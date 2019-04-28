module keycheck(
			clk,rst_n,
			key,led
				);
input clk;
input rst_n;
input key;
output reg led;

reg[3:0] keyr;

always@(posedge clk or negedge rst_n)
	if(!rst_n)keyr <= 4'b1111;
	else keyr <= {keyr[2:0],key};
wire key_pos = keyr[2]&~keyr[3];
wire key_neg = ~keyr[2]&keyr[3];

reg[19:0] cnt;

always@(posedge clk or negedge rst_n)
	if(!rst_n)cnt <= 20'd0;
	else if(key_pos || key_neg) cnt<=20'd0;
	else if(cnt < 20'd999_999) cnt <=cnt+1'b1;
	else cnt <= 20'd0;
	
reg[1:0] key_value;
always@(posedge clk or negedge rst_n)
	if(!rst_n)key_value[0] <= 1'b1;
	else if(cnt == 20'd999_999) key_value[0] <= keyr[3];

always@(posedge clk or negedge rst_n)
	if(!rst_n)key_value[1] <= 1'b1;
	else key_value[1] <= key_value[0];
	
wire led_ctrl = ~key_value[0] & key_value[1];

always@(posedge clk or negedge rst_n)
	if(!rst_n) led <= 1'b0;
	else if(led_ctrl) led <= ~led;

endmodule


