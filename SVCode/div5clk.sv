module div5clk #(parameter N = 5) (
    input clk, 
    input rst,
    output div5clk
);

logic [2:0] pos_cnt, neg_cnt;
logic pos_clk, neg_clk;
logic pos_clk5, neg_clk5;

always @(posedge clk, negedge rst) begin
    if (!rst) begin
        pos_cnt <= 'd0;
        pos_clk <= 'd0;
    end 
    else if (pos_cnt == 'd0) begin
        pos_clk <= ~pos_clk;
        pos_cnt <= pos_cnt + 'd1;
    end
    else if (pos_cnt == 'd2) begin // (5-1) / 2 = 2
        pos_clk <= ~pos_clk;
        pos_cnt <= pos_cnt + 'd1;
    end 
    else if (pos_cnt == 'd4) begin // 5 -1 
        pos_clk <= pos_clk; 
        pos_cnt <= 'd0;
    end else begin
        pos_clk <= pos_clk; // other cases remain the same value
        pos_cnt <= pos_cnt + 'd1;
    end
end

always @(negedge clk, negedge rst) begin
    if (!rst) begin
        neg_cnt <= 'd0;
        neg_clk <= 'd0;
    end 
    else if (neg_cnt == 'd0) begin
        neg_clk <= ~neg_clk;
        neg_cnt <= neg_cnt + 'd1;
    end
    else if (neg_cnt == 'd2) begin // (5-1) / 2 = 2
        neg_clk <= ~neg_clk;
        neg_cnt <= neg_cnt + 'd1;
    end 
    else if (neg_cnt == 'd4) begin // 5 -1 
        neg_clk <= neg_clk; 
        neg_cnt <= 'd0;
    end else begin
        neg_clk <= neg_clk; // other cases remain the same value
        neg_cnt <= neg_cnt + 'd1;
    end
end

assign pos_clk5 = pos_clk; // delay output
assign neg_clk5 = neg_clk;
assign div5clk = pos_clk5 ^ neg_clk5;

endmodule


module clk_div_even (
  input logic i_clk, 
  input logic i_rst_b,
  input logic [9:0] i_div_num,  // it refers to the max cnt num. eg: div4, i_div_num = 3
  output logic o_clk_div
);

  logic [9:0] cnt, div_num_reg;
  logic temp_clk_div;

  // used for avoid glitch when i_div_num suddenly changed.
  always_ff @(posedge i_clk, negedge i_rst_b) begin
    if(!i_rst_b) div_num_reg <= 'd1; 
    else if (cnt == div_num_reg) div_num_reg <= i_div_num; // only get this input when I finish the previous counting.
  end

  // update cnt
  always_ff @(posedge i_clk, negedge i_rst_b) begin
    if(!i_rst_b) begin
      cnt <= 0;
    end else if (cnt == div_num_reg) begin
      cnt <= 0;
    end else begin
      cnt <= cnt + 'd1;
    end
  end
  
  // update the div clk
  always_ff @(posedge i_clk, negedge i_rst_b) begin
    if (!i_rst_b) begin
      temp_clk_div <= 0;
    end else if (cnt == div_num_reg || cnt == (div_num_reg >> 1)) begin
        temp_clk_div <= ~temp_clk_div;
    end else begin
        temp_clk_div <= temp_clk_div;
    end
  end

  assign o_clk_div = temp_clk_div;

endmodule


// in 7 cycles have 6 1's
module clk_div_7_6 (
  input logic i_clk, 
  input logic i_rst_b,
  output logic o_clk_div
);
  
  logic [6:0] shift_reg;

  always_ff @(posedge i_clk, negedge i_rst_b) begin
    if (!i_rst_b) begin
      shift_reg <= 'b111_1110;
    end else begin
      shift_reg <= {shift_reg[5:0], shift_reg[6]};
    end
  end

  assign o_clk_div = shift_reg[4];
endmodule