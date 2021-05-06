/*
* Date of Writing: 07-04-2021  
*/

/*BEHAVIOURAL CODE FOR IMPLEMENTATION OF CONTROL UNIT*/
module Control_Unit (instruction6_0,Branch,MemRead,ALUOp,MemToReg,MemWrite,ALUSrc,RegWrite);
    
    /*I/O DECLARATIONS*/
    input [6:0] instruction6_0;
    output Branch;  
    output MemRead;
    output MemToReg;
    output [1:0] ALUOp;
    output MemWrite;
    output ALUSrc;
    output RegWrite;
    
    /*BEHAVIOURS*/
    assign ALUSrc   = ~instruction6_0[6] & ~instruction6_0[5] | ~instruction6_0[6] & ~instruction6_0[4];
    assign RegWrite = ~instruction6_0[6] & ~instruction6_0[5] | ~instruction6_0[6] &  instruction6_0[4];
    assign MemWrite = ~instruction6_0[6] &  instruction6_0[5] | ~instruction6_0[6] &  instruction6_0[4];
    // assign MemWrite = ~instruction6_0[6];
    assign MemRead  = ~instruction6_0[6] & ~instruction6_0[5] & ~instruction6_0[4];
    assign Branch   =  instruction6_0[6] &  instruction6_0[5] & ~instruction6_0[4];

    assign ALUOp[1] = ~instruction6_0[6] &  instruction6_0[4];
    assign ALUOp[0] =  instruction6_0[6] &  instruction6_0[5] & ~instruction6_0[4];
    // assign MemtoReg = ~instruction6_0[6] &  instruction6_0[4] |  instruction6_0[6] &  instruction6_0[5] & ~instruction6_0[4];
    assign MemToReg = (~instruction6_0[6] & instruction6_0[4] | instruction6_0[6] & instruction6_0[5] & ~instruction6_0[4]);     
    // assign MemToReg = ~instruction6_0[6] & instruction6_0[4];     
    

endmodule //Control_Unit