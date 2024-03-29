`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 09:45:21 PM
// Design Name: 
// Module Name: de0cv_jimmy_prog2
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

module de0cv_jimmy_prog2(

	//////////// CLOCK //////////
	input 		          		G_CLOCK_50,
	//input 		          		CLOCK2_50,
	//input 		          		CLOCK3_50,
	//inout 		          		CLOCK4_50,

	//////////// SEG7 //////////
	output		     [6:0]		G_HEX0,
	output		     [6:0]		G_HEX1,
	output		     [6:0]		G_HEX2,
	output		     [6:0]		G_HEX3,
	output		     [6:0]		G_HEX4,
	output		     [6:0]		G_HEX5,

	//////////// KEY //////////
	input 		     [3:0]		V_BT,
	//input 		          		RESET_N,

	//////////// LED //////////
	output		     [9:0]		G_LEDR,

	//////////// SW //////////
	input 		     [9:0]		V_SW
);


    wire clk;
    wire [7:0] led;
	 
	assign clk = G_CLOCK_50;
	assign G_LEDR = {2'b0,led};
    assign G_HEX5 = 7'b111_1111;
    assign G_HEX4 = 7'b111_1111;
    assign G_HEX3 = 7'b111_1111;
    

    wire [7:0] prog_data_bus;
    wire [7:0] prog_addr_bus;
    wire [3:0] S_strobe;
    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;
    wire [7:0] fib;
    reg  [7:0] S;
    wire reset;
    wire display_clk;
    
    jimmy james(
        .jimmy_clk(clk),
        .reset(reset),
        .in_port_0(V_SW[7:0]),
        .out_port_1(fib),
        .out_strobe(S_strobe),
        .inst_data_bus(prog_data_bus),
        .inst_address_bus(prog_addr_bus)
    );
    
    program_memory2 pm(
        .address_bus(prog_addr_bus),
        .data_bus(prog_data_bus),
        .reset(reset),
        .program_clk(clk)
    );
    
    bin2bcd decoder(
        .bin(S),
        .bcd({hundreds,tens,ones})
    );
    
    hex2_7seg dec2(hundreds, G_HEX2);
    hex2_7seg dec1(tens,     G_HEX1);
    hex2_7seg dec0(ones,     G_HEX0);
	
       
    always @ (negedge(S_strobe[1])) begin
      S <= fib;
    end
    
    assign led = S;
    assign reset = V_BT[0];
    
endmodule
