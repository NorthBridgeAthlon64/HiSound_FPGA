// i2s_pll_wrapper.v
// 封装两个PLL，对外提供统一的时钟接口

module i2s_pll_wrapper(
    input  wire clk_24_576,      // 48KHz系列晶振
    input  wire clk_22_5792,     // 44.1KHz系列晶振
    input  wire reset,           // 高电平复位
    
    output wire pll_4x_48k,      // PLL1输出：98.304MHz
    output wire locked_48k,      // PLL1锁定
    
    output wire pll_4x_44k1,     // PLL2输出：90.3168MHz
    output wire locked_44k1      // PLL2锁定
);

    // PLL1: 48KHz系列
    // 24.576MHz × 4 = 98.304MHz
    pll_i2s_48k u_pll_48k (
        .clkin  (clk_24_576),
        .clkout (pll_4x_48k),
        .lock   (locked_48k),
        .reset  (reset)
    );
    
    // PLL2: 44.1KHz系列
    // 22.5792MHz × 4 = 90.3168MHz
    pll_i2s_44k1 u_pll_44k1 (
        .clkin  (clk_22_5792),
        .clkout (pll_4x_44k1),
        .lock   (locked_44k1),
        .reset  (reset)
    );

endmodule