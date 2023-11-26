module selecting(input clk, input resetn, input Pos, input cCol, input [2:0] x, input [2:0] y, 
	input [2:0] z, input [2:0] c,
	output reg [35:0] jp1, output reg[35:0] jp2);
	
	reg [3:0] oX,oY,oZ,color;
	reg enable;
	
	reg [2:0] flash;
	reg [25:0] counter;
	
	integer i;
	
	always@(posedge clk) begin
	
		if(!resetn) begin
			jp1 <= 0;
			jp2 <= {36{1'b1}};
			enable <= 0;
			oX <= 0;
			oY <= 0;
			oZ <= 0;
			color <= 0;
			flash <= 0;
			counter <= 0;
		end
		
		else if(Pos) begin
		
			oX <= {1'b0,x};
			oY <= {1'b0,y};
			oZ <= {1'b0,z};
			color <= 4'b111;

			enable <= 1;
			
		end
		
		else if(cCol) begin
			//flashing pure red / blue / green
			if(c == 0) begin
			
				if(counter == 26'd25000000) begin
					counter <= 0;
					if(flash == 3'd4) 
						flash <= 0;
					else
						flash <= flash + 1;
				end
				else counter <= counter + 1;
				
				for(i=0;i<3;i=i+1) begin
					if(i==flash) color[i] <= 1;
					else color[i] <= 0;
				
				end
				
				enable <= 1;
				
			end
			
			else begin
				
				color <= {1'b0,c};
				enable <= 1;
			end
			
		end
		
	end
	
	LEDdisplay led(clk,resetn,enable,oX,oY,oZ,color,jp1,jp2);

	
endmodule
	
