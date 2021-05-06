/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 12-03-2021  
*/


/* 2:1 MULTIPLEXER */
module mux2_1 (out, i0, i1, s0); 
    // I/o port declarations
    input i0, i1; 
    input s0;
    output out;
    reg out;
    always @( s0 or i0 or i1 )
        case ({ s0}) 
        1'b0 : out = i0;
        1'b1 : out = i1;
        // default: $display("Invalid control signals"); 
    endcase
endmodule  //mux2_1

/* 4:1 MULTIPLEXER */
module mux4_1 (result, i0, i1, i2, i3, s); 
    // I/o port declarations
    input i0, i1, i2, i3; 
    input [1:0] s;
    output result;
    reg result;
    always @( s[0] or s[1] or i0 or i1 or i2 or i3 )
        case ({s[1],s[0]}) 
            2'b00 : result = i0;
            2'b01 : result = i1;
            2'b10 : result = i2;
            2'b11 : result = i3;
        // default: $display("Invalid control signals"); 
    endcase
endmodule  //mux4_1

/* FULL ADDER AND SUBTRACTOR*/
module FAS(sum,carry_out,a,b,carry_in);

    // I/o port declarations
    input  a,b,carry_in;
    output sum, carry_out;
 
    // no net
     
    // behavioural 
    assign sum = (~a & ~b & carry_in) | (~a & b & ~carry_in) | (a & ~b & ~carry_in) | (a & b & carry_in); 
    assign carry_out = (a & b) | (b & carry_in) | (carry_in & a); 
    
endmodule //FAS

/*AND STRUCTURAL*/
module AND(and_out,input1,input2);

    // I/o port declarations
    input input1;
    input input2;
    output and_out;

    // no net
 
    // behavioural 
    assign and_out = input1 & input2;
    endmodule //AND

/*OR GATE STRUCTURAL*/
module OR(or_out,input1,input2);
 
    // I/o port declarations
    input input1;
    input input2;
    output or_out;
    // no net

    // behavioural 
    assign or_out = input1 | input2;
endmodule  //OR

/*XOR Behavioural*/
module xor_behavioural(y,a,b);
    // I/o port declarations
    input a,b;
    output y;
	 
    // no net

    // behavioural 
	assign y = (~a & b) | (a & ~b);
    
endmodule  //xor

/*STRUCTURAL IMPLEMENTATION OF ALU*/
module ALU (alu_out,alu_carry_out,A,B,alu_carry_in,Operation);
    // I/o port declarations
    input A;
    input B;
    input alu_carry_in;
    input [3:0] Operation;
    output reg  alu_out;
    output wire  alu_carry_out;
    output wire slt;

    wire i0_1,i1_1;
    wire out1;
    // behavioural 
    assign i0_1 = A;
    assign i1_1 = ~A;
    mux2_1 m1(out1,i0_1,i1_1,Operation[3]);

    //MUX 2
    wire i0_2,i1_2;
    wire out2;
    // behavioural    
    assign i0_2 = B;
    assign i1_2 = ~B;
    mux2_1 m2(out2,i0_2,i1_2,Operation[2]);

    // AND
    wire and1;
    // FUCNTION CALL     
    AND and_1(and1,out1,out2);

    wire or1;
    // FUCNTION CALL    
    OR or_1(or1,out1,out2);

    // adder or subtractor
    wire sum, carry_out;
    FAS addsub1(sum,carry_out,out1,out2,alu_carry_in);
    // behavioural 
    assign alu_carry_out = carry_out;

    always @(*)
    begin
        case ({Operation[3], Operation[2],Operation[1],Operation[0]}) 
            4'b0000: alu_out = and1; //AND A.B
            4'b0001: alu_out = or1;  //OR
            4'b0010: alu_out = sum;  //ADD
            4'b0110: alu_out = sum;  //SUB
            4'b1101: alu_out = or1;  //NAND
            4'b1100: alu_out = and1; //NOR
            4'b0111: alu_out = sum;  //SLT
            default: $display("Invalid control signals"); 
        endcase
    end




endmodule //ALU