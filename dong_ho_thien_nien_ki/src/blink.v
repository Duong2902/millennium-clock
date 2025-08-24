module blink (
    input clk_0_5s,
    input rst_n,
    input set_mode,
    output reg blink
);
always @(posedge clk_0_5s or negedge rst_n) begin
    if (!rst_n) begin
        blink <=0;
    end
    else if (set_mode) begin
        blink <= ~blink;
    end
    else begin
        blink <=0;
    end
    end
endmodule