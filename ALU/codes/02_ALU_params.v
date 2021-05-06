/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 12-03-2021  
*/

/* n-bit ripple carry ALU */
module ALU_params(Alu_out,Alu_carry_out,A,B,Alu_carry_in,Operation);
    
    //parameter
    parameter N = 64;
    
    // I/o port declarations
    input [N-1:0] A,B;
    input Alu_carry_in;
    input [3:0] Operation;
    output [N-1:0] Alu_out;
    output Alu_carry_out;

    genvar i;

    // N local wire
    wire [N:0] w;

    // behavioural
    assign w[0] = Alu_carry_in;

    assign Alu_carry_out = w[N];
    for( i = 0; i< N; i=i+1)
    begin
        ALU alu1(.alu_out(Alu_out[i]),.alu_carry_out(w[i+1]),.A(A[i]),.B(B[i]),.alu_carry_in(w[i]),.Operation(Operation));
    end
 
endmodule   // ALU_params
