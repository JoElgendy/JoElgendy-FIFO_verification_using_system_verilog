package FIFO_transaction_pkg;
    import shared_pkg::*;

    class FIFO_transaction;

        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        integer RD_EN_ON_DIST , WR_EN_ON_DIST;


        function new (input integer arg_1 = 30 , input integer arg_2 = 70);
            RD_EN_ON_DIST = arg_1;
            WR_EN_ON_DIST = arg_2;
        endfunction

        constraint rst_con {
            rst_n dist {0:=2 , 1:=98} ;
        }
        
        constraint wr_con {
            wr_en dist {0:= 100-WR_EN_ON_DIST  , 1:=WR_EN_ON_DIST};
        }

        constraint rd_con {
            rd_en dist {0:= 100-RD_EN_ON_DIST  , 1:=RD_EN_ON_DIST};
        }  

    endclass
endpackage