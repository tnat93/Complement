module Complement(CLK, SW, LED, SSEG_CA, SSEG_AN);

    input CLK;
    input [7:0] SW;
    output wire [7:0] LED;
    output reg [7:0] SSEG_CA;
    output reg [7:0] SSEG_AN;
    
    reg [31:0] counter_out, k_count;
    reg Clk_Slow, Clk_1K;
    reg [1:0] cnt;
    
    reg [3:0] temp;
    
    initial begin
        counter_out<= 32'h00000000;
        k_count<= 32'h00000000;
        Clk_Slow <=0;
        cnt <= 2'b00;
    end
            
    always @(posedge CLK) begin
           counter_out<=counter_out + 32'h00000001;    
           if(counter_out > 32'h000186A0)     
           begin
                   counter_out<= 32'h00000000;
                   Clk_1K <= !Clk_1K;
           end
    end
    
    always @(posedge Clk_1K) begin
           k_count = k_count + 32'h00000001;
           if( k_count > 32'h000003E8)
           begin
                   k_count <= 32'h00000000;
                   Clk_Slow <= !Clk_Slow;
            end
    end
    
    //Anodes 1,2,7,8: SSEG_AN <= 8'b00111100;
    //First 4 switches = Anode 1
    //Second 4 switches = Anode 2
    //Anode 7 = Opposite of first 4 switches
    //Anode 8 = Opposite of second 4 switches
    always @ (posedge Clk_1K) begin
            cnt = cnt + 2'b01;
    end

    always @ (cnt) begin
            case (cnt)
                    2'b00: begin
                       temp = SW[3:0];
                       SSEG_AN = 8'b11111110;
                       end

                    2'b01: begin
                       temp = SW[7:4];
                       SSEG_AN = 8'b11111101;
                       end

                    2'b10: begin
                       temp = ~SW[3:0];
                       SSEG_AN = 8'b10111111;
                       end

                    2'b11: begin
                       temp = ~SW[7:4];
                       SSEG_AN = 8'b01111111;
                       end
            endcase
    end
    
    always @ (temp) begin
            case (temp)
                4'b0000: SSEG_CA <= 8'b11000000;    //0
                4'b0001: SSEG_CA <= 8'b11111001;    //1
                4'b0010: SSEG_CA <= 8'b10100100;    //2
                4'b0011: SSEG_CA <= 8'b10110000;    //3
                4'b0100: SSEG_CA <= 8'b10011001;    //4
                4'b0101: SSEG_CA <= 8'b10010010;    //5
                4'b0110: SSEG_CA <= 8'b10000010;    //6
                4'b0111: SSEG_CA <= 8'b11011000;    //7
                4'b1000: SSEG_CA <= 8'b10000000;    //8
                4'b1010: SSEG_CA <= 8'b10001000;    //A
                4'b1011: SSEG_CA <= 8'b10000011;    //B
                4'b1100: SSEG_CA <= 8'b11000110;    //C
                4'b1101: SSEG_CA <= 8'b10100001;    //D
                4'b1110: SSEG_CA <= 8'b10000110;    //E
                4'b1111: SSEG_CA <= 8'b10001110;    //F
            endcase
   
       end
   
       assign LED = SW;
endmodule
