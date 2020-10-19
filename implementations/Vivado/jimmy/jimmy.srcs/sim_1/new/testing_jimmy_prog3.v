`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Closure Laboratories
// Engineer: Eduardo Corpeño
// 
// Create Date: 05/26/2020 02:35:03 PM
// Design Name: Testing Jimmy with Program #3
// Module Name: testing_jimmy_prog3
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


module testing_jimmy_prog3();
    reg clk;
    reg reset;
    wire [7:0] prog_data_bus;
    wire [7:0] prog_addr_bus;
    wire [3:0] S_strobe;
    wire [7:0] fact;
    reg [7:0] A;
    reg [7:0] S;
    
    jimmy james(
        .jimmy_clk(clk),
        .reset(reset),
        .in_port_0(A),
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
    always #5 clk = !clk;

    always @ (negedge(S_strobe[1])) begin
      S <= fact;
      A <= A + 1;
    end
    
    initial begin
        $dumpfile("test.vcd"); 
        $dumpvars(0,testing_jimmy_prog3); 
        clk <= 0;
        reset <= 1;
        A <= 0;
        #57;
        reset <= 0;
        #53;
        reset <= 1;
        #10507;
        $finish;
    end
endmodule
