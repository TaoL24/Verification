module canDiv3 (
  input logic i_clk, 
  input logic i_rst_b,
  input logic [9:0] i_data, 
  input logic i_run_fsm,
  output logic o_done, 
  output logic o_div2, 
  output logic o_div3
);

  // sol 1: finish in mul cycles
  logic [9:0] tmp_data;

  always_ff @(posedge i_clk, negedge i_rst_b) begin
    if (!i_rst_b) begin
      o_done <= 'd0;
      o_div2 <= 'd0;
      o_div3 <= 'd0;
      tmp_data <= 'd0;
    end else if (i_run_fsm) begin
      tmp_data <= i_data;
      o_done <= 1'b0;
    end else if (tmp_data > 'd2) begin
      tmp_data <= tmp_data - 'd3;
    end else begin
      o_div2 <= i_data[0] == 0;
      o_div3 <= tmp_data == 0;
      o_done <= 1'b1;
    end
  end


  // sol 2: finish in 1 cycle
  always_ff @(posedge i_clk, negedge i_rst_b) begin
    if (!i_rst_b) begin
      o_done <= 'd0;
      o_div2 <= 'd0;
      o_div3 <= 'd0;
    end else if (i_run_fsm) begin 
      o_div2 <= i_data[0] == 0;
      o_div3 <= i_data % 3 == 0;
      o_done <= 1'b1; // finish in one cycle
    end else begin
      o_done <= 1'b0;
    end
  end
endmodule