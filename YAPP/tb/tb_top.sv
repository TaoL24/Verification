/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;
// import the UVM library
import uvm_pkg::*;
// include the UVM macros
`include "uvm_macros.svh";

// import the YAPP package
`include "yapp_pkg::*";

// import multichannel sequencer and sequences
`include "router_mcsequencer.sv";
`include "router_mcseqs_lib.sv";

// import the testbench and test library file
`include "router_tb.sv";
`include "router_test_lib.sv";

initial begin
    yapp_if_cfg::set(null, "uvm_test_top.tb.yapp.tx_agent.*", "vif", hw_top.in0);
    run_test("base_test");
end

endmodule : tb_top
