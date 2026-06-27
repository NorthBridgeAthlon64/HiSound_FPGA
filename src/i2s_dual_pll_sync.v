module i2s_dual_pll_sync(
    input  wire pll_4x_48k,
    input  wire locked_48k,
    input  wire pll_4x_44k1,
    input  wire locked_44k1,

    input  wire sample_sel,
    input  wire reset,

    output wire pll_4x,
    output wire locked,
    output wire cnt_reset
);

    reg [2:0] sel_sync;
    reg       sel_d1;

    always @(posedge pll_4x_48k or posedge reset) begin
        if (reset) begin
            sel_sync <= 3'b0;
            sel_d1   <= 1'b0;
        end else begin
            sel_sync <= {sel_sync[1:0], sample_sel};
            sel_d1   <= sel_sync[2];
        end
    end

    wire sel_stable  = sel_sync[2];
    wire sel_changed = sel_stable != sel_d1;

    assign pll_4x = sel_stable ? pll_4x_48k : pll_4x_44k1;
    assign locked = sel_stable ? locked_48k : locked_44k1;
    assign cnt_reset = reset | sel_changed;

endmodule
