class router_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(router_scoreboard)

     
    `uvm_analysis_imp_decl(_yapp)
    uvm_analysis_imp_yapp #(yapp_packet, router_scoreboard) yapp_in;

    `uvm_analysis_imp_decl(_chan0)
    uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) chan0_in;

    `uvm_analysis_imp_decl(_chan1)
    uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) chan1_in;

    `uvm_analysis_imp_decl(_chan2)
    uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) chan2_in;

    // scoreboard packet queues
    yapp_packet q0[$];
    yapp_packet q1[$];
    yapp_packet q2[$];

    // scoreboard statistics
    int packet_in, in_dropped;
    int packet_ch0, compare_ch0, miscompare_ch0, dropped_ch0;
    int packet_ch1, compare_ch1, miscompare_ch1, dropped_ch1;
    int packet_ch2, compare_ch2, miscompare_ch2, dropped_ch2;


    function void new (string name, uvm_component parent);
        super.new(name, parent);
        yapp_in = new("yapp_in", this);
        chan0_in = new("chan0_in", this);
        chan1_in = new("chan1_in", this);
        chan2_in = new("chan2_in", this);
    endfunction: new 

    virtual function void write_yapp(yapp_packet packet);
        yapp_packet ypkt;
        // make a copy for storing in the scoreboard
        $cast(ypkt, packet.clone()); // clone returns uvm_object type, need downcast checking
        packet_in++;
        case (ypkt.addr)
            2'b00: begin 
                q0.push_back(ypkt);
                `uvm_info(get_type_name(), "Added packet to Scoreboard Queue 0", UVM_HIGH)
            end
            2'b01: begin
                q1.push_back(ypkt);
                `uvm_info(get_type_name(), "Added packet to Scoreboard Queue 1", UVM_HIGH)
            end
            2'b11: begin
                q2.push_back(ypkt);
                `uvm_info(get_type_name(), "Added packet to Scoreboard Queue 2", UVM_HIGH)
            end
            default: begin
                `uvm_info(get_type_name(), $sformatf("Packet Dropped: Bad Address=%d\n%s",ypkt.addr,ypkt.sprint()), UVM_LOW)
                in_dropped++;
            end
        endcase
    endfunction

    virtual function void write_chan0(channel_packet cp);
        yapp_packet yp;
        packet_ch0++;
        if (q0.size() == 0) begin
            `uvm_error(get_type_name(), $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_0 Packet!\n%s", packet.sprint()))
            dropped_ch0++;
            return;
        end

        if (comp_uvm(q0[0], cp)) begin
            void'(q0.pop_front());
            `uvm_info(get_type_name(), $sformatf("Scoreboard Comapre Match: Channel_0 Packet\n%s", packet.sprint()), UVM_MEDIUM)
            compare_ch0++
        end else begin
            yp = q0[0];
            `uvm_warning(get_type_name(), $sformatf("Scoreboard Error [MISMATCH]: Channel 0 received WRONG packet: \nExpected:\n%s\nGot:\n%s",
						yp.sprint(), cp.sprint()))
            miscompare_ch0++;
        end
    endfunction : write_chan0

    // skip for write_chan1, write_chan2

    // custom packet compare function using uvm_comparer methods
    function bit comp_uvm(input yapp_packet yp, input channel_packet cp, uvm_comparer comparer = null);
        string str;
        if (comparer == null) begin
            comparer = new();
            comp_uvm = comparer.compare_field("addr", yp.addr, cp.addr, 2);
            comp_uvm &= comparer.compare_field("length", yp.length, cp.length, 6);
            foreach(yp.payload[i]) begin
                str.itoa(i);
                comp_uvm &= comparer.compare_field({"payload[",str ,"]"}, yp.payload[i], cp.payload[i], 8);
            end
            comp_uvm &= comparer.compare_field("parity", yp.parity, cp.parity, 8);
        end;
    endfunction : comp_uvm

    // custom packet compare function using inequality operators
    function bit comp_equal (input yapp_packet yp, input channel_packet cp);
        // returns first mismatch only
        if (yp.addr != cp.addr) begin
        `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
        return(0);
        end
        if (yp.length != cp.length) begin
        `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
        return(0);
        end
        foreach (yp.payload [i])
        if (yp.payload[i] != cp.payload[i]) begin
            `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
            return(0);
        end
        if (yp.parity != cp.parity) begin
        `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
        return(0);
        end
        return(1);
    endfunction : comp_equal


    function void check_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Checking Router Scoreboard", UVM_LOW)
        if (q0.size() || q1.size() || q2.size()) begin // if any of q is not empty, that means sth wrong!
            `uvm_error(get_type_name(), $sformatf("Check:\n\n  WARNING: Router Scoreboard Queue's NOT empty: \n  Chan0: %0d\n   Chan1: %0d\n,  Chan2: %0d\n", 
                                                    q0.size(), q1.size(), q2.size()))
        end else begin
            `uvm_info(get_type_name(), "Check:\n\n  Router Scoreboard Empty!\n", UVM_LOW)
        end
    endfunction : check_phase


    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report:\n\n Scoreboard: Packet Statistics \n    
                                             Packet In: %0d  Packets Dropped: %0d \n
                                             Channel 0 Total: %0d  Pass: %0d Miscompare: %0d Dropped: %0d\n
                                             Channel 1 Total: %0d  Pass: %0d Miscompare: %0d Dropped: %0d\n
                                             Channel 2 Total: %0d  Pass: %0d Miscompare: %0d Dropped: %0d\n ",	
                                             packet_in, in_dropped,
                                             packet_ch0, compare_ch0, miscompare_ch0, dropped_ch0, 
                                             packet_ch1, compare_ch1, miscompare_ch1, dropped_ch1, 
                                             packet_ch2, compare_ch2, miscompare_ch2, dropped_ch0), UVM_LOW)

        if ((dropped_ch0 + dropped_ch1 + dropped_ch2 + miscompare_ch0 + miscompare_ch1 + miscompare_ch2) > 0)
            `uvm_error(get_type_name(), "Simulation FAILED!")
        else
            `uvm_info(get_type_name(), "Simulation PASSED!", UVM_NONE)
    endfunction : report_phase


endclass