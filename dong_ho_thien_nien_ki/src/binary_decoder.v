module binary_decoder (
    input  [5:0] din,
    output reg [3:0] led_ten,
    output reg [3:0] led_one
);

reg [5:0] temp_val;

always @(*) begin
    led_ten     = 4'd0;
    led_one     = 4'd0;
    
    temp_val = din;

    // Tìm chữ số hàng chục
    if (temp_val >= 60) begin led_ten = 9; temp_val = temp_val - 60; end
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

