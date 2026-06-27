module i2s_dual_pll_sync(
    input  wire clk,
    input  wire sample_sel,
    input  wire reset,

    output wire cnt_reset
);

    reg [2:0] sel_sync;
    reg       sel_d1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sel_sync <= 3'b0;
            sel_d1   <= 1'b0;
        end else begin
            sel_sync <= {sel_sync[1:0], sample_sel};
            sel_d1   <= sel_sync[2];
        end
    end

    wire sel_changed = sel_sync[2] != sel_d1;
    assign cnt_reset = reset | sel_changed;

endmodule
