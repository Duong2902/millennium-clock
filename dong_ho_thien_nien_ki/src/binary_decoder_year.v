module binary_decoder_year (
    input wire [9:0] din,
    output reg [3:0] led_hundred,
    output reg [3:0] led_ten,
    output reg [3:0] led_one
);

reg [9:0] temp_val;

always @(din) begin
    led_hundred = 4'd0;
    led_ten     = 4'd0;
    led_one     = 4'd0;
    
    temp_val = din;

    //tìm chữ số hàng trăm
    if (din >=900) begin
        led_hundred = 9;
        temp_val = din - 900;
    end else if (din >= 800) begin
        led_hundred = 8;
        temp_val = din - 800;
    end else if (din >= 700) begin
        led_hundred = 7;
        temp_val = din - 700;
    end else if (din >= 600) begin
        led_hundred = 6;
        temp_val = din - 600;
    end else if (din >= 500) begin
        led_hundred = 5;
        temp_val = din - 500;
    end else if (din >= 400) begin
        led_hundred = 4;
        temp_val = din - 400;
    end else if (din >= 300) begin
        led_hundred = 3;
        temp_val = din - 300;
    end else if (din >= 200) begin
        led_hundred = 2;
        temp_val = din - 200;
    end else if (din >= 100) begin
        led_hundred = 1;
        temp_val = din - 100;
    end else begin
        led_hundred = 0;
        temp_val = din;
    end
    
    // Tìm chữ số hàng chục
    if (temp_val >= 90) begin led_ten = 9; temp_val = temp_val - 90; end
    else if (temp_val >= 80) begin led_ten = 8; temp_val = temp_val - 80; end
    else if (temp_val >= 70) begin led_ten = 7; temp_val = temp_val - 70; end
    else if (temp_val >= 60) begin led_ten = 6; temp_val = temp_val - 60; end
    else if (temp_val >= 50) begin led_ten = 5; temp_val = temp_val - 50; end
    else if (temp_val >= 40) begin led_ten = 4; temp_val = temp_val - 40; end
    else if (temp_val >= 30) begin led_ten = 3; temp_val = temp_val - 30; end
    else if (temp_val >= 20) begin led_ten = 2; temp_val = temp_val - 20; end
    else if (temp_val >= 10) begin led_ten = 1; temp_val = temp_val - 10; end
    else begin led_ten = 0; end
    
    // Chữ số hàng đơn vị là phần còn lại
    led_one = temp_val;
end

endmodule