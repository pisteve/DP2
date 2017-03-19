
#include <stdio.h>

#include "xparameters.h"

#include "netif/xadapter.h"

#include "platform.h"
#include "platform_config.h"
#if defined(__aarch64__)
#include "xil_printf.h"
#endif

#include "lwip/tcp.h"
#include "xil_cache.h"

#if LWIP_DHCP==1
#include "lwip/dhcp.h"
#endif

/* defined by each RAW mode application */
void print_headers();
int start_apps();
int transfer_packets();
void tcp_fasttmr(void);
void tcp_slowtmr(void);

/* missing declaration in lwIP */
void lwip_init();

#if LWIP_DHCP==1
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
#endif

extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;
static struct netif server_netif;
struct netif *netif;

void
print_ip(char *msg, struct ip_addr *ip) 
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip), 
			ip4_addr3(ip), ip4_addr4(ip));
}

void
print_ip_settings(struct ip_addr *ip, struct ip_addr *mask, struct ip_addr *gw)
{

	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}


int main()
{
	struct ip_addr ipaddr, netmask, gw;

	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

	netif = &server_netif;

	init_platform();

#if LWIP_DHCP==1
    ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
#else
	/* initialize IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   1, 199);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);
#endif	


	print_seq_header();

	lwip_init();


  	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(netif, &ipaddr, &netmask,
						&gw, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}
	netif_set_default(netif);

	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
	netif_set_up(netif);

#if (LWIP_DHCP==1)
	/* Create a new DHCP client for this interface.
	 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
	 * the predefined regular intervals after starting the client.
	 */
	dhcp_start(netif);
	dhcp_timoutcntr = 24;

	while(((netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(packet_netif);

	if (dhcp_timoutcntr <= 0) {
		if ((netif->ip_addr.addr) == 0) {
			xil_printf("DHCP Timeout\r\n");
			xil_printf("Configuring default IP of 192.168.1.10\r\n");
			IP4_ADDR(&(netif->ip_addr),  192, 168,   1, 10);
			IP4_ADDR(&(netif->netmask), 255, 255, 255,  0);
			IP4_ADDR(&(netif->gw),      192, 168,   1,  1);
		}
	}

	ipaddr.addr = netif->ip_addr.addr;
	gw.addr = netif->gw.addr;
	netmask.addr = netif->netmask.addr;
#endif

	print_ip_settings(&ipaddr, &netmask, &gw);


	start_apps();


	while (1) {
	    xemacif_input(netif);
	    transfer_packets();
	}
  
	/* never reached */
	cleanup_platform();

	return 0;
}
