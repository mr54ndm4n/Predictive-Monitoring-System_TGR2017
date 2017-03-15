#include "simple_mb_slave.h"

#include "stm32l0xx_hal.h"
#include <string.h>

//#define __ENABLE_FULL_DEBUG__   // Use to enable dubug in hardware (Recommend)
#ifdef  __ENABLE_FULL_DEBUG__
#include <stdio.h>
#define debug_print(...) printf(__VA_ARGS__)
#else
#define debug_print(...)
#endif


#define STATE_FIND_ADDR     			0
#define STATE_FIND_FXCODE 				1  /// recently added
#define STATE_FIND_DATA_HI    		2
#define STATE_FIND_DATA_LOW     	3
#define STATE_FIND_NUM_OF_REG_HI 	4  /// recently added
#define STATE_FIND_NUM_OF_REG_LOW	5 
#define STATE_CAL_CRC1      			6
#define STATE_CAL_CRC2      			7


#define READ_ANALOG_FXCODE 			4  // Read Analog
#define NUM_OF_REG							1  // Read Analog

static uint8_t* p_rx_buf;
static uint8_t mb_state = STATE_FIND_ADDR;
static uint8_t mb_addr  = 0x01;
static uint8_t mb_count = 0;
static mb_data_cb g_mb_data_cb;
mb_req_packet *p_req;

uint8_t tempForDataHi = 0;
char sendStr2[100] = "";
extern TIM_HandleTypeDef htim2;

extern UART_HandleTypeDef huart2;

extern void modbus_cb(mb_req_packet* p_req);

static uint16_t crc16_update(uint16_t crc, uint8_t a)
{
    int i;
    crc ^= a;
    for (i = 0; i < 8; ++i)
    {
        if (crc & 1)
            crc = (crc >> 1) ^ 0xA001;
        else
            crc = (crc >> 1);
    }
    return crc;
}

void mb_init(uint8_t _mb_addr,
             uint8_t *rx_buffer,
             mb_data_cb mb_cb)
{

    p_rx_buf     = rx_buffer;
    mb_addr      = _mb_addr;
    g_mb_data_cb = mb_cb;
}

void check_timeout(){
	static int t = 0;
	if(mb_state != STATE_FIND_ADDR)
		t++;
	if(t > 1000){
		mb_state = STATE_FIND_ADDR;
	}
	else{
		t = 0;
	}
}


void mb_rx(uint8_t data) {
    static uint16_t crc = 0xFFFF;
    static uint16_t req_crc = 0;

    switch(mb_state) {
        case STATE_FIND_ADDR :
        if(data == mb_addr) {
            crc = 0xFFFF;
            req_crc = 0;         ////// reset value
            mb_count = 0;
            mb_state = STATE_FIND_FXCODE;
            p_rx_buf[0] = data;
						crc = crc16_update(crc, data);       ////// return new crc (Overwirte)
            sprintf(sendStr2,"CRC CAL %d %X LAST DATA(ADDRESS) : %X\n", mb_count, crc, data);
						HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
					
            
        }
        break;
				
				case STATE_FIND_FXCODE :
				
				mb_count = mb_count + 1;
				p_rx_buf[mb_count] = data;
				
				crc = crc16_update(crc, data);       ////// return new crc (Overwirte)
        sprintf(sendStr2,"CRC CAL %d %X LAST DATA(FXCODE) : %X\n", mb_count, crc, data);
				HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
				
				if(data == READ_ANALOG_FXCODE){
					mb_state = STATE_FIND_DATA_HI;
				}
				else{
					/// Reset STATE and Clear Data
				}
					

        case STATE_FIND_DATA_HI :
        mb_count = mb_count + 1;
        tempForDataHi = data;
        crc = crc16_update(crc, data);
        sprintf(sendStr2,"CRC CAL %d %X LAST DATA(DATAHI) : %X\n", mb_count, crc, data);
				HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
        mb_state = STATE_FIND_DATA_LOW ;
        break;
				
				case STATE_FIND_DATA_LOW :
        mb_count = mb_count + 1;
        p_rx_buf[mb_count] = data;
        crc = crc16_update(crc, data);
        sprintf(sendStr2,"CRC CAL %d %X LAST DATA(DATALOW) : %X\n", mb_count, crc, data);
				HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
        mb_state = STATE_FIND_NUM_OF_REG_HI ;
        
        break;
				
				case STATE_FIND_NUM_OF_REG_HI :
				mb_count = mb_count+1;
				if(data == 0){
					mb_state = STATE_FIND_NUM_OF_REG_LOW;
				}
				crc = crc16_update(crc, data);
        sprintf(sendStr2,"CRC CAL %d %X LAST DATA(NUM_OF_REG HI) : %X\n", mb_count, crc, data);
				HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
				break;
				
				case STATE_FIND_NUM_OF_REG_LOW :
				mb_count = mb_count+1;
				if(data == NUM_OF_REG ){
					mb_state = STATE_CAL_CRC1;
				}
				crc = crc16_update(crc, data);
        sprintf(sendStr2,"CRC CAL %d %X LAST DATA(NUM_OF_REG LOW) : %X\n", mb_count, crc, data);
				HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
				break;

        case STATE_CAL_CRC1 :
        req_crc = data;
        mb_state = STATE_CAL_CRC2;
        break;

        case STATE_CAL_CRC2 :
        req_crc |= (data << 8);
        sprintf(sendStr2,"CRC RCV %X\n", req_crc);
				HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
            if(crc == req_crc) {
                p_req = (mb_req_packet *)p_rx_buf;
                sprintf(sendStr2,"CRC CORRECT\n");
								HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
                sprintf(sendStr2,"DATA ADDR %d\n", p_req->addr);
								HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
                sprintf(sendStr2,"DATA POINT HI %d\n", p_req->no_point_hi);
								HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
                sprintf(sendStr2,"DATA POINT LOW %d\n", p_req->no_point_low);
								HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
                g_mb_data_cb(p_req);
            } else {
                sprintf(sendStr2,"CRC INCORRECT\n");
								HAL_UART_Transmit(&huart2, (uint8_t *)sendStr2, strlen(sendStr2), 500);
            }
        mb_state = STATE_FIND_ADDR;
				//modbus_cb();
        default :
        break;
    }
}
