/*-----------------------------------------------------------------
File name     : driver_example.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif YAPP UVC TX driver example code 
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
class yapp_tx_driver extends uvm_driver #(yapp_packet);
    
    // yapp_tx_driver req;

    // Declare this property to count packets sent
    int num_sent;

    // virtual interface
    virtual yapp_if vif;

    `uvm_component_utils_begin(yapp_tx_driver)
        `uvm_field_int(num_sent, UVM_ALL_ON)
    `uvm_component_utils_end

    function void new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function connect_phase(uvm_phase phase);
        if(!yapp_if_cfg::get(this, get_full_name(), "vif", vif))
        `uvm_error(get_type_name(), {"virtual interface must be set for: ", get_full_name, ".vif"})
    endfunction

    // UVM run_phase
    task run_phase(uvm_phase phase);
        fork
        get_and_drive();
        reset_signals();
        join
    endtask : run_phase

    // Gets packets from the sequencer and passes them to the driver. 
    task get_and_drive();
        @(posedge vif.reset);
        @(negedge vif.reset);
        `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
        forever begin
        // Get new item from the sequencer
        seq_item_port.get_next_item(req);

        `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)
        
        // concurrent blocks for packet driving and transaction recording
        fork
            // send packet
            begin
            // for acceleration efficiency, write unsynthesizable dynamic payload array directly into 
            // interface static payload array
            foreach (req.payload[i])
                vif.payload_mem[i] = req.payload[i];
            // send rest of YAPP packet via individual arguments
            vif.send_to_dut(req.length, req.addr, req.parity, req.packet_delay);
            end
            // trigger transaction at start of packet (trigger signal from interface)
            @(posedge vif.drvstart) void'(begin_tr(req, "Driver_YAPP_Packet"));
        join

        // End transaction recording
        end_tr(req);
        num_sent++;
        // Communicate item done to the sequencer
        seq_item_port.item_done();
        end
    endtask : get_and_drive

    // Reset all TX signals
    task reset_signals();
        forever 
        vif.yapp_reset();
    endtask : reset_signals

    task send_to_dut(yapp_packet yapp);
        `uvm_info(get_type_name(), $sformatf("Packet is \n%s", yapp.sprint()), UVM_LOW);
        #10ns; // for easier debug
    endtask

    function start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH);
    endfunction

    // UVM report_phase
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: YAPP TX driver sent %0d packets", num_sent), UVM_LOW)
    endfunction : report_phase
endclass