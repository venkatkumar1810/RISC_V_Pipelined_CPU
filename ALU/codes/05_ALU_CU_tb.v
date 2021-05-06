/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 13-03-2021  
*/

module ALU_CU_tb();
   /* reg to feed to Fun6,ALUOp*/

    reg [5:0] Fun6;
    reg [1:0] ALUOp;
    wire [3:0] Operation;
   
    /*Instantiate the DUT*/
    ALU_CU alucu(Operation,Fun6,ALUOp);
    /*stimulus
    * create and feed input combinations
    * to the DUT */


    /*Procedural statement */
    initial
    begin
    /*print input/output signals to/from the DUT */ 
        $dumpfile("ALU_CU.vcd");
        $dumpvars(0,ALU_CU_tb);
        $monitor($time,". Operation: %b, Fun6: %b , ALUOp: %b",Operation,Fun6,ALUOp);
        begin
            /*GIVEN INPUTS BASED ON THE PPTS OF CU*/
            #5 Fun6 = 6'b000000; ALUOp = 2'b00;
            #5 Fun6 = 6'b000000; ALUOp = 2'b01;
            #5 Fun6 = 6'b000000; ALUOp = 2'b10;
            #5 Fun6 = 6'b000010; ALUOp = 2'b10;
            #5 Fun6 = 6'b000100; ALUOp = 2'b10;
            #5 Fun6 = 6'b000101; ALUOp = 2'b10;
            #5 Fun6 = 6'b001010; ALUOp = 2'b10;
        end
        #10 $finish;
    end
endmodule //ALU_CU_tb