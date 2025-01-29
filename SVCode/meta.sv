module myfifo (
    input clk, rstn,
    input w_en, r_en,
    input [7:0] datain,
    output [7:0] dataout,
    output full, empty
);
endmodule

// wrapper the myfifo with this empty valid handshake mechanism 
module myfifo_empty_valid (
    // write domain
    input valid_w;
    output ready_w; // indicate fifo is not full, can write data in it

    // read domain
    output valid_r; // indicate fifo is not empty, can read data from it
    input ready_r;
);

logic empty, full;
logic w_en, r_en;

// write domain
assign w_en = valid_w && ~full;
assign ready_w = ~full;

// read domain
assign r_en = ready_r && ~empty;
assign valid_r = ~empty;

myfifo myfifo1 (.*);

endmodule