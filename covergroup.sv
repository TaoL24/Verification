logic [3:0] var1;

// bin: acted as counter 
// scalar bin, vector bin, automatic bin
covergroup cg1 @(posedge clk);
    ce: coverpoint var1 {
        // 1 bin for illegal values {0,15}
        illegal_bins a = {0, 15};
        // 1 bin for ignored values {13, 14}
        // (value 15 is illegal)
        ignore_bins b = {[13:15]};
        // 1 bin for {2, 3}
        bins c = {2, 3};
        // 3 bins e[1] e[2] e[6]
        bins e[] = { [0:2], 2, 6};
        // 2 bins - d[0] = {9,10,11,9}
        //        - d[1] = {12}
        bins d[2] = {[9:11], 9, [12:15]};
        // 1 bin for {4, 5, 7, 8}
        bins f = default; 
    }
endgroup: cg1

// cross
logic [1:0] a;
logic [2:0] b;
logic c;

covergroup cg2 @(posedge clk);
    bcp: coverpoint b{
        bins b1 = {[9:12]}; // 1 bin
        bins b2[] = {[13:15]}; // 3 bins
        bins restofb = default; // 9 bins  
    }
    ccp: coverpoint c; // 2 automatic bins
    axbxc: cross a, bcp, ccp; // 32 bins = a(4) x bcp (4) x ccp (2)
endgroup

// coverpoint bin for value tansitions
covergroup cg3;
    c1: coverpoint cp {
        bins adsu = (ADDI => SUBI);
        bins suan = (ADDI => SUBI => ANDI);
        bins su3 = (ADDI, SUBI => ANDI);
    }
endgroup

// type_option and option
int a, b;
covergroup cg4 @(posedge clk)
    c1: coverpoint a {option.auto_bin_max = 10}
    c2: coverpoint b;
endgroup: cg4

cg4 one = new;
one.c2.option.auto_bin_max = 256;