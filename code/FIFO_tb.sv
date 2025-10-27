import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
module FIFO_tb (FIFO_interface.TEST FIFO_if);

FIFO_transaction myclass = new ;
FIFO_scoreboard myscore = new ;

initial begin
    assert_reset();
        // writing only
     for (int i=0; i<10; i++) begin
            assert(myclass.randomize());
            FIFO_if.data_in = myclass.data_in ;
            FIFO_if.rst_n   = 1   ;
            FIFO_if.wr_en   = 1   ;
            FIFO_if.rd_en   = 0   ;
             -> done ;
            @(negedge FIFO_if.clk);
    end 

    // both reading and writing to check reading only done in 1st cycle
    for (int i=0; i<10; i++) begin
            assert(myclass.randomize());
            FIFO_if.data_in = myclass.data_in ;
            FIFO_if.rst_n   = 1   ;
            FIFO_if.wr_en   = 1   ;
            FIFO_if.rd_en   = 1   ;
             -> done ;
            @(negedge FIFO_if.clk);
    end  
    
       // writing only
     for (int i=0; i<10; i++) begin
            assert(myclass.randomize());
            FIFO_if.data_in = myclass.data_in ;
            FIFO_if.rst_n   = 1   ;
            FIFO_if.wr_en   = 1   ;
            FIFO_if.rd_en   = 0   ;
             -> done ;
            @(negedge FIFO_if.clk);
    end 
    //reading only
    for (int i=0; i<10; i++) begin
            assert(myclass.randomize());
            FIFO_if.data_in = myclass.data_in ;
            FIFO_if.rst_n   = 1   ;
            FIFO_if.wr_en   = 0   ;
            FIFO_if.rd_en   = 1   ;
             -> done ;
            @(negedge FIFO_if.clk);
    end 
   
    // both reading and writing
    for (int i=0; i<10; i++) begin
            assert(myclass.randomize());
            FIFO_if.data_in = myclass.data_in ;
            FIFO_if.rst_n   = 1   ;
            FIFO_if.wr_en   = 1   ;
            FIFO_if.rd_en   = 1   ;
             -> done ;
            @(negedge FIFO_if.clk);
    end 
    // no reading nor writing

     for (int i=0; i<10; i++) begin
            assert(myclass.randomize());
            FIFO_if.data_in = myclass.data_in ;
            FIFO_if.rst_n   = 1   ;
            FIFO_if.wr_en   = 0   ;
            FIFO_if.rd_en   = 0   ;
             -> done ;
            @(negedge FIFO_if.clk);
    end 
   
    // randomize everything

    for (int i=0; i<10000; i++) begin
            assert(myclass.randomize());
            FIFO_if.data_in = myclass.data_in ;
            FIFO_if.rst_n   = myclass.rst_n   ;
            FIFO_if.wr_en   = myclass.wr_en   ;
            FIFO_if.rd_en   = myclass.rd_en   ;
             -> done ;
            @(negedge FIFO_if.clk);
    end 
    // end 
    -> done ;
    test_finished = 1 ;
    
end


task assert_reset();
    FIFO_if.rst_n = 0 ;
    -> done ;
    @(negedge FIFO_if.clk);
    FIFO_if.rst_n = 1 ;
endtask


endmodule