`include "defines.v"

module tb_sram_s(

    );
`define CLK_PERIORD     10

parameter ADDR_WIDTH = 4;
parameter DATA_WIDTH = 8;
parameter DATA_DEPTH = 16;

integer i;

reg                     clk, rst, ce;

reg[ADDR_WIDTH-1:0]     raddr;
reg                     re;
wire[DATA_WIDTH-1:0]    rdata;

reg[ADDR_WIDTH-1:0]     waddr;
reg                     we;
reg[DATA_WIDTH-1:0]     wdata;

sram_s sram_s_0(
    .clk(clk),
    .rst(rst),
    .ce(ce),

    // port read
    .raddr(raddr),
    .re(re),
    .rdata(rdata),

    // port write
    .waddr(waddr),
    .we(we),
    .wdata(wdata)
);

initial begin
    clk = 0;
end
always #(`CLK_PERIORD/2)    clk = ~clk;

initial begin
    rst     =   `RstEnable;
    ce      =   `ChipDisable;
    we      =   `WriteDisable;
    re      =   `ReadDisable;
    raddr   =   {ADDR_WIDTH{1'b0}};
    #20
    rst     =   `RstDisable;
    ce      =   `ChipEnable;
    #5

    @(posedge clk)
    we      =   `WriteEnable;
    for (i=0;i<DATA_DEPTH;i=i+1) begin
        @(posedge clk) 
        begin
            waddr = i;
            wdata = {DATA_WIDTH{1'b0}}+i;
            we      =   `WriteDisable;
            re      =   `ReadEnable;
            raddr = i;
        end
    end

    #10
    ce      =   `ChipDisable;

    #100 $stop;
end

endmodule