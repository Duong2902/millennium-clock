
module dong_ho_thien_nien_ki(
    input clk,
    input rst_n,
    input set_mode, 
	input sel,
    input debug_signal,
    input [1:0] set_select,
    input inc_btn,
    input dec_btn,
    output  [6:0] HEX0,
    output  [6:0] HEX1,
    output  [6:0] HEX2,
    output  [6:0] HEX3,
    output  [6:0] HEX4,
    output  [6:0] HEX5,
    output  [6:0] HEX6,
    output  [6:0] HEX7
);

wire clk_1s, clk_0_5s;
wire [5:0] sec, min;
wire [5:0] hour;
wire [5:0] day;
wire [5:0] month;
wire [9:0] year;


// Tạo clock 1s
clock_1s clock_1s_i ( 
    .sys_clk (clk),
    .debug_signal (debug_signal),
    .reset_n (rst_n),
    .clk_1s(clk_1s),
    .clk_0_5s (clk_0_5s)
);

// Bộ đếm thời gian
time_counter time_counter_i ( 
    .clk_1s(clk_1s),
    .rst_n (rst_n),
    .set_mode (set_mode),
    .set_select (set_select),
    .sel (sel),
    .inc_btn (inc_btn),
    .dec_btn (dec_btn),
    .sec (sec),
    .min (min),
    .hour (hour),
    .day (day),
    .month (month),
    .year (year)
);

wire blink_i ;
blink blink_block (
    .clk_0_5s(clk_0_5s),
    .rst_n (rst_n),
    .set_mode (set_mode),
    .blink (blink_i)
    );

//display
display display_i (.set_mode (set_mode),
                    .sel (sel),
                    .set_select (set_select),
                    .blink (blink_i),
                    .sec (sec),
                    .min (min),
                    .hour (hour),
                    .day (day),
                    .month (month),
                    .year (year),
                    .HEX0 (HEX0),
                    .HEX1 (HEX1),
                    .HEX2 (HEX2),
                    .HEX3 (HEX3),
                    .HEX4 (HEX4),
                    .HEX5 (HEX5),
                    .HEX6 (HEX6),
                    .HEX7 (HEX7)
);
endmodule