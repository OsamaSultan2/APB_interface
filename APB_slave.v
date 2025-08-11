module APB_slave #(
  parameter DATAWIDTH = 8, //can be up to 32 bits
  parameter ADDRESSWIDTH = 8 //can be up to 32 bits
) (
  input pclk, preset_n, pwrite,valid1,valid2,penable,
  input [1:0] pselx,
  input [DATAWIDTH-1 : 0] datain1,datain2,pwdata,
  input [ADDRESSWIDTH-1 : 0] paddr,

  output pready,
  output reg [DATAWIDTH-1 : 0] dataout, prdata,
  output reg [ADDRESSWIDTH-1 : 0] address,
  output reg [1:0] block_slk
);
//=======================================================
  assign pready = (valid1 | valid2)  & penable ;
  always @( posedge pclk or negedge preset_n ) begin
    if (~preset_n) begin
      block_slk <= 0;
      dataout   <= 0;
      prdata    <= 0;
      address   <= 0;
    end
    else if( (|pselx) ) begin
      block_slk   <= pselx;
      if (penable) begin
          address <= paddr;
        if (pwrite) begin
          dataout <= pwdata;
        end
        else begin
        if (pready) begin
          prdata <= (pselx =='b01)? datain1: (pselx == 'b10)? datain2:0;
        end
        else 
          prdata <= 0;
        end
      end
    end
  end
endmodule