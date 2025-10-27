import shared_pkg::*;

module FIFO(FIFO_interface.DUT FIFO_if);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

bit [max_fifo_addr-1:0] wr_ptr, rd_ptr;
bit [max_fifo_addr:0] count;

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		wr_ptr  <= 0;
		FIFO_if.overflow <= 0;
		FIFO_if.wr_ack <= 0 ;
	end
	else if (FIFO_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFO_if.data_in;
		FIFO_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		FIFO_if.overflow <= 0;
	end
	else begin 
		FIFO_if.wr_ack <= 0; 
		if (FIFO_if.full & FIFO_if.wr_en)
			FIFO_if.overflow <= 1;
		else
			FIFO_if.overflow <= 0;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		rd_ptr <= 0;
		FIFO_if.underflow <= 0 ;
		FIFO_if.data_out <= 0;
	end 
	else if (FIFO_if.rd_en && count != 0) begin
		FIFO_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		FIFO_if.underflow <= 0 ;
	end else begin 
		if (FIFO_if.rd_en & FIFO_if.empty)
			FIFO_if.underflow <= 1;
		else
			FIFO_if.underflow <= 0;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b10) && !FIFO_if.full) begin
				count <= count + 1;
		end else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b01) && !FIFO_if.empty) begin
    			count <= count - 1;
		end else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.empty) begin
  			count <= count + 1;
		end  else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.full) begin
  			count <= count - 1;
		end 
	end
end

assign FIFO_if.full =   (count == FIFO_DEPTH)? 1 : 0;
assign FIFO_if.empty =  (count == 0)? 1 : 0;
assign FIFO_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign FIFO_if.almostempty =  (count == 1)? 1 : 0;





`ifdef SIM
	always_comb begin
		if(!FIFO_if.rst_n)
		rst_assert: assert final(FIFO_if.data_out === 0 && wr_ptr ===0 && rd_ptr ===0 && count === 0)
			else $error("Assertion reset failed!");
	end
		
	property wr_ack_prop ;
		@(posedge FIFO_if.clk) disable iff (!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full) |=> FIFO_if.wr_ack ;
	endproperty

	property overflow_prop ;
		@(posedge FIFO_if.clk)disable iff (!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.full) |=> FIFO_if.overflow ;
	endproperty

	property underflow_prop ;
		@(posedge FIFO_if.clk)disable iff (!FIFO_if.rst_n) (FIFO_if.rd_en && FIFO_if.empty) |=> FIFO_if.underflow ;
	endproperty

	property empty_prop ;
		@(posedge FIFO_if.clk)disable iff (!FIFO_if.rst_n) (count === 0) |-> FIFO_if.empty ;
	endproperty

	property full_prop ;
		@(posedge FIFO_if.clk)disable iff (!FIFO_if.rst_n) (count === FIFO_DEPTH) |-> FIFO_if.full ;
	endproperty

	property almostfull_prop ;
		@(posedge FIFO_if.clk)disable iff (!FIFO_if.rst_n) (count === FIFO_DEPTH-1) |-> FIFO_if.almostfull ;
	endproperty

	property almostempty_prop ;
		@(posedge FIFO_if.clk)disable iff (!FIFO_if.rst_n) (count === 1) |-> FIFO_if.almostempty ;
	endproperty

	property rd_wrap_around_prop ;
		@(posedge FIFO_if.clk)disable iff (!FIFO_if.rst_n) (rd_ptr === FIFO_DEPTH-1 && FIFO_if.rd_en && !FIFO_if.empty) |=> (rd_ptr === 0) ;
	endproperty

	property wr_wrap_around_prop ;
		@(posedge FIFO_if.clk)disable iff (!FIFO_if.rst_n) (wr_ptr === FIFO_DEPTH-1 && FIFO_if.wr_en && !FIFO_if.full) |=> (wr_ptr === 0) ;
	endproperty

	property pointer_threshold_prop ;
		@(posedge FIFO_if.clk) (wr_ptr < FIFO_DEPTH && rd_ptr < FIFO_DEPTH && count <= FIFO_DEPTH ) ;
	endproperty


	wr_ack_assertion : assert property (wr_ack_prop)
		else $error("Assertion wr_ack failed!");
	overflow_assertion : assert property (overflow_prop)
		else $error("Assertion overflow failed!");
	undeflow_assertion : assert property (underflow_prop)
		else $error("Assertion undeflow failed!");
	empty_assertion : assert property (empty_prop)
		else $error("Assertion empty failed!");
	full_assertion : assert property (full_prop)
		else $error("Assertion full failed!");
	almostfull_assertion : assert property (almostfull_prop)
		else $error("Assertion almostfull failed!");
	almostempty_assertion : assert property (almostempty_prop)
		else $error("Assertion almostempty failed!");
	rd_wrap_around_assertion : assert property (rd_wrap_around_prop)
		else $error("Assertion rd_wrap failed!");
	wr_wrap_around_assertion : assert property (wr_wrap_around_prop)
		else $error("Assertion wr_wrap failed!");
	pointer_threshold_assertion : assert property (pointer_threshold_prop)
		else $error("Assertion pointer_threshold failed!");

	wr_ack_cover            : cover property (wr_ack_prop)            ;            
	overflow_cover          : cover property (overflow_prop)          ;               
	undeflow_cover          : cover property (underflow_prop)         ;                      
	empty_cover             : cover property (empty_prop)             ;                       
	full_cover              : cover property (full_prop)              ;                        
	almostfull_cover        : cover property (almostfull_prop)        ;                          
	almostempty_cover       : cover property (almostempty_prop)       ;                      
	rd_wrap_around_cover    : cover property (rd_wrap_around_prop)    ;                       
	wr_wrap_around_cover    : cover property (wr_wrap_around_prop)    ;                   
	pointer_threshold_cover : cover property (pointer_threshold_prop) ;                  
`endif


endmodule

