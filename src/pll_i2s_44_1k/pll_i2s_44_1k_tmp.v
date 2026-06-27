//Copyright (C)2014-2026 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.12.02_SP1 (64-bit)
//IP Version: 1.0
//Part Number: GW1NSR-LV4CQN48PC7/I6
//Device: GW1NSR-4C
//Created Time: Sat Jun 27 09:59:21 2026

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    pll_i2s_44_1k your_instance_name(
        .clkout(clkout), //output clkout
        .lock(lock), //output lock
        .reset(reset), //input reset
        .clkin(clkin) //input clkin
    );

//--------Copy end-------------------
