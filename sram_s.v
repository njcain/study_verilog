`include "defines.v"

module sram_s # (
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 8,
    parameter DATA_DEPTH = 16
)(
    input wire                  clk,
    input wire                  rst,
    input wire                  ce,

    // port read
    input wire[ADDR_WIDTH-1:0]  raddr,
    input wire                  re,
    output reg[DATA_WIDTH-1:0]  rdata,

    // port write
    input wire[ADDR_WIDTH-1:0]  waddr,
    input wire                  we,
    input wire[DATA_WIDTH-1:0]  wdata
    );

    integer i;
    reg [DATA_WIDTH-1:0]        register [DATA_DEPTH-1:0];

always @ (posedge clk) begin
    if (rst == `RstEnable) begin
        for(i=0; i<DATA_DEPTH; i=i+1) begin
            register[i] <= {DATA_WIDTH{1'b0}};
        end
    end 
    else if ((we == `WriteEnable) && (ce == `ChipEnable)) begin
        register[waddr] <= wdata;
    end
end

always @ (posedge clk) begin
    if (rst == `RstEnable) begin
        rdata <= {DATA_WIDTH{1'b0}};
    end
    else if ((re == `ReadEnable) && (ce == `ChipEnable)) begin
        rdata <= register[raddr];
    end else begin
        rdata <= rdata;
    end
end

endmodule
