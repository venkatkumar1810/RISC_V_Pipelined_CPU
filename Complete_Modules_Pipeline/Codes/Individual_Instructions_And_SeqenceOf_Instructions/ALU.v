/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 13-03-2021
FROM THE PREVIOUS ASSIGNMENT A2
*/

module mux2_1 (out, i0, i1, s0); 
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
endmodule

module mux4_1 (result, i0, i1, i2, i3, s); 
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
endmodule

/* FULL ADDER AND SUBTRACTOR*/
module FAS(sum,carry_out,a,b,carry_in);
    input  a,b,carry_in;
    output sum, carry_out;

    assign sum = (~a & ~b & carry_in) | (~a & b & ~carry_in) | (a & ~b & ~carry_in) | (a & b & carry_in); 
    assign carry_out = (a & b) | (b & carry_in) | (carry_in & a); 
    
endmodule

module AND(and_out,input1,input2);
    input input1;
    input input2;
    output and_out;
    assign and_out = input1 & input2;
endmodule

module OR(or_out,input1,input2);
    input input1;
    input input2;
    output or_out;
    assign or_out = input1 | input2;
endmodule

module xor_behavioural(y,a,b);
    // I/o port declarations
    input a,b;
    output y;
	 
    // no net

    // behavioural 
	assign y = (~a & b) | (a & ~b);
    
endmodule

module ALU (alu_out,alu_carry_out,A,B,alu_carry_in,Operation);
    input A;
    input B;
    input alu_carry_in;
    input [3:0] Operation;
    output reg  alu_out;
    output wire  alu_carry_out;

    wire i0_1,i1_1;
    wire out1;
    assign i0_1 = A;
    assign i1_1 = ~A;
    mux2_1 m1(out1,i0_1,i1_1,Operation[3]);

    //MUX 2
    wire i0_2,i1_2;
    wire out2;
    assign i0_2 = B;
    assign i1_2 = ~B;
    mux2_1 m2(out2,i0_2,i1_2,Operation[2]);

    // AND
    wire and1,carry_outt,summ,sum_,carry_out_;
    //FAS addsub2(summ,carry_outt,out1,out2,alu_carry_in);
    //assign alu_carry_out = carry_outt;
    AND and_1(and1,out1,out2);

    wire or1;
    //FAS addsub3(sum_,carry_out_,out1,out2,alu_carry_in);
    //assign alu_carry_out = carry_out_;
    OR or_1(or1,out1,out2);

    // adder or subtractor
    wire sum, carry_out;
    FAS addsub1(sum,carry_out,out1,out2,alu_carry_in);
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
            // default: $display("Invalid control signals"); 
        endcase
    end
endmodule //ALU

/* n-bit ripple carry ALU */
module ALU_params(Alu_out,Alu_carry_out,A,B,Alu_carry_in,Operation);
    
    parameter N = 64;

    input [N-1:0] A,B;
    input Alu_carry_in;
    input [3:0] Operation;
    output [N-1:0] Alu_out;
    output Alu_carry_out;

    genvar i;

    wire [N:0] w;

    assign w[0] = Alu_carry_in;

    assign Alu_carry_out = w[N];
    // assign Setlt = set[0];
    generate for( i = 0; i< N; i=i+1)
	 //begin:
    begin: alu
        ALU alu(.alu_out(Alu_out[i]),.alu_carry_out(w[i+1]),.A(A[i]),.B(B[i]),.alu_carry_in(w[i]),.Operation(Operation));
    end
	 endgenerate
 
endmodule

module Zero_check(out,in);
    parameter N = 64; 
    input [N-1:0] in;
    output out; 
    assign out = in ? 0:1;
endmodule //ALU_tb

module SLT(out0,in0,coutt,overfg);
    input in0;
    input overfg;
    input coutt;
    wire w_1;
    output wire out0; 
    xor_behavioural xor_gate(w_1,in0,overfg);
    xor_behavioural xor_gate2(out0,w_1,coutt);
endmodule //ALU_tb

module Overflow(flag,a,b,bin,cin,cout,sumout);
    input a,b,bin,cout,cin,sumout;
    output flag;
    assign flag = (cin!=cout)?1:0;

endmodule //ALU_tb
