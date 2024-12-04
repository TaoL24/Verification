/*-----------------------------------------------------------------
File name     : monitor_example.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif YAPP UVC TX Monitor example code
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
class yapp_tx_monitor extends uvm_monitor;

    // Collected Data handle
    yapp_packet pkt;

    // Count packets collected
    int num_pkt_col;

    // virtual interface
    virtual yapp_if vif;

    `uvm_component_utils_begin(yapp_tx_monitor)
        `uvm_field_int(num_pkt_col, UVM_ALL_ON)
    `uvm_component_utils_end
    
    function void new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function connect_phase(uvm_phase phase);
        if(!yapp_if_cfg::get(this, get_full_name(), "vif", vif))
        `uvm_error(get_type_name(), {"virtual interface must be set for: ", get_full_name, ".vif"})
    endfunction

    function start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH);
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Here is MONITOR!!", UVM_LOW);

        // from example code
        // Look for packets after reset
        @(posedge vif.reset)
        @(negedge vif.reset)
        `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
        forever begin 
            // Create collected packet instance
            pkt = yapp_packet::type_id::create("pkt", this);

            // concurrent blocks for packet collection and transaction recording
            fork
            // collect packet
            vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
            // trigger transaction at start of packet
            @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
            join

            pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
            // End transaction recording
            end_tr(pkt);
            `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
            num_pkt_col++;
        end
    endtask


    // UVM report_phase
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
    endfunction : report_phase
endclass


