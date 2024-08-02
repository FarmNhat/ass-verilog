module seven_segment_display (
    input [3:0] digit,  // Binary input to display (0-9)
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
////////////////////////////////////////

////////////////////////////////////////
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

////////////////////////////////////////////

////////////////////////////////////////////
module
    input clk;
    input reset;
    output reg xanh_1;
    output reg vang_1;
    output reg do_1;
    output reg xanh_2;
    output reg vang_2;
    output reg do_2;
    output reg [6:0] display_seg1, display_seg2;

    reg [4:0] timer;
    reg one_sec;
    reg [3:0] led1, led2;

    One_Hz one(
        .clk(clk),
        .reset(reset),
        .one_sec(clk_out),
    );

    seven_segment_display seg1 (
        .led1(digit)
        .display_seg1(seg)
    );

    seven_segment_display seg2 (
        .led2(digit)
        .display_seg2(seg)
    );

    always @(posedge reset) begin
        timer <= 5'd0;
        do_1 <= 1'b1;
        xanh_1 <= 1'b0;
        vang_1 <= 1'b0;

        do_2 <= 1'b0;
        xanh_2 <= 1'b1;
        vang_2 <= 1'b0;

        seg1 <= 4'd10;
        seg2 <= 4'd7
    end

    always @(posedge one_sec ) begin
        if ( timer == 5'd0) begin
            do_1 <= 1'b1;
            xanh_1 <= 1'b0;
            vang_1 <= 1'b0;

            do_2 <= 1'b0;
            xanh_2 <= 1'b1;
            vang_2 <= 1'b0;

            timer = timer + 1;
            seg1 <= 4'd10;
            seg2 <= 4'd7;
        end
        else if(timer == 5'd7) begin
            xanh_2 <= 1'b0;
            vang_2 <= 1'b1;
            do_2 <= 1'b0;

            timer = timer + 1;
            seg2 <= 4'd3;
        end
        else if ( timer == 5'd10) begin
            do_1 <= 1'b0;
            vang_1 <= 1'b0;
            xanh_1 <= 1'b1;

            xanh_2 <= 1'b0;
            vang_2 <= 1'b0;
            do_2 <= 1'b1;

            timer = timer + 1;
            seg1 <= 4'd7;
            seg2 <= 4'd10;
        end
        else if (timer == 5'd17) begin
            do_1 <= 1'b0;
            vang_1 <= 1'b1;
            xanh_1 <= 1'b0;

            xanh_2 <= 1'b0;
            vang_2 <= 1'b0;
            do_2 <= 1'b1;

            timer = timer + 1;
            seg1 <= 4'd3;
        end
        else if (timer == 5'd20) begin
            timer <= 5'd0;

        end
        else begin
            timer = timer + 1;
            seg1 = seg1 - 1;
            seg2 = seg2 - 1;
        end
    end
endmodule
