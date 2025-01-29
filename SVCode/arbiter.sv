module arbiter #(parameter LENGTH = 8) (
    input [LENGTH-1:0] req,
    output reg [LENGTH-1:0] gnt
);
    // fixed priority
    // solution1
    assign gnt = req & (~(req - 'd1)); 

    //solution2
    reg [LENGTH-1:0] pre_req;

    pre_req[0] = req[0];
    pre_req[LENGTH-1:1] = req[LENGTH-2:0] | pre_req[LENGTH-2:0];
    gnt = req & ~pre_req;

    //solution 3: kill chain
    wire [LENGTH:0] kills;
    assign kills[0] = 1'b0; // 0 means not blocking 
    wire [LENGTH-1:0] gnt_int;

    genvar i;
    for (i =0; i < LENGTH; i++) begin: pre_req_logic
        assign gnt_int[i] = !kills[i] & req[i]; // only kill=0 and current req=1, grant it!!
        assign kills[i+1] = kills[i] | gnt_int[i]; // if prev kill chain blocking, or already grant, block current kill 
    end

    assign gnt = gnt_int;
endmodule


// Round robin arbiter
module variable_priority_arbiter #(parameter LENGTH = 4) (
    input [LENGTH-1:0] priority,
    input [LENGTH-1:0] req;
    output [LENGTH-1:0] gnt;
);

/*
suppose the input priority is 00100 
priority_int will be 00000_00100
imagine the reqs_int is 01000_01000 //case1
imagine the reqs_int is 00100_00100 //case2
imagine the reqs_int is 00010_00010 //case3
*/
    wire [2*LENGTH : 0] kills;
    wire [2*LENGTH-1 : 0] priority_int = {{LENGTH{1'b0}}, priority}; 
    wire [2*LENGTH-1 : 0] reqs_int = {req,req};
    wire [2*LENGTH-1 : 0] grants_int;
    
    assign kills[0] = 1'b0;
    genvar i;
    for (i =0; i < LENGTH; i++) begin: pre_req_logic
        assign grants_int[i] = priority_int[i] ? reqs_int[i] : (!kills[i] & reqs_int[i]);
        assign kills[i+1] = priority_int[i] ? grants_int[i] : (kills[i] | grants_int[i]);
    end
    
endmodule    
