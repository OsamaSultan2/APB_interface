module APB_master (
  pclk, prst_n, paddr, pselx, penable, pwrite,
  pwdata, prdata, pready, pslverr,transfer_type,error_flag,
  MOSI,MISO,address
);

  //=============== parameters init. ============================
  parameter ADDR_WIDTH =  8;    // can be up to 32 bits
  parameter DATA_WIDTH =  8;    // can be up to 32 bits
  //--------------- FSM STATES PARAMETERS -------------------------
  localparam IDLE =2'b00 ;
  localparam SETUP =2'b01 ;
  localparam  ACCESS=2'b10 ;
  //====================== input signals ============================
  input pclk, prst_n, pready,pselx, transfer_type,pslverr;
  input [DATA_WIDTH-1 : 0] MISO;
  input [DATA_WIDTH-1 : 0] prdata;
  input [ADDR_WIDTH -1 : 0] address;
  //====================== output sigmals ===========================
  output penable, pwrite, error_flag;
  output  reg [ADDR_WIDTH -1 : 0] paddr;
  output  reg [DATA_WIDTH -1 : 0] MOSI;
  output  reg [DATA_WIDTH -1 : 0] pwdata;
  //====================== internal signals ==========================
  reg [1:0] cs,ns;
  //======================  state transition kogic =========================
  always @(*) begin
    case (cs)
      IDLE:begin
        if (pselx) begin
          ns=SETUP;
        end
        else 
          ns=IDLE;
      end 
      SETUP:ns=ACCESS;
      ACCESS:begin
        if (pselx && pready) begin
          ns=SETUP;
        end
        else if (!pselx && pready) begin
          ns = IDLE;
        end
        else 
        ns = ACCESS;
      end 
      default: ns=IDLE;
    endcase
  end
//======================= next state kogic =======================
always @(posedge pclk or negedge prst_n) begin
  if(!prst_n)
  cs<=IDLE;
  else
  cs<=ns;
end
//======================= output logic ============================

  
endmodule