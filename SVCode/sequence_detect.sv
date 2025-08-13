module seq_detect (
    input clk,rst,
    input in,
    output logic out
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
        default: next_state = (in)? S_1: IDLE;   // !!!!! need to have default case to avoid latch
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


//Melay FSM
module seq_detect_melay(
    input clk, rstn,
    input logic in,
    output logic out
);

// 11010

// typedef enum logic [2:0] {S_IDLE, S_1, S_11, S_110, S_1101} state_t;
// state_t state, next_state; 
localparam S_IDLE = 0,
           S_1    = 1,
           S_11   = 2,
           S_110  = 3,
           S_1101 = 4;

logic [2:0] state, next_state; // 5 state

always_ff @(posedge clk, negedge rstn) begin
    if(!rstn) state <= S_IDLE;
    else      state <= next_state;
end

always_comb begin
    case(state)
        S_IDLE: next_state  = (in) ? S_1    : S_IDLE;
        S_1:    next_state  = (in) ? S_11   : S_IDLE; 
        S_11:   next_state  = (in) ? S_IDLE : S_110;
        S_110:  next_state  = (in) ? S_1101 : S_IDLE;
        S_1101: next_state  = (in) ? S_11   : S_IDLE; // overlap
        default: next_state = (in) ? S_1    : S_IDLE;
    endcase
end

always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) out <= 0;
    else begin
        case(state)
            S_IDLE: out  <= '0;
            S_1:    out  <= '0; 
            S_11:   out  <= '0;
            S_110:  out  <= '0;
            S_1101: out  <= (in) ? 'b0 : 'b1;
            default: out  <= '0;
        endcase
    end
end
endmodule
