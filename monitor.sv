class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
 uvm_analysis_port #(transaction) send;
virtual s_if vsif;
transaction t;



 
  function new(input string inst = "monitor", uvm_component parent = null);
    super.new(inst,parent); 
    send = new("send",this);
    `uvm_info("Mon","mon_built",UVM_LOW)
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    t = transaction::type_id::create("M_TRANS");    
    if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
  		`uvm_error("MON", "Unable to access Interface");
  endfunction
 
virtual task run_phase(uvm_phase phase);
   forever begin
    @(posedge vsif.clk)
     #1;
    t.data_out=vsif.mv_data_out;// data out of the moving average block is sent to the scoreboard transaction each clock.
    send.write(t);
   end

 
  
endtask
 

endclass
