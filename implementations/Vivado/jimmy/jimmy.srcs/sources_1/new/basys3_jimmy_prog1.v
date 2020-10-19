`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 09:45:21 PM
// Design Name: 
// Module Name: jimmy_fibonacci
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


module basys3_jimmy_prog1(
    input clk,
    input btnC,
    input [15:0] sw,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [7:0] led
    );
    
    
    wire [7:0] prog_data_bus;
    wire [7:0] prog_addr_bus;
    wire [3:0] S_strobe;
    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;
    wire [7:0] sum;
    reg  [7:0] S;
    wire reset;
    wire display_clk;
    
    jimmy james(
        .jimmy_clk(clk),
        .reset(reset),
        .in_port_0(sw[15:8]),
        .in_port_1(sw[7:0]),
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
    
    bin2bcd decoder(
        .bin(S),
        .bcd({hundreds,tens,ones})
    );
    
    FreqDivider fd(
        .in_clk(clk),
        .reset(reset),
        .ratio(32'd416_667),
        .out_clk(display_clk)
    );
    
    basys3_display_controller mydisplay(
        .disp_clk(display_clk),
        .reset(reset),
        .dig3(4'd0),
        .dig2(hundreds),
        .dig1(tens),
        .dig0(ones),
        .segments(seg),
        .anodes(an)
    );
    
    always @ (negedge(S_strobe[0])) begin
      S <= sum;
    end
    
    assign led = S;
    assign reset = ~btnC;
    assign dp = 1'b1;
    
endmodule
