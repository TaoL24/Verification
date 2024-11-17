
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