
logic clk;
logic w_en,r_en;

always @(posedge clk) begin
    CHECK_EN: assert(~(w_en && r_en))
    else begin
        $info("");
        $error(""); // default
        $warning("");
        $fatal("")
        $$display("Failed at %m !");
    end
end

// immediate assertion: single cycle
always_ff @( posedge clk ) begin : CHECK_SER
    @(posedge w_en);
    repeat(16) begin
        @(posedge clk or negedge w_en);
        SP: assert (w_en)
        else begin
            $error("low pulse: not stasify the requirement");
            disable CHECK_SER;
        end
    end
    
    @(posedge clk or negedge w_en);
    LP: assert (~w_en) 
    else begin
        $error("long pulse");
    end
    
end

// concurrent assertion: span multiple cycles
SPI: assert property(
    @(posedge clk)
    !w_en ##1 w_en |-> w_en[*16] ##1 !w_en
);

property P1;
    @(posedge clk iff VALID) en1 || en2;
endproperty

/* quiz 
If the req-ack handshake occurs then:
● gnt is true on only the 2nd cycle after the req ack handshake.
● ends is true on only the 6th cycle after gnt is true.
*/
property HANDSHAKE;
    @(negedge clk) (req ##1 ack) |=> (!gnt ##1 gnt ##1 (!gnt && !ends)[*5] ##1 (!gnt && ends) ) ;
endproperty

A1: assert (HANDSHAKE);



// SVA Courses:

// Module 2: ABV
A1: assert property( @(posedge clk) (disable iff !RST) !(W_EN && R_EN) );

// edge-triggered avoid overlapping
$rose(); // it is the equivalent of (A != 1'b1 ##1 A)
$fell();

$stable(); // A == $past(A)

$countones(); // numbers of 1's
$isunknown(); // TRUE is X or Z

$onehot(); // true only if exact one bit is 1
$onehot0(); // true only if at most one bit is 1

// Quiz:
property p1;
    @(posedge clk) (A || B) |=> op1;
endproperty

property p2;
    @(posedge clk) !(B && C) |=> op2;
endproperty

property p3;
    @(posedge clk) !C |=> op3;
endproperty

// no enough!!! does not consider the cases when opx is 0!!!!!!!!!
// more tests:
p1_b: assert property( @(posedge clk) op1 |-> $past(A||B));
p1_b: assert property( @(posedge clk) op1 == $past(A||B));



// Module 3: Sequences

// fpr syncchronous abort
sync_accept_on();
sync_reject_on();
ABORT_PASS_ON_CLR: assert property @(posedge CLK) A |=> sync_accept_on(CLR) (B ##1 C ##1 D);


// cylce delay:
expr1 ##[min:max] expr2;

// Consecutive Repetition
seq[*N];

// Consecutive Repetition with Range
SEQ_CD[*1:3] ##1 E;

// special empty seq: 
// using the LRM rule (EMPTY ##N seq) is equivalent to (##(n-1) seq) for n>0
[*0:2];

// Not necessarily Consecutive Repetition
property NONCONSEC_REP;
    @(negedge CLK) A |-> B[=2] ##1 C;
endproperty

property GOTO_REP;
    @(negedge CLK) A |-> B[->2] ##1 C; //Last occurrence of B must be followed immediately by C
endproperty


//Quiz
property q3;
    @(posedge clk) (Req ##1 Ack) |-> !Gnt ##[1:2]   Gnt ##1 !Finish[*5] ##1 Finish; 
    @(posedge clk) (Req ##1 Ack) |-> !Gnt[*1:2] ##1 Gnt ##1 !Finish[*5] ##1 Finish; // 2nd approach
endproperty

