`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 21:03:37
// Design Name: 
// Module Name: diglock_tb
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

module diglock_tb();

    reg clk, rst;
    reg req_access;
    reg [7:0] pin;
    reg first_four_match;
    reg last_four_match;
    wire lock_open;
    wire alarm;
    wire deny_access;
    diglock dut(
        .clk(clk),
        .rst(rst),
        .req_access(req_access),
        .pin(pin),
        .first_four_match(first_four_match),
        .last_four_match(last_four_match),
        .lock_open(lock_open),
        .alarm(alarm),
        .deny_access(deny_access)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  
    end

    initial begin
      
        rst = 1;
        req_access = 0;
        first_four_match = 0;
        last_four_match = 0;
        pin = 8'h00;
        #20 rst=0;
        #20;
        req_access = 1;
        #20;
        req_access = 0;
        first_four_match = 1;  
        last_four_match = 1; 
        
     
        #100 first_four_match = 0;
        last_four_match = 0;
        #20  req_access = 1;
        #20;
        req_access = 0;
        first_four_match = 0; 
        last_four_match = 0;
        #50;
         req_access = 1;
        #20;
        req_access = 0;
        first_four_match = 1; 
        last_four_match = 0;  
        #50;
        req_access = 1;
        #20;
        req_access = 0;
        first_four_match = 0;
        last_four_match = 0;
         #200  $finish;
    end
    initial begin 
    $monitor( "time=%t deny_acess= %b  lock_open=%b" ,$time ,deny_access , lock_open);
    end 

endmodule

