// testbench

class router_tb extends uvm_env;

    yapp_env yapp; // declare a handle for UVC class

    hbus_env hbus; // declare HBUS handle

    channel_env chan0; // Channel enviroment UVCs
    channel_env chan1;
    channel_env chan2;

    clock_and_reset_env clock_and_reset; // clock and reset UVC

    router_mcsequencer mcseqr; // multichannel sequencer handle

    router_scoreboard router_sb; // scoreboard handle

    `uvm_component_utils(router_tb)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MSG","build phase of testbench is being executed", UVM_HIGH);
        
        // YAPP UVC
        yapp = yapp_env::type_id::create("yapp", this);
        
        // Channel UVC with channel_id
        uvm_config_int::set(this,"chan0", "channel_id", 0);
        uvm_config_int::set(this,"chan1", "channel_id", 1);
        uvm_config_int::set(this,"chan2", "channel_id", 2);
        chan0 = channel_env::type_id::create("chan0", this);
        chan1 = channel_env::type_id::create("chan1", this);
        chan2 = channel_env::type_id::create("chan2", this);

        // HBUS UVC - 1 Master and 0 Slave
        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);
        hbus = hbus_env::type_id::create("hbus", this);

        // clock and reset UVC
        clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);

        // virtual sequencer
        mcseqr = router_mcsequencer::type_id::create("mcseqr", this);

        // router scoreboard
        router_sb = router_scoreboard::type_id::create("router_sb", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        mcseqr.yapp_seqr = yapp.tx_agent.sequencer;
        mcseqr.hbus_seqr = hbus.masters[0].sequencer;

        // Connect the TLM ports form the YAPP and Channel UVCs to the scoreboard
        yapp.tx_agent.monitor.item_collected_port.connect(router_sb.yapp_in);
        chan0.rx_agent.monitor.item_collected_port.connect(router_sb.chan0_in);
        chan1.rx_agent.monitor.item_collected_port.connect(router_sb.chan1_in);
        chan2.rx_agent.monitor.item_collected_port.connect(router_sb.chan2_in);
    endfunction: connect_phase

endclass: router_tb