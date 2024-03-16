//the transcation which is used for test_both.
`include "pd_mavg_aex_includes.v"

class transaction_both extends transaction;
  rand int window_start;
  rand int window_end;

 


  
  function new(string inst = "transaction_both");
    super.new(inst);
    c=both;
    `uvm_info("TRANS_PD","trans_pd_built",UVM_LOW)
  endfunction
  
  constraint window{
    window_start inside {[0:(row_width-10)]};
    window_end inside {[window_start:row_width]};


   
  }
  
  constraint p_data{
    foreach(data_in[i]){
      if(i>=window_start&&i<=window_end)
        data_in[i]>=peak_param;
      else
        data_in[i]<peak_param;
      
    }
    
  }
  

      `uvm_object_utils_begin(transaction_both)
    `uvm_field_int(window_start,UVM_ALL_ON)
    `uvm_field_int(window_end,UVM_ALL_ON)
  `uvm_object_utils_end
endclass

