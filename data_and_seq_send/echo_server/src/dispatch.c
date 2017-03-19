#include "lwip/inet.h"
#include "lwip/ip_addr.h"
#include "switch.h"


void print_headers(){
	xil_printf("Port 7 to send in data\n");
	xil_printf("Port 8 to send in sequences\n");

	if(SEND_SEQ)	print_seq_header();
	if(SEND_DATA)	print_data_header();
}

int start_apps(){

	if(SEND_SEQ)	start_seqSend();
	if(SEND_DATA)	start_dataSend();

}

int transfer_packets(){
	if(SEND_SEQ)	transfer_seq();
	if(SEND_DATA)	transfer_data();
}


