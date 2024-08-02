
////////////////////////////////////////

////////////////////////////////////////


////////////////////////////////////////////

////////////////////////////////////////////
module traffic;
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
