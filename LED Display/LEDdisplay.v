module LEDdisplay(input clk, input resetn,input enable,
	input [3:0] oX,input [3:0] oY,input [3:0] oZ,input [3:0] color,
	output reg [35:0] jp1, output reg  [35:0] jp2
	);
	
	//there can only be 1 '1' in x,y,z representing 1 lights
	
	
	// with (x,y) -NOR gate -> as neg end (ground)
	// z with selected colot -> as pos end (power)
	
	reg [7:0] x,y,z1,z2,z3;
	
	integer i;
	
	always @(posedge clk) begin
		if(~resetn) begin
			x <= 8'd0;
			y <= 8'd0;
			z1 <= 8'd0;
			z2 <= 8'd0;
			z3 <= 8'd0;
			jp1 <= 0;
			jp2 <= 0;
			
		end
		
		else if(enable) begin
			
			for(i=0;i<8;i=i+1) begin
				if(i == oX[2:0]) x[i] <= 1;
				else x[i] <= 0;
				
				if(i == oY[2:0]) y[i] <= 1;
				else y[i] <= 0;
				
				if(i == oZ[2:0]) begin
				
					if(color[2] == 1) z1[i] <= 1;
					else z1[i] <= 0;
					
					if(color[1] == 1) z2[i] <= 1;
					else z2[i] <= 0;
					
					if(color[0] == 1) z3[i] <= 1;
					else z3[i] <= 0;
					
				end
				
			end
			
			//on jp1
			jp1[2] <= x[0];
			jp1[4] <= x[1];
			jp1[6] <= x[2];
			jp1[0] <= x[3];
			jp1[1] <= x[4];
			jp1[3] <= x[5];
			jp1[5] <= x[6];
			jp1[7] <= x[7];
		
			jp1[8] <= y[0];
			jp1[10] <= y[1];
			jp1[12] <= y[2];
			jp1[14] <= y[3];
			jp1[16] <= y[4];
			jp1[18] <= y[5];
			jp1[20] <= y[6];
			jp1[22] <= y[7];
			
			
			//jp2
			jp2[2] <= z1[0];
			jp2[4] <= z1[1];
			jp2[6] <= z1[2];
			jp2[0] <= z1[3];
			jp2[1] <= z1[4];
			jp2[3] <= z1[5];
			jp2[5] <= z1[6];
			jp2[7] <= z1[7];
			
			jp2[8] <= z2[0];
			jp2[10] <= z2[1];
			jp2[12] <= z2[2];
			jp2[14] <= z2[3];
			jp2[16] <= z2[4];
			jp2[18] <= z2[5];
			jp2[20] <= z2[6];
			jp2[22] <= z2[7];
			
			jp2[9] <= z3[0];
			jp2[11] <= z3[1];
			jp2[13] <= z3[2];
			jp2[15] <= z3[3];
			jp2[17] <= z3[4];
			jp2[19] <= z3[5];
			jp2[21] <= z3[6];
			jp2[23] <= z3[7];
			
		
		end
		
	end
	
	

endmodule
