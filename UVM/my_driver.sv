class my_driver extends uvm_driver #(my_transcation);

    `uvm_component_utils(my_driver)


    function new(string name = "my_driver", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);// get the transcation from sequencer
            `uvm_info("DRV_RUN_PHASE", req.sprint(), UVM_MEDIUM)
            #100;
            seq_item_port.item_done(); // inform sequencer driver finsih the transcation, respone to the sequencer        
        end
    endtask 

endclass //my_driver extends uvm_driver #(my_transcation)