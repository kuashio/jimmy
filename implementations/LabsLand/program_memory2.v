`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Closure Laboratories
// Engineer: Eduardo Corpeño
// 
// Create Date: 05/26/2020 08:44:29 AM
// Design Name: Jimmy Program Memory 2
// Module Name: program_memory2
// Project Name: Jimmy
// Target Devices: BASYS3 Board (Artix 7: XC7A35T-1CPG236C)
//                 DE0-CV Board (Intel Cyclone V: 5CEBA4F23C7N)
// Tool Versions: Xilinx Vivado 2019, Quartus Prime 19.1, Lattice Diamond, EDAPlayground
// Description: A basic 8-bit processor for a CPU design course.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Opcodes
`define OP_ADD      4'b0000
`define OP_MUL      4'b0010
`define OP_MOV      4'b0100
`define OP_NOP      4'b0111
`define OP_LD_IMM   6'b100000
`define OP_CMP_IMM  6'b100011
`define OP_DEC      6'b100101
`define OP_INPUT    6'b100110
`define OP_OUTPUT   6'b100111
`define OP_BRA      6'b101010
`define OP_BHI      6'b101100
`define OP_BEQ      6'b101101

module program_memory2(
    input  [7:0] address_bus,
    output [7:0] data_bus,
    input  reset,
    input program_clk
    );
    
    reg [7:0] program_rom [255:0];
    assign data_bus = program_rom[address_bus];
    
    always @(posedge(program_clk))
        if (reset == 0) begin
            program_rom[ 0] <= {`OP_INPUT,2'd0};        //start:     INPUT R0
            program_rom[ 1] <= {`OP_CMP_IMM,2'd0};      //           CMP R0, #1
            program_rom[ 2] <= 8'd1;                    //           ^^^ #1
            program_rom[ 3] <= {`OP_BHI,2'b00};         //           BHI init
            program_rom[ 4] <= 8'd9;                    //           ^^^ init (9) 
            program_rom[ 5] <= {`OP_MOV,2'd1,2'd0};     //           MOV R1,R0 
            program_rom[ 6] <= {`OP_OUTPUT,2'd1};       //end:       OUTPUT R1
            program_rom[ 7] <= {`OP_BRA,2'b00};         //           BRA start
            program_rom[ 8] <= 8'd0;                    //           ^^^start(0)
            program_rom[ 9] <= {`OP_LD_IMM,2'd1};       //init:      LD R1, #0
            program_rom[10] <= 8'd0;                    //           ^^^#0
            program_rom[11] <= {`OP_LD_IMM,2'd2};       //           LD R2, #1
            program_rom[12] <= 8'd1;                    //           ^^^#1
            program_rom[13] <= {`OP_CMP_IMM,2'd0};      //loop:      CMP R0, #0
            program_rom[14] <= 8'd0;                    //           ^^^#0
            program_rom[15] <= {`OP_BEQ,2'b00};         //           BEQ end
            program_rom[16] <= 8'd6;                    //           ^^^end(6)
            program_rom[17] <= {`OP_MOV,2'd3,2'd1};     //           MOV R3, R1
            program_rom[18] <= {`OP_ADD,2'd3,2'd2};     //           ADD R3, R2
            program_rom[19] <= {`OP_MOV,2'd1,2'd2};     //           MOV R1, R2
            program_rom[20] <= {`OP_MOV,2'd2,2'd3};     //           MOV R2, R3
            program_rom[21] <= {`OP_DEC,2'd0};          //           DEC R0
            program_rom[22] <= {`OP_BRA,2'b00};         //           BRA loop
            program_rom[23] <= 8'd13;                   //           ^^^loop(13)
            program_rom[24] <= 8'b0111_0000; // NOP
            program_rom[25] <= 8'b0111_0000; // NOP
            program_rom[26] <= 8'b0111_0000; // NOP
            program_rom[27] <= 8'b0111_0000; // NOP
            program_rom[28] <= 8'b0111_0000; // NOP
            program_rom[29] <= 8'b0111_0000; // NOP
            program_rom[30] <= 8'b0111_0000; // NOP
            program_rom[31] <= 8'b0111_0000; // NOP
     end
endmodule
