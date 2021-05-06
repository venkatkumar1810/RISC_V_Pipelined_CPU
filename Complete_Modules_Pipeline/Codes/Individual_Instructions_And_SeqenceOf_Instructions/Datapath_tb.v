/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 27-03-2021
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
        // Operation = 0010; 
        $monitor($time,".WD : %d ,RD1:%d ,RD2:%d ,INst: %h ,PCNOw:%d,CLk:%d,Zero:%b",writedataa,readdata1,readdata2,Instruction,PCNow, Clk,zero);
        begin
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5$display("  ");
            $display("\taddi x15,x1,14 => x15 = 14");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x5,x6,x7 ; x6=2,x7=3 => x5 =5");
            $display("  ");
            #5  Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x5,x15,x5; 14+5 = 19 <- (x5)");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tsub x15,x15,x6 ; 14 - 2 = 12 <- x15");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tlw x15,4(x5) ; 4(x5) -> x6 = 3 then x15 <= 3");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x0,x0,x15 ; x0=0 x15=3");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tsw x5,0(x15) ; x5=19, 0(x15) <= 19");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tlw x5,0(x15) ; x5 <- 0(x15) then x5 = 19");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x5,x15,x5 ; x15 =3 , x5=19 then x5 = 22");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5  $display("  ");
            $display("\tbeq x5, x15, 8");
            $display("  ");
            #5 Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x5,x15,x5 ;");
            $display("  ");
        end
        #5 $finish;
    end

endmodule //Datapath_tb