/*
* NAME-1: Yenumula Venkat Kumar 
* Rollno: 191CS263 
* Date of Writing: 26-03-2021
*/

/* Test bench for the InstructionFetchUnit module*/
module IF_tb ();
        /* local reg to feed to REset,CLk,JUmp,PCWRite
         * inputs of the IFU */

	reg REset,CLk,JUmp,PCWRite;
	reg  [63:0] NEwPC;
	wire [31:0] INstruction;
    wire [63:0] PCNOw,PCNExt4;
    
     /* Instantiate the DUT*/
    InstructionFetchUnit IFU(INstruction, PCNOw,PCNExt4,REset, CLk,NEwPC,JUmp,PCWRite);
    /* Stimulus
     * create and feed input combinations 
     * to the DUT */


     /*Procedural statement*/
    
    initial begin
        CLk =1;
        forever
        #5 CLk<=~CLk;
    end

    initial
    begin
      /* print input/output siganls to/from the DUT */
        $dumpfile("IFU.vcd");
        $dumpvars(0,IF_tb);
        NEwPC = 64'h0000000000000000;
        $monitor($time,". INstruction: %h , PCNExt4: %d , PCNOw: %d , REset: %d , CLk: %d ,JUmp: %d , PCWRite: %d",INstruction,PCNExt4, PCNOw,REset, CLk,JUmp,PCWRite);
        begin
            #0 REset = 1'b0; PCWRite =1'b1;  JUmp = 1'b0;
            #5 REset = 1'b0; PCWRite =1'b1;  JUmp = 1'b0;
            #5 REset = 1'b0; PCWRite =1'b1;  JUmp = 1'b0;
            #5 REset = 1'b0; PCWRite =1'b1;  JUmp = 1'b0;
            #5 REset = 1'b0; PCWRite =1'b1;  JUmp = 1'b0;
            #5 REset = 1'b0; PCWRite =1'b1;  JUmp = 1'b0;
            #5 REset = 1'b0; PCWRite =1'b1;  JUmp = 1'b0;
            #5 REset = 1'b0; PCWRite =1'b1;  JUmp = 1'b0;
            #5 REset = 1'b0; PCWRite =1'b0;  JUmp = 1'b1;
            #5 REset = 1'b0; PCWRite =1'b0;  JUmp = 1'b1;
            #5 REset = 1'b1; PCWRite =1'b0;  JUmp = 1'b0;
            // #5 REset = 1'b0;  JUmp = 1'b0; PCWRite =1'b1;
        end
        #10 $finish;
    end

endmodule //IF_tb