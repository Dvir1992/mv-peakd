module  (A,B,CI,SUM,CO);

   parameter width=4;

   // port decalrations

   input [width-1 : 0] 	A,B;
   input 		CI;
   
   output [width-1 : 0] SUM;
   output 		CO;

assign SUM = A+B;

endmodule  // 	NS_DW01_add;
