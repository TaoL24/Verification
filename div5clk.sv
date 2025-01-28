module div5clk #(parameter N = 5) 
    (input clk, 
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
    end
    else if (pos_cnt == 'd2) begin // (5-1) / 2 = 2
        pos_clk <= ~pos_clk;
    end 
    else if (pos_cnt == 'd4) begin // 5 -1 
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
    else if (pos_cnt == 'd0) begin
        neg_clk <= ~neg_clk;
    end
    else if (pos_cnt == 'd2) begin // (5-1) / 2 = 2
        neg_clk <= ~neg_clk;
    end 
    else if (pos_cnt == 'd4) begin // 5 -1 
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