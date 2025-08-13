class randc_imp #(int N = 8);

parameter iter = 2**N;

logic [N-1:0] pool [$];
// int index;

function new();
  this.reset();
endfunction

function void reset();
  pool.delete();
  // index = 0;

  for(int i=0; i<iter; i++) begin
    pool.push_back(i);
  end
  pool.shuffle();

  // while(pool.size()>0) begin
  //   index = $urandom(0, iter);
  //   if (pool.exist(index)) begin
  //     pool.delete(index);
  //   end
  // end
endfunction

function logic [N-1:0] get_next_value();
  if (pool.size()>0) begin
    return pool.pop_front();
  end else begin
    $fatal("No more unique values. Please call reset().");
  end
endfunction

endclass


randc_imp #(4) ins = new();
repeat(16) begin
  $display("Randc Value: %d",ins.get_next_value);
end


// async reset, sync release
module reset_gen(
  input clk,
  input a_rstn,
  output logic rstn_1 // this is relavant to clk, so it is SYNC!!!!
);

logic rstn_0;

always @(posedge clk, negedge a_rstn) begin
  if (!a_rstn) begin
    rstn_0 <= 0;
    rstn_1 <= 0;
  end else begin
    rstn_0 <= 1'b1; // !!!
    rstn_1 <= rstn_0;
  end
end

endmodule