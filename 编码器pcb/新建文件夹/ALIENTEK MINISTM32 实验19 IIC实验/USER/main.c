#include "led.h"
#include "delay.h"
#include "sys.h"
#include "usart.h"
#include "lcd.h"
#include "key.h"  
#include "24cxx.h" 
#include "myiic.h"
#include "AS5600.h"

//ALIENTEK Mini STM32�����巶������19
//IICʵ��  
//����֧�֣�www.openedv.com
//������������ӿƼ����޹�˾
   	
//Ҫд�뵽24c02���ַ�������
const u8 TEXT_Buffer[]={"MiniSTM32 IIC TEST"};
#define SIZE sizeof(TEXT_Buffer)	
 int main(void)
 { 
	double test=0;
	u8 key;
	u16 i=0;
	u8 datatemp[SIZE];
	AS5600_Init();
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);// �����ж����ȼ�����2
	delay_init();	    	 //��ʱ������ʼ��	  
	uart_init(9600);	 	//���ڳ�ʼ��Ϊ9600
	while(1)
	{
		test = Get_Angle();
	 printf("test= %lf\r\n",test);
	}
	
}
