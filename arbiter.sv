module arbiter #(parameter LENGTH = 8) (
    input [LENGTH-1:0] req;
    output reg [LENGTH-1:0] gnt;
);
    // fixed priority
    // solution1
    assign gnt = req & (~(req-'d1)); 

    //solution2
    reg [LENGTH-1:0] pre_req;

    pre_req[0] = req[0];
    pre_req[LENGTH-1:1] = req[LENGTH-2:0] | pre_req[LENGTH-2:0];
    gnt = req & ~pre_req;

    // Round robin arbiter


endmodule