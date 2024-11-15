class my_transcation extends uvm_sequence_item;

    rand bit [3:0] sa;
    rand bit [3:0] da;
    rand reg payload[$];

    `uvm_object_utils_begin(my_transcation)
        `uvm_field_int(sa, UVM_ALL_ON)
        `uvm_field_int(da, UVM_ALL_ON)
        `uvm_field_queue_int(payload, UVM_ALL_ON)
    `uvm_object_utils_end

    constraint Limit{
        sa inside {[0:15]};
        da inside {[0:15]};
        payload.size() inside {[2:4]};


        // recap of weighted distribution 
        sa dist = { [0:3] := 40, [4:15] := 12 }; //  40/(40*4+12*12), 12/(40*4+12*12)
        da dist = { [0:3] :/ 40, [4:15] :/ 12 }; //  10/40+12, 1/40+12

    }

    function new(string name = "my_transcation");
        super.new(name);
    endfunction //new()


endclass //my_transcation extends uvm_sequence_item