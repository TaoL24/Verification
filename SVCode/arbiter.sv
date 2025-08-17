module arbiter #(parameter LENGTH = 8) (
    input [LENGTH-1:0] req,
    output reg [LENGTH-1:0] gnt
);
    // fixed priority
    // solution1
    assign gnt = req & (~(req - 'd1)); // find last 1, a number & it's 2's complement number result in the last 1 position

    //solution2
    reg [LENGTH-1:0] pre_req;

    pre_req[0] = 1'b0;
    pre_req[LENGTH-1:1] = req[LENGTH-2:0] | pre_req[LENGTH-2:0];
    gnt = req & ~pre_req;

    //solution 3: kill chain
    wire [LENGTH:0] kills;
    assign kills[0] = 1'b0; // 0 means not blocking 
    wire [LENGTH-1:0] gnt_int;

    generate
        for (genvar i =0; i < LENGTH; i++) begin: pre_req_logic
            assign gnt_int[i] = !kills[i] & req[i]; // only kill=0 and current req=1, grant it!!
            assign kills[i+1] = kills[i] | gnt_int[i]; // if prev kill chain blocking, or already grant, block current kill 
        end
    endgenerate

    assign gnt = gnt_int;
endmodule

// 0101 -> 0001;



// Round robin arbiter
module #(parameter N = 8) rr_abt(
  input clk, rstn,
  input  logic [N-1:0] req,
  output logic [N-1:0] gnt 
);

  // unmasked simple arbiter
  logic [N-1:0] unmasked_higher_pri_req;
  logic [N-1:0] unmasked_gnt;
  assign unmasked_higher_pri_req[0] = 0;
  assign unmasked_higher_pri_req[N-1:1] = unmasked_higher_pri_req[N-2:0] | req[N-2:0];
  assign unmasked_gnt = req & ~unmasked_higher_pri_req;

  // masked simple arbiter
  logic [N-1:0] masked_higher_pri_req;
  logic [N-1:0] masked_gnt;
  logic [N-1:0] masked_req;
  assign masked_req = req & ptr;
  assign masked_higher_pri_req[0] = 0;
  assign masked_higher_pri_req[N-1:1] = masked_higher_pri_req[N-2:0] | masked_req[N-2:0];
  assign masked_gnt = masked_req & ~masked_higher_pri_req;


  logic [N-1:0] ptr;

  always_ff @( posedge clk, negedge rstn ) begin
    if (!rstn) ptr <= {N{1'b1}};
    else begin
      if(|masked_req) ptr <= masked_higher_pri_req;
      else if (|req)  ptr <= unmasked_higher_pri_req;
    end
  end

  assign gnt = (|masked_req) ? masked_gnt : unmasked_gnt;
endmodule  
