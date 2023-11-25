module Countdown(input clk,input resetn,input CDA,output reg CDADone);

	reg figure [0:4][0:8];
	//Assign value to figure 1-3
	integer i,t;
	
	initial begin 
		/*figure = '{'{ 1,1,0,  1,1,1,  1,1,1},
						'{0,1,0,  0,0,1,  0,0,1},
						'{0,1,0,  1,1,1,  1,1,1},
						'{0,1,0,  1,0,0,  0,0,1},
						'{1,1,1,  1,1,1,  1,1,1}};*/
		for(i=0;i<5;i = i+1) begin
			for(t=0;t<9;t = t+1) begin
				if((i==0 && t!=2) || (t==1) || i==4 || (i==2 && t>2))
					figure[i][t] = 1;
			end
		end
		figure[1][5] = 1;
		figure[1][8] = 1;
		figure[3][3] = 1;
		figure[3][8] = 1;
		
	end
	
	
	reg [3:0] oX,oY,oZ,color;
	reg enable;

	//helpers
	reg [24:0] cntStay; //625,0000 cycle / image
	reg [4:0] cntlayer; // y: 8->1
	reg [2:0] cntNum; // display 1 or 2 or 3
	
	
	always@(posedge clk) begin
		if(!resetn) begin
			CDADone <= 0;
			oX <= 4'd2;
			oY <= 4'd7;
			oZ <= 4'd2;
			color <= 0;
			enable <= 0;
			cntStay <= 0;
			cntlayer <= 5'd8;
			cntNum <=0;
			enable <= 0;
		end
		
		else if(CDA && ~CDADone)begin
			
			if(cntStay==25'd6250000) begin
				cntlayer <= cntlayer - 1;
				cntStay <= 0;
			end
			if(cntStay < 25'd6250000)
				cntStay <= cntStay + 1;
			
			if(cntlayer==4'd0) begin
				cntlayer <= 4'd8;
				cntNum <= cntNum + 1;
			end
			
			if(cntNum == 2'd3) begin
				CDADone <= 1;
				enable <= 0;
			end
			
			else if(~CDADone) begin
				
				
				enable <= 1;
				
				// i=(cntStay%15)/3; t=3*cntNum + (cntStay%15)%3
				// 
				if(figure[(cntStay%15)/3][3*cntNum + (cntStay%15)%3]) begin
					oZ <= 6 - ((cntStay%15)/3);
					oX <= 2 + ((cntStay%15)%3);
					if(cntlayer > 0)
						oY <= cntlayer - 1;
				
				end
				
			end
		
		end
	end
	
	LEDdisplay led(clk,resetn,enable,oX,oY,oZ,color);

endmodule
