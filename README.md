# mips-5-stage-pipeline-processor

# MIPS ISA Compatible 5-Stage Pipeline Processor

## Overview
This project implements a MIPS ISA compatible 5-stage pipeline processor using SystemVerilog. The processor follows the classic pipeline stages: Instruction Fetch, Instruction Decode, Execute, Memory Access, and Write Back. It supports arithmetic, logic, memory access, branch, jump, multiply, and set-less-than instructions.

## Features
- 5-stage pipelined processor architecture
- MIPS ISA compatible instruction execution
- ALU, register file, control unit, instruction memory, and data memory
- Sequential multiplier with Hi/Lo registers
- Data hazard handling with forwarding and stall logic
- Control hazard handling for branch and jump instructions
- Test programs for instruction and processor-level verification

## Technologies Used
- SystemVerilog
- Vivado
- FPGA / RTL simulation
- MIPS assembly test programs

## System Architecture
The processor is divided into five major pipeline stages:

1. Instruction Fetch
2. Instruction Decode
3. Execute
4. Memory Access
5. Write Back

Pipeline registers are used between stages to store instruction data, control signals, and intermediate results.

## My Contributions
- Designed and implemented processor RTL modules using SystemVerilog.
- Developed datapath, control logic, ALU-related integration, register file connection, and memory interface.
- Implemented pipeline hazard handling including forwarding, stalls, and branch control.
- Created test programs to verify supported MIPS instructions and processor behavior.
- Analyzed simulation waveforms to debug instruction execution and pipeline operation.

## Project Structure
```text
rtl/            Source RTL files
tb/             Testbench files
doc/            Architecture notes and diagrams
testprogram/    Test Program and HEX Files



# =================================================================
#    Ways to Store instruction into Instruction Memory
# =================================================================
 - Have to copy the HEX file path and paste into the memu.sv module

# =================================================================
#    Individual Instruction Test
# =================================================================
 - Use the funct_call.hex HEX file

# =================================================================
#    Building Block Test
# =================================================================
 - Use the building_block.hex HEX file

# =================================================================
#    Function Call Test
# =================================================================
 - Use the funct_call.hex HEX file

# =================================================================
#   Reminder
# =================================================================
 - All the program will have inserted 9 nop, to replace the 
   realtime setup provided by qtspim
