`uvm_analysis_imp_decl(_mv)
`uvm_analysis_imp_decl(_pd)

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
 
uvm_analysis_imp_mv #(transaction,scoreboard) mv;
uvm_analysis_imp_pd #(transaction,scoreboard) pd;
ref_model rm;
ref_model_pd rm_pd;
integer row_counter;
bit done=0;

  
  function new(input string inst = "SCO", uvm_component parent);
    super.new(inst,parent);
    mv = new("mv",this);
    pd =new("pd",this);

endfunction
  

 
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB","scb_built",UVM_LOW)
     rm= ref_model::type_id::create("rm",this);
    rm_pd= ref_model_pd::type_id::create("rm_pd",this);
  endfunction
  
 
  
  virtual function void write_mv(transaction t);// checks the data out of the moving average block.
    if(rm.t.data_out!=t.data_out)
      `uvm_error("scoreboard", $sformatf("%t:exp_data_mv=%h,real_data_mv=%h:",$time,rm.t.data_out,t.data_out))   
  endfunction
  
      virtual function void write_pd(transaction t);// checks the data out of the peak detection block.
    int val_ref;
    int val_real;
    while (rm_pd.t.peak_info.size()!=0)begin
      val_ref=rm_pd.t.peak_info.pop_front();
      val_real=t.peak_info.pop_front();
      if(val_ref!=val_real)
        `uvm_error("scoreboard", $sformatf("%t:exp_data_pd=%h,real_data_pd=%h:",$time,val_ref,val_real))
    end
      
  
  endfunction
  //we use the phase_ready_to_end function to give time to the output creation before the simulation ends. 
  virtual function void phase_ready_to_end (uvm_phase phase);
    if(done)
      return;//phase_ready_to_end run 20 times if you raise and drop objection every time. So I used "done" to limit the  delay task to one time.
      if (phase.get_name != "post_shutdown")
      	return;
      phase.raise_objection(this);
     fork
       delay(phase);  
     join_none
   
 endfunction
  
  task delay(uvm_phase phase);
	#20;
    phase.drop_objection(this);
    done=1;
  endtask
  
endclass
