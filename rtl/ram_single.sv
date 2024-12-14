// -----------------------------------------------------------------------------
// File Name: ram_single.sv
// Description:
//     A parameterizable single-port RAM module. This module supports
//     synchronous read and write operations.
//
// Author: shsjung (github.com/shsjung)
// Date Created: 2024-12-12
// -----------------------------------------------------------------------------

`define SIM_LOG

module ram_single #(
    parameter  int Width = 32,
    parameter  int Depth = 256,
    localparam int Aw    = $clog2(Depth)
) (
    input              clk_i,

    input              we_i,
    input              re_i,
    input  [   Aw-1:0] addr_i,
    input  [Width-1:0] wdata_i,
    output [Width-1:0] rdata_o
);

    logic [Width-1:0] memory[Depth];
    logic [Width-1:0] rdata;

    always_ff @(posedge clk_i) begin
        if (we_i) begin
            memory[addr_i] <= wdata_i;
`ifdef SIM_LOG
            $display("ram_single: WRITE (%x): %x", addr_i, wdata_i);
`endif
        end
    end

    always_ff @(posedge clk_i) begin
        if (re_i) begin
            rdata <= memory[addr_i];
`ifdef SIM_LOG
            $display("ram_single: READ  (%x): %x", addr_i, memory[addr_i]);
`endif
        end
    end

    assign rdata_o = rdata;

endmodule
