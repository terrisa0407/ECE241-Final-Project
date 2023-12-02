module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,	SW,	LEDR,// On Board Keys
		GPIO_0, GPIO_1, HEX0, HEX1, HEX2, HEX4,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;				
	
	// Declare your inputs and outputs here
	input [9:0] SW;
	
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Changes go here
	output reg [9:0] LEDR;
	output [35:0] GPIO_0;
	output [35:0] GPIO_1;
	
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX4;
	
	wire sensor;
	assign sensor = 1; // replaced with sensor module
	
	wire CDADone,rcm; // input
	wire Ped, CDA,POS,Color,off,SA; //output
	
	wire [4:0] cs;
	
	fsm ff(CLOCK_50,~KEY[1]/*LOAD*/,resetn, sensor,~KEY[2]/*pause*/, CDADone,rcm, // rainbow Color mode: 1(true)
	Ped, CDA, POS, Color, off, SA,cs);
	
	//showing which state it is
	integer i;
	always@(*) begin
		for(i=0;i<10;i=i+1) begin
			if(i==cs) LEDR[i] = 1;
			else LEDR[i] = 0;
		end
	end
	wire [2:0] a,b,c,d;
	LEDdp led(KEY[1]/*LOAD*/, resetn,CLOCK_50,SW[8:0],off,CDA,POS,Color,SA,pause,CDADone,rcm,GPIO_0,GPIO_1,a,b,c,d);	
	
	hex_decoder(a,HEX0);
	hex_decoder(b,HEX1);
	hex_decoder(c,HEX2);
	
	wire [2:0] ttt = {2'b00,rcm}; 
	hex_decoder(Color,HEX4);
	
	//
	
	wire writeEn;
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	/*
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. //s
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";*/
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	
	
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
endmodule

//changed version (0-7)
module hex_decoder(ca,display);

	input[2:0] ca;
	output[6:0] display;
	
	wire [3:0] c;
	assign c = {1'b0,ca};
	
	assign display[0] = ~((c[3] | c[2] | c[1] | ~c[0]) &
		(c[3] | ~ c[2] | c[1] | c[0]) &
		(~c[3] | c[2] | ~c[1] | ~c[0]) &
		(~c[3] | ~c[2] | c[1] | ~c[0]));
		
	assign display[1] = ~((c[3] | ~c[2] | c[1] | ~c[0]) &
		(c[3] | ~c[2] | ~c[1] | c[0]) &
		(~c[3] | c[2] | ~c[1] | ~c[0]) &
		(~c[3] | ~c[2] | c[1] | c[0]) &
		(~c[3] | ~c[2] | ~c[1] | c[0]) &
		(~c[3] | ~c[2] | ~c[1] | ~c[0]));
		
	assign display[2] = ~((c[3] | c[2] | ~c[1] | c[0]) &
		(~c[3] | ~c[2] | c[1] | c[0]) &
		(~c[3] | ~c[2] | ~c[1] | c[0]) &
		(~c[3] | ~c[2] | ~c[1] | ~c[0]));
		
	assign display[3] = ~((c[3] | c[2] | c[1] | ~c[0]) &
		(c[3] | ~c[2] | c[1] | c[0]) &
		(c[3] | ~c[2] | ~c[1] | ~c[0]) &
		(~c[3] | c[2] | ~c[1] | c[0]) &
		(~c[3] | ~c[2] | ~c[1] | ~c[0]));
		
	assign display[4] = ~((c[3] | c[2] | c[1] | ~c[0]) &
		(c[3] | c[2] | ~c[1] | ~c[0]) &
		(c[3] | ~c[2] | c[1] | c[0]) &
		(c[3] | ~c[2] | c[1] | ~c[0]) &
		(c[3] | ~c[2] | ~c[1] | ~c[0]) &
		(~c[3] | c[2] | c[1] | ~c[0]));
		
	assign display[5] = ~((c[3] | c[2] | c[1] | ~c[0]) &
		(c[3] | c[2] | ~c[1] | c[0]) &
		(c[3] | c[2] | ~c[1] | ~c[0]) &
		(c[3] | ~c[2] | ~c[1] | ~c[0]) &
		(~c[3] | ~c[2] | c[1] | ~c[0]));
		
	assign display[6] = ~((c[3] | c[2] | c[1] | c[0]) &
		(c[3] | c[2] | c[1] | ~c[0]) &
		(c[3] | ~c[2] | ~c[1] | ~c[0]) &
		(~c[3] | ~c[2] | c[1] | c[0]));
		

endmodule

