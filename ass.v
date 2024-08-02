module seven_segment_display (
    input wire [3:0] digit,  // Binary input to display (0-9)
    output reg [6:0] seg    // 7-segment display output (active low)
);
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111; 
        endcase
    end
endmodule

module
    input clk;
    input reset;
    output reg xanh_1;
    output reg vang_1;
    output reg do_1;
    output reg xanh_2;
    output reg vang_2;
    output reg do_2;
    output reg [6:0] display_time;

    reg [2:0] timer;

    always @(posedge reset) begin
        timer <= 3'd0;
        do_1 <= 1'b1;
        xanh_2 <= 1'b1;
    end

    always @(posedge clk) begin
        if()
    end
endmodule