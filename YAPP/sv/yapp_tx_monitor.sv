class yapp_tx_monitor extends uvm_monitor;

    `uvm_component_utils(yapp_tx_monitor)

    function void new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH);
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Here is MONITOR!!", UVM_LOW);
    endtask
endclass