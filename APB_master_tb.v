module APB_master_tb ();
  parameter DATAWIDTH = 8; //can be upt to 32 bits
  parameter ADDRESSWIDTH = 9; //can be upt to 32 bits
  reg pclk, preset_n, pready;
  reg [1:0] process;
  reg [DATAWIDTH-1:0] datain, prdata;
  reg [ADDRESSWIDTH-1:0] address;

  wire penable,pwrite;
  wire [1:0] pselx;
  wire [ADDRESSWIDTH-2:0] paddr;
  wire [DATAWIDTH-1 :0] dataout,pwdata;
//====================== DUT inistantiation ==================================
APB_master dut (
  .pclk(pclk),
  .preset_n(preset_n),
  .pready(pready),
  .process(process),
  .datain(datain),
  .prdata(prdata),
  .address(address),
  .penable(penable),
  .pwrite(pwrite),
  .pselx(pselx),
  .paddr(paddr),
  .dataout(dataout),
  .pwdata(pwdata)
  );
//=================== clock generation =========================================
initial begin
  pclk =0;
  forever begin
  #5 pclk = ~ pclk; 
  end
end
//=================== testbench ========================================
initial begin
//==> initializing data 
  preset_n  = 0;
  pready    = 0;
  process   = 0;
  datain    = 0;
  prdata    = 0;
  address   = 0;
@(negedge(pclk));
//==> beginning the transaction
  preset_n  = 1;
  process   = 'b10;
  address   = 9'b0_0001_0000;
@(negedge(pclk));
//==> setup phase 
  pready    = 0;
  process   = 'b11;
  datain    = 'b0001_0010;
  prdata    = 0;
  @(negedge(pclk));
//==> access phase
  pready    = 1;
  @(negedge(pclk));
//==> trying reading
  pready    = 0;
  process   = 'b10;
  address   = 9'b1_0001_1101;
  @(negedge(pclk));
//===> acccess phase
  pready =1;
  prdata ='b0000_0001;
    address =0;
    process =0;
  @(negedge(pclk));
  process  =0;
  @(negedge(pclk));
//===> return to idle

$stop;
end
endmodule