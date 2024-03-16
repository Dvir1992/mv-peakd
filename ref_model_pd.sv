//ref model  for the peak detection block.
class ref_model_pd extends uvm_component;
	
  `uvm_component_utils(ref_model_pd)
   virtual s_if vsif;  
   integer pixel_counter=0;
   transaction t;
   integer A=0;
   integer CA=0;
   integer i;
   integer enu1;
   integer enu2;
   integer enu3;
   integer denu1;
   integer denu2;
   integer denu3;
  function new(input string inst = "ref_model_pd", uvm_component parent = null);
    super.new(inst,parent); 
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);    
    `uvm_info(get_type_name(), $sformatf("ref_model_pd_built"), UVM_LOW);
    if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
      `uvm_error("RM_PD", "Unable to access Interface");
    t = transaction::type_id::create("R_PD_TRANS");
   endfunction

  
virtual task run_phase(uvm_phase phase);  
   fork

         
    begin
      forever begin
        @(posedge vsif.clk or posedge vsif.mv_valid_out);
        #1;
        if(vsif.mv_valid_out)begin
          if(vsif.mv_data_out>=vsif.peaktreshold_param)begin
            //$display("peak is:%h\n",vsif.peaktreshold_param);
            //$display("bigger is:%h",vsif.mv_data_out);
            A<=A+vsif.mv_data_out;
            CA<=CA+vsif.mv_data_out*(vsif.active_columns_start+i);
          end
           i=i+1;
        end
        else begin
          i=0;
          
        end
      end
    end
 
    begin
      forever begin
        @(negedge vsif.mv_valid_out);
        $display("A=%h, CA=%h",A,CA);
        $display("%h,%h,%h,%h,%h,%h,",CA[0+:10],CA[10+:10],CA[20+:10],A[0+:10],A[10+:10],A[20+:10]);
        enu1=CA[0+:10];
        enu2=CA[10+:10];
        enu3=CA[20+:10];
        denu1=A[0+:10];
        denu2=A[10+:10];
        denu3=A[20+:10];
        A=0;
        CA=0;
        t.peak_info.delete();
        repeat(3)
          @(posedge vsif.clk);
        t.peak_info.push_back(enu1);
        $display("que is: %p",t.peak_info);
        @(posedge vsif.clk);
        t.peak_info.push_back(enu2);
        $display("que is: %p",t.peak_info);
        @(posedge vsif.clk);
        t.peak_info.push_back(enu3);
        $display("que is: %p",t.peak_info);
        @(posedge vsif.clk);
        t.peak_info.push_back(denu1);
        $display("que is: %p",t.peak_info);
        @(posedge vsif.clk);
        t.peak_info.push_back(denu2);
         $display("que is: %p",t.peak_info);
        @(posedge vsif.clk);
        t.peak_info.push_back(denu3);
        $display("que is: %p",t.peak_info);
        
      end
    end
    
  join
  
endtask
  
endclass
