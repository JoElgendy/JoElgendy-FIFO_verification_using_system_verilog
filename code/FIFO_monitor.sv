import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
module FIFO_monitor (FIFO_interface.MONITOR FIFO_if);
    FIFO_transaction trans  = new ;
    FIFO_scoreboard  score  = new ;
    FIFO_coverage  coverage = new ;

    initial begin
        forever begin
            wait (done.triggered);
             @(negedge FIFO_if.clk)                  ;

            trans.data_in     = FIFO_if.data_in     ;
            trans.rst_n       = FIFO_if.rst_n       ;
            trans.wr_en       = FIFO_if.wr_en       ;
            trans.rd_en       = FIFO_if.rd_en       ;
            trans.data_out    = FIFO_if.data_out    ;
            trans.wr_ack      = FIFO_if.wr_ack      ;
            trans.overflow    = FIFO_if.overflow    ;
            trans.full        = FIFO_if.full        ;
            trans.empty       = FIFO_if.empty       ;
            trans.almostfull  = FIFO_if.almostfull  ;
            trans.almostempty = FIFO_if.almostempty ;
            trans.underflow   = FIFO_if.underflow   ;
            fork
                begin
                    coverage.sample_data(trans);
                end
                begin
                    score.check_data(trans);
                end
            join

            if(test_finished) begin
                $display("Finished Successfully");
                $display("Error count = %0d , correct count = %0d" , error_count , correct_count);
                $stop;
            end  
        end

    end

endmodule