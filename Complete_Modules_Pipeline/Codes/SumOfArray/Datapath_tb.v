/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 10-04-2021
*/

/* Test bench for the Datapath module */
module Datapath_tb ();
   /* local reg*/
    reg Clk;
    // reg RegWrite, ALUSrc, PCSrc, MemWrite, MemRead, MemToReg;
	reg Reset,Jump,PCWrite;
	reg [63:0] NewPC;
    // reg [1:0] ALU_Op;
    wire [63:0] writedataa,readdata1,readdata2;
	wire [63:0] PCNext4,PCNow;
	wire [31:0] Instruction;
    wire zero;
   
   /* Instantiate the DUT */
   Datapath Dp(Clk,Instruction,zero,PCNow,PCNext4,Reset,NewPC,Jump,PCWrite,writedataa,readdata1,readdata2);
    /* stimulus
     * create and feed the input combinations
     * to the DUT */
   /* Procedural statement */
    initial begin
        Clk =1;
        forever
        #5 Clk<=~Clk;
    end
    
    initial
    begin
        $dumpfile("Datapath.vcd");
        $dumpvars(0,Datapath_tb);
        NewPC = 64'h0000000000000000;
        $monitor($time,".WD : %d ,RD1:%d ,RD2:%d ,INst: %h ,PCNOw:%d,CLk:%d",writedataa,readdata1,readdata2,Instruction,PCNow, Clk);
        repeat(50)
        begin
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
           
        end
        #5 $finish;
    end

endmodule //Datapath_tb