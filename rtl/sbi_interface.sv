// -----------------------------------------------------------------------------
// File Name: sbi_interface.sv
// Description:
//     A simple memory interface based on SBI. The SBI is designed for
//     efficient burst-only communication between modules in a hardware system.
//
// Author: shsjung (github.com/shsjung)
// Date Created: 2024-12-13
// -----------------------------------------------------------------------------

module sbi_interface #(
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
    output             bVALID,

    output             we_o,
    output             re_o,
    output [   Aw-1:0] addr_o,
    output [Width-1:0] wdata_o,
    input  [Width-1:0] rdata_i
);

    logic [Aw-1:0] raddr, waddr;
    logic qvalid;

    always_ff @(posedge bCLK or negedge bRSTn) begin
        if (!bRSTn) begin
            raddr <= 'h0;
        end else if (bSTART & ~bWRITE) begin
            raddr <= bADDR;
        end else if (bACCESS & ~bWRITE) begin
            raddr <= raddr + 'h1;
        end
    end

    always_ff @(posedge bCLK or negedge bRSTn) begin
        if (!bRSTn) begin
            waddr <= 'h0;
        end else if (bSTART & bWRITE) begin
            waddr <= bADDR;
        end else if (bACCESS & bWRITE) begin
            waddr <= waddr + 'h1;
        end
    end

    always_ff @(posedge bCLK or negedge bRSTn) begin
        if (!bRSTn) begin
            qvalid <= 1'h0;
        end else begin
            qvalid <= bACCESS & ~bWRITE;
        end
    end

    assign we_o = bACCESS & bWRITE;
    assign re_o = bACCESS & ~bWRITE;
    assign addr_o = (bWRITE) ? waddr : raddr;
    assign wdata_o = bD;

    assign bQ = rdata_i;
    assign bVALID = qvalid;

endmodule
