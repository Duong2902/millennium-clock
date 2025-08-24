
module display (
    input set_mode, 
	input sel,
    input [1:0] set_select,
    input blink,
    input [5:0] sec, min,
    input [5:0] hour,
    input [5:0] day,
    input [5:0] month,
    input [9:0] year,
    output  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
);
reg [3:0] d0, d1, d2, d3, d4, d5, d6, d7;
wire [9:0] year_plus = year + 25;
wire [3:0] sec_ten, sec_one, min_ten, min_one, hour_ten, hour_one, day_ten, day_one, month_ten, month_one, year_ten, year_one, year_hund;
//giải mã binary thành từ d0-d7
binary_decoder extract_bits_sec (.din(sec),
                          .led_ten(sec_ten),
                          .led_one(sec_one));

binary_decoder extract_bits_min (.din(min),
                          .led_ten(min_ten),
                          .led_one(min_one));

binary_decoder extract_bits_hour (.din(hour),
                          .led_ten(hour_ten),
                          .led_one(hour_one));

binary_decoder extract_bits_day (.din(day),
                          .led_ten(day_ten),
                          .led_one(day_one));

binary_decoder extract_bits_month (.din(month),
                          .led_ten(month_ten),
                          .led_one(month_one));

binary_decoder_year extract_bits_year (.din(year_plus),
                          .led_hundred(year_hund),
                          .led_ten(year_ten),
                          .led_one(year_one));
always @(sel or set_mode or blink or set_select or
          sec_one or sec_ten or
          min_one or min_ten or
          hour_one or hour_ten or
          day_one or day_ten or
          month_one or month_ten or
          year_one or year_ten or year_hund ) begin
    if (sel == 1'b0) begin
            d0 = sec_one;  d1 = sec_ten;
            d2 = min_one;  d3 = min_ten;
            d4 = hour_one; d5 = hour_ten;
            d6 = 4'd10;  d7 = 4'd10; // trống
    end else begin
            d0 = day_one;   d1 = day_ten;
            d2 = month_one;   d3 = month_ten;
            d4 = year_one;  d5 = year_ten;
            d6 = year_hund;  d7 = 4'd2;
        end
    if (set_mode && blink) begin
            if (sel == 1'b0) begin
                // TIME
                case (set_select)
                    2'd0: begin d0 = 4'd10; d1 = 4'd10; end // SS
                    2'd1: begin d2 = 4'd10; d3 = 4'd10; end // MM
                    2'd2: begin d4 = 4'd10; d5 = 4'd10; end // HH
                    default:begin
                        d0 = d0;
                        d1 = d1;
                        d2 = d2;
                        d3 = d3;
                        d4 = d4;
                        d5 = d5;
                    end 
                endcase
            end else begin
                // DATE
                case (set_select)
                    2'd0: begin d0 = 4'd10; d1 = 4'd10; end        // DD
                    2'd1: begin d2 = 4'd10; d3 = 4'd10; end        // MM
                    2'd2: begin d4 = 4'd10; d5 = 4'd10; d6 = 4'd10; d7 = 4'd10; end // YYYY
                    default: begin
                        d0 = d0;
                        d1 = d1;
                        d2 = d2;
                        d3 = d3;
                        d4 = d4;
                        d5 = d5;
                        d6 = d6;
                        d7 = d7;
                    end
                endcase
            end
     end
     else begin
        d0 = d0;
        d1 = d1;
        d2 = d2;
        d3 = d3;
        d4 = d4;
        d5 = d5;
        d6 = d6;
        d7 = d7;
     end
end

bcd_to_7seg bcd0 (.bcd(d0), .seg(HEX0));
bcd_to_7seg bcd1 (.bcd(d1), .seg(HEX1));
bcd_to_7seg bcd2 (.bcd(d2), .seg(HEX2));
bcd_to_7seg bcd3 (.bcd(d3), .seg(HEX3));
bcd_to_7seg bcd4 (.bcd(d4), .seg(HEX4));
bcd_to_7seg bcd5 (.bcd(d5), .seg(HEX5));
bcd_to_7seg bcd6 (.bcd(d6), .seg(HEX6));
bcd_to_7seg bcd7 (.bcd(d7), .seg(HEX7));


endmodule