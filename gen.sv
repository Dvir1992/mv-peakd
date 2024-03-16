class generator extends uvm_sequence#(transaction);
`uvm_object_utils(generator)
 rand integer frames;
 rand integer rows;
  
  function new(string inst = "generator");
  super.new(inst);
    `uvm_info("GEN","generator_built",UVM_LOW)
  endfunction

 
  virtual task body();
    req = transaction::type_id::create("GEN_TRANS");  
    for (int i=0; i<frames; i++) begin
      for (int j=0; j<rows; j++) begin
   	 	start_item(req);       
        req.randomize() with {frame==i;row==j;};//After this row, the sequence_item(req, in this case) is passed to the sequencer REQ fifo. It means that if the driver calls for an item (get_next_itme()), he can get one.
		req.print();        
        finish_item(req); //this code line will end only after the item_done from the driver.
    end     
   end
 endtask
  
endclass

