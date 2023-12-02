module selecting(input clk, input resetn, input Pos, input cCol, input [2:0] x, input [2:0] y, 
	input [2:0] z, input [2:0] c,
	output [35:0] jp1, output [35:0] jp2);
	
	reg [3:0] oX,oY,oZ,color;
	reg enable;
	
	reg [2:0] flash;
	reg [25:0] counter;
	
	parameter freq = 4;
	
	integer i;
	
	always@(posedge clk) begin
	
		if(!resetn) begin
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
					if(flash == 3'd2) 
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
	
	
	reg [25:0] blinking;
	reg en;
	
	always@(posedge clk) begin
	
		if(!resetn) begin
			blinking <= 0;
			en <= 0;
		end
		
		else if(!Pos) en <= enable;
		
		else if(!enable)  begin
			blinking <= 0;
			en <= 1;
		end
		
		else if(enable && c!=0) begin
			if(blinking == 50000000/freq) begin
				blinking <= 0;
				if(en) en <= 0;
				else en <= 1;
			end
			else blinking <= blinking +1; 
		end
	
	end
	
	//Change this back / en / enable
	LEDdisplay led(clk,resetn,en,oX,oY,oZ,color,jp1,jp2);

	
endmodule
	
