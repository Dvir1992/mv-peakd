class monitor_pd extends uvm_monitor;
  `uvm_component_utils(monitor_pd)
  uvm_analysis_port #(transaction) send_pd;// Broadcasts a value to all subscribers implementing a uvm_analysis_imp.
virtual s_if vsif;
transaction t;



 
  function new(input string inst = "monitor_pd", uvm_component parent = null);
    super.new(inst,parent); 
    send_pd = new("send_pd",this);
    `uvm_info("Mon_Pd","mon_pd_built",UVM_LOW)
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    t = transaction::type_id::create("M_PD_TRANS");    
    if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
      `uvm_error("MON_PD", "Unable to access Interface");
  endfunction
 
virtual task run_phase(uvm_phase phase);
   forever begin
     @(posedge vsif.clk or posedge vsif.peak_valid);
     if(vsif.peak_valid)begin
     	#1;
       t.peak_info.push_back(vsif.peak_info);//data out of the peak detection block is sent to the  scoreboard transaction from the time peak_valid is up until it is down,each clock.
     end
     else begin
    	send_pd.write(t);
        t.peak_info.delete();
     end
   end

 
  
endtask
 

endclass
