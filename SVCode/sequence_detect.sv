module seq_detect (
    input clk,rst;
    input in;
    output logic out;
);
    
// 10010 detector!!!

//Moore FSM
localparam  IDLE    = 0, 
            S_1     = 1, 
            S_10    = 2, 
            S_100   = 3, 
            S_1001  = 4, 
            S_10010 = 5;  // Define different value for state
logic [2:0] state, next_state; // enough bit width for handling the diff para

always_ff @(posedge clk, negedge rst) begin
    if (!rst) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state) 
        IDLE:    next_state = (in)? S_1: IDLE; 
        S_1:     next_state = (in)? S_1: S_10; 
        S_10:    next_state = (in)? S_1: S_100; 
        S_100:   next_state = (in)? S_1001: IDLE; 
        S_1001:  next_state = (in)? S_1: S_10010; 
        S_10010: next_state = (in)? S_1: S_100; 
        default: next_state = IDLE;   // !!!!! need to have default case to avoid latch
    endcase
end

always_ff @(posedge clk, negedge rst) begin
    if(!rst) begin
        out <= 0;
    end else begin
        case(state)
            IDLE:    out <= 0; 
            S_1:     out <= 0; 
            S_10:    out <= 0; 
            S_100:   out <= 0; 
            S_1001:  out <= 0; 
            S_10010: out <= 1; 
        endcase
    end
end





endmodule