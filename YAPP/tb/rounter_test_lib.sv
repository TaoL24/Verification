// test 

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    router_tb tb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tb.new("tb", this);
        uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_5_packets::get_type());    
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    function start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_HIGH);
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