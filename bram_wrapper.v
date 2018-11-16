module bram_wrapper(input clk, rst, dinA, dinB, wea, rea, web, reb,  wec, rec, addrA, addrB, addrC, output dout);
parameter ID = 0;
parameter REG_EN = 0;
parameter PRT_B_EN = 0;
parameter NON_TP = 0;
parameter A_WID = 9;
parameter D_WID = 32;
parameter OPT_OUT = 1;
parameter IS_RST = 0;
parameter ONE_CLK = 0;
parameter PRT_A_EN = 0;
parameter MODE = "WRITE_FIRST";

   reg clk, rst;
   reg [A_WID-1:0] addrA, addrB, addrC;
   wire [D_WID-1:0] dinA, dinB;
   
   reg  wea;
   reg  rea;
   reg  web;
   reg  reb;
   
   reg [D_WID-1:0] doutA;
   reg [D_WID-1:0] doutB;
   

   //final output
   reg [D_WID-1:0] dout;

   //instance
   bram #(
	  .A_WID(A_WID),
	  .D_WID(D_WID)	  
	  ) bram_inst( .wrclk(clk), 
		   .wraddr(addrA), 
		   .din(din_a), 
		   .rst(rst), 
		   .we(we_a), 
		   .porta_en(en_a), 
		   
		   .rdclk(clk), 
		   .portb_en(en_b), 
		   .reg_en(reg_en_b), 
		   .rdaddr(addrB), 
		   .dout(dout_b)
		   );
    always @(posedge clk)
	begin
	if()
	end
	
		//addr incrementing
    always @(posedge clk or posedge rst)
      begin
        if(rst || cntr==14'd511)
		begin   
		   cntr <= 0;
		end
		else
		begin
		   cntr <= cntr+1;
		end
    end
	  
	always @(posedge clk or posedge rst)
	if(rst) begin
	   addrA <= 0;
	   addrB <= 0;
	end
	else
	begin
	   dinA[31:0] <= cntr+1;
	   dinB[31:0] <= cntr+2;
	   addrA <= cntr;
	   addrB <= cntr;
	end
	
    always @(negedge clk)
	if(rst) begin
	   wea <= 0;
	   rea <= 0;
	   web <= 0;
	   reb <= 0;
	end 
	else if (dut_start) begin
	   {wea,rea} <= 2'b11;
	   {web,reb} <= 2'b11;
	   
	end

   always @(posedge clk)
        if(rst) begin
           pass <= 0;
           fail <= 0;
        end
        else if (dut_start) begin
           if ( (addr_b === 0 && dout_b !== 'hF_FFFF_FFFF) ||
                      (addr_b === 'h01F && dout_b !== 0) ) begin
              $display("ID: PortB failed", ID);
              fail <= 1;
           end
           else
             pass <= 1;
        end

	
endmodule // dp_ram_top