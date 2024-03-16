//main scope- testbench and all relevant sv files.
`include "uvm_macros.svh"
 import uvm_pkg::*;
typedef enum{mv,pd,both} c_on;// the value that c_on will get will determine the active blocks in the design.
`include "s_if.sv"
`include "transaction.sv"
`include "transaction_pd.sv"
`include "transaction_both.sv"
`include "monitor.sv"
`include "driver.sv"
`include "monitor_pd.sv"
`include "agent.sv"
`include "agent_pd.sv"
`include "ref_model.sv"
`include "ref_model_pd.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "gen.sv"
`include "test_pd.sv"
`include "test_mv.sv"
`include "test_both.sv"




module testbench;
  
  s_if sif();//physical interface
  top t(    //main design instantiation.
    .clk(sif.clk),
    .reset_n(sif.reset_n),
    .start_act(sif.start_act),
    .movavg_en(sif.movavg_en),
    .vald_din(sif.vald_din),
    .data_in(sif.data_in),
    .movavgwin_param(sif.movavgwin_param),
    .pdet_en(sif.pdet_en),
    .peaktreshold_param(sif.peaktreshold_param),
    .inverse_data_out(sif.inverse_data_out),
    .aex_dbg_en(sif.aex_dbg_en),
    .active_columns_start(sif.active_columns_start),
    .peak_info(sif.peak_info),
    .peak_valid(sif.peak_valid)
  );
  
  assign sif.mv_data_out= t.data_out;//move data from moving average block to peak detection block.
  assign sif.mv_valid_out=t.valid_out;//move valid signal from moving average block to peak detection block.
  assign t.start_act_pd=sif.start_act_pd;// start_act is high when a new frame started. start_act_pd acts the same beside a 0-2 delay clocks. 
 
  
  
  initial begin 
    sif.clk=0;//reset all signals to default value.
    sif.reset_n=0;
    sif.start_act=0;
    sif.movavg_en=0;
    sif.vald_din=0;
    sif.data_in=0;
    sif.movavgwin_param=0;
    sif.pdet_en=0;
    sif.peaktreshold_param=0;
    sif.inverse_data_out=1;
    sif.aex_dbg_en=0;
    sif.active_columns_start=0;
    sif.start_act_pd=0;
    #50;
    sif.reset_n=1; 
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  always#5 sif.clk= ~sif.clk;//create the main clock.
  
  initial begin
    uvm_factory factory;
    factory = uvm_factory::get();// we use this to see the factory data through the simulation.
    uvm_config_db #(virtual s_if) :: set(null, "*", "vsif", sif);//move virtual interface between components.
    uvm_config_db #(uvm_factory) :: set(null, "*", "factory", factory);
   `uvm_info("TB","start running",UVM_LOW)
    run_test("test_pd");//we can run 3 different tests: "test_both","test_pd","test_mv".
  
  end
endmodule
