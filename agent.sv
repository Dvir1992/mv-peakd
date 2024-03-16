class agent extends uvm_agent;
`uvm_component_utils(agent)
  monitor m;
  driver d;
  uvm_sequencer #(transaction) seqr;
  uvm_factory factory;
 
  function new(string inst = "agent", uvm_component parent = null);
    super.new(inst,parent);
  endfunction
 

  
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    `uvm_info("AGENT","agent_built",UVM_LOW)
    if(!uvm_config_db#( uvm_factory)::get(this,"","factory",factory))
      `uvm_error("AGN", "Unable to access factroy");
    m = monitor::type_id::create("m",this);
    d = driver::type_id::create("d",this);
    seqr = uvm_sequencer #(transaction)::type_id::create("seqr",this);      
 
  endfunction
 
  virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass
  


