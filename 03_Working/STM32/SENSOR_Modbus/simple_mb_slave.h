#ifndef SIMPLE_MB_SLAVE_H
#define SIMPLE_MB_SLAVE_H

#include <stdint.h>

typedef struct {
    uint8_t addr;
    uint8_t func_code;
    uint8_t start_addr_hi;
    uint8_t start_addr_low;
    uint8_t no_point_hi;
    uint8_t no_point_low;
}mb_req_packet;

typedef void(*mb_data_cb)(mb_req_packet* p);

void mb_init(uint8_t _mb_addr, uint8_t *rx_buffer, mb_data_cb mb_cb);
void mb_rx(uint8_t data);

#endif /*SIMPLE_MB_SLAVE_H*/
