//ECE6370
//Pranav Kulkarni
//1ms timer
//Generates a 1ms pulse every 4u time interval when EnableCount is pulled high
module timer4u(clock,rst,EnableCount, enable_lcd);
  input clock, rst, EnableCount;
  
  output reg enable_lcd;
 
  reg state_enable = 1'b0;
  reg TimerIndicator;
  reg [1:0] state;
  reg [15:0] LFSR;
  wire feedback = LFSR[15];
  parameter IDLE = 0, CountState = 1, RestartCount = 2;
 
  always @(posedge clock)
  begin
      if(rst == 0)
      begin
        LFSR <= 16'hffff;
        TimerIndicator <= 1'b0;
      end
      else
        begin
	  case(state)
            IDLE : begin
                   LFSR <= 16'hffff;
						
                   if(EnableCount == 1'b1)
                   begin
                   state <= CountState;
                   TimerIndicator <= 1'b0;
                   end
                   else
                   begin
                   state <= IDLE;
                   TimerIndicator <= 1'b0;
                   end
                   end
            CountState : begin
     			 LFSR[0] <= feedback;
    			 LFSR[1] <= LFSR[0];
    			 LFSR[2] <= LFSR[1] ^ feedback;
    			 LFSR[3] <= LFSR[2] ^ feedback;
    			 LFSR[4] <= LFSR[3];
    			 LFSR[5] <= LFSR[4] ^ feedback;
    			 LFSR[6] <= LFSR[5];
    			 LFSR[7] <= LFSR[6];
    			 LFSR[8] <= LFSR[7];
    			 LFSR[9] <= LFSR[8];
    			 LFSR[10] <= LFSR[9];
    			 LFSR[11] <= LFSR[10];
    			 LFSR[12] <= LFSR[11];
    			 LFSR[13] <= LFSR[12];
    			 LFSR[14] <= LFSR[13];
    			 LFSR[15] <= LFSR[14];
                         if(LFSR == 16'hda17)//sequence that indicates 4us mark
                             begin
                             TimerIndicator <= 1'b1;
                             state <= RestartCount;
			     LFSR <= 16'hffff;
                             end
                           else
                             begin
                               TimerIndicator <= 1'b0;
                               state <= CountState;
                             end
 
			 end
         RestartCount : begin
                        TimerIndicator <= 1'b0;//restart count if 100us reached since 16 bit lfsr can count more than 100us
                        state <= CountState;//the sequence would change everytime i.e. timer would be inaccurate
                        LFSR <= 16'hffd3;
                        end
	 
         default : begin
                   state <= IDLE;
                   end
         endcase
      end

  end
always@(posedge TimerIndicator)
begin
case(state_enable)
1'b0 : begin
		enable_lcd <= 1'b1;
                state_enable <= 1'b1;
	end
1'b1 : begin
		enable_lcd <= 1'b0;
		state_enable<= 1'b0;
        end
default : begin state_enable <= 1'b0;end
endcase
end 

  


  
endmodule

