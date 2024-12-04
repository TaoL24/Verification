// testbench

class router_tb extends uvm_env;

    yapp_env yapp; // declare a handle for UVC class

    hbus_env hbus; // declare HBUS handle

    router_mcsequencer mcseqr; // multichannel sequencer handle

    `uvm_component_utils(router_tb)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MSG","build phase of testbench is being executed", UVM_HIGH);

        yapp = yapp_env::type_id::create("yapp", this);

        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);
        hbus = hbus_env::type_id::create("hbus", this);

        mcseqr = router_mcsequencer::type_id::create("mcseqr", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        mcseqr.yapp_seqr = yapp.tx_agent.sequencer;
        mcseqr.hbus_seqr = hbus.masters[0].sequencer;
    endfunction: connect_phase

endclass: router_tb