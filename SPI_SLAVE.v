`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 19:12:38
// Design Name: 
// Module Name: SPI_SLAVE
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


module SPI_SLAVE#(
    parameter width=8,
    parameter cpol=0,
    parameter cpha=0
)(input wire [7:0]tx_data,
  input wire clk, rst, mosi,
  input wire sclk, cs,
  output reg miso, 
  output reg [7:0]rx_data, 
  output reg rx_done
);
reg [7:0]shift_rx;
reg [7:0]shift_tx;
reg [2:0]bit_cnt;
reg cs_prev;
reg sclk_prev;
wire cs_falling=(cs_prev==1 && cs==0);
wire sclk_raising=(sclk_prev==0 && sclk==1);
wire sclk_falling=(sclk_prev==1 && sclk==0);
always@(posedge clk or posedge rst) begin
if(rst) begin
    cs_prev<=1;
    sclk_prev<=cpol;
    shift_rx<=0;
    shift_tx<=0;
    miso<=0;
    rx_data<=0;
    bit_cnt<=7;
    rx_done<=0;
   end
else begin
    sclk_prev<=sclk;
    cs_prev<=cs;
    rx_done<=0;
    if(cs_falling) begin
        shift_tx<=tx_data;
        bit_cnt<=7;
       end
    if(cs==0) begin
        if(cpha==0) begin
            if(cpol==0) begin
                if(sclk_falling) 
                    miso<=shift_tx[7];
                if(sclk_raising) begin
                    shift_rx<={shift_rx[6:0],mosi};
                    shift_tx<={shift_tx[6:0],1'b0};
                    if(bit_cnt==0) begin
                        bit_cnt<=7;
                        rx_data<={shift_rx[6:0],mosi};
                        rx_done<=1;
                        end
                    else
                        bit_cnt<=bit_cnt-1;
                end
            end
            else begin
                if(sclk_raising) 
                    miso<=shift_tx[7];
                if(sclk_falling) begin
                    shift_rx<={shift_rx[6:0],mosi};
                    shift_tx<={shift_tx[6:0],1'b0};
                    if(bit_cnt==0) begin
                        bit_cnt<=7;
                        rx_data<={shift_rx[6:0],mosi};
                        rx_done<=1;
                     end
                    else
                        bit_cnt<=bit_cnt-1;
                end
            end
         end
        else begin
            if(cpol==0) begin
                if(sclk_raising) 
                    miso<=shift_tx[7];
                if(sclk_falling) begin
                    shift_rx<={shift_rx[6:0],mosi};
                    shift_tx<={shift_tx[6:0],1'b0};
                    if(bit_cnt==0) begin
                        bit_cnt<=7;
                        rx_data<={shift_rx[6:0],mosi};
                        rx_done<=1;
                     end
                    else
                        bit_cnt<=bit_cnt-1;
                end
            end
            else begin 
                 if(sclk_falling) 
                    miso<=shift_tx[7];
                if(sclk_raising) begin
                    shift_rx<={shift_rx[6:0],mosi};
                    shift_tx<={shift_tx[6:0],1'b0};
                    if(bit_cnt==0) begin
                        bit_cnt<=7;
                        rx_data<={shift_rx[6:0],mosi};
                        rx_done<=1;
                        end
                    else
                        bit_cnt<=bit_cnt-1;
                end
            end
         end end
     else 
        miso<=0;
   end
 end   
endmodule
