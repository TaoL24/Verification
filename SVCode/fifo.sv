module syn_fifo #(parameter DEPTH = 8, WIDTH = 8)(
    input clk;
    input rstn;

    input [WIDTH-1:0] w_data;
    output reg full;
    input w_en;

    output reg [WIDTH-1:0] r_data;
    output reg empty;
    input r_en;
);
    parameter ptr_depth = $clog2(DEPTH);
    reg [ptr_depth:0] w_ptr, r_ptr; // 1+logN bits
    reg [WIDTH-1:0] fifo [DEPTH-1:0]; 

    always_ff @(posedge clk or negedge rstn ) begin : write_side
        if (!rstn) begin
            w_ptr <= 0;
        end else (w_en && !full) begin
            w_ptr <= w_ptr + 1;
            fifo[w_ptr[0 +: ptr_depth]] <= w_data;
        end
    end

    always_ff @(posedge clk or negedge rstn ) begin : read_side
        if (!rstn) begin
            r_ptr <= 0;
            r_data <= 0;
        end else (r_en && !empty) begin
            r_ptr <= r_ptr + 1;
            r_data <= fifo[r_ptr[0 +: ptr_depth]];
        end
    end

    assign empty = (w_ptr == r_ptr);
    assign full = ((w_ptr[ptr_depth] != r_ptr[ptr_depth]) && (w_ptr[0 +: ptr_depth] == r_ptr[0 +: ptr_depth]));

endmodule