module FIFO_top ();
    bit clk ;
    always #1 clk =! clk ;

    FIFO_interface FIFO_if (clk);
    FIFO my_FIFO (FIFO_if);
    FIFO_tb my_tb (FIFO_if);
    FIFO_monitor my_monitor (FIFO_if);
    
endmodule