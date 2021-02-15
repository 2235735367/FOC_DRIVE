#include "led.h"
#include "delay.h"
#include "sys.h"
#include "usart.h"
#include "lcd.h"
#include "key.h"  
#include "24cxx.h" 
#include "myiic.h"
#include "AS5600.h"

//ALIENTEK Mini STM32开发板范例代码19
//IIC实验  
//技术支持：www.openedv.com
//广州市星翼电子科技有限公司
   	
//要写入到24c02的字符串数组
const u8 TEXT_Buffer[]={"MiniSTM32 IIC TEST"};
#define SIZE sizeof(TEXT_Buffer)	
 int main(void)
 { 
	double test=0;
	u8 key;
	u16 i=0;
	u8 datatemp[SIZE];
	AS5600_Init();
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);// 设置中断优先级分组2
	delay_init();	    	 //延时函数初始化	  
	uart_init(9600);	 	//串口初始化为9600
	while(1)
	{
		test = Get_Angle();
	 printf("test= %lf\r\n",test);
	}
	
}
