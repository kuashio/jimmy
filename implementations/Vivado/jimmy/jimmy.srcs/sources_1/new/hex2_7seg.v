`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2020 04:43:43 PM
// Design Name: 
// Module Name: hex2_7seg
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

module hex2_7seg(
        input [3:0] hex_in,
        output reg [6:0] seg_out
    );
    always @(*)
        case(hex_in)
            4'd0:  seg_out <= 7'b1000000; // "0"  
            4'd1:  seg_out <= 7'b1111001; // "1" 
            4'd2:  seg_out <= 7'b0100100; // "2" 
            4'd3:  seg_out <= 7'b0110000; // "3" 
            4'd4:  seg_out <= 7'b0011001; // "4" 
            4'd5:  seg_out <= 7'b0010010; // "5" 
            4'd6:  seg_out <= 7'b0000010; // "6" 
            4'd7:  seg_out <= 7'b1111000; // "7" 
            4'd8:  seg_out <= 7'b0000000; // "8"  
            4'd9:  seg_out <= 7'b0010000; // "9"  
            4'd10: seg_out <= 7'b0001000; // "A"  
            4'd11: seg_out <= 7'b0000011; // "B"  
            4'd12: seg_out <= 7'b1000110; // "C"  
            4'd13: seg_out <= 7'b0100001; // "D"  
            4'd14: seg_out <= 7'b0000110; // "E"  
            4'd15: seg_out <= 7'b0001110; // "F"
        endcase
endmodule
