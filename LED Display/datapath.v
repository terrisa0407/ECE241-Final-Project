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
		
		else if(choC) begin
			color <= data[2:0];
			if(color == 111) rcm <= 1;
			else rcm <= 0;
			
		end
		
	end
	
	
endmodule


