class yapp_env extends uvm_env;

    yapp_tx_agent tx_agent;

    `uvm_component_utils(yapp_env)

    function void new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tx_agent = new("tx_agent", this);
    endfunction

    virtual function start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH);
    endfunction
endclass