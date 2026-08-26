package constants;
  timeunit 1ns; timeprecision 1ps;

  localparam [31:0] nop_instr = 32'h00000013;

  localparam [15:0] cnop_instr = 16'h0001;

  localparam [1:0] u_mode = 2'b00;
  localparam [1:0] m_mode = 2'b11;

  localparam [6:0] opcode_lui       = 7'b0110111;
  localparam [6:0] opcode_auipc     = 7'b0010111;
  localparam [6:0] opcode_jal       = 7'b1101111;
  localparam [6:0] opcode_jalr      = 7'b1100111;
  localparam [6:0] opcode_branch    = 7'b1100011;
  localparam [6:0] opcode_load      = 7'b0000011;
  localparam [6:0] opcode_store     = 7'b0100011;
  localparam [6:0] opcode_immediate = 7'b0010011;
  localparam [6:0] opcode_register  = 7'b0110011;
  localparam [6:0] opcode_fence     = 7'b0001111;
  localparam [6:0] opcode_system    = 7'b1110011;
  localparam [6:0] opcode_fp        = 7'b1010011;
  localparam [6:0] opcode_fload     = 7'b0000111;
  localparam [6:0] opcode_fstore    = 7'b0100111;
  localparam [6:0] opcode_fmadd     = 7'b1000011;
  localparam [6:0] opcode_fmsub     = 7'b1000111;
  localparam [6:0] opcode_fnmsub    = 7'b1001011;
  localparam [6:0] opcode_fnmadd    = 7'b1001111;

  localparam [2:0] funct_add  = 3'b000;
  localparam [2:0] funct_sll  = 3'b001;
  localparam [2:0] funct_slt  = 3'b010;
  localparam [2:0] funct_sltu = 3'b011;
  localparam [2:0] funct_xor  = 3'b100;
  localparam [2:0] funct_srl  = 3'b101;
  localparam [2:0] funct_or   = 3'b110;
  localparam [2:0] funct_and  = 3'b111;

  localparam [2:0] funct_bclr = 3'b001;
  localparam [2:0] funct_bext = 3'b101;
  localparam [2:0] funct_binv = 3'b001;
  localparam [2:0] funct_bset = 3'b001;

  localparam [2:0] funct_min  = 3'b100;
  localparam [2:0] funct_minu = 3'b101;
  localparam [2:0] funct_max  = 3'b110;
  localparam [2:0] funct_maxu = 3'b111;

  localparam [2:0] funct_rol = 3'b001;
  localparam [2:0] funct_ror = 3'b101;

  localparam [2:0] funct_sh1add = 3'b010;
  localparam [2:0] funct_sh2add = 3'b100;
  localparam [2:0] funct_sh3add = 3'b110;

  localparam [2:0] funct_zexth = 3'b100;

  localparam [2:0] funct_mul    = 3'b000;
  localparam [2:0] funct_mulh   = 3'b001;
  localparam [2:0] funct_mulhsu = 3'b010;
  localparam [2:0] funct_mulhu  = 3'b011;
  localparam [2:0] funct_div    = 3'b100;
  localparam [2:0] funct_divu   = 3'b101;
  localparam [2:0] funct_rem    = 3'b110;
  localparam [2:0] funct_remu   = 3'b111;

  localparam [2:0] funct_beq  = 3'b000;
  localparam [2:0] funct_bne  = 3'b001;
  localparam [2:0] funct_blt  = 3'b100;
  localparam [2:0] funct_bge  = 3'b101;
  localparam [2:0] funct_bltu = 3'b110;
  localparam [2:0] funct_bgeu = 3'b111;

  localparam [2:0] funct_lb  = 3'b000;
  localparam [2:0] funct_lh  = 3'b001;
  localparam [2:0] funct_lw  = 3'b010;
  localparam [2:0] funct_ld  = 3'b011;
  localparam [2:0] funct_lbu = 3'b100;
  localparam [2:0] funct_lhu = 3'b101;
  localparam [2:0] funct_lwu = 3'b110;

  localparam [2:0] funct_sb = 3'b000;
  localparam [2:0] funct_sh = 3'b001;
  localparam [2:0] funct_sw = 3'b010;
  localparam [2:0] funct_sd = 3'b011;

  localparam [2:0] funct_csrrw  = 3'b001;
  localparam [2:0] funct_csrrs  = 3'b010;
  localparam [2:0] funct_csrrc  = 3'b011;
  localparam [2:0] funct_csrrwi = 3'b101;
  localparam [2:0] funct_csrrsi = 3'b110;
  localparam [2:0] funct_csrrci = 3'b111;

  localparam [4:0] funct_fadd      = 5'b00000;
  localparam [4:0] funct_fsub      = 5'b00001;
  localparam [4:0] funct_fmul      = 5'b00010;
  localparam [4:0] funct_fdiv      = 5'b00011;
  localparam [4:0] funct_fsqrt     = 5'b01011;
  localparam [4:0] funct_fsgnj     = 5'b00100;
  localparam [4:0] funct_fminmax   = 5'b00101;
  localparam [4:0] funct_fcomp     = 5'b10100;
  localparam [4:0] funct_fclass    = 5'b11100;
  localparam [4:0] funct_fmv_f2i   = 5'b11100;
  localparam [4:0] funct_fmv_i2f   = 5'b11110;
  localparam [4:0] funct_fconv     = 5'b01000;
  localparam [4:0] funct_fconv_f2i = 5'b11000;
  localparam [4:0] funct_fconv_i2f = 5'b11010;
  localparam [4:0] funct_fconv_f2f = 5'b01000;

  localparam [2:0] c0_addispn = 3'b000;
  localparam [2:0] c0_fld     = 3'b001;
  localparam [2:0] c0_lw      = 3'b010;
  localparam [2:0] c0_flw     = 3'b011;
  localparam [2:0] c0_sw      = 3'b110;
  localparam [2:0] c0_fsd     = 3'b101;
  localparam [2:0] c0_fsw     = 3'b111;

  localparam [2:0] c1_addi = 3'b000;
  localparam [2:0] c1_jal  = 3'b001;
  localparam [2:0] c1_li   = 3'b010;
  localparam [2:0] c1_lui  = 3'b011;
  localparam [2:0] c1_alu  = 3'b100;
  localparam [2:0] c1_j    = 3'b101;
  localparam [2:0] c1_beqz = 3'b110;
  localparam [2:0] c1_bnez = 3'b111;

  localparam [2:0] c2_slli  = 3'b000;
  localparam [2:0] c2_fldsp = 3'b001;
  localparam [2:0] c2_lwsp  = 3'b010;
  localparam [2:0] c2_flwsp = 3'b011;
  localparam [2:0] c2_alu   = 3'b100;
  localparam [2:0] c2_swsp  = 3'b110;
  localparam [2:0] c2_fsdsp = 3'b101;
  localparam [2:0] c2_fswsp = 3'b111;

  localparam [1:0] opcode_c0 = 2'b00;
  localparam [1:0] opcode_c1 = 2'b01;
  localparam [1:0] opcode_c2 = 2'b10;

  localparam [11:0] csr_ecall  = 12'h000;
  localparam [11:0] csr_ebreak = 12'h001;

  localparam [11:0] csr_uret = 12'h002;
  localparam [11:0] csr_sret = 12'h102;
  localparam [11:0] csr_mret = 12'h302;

  localparam [11:0] csr_wfi = 12'h105;

  localparam [11:0] csr_ustatus = 12'h000;
  localparam [11:0] csr_uie     = 12'h004;
  localparam [11:0] csr_utvec   = 12'h005;

  localparam [11:0] csr_uscratch = 12'h040;
  localparam [11:0] csr_uepc     = 12'h041;
  localparam [11:0] csr_ucause   = 12'h042;
  localparam [11:0] csr_utval    = 12'h043;
  localparam [11:0] csr_uip      = 12'h044;

  localparam [11:0] csr_fflags = 12'h001;
  localparam [11:0] csr_frm    = 12'h002;
  localparam [11:0] csr_fcsr   = 12'h003;

  localparam [11:0] csr_ucycle    = 12'hC00;
  localparam [11:0] csr_utime     = 12'hC01;
  localparam [11:0] csr_uinstret  = 12'hC02;
  localparam [11:0] csr_ucycleh   = 12'hC80;
  localparam [11:0] csr_utimeh    = 12'hC81;
  localparam [11:0] csr_uinstreth = 12'hC82;

  localparam [11:0] csr_mvendorid  = 12'hF11;
  localparam [11:0] csr_marchid    = 12'hF12;
  localparam [11:0] csr_mimpid     = 12'hF13;
  localparam [11:0] csr_mhartid    = 12'hF14;
  localparam [11:0] csr_mstatus    = 12'h300;
  localparam [11:0] csr_misa       = 12'h301;
  localparam [11:0] csr_medeleg    = 12'h302;
  localparam [11:0] csr_mideleg    = 12'h303;
  localparam [11:0] csr_mie        = 12'h304;
  localparam [11:0] csr_mtvec      = 12'h305;
  localparam [11:0] csr_mcounteren = 12'h306;

  localparam [11:0] csr_mscratch = 12'h340;
  localparam [11:0] csr_mepc     = 12'h341;
  localparam [11:0] csr_mcause   = 12'h342;
  localparam [11:0] csr_mtval    = 12'h343;
  localparam [11:0] csr_mip      = 12'h344;

  localparam [11:0] csr_pmpcfg0   = 12'h3A0;
  localparam [11:0] csr_pmpcfg1   = 12'h3A1;
  localparam [11:0] csr_pmpcfg2   = 12'h3A2;
  localparam [11:0] csr_pmpcfg3   = 12'h3A3;
  localparam [11:0] csr_pmpaddr0  = 12'h3B0;
  localparam [11:0] csr_pmpaddr1  = 12'h3B1;
  localparam [11:0] csr_pmpaddr2  = 12'h3B2;
  localparam [11:0] csr_pmpaddr3  = 12'h3B3;
  localparam [11:0] csr_pmpaddr4  = 12'h3B4;
  localparam [11:0] csr_pmpaddr5  = 12'h3B5;
  localparam [11:0] csr_pmpaddr6  = 12'h3B6;
  localparam [11:0] csr_pmpaddr7  = 12'h3B7;
  localparam [11:0] csr_pmpaddr8  = 12'h3B8;
  localparam [11:0] csr_pmpaddr9  = 12'h3B9;
  localparam [11:0] csr_pmpaddr10 = 12'h3BA;
  localparam [11:0] csr_pmpaddr11 = 12'h3BB;
  localparam [11:0] csr_pmpaddr12 = 12'h3BC;
  localparam [11:0] csr_pmpaddr13 = 12'h3BD;
  localparam [11:0] csr_pmpaddr14 = 12'h3BE;
  localparam [11:0] csr_pmpaddr15 = 12'h3BF;

  localparam [11:0] csr_mcycle    = 12'hB00;
  localparam [11:0] csr_minstret  = 12'hB02;
  localparam [11:0] csr_mcycleh   = 12'hB80;
  localparam [11:0] csr_minstreth = 12'hB82;

  localparam [11:0] csr_tselect  = 12'h7A0;
  localparam [11:0] csr_tdata1   = 12'h7A1;
  localparam [11:0] csr_tdata2   = 12'h7A2;
  localparam [11:0] csr_tdata3   = 12'h7A3;
  localparam [11:0] csr_tcontrol = 12'h7A5;

  localparam [11:0] csr_dcsr     = 12'h7B0;
  localparam [11:0] csr_dpc      = 12'h7B1;
  localparam [11:0] csr_dscratch = 12'h7B2;

  localparam [0:0] interrupt = 1'b1;
  localparam [0:0] exception = 1'b0;

  localparam [7:0] interrupt_user_soft    = 8'h00;
  localparam [7:0] interrupt_super_soft   = 8'h01;
  localparam [7:0] interrupt_mach_soft    = 8'h03;
  localparam [7:0] interrupt_user_timer   = 8'h04;
  localparam [7:0] interrupt_super_timer  = 8'h05;
  localparam [7:0] interrupt_mach_timer   = 8'h07;
  localparam [7:0] interrupt_user_extern  = 8'h08;
  localparam [7:0] interrupt_super_extern = 8'h09;
  localparam [7:0] interrupt_mach_extern  = 8'h0B;

  localparam [7:0] except_instr_addr_misalign = 8'h00;
  localparam [7:0] except_instr_access_fault  = 8'h01;
  localparam [7:0] except_illegal_instruction = 8'h02;
  localparam [7:0] except_breakpoint          = 8'h03;
  localparam [7:0] except_load_addr_misalign  = 8'h04;
  localparam [7:0] except_load_access_fault   = 8'h05;
  localparam [7:0] except_store_addr_misalign = 8'h06;
  localparam [7:0] except_store_access_fault  = 8'h07;
  localparam [7:0] except_env_call_user       = 8'h08;
  localparam [7:0] except_env_call_super      = 8'h09;
  localparam [7:0] except_env_call_mach       = 8'h0B;
  localparam [7:0] except_instr_page_fault    = 8'h0C;
  localparam [7:0] except_load_page_fault     = 8'h0D;
  localparam [7:0] except_store_page_fault    = 8'h0F;

endpackage
