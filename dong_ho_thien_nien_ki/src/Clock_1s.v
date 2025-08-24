module clock_1s(
    input              reset_n, 
    input              debug_signal,
    input              sys_clk,       
    output reg         clk_1s, 
    output reg         clk_0_5s
);

reg [24:0] value_divide_1;

always @(*) begin
    if (debug_signal)
        value_divide_1 = 25'd2500000;
    else
        value_divide_1 = 25'd25000000;
end
parameter   value_divide_2 = 24'd12500000;

reg [24:0]  count_1s;
reg [23:0]  count_0_5s;

always @(negedge reset_n or posedge sys_clk) 
begin
  if(!reset_n) 
  begin
    count_1s <= 25'd1;
    count_0_5s <= 24'd1;
    clk_1s  <= 1'b0;
    clk_0_5s <= 1'b0;
  end
  else 
  begin
    if(count_1s == value_divide_1)
    begin
      clk_1s <= ~clk_1s;
      count_1s <= 25'd1;
    end
    else begin
      count_1s <= count_1s + 1'd1;
      clk_1s <= clk_1s;
    end
    
    if(count_0_5s == value_divide_2)
    begin
      clk_0_5s <= ~clk_0_5s;
      count_0_5s <= 24'd1;
    end
    else begin
      count_0_5s <= count_0_5s + 1'd1;
      clk_0_5s <= clk_0_5s;
    end
  end
end

endmodule