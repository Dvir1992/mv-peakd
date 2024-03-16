//in this test only the peak detection block is active and transaction_pd data is sent inside the design.
class test_pd extends uvm_test;
  
  `uvm_component_utils(test_pd)
   env e;
   generator gen;

  function new(string inst="test_pd", uvm_component parent = null);
    super.new(inst,parent);//get the uvm_test characteristics
  endfunction
  
 
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     `uvm_info("TEST_PD","test_pd_built",UVM_LOW)
     set_type_override_by_type(transaction::get_type(), transaction_pd::get_type());
     e = env::type_id::create("e",this);
     gen = generator::type_id::create("gen");      
  endfunction
  
  virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
    gen.randomize() with {frames==2;rows==7;};// we want to test the block on 2 frames. each frame has 7 data rows.
    gen.start(e.a.seqr);
   phase.drop_objection(this);
  endtask
endclass
 
  
