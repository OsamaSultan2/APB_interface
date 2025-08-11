module APB_bus 
#(  parameter DATAWIDTH = 8,   //can be upt to 32 bits
    parameter ADDRESSWIDTH = 9 //can be upt to 32 bits
)
(
  input pclk, preset_n, valid1, valid2,
  input [1:0] process,
  input [ADDRESSWIDTH - 1 : 0] address,
  input [DATAWIDTH - 1 : 0] Masterin,Slavein1,Slavein2,

  output [1:0] block_slk,
  output [DATAWIDTH -1 : 0] Master_out, Slave_out,
  output [ADDRESSWIDTH - 2 : 0] slave_addr
  );
  //================ wire declerations =========================
  wire pready, pwrite, penable;
  wire [DATAWIDTH -1 : 0 ] prdata,pwdata;
  wire [ADDRESSWIDTH-2:0]  paddr ;
  wire [1:0] pselx;
  //================ master instantiation =======================
  APB_master master (
    .pclk(pclk),
    .preset_n(preset_n),
    .pready(pready),
    .process(process),
    .datain(Masterin),
    .prdata(prdata),
    .address(address),
    .penable(penable),
    .pwrite(pwrite),
    .pselx(pselx),
    .paddr(paddr),
    .dataout(Master_out),
    .pwdata(pwdata)
  );
  //================ slave instantiation =========================
  APB_slave slave (
    .pclk(pclk),
    .preset_n(preset_n),
    .pready(pready),
    .pwrite(pwrite),
    .valid1(valid1),
    .valid2(valid2),
    .penable(penable),
    .pselx(pselx),
    .datain1(Slavein1),
    .datain2(Slavein2),
    .pwdata(pwdata),
    .paddr(paddr),
    .prdata(prdata),
    .dataout(Slave_out),
    .address(slave_addr),
    .block_slk(block_slk)
  );
endmodule