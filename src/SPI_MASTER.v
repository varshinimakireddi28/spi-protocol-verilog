`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 17:19:46
// Design Name: 
// Module Name: SPI_MASTER
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



module SPI_MASTER#(
    parameter width=8,
    parameter cpol=0,
    parameter cpha=0
)( 
   input wire [7:0]tx_data,
   input wire clk, rst, start,
   output reg sclk, cs,
   output reg busy, done,
   output reg [7:0]rx_data,
   output reg mosi,
   input wire miso
  );
  localparam IDLE=2'b00;
  localparam LOAD=2'b01;
  localparam TRANSFER=2'b10;
  localparam FINISH=2'b11;
  reg [7:0]shift_tx;
  reg [7:0]shift_rx;
  reg [1:0]state;
  reg [2:0]bit_cnt;
  reg [2:0]div_cnt;
  reg clk_div; 
always@(posedge clk or posedge rst) begin
    if(rst)
    begin
        div_cnt<=0;
        clk_div<=0;
    end
    else 
     begin
        if(div_cnt==7)
        begin
            div_cnt<=0;
            clk_div<=~clk_div;
        end
       else 
            div_cnt<=div_cnt+1;
     end
     end
 always@(posedge clk_div or posedge rst) begin
 if (rst) begin
        state <= IDLE;
        cs    <= 1;
        sclk  <= cpol;
        busy  <= 0;
        done  <= 0;
        rx_data<=0;
        mosi<=0;
        shift_tx<=0;
        shift_rx<=0;
        bit_cnt<=0;
    end
 else begin
  case(state)
    IDLE: begin
          cs<=1;
          sclk<=cpol;
          done<=0;
          busy<=0;
          if(start) state<=LOAD;
         end
    LOAD: begin
          cs<=0;
          shift_tx<=tx_data;
          done<=0;
          busy<=1;
          state<=TRANSFER;
          bit_cnt<=7;
          end
    TRANSFER: begin
              sclk<=~sclk;
              if(cpha==0) begin
                if(sclk==cpol) 
                    mosi<=shift_tx[7];
                else begin
                    shift_rx<={shift_rx[6:0],miso};
                    shift_tx<={shift_tx[6:0],1'b0};
                    if(bit_cnt==0)
                        state<=FINISH;
                    else bit_cnt<=bit_cnt-1;
                    end 
              end
              else begin
                if(sclk!=cpol) begin
                    shift_rx<={shift_rx[6:0],miso};
                    shift_tx<={shift_tx[6:0],1'b0};
                    if(bit_cnt==0) state<=FINISH;
                    else bit_cnt<=bit_cnt-1;
                    end
                else mosi<=shift_tx[7];
                end
            end
    FINISH: begin
            rx_data<=shift_rx;
            done<=1;
            cs<=1;
            busy<=0;
            sclk<=cpol;
            state<=IDLE;
            end
        endcase
      end end
endmodule
