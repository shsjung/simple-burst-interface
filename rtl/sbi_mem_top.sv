// -----------------------------------------------------------------------------
// File Name: sbi_mem_top.sv
// Description:
//     A module which includes the following components:
//     1. A memory interface module for interacting with the memory.
//     2. A memory model
//     This module supports parametrized address and data widths.
//
// Author: shsjung (github.com/shsjung)
// Date Created: 2024-12-13
// -----------------------------------------------------------------------------

module sbi_mem_top #(
    parameter  int Width = 32,
    parameter  int Depth = 256,
    localparam int Aw    = $clog2(Depth)
) (
    input              bCLK,
    input              bRSTn,
    input  [   Aw-1:0] bADDR,
    input              bSTART,
    input              bACCESS,
    input              bWRITE,
    input  [Width-1:0] bD,
    output [Width-1:0] bQ,
    output             bVALID
);

    logic             we;
    logic             re;
    logic [   Aw-1:0] addr;
    logic [Width-1:0] wdata;
    logic [Width-1:0] rdata;

    sbi_interface #(
        .Width (Width),
        .Depth (Depth)
    ) inst_sbi_slave (
        .bCLK    (bCLK),
        .bRSTn   (bRSTn),
        .bADDR   (bADDR),
        .bSTART  (bSTART),
        .bACCESS (bACCESS),
        .bWRITE  (bWRITE),
        .bD      (bD),
        .bQ      (bQ),
        .bVALID  (bVALID),

        .we_o    (we),
        .re_o    (re),
        .addr_o  (addr),
        .wdata_o (wdata),
        .rdata_i (rdata)
    );

    ram_single #(
        .Width (Width),
        .Depth (Depth)
    ) inst_ram (
        .clk_i   (bCLK),

        .we_i    (we),
        .re_i    (re),
        .addr_i  (addr),
        .wdata_i (wdata),
        .rdata_o (rdata)
    );

endmodule
