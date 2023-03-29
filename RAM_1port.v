//单口ram只有一个port
module RAM_1port(
    input rstn,
    input [6:0] addr,
    input [3:0] w_data,
    input enb,
    input clk,
    output wire [3:0] r_data
);

reg  [6:0] mem [127:0];
integer i;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        for(i = 0; i<127; i=i+1) begin
            mem[i] <= 0;
        end
    end
    else if(enb) begin
        mem[addr] <= w_data;
    end
end
assign r_data = (!enb)? mem[addr]:0;

endmodule
// 读数据是组合逻辑，只要有地址，就是相应的数据，
// 写数据是时序逻辑，在时钟上升沿来的时候，写进去一次。