
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
