module is_onehot #(WIDTH = N) (
    input [WIDTH-1:0] sig,
    output logic out
);
    assign out = (sig & (sig - 1) == 0) && (sig != 0);
endmodule

