/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 26-03-2021 
*/


/* MODULE PC ADDER-
* Design an incrementor that computes the current  PC + 4 
* The result should always be an increment of the signal 'PCResult' by  4 (i.e., PCAddResult = PCResult + 4) */
module PCAdder(PCResultT, PCAddResultT);

    input [63:0]  PCResultT;
    output reg [63:0]  PCAddResultT;

    always @(PCResultT)
    begin
    	PCAddResultT <= PCResultT + 64'h0000000000000004;
    end
endmodule



/* PROGRAM COUNTER
* Design a program counter register that holds the current address of the  instruction memory
* This module should be updated at the positive edge of  the clock
* The contents of a register default to unknown values or 'X' upon  instantiation in your module
* Hence, please add a synchronous 'Reset'  signal to your PC register to enable global reset of your datapath to point 
* to the first instruction in your instruction memory */
module ProgramCounter(PCNextt, PCResultt, Resett, Clkk,PCWritee);
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
endmodule


/* INSTRUCTION MEMORY
* Similar to the DataMemory, this module should also be byte-addressed
* All of the instructions will be  hard-coded into the instruction memory */  
module InstructionMemory(Address, Instruction); 
    input [63:0] Address;        // Input Address 
    output [31:0] Instruction;    // Instruction at memory location Address  
    reg [31:0] mem[0:13];		  // we can replace 13 with 1024 when keep 1024 values in Code.txt
	initial
	begin
		/*THIS FILE CONTAINS THE LIST OF INSTRUCTION TO BE DECODED*/
		$readmemh("memory_instructions.txt",mem);

	end
	assign Instruction = mem[Address>>2];	
endmodule

/* Module - mux_2to1_64bit.v
* Description - Performs signal multiplexing between 2 32-Bit words */
module mux_2to1_64bit(out, inA, inB, sel);
    
    input [63:0] inA;
    input [63:0] inB;
    input sel;
    output [63:0] out;

	reg [63:0] out; 
	always@(inA,inB,sel)
	begin
		if (sel == 0) begin
			out <= inA;
		end
		else begin
			out <= inB;
		end
	end
	 
endmodule


/* FUNCTIONALITY
* Connect the modules together for a testbench 
* @@ The 'Reset' input control signal is connected to the program counter (PC) 
* register which initializes the unit to output the first instruction in  instruction memory
* @@ The 'Instruction' output port holds the output value from the instruction memory module
* @@ The 'Clk' input signal is connected to the program counter (PC) register 
* which generates a continuous clock pulse into the module */
module InstructionFetchUnit(Instruction, PCNow,PCNext4,Reset, Clk,NewPC,Jump,PCWrite);

	wire [63:0] PCAdderOut,PCNext,Instruction1,PCOut;
	input Reset,Clk,Jump,PCWrite;
	input [63:0] NewPC;
	output [63:0] PCNext4,PCNow;
	output [31:0] Instruction;

	PCAdder adder(PCOut,PCAdderOut);
	ProgramCounter PC(PCNext,PCOut,Reset,Clk,PCWrite);
	InstructionMemory mem(PCOut,Instruction);
	mux_2to1_64bit JumpOrPCNext4Mux(PCNext,PCAdderOut,NewPC,Jump); 

	assign PCNow = PCOut;
	assign PCNext4 = PCAdderOut;

endmodule

