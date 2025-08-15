`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2025 15:49:22
// Design Name: 
// Module Name: digi_top
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


module top_diglock_fpga (
    input clk,      // 50MHz DE10 clock
    input rst,    // pushbutton active-low
    input [7:0]pin, // 8 switches = pin
    input req_access,     // request access
    output [2:0] LEDR // LEDs: [0]=lock_open, [1]=alarm, [2]=deny_access
);
    wire lock_open, alarm, deny_access;

    // For testing: assume exact match if pin = 8'b10100101 (e.g.)
    wire [3:0] level  = pin[7:4];
    wire [3:0] id     = pin[3:0];
    wire [3:0] stored_level = 4'b0111;
    wire [3:0] stored_id    = 4'b0111;

    wire first_four_match = (level == stored_level);
    wire last_four_match  = (id == stored_id);

    diglock u1 (
        .clk(clk),
        .rst(rst), // active-high reset inside
        .req_access(req_access), // active-low button
        .pin(pin),
        .first_four_match(first_four_match),
        .last_four_match(last_four_match),
        .lock_open(lock_open),
        .alarm(alarm),
        .deny_access(deny_access)
    );

    assign LEDR[0] = lock_open;
    assign LEDR[2] = alarm;
    assign LEDR[1] = deny_access;

endmodule
