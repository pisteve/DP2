#include <stdio.h>
#include <string.h>
#include "lwip/err.h"
#include "lwip/tcp.h"
#if defined (__arm__) || defined (__aarch64__)
#include "xil_printf.h"

#endif



static unsigned data_port = 7;
static unsigned data_port_running = 0;

int transfer_data() {
	return 0;
}

void print_data_header()
{
	xil_printf("Attempting to read raw packets\n");
}

err_t data_recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{
	u_int len;
	u8_t *packet;

	/* do not read the packet if we are not in ESTABLISHED state */
	if (!p) {
		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
		return ERR_OK;
	}

	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);
	len = p->tot_len;

	packet = (u8_t*)p->payload;
	for (uint i = 0; i < len; i++){
		packet[len] = 0xFF;
		xil_printf("%x\n", packet[i]);
	}
	xil_printf("%08x\n", packet[len]);
	pbuf_free(p);

	return ERR_OK;
}

err_t data_accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
	static int connection = 1;

	/* set the receive callback for this connection */
	tcp_recv(newpcb, data_recv_callback);

	/* just use an integer number indicating the connection id as the
	   callback argument */
	tcp_arg(newpcb, (void*)(UINTPTR)connection);

	/* increment for subsequent accepted connections */
	connection++;

	return ERR_OK;
}


int start_dataSend()
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
	err = tcp_bind(pcb, IP_ADDR_ANY, data_port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", data_port, err);
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

	/* specify callback to use for incoming connections */
	tcp_accept(pcb, data_accept_callback);

	xil_printf("TCP echo server started @ port %d\n\r", data_port);
	data_port_running = 1;
	return 0;
}
