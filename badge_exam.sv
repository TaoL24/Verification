// Q1
module task_fn;
    integer x = 5, y = 5;
    function integer write_fn_x();
        write_fn_x = x + y;  // return 5+5=10
    endfunction
endmodule

module top();
    task_fn f1;  // init task_fn: f1
    integer x = 10, y = 10;  // local varible: no impact on x,y in task_fn
    initial begin
        $display("Value of Z is %d", f1.write_fn_x());  // 10!!!
    end
endmodule

// Q2: 1.14
package P1; 
    localparam int c1 = 10; 
    typedef enum {start,stop} fsm_states_t; 
    logic [7:0] data_valid = 'd5; 
    logic enable;
endpackage: P1 

package P2; 
    logic enable; 
endpackage: P2 

module pkg_use(); 
    import P1::*; 
    import P2::*; 
    logic [7:0] data_valid = 'd7; 
    initial begin 
        data_valid ++; 
        $display("Value of data_valid is %d", data_valid); // ??????????error or can still display?????!!!
    end 
endmodule

//Q3: 1.17
// What are the number of bins generated for cross cover point 'c3xc2' in this code? 
typedef enum bit [2:0] {IDLE, PLAY, PAUSE, INCR, DECR, STOP, REWIND} op_t; 
typedef enum bit [1:0] {REGO, REG1, REG2, REG3} regs_t; 

op_t opc; 
regs_t regs; 
logic [3:0] data; 

covergroup cg @(posedge clk); 
    c1: coverpoint opc { bins op[] = { [PLAY:$] }; } 
    c2: coverpoint regs; 
    c3: coverpoint data { bins low [] = { [0:'h03] }; bins high = { ['h4:'h8] }; } 
    c3xc2: cross c3,c2 { bins cross1 = binsof (c2) intersect {REG1} && binsof (c3) intersect {2}; } 
endgroup 

cg cg1 = new();

// 1.19
// In this code, what is the randomization weight for 'data' values of 15, 30 and 40 
class randclass; 
rand int data; 
    constraint c_data {data dist { [11:20]:=3, [26:30]:/5}, 40:=2;} 
endclass


// 1.27 An interface can have multiple clocking blocks per clock domain?
//YES

// 1.30
enum {A1=0,A2,A3} enum1; 
enum bit [2:0] {A4 = 1,A5, A6, A7} enum2; 
enum logic [3:0] {A8 = 5, A9} enum3;

initial begin 
    $display("enum1 value &b, enum1 name %s ",enum1, enum1.name());  //enum1 value 0, enum1 name A1
    $display("enum2 value &b, enum2 name %s ",enum2, enum2.name());  //enum2 value 0, enum2 name 
    $display("enum3 value &b, enum3 name %s", enum3, enum3.name());  //enum3 value x, enum3 name
end


 