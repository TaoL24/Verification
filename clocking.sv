create_clock -name clk -period 10.0
set_input_delay -clock clk 3.0 [get_ports clk1] 


clocking cb @(posedge clk);
    default input #1step output #3;
    input dout;     // output for DUT
    output reset, data; // input for DUT
    output negedge enab;
endclocking

// example for cycle delay
default clocking cb1 @(posedge clk);
    input #2 dout;
    output #3 reset, data;
endclocking

clocking cb4 @(negedge clk);
    output #3 enab, rdata;
endclocking

initial begin
// Wait 2 cb1 cycles
repeat (2) @(cb1);
// Wait 2 cb1 cycles
##2;
// Drive data after 1 cb cycle
##1  cb1.data <= 2'b01;
##1; cb1.data <= 2'b10;
// Drive rdata with current dreg
// value after 3 cb4 cycles
cb4.rdata <= ##3 dreg;
end


// inter-statement assignment/ intra-statement assignment difference
#5 a = b; // inter
a = #5 b; // intra 
a = @(posedge clk) b; 
a = repeat(5) @(posedge clk) b;
