/*COMPUTER ARCHITECTURE AND ORGANIZATION-ASSIGNMENT-3*/

TEAM MEMBERS:

1. Yenumula Venkat Kumar - 191CS263
   Mobile: 8688414344
   Email: venkatkumaryenumula18@gmail.com
2. Tummala Ajay	         - 191CS259
   Mobile: 9100647787
   Email: ajaytummala99@gmail.com

SOFTWARES USED:
1. Xilinx 14.7 ISE Design Suite for block diagrams
2. Visual Studio Code + Icarus(iverilog compiler) for the coding part
3. gtkwave for the wave diagrams

CONTRIBUTIONS:
   BOTH OF US(Venkat and Ajay),had regural conversions over MS-Teams 
   and we distrubuted the work related to this reasonably, Like the 
   we did have both of our work in this Q5 and Q4 
   we first implemented this Q5 because after implementing Instruction 
   fetch unit, it would be better to connect it to the data path completely
   and for Q4 it'd be just removing IFU block and giving inputs manually.
   implementation of both the codes and comments are given appropriately.

NOTES: we gave outputs the datapath module(for our reference) 
but in general there will be no outputs
everything will be done within the pipeline

LANGUAGES USED: 
Verilog (HDL)

DIRECTORY WALKTHROUGH: 
Codes, Diagrams, Outputs

Ouputs: 
it contains the screenshots of the outputs with gtkwave diagram generated
Diagrams:
it contains the blockdiagram, modulediagrams, and detailed pdf of block diagram with modules labelled
Codes:
	Instruction_Fetch_Unit.v
	IFU_tb.v
	we need to compile both these files together to get the outputs
	note: memory_instructions.txt contains the list few set of instructions 
	that are to be used at the time of execution.While compiling ensure 
	this file is within the folder of the codes 
	the instructions we used are in datagiven.txt