/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 27-03-2021
*/

module mux_2to1_64bit(out, inA, inB, sel);

   //I/O port declarations

    output  [63:0] out;
    
    input   [63:0] inA;
    input   [63:0] inB;
    input          sel;
	reg [63:0]out;

	always@(inA,inB,sel) begin
        if (sel == 0) begin
        out <= inA;
        end
        else begin
        out <= inB;
        end
	end
endmodule // mux_2to1_64bit

/* FULL ADDER*/
module FA(sum,carry_out,a,b,carry_in);
    // I/O port declarations
    input  a,b,carry_in;
    output sum, carry_out;

    // no net
    
     // behaviouiral
    assign sum = (~a & ~b & carry_in) | (~a & b & ~carry_in) | (a & ~b & ~carry_in) | (a & b & carry_in); 
    assign carry_out = (a & b) | (b & carry_in) | (carry_in & a); 

endmodule // FA

/* n-bit ripple carry adder */
module RCA_param(Sum, carry_out, A, B, carry_in);
    
    parameter N = 64;
    // I/O port declaration

    input  [N-1:0] A,B;
    input  carry_in;
    output  [N-1:0] Sum;
    output  carry_out;

    genvar i;

    wire [N:0] w;
   // behavioural

    assign w[0] = carry_in;
    assign carry_out = w[N];

    generate for( i = 0; i< N; i=i+1)
    begin: fa0
        FA fa0(.sum(Sum[i]),.carry_out(w[i+1]),.a(A[i]),.b(B[i]),.carry_in(w[i]));
    end
	 endgenerate
    // wire w0_1,w1_2,w2_3,w3_4;

endmodule // RCA_param

/* THIS MODULE IS USED WHENEVER WE ARE USING BEQ INSTURCTION */
module left_shift_1(out_shifted,inp);
    input [63:0] inp;
    output [63:0] out_shifted;
    assign out_shifted[63:1] = inp[62:0];
    assign out_shifted[0] = 0;
endmodule

/*THIS MODULE EXTRACTS THE IMMEDIATE VALUE FROM THE INSTRUCTION OBTAINED 
	FROM THE RF AND FURTHER EXTENDS THE IMMEDIATE VALUE TO 64BITS */
module sign_extension(out, in,ExtendSign);
    // I/O port declarations

    /* A 32-Bit input word */
    input   [31:0] in;
	input ExtendSign;
	wire [51:0] ext;
    wire [6:0] Opc;
	assign Opc = in[6:0];
    /* A 64-Bit output word */
    output  [63:0] out;
	reg [63:0] out;
    // assign ext = in[31];
    always@(in or Opc)
	 begin
	 	if(Opc == 7'b0010011 || Opc == 7'b0000011 ) begin
			if (ExtendSign == 1) begin
				// $display("sooya");
				// out <= {52'h0000000000000,in[31:20]};
				out <= {52'hfffffffffffff , in[31:20]};
				// out <= $signed(in[31:20]);
			end 
			else begin
				// if (in[31]==1) begin
				// $display("sooya123");
				out <= {52'h0000000000000 , in[31:20]};
			end

		end
	 	if(Opc == 7'b1100011) begin
			if (ExtendSign == 1) begin
				out <= {52'hfffffffffffff , in[31],in[7],in[30:25],in[11:8]};
				// $display("sooya");
			end 
			else begin
				// if (in[31]==1) begin
				out <= {52'h0000000000000 , in[31],in[7],in[30:25],in[11:8]};
			end
			// else begin
			// 	out <= in;
			// end
		end
	 	if(Opc == 7'b0100011) begin
			if (ExtendSign == 1) begin
				// $display("sooya");
				out <= {52'hfffffffffffff , in[31:25],in[11:7]};
			end 
			else begin
				// if (in[31]==1) begin
				out <= {52'h0000000000000 , in[31:25],in[11:7]};
			end
			// else begin
			// 	out <= in;
			// end
		end
		// end
	end
endmodule  // sign_extensions

/* THIS THE MODULE TO GETS THE REQUIRED RS1,RS2,RD REQURED FOR THE 
	REGISTER MEMORY FILES BASED ON THE OPCODE*/
module getreg(inp,rs1,rs2,rd);
       // I/O port declarations
	input [31:0] inp;
	output reg [4:0] rs1,rs2,rd;
	wire [6:0] Opc;
	assign Opc = inp[6:0];

	always@(inp or Opc)
	begin
		// sum/sub R type inst
	 	if(Opc == 7'b0110011 ) begin
			rs1 = {inp[19:15]};
			rs2 = {inp[24:20]}; // dont care value;
			rd  = {inp[11:7]}; 
		end
	 	// load I type
	 	if(Opc == 7'b0010011 || Opc == 7'b0000011 ) begin
			rs1 = {inp[19:15]};
			rs2 = {inp[24:20]}; // dont care value;
			rd  = {inp[11:7]}; 
		end
		//beq - B type
	 	if(Opc == 7'b1100011) begin
			rs1 = {inp[19:15]};
			rs2 = {inp[24:20]};
			rd  = {inp[19:15]}; // dont care value;
		end
		// store - S - type
	 	if(Opc == 7'b0100011) begin
			rs1 = {inp[19:15]};
			rs2 = {inp[24:20]}; // dont care value;
			rd  = {inp[11:7] }; 
		end
	end
endmodule // getreg

/* PCADDER 
* Design an incrementor  that computes the current  PC + 4 
* The result should always be an increment of the signal 'PCResult' by  4 (i.e., PCAddResult = PCResult + 4) */
module PCAdderr(PCResultT, PCAddResultT);
    // I/O port declarations
    input [63:0]  PCResultT;
    output reg [63:0]  PCAddResultT;

    always @(PCResultT)
    begin
    	PCAddResultT <= PCResultT + 64'h0000000000000004;
    end
endmodule // PCAdderr

/* PgCOUNTER
* Design a program counter register that holds the current address of the  instruction memory
* This module should be updated at the positive edge of  the clock 
*  The contents of a register default to unknown values or 'X' upon  instantiation in your module */
module ProgramCounterr(PCNextt, PCResultt, Resett, Clkk,PCWritee);
	input [63:0] PCNextt;
	input Resett, Clkk,PCWritee;
	output reg [63:0]  PCResultt;
	initial begin
		PCResultt <= 64'h0000000000000000;
	end
    always @(posedge Clkk)
    begin
    	if (Resett == 1)
    	begin
    		PCResultt <= 64'h0000000000000000;
    	end
    	else
    	begin
			if (PCWritee == 1) begin
				PCResultt <= PCNextt;
			end
    	end
		//$display("PC=%h",PCResult);
    end
endmodule // ProgramCounterr


/* INSTRUCTIONS MEMORY
* Similar to the DataMemory, this module should also be byte-addressed
* All of the instructions will be  hard-coded into the instruction memory
* The contents of the InstructionMemory is the machine language program to be run on your RISCV processor */

module InstructionMemoryy(Address, Instruction); 
    input [63:0] Address;        // Input Address 
    output [31:0] Instruction;    // Instruction at memory location Address  
    reg [31:0] mem[0:30];		  // we can replace 13 with 1024 when keep 1024 values in Code.txt
	initial
	begin
		$readmemh("memory_instructions.txt",mem);
	end
	assign Instruction = mem[Address>>2];	
endmodule // InstructionMemoryy



/* REGFILE
* 'ReadRegister1' and 'ReadRegister2' are two 5-bit addresses to read two 
* registers simultaneously. The two 32-bit data sets are available on ports 
* 'ReadData1' and 'ReadData2', respectively. 'ReadData1' and 'ReadData2' are 
* registered outputs */
module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);

	input [4:0] ReadRegister1,ReadRegister2,WriteRegister;
	input [63:0] WriteData;
	input RegWrite,Clk;

	output reg [63:0] ReadData1,ReadData2;
	
	//reg [31:0] Registers = new reg[32];
	reg [63:0] Registers [0:31];
	
	initial begin
		Registers[0]  <= 64'h0000000000000000;
		Registers[1]  <= 64'h0000000000000000;
		Registers[2]  <= 64'h0000000000000000;
		Registers[3]  <= 64'h0000000000000000;
		Registers[4]  <= 64'h0000000000000000;
		Registers[5]  <= 64'h0000000000000000;
		Registers[6]  <= 64'h0000000000000000;  // TEST INPUTS
		Registers[7]  <= 64'h0000000000000000;  // TEST INPUTS
		Registers[8]  <= 64'h0000000000000000;
		Registers[9]  <= 64'h0000000000000000;
		Registers[10] <= 64'h0000000000000000;
		Registers[11] <= 64'h0000000000000000;
		Registers[12] <= 64'h0000000000000000;
		Registers[13] <= 64'h0000000000000000;
		Registers[14] <= 64'h0000000000000000;
		Registers[15] <= 64'h0000000000000000;
		Registers[16] <= 64'h0000000000000000;
		Registers[17] <= 64'h0000000000000000;
		Registers[18] <= 64'h0000000000000000;
		Registers[19] <= 64'h0000000000000000;
		Registers[20] <= 64'h0000000000000000;
		Registers[21] <= 64'h0000000000000000;
		Registers[22] <= 64'h0000000000000000;
		Registers[23] <= 64'h0000000000000000;
		Registers[24] <= 64'h0000000000000000;
		Registers[25] <= 64'h0000000000000000;
		Registers[29] <= 64'h0000000000000000; 
		Registers[31] <= 64'h0000000000000000;
	end

	always @(posedge Clk)
	begin
		if (RegWrite == 1) 
		begin
			Registers[WriteRegister] <= WriteData;
		end
	end
	
	always @(negedge Clk)
	begin
		ReadData1 <= Registers[ReadRegister1];
		ReadData2 <= Registers[ReadRegister2];
	end
	
endmodule


/* DATAMEMORY:
*  Create a memory and initilize it by reading from a test data  
* The 'WriteData' value is written into the address  in the positive clock edge if 'MemWrite'  signal is 1
* 'ReadData' is the value of memory location if  'MemRead' is 1 
* otherwise, it is 0x00000000. The reading of memory is not  clocked */
module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData,BHW,ExtendSign);

// I/O port declarations 

    input [63:0] Address; 	 	// Input Address 
    input [63:0] WriteData;  	// Data that needs to be written into the address 
	input [1:0] BHW;
    input Clk,ExtendSign;
    input MemWrite; 	        // Control signal for memory write 
    input MemRead; 			    // Control signal for memory read 
    output reg [63:0] ReadData; // Contents of memory location at Address
    reg [31:0] Memory [0:20];	// stack pointer initialization depends on this
      
   		always @(posedge Clk)		   //Memory write
   		begin
			if (MemWrite==1) begin
				case (BHW)
					0: begin
						case (Address[1:0])
							0:
								Memory[Address>>2] = {Memory[Address>>2][31:8],WriteData[7:0]};
							1:
								Memory[Address>>2] = {Memory[Address>>2][31:16],WriteData[7:0],Memory[Address>>2][7:0]};
							2:
								Memory[Address>>2] = {Memory[Address>>2][31:24],WriteData[7:0],Memory[Address>>2][15:0]};
							3:
								Memory[Address>>2] = {WriteData[7:0],Memory[Address>>2][23:0]};
						endcase
					end
					1: begin
						case (Address[1])
							0:
								Memory[Address>>2] = {Memory[Address>>2][31:16],WriteData[15:0]};
							1:
								Memory[Address>>2] = {WriteData[15:0],Memory[Address>>2][15:0]};
						endcase
					end
					2: begin
						Memory[Address>>2] = {WriteData[31:0]};
					end
				endcase
			end
   		end

   		always @(Address or MemRead)
   		begin	
   			if	(MemRead == 1) begin
				case (BHW)
					0: begin // BYTE
						case (Address[1:0]) // 31:24,23:16,15:8,7:0
							0: begin
								if (ExtendSign && Memory[Address>>2][7])
									ReadData <= {56'hffffffffffffff,Memory[Address>>2][7:0]};
								else 
									ReadData <= {56'h00000000000000,Memory[Address>>2][7:0]};
							end
							1: begin
								if (ExtendSign && Memory[Address>>2][15])
									ReadData <= {56'hffffffffffffff,Memory[Address>>2][15:8]};
								else 
									ReadData <= {56'h00000000000000,Memory[Address>>2][15:8]};
							end
							2: begin
								if (ExtendSign && Memory[Address>>2][23])
									ReadData <= {56'hffffffffffffff,Memory[Address>>2][23:16]};
								else 
									ReadData <= {56'h00000000000000,Memory[Address>>2][23:16]};
							end
							3: begin
								if (ExtendSign && Memory[Address>>2][31])
									ReadData <= {56'hffffffffffffff,Memory[Address>>2][31:24]};
								else 
									ReadData <= {56'h00000000000000,Memory[Address>>2][31:24]};
							end
						endcase
					end
					1: begin // HALFWORD
						case (Address[1])
							0: begin
								if (ExtendSign && Memory[Address>>2][15])
									ReadData <= {32'hffffffff,Memory[Address>>2][15:0]};
								else 
									ReadData <= {32'h00000000,Memory[Address>>2][15:0]};
							end	
							1: begin
								if (ExtendSign && Memory[Address>>2][31])
									ReadData <= {32'hffffffff,Memory[Address>>2][31:16]};
								else 
									ReadData <= {32'h00000000,Memory[Address>>2][31:16]};
							end
						endcase
					end
					2: begin // WORD
                        ReadData <= {32'h00000000,Memory[Address>>2]};
					end
				endcase
   			end else 
   				ReadData <= 32'h00000000;		
   		    end 

endmodule  // DataMemory

/* This function to give fun6 value to ALU CU*/
module Fun6_OP(inst31,inst14_12,fun6);
	input inst31;
	input [2:0] inst14_12;
	output [5:0] fun6;
	reg [5:0] fun6;
	always @(inst31,inst14_12) 
	begin
		fun6 <= {2'b00,inst14_12[2:1],inst31,inst14_12[0]};
	end
endmodule //Fun6_OP

/* MODULE FOR ALL THE CONNECTIONS REQUIRED FOR THE TEST BENCH
NOTE THAT NO OUTPUTS WILL BE PRESENT, THE OUTPUTS GIVEN HERE ARE 
JUST FOR REFERENCE PURPOSE AND TO GET BLOCK DIAGRAMS */
module Datapath(Clk,Instruction,zero,PCNow,PCNext4,Reset,NewPC,Jump,PCWrite,writedataa,readdata1,readdata2);
	
    //RegWrite,ALUSrc,ALU_Op,MemWrite,MemRead,MemToReg,
    input Clk;
	input Reset,Jump,PCWrite;
	input [63:0] NewPC;
    output [63:0] writedataa,readdata1,readdata2;
	output [63:0] PCNext4,PCNow;
	output wire [31:0] Instruction;
	output zero;

    wire [63:0] PCAdderOut,PCNext,PCOut;
    wire [63:0] new_pc_out;
    wire [1:0] ALU_Op;
    wire RegWrite, ALUSrc, MemWrite, MemRead, MemToReg;
	 
    PCAdderr pcadder(PCOut,PCAdderOut);
	ProgramCounterr PCounterr(PCNext,PCOut,Reset,Clk,PCWrite);
	InstructionMemoryy memory(PCOut,Instruction);
	mux_2to1_64bit JumpOrPCNext4Mux(PCNext,new_pc_out,NewPC,Jump); 

	assign PCNow = PCOut;
	assign PCNext4 = PCAdderOut;

	wire branch;
	// Control_Unit (instruction6_0,Branch,MemRead,ALUOp,MemToReg,MemWrite,ALUSrc,RegWrite);
	Control_Unit Main_CU(Instruction[6:0],branch,MemRead,ALU_Op,MemToReg,MemWrite,ALUSrc,RegWrite);
	// wire [6:0] Opc;
	wire [4:0] rss1, rss2, rdd;
	// assign Opc = instruction[6:0];
	getreg GR(Instruction[31:0],rss1,rss2,rdd);
	
	//RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    RegisterFile RF(rss1,rss2,rdd,writedataa,RegWrite,Clk,readdata1,readdata2);
    
    wire [63:0] sign_extended;
    //module sign_extension(out, in,ExtendSign);
    sign_extension SE(sign_extended, Instruction[31:0], Instruction[31]);

	wire [5:0] fun6_ALU_CU;
	Fun6_OP F6(Instruction[30],Instruction[14:12],fun6_ALU_CU);
    wire [3:0] Operation;
	ALU_CU alucu(Operation,fun6_ALU_CU,ALU_Op);

    wire [63:0] mux_out;
    //mux_2to1_64bit(out, inA, inB, sel);
    mux_2to1_64bit mx21_64(mux_out,readdata2,sign_extended,ALUSrc);
    
  
	wire Alu_carry_out;
    wire [63:0] ALU_result;
    // wire ALu_Carryin;
    assign cin = Operation[2];
    ALU_params AP(ALU_result,Alu_carry_out,readdata1,mux_out,cin,Operation);
	Zero_check ZC(zero,ALU_result);

    wire [63:0] readdata3;
    wire [1:0] bhw;
    assign bhw = 2;

    //DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData,BHW,ExtendSign); 
    DataMemory DM(ALU_result, readdata2, Clk, MemWrite, MemRead, readdata3,bhw,ALU_result[31]);

    wire [63:0] mux_out_mr;
    //mux_2to1_64bit(out, inA, inB, sel);
    mux_2to1_64bit MtoREg(mux_out_mr,readdata3,ALU_result,MemToReg);
    assign writedataa = mux_out_mr;

    wire [63:0] shifted_by_1;
    left_shift_1 LS1(shifted_by_1,sign_extended);

    wire [63:0] rca_out;
    wire carryin,carryout;
    assign carryin = 0;
    //module RCA_param(Sum, carry_out, A, B, carry_in);
    RCA_param ADDER_NPC(rca_out,carryout,PCOut,shifted_by_1,carryin);
    
	wire PCSrc;
	AND and_near_pcsrc(PCSrc,zero,branch);
    // assign PCSrc = zero;
    //mux_2to1_64bit(out, inA, inB, sel);
    mux_2to1_64bit near_npc(new_pc_out,PCAdderOut,rca_out,PCSrc);

endmodule //Datapath