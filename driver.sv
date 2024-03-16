//The driver- get a specific transaction (it depends on the test name) and the driver move it to the main interface.
class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
 
transaction t;
virtual s_if vsif;
event end_of_data;
integer delay;
uvm_factory factory;

 
  function new(input string inst = "driver", uvm_component parent = null);
    super.new(inst,parent);    

  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRV","drv_built",UVM_LOW)
    t = transaction::type_id::create("D_TRANS"); 
    t.print();
    if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
      `uvm_error("DRV", "Unable to access Interface");
  endfunction
 
  virtual task run_phase(uvm_phase phase);  // each signal in the interface get the data in parallel, by using th join fork model. 
  forever begin
    @(posedge vsif.clk or negedge vsif.reset_n);
    if(!vsif.reset_n)begin
      vsif.start_act <= 0;
      vsif.movavg_en <= 0;
      vsif.vald_din<=0;
      vsif.data_in<=0;
      vsif.movavgwin_param<=0;
      vsif.pdet_en<=0;
      vsif.peaktreshold_param<=0;
      vsif.aex_dbg_en<=0;
      vsif.active_columns_start<=0;      
    end 
    else begin
      seq_item_port.get_next_item(t);

      fork
        begin
          case(t.c)
          mv:
            begin
          		vsif.movavg_en<=1;
                vsif.pdet_en<=0;
                @(negedge vsif.vald_din);
          		@(posedge vsif.clk);
          		@(posedge vsif.clk);
         		vsif.movavg_en<=0;
         		repeat($urandom_range(0,10))
           		  @(posedge vsif.clk);    
            end
          pd:
            begin
              vsif.movavg_en<=0;
              vsif.pdet_en<=1;
          	  @(negedge vsif.vald_din);
              repeat(9)
               @(posedge vsif.clk);    
         	  vsif.pdet_en<=0;
         	  repeat($urandom_range(0,10))
           		@(posedge vsif.clk);   
              
            end
          both:
            begin
              vsif.movavg_en<=1;
              vsif.pdet_en<=1;
              @(negedge vsif.vald_din);
              repeat(11)
               @(posedge vsif.clk);  
            end
            
          endcase
         
        end
      	begin
          vsif.start_act<=t.start_act;
          @(posedge vsif.clk);
            vsif.start_act<=0;          
        end
        begin
          if(t.start_act)
          	if(t.c==pd)
            	vsif.start_act_pd<=1;
          	else begin           
              @(posedge vsif.mv_valid_out);
             	vsif.start_act_pd<=1;           
         	end
            @(posedge vsif.clk);
            vsif.start_act_pd<=0;          
        end
        begin
          @(posedge vsif.mv_valid_out);
         vsif.peaktreshold_param<=t.peak_param;
        end
          
        begin
          repeat(t.row_width)begin
            vsif.vald_din<=1;  
          	@(posedge vsif.clk);
          end
          vsif.vald_din<=0;         
        end
        begin
          while(t.data_in.size()>0) begin
            vsif.data_in<=t.data_in.pop_back();
            @(posedge vsif.clk);            
          end        
        end 
        begin
          vsif.movavgwin_param<=t.movavgwin_param;
        end
      join 
      seq_item_port.item_done();
    end   
  end

endtask
 
endclass
