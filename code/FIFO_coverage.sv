package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn ; 
        covergroup COV_gp ;
        Write_en    : coverpoint F_cvg_txn.wr_en       iff (F_cvg_txn.rst_n) {option.weight =0 ; }
        Read_en     : coverpoint F_cvg_txn.rd_en       iff (F_cvg_txn.rst_n) {option.weight =0 ; } 
        write_ack   : coverpoint F_cvg_txn.wr_ack      iff (F_cvg_txn.rst_n) {option.weight =0 ; } 
        overflow    : coverpoint F_cvg_txn.overflow    iff (F_cvg_txn.rst_n) {option.weight =0 ; } 
        full        : coverpoint F_cvg_txn.full        iff (F_cvg_txn.rst_n) {option.weight =0 ; } 
        empty       : coverpoint F_cvg_txn.empty       iff (F_cvg_txn.rst_n) {option.weight =0 ; } 
        almostfull  : coverpoint F_cvg_txn.almostfull  iff (F_cvg_txn.rst_n) {option.weight =0 ; } 
        almostempty : coverpoint F_cvg_txn.almostempty iff (F_cvg_txn.rst_n) {option.weight =0 ; } 
        underflow   : coverpoint F_cvg_txn.underflow   iff (F_cvg_txn.rst_n) {option.weight =0 ; } 

        cross_wr_rd_wrack       : cross Write_en , Read_en , write_ack   {
            illegal_bins WR0_Ack1 = (binsof(Write_en) intersect {0} && binsof(write_ack) intersect {1});
        }
        cross_wr_rd_overflow    : cross Write_en , Read_en , overflow    {
            illegal_bins WR0_overflow1 = (binsof(Write_en) intersect {0} && binsof(overflow) intersect {1});
        }
        cross_wr_rd_underflow   : cross Write_en , Read_en , underflow   {
            illegal_bins WR0_overflow1 = (binsof(Read_en) intersect {0} && binsof(underflow) intersect {1});
        }
        cross_wr_rd_full        : cross Write_en , Read_en , full        {
            illegal_bins WR0_overflow1 = (binsof(Read_en) intersect {1} && binsof(full) intersect {1});
        }
        cross_wr_rd_empty       : cross Write_en , Read_en , empty       {
            illegal_bins WR0_overflow1 = (binsof(Write_en) intersect {1} && binsof(empty) intersect {1});
        }
        cross_wr_rd_almostfull  : cross Write_en , Read_en , almostfull  ;
        cross_wr_rd_almostempty : cross Write_en , Read_en , almostempty ;
        endgroup

        function new ();
               COV_gp = new() ;         
        endfunction

        function void sample_data(input FIFO_transaction F_txn);
            F_cvg_txn = F_txn ;   
            COV_gp.sample();         
        endfunction

    endclass
endpackage
