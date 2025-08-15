`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2025 23:33:32
// Design Name: 
// Module Name: diglock
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


module diglock (
    input wire clk, rst, 
    input wire req_access,
    input wire [7:0] pin, 
    input wire first_four_match, 
    input wire last_four_match,  
   
    output reg lock_open,   
    output reg alarm,        
    output reg deny_access  
);
    parameter IDLE        = 3'b000,
              CHECK_LVL   = 3'b001,
              CHECK_ID    = 3'b010,
              ACCESS_OK   = 3'b011,
              ACCESS_DENY = 3'b100,
              ALARM_STATE = 3'b101;

    reg [2:0] state;
    reg [1:0] deny_count;
   wire count_eq_3;
    
   // reg req_access_sync_0, req_access_sync_1, req_access_prev;
    //wire req_access_pulse;

   // always @(posedge clk or posedge rst) begin
     //   if (rst) begin
       //     req_access_sync_0 <= 0;
         //   req_access_sync_1 <= 0;
           // req_access_prev <= 0;
      //  end else begin
         /*   req_access_sync_0 <= req_access;
            req_access_sync_1 <= req_access_sync_0;
            req_access_prev <= req_access_sync_1;
        end
    end*/

   // assign req_access_pulse = req_access_sync_1 & ~req_access_prev;

   always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            lock_open <= 0;
            alarm <= 0;
            deny_access <= 0;
        end  
        else begin
            deny_access <= 0; 

            case (state)
                IDLE: begin
                    lock_open <= 0;
                    alarm <= 0;
                    if (req_access) begin
                        state <= CHECK_LVL;
                    end
                end

                CHECK_LVL: begin
                    if (first_four_match)
                        state <= CHECK_ID;
                    else
                        state <= ACCESS_DENY;
                end

                CHECK_ID: begin
                    if (last_four_match)
                        state <= ACCESS_OK;
                    else
                        state <= ACCESS_DENY;
                end

                ACCESS_OK: begin
                    lock_open <= 1;
                    state <= IDLE;
                end

                ACCESS_DENY: begin
                    deny_access <= 1;  
                    lock_open <= 0;
                    if (count_eq_3)
                        state <= ALARM_STATE;
                    else
                        state <= IDLE;
                end

                ALARM_STATE: begin
                    alarm <= 1;
                    lock_open <= 0;
                    state <= IDLE;
                end

            endcase
        end
    end
 

always @(posedge clk or posedge rst) begin
    if (rst) begin
        deny_count <= 0;
    end 
    else begin
        if (deny_access)
            deny_count <= deny_count + 1;
        else if (lock_open)  
            deny_count <= 0;
    end
end

assign count_eq_3 = (deny_count == 2);  
endmodule 
