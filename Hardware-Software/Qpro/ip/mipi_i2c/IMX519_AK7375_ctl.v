`define CMD_CCD_INIT        4'd01  // init. cmd_param0=0 for 1080p; other values are reserved.
`define CMD_CCD_EXPOSRE     4'd02  // exposure value = cmd_param0,  range:0x0020~0xffbc, defualt:0x3e8
`define CMD_CCD_ANALOG_GAIN 4'd03  // analog gain value = cmd_param0, range:0x0100~0xffff, defualt:0x0100
`define CMD_CCD_COLOR_BAL   4'd04  // color balance. blue gain = cmd_param0, red gain = cmd_param1
`define CMD_VCM_ACTIVE      4'd10  // vcm power on
`define CMD_VCM_STANDBY     4'd11  // vcm power off
`define CMD_VCM_POS         4'd12  // set vcm pos = param0, range:0~65535

module IMX519_AK7375_ctl (
input        [2:0]iKEY ,
input            iCLK         ,
input            iRST_N       ,
output reg [3:0] oCMD         ,
output reg [15:0]oCMD_PARAM0  ,
output reg [15:0]oCMD_PARAM1  ,
output reg       oCMD_START   ,
input            iCMD_DONE    ,
input            iCMD_DONE_ERR,

// --- AXI4-Stream Inputs for Sync ---
input [3:0]      AXI_TUSER,     
input            AXI_TVALID,    

// Auto color blance parameter input
input [15:0] iBLUE_GAIN,
input [15:0] iRED_GAIN,

// Auto foucus parameter input
input    [15:0]iVCM_DATA ,
input          iVCM_END  ,

output reg [7:0]ST 
);//

parameter  init_DELAY  =10000 ;
parameter  START_DELAY =148500*5;// 5ms 500 ; //

reg [31:0]delay;   
reg [2:0 ]rKEY ; 
//reg [7:0 ]ST ; 
reg       sof_d;
reg [15:0] last_vcm_data;


wire VS_NS;         


// --- Simplified Sync Logic for AXI-Stream ---
reg [15:0] vs_stretcher;
wire sof = AXI_TUSER[0] & AXI_TVALID;

always @(posedge iCLK) begin
    if (!iRST_N) begin
        vs_stretcher <= 0;
    end else begin
        // When we see the 1-cycle SOF, start a counter
        if (sof) 
            vs_stretcher <= 16'hFFFF; // Stay "High" for 65535 cycles
        else if (vs_stretcher > 0) 
            vs_stretcher <= vs_stretcher - 1;
    end
end


assign VS_NS = (vs_stretcher > 0);

always @(negedge iRST_N or posedge iCLK ) begin 
if (!iRST_N ) begin
  rKEY       <=iKEY ; 
  ST         <=0;
  oCMD       <=0;  
  oCMD_PARAM0<=0;  
  oCMD_PARAM1<=0;  
  oCMD_START <=0;  
  delay      <=0;
end


else begin 
  rKEY    <= iKEY;   
  sof_d   <= sof;

case (ST)
 0:  begin
      if (delay==init_DELAY ) ST<=1 ; 
 		  else delay <=delay+1 ; 
 end
 1:  begin
     if (iCMD_DONE) begin 
	      oCMD_START <=0; 
		          if (rKEY[0] & ~iKEY[0] ) begin ST<=2; delay<=0  ;oCMD<=`CMD_CCD_COLOR_BAL;   oCMD_PARAM0<=iBLUE_GAIN; oCMD_PARAM1<=iRED_GAIN ;end   //CCD_COLOR_BAL  
		    else  if (rKEY[1] & ~iKEY[1] ) begin ST<=80 ; end   //Auto Focuse  
	       else  if (rKEY[2] & ~iKEY[2] ) begin ST<=2; delay<=0  ;oCMD<=`CMD_CCD_INIT; end   //CCD_INIT       
	  end 
    end
 2:  begin 
       oCMD_START <=1  ; 
       if (delay==START_DELAY ) ST<=1 ; 
		  else delay <=delay+1 ; 
     end
	  
///----- auto foucs start-------------
80:  begin
		  oCMD<=`CMD_VCM_ACTIVE; //CMD_VCM_ACTIVE     
        delay       <=0  ;	
	     ST          <=81 ; 	  
end
81:  begin 
       oCMD_START <=1  ; 
       if (delay==START_DELAY ) ST<=82 ; 
		  else delay <=delay+1 ; 
     end
82:begin 	  
     if (iCMD_DONE) begin 
	       oCMD_START <=0; 
			 delay      <=0 ;	
			 ST         <=83 ; 
	  end	
end
83:  begin 
       if (delay == START_DELAY ) begin ST<=84 ; end 
		  else delay <=delay+1 ; 
end 	  
84:  begin 
  if (!VS_NS) begin
   if (iVCM_END) 
		begin
          ST<=1; 
		end
	else if (iVCM_DATA != last_vcm_data) 
     begin 
			 last_vcm_data <= iVCM_DATA;
          oCMD<=`CMD_VCM_POS ; 
          oCMD_PARAM0<=iVCM_DATA;
          delay <=0 ; 
          ST<=85; 
     end  
  end  
end 

85:  begin 
       oCMD_START <=1  ; 
       if (delay==START_DELAY ) ST<=86 ; 
		  else delay <=delay+1 ; 
     end
86:begin 	  
     if (iCMD_DONE) begin 
	       oCMD_START <=0; 
			 ST         <=84 ; 
     end
end	    
	  
endcase 

end
end
endmodule 
