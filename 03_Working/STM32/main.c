/**
  ******************************************************************************
  * File Name          : main.c
  * Description        : Main program body
  ******************************************************************************
  *
  * Copyright (c) 2017 STMicroelectronics International N.V. 
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without 
  * modification, are permitted, provided that the following conditions are met:
  *
  * 1. Redistribution of source code must retain the above copyright notice, 
  *    this list of conditions and the following disclaimer.
  * 2. Redistributions in binary form must reproduce the above copyright notice,
  *    this list of conditions and the following disclaimer in the documentation
  *    and/or other materials provided with the distribution.
  * 3. Neither the name of STMicroelectronics nor the names of other 
  *    contributors to this software may be used to endorse or promote products 
  *    derived from this software without specific written permission.
  * 4. This software, including modifications and/or derivative works of this 
  *    software, must execute solely and exclusively on microcontroller or
  *    microprocessor devices manufactured by or for STMicroelectronics.
  * 5. Redistribution and use of this software other than as permitted under 
  *    this license is void and will automatically terminate your rights under 
  *    this license. 
  *
  * THIS SOFTWARE IS PROVIDED BY STMICROELECTRONICS AND CONTRIBUTORS "AS IS" 
  * AND ANY EXPRESS, IMPLIED OR STATUTORY WARRANTIES, INCLUDING, BUT NOT 
  * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
  * PARTICULAR PURPOSE AND NON-INFRINGEMENT OF THIRD PARTY INTELLECTUAL PROPERTY
  * RIGHTS ARE DISCLAIMED TO THE FULLEST EXTENT PERMITTED BY LAW. IN NO EVENT 
  * SHALL STMICROELECTRONICS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
  * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
  * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
  * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "stm32l0xx_hal.h"
#include "cmsis_os.h"

/* USER CODE BEGIN Includes */
#include <stdio.h>  // sprintf 
#include <string.h> // strlen
/* USER CODE END Includes */

/* Private variables ---------------------------------------------------------*/
ADC_HandleTypeDef hadc;
DMA_HandleTypeDef hdma_adc;

UART_HandleTypeDef huart2;

osThreadId Task01Handle;
osThreadId Task02Handle;
//osMessageQId Queue01Handle;
osMailQId Queue01Handle;

/* USER CODE BEGIN PV */
/* Private variables ---------------------------------------------------------*/

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
void Error_Handler(void);
static void MX_GPIO_Init(void);
static void MX_DMA_Init(void);
static void MX_ADC_Init(void);
static void MX_USART2_UART_Init(void);
void StartDefaultTask(void const * argument);
void StartTask02(void const * argument);

/* USER CODE BEGIN PFP */
/* Private function prototypes -----------------------------------------------*/

/* USER CODE END PFP */

/* USER CODE BEGIN 0 */
#define Signal_A 0x0001

char initString[256];
uint32_t ConvertedData[2]; //Buffer for the converted data 
uint32_t PBvolt; //for ADC_IN0 in mV 
uint32_t POTvolt; //for ADC_IN1 in mV. Will be later used in the second part of this exercise 

static volatile uint16_t adcVal = 0;
static volatile uint16_t newAdcVal = 0;

// uint32_t Signal_A = 0x0001;

typedef struct {
	uint8_t  START_TEXT ;
	uint8_t  NUMBER_DATA; 
	uint16_t ADC_DATA ;
	uint16_t HUMIDITY;
	uint8_t  END_TEXT;
} DATA_PACKAGE;

typedef struct {
	uint8_t  START_TEXT ;
	uint8_t  NUMBER_DATA; 
	uint16_t ADC_DATA ;
	uint16_t HUMIDITY;
	uint8_t  END_TEXT;
} DATA2_PACKAGE;

//properties_t *data = osMailAlloc(Queue01Handle ,osWaitForever);
 
/* USER CODE END 0 */

int main(void)
{

  /* USER CODE BEGIN 1 */
	//////////////////////////////////////////////////////////////////////
//	sprintf(initString, "Hello TESA TOPGUN RALLY 2017\n");
//	while(__HAL_UART_GET_FLAG(&huart2, UART_FLAG_TC)==RESET){}
//	HAL_UART_Transmit(&huart2, (uint8_t *) initString, strlen(initString), 2000);  // Send Greeting

  /* USER CODE END 1 */

  /* MCU Configuration----------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* Configure the system clock */
  SystemClock_Config();

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_ADC_Init();
  MX_USART2_UART_Init();

  /* USER CODE BEGIN 2 */
	/* (Browse through stm32l0xx_hal_adc_ex.c file for the correct function to use) */
	if (HAL_ADCEx_Calibration_Start(&hadc, ADC_SINGLE_ENDED) != HAL_OK)
	{
	    Error_Handler();
	}

	/* Start ADC conversion with DMA */
	/* (Browse through stm32l0xx_hal_adc.c file for the correct function to use) */
	/* Indicate the ADC handler (hadc), the destination Buffer address (ConvertedData),
	   and the length or number of data to be transferred from ADC peripheral to memory (????) */
	if (HAL_ADC_Start_DMA(&hadc, ConvertedData, 1) != HAL_OK)
	{
	   Error_Handler();
	}

	/* Turn on LD2 */
	HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_SET );

  /* USER CODE END 2 */

  /* USER CODE BEGIN RTOS_MUTEX */
  /* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* USER CODE BEGIN RTOS_SEMAPHORES */
  /* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* USER CODE BEGIN RTOS_TIMERS */
  /* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* Create the thread(s) */
  /* definition and creation of Task01 */
  osThreadDef(Task01, StartDefaultTask, osPriorityNormal, 0, 128);
  Task01Handle = osThreadCreate(osThread(Task01), NULL);

  /* definition and creation of Task02 */
  osThreadDef(Task02, StartTask02, osPriorityIdle, 0, 128);
  Task02Handle = osThreadCreate(osThread(Task02), NULL);

  /* USER CODE BEGIN RTOS_THREADS */
  /* add threads, ... */
  /* USER CODE END RTOS_THREADS */

  /* Create the queue(s) */
  /* definition and creation of Queue01 */
	osMailQDef(Queue01, 5,  DATA_PACKAGE); //////////////// ????
	Queue01Handle = osMailCreate(osMailQ(Queue01), NULL);
	
  //osMessageQDef(Queue01, 16, uint16_t);
  //Queue01Handle = osMessageCreate(osMessageQ(Queue01), NULL);

  /* USER CODE BEGIN RTOS_QUEUES */
  /* add queues, ... */
  /* USER CODE END RTOS_QUEUES */
 

  /* Start scheduler */
  osKernelStart();
  
  /* We should never get here as control is now taken by the scheduler */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
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
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI|RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = 16;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLLMUL_8;
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
  HAL_NVIC_SetPriority(SysTick_IRQn, 3, 0);
}

/* ADC init function */
static void MX_ADC_Init(void)
{

  ADC_ChannelConfTypeDef sConfig;

    /**Configure the global features of the ADC (Clock, Resolution, Data Alignment and number of conversion) 
    */
  hadc.Instance = ADC1;
  hadc.Init.OversamplingMode = DISABLE;
  hadc.Init.ClockPrescaler = ADC_CLOCK_ASYNC_DIV1;
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

/** 
  * Enable DMA controller clock
  */
static void MX_DMA_Init(void) 
{
  /* DMA controller clock enable */
  __HAL_RCC_DMA1_CLK_ENABLE();

  /* DMA interrupt init */
  /* DMA1_Channel1_IRQn interrupt configuration */
//  HAL_NVIC_SetPriority(DMA1_Channel1_IRQn, 3, 0);
//  HAL_NVIC_EnableIRQ(DMA1_Channel1_IRQn);

}

/** Configure pins as 
        * Analog 
        * Input 
        * Output
        * EVENT_OUT
        * EXTI
*/
static void MX_GPIO_Init(void)
{

  GPIO_InitTypeDef GPIO_InitStruct;

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(LD2_GPIO_Port, LD2_Pin, GPIO_PIN_SET);

  /*Configure GPIO pin : LD2_Pin */
  GPIO_InitStruct.Pin = LD2_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(LD2_GPIO_Port, &GPIO_InitStruct);

}

/* USER CODE BEGIN 4 */

/////////////////////////////////////////////////////////////
void LED_Toggle(void){
	for(;;){
		HAL_GPIO_TogglePin(GPIOA,GPIO_PIN_5);
		osDelay(250);
	}
}

/* USER CODE END 4 */

/* StartDefaultTask function */
void StartDefaultTask(void const * argument)
{

  /* USER CODE BEGIN 5 */
	
	/////////////////////////////////////////////////////////////
	sprintf(initString, "Hello TESA TOPGUN RALLY 2017\n");
	while(__HAL_UART_GET_FLAG(&huart2, UART_FLAG_TC)==RESET){}
	HAL_UART_Transmit(&huart2, (uint8_t *) &initString, strlen(initString), 500);  // Send Greeting

//	osSignalSet(StartTask02, Signal_A);  // send signal

//	osEvent mail_event = osMailGet(Queue01Handle, 0);
//	DATA2_PACKAGE *data = (DATA2_PACKAGE *)mail_event.value.p;
//	osMailFree(Queue01Handle,data);
		/* Infinite loop */
  for(;;)
  {
		/////////////////////////////////////////////////////////////
//		sprintf(initString, "Hello TESA TOPGUN RALLY 2017\n");
//		while(__HAL_UART_GET_FLAG(&huart2, UART_FLAG_TC)==RESET){}
//		HAL_UART_Transmit(&huart2, (uint8_t *) &initString, strlen(initString), 500);  // Send Greeting

		osSignalSet(Task02Handle, Signal_A);  // send signal

		osEvent mail_event = osMailGet(Queue01Handle, 0);
		DATA2_PACKAGE *data = (DATA2_PACKAGE *)mail_event.value.p;
		osMailFree(Queue01Handle,data);
				
    osDelay(1);
  }
  /* USER CODE END 5 */ 
}

/* StartTask02 function */

void StartTask02(void const * argument)
{
  /* USER CODE BEGIN StartTask02 */
	
	/////////////////////////////////////////////////////////////
//	osSignalWait(Signal_A, osWaitForever); /////
//	
//	while (HAL_ADC_PollForConversion(&hadc, 200) != HAL_OK) {}
//	adcVal  = HAL_ADC_GetValue(&hadc);
//		
//	newAdcVal = adcVal * 2 ;
//		//Calculation
//	
//	DATA_PACKAGE *data = osMailAlloc(Queue01Handle ,osWaitForever) ;  // Pack DATA
//	data->START_TEXT = 0x02;
//	data->NUMBER_DATA = 0x04;
//	data->ADC_DATA = adcVal;
//	data->HUMIDITY = newAdcVal ;
//	data->END_TEXT = 0x03;
//	
//	osMailPut(Queue01Handle,data);  // Send to MailQueue
		
	//LED_Toggle();
  
  /* Infinite loop */ 	
  for(;;)
  {
		/////////////////////////////////////////////////////////////
//		osSignalWait(Signal_A , osWaitForever);
		
		while (HAL_ADC_PollForConversion(&hadc, 200) != HAL_OK) {}
		adcVal  = HAL_ADC_GetValue(&hadc);
//			
//		newAdcVal = adcVal * 2 ;
//			//Calculation
//		
//		DATA_PACKAGE *data = osMailAlloc(Queue01Handle ,osWaitForever) ;  // Pack DATA
//		data->START_TEXT = 0x02;
//		data->NUMBER_DATA = 0x04;
//		data->ADC_DATA = adcVal;
//		data->HUMIDITY = newAdcVal ;
//		data->END_TEXT = 0x03;
//		
//		osMailPut(Queue01Handle, data);  // Send to MailQueue
			
		LED_Toggle();
		osDelay(1);
			
//    osDelay(1);
  }
  /* USER CODE END StartTask02 */
}

/**
  * @brief  Period elapsed callback in non blocking mode
  * @note   This function is called  when TIM6 interrupt took place, inside
  * HAL_TIM_IRQHandler(). It makes a direct call to HAL_IncTick() to increment
  * a global variable "uwTick" used as application time base.
  * @param  htim : TIM handle
  * @retval None
  */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
/* USER CODE BEGIN Callback 0 */

/* USER CODE END Callback 0 */
  if (htim->Instance == TIM6) {
    HAL_IncTick();
  }
/* USER CODE BEGIN Callback 1 */

/* USER CODE END Callback 1 */
}

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
