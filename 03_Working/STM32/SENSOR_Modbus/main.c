/**
  ******************************************************************************
  * File Name          : main.c
  * Description        : Main program body
  ******************************************************************************
  *
  * COPYRIGHT(c) 2017 STMicroelectronics
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  *   1. Redistributions of source code must retain the above copyright notice,
  *      this list of conditions and the following disclaimer.
  *   2. Redistributions in binary form must reproduce the above copyright notice,
  *      this list of conditions and the following disclaimer in the documentation
  *      and/or other materials provided with the distribution.
  *   3. Neither the name of STMicroelectronics nor the names of its contributors
  *      may be used to endorse or promote products derived from this software
  *      without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "stm32l0xx_hal.h"

/* USER CODE BEGIN Includes */
#include <simple_mb_slave.h>
#include <stdio.h>
#include <string.h>

/* USER CODE END Includes */

/* Private variables ---------------------------------------------------------*/
ADC_HandleTypeDef hadc;

TIM_HandleTypeDef htim2;

UART_HandleTypeDef huart2;

/* USER CODE BEGIN PV */
/* Private variables ---------------------------------------------------------*/

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
void Error_Handler(void);
static void MX_GPIO_Init(void);
static void MX_USART2_UART_Init(void);
static void MX_TIM2_Init(void);
static void MX_ADC_Init(void);

/* USER CODE BEGIN PFP */
/* Private function prototypes -----------------------------------------------*/

/* USER CODE END PFP */

/* USER CODE BEGIN 0 */
uint8_t rx_buffer;
uint8_t tx_data[20] = {0x11, 0x04, 0x02, 0x00, 0x20, 0x79, 0x2B, 0x00};
uint8_t rx_data[20] = "";
char sendStr[100] = "";

uint8_t tempRx ;

static volatile int adcVal = 0; 
volatile uint8_t sendVal = 0; 

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



void modbus_cb(mb_req_packet* p_req) {
//    sprintf(sendStr,"DATA ADDR %d\n", p_req->addr);
//		HAL_UART_Transmit(&huart2, (uint8_t *)sendStr, strlen(sendStr), 500);
//    sprintf(sendStr,"DATA POINT HI %d\n", p_req->no_point_hi);   //// Use Hi only in this workshop
//		HAL_UART_Transmit(&huart2, (uint8_t *)sendStr, strlen(sendStr), 500);
//    sprintf(sendStr,"DATA POINT LOW %d\n", p_req->no_point_low);
//		HAL_UART_Transmit(&huart2, (uint8_t *)sendStr, strlen(sendStr), 500);
	
		uint16_t sendCRC = 0xFFFF;
		int i = 0;
		uint8_t sendCRC_HI = 0;
		uint8_t sendCRC_LOW = 0;
	
		while (HAL_ADC_PollForConversion(&hadc, 200) != HAL_OK) {}
		adcVal  = HAL_ADC_GetValue(&hadc);
		sendVal = 950 - (( (double)adcVal /4095.0 ) * 950 ) ;
	
		
    tx_data[0] = 0x11;    // address
    tx_data[1] = 0x04;		// fxcode
    tx_data[2] = 0x00 ;    ////(sendVal | 0b1111111100000000) ;// data hi // adc send val mask bit 15 - 8
    tx_data[3] =  sendVal ; ////(sendVal | 0b0000000011111111) ;// data low // adc send val mask bit 7 - 0
    tx_data[4] = 0x00;		// num hi 
    tx_data[5] = 0x01;		// num low 
	
		for(i = 0 ; i <= 5 ; i ++){
			 sendCRC = crc16_update(sendCRC , tx_data[i] );
		}
		sendCRC_LOW = (uint8_t) sendCRC ;
		sendCRC_HI = sendCRC >> 8;
		
		tx_data[6] = sendCRC_LOW;		// CRC1   16 bit mask with 0b11111111 11111111 00000000 00000000;
		tx_data[7] = sendCRC_HI;		// CRC2		16 bit
		
		//sprintf(sendStr,"DATA POINT LOW %d\n", p_req->no_point_low);
		HAL_UART_Transmit(&huart2, (uint8_t *)&tx_data[0], 1 , 100);    // address
		HAL_UART_Transmit(&huart2, (uint8_t *)&tx_data[1], 1 , 100);		// fxcode
		HAL_UART_Transmit(&huart2, (uint8_t *)&tx_data[2], 1 , 100)	;	  // data hi
		HAL_UART_Transmit(&huart2, (uint8_t *)&tx_data[3], 1 , 100);		// data low
		HAL_UART_Transmit(&huart2, (uint8_t *)&tx_data[4], 1 , 100);		// num hi
		HAL_UART_Transmit(&huart2, (uint8_t *)&tx_data[5], 1 , 100);		// num low
		HAL_UART_Transmit(&huart2, (uint8_t *)&tx_data[6], 1 , 100);		// CRC 1
		HAL_UART_Transmit(&huart2, (uint8_t *)&tx_data[7], 1 , 100);		// CRC 2
}
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	int i =0 ;

	for(i=0 ;i >= 7; i++){
					HAL_UART_Receive(&huart2, &rx_buffer, 1, 200);
					mb_rx(rx_buffer);
	}
		
	sprintf(sendStr," after Interrupt\n");
	HAL_UART_Transmit(&huart2, (uint8_t *)sendStr, strlen(sendStr), 500);
	HAL_UART_Receive_IT(huart, (uint8_t*) &tempRx, 1);
}

/* USER CODE END 0 */

int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration----------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* Configure the system clock */
  SystemClock_Config();

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_USART2_UART_Init();
  MX_TIM2_Init();
  MX_ADC_Init();

  /* USER CODE BEGIN 2 */
	HAL_ADC_Start(&hadc);
	 mb_init(0x11, rx_data, modbus_cb); //// (Device Address , pointer to DATA ,
										//	Fx callback pointer extract to address stucture)

    // 11 03 00 6B 00 03 7687
    mb_rx(0x11);  /// Address
    mb_rx(0x04);	/// 0x03 /// Fx code
    mb_rx(0xFA);	// DATA HI
    mb_rx(0x6B);	// DATA LOW
    mb_rx(0x00);  // NUM HI
    mb_rx(0x01);  // NUM Low
    mb_rx(0x76);	// CRC 
    mb_rx(0x87);  // CRC IS 0x8776 converted to 7687


    mb_rx(0x11);
    mb_rx(0x03);
    mb_rx(0x00);
    mb_rx(0x6B);
    mb_rx(0x00);
    mb_rx(0x03);
    mb_rx(0x76);
    mb_rx(0x87);	


  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {	
		
			//sprintf(sendStr,"before while\n");
			//HAL_UART_Transmit(&huart2, (uint8_t *)sendStr, strlen(sendStr), 500);
  /* USER CODE END WHILE */

  /* USER CODE BEGIN 3 */

  }
  /* USER CODE END 3 */

}

/** System Clock Configuration
*/
void SystemClock_Config(void)
{

  RCC_OscInitTypeDef RCC_OscInitStruct;
  RCC_ClkInitTypeDef RCC_ClkInitStruct;
  RCC_PeriphCLKInitTypeDef PeriphClkInit;

    /**Configure the main internal regulator output voltage 
    */
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

    /**Initializes the CPU, AHB and APB busses clocks 
    */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = 16;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLLMUL_4;
  RCC_OscInitStruct.PLL.PLLDIV = RCC_PLLDIV_2;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

    /**Initializes the CPU, AHB and APB busses clocks 
    */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_1) != HAL_OK)
  {
    Error_Handler();
  }

  PeriphClkInit.PeriphClockSelection = RCC_PERIPHCLK_USART2;
  PeriphClkInit.Usart2ClockSelection = RCC_USART2CLKSOURCE_PCLK1;
  if (HAL_RCCEx_PeriphCLKConfig(&PeriphClkInit) != HAL_OK)
  {
    Error_Handler();
  }

    /**Configure the Systick interrupt time 
    */
  HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/1000);

    /**Configure the Systick 
    */
  HAL_SYSTICK_CLKSourceConfig(SYSTICK_CLKSOURCE_HCLK);

  /* SysTick_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(SysTick_IRQn, 0, 0);
}

/* ADC init function */
static void MX_ADC_Init(void)
{

  ADC_ChannelConfTypeDef sConfig;

    /**Configure the global features of the ADC (Clock, Resolution, Data Alignment and number of conversion) 
    */
  hadc.Instance = ADC1;
  hadc.Init.OversamplingMode = DISABLE;
  hadc.Init.ClockPrescaler = ADC_CLOCK_SYNC_PCLK_DIV2;
  hadc.Init.Resolution = ADC_RESOLUTION_12B;
  hadc.Init.SamplingTime = ADC_SAMPLETIME_19CYCLES_5;
  hadc.Init.ScanConvMode = ADC_SCAN_DIRECTION_FORWARD;
  hadc.Init.DataAlign = ADC_DATAALIGN_RIGHT;
  hadc.Init.ContinuousConvMode = ENABLE;
  hadc.Init.DiscontinuousConvMode = DISABLE;
  hadc.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_NONE;
  hadc.Init.ExternalTrigConv = ADC_SOFTWARE_START;
  hadc.Init.DMAContinuousRequests = ENABLE;
  hadc.Init.EOCSelection = ADC_EOC_SINGLE_CONV;
  hadc.Init.Overrun = ADC_OVR_DATA_PRESERVED;
  hadc.Init.LowPowerAutoWait = DISABLE;
  hadc.Init.LowPowerFrequencyMode = DISABLE;
  hadc.Init.LowPowerAutoPowerOff = DISABLE;
  if (HAL_ADC_Init(&hadc) != HAL_OK)
  {
    Error_Handler();
  }

    /**Configure for the selected ADC regular channel to be converted. 
    */
  sConfig.Channel = ADC_CHANNEL_0;
  sConfig.Rank = ADC_RANK_CHANNEL_NUMBER;
  if (HAL_ADC_ConfigChannel(&hadc, &sConfig) != HAL_OK)
  {
    Error_Handler();
  }

}

/* TIM2 init function */
static void MX_TIM2_Init(void)
{

  TIM_ClockConfigTypeDef sClockSourceConfig;
  TIM_MasterConfigTypeDef sMasterConfig;

  htim2.Instance = TIM2;
  htim2.Init.Prescaler = 32-1;
  htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim2.Init.Period = 1000-1;
  htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  if (HAL_TIM_Base_Init(&htim2) != HAL_OK)
  {
    Error_Handler();
  }

  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim2, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }

  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }

}

/* USART2 init function */
static void MX_USART2_UART_Init(void)
{

  huart2.Instance = USART2;
  huart2.Init.BaudRate = 115200;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  huart2.Init.OneBitSampling = UART_ONE_BIT_SAMPLE_DISABLE;
  huart2.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;
  if (HAL_UART_Init(&huart2) != HAL_OK)
  {
    Error_Handler();
  }

}

/** Pinout Configuration
*/
static void MX_GPIO_Init(void)
{

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOA_CLK_ENABLE();

}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @param  None
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler */
  /* User can add his own implementation to report the HAL error return state */
  while(1) 
  {
  }
  /* USER CODE END Error_Handler */ 
}

#ifdef USE_FULL_ASSERT

/**
   * @brief Reports the name of the source file and the source line number
   * where the assert_param error has occurred.
   * @param file: pointer to the source file name
   * @param line: assert_param error line source number
   * @retval None
   */
void assert_failed(uint8_t* file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
    ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */

}

#endif

/**
  * @}
  */ 

/**
  * @}
*/ 

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
