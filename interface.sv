interface bus_if;
    logic a, b, c, d;
    modport master(
        input a, b,
        output c, d
    );

    modport slave (
        input c, d,
        output a, b
    );
endinterface: bus_if

module bus_master(bus_if.master mbus);
endmodule

module bus_slave (bus_if.slave sbus);
endmodule

module testbench
    bus_if ins1 ();
    bus_master m1 (.mbus(ins1));
    bus_slave s1 (.sbus(ins1));
endmodule


// Quiz
interface q_bus_if(input clk, input rst);
    logic as, rw, ds;
    logic [7:0] addr;
    logic da;
    logic [15:0] data;

    modport read (
        input da, data,
        output addr, as, rw, ds
    );
    modport mgr (
        output da, data,
        input addr, as, rw, ds
    );
endinterface: q_bus_if

module busread (q_bus_if bus);

endmodule

module busmgr (q_bus_if bus);

endmodule

module q_testbench();
    logic clk, rst = 0;
    q_bus_if if1 (clk, rst); 
    busread U1 = (if1.read);
    busread U2 = (if1.mgr);
    // busread U1(.clk(clk), .rst(rst), .bus(if1.read));
    // busmgr U2(.clk, .rst, .bus(if1.mgr));
endmodule