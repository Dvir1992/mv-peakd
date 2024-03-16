//the transcation which is used for test_mv.
`include "pd_mavg_aex_includes.v"

class transaction extends uvm_sequence_item;
  rand logic start_act;
  rand logic [`DATAWIDTH-1:0] data_in[$];
  rand logic[`PIXEL_WIDTH-1:0] row_width;
  rand logic [1:0] movavgwin_param;
  rand int frame;
  rand int row;
  rand logic [`DATAWIDTH-1:0] peak_param; 
  int last_row;
  int last_row_width;
  int last_param; 
  logic [`DATAWIDTH-1:0] data_out;
  logic [`DATAWIDTH-1:0] peak_info [$:6];
  int x=5;
  int y=10;
  c_on c;
  

  
  function new(string inst = "transaction_mv");
     super.new(inst); 
     c=mv;
    `uvm_info("TRANS_MV","trans_mv_built",UVM_LOW)

  endfunction
 
  function void post_randomize();
    	last_row=row;
    	last_row_width=data_in.size();
    	last_param= movavgwin_param;
    endfunction
 
    constraint frame_start{
    if(row==0)
      start_act==1;
    else
      start_act==0;    
  }
  constraint param{
    movavgwin_param==((last_param+1)%4);
  }
  
    constraint data_size{
      if (last_row<row)
        data_in.size()==last_row_width;
      else
        data_in.size() inside {[50:90]}; 
      row_width==data_in.size();
    
  }


  
   `uvm_object_utils_begin(transaction)
    `uvm_field_int(start_act,UVM_ALL_ON)  
    `uvm_field_queue_int(data_in,UVM_ALL_ON)
    `uvm_field_int(row_width,UVM_ALL_ON)
    `uvm_field_int(movavgwin_param,UVM_ALL_ON)
    `uvm_field_int(frame,UVM_ALL_ON)
    `uvm_field_int(row,UVM_ALL_ON)
     `uvm_field_int(peak_param,UVM_ALL_ON) 
  `uvm_object_utils_end
 

 
endclass

