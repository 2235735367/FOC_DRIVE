#include "AS5600.h"
#include "delay.h"
# include "sys.h"

void AS5600_Init(void)
{
	IIC_Init();
}

u16 AS5600_Read_Len(u8 addr,u8 reg,u8 len,u8 *buf)
{
	//SDA_IN();
	
	IIC_Start();
	
	IIC_Send_Byte((addr << 1) | Write_Bit);
	
	if (IIC_Wait_Ack())
	{
		IIC_Stop();
		
		return 1;
	}
	
	IIC_Send_Byte(reg);
	
	IIC_Wait_Ack();
	
	IIC_Start();
	
	IIC_Send_Byte((addr<<1) | Read_Bit);//??????+???
	
	IIC_Wait_Ack();		//???? 
	
	while(len)
	{
		if(len==1)*buf=IIC_Read_Byte(0);//???,??nACK 
		else *buf=IIC_Read_Byte(1);		//???,??ACK  
		len--;
		buf++; 
	}    
	
	IIC_Stop();	//???????? 
	
	return 0;	
		
}

float Get_Angle(void)
{
	u8 buf[2] = {0};
	u8 i = 0;
	
	float temp = 0;
	float temp1 = 0.0;
	
	for (i = 0; i < 20; i++)
	{
		AS5600_Read_Len(Slave_Addr,Angle_Hight_Register_Addr,2,buf);
		
		temp1 +=buf[0]*256+buf[1];
		
		delay_ms(5);
		//temp = (((u16)buf[0] & (0x0f00)) << 8) | buf[1];
	}
	
	//????,???????
	temp = temp1/20;
	
	return temp/4096*360;
	
}







