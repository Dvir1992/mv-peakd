//A top design that contains the moving_average, the peak_detector blocks and the wires between them.
`include "pd_mavg_aex_includes.v"
`include "moving_average.v"
`include "peak_detector.v"

module top(
  clk,
  reset_n,
  start_act,
  movavg_en,
  vald_din,
  data_in,
  movavgwin_param,
  pdet_en,
  peaktreshold_param,
  inverse_data_out,
  aex_dbg_en,
  active_columns_start,
  peak_info,
  peak_valid
);
//mvg 
input clk;
input reset_n;
input start_act; // start the action
input movavg_en; // en the block 
input vald_din; // valid data input
input [`DATAWIDTH-1:0] data_in; // data input
input [1:0] movavgwin_param; // moving average window value = 2,4,8,16
  
//common
wire [`DATAWIDTH-1:0] data_out; // data output of the filter
wire valid_out; //  data valid from filter
  
  
//pd
input pdet_en;
input [`DATAWIDTH-1:0] peaktreshold_param; //   check for signal treshold value
input inverse_data_out; 
input aex_dbg_en;
input [9:0] active_columns_start;
wire start_act_pd;



  
output [`DATAWIDTH-1:0] peak_info; // the peak index,max value,source (derivate,simple)  
output peak_valid; //  peak found above secdevmax_param or simple peak 
  



  movavg_fltr mvg(
    .clk(clk),
    .reset_n(reset_n),
    .start_act(start_act),
    .movavg_en(movavg_en),
    .vald_din(vald_din),
    .data_in(data_in),
    .movavgwin_param(movavgwin_param),
    .data_out(data_out),
    .valid_out(valid_out)
  );
  
  peak_detector pd(
    .clk(clk),
    .reset_n(reset_n),
    .start_act(start_act_pd),
    .vald_data(valid_out),
    .data_in(data_out),
    .pdet_en(pdet_en),
    .peaktreshold_param(peaktreshold_param),
    .inverse_data_out(inverse_data_out),
    .aex_dbg_en(aex_dbg_en),
    .active_columns_start(active_columns_start),
    .peak_info(peak_info),
    .peak_valid(peak_valid)  
  );
  
endmodule
