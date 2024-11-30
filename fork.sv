$display("A");
fork
    $display("B");
        #50; $display("C");
    begin
        $display("D");
        #30 $display("E");
        #10 $display("F");
    end
join_any
    $display("G");

// A B D E F G C



fork:f1
    #300 $display("thread 1");
    #350 $display("thread 2");
    begin
        fork: f2
            #350 $display("thread 3");
            #200 $display("thread 4");
        join_none
        #170 begin disable fork; 
            $display("disable fork");
        end
    end

    #300 $display("thread 5");
join_none

// only the thread 3,4 will be disabled, since we have the encapuslation for the f2


// task is static; function is automatic !!BY DEFAULT!!
for(inti=0;i<=10;i++)
begin
    fork
        automatic int j=i; //note you must declare a automatic copy of j here other wise it will be same value(10) when you spawn all some_task()
        begin
            printsomething;
            some_task(j);
        end
    join_none
end


// task varible also static in default, if no "automatic" added, the output is: 
// #11ns 20
// #20ns 20
task print(automatic i);
    #10ns;
    $display("%s ns %d", $time, i);
endtask

initial begin
    fork
        begin
            #1ns;print(10);
        end
        begin
            #10ns;print(20);
        end
    join 
end