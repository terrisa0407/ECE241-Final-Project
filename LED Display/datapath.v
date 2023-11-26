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
	
	output CDADone,
	output reg rcm,
	
	output reg [35:0] jp1,
	output reg [35:0] jp2
);

	reg [2:0] x,y,z,color;
	
	wire [35:0] cdaAni1, cdaAni2, sel1,sel2;
	
	Countdown cda(clk,resetn,CDA,CDADone,cdaAni1,cdaAni2);
	
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
		
		else if(choC) begin
			color <= data[2:0];
			if(color == 0) rcm <= 1;
			else rcm <= 0;
			
		end
		
	end
	
	selecting u1(clk,resetn,Pos,choC,x,y,z,color,sel1,sel2);
	
	always@(*) begin
		if(!resetn) begin
			jp1 = 0;
			jp2 = {36{1'b1}};
		end
		
		else if(CDA) begin
			jp1 = cdaAni1;
			jp2 = cdaAni2;
		end
			
		else if(Pos || choC) begin
			jp1 = sel1;
			jp2 = sel2;
		end
	end
	
	
	
endmodule


