// testbench

class router_tb extends uvm_env;

    yapp_env yapp; // declear a handle for UVC class

    `uvm_component_utils(router_tb)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MSG","build phase of testbench is being executed", UVM_HIGH);
        yapp.new("yapp", this);
    endfunction

endclass: router_tb