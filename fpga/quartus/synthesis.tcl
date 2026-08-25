cd [file dirname [info script]]

package require ::quartus::project
package require ::quartus::flow

set proj "rv-diios"
set rev  "top"

if {[project_exists $proj]} {
    project_open $proj -revision $rev
} else {
    project_new $proj -revision $rev
}

set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name IP_FILE pll.ip
set_global_assignment -name SYSTEMVERILOG_FILE top.sv
set_global_assignment -name SYSTEMVERILOG_FILE configure.sv
set_global_assignment -name SYSTEMVERILOG_FILE sdram.sv
set_global_assignment -name SYSTEMVERILOG_FILE tim.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/constants.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/functions.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/wires.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/bit_alu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/btac.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/alu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/agu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/bcu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/lsu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/csr_alu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/mul.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/div.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/compress.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/base.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/register.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/csr.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/buffer.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/hazard.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/forwarding.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/fetch_stage.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/decode_stage.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/issue_stage.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/execute_stage.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/memory_stage.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/writeback_stage.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/arbiter.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/bridge.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/bus.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/cdc.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/clint.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/cpu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/rom.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/spi.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/uart_rx.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/uart_tx.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../../verilog/rtl/soc.sv
set_global_assignment -name SDC_FILE top.sdc

set_global_assignment -name FAMILY "Agilex 3"
set_global_assignment -name DEVICE A3CZ135BB18AE7S
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
set_global_assignment -name DEVICE_FILTER_PACKAGE VPBGA


#============================================================
# CLOCK
#============================================================
set_instance_assignment -name IO_STANDARD "1.2-V" -to CLOCK0_50
set_location_assignment PIN_K43  -to CLOCK0_50

#============================================================
# KEY
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to KEY[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to KEY[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to KEY[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to KEY[3]
set_location_assignment PIN_K26  -to KEY[0]
set_location_assignment PIN_K27  -to KEY[1]
set_location_assignment PIN_BK10 -to KEY[2]
set_location_assignment PIN_W12  -to KEY[3]

#============================================================
# LED
#============================================================
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[0]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[1]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[2]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[3]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[4]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[5]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[6]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[7]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[8]
set_instance_assignment -name IO_STANDARD "1.2-V" -to LEDR[9]
set_location_assignment PIN_B39  -to LEDR[0]
set_location_assignment PIN_B42  -to LEDR[1]
set_location_assignment PIN_K35  -to LEDR[2]
set_location_assignment PIN_F32  -to LEDR[3]
set_location_assignment PIN_A19  -to LEDR[4]
set_location_assignment PIN_B24  -to LEDR[5]
set_location_assignment PIN_A24  -to LEDR[6]
set_location_assignment PIN_A44  -to LEDR[7]
set_location_assignment PIN_B34  -to LEDR[8]
set_location_assignment PIN_D40  -to LEDR[9]

#============================================================
# SDRAM
#============================================================
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_CLK
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_CKE
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[0]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[1]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[2]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[3]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[4]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[5]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[6]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[7]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[8]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[9]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[10]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[11]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_ADDR[12]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_BA[0]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_BA[1]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[0]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[1]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[2]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[3]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[4]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[5]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[6]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[7]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[8]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[9]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[10]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[11]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[12]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[13]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[14]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[15]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[16]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[17]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[18]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[19]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[20]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[21]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[22]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[23]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[24]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[25]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[26]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[27]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[28]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[29]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[30]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQ[31]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_CS_n
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_WE_n
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_CAS_n
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_RAS_n
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQM[0]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQM[1]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQM[2]
set_instance_assignment -name IO_STANDARD "1.8-V LVCMOS" -to DRAM_DQM[3]
set_location_assignment PIN_BK32 -to DRAM_CLK
set_location_assignment PIN_BH40 -to DRAM_CKE
set_location_assignment PIN_BN26 -to DRAM_ADDR[0]
set_location_assignment PIN_BH27 -to DRAM_ADDR[1]
set_location_assignment PIN_BM26 -to DRAM_ADDR[2]
set_location_assignment PIN_BH18 -to DRAM_ADDR[3]
set_location_assignment PIN_BH26 -to DRAM_ADDR[4]
set_location_assignment PIN_BK18 -to DRAM_ADDR[5]
set_location_assignment PIN_BH21 -to DRAM_ADDR[6]
set_location_assignment PIN_BH32 -to DRAM_ADDR[7]
set_location_assignment PIN_BK26 -to DRAM_ADDR[8]
set_location_assignment PIN_BH35 -to DRAM_ADDR[9]
set_location_assignment PIN_BN27 -to DRAM_ADDR[10]
set_location_assignment PIN_BN29 -to DRAM_ADDR[11]
set_location_assignment PIN_BM24 -to DRAM_ADDR[12]
set_location_assignment PIN_BH43 -to DRAM_BA[0]
set_location_assignment PIN_BM29 -to DRAM_BA[1]
set_location_assignment PIN_BM51 -to DRAM_DQ[0]
set_location_assignment PIN_BM50 -to DRAM_DQ[1]
set_location_assignment PIN_BK50 -to DRAM_DQ[2]
set_location_assignment PIN_BN47 -to DRAM_DQ[3]
set_location_assignment PIN_BM47 -to DRAM_DQ[4]
set_location_assignment PIN_BH50 -to DRAM_DQ[5]
set_location_assignment PIN_BL51 -to DRAM_DQ[6]
set_location_assignment PIN_BH46 -to DRAM_DQ[7]
set_location_assignment PIN_BN37 -to DRAM_DQ[8]
set_location_assignment PIN_BM37 -to DRAM_DQ[9]
set_location_assignment PIN_BN39 -to DRAM_DQ[10]
set_location_assignment PIN_BM44 -to DRAM_DQ[11]
set_location_assignment PIN_BM42 -to DRAM_DQ[12]
set_location_assignment PIN_BM45 -to DRAM_DQ[13]
set_location_assignment PIN_BN42 -to DRAM_DQ[14]
set_location_assignment PIN_BN45 -to DRAM_DQ[15]
set_location_assignment PIN_BM9  -to DRAM_DQ[16]
set_location_assignment PIN_BC1  -to DRAM_DQ[17]
set_location_assignment PIN_BN5  -to DRAM_DQ[18]
set_location_assignment PIN_BJ1  -to DRAM_DQ[19]
set_location_assignment PIN_BJ2  -to DRAM_DQ[20]
set_location_assignment PIN_BG2  -to DRAM_DQ[21]
set_location_assignment PIN_BC2  -to DRAM_DQ[22]
set_location_assignment PIN_BG1  -to DRAM_DQ[23]
set_location_assignment PIN_BN8  -to DRAM_DQ[24]
set_location_assignment PIN_BN11 -to DRAM_DQ[25]
set_location_assignment PIN_BM8  -to DRAM_DQ[26]
set_location_assignment PIN_BM14 -to DRAM_DQ[27]
set_location_assignment PIN_BM11 -to DRAM_DQ[28]
set_location_assignment PIN_BN16 -to DRAM_DQ[29]
set_location_assignment PIN_BN14 -to DRAM_DQ[30]
set_location_assignment PIN_BM19 -to DRAM_DQ[31]
set_location_assignment PIN_BN34 -to DRAM_CS_n
set_location_assignment PIN_BM34 -to DRAM_WE_n
set_location_assignment PIN_BK40 -to DRAM_CAS_n
set_location_assignment PIN_BM31 -to DRAM_RAS_n
set_location_assignment PIN_BE4  -to DRAM_DQM[0]
set_location_assignment PIN_BA2  -to DRAM_DQM[1]
set_location_assignment PIN_BE6  -to DRAM_DQM[2]
set_location_assignment PIN_BD1  -to DRAM_DQM[3]

#============================================================
# UART
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to FPGA_UART_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to FPGA_UART_RX
set_location_assignment PIN_J1   -to FPGA_UART_TX
set_location_assignment PIN_BH10 -to FPGA_UART_RX

if {[catch {execute_flow -compile} err]} {
    post_message -type error "Compile failed: $err"
    project_close
    qexit -error
}

project_close
qexit -success