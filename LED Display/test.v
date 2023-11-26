module test(input CLOCK_50, input [9:0] SW,input [3:0]KEY,output [6:0] HEX0,output [6:0] HEX1, output [6:0] HEX2,output [35:0] GPIO_0,
	output [35:0] GPIO_1);

	wire [3:0] x = {1'b0,SW[2:0]};
	wire [3:0] y = 1111;
	wire [3:0] z = {1'b0,SW[5:3]};
	wire [3:0] c = {1'b0,SW[8:6]};
	
	hex_decoder u1(x,HEX0);
	hex_decoder u2(z,HEX1);
	hex_decoder u3(c,HEX2);
	
	LEDdisplay led(CLOCK_50, KEY[0]/*resetn*/,SW[9]/*enable*/,x,y,z,c,GPIO_0,GPIO_1);

endmodule

module hex_decoder(c,display);

	input[3:0] c;
	output[6:0] display;
	
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

