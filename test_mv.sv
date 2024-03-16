//in this test only the moving average block is active and transaction data is sent inside the design.
class test_mv extends uvm_test;
  
  `uvm_component_utils(test_mv)
   env e;
   generator gen;
   virtual s_if vsif;
  function new(string inst="test_mv", uvm_component parent = null);
    super.new(inst,parent);//get the uvm_test characteristics

  endfunction
  

  
 
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_MV","test_mv_built",UVM_LOW)
     e = env::type_id::create("e",this);
     gen = generator::type_id::create("gen"); 
     if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
      `uvm_error("DRV", "Unable to access Interface");    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);//we use objection to prevent the test from ending.
    gen.randomize() with {frames==4;rows==3;};// we want to test the block on 4 frames. each frame has 3 data rows.
    gen.start(e.a.seqr);
    phase.drop_objection(this);
  endtask
endclass
 
  
