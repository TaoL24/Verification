
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



// Module 4: Sequences

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



// Module 5: Coverage

//throughout DRdy[*1:3], Busy should remain high
C1: cover property (@(posedge clk) ( (GntA || GntB) ##1 (Busy throughout DRdy[*1:3]) ##0 Done) );

// it has 2 meanings:
// 1) A followed by B
// 2) A not occurring, this is not what we want 
C12: cover property ( A |=> B);

// in this 2) case, we could use cover sequence
C13: cover sequence ( A ##1 B);
// cover sequence ( A |=> B); is illegal!!!!!


// Module 6: Liveness Properties

// weak prop: claims nothing bad happens, in finite waveform
SAFETY1: assert property (@(posedge clk) A |-> weak(!C[*] ##0 B) );

// strong prop: claims something good happens, eventually, in infinite waveform
LIVENESS1: assert property (@(posedge clk) A |-> strong(!C[*] ##0 B) );

// Linear Temporal Logic (LTL) Operators

// S_EVEN_UBND equals to P2
S_EVEN_UBND: assert property (REQ |-> s_eventually GNT);
P2: assert property (REQ |-> strong(##[0:$] GNT) );

// Module 7

// Behavior of the DUT: Assertions

// Behavior of DUT’s environment(input): Assumptions (normally used in formal)


// Module 8: Auxiliary code




// Module 10: Sequence Operations

// sequence funsion: seq_b starts in the same cycle as seq_a completes
SEQ_A ##0 SEQ_B

// sequence or: either one seq holds at the current cycle

// sequence and: sequences to start at the same time, may finishing in different cycle

// sequence intersect: length matching and, start in the same cycle and end in the same cycle

// first_match operator
// On RHS of implication operator, there is an implicit first_match of any sequence

// useful at LHS: removing undesired failure
sequence SEQ_CD;
    C[*1:3] ##1 D;
endsequence

property LHS_FM;
    first_match(SEQ_CD) |=> E;
endproperty

property LHS;
    SEQ_CD |=> E;
endproperty

// sequence throughout
expr1 throughout seqa;
// same as 
expr1[*0:$] intersect seqa;

// sequence within
S_ACK_WIN_10: assert property ( @(posedge CLK) $rose(start) |-> ack[*1:3] within 1'b1[*10] );

// but actually ack can happen more than 3 times with in 10 windows

// cuz this is equivalent to this according to LRM states:
S_ACK_WIN_10_EQUIV: assert property ( @(posedge CLK) $rose(start) |->( 1'b1[*0:$] ##1 ack[*1:3] ##1 1'b1[*0:$] ) within 1'b1[*10] );

// better solution for these is using aux code, create a shift reg to $countones()

// Quiz:

sequence q10_1;  
    PULSE[=4] intersect 1[*10];
endsequence

sequence: q10_2;
    GO ##1 ERR or ENB[*3:7];
endsequence

sequence q10_3;
    STRT ##1 (PUSH && !KILL)[*6];
endsequence

sequence q10_4;
    !STOP throughout POP[->6];
endsequence

property q10_p1;
    @(posedge clk) q10_3 |=> q10_4;
endproperty

A10_1: assert property(q10_p1);




// Module 11: Advanced SVA Features

// trigger sequence method: endpoint
// we don't use "ended" anymore 
'define true 1
sequence EP2; 
    (req ##1 ack ##2 'true);
endsequence

property SEQ;
    @(negedge clk) $rose(A) |=> EP2.triggered;
endproperty

// using local variable 
property count_cycles;
    int cyc;
    @(posedge clk)
    ($rose(start), cyc=0) |=> (!end, cyc++)[*4:14] ##1 ( (end && short && cyc<=10) or (end && long && cyc>10) );
endproperty


// lab: SPI verification
localparam [7:0] expected_start = 8'hee;
localparam [7:0] expected_config = 8'hc3;
localparam [7:0] expected_read = 8'haa;

// result of header is stored at header_res(output!)
sequence get_header(frame_sig, data_sig, logic [7:0] header_res);
  logic [7:0] header;
  int i = 0;
  ($rose(frame_sig), header=0) ##1 (frame_sig, header[i]=data_sig, i++)[*8] ##0 (1, header_res == header);
endsequence
// here '1,xx=xx' means make the tuple always execute in the current cycle

sequence check_start(data);
  !frame && (data == expected_start);
endsequence

sequence check_read(data);
  frame[*10] ##1 !frame && (data == expected_read);
endsequence

sequence check_config(data);
  frame[*8] ##1 !frame && (data == expected_config);
endsequence

// here we use |-> cuz in get_header we already done the ##1
property framecheck;
  logic [7:0] header_p = 0;
  @(posedge clk iff !suspend)
  $rose(frame_sig) |-> get_header(frame, serial, header_p) ##1 
                      (check_start(header_p) or check_read(header_p) or check_config(header_p));
endproperty

FRMCHK_BEST :  assert property(framecheck);


// Module 12: Constructs for property

// until, until_with, s_until, s_until_with
P_UNTIL_NOVRLP_W: assert property (B |=> (C until D) );
P_UNTIL_OVRLP_W:  assert property (B |=> (C until_with D) );
P_UNTIL_NOVRLP_S: assert property (B |=> (C s_until D) );
P_UNTIL_OVRLP_S:  assert property (B |=> (C s_until_with D) );

// always <property expression>
// Defines a property which requires <property expression> to be true in the current cycle and all future cycles
assume property (s_eventually always !request);

// follow by operator
seq #-# prop; // overlapping, equivalent to 
not (sequence_expr |-> not property_expr);

seq #=# prop; // nonoverlapping, equivalent to 
not (sequence_expr |=> not property_expr);

// useful use:
// Make sure precondition can be hit and extended to infinity

assert property (a |-> s_eventually b); // liveness assert
cover  property (a #-# always 1); // make sure a happens, not vacuously true!!!!


// implies 
// For the expression to pass prop2 must be true if prop1 is ture
prop1 implies prop2;
// they are evaluated concurrently!!!!