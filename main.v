module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,	SW,	// On Board Keys
		GPIO_0, GPIO_1,
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
	output [35:0] GPIO_0;
	output [35:0] GPIO_1;
	
	wire sensor;
	assign sensor = 1; // replaced with sensor module
	
	wire CDADone,rcm; // input
	wire Ped, CDA,POS,Color,off,SA; //output
	
	fsm ff(CLOCK_50,KEY[1]/*LOAD*/,resetn, sensor,KEY[2]/*pause*/, CDADone,rcm, // rainbow Color mode: 1(true)
	Ped, CDA, POS, Color, off, SA);
	
	LEDdp led(KEY[1]/*LOAD*/, resetn,CLOCK_50,SW[8:0],off,CDA,Pos,Color,SA,pause,CDADone,rcm,GPIO_0,GPIO_1);	
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
