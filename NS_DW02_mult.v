module(A,B,TC,PRODUCT);
parameter	A_width = 8;
parameter	B_width = 8;
   
input	[A_width-1:0]	A;
input	[B_width-1:0]	B;
input			TC;
output	[A_width+B_width-1:0]	PRODUCT;

assign PRODUCT = A*B;

endmodule


