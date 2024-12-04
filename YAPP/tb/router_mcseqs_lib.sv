class router_mcseqs extends uvm_sequence;

    `uvm_object_utils(router_mcseqs)
    `uvm_declare_p_sequencer(router_mcsequencer)

    function void new(string name = "router_mcseqs");
        super.new(name);
    endfunction

    // YAPP sequence defined in yapp_tx_seqs.sv
    yapp_012_seq yapp_012;
    yapp_rnd_seq yapp_rnd;

    // HBUS sequence
    hbus_small_packet_seq h_small;
    hbus_set_default_regs_seq h_large;
    hbus_read_max_pkt_seq read_max_pkt;

    task pre_body();
        uvm_phase phase;
        phase = get_starting_phase();
        if(phase != null) begin
            phase.raise_obejction(this,get_type_name());
            `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask

    task body();
        `uvm_info(get_type_name(), "Executing multi-sequence", UVM_LOW)

        // Set router to accept small packets and check the setting
        `uvm_do_on(h_small, p_sequencer.hbus_seqr)
        `uvm_do_on(read_max_pkt,p_sequencer.hbus_seqr)

        // Send 6 consecutive packs to address 0, 1, 2
        `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
        `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)

         // Set router to accept large packets and check the setting
        `uvm_do_on(h_large, p_sequencer.hbus_seqr)
        `uvm_do_on(read_max_pkt,p_sequencer.hbus_seqr)
        
        // Send a random sequencer of 6 packets
        `uvm_do_on_with(yapp_rnd, p_sequencer.yapp_seqr, {count = 6;})
    endtask

    task post_body();
        uvm_phase phase;
        phase = get_starting_phase();
        if (phase != null) begin
            phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask
endclass
