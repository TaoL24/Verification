// 1st screen interview: VR handshake mechanism
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

// 2nd tech interview: only this coding Question
module count_rectangles(
    input clk,
    input rst_n,
    input start_frame,
    input vld,
    input pixel,

    output done,
    output [$clog2(512*256) -1:0] num_rectangles //512 *256
);

    //Your·code here
    logic [$clog2(1024):0] col;
    logic [$clog2(512):0] row;
    logic done_reg;

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            row <= 0;
            col <=0;
            done_reg <= 0;
        end else if (start_frame) begin
            row <= 0;
            col <=0;
            done_reg <= 0;
        end else begin
            if(vld) begin
                col <= (col>= 'd1023) ? 0 : (col + 1);
                row <= (col>= 'd1023) ? (row + 1) : row;
                done_reg <= (col== 1023 && row == 511);
            end
        end
    end

    logic [1023:0] line_buffer;
    logic pre_pixel;

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n)begin
            line_buffer <= 0;
            pre_pixel   <= 0;
        end else if (start_frame) begin
            line_buffer <= 0;
            pre_pixel   <= 0;
        end else begin
            line_buffer[col] <= pixel;
            pre_pixel        <= pixel;
        end
    end

    logic [$clog2(512*256) -1:0] num_rectangles_reg;

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rstn) begin
            num_rectangles_reg <= 0;
        end else if (start_frame) begin
            num_rectangles_reg <= 0;
        end else begin
            if(pre_pixel == 0 && pixel == 1 && line_buffer[col] == 0) begin
                num_rectangles_reg <= num_rectangles_reg + 'd1;
            end
        end
    end

    assign num_rectangles = num_rectangles_reg;
    assign done = done_reg;

endmodule