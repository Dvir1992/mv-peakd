`include "pd_mavg_aex_includes.v"

interface s_if;
  
  logic clk;  
  logic reset_n;
  logic start_act;
  logic start_act_pd;
  logic  movavg_en;
  logic vald_din;
  logic [`DATAWIDTH-1:0] data_in;
  logic [1:0]  movavgwin_param; 
  logic pdet_en; 
  logic [`DATAWIDTH-1:0] peaktreshold_param;
  logic inverse_data_out;
  logic aex_dbg_en;
  logic [`PIXEL_WIDTH-1:0] active_columns_start;
  logic [`DATAWIDTH-1:0] peak_info;
  logic peak_valid;
  
  logic [`DATAWIDTH-1:0] mv_data_out;
  logic mv_valid_out;


 
endinterface
