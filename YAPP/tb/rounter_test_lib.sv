// test 

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    router_tb tb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        // uvm_config_int::set(this, "tb.yapp.tx_agent", "is_active", UVM_PASSIVE); // set for configuration
        super.build_phase(phase);

        uvm_config_int::set(this, "*", "recording_detail", 1); // enable transaction recording
        // tb = new("tb", this);
        tb = router_tb::type_id::create("tb", this); // using factory!

    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    function start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH);
    endfunction

    function check_phase(uvm_phase phase);
        check_config_usage(); // configuration checker
    endfunction
endclass: base_test


// can have more than one test
// command line +UVM_TESTNAME=mytest
class mytest extends base_test;

    `uvm_component_utils(mytest)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass: mytest

//------------------------------------------------------------------------------
// factory lab test
//------------------------------------------------------------------------------ 
class short_packet_test extends base_test;

    `uvm_component_utils(short_packet_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        // for connect sequence        
        uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase", "default_sequence", yapp_5_packets::get_type());
        super.build_phase(phase);
    endfunction
endclass: short_packet_test

//------------------------------------------------------------------------------
// configuration lab test
//------------------------------------------------------------------------------ 
class set_config_test extends base_test;

    `uvm_component_utils(set_config_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        uvm_config_int::set(this, "tb.yapp.tx_agent", "is_active", UVM_PASSIVE);
        super.build_phase(phase);
    endfunction
endclass: set_config_test

//------------------------------------------------------------------------------
// sequence lab test
//------------------------------------------------------------------------------ 
class incr_payload_test extends base_test;

    `uvm_component_utils(incr_payload_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type, short_yapp_packet::get_type());
        uvm_config_wapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase", "default_sequence", yapp_incr_payload_seq::get_type());
        super.build_phase(phase);
    endfunction
endclass

class exhaustive_seq_test extends base_test;

    `uvm_component_utils(exhaustive_seq_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type, short_yapp_packet::get_type());
        uvm_config_wapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase", "default_sequence", yapp_exhaustive_seq::get_type());
        super.build_phase(phase);
    endfunction
endclass