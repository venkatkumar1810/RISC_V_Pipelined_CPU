/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 12-03-2021  
*/

/*MODULE FOR THE ZERO_CHECK BEHAVIOURAL*/
module Zero_check(out,in);
    //I/O port declaration 
    parameter N = 64; 
    input [N-1:0] in;
    output out;

    // No net
   
    // behavioral 
    assign out = in ? 0:1;
endmodule //ALU_tb

/*MODULE FOR SET LESS THAN CHECK STRUCTURAL*/
module SLT(out0,in0,coutt,overfg);
    // I/O port declaration
    input in0;
    input overfg;
    input coutt;

    // local wire
    wire w_1;
    output wire out0;
    
    // Behavioural 
    xor_behavioural xor_gate(w_1,in0,overfg);
    xor_behavioural xor_gate2(out0,w_1,coutt);
endmodule //SLT

/*MODULE FOR OVERLFOW CHECK BEHAVIOURAL*/
module Overflow(flag,a,b,bin,cin,cout,sumout);
    
    //I/O port declaration
    input a,b,bin,cout,cin,sumout;
    output flag;

    // No net    

    // Behavioural
    assign flag = (cin!=cout)?1:0;

endmodule //OVERFLOW

/* Testbench for the ALU module */
module ALU_tb ();

   /* local reg to feed 
   * inputs of the ALU)tb */
    parameter N = 64;
    reg [N-1:0]A,B;
    reg alu_carry_in;
    reg [3:0] Operation;
    wire [N-1:0]alu_out;
    wire alu_carry_out;
    
    /* Instantiate the DUT */
    ALU_params alu(alu_out,alu_carry_out,A,B,alu_carry_in,Operation);

    wire zerO_check,slT,over_flag;
    Zero_check Zc(zero_check,alu_out);
    
    Overflow overFlag(over_flag,A[N-1],B[N-1],Operation[2],alu_carry_in,alu_carry_out,alu_out[N-1]);

    SLT Slt(slT,alu_out[N-1],~alu_carry_out,over_flag);

    
    /*stimulus
    * create and feed input combinations
    * to the DUT */
    
    /* procedural statement */
     
    initial   // execute only once
    begin
        $dumpfile("ALU.vcd");
        $dumpvars(0,ALU_tb);

        /* print input\output signals to\form the DUT */
        $monitor($time,". alu_out: %b, Zero_check: %b, Overflow: %b\tA: %b, B: %b, Operation: %b.",alu_out,zero_check,over_flag,A,B,Operation);

        begin
            // 4'b0000 :assign alu_out = and1; // AND A.B
            #5 A=$random; B = $random; Operation=4'b0000;        // delay for 5 t_units
            // 4'b0001 :assign alu_out = or1;  //OR
            #5 A=$random; B = $random; Operation=4'b0001;
            // 4'b0010 :assign alu_out = sum;  //ADD
            #5 assign alu_carry_in = 0; A=$random; B = $random; Operation=4'b0010;
            // 4'b0110 :assign alu_out = sum;  //SUB
            #5 assign alu_carry_in = 1; A=$random; B = $random; Operation=4'b0110;  
            // 4'b1101 :assign alu_out = or1;  //NAND
            #5 A=$random; B = $random; Operation=4'b1101;
            // 4'b1100 :assign alu_out = and1; //NOR
            #5 A=$random; B = $random; Operation=4'b1100;
            // 4'b0111 :assign alu_out = sum;  //SLT
            #5 assign alu_carry_in = 1; A=$random; B = $random; Operation=4'b0111; 
            #5 $display("\t\t      Set_less_than: %b",slT);
            #5 assign alu_carry_in = 1; A=64'b1100; B = 64'b1101; Operation=4'b0111; 
            #5 $display("\t\t      Set_less_than: %b",slT);


        end
        #10 $finish;    
    end


endmodule //ALU_tb