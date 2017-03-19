//port 8
#include <stdio.h>
#include <string.h>
#include "lwip/err.h"
#include "lwip/tcp.h"
#if defined (__arm__) || defined (__aarch64__)
#include "xil_printf.h"

#endif

#define EXCESS 0xFF
static unsigned seq_port = 8;
static unsigned seq_port_running = 0;


int transfer_seq() {
	return 0;
}

void print_seq_header()
{
	xil_printf("Attempting to send sequence packets\n");
}

err_t seq_recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{
//	u16_t tcp_sendBuf(struct tcp_pcb* pcb);

	u8_t len;
	u8_t *packet;

	/* do not read the packet if we are not in ESTABLISHED state */
	if (!p) {
		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
		return ERR_OK;
	}

	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->tot_len);
	len = p->tot_len;

	packet = (u8_t*)p->payload;
	u32_t packetSeq;
	for (uint i = 0; i < len; i+=4){

		if(i+4 > len){
			u_int num_Excess = 4 - len%4;
			if (num_Excess == 1){
				packetSeq = (packet[i]<<24)|(packet[i+1]<<16)|(packet[i+2]<<8)|EXCESS;
			}
			else if (num_Excess == 2){
				packetSeq = (packet[i]<<24)|(packet[i+1]<<16)|EXCESS<<8|EXCESS;
			}
			else{
				packetSeq = (packet[i]<<24)|EXCESS<<16|EXCESS<<8|EXCESS;
			}
		}
		else{
			packetSeq = (packet[i]<<24)|(packet[i+1]<<16)|(packet[i+2]<<8)|(packet[i+3]);
		}
		xil_printf("%08x\n", packetSeq);
		//provide assigned memory address for packetSeq
	}
	pbuf_free(p);
	return ERR_OK;
}

err_t seq_accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
	static int connection = 1;

	/* set the receive callback for this connection */
	tcp_recv(newpcb, seq_recv_callback);

	/* just use an integer number indicating the connection id as the
	   callback argument */
	tcp_arg(newpcb, (void*)(UINTPTR)connection);

	/* increment for subsequent accepted connections */
	connection++;

	return ERR_OK;
}


int start_seqSend()
{
	struct tcp_pcb *pcb;
	err_t err;

	/* create new TCP PCB structure */
	pcb = tcp_new();
	if (!pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}

	/* bind to specified @port */
	err = tcp_bind(pcb, IP_ADDR_ANY, seq_port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r",seq_port, err);
		return -2;
	}

	/* we do not need any arguments to callback functions */
	tcp_arg(pcb, NULL);

	/* listen for connections */
	pcb = tcp_listen(pcb);
	if (!pcb) {
		xil_printf("Out of memory while tcp_listen\n\r");
		return -3;
	}
	xil_printf("TCP echo server started @ port %d\n\r", seq_port);
	/* specify callback to use for incoming connections */
	tcp_accept(pcb, seq_accept_callback);

	seq_port_running = 1;
	return 0;
}
