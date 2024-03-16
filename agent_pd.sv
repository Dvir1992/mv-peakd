class agent_pd extends uvm_agent;
  `uvm_component_utils(agent_pd)
  monitor_pd m_pd;
  uvm_factory factory;
 
  function new(string inst = "agent_pd", uvm_component parent = null);
    super.new(inst,parent);
  endfunction
 

  
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    `uvm_info("AGENT_PD","agent_pd_built",UVM_LOW)
    if(!uvm_config_db#( uvm_factory)::get(this,"","factory",factory))
      `uvm_error("AGN_PD", "Unable to access factroy");
    m_pd = monitor_pd::type_id::create("m_pd",this);
    
  endfunction
 


endclass
  

