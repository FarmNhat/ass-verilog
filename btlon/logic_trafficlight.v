`timescale 1ns / 1ps

module logic_trafficlight(n_light, s_light, e_light, w_light, clk, rst);
    output reg [2:0] n_light, s_light, e_light, w_light;
    input clk;
    input rst;
    
    reg [2:0] state;
    
    parameter [2:0] north_south = 3'b000;
    parameter [2:0] north_south_y = 3'b001;
    parameter [2:0] west_east = 3'b010;
    parameter [2:0] west_east_y = 3'b100;
    
    reg [2:0] count;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= north_south;
            count <= 3'b000;
        end else begin
            case (state) 
                north_south: begin
                    if (count == 3'b111) begin
                        count <= 3'b000;
                        state <= north_south_y;
                    end else begin
                        count <= count + 3'b001;
                        state <= north_south;
                    end
                end
                north_south_y: begin
                    if (count == 3'b011) begin
                        count <= 3'b000;
                        state <= west_east;
                    end else begin 
                        count <= count + 3'b001;
                        state <= north_south_y;
                    end
                end
                west_east: begin
                    if (count == 3'b111) begin
                        count <= 3'b000;
                        state <= west_east_y;
                    end else begin
                        count <= count + 3'b001;
                        state <= west_east;
                    end
                end
                west_east_y: begin
                    if (count == 3'b011) begin
                        count <= 3'b000;
                        state <= north_south;
                    end else begin
                        count <= count + 3'b001;
                        state <= west_east_y;
                    end
                end
            endcase 
       end
    end
    
    always @(state) begin //GREEN: 3'b001, YELLOW: 3'b100, RED: 3'b010
        case (state)
            north_south: begin
                n_light = 3'b001;
                s_light = 3'b001;
                e_light = 3'b010;
                w_light = 3'b010;
            end
            north_south_y: begin
                n_light = 3'b100;
                s_light = 3'b100;
                e_light = 3'b010;
                w_light = 3'b010;
            end
            west_east: begin
                n_light = 3'b010;
                s_light = 3'b010;
                e_light = 3'b001;
                w_light = 3'b001;
            end
            west_east_y: begin
                n_light = 3'b010;
                s_light = 3'b010;
                e_light = 3'b100;
                w_light = 3'b100;
            end
        endcase
    end
endmodule
