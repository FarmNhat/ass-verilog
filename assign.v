// 7-segment display driver
module seven_segment_display (
    input wire [3:0] digit,  // Binary input to display (0-9)
    output reg [6:0] seg    // 7-segment display output (active low)
);
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;///sjdkdodo
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            default: seg = 7'b1111111; // All segments off for values > 5
        endcase
    end
endmodule

// Traffic light controller with 7-segment display timer
module traffic_light_controller (
    input wire clk,           // System clock
    input wire reset,         // System reset
    output reg led4_r,        // North-South Red light on RGB LED4
    output reg led4_g,        // North-South Green light on RGB LED4
    output reg led4_b,        // North-South Yellow light on RGB LED4 (combination of Red and Green)
    output reg led5_r,        // East-West Red light on RGB LED5
    output reg led5_g,        // East-West Green light on RGB LED5
    output reg led5_b,        // East-West Yellow light on RGB LED5 (combination of Red and Green)
    output wire [6:0] seg     // 7-segment display output
);

    // State encoding
    reg [1:0] current_state, next_state;
    localparam S_NS_GREEN = 2'b00,
               S_NS_YELLOW = 2'b01,
               S_EW_GREEN = 2'b10,
               S_EW_YELLOW = 2'b11;

    reg [31:0] timer; // 32-bit timer for state duration
    reg [3:0] display_digit; // Digit to display on 7-segment

    localparam TIMER_MAX_GREEN = 250_000_000; // 5 seconds at 50 MHz
    localparam TIMER_MAX_YELLOW = 100_000_000; // 2 seconds at 50 MHz

    reg [31:0] display_timer; // Secondary timer for 7-segment display update
    reg [3:0] countdown_digit; // Countdown digit for display

    // 7-segment display driver instance
    seven_segment_display display_driver (
        .digit(display_digit),
        .seg(seg)
    );

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S_NS_GREEN;
            timer <= 0;
            display_timer <= 0;
            countdown_digit <= 5; // Start countdown from 5
        end 
        else begin
            if (timer == 0) begin
                if (current_state == S_NS_GREEN || current_state == S_EW_GREEN) begin
                    timer <= TIMER_MAX_GREEN;
                end 
                else begin
                    timer <= TIMER_MAX_YELLOW;
                end
                current_state <= next_state;
                if (current_state == S_NS_YELLOW || current_state == S_EW_YELLOW) begin
                    countdown_digit <= 2; // Reset countdown for yellow state
                end 
                else begin
                    countdown_digit <= 5; // Reset countdown for green state
                end
            end 
            else begin
                timer <= timer - 1;
            end

            // Increment the display timer and update the display digit less frequently
            if (display_timer == 50_000_000) begin  // Assuming we want to update every 1 second
                display_timer <= 0;
                if (countdown_digit > 0) begin
                    countdown_digit <= countdown_digit - 1;
                end else if (countdown_digit == 0 && (current_state == S_NS_GREEN || current_state == S_EW_GREEN)) begin
                    countdown_digit <= 5; // Reset countdown when it reaches 0 for green state
                end else if (countdown_digit == 0 && (current_state == S_NS_YELLOW || current_state == S_EW_YELLOW)) begin
                    countdown_digit <= 2; // Reset countdown when it reaches 0 for yellow state
                end
            end else begin
                display_timer <= display_timer + 1;
            end

            display_digit <= countdown_digit; // Update display digit
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S_NS_GREEN: next_state = S_NS_YELLOW;
            S_NS_YELLOW: next_state = S_EW_GREEN;
            S_EW_GREEN: next_state = S_EW_YELLOW;
            S_EW_YELLOW: next_state = S_NS_GREEN;
            default: next_state = S_NS_GREEN;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default all lights to off
        led4_r = 0;
        led4_g = 0;
        led4_b = 0;
        led5_r = 0;
        led5_g = 0;
        led5_b = 0;
        
        case (current_state)
            S_NS_GREEN: begin
                led4_g = 1; // NS Green
                led5_r = 1; // EW Red
            end
            S_NS_YELLOW: begin
                led4_r = 1; // NS Red
                led4_g = 1; // NS Green (Yellow as combination of Red and Green)
                led5_r = 1; // EW Red
            end
            S_EW_GREEN: begin
                led4_r = 1; // NS Red
                led5_g = 1; // EW Green
            end
            S_EW_YELLOW: begin
                led4_r = 1; // NS Red
                led5_r = 1; // EW Red
                led5_g = 1; // EW Green (Yellow as combination of Red and Green)
            end
            default: begin
                led4_r = 1; // NS Red
                led5_r = 1; // EW Red
            end
        endcase
    end
endmodule