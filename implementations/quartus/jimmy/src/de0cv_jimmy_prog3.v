`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 09:45:21 PM
// Design Name: 
// Module Name: de0cv_jimmy_prog3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module de0cv_jimmy_prog3(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	inout 		          		CLOCK4_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,
	input 		          		RESET_N,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// microSD Card //////////
//	output		          		SD_CLK,
//	inout 		          		SD_CMD,
//	inout 		     [3:0]		SD_DATA,

	//////////// SW //////////
	input 		     [9:0]		SW
);


    wire clk;
    wire [7:0] led;
	 
	 assign clk = CLOCK_50;
	 assign LEDR = {2'b0,led};
    assign HEX5 = 7'b111_1111;
    assign HEX4 = 7'b111_1111;
    assign HEX3 = 7'b111_1111;
    

    wire [7:0] prog_data_bus;
    wire [7:0] prog_addr_bus;
    wire [3:0] S_strobe;
    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;
    wire [7:0] fact;
    reg  [7:0] S;
    wire reset;
    wire display_clk;
    
    jimmy james(
        .jimmy_clk(clk),
        .reset(reset),
        .in_port_0(SW[7:0]),
        .out_port_1(fact),
        .out_strobe(S_strobe),
        .inst_data_bus(prog_data_bus),
        .inst_address_bus(prog_addr_bus)
    );
    
    program_memory3 pm(
        .address_bus(prog_addr_bus),
        .data_bus(prog_data_bus),
        .reset(reset),
        .program_clk(clk)
    );
    
    bin2bcd decoder(
        .bin(S),
        .bcd({hundreds,tens,ones})
    );
    
    hex2_7seg dec2(hundreds, HEX2);
    hex2_7seg dec1(tens,     HEX1);
    hex2_7seg dec0(ones,     HEX0);
	
       
    always @ (negedge(S_strobe[1])) begin
      S <= fact;
    end
    
    assign led = S;
    assign reset = RESET_N;
    
endmodule
