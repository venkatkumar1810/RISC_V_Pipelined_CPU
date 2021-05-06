/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 27-03-2021
*/

/* Test bench for the Datapath module */
module Datapath_tb ();
   /* local reg*/
    reg Clk;
    reg RegWrite, ALUSrc, PCSrc, MemWrite, MemRead, MemToReg;
	reg Reset,Jump,PCWrite;
	reg [63:0] NewPC;
    reg [3:0] Operation;
    wire [63:0] writedataa,readdata1,readdata2;
	wire [63:0] PCNext4,PCNow;
	wire [31:0] Instruction;
    wire zero;
   
   /* Instantiate the DUT */
   Datapath Dp(Clk,Instruction,zero,PCNow,PCNext4,Reset,NewPC,Jump,PCWrite,RegWrite,ALUSrc,Operation,MemWrite,MemRead,MemToReg,writedataa,readdata1,readdata2);
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
        $monitor($time,". Writedataa : %d, Readdata1 : %d, Readdata2 : %d, INstruction: %h , Operation : %b, PCNExt4: %d , PCNOw: %d , CLk: %d ,Zero: %b",writedataa,readdata1,readdata2, Instruction, Operation,PCNext4, PCNow, Clk,zero);
        begin
            #5 Operation = 4'b0010; RegWrite = 1; ALUSrc = 1;  MemToReg = 1; MemWrite = 1; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5$display("  ");
            $display("\taddi x15,x1,14 => x15 = 14");
            $display("  ");
            #5 Operation = 4'b0010; RegWrite = 1; ALUSrc = 0;  MemToReg = 1; MemWrite = 1; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x5,x6,x7 ; x6=2,x7=3 => x5 =5");
            $display("  ");
            #5 Operation = 4'b0010; RegWrite = 1; ALUSrc = 0;  MemToReg = 1; MemWrite = 1; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x5,x15,x5; 14+5 = 19 <- (x5)");
            $display("  ");
            #5 Operation = 4'b0110; RegWrite = 1; ALUSrc = 0;  MemToReg = 1; MemWrite = 1; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tsub x15,x15,x6 ; 14 - 2 = 12 <- x15");
            $display("  ");
            #5 Operation = 4'b0010; RegWrite = 1; ALUSrc = 1;  MemToReg = 0; MemWrite = 0; MemRead = 1; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tlw x15,4(x5) ; 4(x5) -> x6 = 3 then x15 <= 3");
            $display("  ");
            #5 Operation = 4'b0010; RegWrite = 1; ALUSrc = 0;  MemToReg = 1; MemWrite = 1; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x0,x0,x15 ; x0=0 x15=3");
            $display("  ");
            #5 Operation = 4'b0010; RegWrite = 0; ALUSrc = 1;  MemToReg = 0; MemWrite = 1; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tsw x5,0(x15) ; x5=19, 0(x15) <= 19");
            $display("  ");
            #5 Operation = 4'b0010; RegWrite = 1; ALUSrc = 1;  MemToReg = 0; MemWrite = 0; MemRead = 1; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tlw x5,0(x15) ; x5 <- 0(x15) then x5 = 19");
            $display("  ");
            #5 Operation = 4'b0010; RegWrite = 1; ALUSrc = 0;  MemToReg = 1; MemWrite = 1; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x5,x15,x5 ; x15 =3 , x5=19 then x5 = 22");
            $display("  ");
            #5 Operation = 4'b0110; RegWrite = 0; ALUSrc = 0;  MemToReg =1; MemWrite = 0; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5  $display("  ");
            $display("\tbeq x5, x15, 4");
            $display("  ");
            #5 Operation = 4'b0010; RegWrite = 1; ALUSrc = 0;  MemToReg = 1; MemWrite = 1; MemRead = 0; Reset = 1'b0; PCWrite = 1'b1; Jump = 1'b0;
            #5 $display("  ");
            $display("\tadd x5,x15,x5 ; x15 =3 , x5=19 then x5 = 22");
            $display("  ");
        end
        #5 $finish;
    end

endmodule //Datapath_tb