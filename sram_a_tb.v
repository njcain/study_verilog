`include "defines.v"

module tb_sram_a(

    );
`define CLK_PERIORD_R       10
`define CLK_PERIORD_W       16

parameter ADDR_WIDTH = 4;
parameter DATA_WIDTH = 8;
parameter DATA_DEPTH = 16;

integer i;

reg                     clkr, clkw, rst, ce;

reg[ADDR_WIDTH-1:0]     raddr;
reg                     re;
wire[DATA_WIDTH-1:0]    rdata;

reg[ADDR_WIDTH-1:0]     waddr;
reg                     we;
reg[DATA_WIDTH-1:0]     wdata;

sram_a sram_a_0(
    .clkr(clkr),
    .clkw(clkw),
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
    clkr = 0;
    clkw = 0;
end
always #(`CLK_PERIORD_R/2)      clkr = ~clkr;
always #(`CLK_PERIORD_W/2)      clkw = ~clkw;

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

    @(posedge clkw)
    we      =   `WriteEnable;
    for (i=0;i<DATA_DEPTH;i=i+1) begin
        @(posedge clkw) 
        begin
            waddr = i;
            wdata = {DATA_WIDTH{1'b0}}+i;
        end
    end

    @(posedge clkr)
    we      =   `WriteDisable;
    re      =   `ReadEnable;
    for (i=0;i<DATA_DEPTH;i=i+1) begin
        @(posedge clkr) 
        begin
            raddr = i;
        end
    end

    #10
    ce      =   `ChipDisable;

    #100 $stop;
end

endmodule