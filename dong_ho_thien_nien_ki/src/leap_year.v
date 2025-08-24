module leap_year_check (
    input [9:0] year, // 0–974
    input [5:0] month,
    output reg [4:0] max_day
);
    wire [11:0] sum = 2025 + year;
    wire divisible_by_4 = ((sum[1:0]) == 2'b00); //divisible_by_4 = ( sum % 4 == 0)
    wire divisible_by_16 = ((sum[3:0]) == 2'b00); //divisible_by_16 = ( sum % 16 == 0)

    wire [9:0] tmp_100 = sum [11:2];
    wire [4:0] a1_100 = tmp_100 [9:5]; // tmp_100 / 32
    wire [4:0] a2_100 = tmp_100 [4:0]; // tmp_100 % 32
    wire [7:0] tmp_400 = sum [11:4];
    wire [4:0] a1_400 = {2'b0,tmp_400 [7:5]}; // tmp_400 / 32
    wire [4:0] a2_400 = tmp_400 [4:0]; // tmp_400 % 32

    function [4:0] mul7_mod25;
        input [4:0] r;
        case (r)
            5'd0:  mul7_mod25 = 5'd0;
            5'd1:  mul7_mod25 = 5'd7;
            5'd2:  mul7_mod25 = 5'd14;
            5'd3:  mul7_mod25 = 5'd21;
            5'd4:  mul7_mod25 = 5'd3;  
            5'd5:  mul7_mod25 = 5'd10;
            5'd6:  mul7_mod25 = 5'd17;
            5'd7:  mul7_mod25 = 5'd24;
            5'd8:  mul7_mod25 = 5'd6;   
            5'd9:  mul7_mod25 = 5'd13;
            5'd10: mul7_mod25 = 5'd20;
            5'd11: mul7_mod25 = 5'd2;   
            5'd12: mul7_mod25 = 5'd9;
            5'd13: mul7_mod25 = 5'd16;
            5'd14: mul7_mod25 = 5'd23;
            5'd15: mul7_mod25 = 5'd5;
            5'd16: mul7_mod25 = 5'd12;
            5'd17: mul7_mod25 = 5'd19;
            5'd18: mul7_mod25 = 5'd1;   
            5'd19: mul7_mod25 = 5'd8;
            5'd20: mul7_mod25 = 5'd15;
            5'd21: mul7_mod25 = 5'd22;
            5'd22: mul7_mod25 = 5'd4;   
            5'd23: mul7_mod25 = 5'd11;
            5'd24: mul7_mod25 = 5'd18;
            default: mul7_mod25 = 5'd0;
        endcase
    endfunction

    function [4:0] divisible_by_25; // sử dụng sơ đồ hoocner f(x) = 25*g(x) + r => kiểm tra r có chia hết cho 25 không (r = a1*7+a2)
        input [4:0] a1; // 0-24
        input [4:0] a2;   // 0-31
        reg   [5:0] tmp;    // max=55
        begin
            tmp = mul7_mod25(a1) +a2; 
            // Trừ 25 tối đa 2 lần để đưa về [0,24]
            if (tmp >= 6'd25) tmp = tmp - 6'd25;
            if (tmp >= 6'd25) tmp = tmp - 6'd25;
            divisible_by_25 = tmp[4:0];
        end
    endfunction

    wire divisible_by_100 = divisible_by_4 & (divisible_by_25(a1_100,a2_100) == 5'd0 );
    wire divisible_by_400 = divisible_by_16 & (divisible_by_25(a1_400,a2_400) == 5'd0 );
    wire leap = divisible_by_4 && (!divisible_by_100 || divisible_by_400);

    always @(month,year) begin
        case (month)
            1,3,5,7,8,10,12: max_day = 31;
            4,6,9,11:        max_day = 30;
            2: max_day = (leap) ? 29 : 28;
            default: max_day = 31;
        endcase
    end
endmodule


