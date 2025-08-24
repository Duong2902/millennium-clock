`timescale 1ns/1ps

module tb_leap_year_check;

  // DUT I/O
  reg  [9:0] year;     // 0..974  -> năm tuyệt đối = 2025 + year
  reg  [3:0] month;    // 1..12
  wire [4:0] max_day;

  // Instantiate DUT
  leap_year_check dut (
    .year   (year),
    .month  (month),
    .max_day(max_day)
  );

  // ---------------------------
    // ---------------------------
  // Hàm tham chiếu trong TB
  // ---------------------------
  function integer ref_is_leap;
    input integer abs_year;
    begin
      ref_is_leap = ((abs_year % 4) == 0) &&
                    (((abs_year % 100) != 0) || ((abs_year % 400) == 0));
    end
  endfunction

  function integer ref_max_day;
    input integer abs_year;
    input integer m;
    begin
      if (m==1 || m==3 || m==5 || m==7 || m==8 || m==10 || m==12)
        ref_max_day = 31;
      else if (m==4 || m==6 || m==9 || m==11)
        ref_max_day = 30;
      else if (m==2)
        ref_max_day = ref_is_leap(abs_year) ? 29 : 28;
      else
        ref_max_day = 31;
    end
  endfunction


  // ---------------------------
  // Kiểm thử toàn bộ dải
  // ---------------------------
  integer y, m, errors, checks, abs_year, expected;
  initial begin
    errors = 0;
    checks = 0;

    // Quét toàn bộ year=0..974 (tương ứng 2025..2999) và 12 tháng
    for (y = 0; y <= 974; y = y + 1) begin
      abs_year = 2025 + y;
      for (m = 1; m <= 12; m = m + 1) begin
        // Drive inputs
        year  = y[9:0];
        month = m[3:0];

        // Chờ lan truyền tổ hợp
        #1;

        // Tính kỳ vọng và so sánh
        expected = ref_max_day(abs_year, m);
        if (max_day !== expected[4:0]) begin
          $display("[ERROR] year_in=%0d (abs=%0d), month=%0d: DUT=%0d, EXP=%0d",
                   y, abs_year, m, max_day, expected);
          errors = errors + 1;
        end
        checks = checks + 1;
      end
    end

    // Một vài case nổi bật để log riêng (tùy thích)
    check_case(2028);  // leap (year=3)
    check_case(2100);  // không nhuận (year=75)
    check_case(2400);  // nhuận (year=375)
    check_case(2096);  // nhuận (year=71)

    $display("============================================");
    $display("Total checks: %0d, Errors: %0d", checks, errors);
    if (errors == 0) $display("[PASS] All tests passed!");
    else             $display("[FAIL] There are %0d mismatches.", errors);
    $display("============================================");

    $finish;
  end

  // Tiện ích: log nhanh một năm nổi bật cho tháng 2
  task automatic check_case(input integer abs_y);
    integer y_in;
    integer exp28_29;
    begin
      y_in = abs_y - 2025;
      if (y_in < 0 || y_in > 974) begin
        $display("[SKIP] abs_year=%0d ngoài dải DUT (2025..2999).", abs_y);
        disable check_case;
      end
      year  = y_in[9:0];
      month = 4'd2; // Tháng 2
      #1;
      exp28_29 = ref_max_day(abs_y, 2);
      if (max_day !== exp28_29[4:0]) begin
        $display("[ERROR-CASE] abs_year=%0d Feb: DUT=%0d, EXP=%0d",
                 abs_y, max_day, exp28_29);
      end else begin
        $display("[OK-CASE]    abs_year=%0d Feb: %0d days", abs_y, max_day);
      end
    end
  endtask

endmodule
