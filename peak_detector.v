//// peak deatector  find the index of signal peak with centroid algoritem 
`include "NS_DW02_mult.v"
`include "NS_DW01_add.v"
module peak_detector(
                  // inputs
                  clk, // pclk , must work between frams gap  at least 7 pclk cycles
                  reset_n,
                  start_act, // start puls , clear all caculation for next frame, must be act before valid data
                  vald_data, // sign for valid input data
                  data_in, // pixels data
                  pdet_en, // disable/enable block

                  peaktreshold_param, // parameter , above it peaks will be detected 
                  inverse_data_out, // max opeak value inverse
                  aex_dbg_en, // add on peak valid clk for dbg
                  active_columns_start, // woi for pixels used for dark pixel active/no active

                  // outputs
                  peak_info, // the peak index,max value,source (derivate,simple)
                  peak_valid // when high , peak index is on dout

                    ); 

parameter A_width = `DATAWIDTH+1;
parameter B_width = `DATAWIDTH+1;
parameter widthm = 31;
parameter dly_after_rdy_down = 2;

input clk;
input reset_n;
input start_act; // start the action on each frame 
input vald_data; // valid data input
input [`DATAWIDTH-1:0] data_in; // data input
input pdet_en;
input [`DATAWIDTH-1:0] peaktreshold_param; //   check for signal treshold value
input inverse_data_out; 
input aex_dbg_en;
input [9:0] active_columns_start;

output [`DATAWIDTH-1:0] peak_info; // the peak index,max value,source (derivate,simple)  
output peak_valid; //  peak found above secdevmax_param or simple peak 

wire [`DATAWIDTH-1:0] peaktreshold_inversed_lcl;
wire [`DATAWIDTH-1:0] peaktreshold_inversed;
reg [`DATAWIDTH-1:0] peak_info;
reg peak_valid;
reg [`INDEX_WIDTH-1:0] index_in;
reg [3:0] info_count;
reg [`DATAWIDTH-1:0] data_detection; 
wire en_treshfiltr;
wire [A_width+B_width-1:0]   mult_result;
wire [widthm-1 : 0] addm_result;
reg [widthm-1 : 0] saved_addm_result;
wire [widthm-1 : 0] addn_result;
reg [widthm-1 : 0] saved_addn_result;
reg vald_data_dly;
wire index_start;
wire index_stop;

assign peaktreshold_inversed_lcl = inverse_data_out ? peaktreshold_param : ~peaktreshold_param; 

assign peaktreshold_inversed = peaktreshold_inversed_lcl;


// index of data input
always @(posedge clk or negedge reset_n)
      if (reset_n == 1'b0) 
        index_in <= `INDEX_WIDTH'h000;
      else
       if ((index_start == 1'b1) && (pdet_en == 1'b1))
        index_in <= active_columns_start+1'b1;
       else
         if (index_stop == 1'b1)
            index_in <= `INDEX_WIDTH'h000;
         else
          if (index_in != `INDEX_WIDTH'h000)
            index_in <= index_in + 1'b1;
          else
            index_in <= index_in; 

always @(posedge clk or negedge reset_n)
      if (reset_n == 1'b0) 
        vald_data_dly <= 1'b0;
      else
       vald_data_dly <= vald_data;

assign index_start = vald_data && ~vald_data_dly;
assign index_stop = ~vald_data && vald_data_dly;



//----------------------------------------------------------------------------------------------
//  centroid algoritem = (a1*i1 + a2*i2.... a1000*i1000)/(a1+a2+....a1000)
//----------------------------------------------------------------------------------------------
// put 0 in all data under peaktreshold parameter
always @(posedge clk or negedge reset_n)
      if (reset_n == 1'b0) begin 
         data_detection <= `DATAWIDTH'h000;
      end
      else
      if (start_act == 1'b1) begin
         data_detection <= `DATAWIDTH'h000;
      end
      else 
         if ((pdet_en  == 1'b1) && (vald_data == 1'b1)) begin  
            data_detection <= en_treshfiltr ? data_in : `DATAWIDTH'h000;
         end
         else
           begin
            data_detection <= `DATAWIDTH'h000;
           end

 assign en_treshfiltr = (data_in >= peaktreshold_inversed); 

// multiply index by intensity - 13 bits input
NS_DW02_mult #(A_width, B_width) mult_inst ( .A({2'b0,data_detection}), .B({2'b00,index_in}), .TC(1'b0), .PRODUCT(mult_result) );


// add multiply results - 31 bits input - 31 bits out plus carry 
NS_DW01_add  #(widthm) addm_ins (.A({5'h00,mult_result}), .B(saved_addm_result), .CI(1'b0), .SUM(addm_result), .CO() );

// add intensity - 31 bits input - 31 bits output plus carry 
NS_DW01_add #(widthm) addn_ins (.A({19'h00000,data_detection}), .B(saved_addn_result), .CI(1'b0), .SUM(addn_result), .CO() );

// sample added results
always @(posedge clk or negedge reset_n)
      if (reset_n == 1'b0) begin 
        saved_addm_result <= 31'h000000;
        saved_addn_result <= 31'h000000;
      end
      else
      if (start_act == 1'b1) begin 
        saved_addm_result <= 31'h000000;
        saved_addn_result <= 31'h000000;
      end
      else begin
        saved_addm_result <= addm_result; 
        saved_addn_result <= addn_result; 
      end

//-----------------------------------------------------------------------

// count clk after rdy went down for peak info insersion
always @(posedge clk or negedge reset_n)
      if (reset_n == 1'b0)
        info_count <= 4'hf;
      else
        if (vald_data == 1'b1)
          info_count <= 4'h0;
        else
         if (info_count == 4'hf)
          info_count <= info_count;
         else
          info_count <= info_count + 1'b1;


// send out information
always @(posedge clk or negedge reset_n)
      if (reset_n == 1'b0) begin
        peak_info <= `DATAWIDTH'h0; 
        peak_valid <= 1'b0;
      end
      else
          case(info_count)
           dly_after_rdy_down:  begin
                                  peak_info <= {2'h0,saved_addm_result[9:0]};
                                  peak_valid <= 1'b1;
                                end
           dly_after_rdy_down+1: begin
                                  peak_info <= {2'h0,saved_addm_result[19:10]};
                                  peak_valid <= 1'b1;
                                end
           dly_after_rdy_down+2: begin
                                  peak_info <= {2'h0,saved_addm_result[29:20]};
                                  peak_valid <= 1'b1;
                                end
           dly_after_rdy_down+3:  begin
                                  peak_info <= {2'h0,saved_addn_result[9:0]};
                                  peak_valid <= 1'b1;
                                end
           dly_after_rdy_down+4: begin
                                  peak_info <= {2'h0,saved_addn_result[19:10]};
                                  peak_valid <= 1'b1;
                                end
           dly_after_rdy_down+5: begin
                                  peak_info <= {2'h0,saved_addn_result[29:20]};
                                  peak_valid <= 1'b1;
                                end
           default:             begin
                                  peak_info <= `DATAWIDTH'h0;
                                  peak_valid <= 1'b0;
                                end
          endcase


           

endmodule
