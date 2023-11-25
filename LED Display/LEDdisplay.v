module LEDdisplay(input clk, input resetn,input enable,
	input [3:0] oX,input [3:0] oY,input [3:0] oZ,input [3:0] color,
	output reg [7:0] x, output reg  [7:0] y, output reg [7:0] z, output reg [2:0] c);
	
	//there can only be 1 '1' in x,y,z representing 1 lights
	
	// with (x,y) -NOR gate -> as neg end (ground)
	// z with selected colot -> as pos end (power)
	
	always @(posedge clk){
		if(!resetn) begin
			x <= 0;
			y <= 0;
			z <= 0;
			c <= 0;
		end
		
		else if(enable) begin
			x[oX[2:0]] <= 1;
			y[oY[2:0]] <= 1;
			z[oZ[2:0]] <= 1;
			c <= color[2:0];
		
		end
	
	}

endmodule
