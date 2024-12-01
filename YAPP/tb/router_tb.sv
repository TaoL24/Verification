// testbench

class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)

    function new(string name, uvm_component parenet);
        super.new(name, parenet);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MSG","build phase of testbench is being executed", UVM_HIGH);
    endfunction

endclass: router_tb