`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Closure Laboratories
// Engineer: Eduardo Corpeño
// 
// Create Date: 05/22/2020 02:41:57 PM
// Design Name: Jimmy, an 8-bit RISC soft processor
// Module Name: jimmy
// Project Name: Jimmy
// Target Devices: BASYS3 Board (Artix 7: XC7A35T-1CPG236C)
//                 DE0-CV Board (Intel Cyclone V: 5CEBA4F23C7N)
// Tool Versions: Xilinx Vivado 2019, Quartus Prime 19.1, Lattice Diamond
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
`define ADD_REG  6'b000000
`define MUL      6'b000010
`define MOV      6'b000100
`define NOP      6'b000111
`define LD_IMM   6'b100000
`define CMP_IMM  6'b100011
`define DEC      6'b100101
`define INPUT    6'b100110
`define OUTPUT   6'b100111
`define BRA      6'b101010
`define BHI      6'b101100
`define BEQ      6'b101101

// Control Logic States, One-Hot Encoded
`define FETCH      3'b001
`define EXECUTE    3'b010
`define WRITE_BACK 3'b100

module jimmy(
    input jimmy_clk,
    input reset,
    input  [7:0]  in_port_0,
    input  [7:0]  in_port_1,
    input  [7:0]  in_port_2,
    input  [7:0]  in_port_3,
    output [7:0] out_port_0,
    output [7:0] out_port_1,
    output [7:0] out_port_2,
    output [7:0] out_port_3,
    output reg [3:0] in_strobe,
    output reg [3:0] out_strobe,
    input  [7:0] inst_data_bus,
    output [7:0] inst_address_bus
    );
    
    // Registers
    reg [7:0] r[3:0]; // Register Bank
    reg [7:0] pc;     // Program Counter to Program Memory
    reg [7:0] sp;     // Stack Pointer to Data Memory
    reg Z;  // Zero Flag
    reg C;  // Carry Bit
    reg N;  // Negative Flag
    reg V;  // Overflow Flag
    
    // Data Memory
    reg [7:0] mem [255:0];  // The memory implemented as an array
    
    // State Machine
    reg [2:0] state;
    
    // Special Registers
    reg [5:0] instruction;
    reg [1:0] ra;
    reg [1:0] rb;
    reg A7;
    reg B7;
    reg [7:0] result;
    
    wire [7:0]  in_port [3:0];
    reg  [7:0] out_port [3:0];
    
    // Signals and Wiring
    wire [5:0] cat1_opcode;
    wire [5:0] cat2_opcode;
    wire [1:0] cat1_ra;
    wire [1:0] cat1_rb;
    wire [1:0] cat2_ra;
    wire [7:0] argument;
    wire R7;
    
    wire [7:0] r0;     // These four signals
    wire [7:0] r1;     // make the cpu registers
    wire [7:0] r2;     // available as signals to
    wire [7:0] r3;     // the waveform simulator.
    assign r0 = r[0];  // This issue came un
    assign r1 = r[1];  // in EDAPlayground when 
    assign r2 = r[2];  // EDWave wouldn't show
    assign r3 = r[3];  // the registers as signals.
    
    assign inst_address_bus = pc;
    assign cat1_opcode = {2'b00,inst_data_bus[7:4]};
    assign cat2_opcode = inst_data_bus[7:2];
    assign cat1_ra = inst_data_bus[3:2];
    assign cat1_rb = inst_data_bus[1:0];
    assign cat2_ra = inst_data_bus[1:0];
    assign argument = inst_data_bus;
    assign R7 = result[7];
    assign  in_port[0] = in_port_0;
    assign  in_port[1] = in_port_1;
    assign  in_port[2] = in_port_2;
    assign  in_port[3] = in_port_3;
    assign out_port_0 = out_port[0];
    assign out_port_1 = out_port[1];
    assign out_port_2 = out_port[2];
    assign out_port_3 = out_port[3];
    
    wire [15:0] mult;
    assign mult  = r[rb] *r[ra];
    
    // Procedural Code
    
    always @(posedge(jimmy_clk)) begin
        if (reset == 0) begin
            state <= `FETCH;
            pc    <= 8'b0000_0000;
            sp    <= 8'b1111_1111;
            in_strobe  <= 4'b1111; 
            out_strobe <= 4'b1111;
        end
        else begin
            case(state)
                `FETCH: begin
                    in_strobe  <= 4'b1111;
                    out_strobe <= 4'b1111;
                    if (inst_data_bus[7]==1'b0) begin // Instruction Category 
                        instruction <= cat1_opcode;   // Category 1
                        ra <= cat1_ra;
                        rb <= cat1_rb;
                    end
                    else begin                        // Category 2
                        instruction <= cat2_opcode;
                        ra <= cat2_ra;
                        case(cat2_opcode)
                            `LD_IMM,
                            `CMP_IMM, 
                            `BRA, 
                            `BHI,
                            `BEQ:  pc <= pc + 8'd1;
                        endcase
                    end
                    state <= `EXECUTE;
                end
                `EXECUTE: begin
                    case(instruction)
                        `ADD_REG: begin
                            result <= r[ra] + r[rb];
                            A7 <= r[ra][7];
                            B7 <= r[rb][7];
                            state <= `WRITE_BACK;
                        end
                        `MUL: begin
                            {r[rb],r[ra]} <= (ra==rb)?{mult[7:0],mult[7:0]}:(mult);
                            pc <= pc + 8'd1;
                            state <= `FETCH;
                        end      
                        `MOV: begin
                            r[ra] <= r[rb];
                            Z <= (r[rb]==8'd0)?1'b1:1'b0;
                            N <= r[rb][7];
                            V <= 0;
                            pc <= pc + 8'd1;
                            state <= `FETCH;
                        end
                        `NOP: begin
                            pc <= pc + 8'd1;
                            state <= `FETCH;
                        end
                        `LD_IMM: begin
                            r[ra] <= argument;
                            Z <= (argument==8'd0)?1'b1:1'b0;
                            N <= argument[7];
                            V <= 0;
                            pc <= pc + 8'd1;
                            state <= `FETCH;
                        end
                        `CMP_IMM: begin
                            result <= r[ra] - argument;
                            A7 <= r[ra][7];
                            B7 <= argument[7];
                            state <= `WRITE_BACK;
                        end
                        `DEC: begin
                            result <= r[ra] - 8'd1;
                            A7 <= r[ra][7];
                            state <= `WRITE_BACK;
                        end   
                        `INPUT: begin
                            r[ra] = in_port[ra];
                            state <= `WRITE_BACK;
                        end
                        `OUTPUT: begin
                            out_port[ra] = r[ra];
                            state <= `WRITE_BACK;
                        end                        
                        `BRA: begin
                            pc <= argument;
                            state <= `FETCH;
                        end                         
                        `BHI: begin          //   11111111 > 00000000
                            if(C==0 && Z==0) 
                                pc <= argument;
                            else
                                pc <= pc + 8'd1;
                            state <= `FETCH;
                        end
                        `BEQ: begin
                            if(Z==1) 
                                pc <= argument;
                            else
                                pc <= pc + 8'd1;
                            state <= `FETCH;
                         end 
                    endcase
                end
                `WRITE_BACK: begin
                    case(instruction)
                        `ADD_REG: begin
                            r[ra] <= result;
                            V <= (A7&B7&~R7)|(~A7&~B7&R7);
                            N <= R7;
                            Z <= (result==8'd0)?1'b1:1'b0;
                            C <= (A7&B7)|(B7&~R7)|(~R7&A7);
                        end
                        `CMP_IMM: begin
                            V <= (A7&~B7&~R7)|(~A7&B7&R7);
                            N <= R7;
                            Z <= (result==8'd0)?1'b1:1'b0;
                            C <= (~A7&B7)|(B7&R7)|(R7&~A7);
                        end
                        `DEC: begin
                            r[ra] <= result;
                            V <= ~R7&A7;
                            N <= R7;
                            Z <= (result==8'd0)?1'b1:1'b0;
                        end   
                        `INPUT: 
                            in_strobe[ra] = 1'b0;
                        `OUTPUT:
                            out_strobe[ra] = 1'b0;
                    endcase
                    pc <= pc + 8'd1;
                    state <= `FETCH;
                end
                default: begin
                    state <= `FETCH;
                    pc    <= 8'b0000_0000;
                    sp    <= 8'b1111_1111;
                    in_strobe  <= 4'b1111; 
                    out_strobe <= 4'b1111;
                end
            endcase
        end        
	end
endmodule
