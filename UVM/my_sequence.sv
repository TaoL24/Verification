// stimulate one type of transcation
class my_sequence extends uvm_sequence #(my_transcation);

    `uvm_object_utils(my_sequence)
    
    
    function new(string name = "my_sequence");
        super.new(name);
    endfunction //new()

    virtual task body(); // control and produce the tanscations
        if (starting_phase != null) begin
            starting_phase.raise_objection(this);
        end

        repeat(10) begin
            `uvm_do(req)
        end
        
        #100;

        if (starting_phase != null) begin
            starting_phase.drop_objection(this);
        end
    endtask

endclass //my_sequence extends uvm_sequence #(my_transcation)


typedef uvm_sequencer #(my_transcation) my_sequencer;
