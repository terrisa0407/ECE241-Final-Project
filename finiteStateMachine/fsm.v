
module fsm(
	input clk,
	input LOAD,
	input resetn, 
	input sensor,
	input pasue, 
	
	input CDADone, // Countdown animation done
	
	output reg rcm, // rainbow Color mode: 1(true)
	output reg Ped, // paused 
	
	output reg CDA, //Countdown Animation
	output reg POS, // choosing position
	output reg Color, // choosing colour
	output reg off, // every light is off
	output reg SA, // Start Animation: Cubic animations
	
	output reg [4:0] cs // current state (*For simulation)
	);
	
	reg [4:0] ns;
	
	//Assigning next Stage
	always@(*) begin
		case(cs)
		
			5'd0: ns = sensor ? 5'd1 : 5'd0; //notes: sensor needs to stay 1 once activated
			5'd1: ns = CDADone ? 5'd2 : 5'd1;
			5'd2: ns = LOAD ? 5'd3 : 5'd2; // notes: key value (pressed -> 1)
			5'd3: ns = LOAD ? 5'd3 : 5'd4;
			5'd4: begin
				if(LOAD) begin
					if(rcm) ns = 5'd8;
					else ns = 5'd5;
				end
				else ns = 5'd4;
			end
			
			5'd5: ns = LOAD ? 5'd5 : 5'd6;
			5'd6: ns = Ped ? 5'd7 : 5'd6; // notes: pressed -> true
			5'd7: ns = Ped ? 5'd7 : 5'd6;
			
			5'd8: ns = LOAD ? 5'd8 : 5'd9;
			5'd9: ns = Ped ? 5'd10 : 5'd9; 
			5'd10: ns = Ped ? 5'd10 : 5'd9;
			default: ns = 5'd0;
				
		endcase
	end
	
	//output in each stage
	always@(*) begin
	
		off = 0;
		CDA = 0;
		POS = 0;
		Color = 0;
		SA = 0;
		Ped = 0;
		rcm = 0;
		
		case(cs)
			5'd0: off = 1;
			5'd1: 
				CDA = 1;
				
			//Choosing pos
			5'd2: 
				POS = 1;
			5'd3: 
				POS = 1;
			
			//Choosing color 
			5'd4: begin
				Color = 1;
			end
			5'd5: begin
				Color = 1;
			end
			
			//animation (!rcm mode)
			5'd6: 
				SA = 1;
			
			5'd7: 
				Ped = 1;
			
			//Choosing color (rcm mode)
			5'd8: 
				Color = 1;
				
			5'd9: begin
				SA = 1;
				rcm = 1;
			end
			
			5'd10: Ped = 1;
			
		endcase
	
	end

	always@(posedge clk) begin
		if(!resetn)
			cs <= 5'd0;
		else 
			cs <= ns;
			
	end

endmodule
