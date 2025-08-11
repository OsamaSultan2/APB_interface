module APB_master #(
  parameter DATAWIDTH = 8, //can be upt to 32 bits
  parameter ADDRESSWIDTH = 9 //can be upt to 32 bits
) (
  input pclk, preset_n, pready,
  input [1:0] process,
  input [DATAWIDTH-1:0] datain, prdata,
  input [ADDRESSWIDTH-1:0] address,

  output reg penable,pwrite,
  output reg [1:0] pselx,
  output reg [ADDRESSWIDTH-2:0] paddr,
  output reg [DATAWIDTH-1 :0] dataout,pwdata
);
//==================== FSM  states ========================
  localparam IDLE ='b00 ;
  localparam SETUP = 'b01;
  localparam ACCESS = 'b10;
//=================== internal signals ===================
reg [1:0] cs,ns;
//================== next state logic =====================
always @(posedge pclk or negedge preset_n) begin
  if(!preset_n)
    cs<= IDLE;
  else 
    cs <= ns;
end
//================ state transition =======================
always @(*) begin
  case (cs)
    IDLE:begin
      if(process[1]) 
      ns = SETUP;
      else
      ns = IDLE;
    end 
    SETUP:
    ns = ACCESS; 
    ACCESS:begin
      if (pready) begin
        if (!process[1]) begin
          ns = IDLE;
        end
        else
          ns = SETUP;
      end
      else
      ns = ACCESS;
    end
    default: ns = IDLE;
  endcase
end
//=================== output logic ===============================
always @(cs) begin
  case (cs)
    IDLE:begin
      penable <= 0;
      pwrite  <= 0;
      dataout <= 0;
      pwdata  <= 0;
      paddr   <= 0;
      pselx   <= 0;
    end 
    SETUP:begin
      case (address[ADDRESSWIDTH-1])
        2'b00:   pselx <= 2'b01; 
        2'b01:   pselx <= 2'b10;
        default: pselx <= 2'b00;
    endcase
      penable <= 0;
      pwrite  <= process[0];
      dataout <= 0;
      pwdata  <= datain;
      paddr   <= address[ADDRESSWIDTH-2:0];
    end 
    ACCESS:begin
      case (address[ADDRESSWIDTH-1])
        2'b00:   pselx <= 2'b01; 
        2'b01:   pselx <= 2'b10;
        default: pselx <= 2'b00;
      endcase
      penable <= 1;
      pwrite  <= process[0];
      dataout <= prdata;
      pwdata  <= datain;
      paddr   <= address[ADDRESSWIDTH-2:0];
    end 
    default: begin
      penable <= 0;
      pwrite  <= 0;
      dataout <= 0;
      pwdata  <= 0;
      paddr   <= 0;
      pselx   <= 0;
    end
  endcase
end
endmodule