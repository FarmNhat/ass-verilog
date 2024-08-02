module LAB2_2_1 (
    input [3:0] in,
    output reg [3:0] out
);

always @(*) begin

    out[0] = ~(in[0] ^ in[1] ^ in[2] ^ in[3]);
    
    out[1] = (in[0] & ~in[1] & ~in[2] & ~in[3]) | 
             (~in[0] & in[1] & ~in[2] & ~in[3]) | 
             (~in[0] & ~in[1] & in[2] & ~in[3]) | 
             (~in[0] & ~in[1] & ~in[2] & in[3]);
    
    out[2] = ~in[0] & ~in[1] & ~in[2] & ~in[3];
    
    out[3] = in[0] & in[1] & in[2] & in[3];
end

endmodule

module LAB2_2_1_tb();
    reg [3:0] in
    wire [3:0] out;

    LAB2_2_1 uut(
        .in(in), 
        .out(out)
    );

    initial begin
        $monitor(in,out);
        for (int i=0; i<16; i=i+1) begin
            {in[3], in[2], in[1], in[0]} = i;
            #10;
        end
    end
endmodule

module One_Hz (
    input wire clk,         // 125 MHz input clock
    input wire reset,       // Asynchronous reset
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


module bin2led7 (
    input enable,
    input [3:0] bin_in,
    output reg [6:0] led_out
);

    always @(*) begin
        if (enable == 1'b0) begin
            led_out = 7'b0000000; // Turn off all LEDs
        end 
        else begin
            case (bin_in)
                4'b0000: led_out = 7'b0111111; // 0
                4'b0001: led_out = 7'b0000110; // 1
                4'b0010: led_out = 7'b1011011; // 2
                4'b0011: led_out = 7'b1001111; // 3
                4'b0100: led_out = 7'b1100110; // 4
                4'b0101: led_out = 7'b1101101; // 5
                4'b0110: led_out = 7'b1111101; // 6
                4'b0111: led_out = 7'b0000111; // 7
                4'b1000: led_out = 7'b1111111; // 8
                4'b1001: led_out = 7'b1101111; // 9
                4'b1010: led_out = 7'b1110111; // A
                4'b1011: led_out = 7'b1111100; // b
                4'b1100: led_out = 7'b0111001; // C
                4'b1101: led_out = 7'b1011110; // d
                4'b1110: led_out = 7'b1111001; // E
                4'b1111: led_out = 7'b1110001; // F
                default: led_out = 7'b0000000; // Default to off
            endcase
        end
    end
endmodule

module tb_bin2led7;

    // Inputs
    reg enable;
    reg [3:0] bin_in;

    // Outputs
    wire [6:0] led_out;

    // Instantiate the Unit Under Test (UUT)
    bin2led7 uut (
        .enable(enable),
        .bin_in(bin_in),
        .led_out(led_out)
    );

    initial begin
        // Initialize Inputs
        enable = 0;
        bin_in = 0;

        $monitor(enable, bin_in, led_out);
        
        // Test all values with enable off
        enable = 0;
        for (int i=0; i<16; i=i+1) begin
            {in[3], in[2], in[1], in[0]} = i;
            #10;
        end
        
        // Test all values with enable on
        enable = 1;
        for (int i=0; i<16; i=i+1) begin
            {in[3], in[2], in[1], in[0]} = i;
            #10;
        end
    end

endmodule

module select(
    input s0,
    input s1,
    input [3:0] but,
    output [3:0]color,
    //blue, green, red, white
);

always @(*) begin
    if (s0==1'b0) begin 
        case(but)
            4'b0000: color = 4'b0000;
            4'b0001: color = 4'b1000;
            4'b0010: color = 4'b0100;
            4'b0100: color = 4'b0010;
            4'b1000: color = 4'b0001;
            default: color = 4'b0000;
        endcase
    end

    else if (s0==1'b1 && s1==1'b0) begin
        case(but)
            4'b0000: color = 4'b0000;
            4'b0001: color = 4'b1000;
            4'b0010: color = 4'b0100;
            4'b0100: color = 4'b0010;
            4'b1000: color = 4'b0001;
            default: color = 4'b1111;
        endcase
    end

    else if (s0==1'b1 && s1==1'b1) begin
        case(but)
            4'b0000: color = 4'b0000;
            4'b0001: color = 4'b1100;
            4'b0010: color = 4'b0110;
            4'b0100: color = 4'b0011;
            4'b1000: color = 4'b0001;
            default: color = 4'b0000;
        endcase
    end
end
endmodule 


module tb_select
    reg s0;
    reg s1;
    reg [3:0] but;
    wire [3:0] color;

    // Instantiate the Unit Under Test (UUT)
    bin2led7 uut (
        .s0(s0),
        .s1(s1),
        .but(but)
        .color(color)
    );

    initial begin
        $montor(s0,s1,but,color)

        s0=0; 
        for (int i=0; i<16; i=i+1) begin
            {in[3], in[2], in[1], in[0]} = i;
            #10;
        end

        s0=1; s1=0;
        for (int i=0; i<16; i=i+1) begin
            {in[3], in[2], in[1], in[0]} = i;
            #10;
        end

        s0=1; s1=1;
        for (int i=0; i<16; i=i+1) begin
            {in[3], in[2], in[1], in[0]} = i;
            #10;
        end

    end
endmodule
