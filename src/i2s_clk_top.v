module i2s_clk_top(
    input  wire clk_24_576,      // 24.576MHz晶振（48KHz系列）
    input  wire clk_22_5792,     // 22.5792MHz晶振（44.1KHz系列）
    input  wire sample_sel,      // 采样率选择：0=48KHz, 1=44.1KHz
    
    input  wire resetn,          // 低电平复位
    
    // I2S时钟输出（ADC用）
    output wire mclk0,           // 主时钟
    output wire bclk0,           // 位时钟
    output wire fsclk0,          // 帧时钟
    
    // I2S时钟输出（DAC或其他设备用）
    output wire bclk1,
    output wire fsclk1,

    input  wire data_in,
    output wire data_out
);
    

    wire reset = !resetn;        // 转换为高电平复位
    
    // PLL输出
    wire pll_4x_48k, locked_48k;
    wire pll_4x_44k1, locked_44k1;
    
    // Sync + MUX 输出
    wire pll_4x, locked, cnt_reset;
    
    // 时钟生成输出
    wire mclk, bclk, fsclk;
    
    // 1. PLL封装（两个PLL并行工作）
    i2s_pll_wrapper u_pll (
        .clk_24_576    (clk_24_576),
        .clk_22_5792   (clk_22_5792),
        .reset         (reset),
        
        .pll_4x_48k    (pll_4x_48k),
        .locked_48k    (locked_48k),
        
        .pll_4x_44k1   (pll_4x_44k1),
        .locked_44k1   (locked_44k1)
    );
    
    // 2. 双PLL同步 + 时钟MUX（三级同步sample_sel，切换时复位计数器）
    i2s_dual_pll_sync u_sync (
        .pll_4x_48k    (pll_4x_48k),
        .locked_48k    (locked_48k),
        .pll_4x_44k1   (pll_4x_44k1),
        .locked_44k1   (locked_44k1),
        .sample_sel    (sample_sel),
        .reset         (reset),

        .pll_4x        (pll_4x),
        .locked        (locked),
        .cnt_reset     (cnt_reset)
    );
    
    // 3. 时钟分频生成器
    i2s_clk_gen u_clkgen (
        .pll_4x        (pll_4x),
        .locked        (locked),
        .reset         (cnt_reset),
        
        .mclk          (mclk),
        .bclk          (bclk),
        .fsclk         (fsclk)
    );
    
    
    // ADC时钟
    assign mclk0  = mclk;
    assign bclk0  = bclk;
    assign fsclk0 = fsclk;
    
    // 第二路I2S时钟（DAC等）
    assign bclk1  = bclk;
    assign fsclk1 = fsclk;
    
    // 数据直通
    assign data_out = data_in;

endmodule