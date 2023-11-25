module LEDdp(
	//system control
	input load,
	input resetn,
	input clk,
	
	//data in
	input [8:0] data,
	
	//Status control
	input off, // needed? 
	input CDA,
	input Pos,
	input choC,
	input AnS, //Animation Start
	input pause,
	
	output reg CDADone,
	output reg rcm
);

	reg [2:0] x,y,z,color;
	Countdown cda(clk,resetn,CDA,CDADone);
	
	//load x,y,z,color
	always@(posedge clk) begin
		if(!resetn) begin
			x <= 0;
			y <= 0;
			z <= 0;
			color <= 0;
		end
		
		if(Pos) begin
			x <= data[2:0];
			y <= data[5:3];
			z <= data[8:6];
		end
		
		else if(choC)
			color <= data[2:0];
		
	end
	
	
endmodule


module Countdown(input clk,input resetn,input CDA,output reg CDADone);

	reg figure [0:4][0:8];
	//Assign value to figure 1-3
	
	initial begin 
		figure = '{'{ 1,1,0,  1,1,1,  1,1,1},
						'{0,1,0,  0,0,1,  0,0,1},
						'{0,1,0,  1,1,1,  1,1,1},
						'{0,1,0,  1,0,0,  0,0,1},
						'{1,1,1,  1,1,1,  1,1,1}};
	end
	
	
	reg [2:0] oX,oY,oZ,color;
	reg enable;

	//helpers
	reg [23:0] cntStay; //625,0000 cycle / image
	reg [3:0] cntlayer; // y: 8->1
	reg [1:0] cntNum; // display 1 or 2 or 3
	
	
	always@(posedge clk) begin
		if(!resetn) begin
			CDADone <= 0;
			memFin <= 0;
			oX <= 3'd2;
			oY <= 3'd7;
			oZ <= 3'd2;
			color <= 0;
			enable <= 0;
			cntStay <= 0;
			cntlayer <= 4'd8;
			cntNum <=0;
			enable <= 0;
		end
		
		else if(CDA && ~CDADone)begin
			
			if(cntStay==23'd6250000) begin
				cntlayer <= cntlayer - 1;
				cntStay <= 23'd0;
			end
			
			if(cntlayer==4'd0) begin
				cntlayer <= 4'd8;
				cntNum <= cntNum + 1;
			end
			
			if(cntNum == 2'd3) begin
				CDADone <= 1;
				enable <= 0;
			end
			
			else if(~CDADone) begin
				
				cntStay <= cntStay + 1;
				enable <= 1;
				
				// i=(cntStay%15)/3; t=3*cntNum + (cntStay%15)%3
				// 
				if(figure[(cntStay%15)/3][3*cntNum + (cntStay%15)%3]) begin
					oZ <= 6 - ((cntStay%15)/3);
					oX <= 2 + ((cntStay%15)%3);
					oY <= cntlayer;
				
				end
				
			end
		
		end
	end
	
	LEDdisplay led(clk,resetn,enable,oX,oY,oZ,color);

endmodule;
