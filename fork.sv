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
