module RESET_DELY ( 
   input BUTTON_N  , 
	input OSC , 
   output RESET_n  
) ; 

parameter SEC = 50_000_000  ; 
parameter SE10C = SEC/10    ; 
parameter SE20C = SEC/20    ; //0.05
parameter SE50C = SEC/50    ; 
parameter SE100C = SEC/100  ;//error 
parameter SE1000C = SEC/1000; 
parameter SE5C = SEC/2  ; 
parameter SEC1 = 1*SEC  ; 
parameter SEC2 = 2*SEC  ; 
parameter SEC10 = 10*SEC  ; 

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [31:0] DELAY_CNT =0 ; 
  
//=======================================================
//  Structural coding
//=======================================================	

assign RESET_n =( ( DELAY_CNT>=0 ) &&  ( DELAY_CNT< SE20C) )?0:1 ; //0.05s

always @(negedge  BUTTON_N or posedge OSC  ) 
 if (  !BUTTON_N ) begin 
     DELAY_CNT<=0;
 end
 else  begin 
    if  ( DELAY_CNT < SEC10 ) DELAY_CNT <= DELAY_CNT+1; 
 end 
 
endmodule 