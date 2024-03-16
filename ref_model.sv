//ref model for the moving average block.
class ref_model extends uvm_component;
	
  `uvm_component_utils(ref_model)
   virtual s_if vsif;  
   integer i=0;
   integer j=0;
   integer pixel_value=0;
   integer pixel_counter=0;
   transaction t;
  function new(input string inst = "ref_model", uvm_component parent = null);
    super.new(inst,parent); 
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);    
    `uvm_info(get_type_name(), $sformatf("ref_model_built"), UVM_LOW);
    if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
      `uvm_error("RM", "Unable to access Interface");
    t = transaction::type_id::create("R_TRANS");
   endfunction

  
virtual task run_phase(uvm_phase phase);    
  fork
      begin
        forever begin
          @(posedge vsif.vald_din);
          t.movavgwin_param=vsif.movavgwin_param; 
          // `uvm_info("mv param",$sformatf("mv param is is:%h",t.movavgwin_param),UVM_LOW)    
        end
      end
      
      begin
        forever begin
          @(posedge vsif.clk or posedge vsif.vald_din);
          if(vsif.vald_din)begin
            #1;
        	t.data_in.push_back(vsif.data_in);	
           //`uvm_info("data_in",$swriteh("data in is:%p",t.data_in),UVM_LOW)
          //  $displayh("data in is:%p",t.data_in);
          end
        end
      end

      begin
       forever begin        
         @(posedge vsif.clk or posedge vsif.mv_valid_out);
         #1;
         if(vsif.movavg_en) begin
         	if(vsif.mv_valid_out) begin
          	 if(pixel_counter<(2**(t.movavgwin_param+1)-1))begin
             	t.data_out=0;
             	pixel_counter++; 
           	 end           
          	 else begin      
             	pixel_value=0;
             	for(int i=j; i<2**(t.movavgwin_param+1)+j; i++) begin
               		pixel_value=(pixel_value+t.data_in[i]);
            	    //  $display("i=%d,j=%d,data_in=%h",i,j,t.data_in[i]);
             	end
             	pixel_value=pixel_value/(2**(t.movavgwin_param+1));
             	t.data_out=pixel_value; 
             	j++;                       
             end 
            end
           else
             t.data_out=0;
         end
         else
           t.data_out=vsif.data_in;
         //$display("%t:data_out=%h",$time,t.data_out);
      end        
     end
        begin
         forever begin
           @(negedge vsif.mv_valid_out);           
            pixel_counter=0;
            t.data_in.delete();
            j=0;
         end
      end
            
    
    join

    


  
  
  
endtask
  
endclass
