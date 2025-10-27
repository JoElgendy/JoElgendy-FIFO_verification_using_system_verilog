package FIFO_scoreboard_pkg ;
import FIFO_transaction_pkg::*;
import shared_pkg::*;

class FIFO_scoreboard;
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref, overflow_ref ;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref ;
    reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
    reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
    reg [max_fifo_addr:0] count;


task check_data(input FIFO_transaction FIFO_tr);
    reference_model(FIFO_tr);


    if (FIFO_tr.data_out !== data_out_ref) begin
        $display("Error in dataout");
        $stop();
        error_count ++ ;
    end else begin
        correct_count++ ;
    end

    if (FIFO_tr.wr_ack !== wr_ack_ref) begin
        $display("Error in wr_ack");
        $stop();
        error_count ++ ;
    end else begin
        correct_count++ ;
    end
    

    if (FIFO_tr.overflow !==overflow_ref) begin
        $display("Error in overflow");
        $stop();
        error_count ++ ;
    end else begin
        correct_count++ ;
    end

    if (FIFO_tr.full !== full_ref) begin
        $display("Error in full");
        $stop();
        error_count ++ ;
    end else begin
        correct_count++ ;
    end

    if (FIFO_tr.empty !== empty_ref) begin
        $display("Error in empty");
        $stop();
        error_count ++ ;
    end else begin
        correct_count++ ;
    end

    if (FIFO_tr.almostfull !== almostfull_ref) begin
        $display("Error in almostfull");
        $stop();
        error_count ++ ;
    end else begin
        correct_count++ ;
    end

    if (FIFO_tr.almostempty !== almostempty_ref) begin
        $display("Error in almostempty");
        $stop();
        error_count ++ ;
    end else begin
        correct_count++ ;
    end

    
    if (FIFO_tr.underflow !== underflow_ref) begin
        $display("Error in underflow");
        $stop();
        error_count ++ ;
    end else begin
        correct_count++ ;
    end
endtask 





task reference_model(input FIFO_transaction FIFO_tr) ;
    	if (!FIFO_tr.rst_n) begin
    		wr_ptr = 0;
            count  = 0;
            rd_ptr = 0;
            {data_out_ref,wr_ack_ref, overflow_ref ,underflow_ref} = 0;
    	end
    	else  begin
            // writing
            if (FIFO_tr.wr_en && count < FIFO_DEPTH) begin
    		    mem[wr_ptr] = FIFO_tr.data_in;
    		    wr_ack_ref  = 1 ;
            	wr_ptr = wr_ptr + 1;
                overflow_ref = 0;
    	    end else begin 
    		    wr_ack_ref = 0; 
    		    if (full_ref & FIFO_tr.wr_en)
    		    	overflow_ref = 1;
    		    else
    		    	overflow_ref = 0;
    	    end
            // reading 
            if (FIFO_tr.rd_en && count != 0) begin
    		data_out_ref = mem[rd_ptr];
    		rd_ptr = rd_ptr + 1;
            underflow_ref = 0;
    	    end else begin 
		        if (empty_ref && FIFO_tr.rd_en)
		        	underflow_ref = 1;
		        else
		        	underflow_ref = 0;
	        end

            // counting
            if( ({FIFO_tr.wr_en, FIFO_tr.rd_en} == 2'b10) && !full_ref) begin
                if (count < FIFO_DEPTH)
    			    count = count + 1;                   
                end
    		else if ( ({FIFO_tr.wr_en, FIFO_tr.rd_en} == 2'b01) && !empty_ref) begin
    			if (count > 0)
                    count = count - 1;
            end else if ( ({FIFO_tr.wr_en, FIFO_tr.rd_en} == 2'b11) && empty_ref) begin
  			    count = count + 1;
		    end  else if ( ({FIFO_tr.wr_en, FIFO_tr.rd_en} == 2'b11) && full_ref) begin
  			    count = count - 1;
		    end 
        end
        
        
     full_ref = (count == FIFO_DEPTH)? 1 : 0;
     empty_ref = (count == 0)? 1 : 0;
     almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
     almostempty_ref = (count == 1)? 1 : 0;

endtask 
endclass


endpackage