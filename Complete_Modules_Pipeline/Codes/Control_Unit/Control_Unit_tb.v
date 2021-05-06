/*
* Date of Writing: 08-04-2021  
*/
module Control_Unit_tb ();
    reg [6:0] instruction6_0;
    wire Branch;  
    wire MemRead;
    wire MemToReg;
    wire [1:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;

    /* Instantiate the DUT */
    Control_Unit CUtb(instruction6_0,Branch,MemRead,ALUOp,MemToReg,MemWrite,ALUSrc,RegWrite);
    /* stimulus
     * create and feed the input combinations
     * to the DUT */
   /* Procedural statement */

    initial
    begin
        $dumpfile("Control_Unit.vcd");
        $dumpvars(0,Control_Unit_tb);
        $monitor($time,".instruction6_0 : %b, Branch : %b, MemRead : %b, MemToReg : %b, ALUOp : %b, MemWrite : %b, ALUSrc : %b, RegWrite : %b",instruction6_0,Branch,MemRead,MemToReg,ALUOp,MemWrite,ALUSrc,RegWrite);
        begin
            #5 instruction6_0 = 7'b0110011;  $display("R type");  //R type 
            #5 instruction6_0 = 7'b0010011;  $display("I type");  //I type
            #5 instruction6_0 = 7'b0000011;  $display(" lw")  ;//lw
            #5 instruction6_0 = 7'b0100011;  $display("sw")  ;//sw
            #5 instruction6_0 = 7'b1100011;  $display("beq");  //beq
        end
        #10 $finish;
    end
endmodule //Control_Unit_tb