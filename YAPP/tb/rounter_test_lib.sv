// test 

class base_test extends uvm_test;

    `uvm_component_utils(router_test_lib)

    router_tb tb;

    function new(string name, uvm_component parenet);
        super.new(name, parenet);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tb.new("tb", this);
        `uvm_info("MSG", "build phase of test is being executed", UVM_HIGH);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction
endclass: base_test


// can have more than one test
// command line +UVM_TESTNAME=mytest
class mytest extends base_test;

    `uvm_component_utils(mytest)
    
    function new(string name, uvm_component parenet);
        super.new(name, parenet);
    endfunction

endclass: mytest