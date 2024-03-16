//in this test  the moving average block and the peak detection blocks are active and transaction_both data is sent inside the block.
class test_both extends uvm_test;
  
  `uvm_component_utils(test_both)
   env e;
   generator gen;
   virtual s_if vsif;
  function new(string inst="test_both", uvm_component parent = null);
    super.new(inst,parent);//get the uvm_test characteristics

  endfunction
  

  
 
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_BOTH","test_both_built",UVM_LOW)
    set_type_override_by_type(transaction::get_type(), transaction_both::get_type());
     e = env::type_id::create("e",this);
     gen = generator::type_id::create("gen"); 
     if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
      `uvm_error("DRV", "Unable to access Interface");    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
    gen.randomize() with {frames==2;rows==2;};
    gen.start(e.a.seqr);
    phase.drop_objection(this);
  endtask
endclass
 
  
