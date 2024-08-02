module Police(
    input wire clk,         // 125 MHz input clock
    input wire reset,       // Asynchronous reset
    output reg out_xanh, out_do      // 1 Hz output clock
);
    reg [26:0] counter;     // 27-bit counter to count up to 125,000,000

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 27'd0;
            out_xanh <= 1'b0;
            out_xanh <= 1'b1;
        end else if (counter == 27'd62499999) begin
            counter <= 27'd0;
            out_xanh <= ~out_xanh;
            out_do   <= ~out_do; // Toggle the output clock
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

//TÉT BENCH
module Police_tb;
    reg clk;
    reg reset;
    wire out_xanh, out_do;

    Police uut(
        .clk(clk),
        .reset(reset),
        .out_xanh(out_xanh),
        .out_do(out_do),
    );

    always begin
        #5 clk=~clk;
    end
endmodule

///////////////////////////////////////////////

///////////////////////////////////////////////

module RisingEdgeDetector (
    input clk,   
    input rst,    
    input in,     
    output reg out     
);

    reg q1, q2;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q1 <= 1'b0;
            q2 <= 1'b0;
            out <= 1'b0;
        end else begin
            q1 <= in;
            q2 <= q1;

            out <= q1 & ~q2;
        end
    end

endmodule
///////////////////////////////////////////////

///////////////////////////////////////////////
/*
    TÉT BENCH
*/

module RisingEdgeDetector_tb;

    reg clk;
    reg rst;
    reg in;
    wire out;

    RisingEdgeDetector dut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out)
    );
    always begin
        #5 clk = ~clk; 
    end

    
    initial begin
        clk = 0;
        rst = 0;
        in = 0;

        rst = 1;
        #10;
        rst = 0;
        #10;

        #10; in = 0; 
        #10; in = 0; 

        // Rising edge
        #10; in = 1; 

        // Falling edge
        #10; in = 0; 

        // Another rising edge
        #10; in = 1; 
        #10; in = 1; 

        // Lower the input
        #10; in = 0; // No rising edge, out should be 0
        #10; in = 0; // No rising edge, out should be 0

        #10 $stop;
    end
endmodule


///////////////////////////////////////////////

///////////////////////////////////////////////

module counter (
    input clk,
    input out, // out của bên rising edge nối vô
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (enable)
            count <= count + 1;
    end
endmodule

module beep_beep (
    input wire clk,
    input wire in,
    output wire [3:0] count
);
    wire out;

    RisingEdgeDetector detector (
        .clk(clk),
        .rst(1'b1),
        .in(in),
        .out(out)
    );
    counter u_counter (
        .clk(clk),
        .out(out), //out của bên rising edge 
        .count(count)
    );
endmodule



