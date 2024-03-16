class env extends uvm_env;
`uvm_component_utils(env)
  
  agent a;
  agent_pd a_pd;
  scoreboard s;
 
  function new(input string inst = "e", uvm_component parent = null);
    super.new(inst,parent);

  endfunction

 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    `uvm_info("Env","env_built",UVM_LOW)
    a = agent::type_id::create("a",this);//this agent is active(contains driver, sequencer and monitor)
    a_pd = agent_pd::type_id::create("a_pd",this);//this agent is passive(only monitor)
    s = scoreboard::type_id::create("s",this);
  endfunction
 

  virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    a.m.send.connect(s.mv);//conect monitor from active agent to scoreboard.
    a_pd.m_pd.send_pd.connect(s.pd);//connect monitor from passive agent to the same socreboard.
  endfunction

endclass
