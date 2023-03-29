module cla_4bit(
  input [3:0] A_in,
  input [3:0] B_in,
  input C_1,
  output [3:0] S,
  output CO
);

  wire [3:0] g;
  wire [3:0] p;

  // Calculate G and P for each bit
  assign g[0] = A_in[0] & B_in[0];
  assign p[0] = A_in[0] | B_in[0];

  assign g[1] = A_in[1] & B_in[1] | g[0] & p[0];
  assign p[1] = A_in[1] | B_in[1];

  assign g[2] = A_in[2] & B_in[2] | g[1] & p[1];
  assign p[2] = A_in[2] | B_in[2];

  assign g[3] = A_in[3] & B_in[3] | g[2] & p[2];
  assign p[3] = A_in[3] | B_in[3];

  // Calculate sum and carry-out
  assign sum = A_in ^ B_in ^ C_1;
  assign cout = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]);

endmodule