/*******************/
/* rom8x1024_sim.v */
/*******************/

//                  +----+
//  rom_addr[11:0]->|    |->rom_data[31:0]
//                  +----+

//
// ROMの記述（論理シミュレーション用）
//

module rom8x1024_sim (rom_addr, rom_data);

  input   [11:0]  rom_addr;  // 12-bit アドレス入力ポート
  output  [31:0]  rom_data;  // 32-bit データ出力ポート

  reg     [31:0]  data;

  // Wire
  wire     [9:0]  word_addr; // 10-bit address, word

  assign word_addr = rom_addr[9:2];
   
  always @(word_addr) begin
    case (word_addr)
      10'h000: data = 32'he000000c; // 00400000: other type! opcode=56(10)
      10'h001: data = 32'h00000000; // 00400004: SLL, REG[0]<=REG[0]<<0;
      10'h002: data = 32'h00000000; // 00400008: SLL, REG[0]<=REG[0]<<0;
      10'h003: data = 32'h00000000; // 0040000c: SLL, REG[0]<=REG[0]<<0;
      10'h004: data = 32'h00000000; // 00400010: SLL, REG[0]<=REG[0]<<0;
      10'h005: data = 32'h00408090; // 00400014: R type, unknown. func=16(10)
      10'h006: data = 32'h00000000; // 00400018: SLL, REG[0]<=REG[0]<<0;
      10'h007: data = 32'h00000000; // 0040001c: SLL, REG[0]<=REG[0]<<0;
      10'h008: data = 32'h27bdfff0; // 00400020: ADDIU, REG[29]<=REG[29]+65520(=0x0000fff0);
      10'h009: data = 32'hafbe0008; // 00400024: SW, RAM[REG[29]+8]<=REG[30];
      10'h00a: data = 32'h03a0f021; // 00400028: ADDU, REG[30]<=REG[29]+REG[0];
      10'h00b: data = 32'hafc00000; // 0040002c: SW, RAM[REG[30]+0]<=REG[0];
      10'h00c: data = 32'h0810001b; // 00400030: J, PC<=0x0010001b*4(=0x0040006c);
      10'h00d: data = 32'h00000000; // 00400034: SLL, REG[0]<=REG[0]<<0;
      10'h00e: data = 32'h24020300; // 00400038: ADDIU, REG[2]<=REG[0]+768(=0x00000300);
      10'h00f: data = 32'hac400000; // 0040003c: SW, RAM[REG[2]+0]<=REG[0];
      10'h010: data = 32'h24030304; // 00400040: ADDIU, REG[3]<=REG[0]+772(=0x00000304);
      10'h011: data = 32'h8fc20000; // 00400044: LW, REG[2]<=RAM[REG[30]+0];
      10'h012: data = 32'h00000000; // 00400048: SLL, REG[0]<=REG[0]<<0;
      10'h013: data = 32'hac620000; // 0040004c: SW, RAM[REG[3]+0]<=REG[2];
      10'h014: data = 32'h24030300; // 00400050: ADDIU, REG[3]<=REG[0]+768(=0x00000300);
      10'h015: data = 32'h24020001; // 00400054: ADDIU, REG[2]<=REG[0]+1(=0x00000001);
      10'h016: data = 32'hac620000; // 00400058: SW, RAM[REG[3]+0]<=REG[2];
      10'h017: data = 32'h8fc20000; // 0040005c: LW, REG[2]<=RAM[REG[30]+0];
      10'h018: data = 32'h00000000; // 00400060: SLL, REG[0]<=REG[0]<<0;
      10'h019: data = 32'h24420001; // 00400064: ADDIU, REG[2]<=REG[2]+1(=0x00000001);
      10'h01a: data = 32'hafc20000; // 00400068: SW, RAM[REG[30]+0]<=REG[2];
      10'h01b: data = 32'h8fc20000; // 0040006c: LW, REG[2]<=RAM[REG[30]+0];
      10'h01c: data = 32'h00000000; // 00400070: SLL, REG[0]<=REG[0]<<0;
      10'h01d: data = 32'h2c42003d; // 00400074: SLTIU, REG[2]<=(REG[2]<61(=0x0000003d))?1:0;
      10'h01e: data = 32'h1440ffef; // 00400078: BNE, PC<=(REG[2] != REG[0])?PC+4+65519*4:PC+4;
      10'h01f: data = 32'h00000000; // 0040007c: SLL, REG[0]<=REG[0]<<0;
      10'h020: data = 32'h03c0e821; // 00400080: ADDU, REG[29]<=REG[30]+REG[0];
      10'h021: data = 32'h8fbe0008; // 00400084: LW, REG[30]<=RAM[REG[29]+8];
      10'h022: data = 32'h27bd0010; // 00400088: ADDIU, REG[29]<=REG[29]+16(=0x00000010);
      10'h023: data = 32'h03e00008; // 0040008c: JR, PC<=REG[31];
      10'h024: data = 32'h00000000; // 00400090: SLL, REG[0]<=REG[0]<<0;
      10'h025: data = 32'h00000000; // 00400094: SLL, REG[0]<=REG[0]<<0;
      10'h026: data = 32'h00000000; // 00400098: SLL, REG[0]<=REG[0]<<0;
      10'h027: data = 32'h00000000; // 0040009c: SLL, REG[0]<=REG[0]<<0;
    endcase
  end

  assign rom_data = data;
endmodule
