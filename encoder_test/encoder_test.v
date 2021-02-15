module   encoder_test  #
(
	parameter	signed ENCO_NUM = 32'd4000	//编码器4倍频后一圈4000个脉冲			
)
(	
	input	wire				clk		,//时钟信号		
	input	wire				rst_n	,//复位信号
    
	input	wire				Enco_A  ,//编码器A信号
    input	wire				Enco_B	,//编码器B信号
    input	wire				Enco_Z	,//编码器Z信号
    output  wire                encoder ,
    
    output	reg	signed 	[15:0]		motor_cnt,		
	output	reg	signed	[15:0]		motor_cir,	
    output	reg		[1:0]		    motor_dir	//转向
);

/*定义两个寄存器，将编码器信号延后1拍、2拍.对信号的上升沿、下降沿进行判断*/
	reg					Enco_A_r1;
	reg					Enco_A_r2;
	reg					Enco_A_r3;   
    wire				Enco_A_pos;   //上升沿
	wire				Enco_A_neg;   //下降沿
    wire                enco_A_2edag; //双沿
		
	always @ (posedge clk  or  negedge rst_n) begin
		if(!rst_n) begin
			Enco_A_r1 <= 1'b0;
			Enco_A_r2 <= 1'b0;
			Enco_A_r3 <= 1'b0;
		end
		else begin
			Enco_A_r1 <= Enco_A;
			Enco_A_r2 <= Enco_A_r1;
			Enco_A_r3 <= Enco_A_r2;
		end
	end
    
	assign Enco_A_pos = Enco_A_r2 &(~Enco_A_r3); //上升沿
    assign Enco_A_neg = (~Enco_A_r2)&Enco_A_r3;  //下降沿
    assign enco_A_2edag = Enco_A_r2^Enco_A_r3;   //双沿
    
    /*定义两个寄存器，将编码器信号延后1拍、2拍.对信号的上升沿、下降沿进行判断*/
	reg					Enco_B_r1;
	reg					Enco_B_r2;
	reg					Enco_B_r3;   
    wire				Enco_B_pos;   //上升沿
	wire				Enco_B_neg;   //下降沿
    wire                enco_B_2edag; //双沿
		
	always @ (posedge clk  or  negedge rst_n) begin
		if(!rst_n) begin
			Enco_B_r1 <= 1'b0;
			Enco_B_r2 <= 1'b0;
			Enco_B_r3 <= 1'b0;
		end
		else begin
			Enco_B_r1 <= Enco_B;
			Enco_B_r2 <= Enco_B_r1;
			Enco_B_r3 <= Enco_B_r2;
		end
	end
    
	assign Enco_B_pos = Enco_B_r2 &(~Enco_B_r3); //上升沿
    assign Enco_B_neg = (~Enco_B_r2)&Enco_B_r3;  //下降沿
    assign enco_B_2edag = Enco_B_r2^Enco_B_r3;   //双沿
    
    assign encoder      = enco_A_2edag^enco_B_2edag;//编码器4倍频
    
/*定义两个寄存器，将编码器信号延后1拍、2拍.对信号的上升沿进行判断*/
	reg					Enco_Z_r1;
	reg					Enco_Z_r2;
	reg					Enco_Z_r3;   
    wire				Enco_Z_pos;//上升沿
		
	always @ (posedge clk  or  negedge rst_n) begin
		if(!rst_n) begin
			Enco_Z_r1 <= 1'b0;
			Enco_Z_r2 <= 1'b0;
			Enco_Z_r3 <= 1'b0;
		end
		else begin
			Enco_Z_r1 <= Enco_Z;
			Enco_Z_r2 <= Enco_Z_r1;
			Enco_Z_r3 <= Enco_Z_r2;
		end
	end
    
	assign Enco_Z_pos = Enco_Z_r2 &(~Enco_B_r3); //上升沿
    
    /*通过对上升沿和A、B两相高低电平来判断电机旋转方向*/
    always @ (posedge clk  or  negedge rst_n) begin
        if(!rst_n) begin
 		motor_dir <= 2'b00;   
        end
        else begin
             if((Enco_A_pos&&Enco_A&&!Enco_B)||(Enco_A_neg&&!Enco_A&&Enco_B)||(Enco_B_pos&&Enco_A&&Enco_B)||(Enco_B_neg&&!Enco_A&&!Enco_B))begin
                motor_dir <= 2'b01;				//A相超前B相
             end
             else if((Enco_A_pos&&Enco_A&&Enco_B)||(Enco_A_neg&&!Enco_A&&!Enco_B)||(Enco_B_pos&&!Enco_A&&Enco_B)||(Enco_B_neg&&Enco_A&&!Enco_B))begin
                motor_dir <= 2'b10;				//B相超前A相
             end
             else begin
                motor_dir <= motor_dir;
             end
		end
    end
    
 /*对4倍频后的脉冲数进行计数*/
    reg signed [15:0]  motor_cnt_temp;
    
	always @ (posedge clk  or  negedge rst_n) begin
		if(!rst_n) begin
			motor_cnt_temp <= 16'd0;
            motor_cnt      <= 16'd0;
		end
		else begin
            if(encoder == 1'b1)begin
            	if( motor_cnt <= -(ENCO_NUM-1) | motor_cnt >= (ENCO_NUM-1)) begin
					motor_cnt <= 16'd0;
				end
                else if(motor_dir == 2'b01)begin
					motor_cnt_temp <= motor_cnt_temp - 1'd1;
                    motor_cnt      <= motor_cnt_temp;
				end
				else if(motor_dir == 2'b10)begin
					motor_cnt_temp <= motor_cnt_temp + 1'd1;
                    motor_cnt      <= motor_cnt_temp;
				end
            end
		end
	end    


    
    

endmodule
	
	
	