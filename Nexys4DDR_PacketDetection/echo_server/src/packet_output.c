#include <stdio.h>
#include <string.h>

#include "lwip/err.h"
#include "lwip/tcp.h"
#if defined (__arm__) || defined (__aarch64__)
#include "xil_printf.h"
#endif

int transfer_data() {
	return 0;
}

void print_app_header()
{
	xil_printf("Attempting to read raw packets\n");
}

err_t recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{

	u16_t* temp;

	u16_t tcp_sendBuf(struct tcp_pcb* pcb);

	struct pbuf* prev;
	/* do not read the packet if we are not in ESTABLISHED state */
	if (!p) {
		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
		return ERR_OK;
	}

	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);


	// store payload in 32 bit unsigned pointer
	temp = (u16_t*)p->payload;

	u16_t count = 0;

//	/* Print payload */
//	while(p != NULL){
	if(p->len != 0 || *(temp) != 0){
		xil_printf("\n---------------");
		xil_printf("\n");
		for(int i=0; i<(p->tot_len);i+=2){
			if(*(temp) == 97){
				err = tcp_write(tpcb, "b", 1, 1);
			}
			else if(*(temp) == 65){
				err = tcp_write(tpcb, "B", 1, 1);
			}
			if((*temp) != 2573){
				xil_printf("%x", *(temp++));
				count++;
			}
		}
	}
	prev = p;
	pbuf_free(prev);
	p = p->next;


	return ERR_OK;
}

err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
	static int connection = 1;

	/* set the receive callback for this connection */
	tcp_recv(newpcb, recv_callback);

	/* just use an integer number indicating the connection id as the
	   callback argument */
	tcp_arg(newpcb, (void*)(UINTPTR)connection);

	/* increment for subsequent accepted connections */
	connection++;

	return ERR_OK;
}


int start_application()
{
	struct tcp_pcb *pcb;
	err_t err;
	unsigned port = 7;

	/* create new TCP PCB structure */
	pcb = tcp_new();
	if (!pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}

	/* bind to specified @port */
	err = tcp_bind(pcb, IP_ADDR_ANY, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
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
	tcp_accept(pcb, accept_callback);

	xil_printf("TCP echo server started @ port %d\n\r", port);

	return 0;
}
