`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2026 19:04:54
// Design Name: 
// Module Name: SPI_TOP
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


module SPI_TOP(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0]master_tx,
    input wire [7:0]slave_tx,
    output wire [7:0]master_rx,
    output wire [7:0]slave_rx,
    output wire done, sclk, cs, busy
    );
wire mosi,miso;
SPI_MASTER#(.cpol(0),.cpha(0))master_inst(.clk(clk), .rst(rst), .sclk(sclk), .cs(cs), 
             .start(start), .tx_data(master_tx), .rx_data(master_rx), .mosi(mosi), .miso(miso), 
             .busy(busy), .done(done));
SPI_SLAVE slave_inst(.tx_data(slave_tx), .rx_data(slave_rx), .mosi(mosi), .miso(miso), 
                     .clk(clk), .rst(rst), .sclk(sclk), .cs(cs), .rx_done());
 endmodule
