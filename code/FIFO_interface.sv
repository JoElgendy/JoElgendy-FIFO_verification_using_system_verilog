import shared_pkg::*;

interface FIFO_interface(clk);

input bit clk ;
logic [FIFO_WIDTH-1:0] data_in;
logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

modport DUT (
input clk ,data_in,rst_n, wr_en, rd_en ,
output wr_ack, full, empty, almostfull, almostempty, underflow ,data_out,overflow
);

modport TEST (
input clk , wr_ack, full , empty, almostfull, almostempty, underflow ,data_out,overflow ,
output data_in , rst_n , wr_en , rd_en 
);

modport MONITOR ( input clk , wr_ack, full , empty, almostfull, almostempty, underflow , data_in , rst_n , wr_en , rd_en ,data_out,overflow );

endinterface 