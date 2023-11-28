module jumpingPoint(input clk,input resetn,input pause,input rcm,input [2:0] x,input [2:0] y,input [2:0] z,input [2:0] c,
	output [35:0] jp1,output [35:0] jp2);
	
	parameter pic = 8;
	
	reg [3:0] oX,oY,oZ,color;
	reg dirX,dirY,dirZ;
	reg enable;
	reg [25:0] counter;
	
	reg init;
	
	always@(posedge clk) begin
	
		if(!resetn) begin
			oX <= 0; oY <= 0; oZ <= 0; color <= 0;
			dirX <= 0; dirY <= 0; dirZ <= 0;
			
			enable <= 0;
			counter <= 0;
			init <= 1;
			
		end
		
		
		else begin
			
			enable <= 1;
			
			if(init) begin
				
				init <= 0;
				
				oX <= {1'b0,x};
				if(oX < 4'd4) dirX <= 1; // direction ++;
				else dirX <= 0;
				
				oY <= {1'b0,y};
				if(oY < 4'd4) dirY <= 1; // direction ++;
				else dirY <= 0;
				
				oZ <= {1'b0,z};
				if(oZ < 4'd4) dirZ <= 1; // direction ++;
				else dirZ <= 0;
				
				if(rcm) color <= 4'b0001;// better to be the one flashing when selected
				else color <= {1'b0,c};
			
			end
			
			if(counter == 50000000/pic) begin
				counter <= 0;
				
				//update oX
				if(oX==1 && dirX==0) begin
					dirX <= 1;
					oX <= 0;
				end
				
				else if(oX == 4'd6 && dirX==1) begin
					dirX <= 0;
					oX <= 4'd7;
				end
				
				else begin
					if(dirX == 1) oX <= oX + 1;
					else oX <= oX - 1;
				end
				
				
				//update OY
				if(oY==1 && dirY==0) begin
					dirY <= 1;
					oY <= 0;
				end

				else if(oY == 4'd6 && dirY==1) begin
					dirY <= 0;
					oY <= 4'd7;
				end
				
				else begin
					if(dirY == 1) oY <= oY + 1;
					else oY <= oY - 1;
				end
				
				//update oZ
				if(oZ==1 && dirZ==0) begin
					dirZ <= 1;
					oZ <= 0;
				end
				
				else if(oZ == 4'd6 && dirZ==1) begin
					dirZ <= 0;
					oZ <= 4'd7;
				end
		
				else begin
					if(dirZ == 1) oZ <= oZ + 1;
					else oZ <= oZ - 1;
				end
				
				if(rcm) begin
					if(color == 4'b0100) color <= 4'b0010;
					if(color == 4'b0010) color <= 4'b0001;
					if(color == 4'b0001) color <= 4'b0100;
				end
				
			end
			
			else if(!pause) counter <= counter + 1;
		
		end
	
	end
	
	LEDdisplay led(clk,resetn,enable,oX,oY,oZ,color,jp1,jp2);
	
	
endmodule
