`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2026 19:37:55
// Design Name: 
// Module Name: SPI_TB
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


module SPI_TB;
reg clk, rst, start;
reg [7:0]master_tx;
reg [7:0]slave_tx;
wire [7:0]master_rx;
wire [7:0]slave_rx;
wire done, busy, sclk, cs;
always #5 clk=~clk;
SPI_TOP uut(.clk(clk), .rst(rst), .start(start), .master_tx(master_tx), .master_rx(master_rx),
            .slave_tx(slave_tx), .slave_rx(slave_rx), .done(done), .busy(busy), .sclk(sclk), 
            .cs(cs));
initial begin
    $monitor("Time=%0t | sclk=%b| cs=%b| master_tx=%h| master_rx=%h| slave_tx=%h| slave_rx=%h,|done=%b",$time, sclk, cs, master_tx, master_rx, slave_tx, slave_rx, done);
     end
initial begin 
    clk=0;
    rst=1;
    start=0;
    master_tx=8'hA5;
    slave_tx=8'h3c;
    #20;
    rst=0;
    #10;
    $display("===master sends 0xA5===");
    start=1; wait(busy == 1); 
    start=0;
    @(posedge done);
    #20;
    $display("master sent:%h",master_tx);
    $display("slave resceived: %h",slave_rx);
    $display("slave sent: %h",slave_tx);
    $display("master received:%h",master_rx);
if(slave_rx==master_tx)
    $display("pass");    
else    
    $display("fail");
 #50;
master_tx=8'hFF;
slave_tx=8'h00;
start=1; wait(busy == 1);  start=0;
@(posedge done);
#20
if(slave_rx==8'hFF)
    $display("pass");
 #50;
master_tx=8'h00;
slave_tx=8'hAB;
start=1; wait(busy == 1); start=0;
@(posedge done);
#20
if(slave_rx==8'h00)
    $display("pass");
 #50;
$finish;
end
endmodule
