// filter moving average with window size paramter 2,4,8,16
module movavg_fltr (
                  // inputs
                  clk,
                  reset_n,
                  start_act,
                  movavg_en,
                  vald_din,
                  data_in,
                  movavgwin_param,

                  // outputs
                  data_out,
                  valid_out
                  );
  input clk;
input reset_n;
input start_act; // start the action
input movavg_en; // en the block 
input vald_din; // valid data input
input [`DATAWIDTH-1:0] data_in; // data input
input [1:0] movavgwin_param; // moving average window value = 2,4,8,16

output [`DATAWIDTH-1:0] data_out; // data output of the filter
output valid_out; //  data valid


wire [`DATAWIDTH-1:0] data_out;
reg [`DATAWIDTH-1:0] mem_dly0;
reg [`DATAWIDTH-1:0] mem_dly1;
reg [`DATAWIDTH-1:0] mem_dly2;
reg [`DATAWIDTH-1:0] mem_dly3;
reg [`DATAWIDTH-1:0] mem_dly4;
reg [`DATAWIDTH-1:0] mem_dly5;
reg [`DATAWIDTH-1:0] mem_dly6;
reg [`DATAWIDTH-1:0] mem_dly7;
reg [`DATAWIDTH-1:0] mem_dly8;
reg [`DATAWIDTH-1:0] mem_dly9;
reg [`DATAWIDTH-1:0] mem_dly10;
reg [`DATAWIDTH-1:0] mem_dly11;
reg [`DATAWIDTH-1:0] mem_dly12;
reg [`DATAWIDTH-1:0] mem_dly13;
reg [`DATAWIDTH-1:0] mem_dly14;
reg [`DATAWIDTH-1:0] mem_dly15;
reg vald_dout_dly;
reg vald_dout;
wire valid_out;
reg [15:0] sample_avg;
reg [15:0] added_val;
reg [`DATAWIDTH-1:0] last_data;
wire [`DATAWIDTH-1:0] new_data;
reg [4:0] winavg_size;
reg [`DATAWIDTH-1:0] last_data_int;
reg [10:0] count_pix_num;
wire restart_count;
wire stop_count;

always @(movavgwin_param)
  case(movavgwin_param)
   2'd0: winavg_size = 5'd2;
   2'd1: winavg_size = 5'd4;
   2'd2: winavg_size = 5'd8;
   2'd3: winavg_size = 5'd16;
  endcase


// valid dout signal used for output valid data 
always @(posedge clk or negedge reset_n)
  if (reset_n == 1'b0) begin
     vald_dout_dly <= 1'b0;
     vald_dout <= 1'b0;
  end
   else 
    if (start_act == 1'b1) begin
     vald_dout_dly <= 1'b0;
     vald_dout <= 1'b0;
    end
    else begin
     vald_dout_dly <= vald_din;
     vald_dout <= vald_dout_dly;
    end

      
// drive the data into regs windos mem regs 
always @(posedge clk or negedge reset_n)
   if (reset_n == 1'b0)
     mem_dly0 <= `DATAWIDTH'h000;
   else
     mem_dly0 <= data_in; // filling data at start

always @(posedge clk or negedge reset_n)
   if (reset_n == 1'b0) begin
     mem_dly1 <= `DATAWIDTH'h000;
     mem_dly2 <= `DATAWIDTH'h000;
     mem_dly3 <= `DATAWIDTH'h000;
     mem_dly4 <= `DATAWIDTH'h000;
     mem_dly5 <= `DATAWIDTH'h000;
     mem_dly6 <= `DATAWIDTH'h000;
     mem_dly7 <= `DATAWIDTH'h000;
     mem_dly8 <= `DATAWIDTH'h000;
     mem_dly9 <= `DATAWIDTH'h000;
     mem_dly10 <= `DATAWIDTH'h000;
     mem_dly11 <= `DATAWIDTH'h000;
     mem_dly12 <= `DATAWIDTH'h000;
     mem_dly13 <= `DATAWIDTH'h000;
     mem_dly14 <= `DATAWIDTH'h000;
     mem_dly15 <= `DATAWIDTH'h000;
   end
   else
    if (start_act == 1'b1) begin
     mem_dly1 <= `DATAWIDTH'h000;
     mem_dly2 <= `DATAWIDTH'h000;
     mem_dly3 <= `DATAWIDTH'h000;
     mem_dly4 <= `DATAWIDTH'h000;
     mem_dly5 <= `DATAWIDTH'h000;
     mem_dly6 <= `DATAWIDTH'h000;
     mem_dly7 <= `DATAWIDTH'h000;
     mem_dly8 <= `DATAWIDTH'h000;
     mem_dly9 <= `DATAWIDTH'h000;
     mem_dly10 <= `DATAWIDTH'h000;
     mem_dly11 <= `DATAWIDTH'h000;
     mem_dly12 <= `DATAWIDTH'h000;
     mem_dly13 <= `DATAWIDTH'h000;
     mem_dly14 <= `DATAWIDTH'h000;
     mem_dly15 <= `DATAWIDTH'h000;
    end
    else 
     if ((vald_dout_dly == 1'd0) & (vald_din == 1'b1)) begin
      mem_dly1 <= data_in;
      mem_dly2 <= data_in;
      mem_dly3 <= data_in;
      mem_dly4 <= data_in;
      mem_dly5 <= data_in;
      mem_dly6 <= data_in;
      mem_dly7 <= data_in;
      mem_dly8 <= data_in;
      mem_dly9 <= data_in;
      mem_dly10 <= data_in;
      mem_dly11 <= data_in;
      mem_dly12 <= data_in;
      mem_dly13 <= data_in;
      mem_dly14 <= data_in;
      mem_dly15 <= data_in;
     end
    else 
      if (vald_din == 1'b1) begin
       mem_dly1 <= mem_dly0;
       mem_dly2 <= mem_dly1;
       mem_dly3 <= mem_dly2;
       mem_dly4 <= mem_dly3;
       mem_dly5 <= mem_dly4;
       mem_dly6 <= mem_dly5;
       mem_dly7 <= mem_dly6;
       mem_dly8 <= mem_dly7;
       mem_dly9 <= mem_dly8;
       mem_dly10 <= mem_dly9;
       mem_dly11 <= mem_dly10;
       mem_dly12 <= mem_dly11;
       mem_dly13 <= mem_dly12;
       mem_dly14 <= mem_dly13;
       mem_dly15 <= mem_dly14;
      end
       else begin
        mem_dly1 <= mem_dly1;
        mem_dly2 <= mem_dly2;
        mem_dly3 <= mem_dly3;
        mem_dly4 <= mem_dly4;
        mem_dly5 <= mem_dly5;
        mem_dly6 <= mem_dly6;
        mem_dly7 <= mem_dly7;
        mem_dly8 <= mem_dly8;
        mem_dly9 <= mem_dly9;
        mem_dly10 <= mem_dly10;
        mem_dly11 <= mem_dly11;
        mem_dly12 <= mem_dly12;
        mem_dly13 <= mem_dly13;
        mem_dly14 <= mem_dly14;
        mem_dly15 <= mem_dly15;
       end
    
 
assign new_data = mem_dly0;

always@(movavgwin_param or mem_dly1 or mem_dly3 or mem_dly7 or mem_dly15)
  case(movavgwin_param)
   2'd0: last_data_int = mem_dly1;
   2'd1: last_data_int = mem_dly3;
   2'd2: last_data_int = mem_dly7;
   2'd3: last_data_int = mem_dly15;
  endcase

always @(posedge clk or negedge reset_n)
  if (reset_n == 1'b0) begin
    added_val <= 16'd0;
    last_data <= `DATAWIDTH'h000;
  end
  else
   if ((start_act == 1'b1) || (movavg_en == 1'b0)) begin
    added_val <= 16'd0;
    last_data <= `DATAWIDTH'h000;
   end
     else
       if (restart_count == 1'b1) begin // at first data_in 
         added_val <= data_in*winavg_size; // add n samples of data_in
         last_data <= data_in;
       end
       else
        if ((vald_din == 1'b1) || (vald_dout_dly == 1'b1))  begin
          last_data <= last_data_int;
          added_val <= added_val - last_data + new_data;
        end
        else begin
          added_val <= added_val;
          last_data <= last_data;
        end

// div by 2,4,8,16 according the movavgwin_param
always @(added_val or movavgwin_param)
    case(movavgwin_param)
     2'd0:sample_avg = {1'b0,added_val[15:1]};  
     2'd1:sample_avg = {2'd0,added_val[15:2]};  
     2'd2:sample_avg = {3'd0,added_val[15:3]};  
     2'd3:sample_avg = {4'd0,added_val[15:4]};  
    endcase

// drive average data out when valid out active
 assign valid_out = (movavg_en == 1'b1) ? vald_dout : vald_din;  
 assign data_out = (movavg_en == 1'b1) ? ((stop_count == 1'b0) ? `DATAWIDTH'h000 : sample_avg[`DATAWIDTH-1:0]) : data_in;

always @(posedge clk or negedge reset_n)
  if (reset_n == 1'b0) 
    count_pix_num <= 10'h0;
  else
    if ((restart_count == 1'b1) | (movavg_en == 1'b0))
       count_pix_num <= 10'h0;
    else
       count_pix_num <= ((count_pix_num > 10'h003) && (valid_out == 1'b0)) ? count_pix_num :  count_pix_num + 1'b1; 

assign restart_count =  ((vald_din == 1'b1) && (vald_dout_dly == 1'b0));
assign stop_count = (count_pix_num >= winavg_size);



endmodule
