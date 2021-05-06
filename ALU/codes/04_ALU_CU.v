/*
* Date of Writing: 13-03-2021  
*/

/*MODULE FOR ALU CU STRUCTURAL IMPLEMENTATION*/
module ALU_CU(operation,fun6,AluOp);
   
    // I/O port declarations
    input [5:0] fun6;
    input [1:0] AluOp;
    output [3:0] operation;

    // assign operation[3] = 0;
    // 2 wires
    wire w1,w2;
    OR or2(w1,fun6[3],fun6[0]);

    AND and2(operation[0],w1,AluOp[1]);
    OR or4(operation[1],~fun6[2],~AluOp[1]);

    AND and4(w2,fun6[1],AluOp[1]);
    OR or3(operation[2],w2,AluOp[0]);

    AND and5(operation[3],AluOp[0],~AluOp[0]);

endmodule //ALU_CU