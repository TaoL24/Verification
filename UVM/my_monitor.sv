class my_monitor extends uvm_monitor;

    `uvm_component_utils(my_monitor)

    function new(string name = "my_monitor", uvm_component parent);
        super.new(name,parent);
    endfunction //new()

    vitual task run_phase(uvm_phase phase);
        forever begin
            `uvm_info("MON_RUN_PHASE", "Monitor Run!", UVM_MEDIUM) // just printing sth, smiplified version
            #100;
        end
    endtask //run_phase
endclass //my_monitor extends uvm_monitor

