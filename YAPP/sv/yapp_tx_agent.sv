class yapp_tx_agent extends uvm_agent;

    yapp_tx_monitor monitor;
    yapp_tx_driver driver;
    yapp_tx_sequencer sequencer;

    `uvm_component_utils_begin(yapp_tx_agent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

    function void new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // monitor = new("monitor", this);
        monitor = yapp_tx_monitor::type_id::create("monitor", this);
        if (is_active == UVM_ACTIVE) begin
        //    driver = new("driver", this);
        //    sequencer = new("sequencer", this); 
           driver = yapp_tx_driver::type_id::create("driver", this);
           sequencer = yapp_tx_sequencer::type_id::create("sequencer", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

    virtual function start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH);
    endfunction
    
endclass