`timescale 1ns/1ps

module tb_top;

    reg         clk;
    reg         rst_n;
    reg         set_mode;
    reg         debug_signal;
    reg         sel;
    reg  [1:0]  set_select;
    reg         inc_btn;
    reg         dec_btn;
    wire [6:0]  HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

    dong_ho_thien_nien_ki dut (
        .clk(clk),
        .debug_signal(debug_signal),
        .rst_n(rst_n),
        .set_mode(set_mode),
        .sel(sel),
        .set_select(set_select),
        .inc_btn(inc_btn),
        .dec_btn(dec_btn),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3),
        .HEX4(HEX4), .HEX5(HEX5), .HEX6(HEX6), .HEX7(HEX7)
    );

    
    initial clk = 0;
    always #5 clk = ~clk;

    reg clk_1s_tb;
    initial clk_1s_tb = 0;
    always #5_000_000 clk_1s_tb = ~clk_1s_tb; 
    reg clk_0_5s_tb;
    initial clk_0_5s_tb = 0;
    always #2_500_000 clk_0_5s_tb = ~clk_0_5s_tb; 
    initial begin
        #1;
        force dut.clock_1s_i.clk_1s = clk_1s_tb;
        force dut.clock_1s_i.clk_0_5s = clk_0_5s_tb;
    end


    task pulse_inc_1s;
        begin
            @(posedge clk_1s_tb);
            inc_btn = 1'b0;
            repeat (5) @(posedge clk);
            inc_btn = 1'b1;
        end
    endtask

    task pulse_dec_1s;
        begin
            @(posedge clk_1s_tb);
            dec_btn = 1'b0;
            repeat (5) @(posedge clk);
            dec_btn = 1'b1;
        end
    endtask

    task wait_n_1s(input integer n);
        integer k;
        begin
            for (k=0; k<n; k=k+1) @(posedge clk_1s_tb);
        end
    endtask

    // -------------------------------
    // Stimulus
    // -------------------------------
    initial begin
        rst_n      = 0;
        set_mode   = 0;
        sel        = 0;       // 0: TIME, 1: DATE
        set_select = 2'd0;    // mặc định chọn SS
        inc_btn    = 1;
        dec_btn    = 1;

        // reset
        repeat (5) @(posedge clk);
        rst_n = 1;
        debug_signal = 0;
        $display("[%0t] Release reset", $time);

        wait_n_1s(3);

        // Vào chế độ chỉnh
        set_mode = 1;
        $display("[%0t] set_mode=1 (edit TIME)", $time);

        // Chọn chỉnh giây (SS)
        set_select = 2'd0;
        $display("[%0t] set_select=SS", $time);

        // Tăng 3 lần giây
        pulse_inc_1s();
        pulse_inc_1s();
        pulse_inc_1s();
        wait_n_1s(1);

        // Chuyển sang phút (MM) và tăng 2 lần
        set_select = 2'd1;
        $display("[%0t] set_select=MM", $time);
        pulse_inc_1s();
        pulse_inc_1s();
        wait_n_1s(1);

        // Chuyển sang giờ (HH), giảm 1 lần
        set_select = 2'd2;
        $display("[%0t] set_select=HH", $time);
        pulse_dec_1s();
        wait_n_1s(1);

        // Chuyển sang DATE
        sel = 1;
        $display("[%0t] sel=1 (edit DATE)", $time);

        // Chọn ngày (DD), tăng 1 lần
        set_select = 2'd0;
        $display("[%0t] set_select=DD", $time);
        pulse_inc_1s();
        wait_n_1s(1);

        // Chọn tháng (MM), tăng 1 lần
        set_select = 2'd1;
        $display("[%0t] set_select=MONTH", $time);
        pulse_inc_1s();
        wait_n_1s(1);

        // Chọn năm (YYYY), tăng 2 lần
        set_select = 2'd2;
        $display("[%0t] set_select=YEAR", $time);
        pulse_inc_1s();
        pulse_inc_1s();
        wait_n_1s(1);

        // Thoát chế độ chỉnh
        set_mode = 0;
        $display("[%0t] set_mode=0 (run)", $time);

        // Chạy tự do thêm vài “giây”
        wait_n_1s(5);

        $display("[%0t] Testbench finished.", $time);
        $finish;
    end

endmodule