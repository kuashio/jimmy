`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2020 12:10:01 PM
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd(
        input [7:0] bin,
        output [11:0] bcd
    );    
    assign bcd[11:8] = bin / 8'd100;
    assign bcd[7:4]  = (bin % 8'd100) / 8'd10;
    assign bcd[3:0]  = (bin % 8'd100) % 8'd10;     
endmodule
