class yapp_tx_driver extends uvm_driver #(yapp_packet);
    
    // yapp_tx_driver req;

    `uvm_component_utils(yapp_tx_driver)

    function void new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            send_to_dut(req);
            seq_item_port.item_done();
        end
    endtask

    task send_to_dut(yapp_packet yapp);
        `uvm_info(get_type_name(), $sformatf("Packet is \n%s", yapp.sprint()), UVM_LOW);
        #10ns; // for easier debug
    endtask

    virtual function start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH);
    endfunction
endclass