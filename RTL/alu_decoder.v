// alu_decoder.v - logic for ALU decoder

module alu_decoder (
    input            Op5,
    input [2:0]      funct3,
    input [6:0]       funct7,
    input [1:0]      ALUOp,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000;             // addition
		  
        2'b01: ALUControl = 4'b0001;             // subtraction
		  
        2'b10: 
                         //***Normal R-type***//
				
            case (funct3) // R-type or I-type ALU
                3'b000: begin
                    // True for R-type subtract
                    if   (funct7==0010100 && Op5==1) ALUControl = 4'b0001; //sub
                    else ALUControl = 4'b0000; // add, addi
                end
                3'b001:  ALUControl = 4'b0100; //sll, slli
                3'b010:  ALUControl = 4'b0101; // slt, slti
                3'b011:  ALUControl = 4'b0101; // sltu, sltiu (doubtful)
                3'b100:  ALUControl = 4'b0110; // xor, xori
                3'b101: begin
                    if (funct7==7'b0010100) ALUControl = 4'b1000; // sra, srai
                    else ALUControl = 4'b0111;          // srl, srli
                end
                3'b110:  ALUControl = 4'b0011; // or, ori
                3'b111:  ALUControl = 4'b0010; // and, andi
                default: ALUControl = 4'bxxxx; // ???
            endcase
				
				
		  2'b11:
			                  //***M-extension (R-type)***//
									
			   case (funct3)
			 	    3'b000: ALUControl = 4'b1001; //mul
				    3'b001: ALUControl = 4'b1010; //mulh
					 3'b010: ALUControl = 4'b1011; //mulsu
				    3'b011: ALUControl = 4'b1100; //mulu
					 3'b100: ALUControl = 4'b1101; //div 
				    3'b101: ALUControl = 4'b1110; //divu
					 3'b110: ALUControl = 4'b1111; //rem
				    default:ALUControl = 4'bxxxx; // ???
		      endcase
			
	
    endcase
end

endmodule
