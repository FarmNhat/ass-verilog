module One_Hz (
    input clk_in,         // 125 MHz input clock
    input reset,       // Asynchronous reset
    output reg clk_out      // 1 Hz output clock
);

    parameter TIME = 50000000;
    reg [25:0] counter;     // counter tới 50,000,000 tại mạch mình xài 50MHz

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 26'd0;
            clk_out <= 1'b0;
        end else if (counter == TIME - 1) begin
            counter <= 26'd0;
            clk_out <= ~clk_out; // Toggle the output clock
        end else begin
            counter <= counter + 1;
        end
    end
endmodule