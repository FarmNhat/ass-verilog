module One_Hz (
    input clk,         // 125 MHz input clock
    input reset,       // Asynchronous reset
    output reg clk_out      // 1 Hz output clock
);
    reg [26:0] counter;     // 27-bit counter to count up to 125,000,000

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 27'd0;
            clk_out <= 1'b0;
        end else if (counter == 27'd124999999) begin
            counter <= 27'd0;
            clk_out <= ~clk_out; // Toggle the output clock
        end else begin
            counter <= counter + 1;
        end
    end
endmodule