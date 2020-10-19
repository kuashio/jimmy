`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Closure Laboratories
// Engineer: Eduardo Corpeño
// 
// Create Date: 05/26/2020 09:13:18 AM
// Design Name: Testing Jimmy with Program #1
// Module Name: testing_jimmy_prog1
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


module testing_jimmy_prog1();
    reg clk;
    reg reset;
    wire [7:0] prog_data_bus;
    wire [7:0] prog_addr_bus;
    wire [3:0] S_strobe;
    wire [7:0] sum;
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] S;
    
    jimmy james(
        .jimmy_clk(clk),
        .reset(reset),
        .in_port_0(A),
        .in_port_1(B),
        .out_port_0(sum),
        .out_strobe(S_strobe),
        .inst_data_bus(prog_data_bus),
        .inst_address_bus(prog_addr_bus)
    );
    
    program_memory1 pm(
        .address_bus(prog_addr_bus),
        .data_bus(prog_data_bus),
        .reset(reset),
        .program_clk(clk)
    );
    always #5 clk = !clk;

    always @ (negedge(S_strobe[0])) begin
      S <= sum;
    end
    
    initial begin
        $dumpfile("test.vcd"); 
      $dumpvars(0,testing_jimmy_prog1); 
        clk <= 0;
        reset <= 1;
        A <= 0;
        B <= 0;
        S <= 0;
        #50;
        reset <= 0;
        #50;
        reset <= 1;
        #400;
        A <= 2;
        B <= 3;
        #400;
        A <= 21;
        B <= 100;
        #400;
        $finish;
    end
    
endmodule
