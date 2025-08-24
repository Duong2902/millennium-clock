
module time_counter (
    input clk_1s,
    input rst_n,
    input set_mode, 
    input sel,
    input [1:0] set_select, 
    input inc_btn,
    input dec_btn,
    output reg [5:0] sec, min,
    output reg [5:0] hour,
    output reg [5:0] day,
    output reg [5:0] month,
    output reg [9:0] year  
);
    wire [4:0] max_day;
    wire [4:0] new_max_day;
    wire [5:0] new_month = (month == 1)? 12 : (month-1);
    leap_year_check leap_chk(.year(year), .month(month), .max_day(max_day));
    leap_year_check new_leap_chk(.year(year), .month(new_month), .max_day(new_max_day));
    always @(posedge clk_1s or negedge rst_n) begin
        if (!rst_n) begin
            sec <= 0; min <= 0; hour <= 0;
            day <= 1; month <= 1; year <= 0;
        end else if (!set_mode) begin
            if (sec == 59) begin
                sec <= 0;
                if (min == 59) begin
                    min <= 0;
                    if (hour == 23) begin
                        hour <= 0;
                        if (day == max_day) begin
                            day <= 1;
                            if (month == 12) begin
                                month <= 1;
                                if (year == 974) 
                                    year <= 0;
                                else
                                    year <= year + 1;
                            end else
                                month <= month + 1;
                        end else
                            day <= day + 1;
                    end else
                        hour <= hour + 1;
                end else
                    min <= min + 1;
            end else
                sec <= sec + 1;
        end else begin
            if (!inc_btn) begin
                if (!sel) begin
                case (set_select)
                    2'd0: begin
                        if (sec < 59)
                            sec <= sec + 1;
                        else begin
                            sec <= 0;
                            if (min < 59)
                                min <= min + 1;
                            else begin
                                min <= 0;
                                if (hour < 23)
                                    hour <= hour + 1;
                                else begin
                                    hour <= 0;
                                    if (day < max_day)
                                        day <= day + 1;
                                    else begin
                                        day <= 1;
                                        if (month < 12)
                                            month <= month + 1;
                                        else begin
                                            month <= 1;
                                            if (year < 974)
                                                year <= year + 1;
                                            else
                                                year <= 0;
                                        end
                                    end
                                end
                            end
                        end
                    end
                    2'd1: begin
                        if (min < 59)
                            min <= min + 1;
                        else begin
                            min <= 0;
                            if (hour < 23)
                                hour <= hour + 1;
                            else begin
                                hour <= 0;
                                if (day < max_day)
                                    day <= day + 1;
                                else begin
                                    day <= 1;
                                    if (month < 12)
                                        month <= month + 1;
                                    else begin
                                        month <= 1;
                                        if (year < 974)
                                            year <= year + 1;
                                        else
                                            year <= 0;
                                    end
                                end
                            end
                        end
                    end
                    2'd2: begin 
                        if (hour < 23)
                            hour <= hour + 1;
                        else begin
                            hour <= 0;
                            if (day < max_day)
                                day <= day + 1;
                            else begin
                                day <= 1;
                                if (month < 12)
                                    month <= month + 1;
                                else begin
                                    month <= 1;
                                    if (year < 974)
                                        year <= year + 1;
                                    else
                                        year <= 0;
                                end
                            end
                        end
                    end
                endcase
                end
                else begin
                    case (set_select)
                    2'd0: begin
                         if (day < max_day)
                            day <= day + 1;
                        else begin
                            day <= 1;
                            if (month < 12)
                                month <= month + 1;
                            else begin
                                month <= 1;
                                if (year < 974)
                                    year <= year + 1;
                                else
                                    year <= 0;
                            end
                        end
                    end
                    2'd1: begin
                        if (month < 12)
                            month <= month + 1;
                        else begin
                            month <= 1;
                            if (year < 974)
                                year <= year + 1;
                            else
                                year <= 0;
                        end
                    end
                    2'd2: begin
                         if (year < 974) year <= year + 1;
                         else begin
                             sec <=0;
                             min <=0;
                             hour <=0;
                             day <=0;
                             month <=0;
                             year <= 0;

                         end
                         end
                    default: begin
                        sec <= sec;
                        min <= min;
                        hour <= hour;
                        day <= day;
                        month <= month;
                        year <= year;
                    end
                endcase
                end
            end
            else if (!dec_btn) begin
                if (!sel) begin
                case (set_select)
                    2'd0: begin
                        if (sec > 0)
                            sec <= sec - 1;
                        else begin
                            sec <= 59;
                            if (min > 0)
                                min <= min - 1;
                            else begin
                                min <= 59;
                                if (hour > 0)
                                    hour <= hour - 1;
                                else begin
                                    hour <= 23;
                                    if (day > 1)
                                        day <= day - 1;
                                    else begin
                                        month <= (month == 1) ? 12 : (month - 1);
                                        if (month == 1) begin
                                            year <= (year > 0) ? (year - 1) : 974;
                                        end
                                        day <= new_max_day;
                                    end
                                end
                            end
                        end
                    end
                    2'd1: begin
                        if (min > 0)
                                min <= min - 1;
                        else begin
                            min <= 59;
                            if (hour > 0)
                                hour <= hour - 1;
                            else begin
                                hour <= 23;
                                if (day > 1)
                                    day <= day - 1;
                                else begin
                                    month <= (month == 1) ? 12 : (month - 1);
                                    if (month == 1) begin
                                        year <= (year > 0) ? (year - 1) : 974;
                                    end
                                    day <= new_max_day;
                                end
                            end
                        end
                    end
                    2'd2: begin 
                        if (hour > 0)
                                hour <= hour - 1;
                        else begin
                            hour <= 23;
                            if (day > 1)
                                day <= day - 1;
                            else begin
                                month <= (month == 1) ? 12 : (month - 1);
                                if (month == 1) begin
                                    year <= (year > 0) ? (year - 1) : 974;
                                end
                                day <= new_max_day;
                            end
                        end
                    end
                endcase
                end
                else begin 
                    case (set_select)
                    2'd0: begin
                        if (day > 1)
                            day <= day - 1;
                        else begin
                            month <= (month == 1) ? 12 : (month - 1);
                            if (month == 1) begin
                                year <= (year > 0) ? (year - 1) : 974;
                            end
                            day <= new_max_day;
                        end
                    end
                    2'd1: begin
                        month <= (month == 1) ? 12 : (month - 1);
                        if (month == 1) begin
                            year <= (year > 0) ? (year - 1) : 974;
                        end
                        day <= new_max_day;
                    end
                    2'd2: begin
                         if (year > 0) year <= year - 1;
                         else year <= year;
                         end
                    default: begin
                        sec <= sec;
                        min <= min;
                        hour <= hour;
                        day <= day;
                        month <= month;
                        year <= year;
                    end
                endcase
                end
            end
            else begin
                sec <= sec;
                min <= min;
                hour <= hour;
                day <= day;
                month <= month;
                year <= year;
                end
        end
    end
endmodule
