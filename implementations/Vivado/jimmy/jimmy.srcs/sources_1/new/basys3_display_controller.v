`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2020 12:27:22 PM
// Design Name: 
// Module Name: basys3_display_controller
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


module basys3_display_controller(
        input disp_clk,
        input [3:0] dig3,
        input [3:0] dig2,
        input [3:0] dig1,
        input [3:0] dig0,
        input reset,
        output [6:0] segments,
        output reg [3:0] anodes
    );
    
    reg [3:0] decoder_input;

    hex2_7seg decoder(
        .hex_in(decoder_input),
        .seg_out(segments)
    );
    
    always @ (posedge disp_clk)
    if (reset==0) begin 
        anodes <= 4'b0111;             // Leftmost display goes first
        decoder_input <= 0;
    end
    else
        case(anodes)                 // Rotate bits @ Anode frequency 
            4'b0111 : begin 
                anodes <= 4'b1011;
                decoder_input <= dig2;
            end
            4'b1011 : begin
                anodes <= 4'b1101;
                decoder_input <= dig1;
            end
            4'b1101 : begin
                anodes <= 4'b1110;
                decoder_input <= dig0;
            end
            4'b1110 : begin
                anodes <= 4'b0111;
                decoder_input <= dig3;
            end
        endcase
endmodule
