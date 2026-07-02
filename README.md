# Synthesizable MIPS32 Microprocessor

A synthesizable **32-bit, single-cycle-style MIPS32 subset processor** written in VHDL. The design integrates instruction fetch, decode, register access, arithmetic/logic execution, branching, data-memory access, and write-back in a modular datapath.

## Architecture

The processor implements a synthesizable single-cycle MIPS32-style datapath

The Program Counter fetches instructions from Instruction Memory, while the Control Unit decodes the opcode and generates control signals for register write-back, ALU operation, memory access, branching, and jumping. The Register File supplies operands to the ALU, whose result is used for arithmetic operations or as a data-memory address.

<p align="center">
  <img src="datapath_architecture.png"
       alt="MIPS32 microprocessor datapath architecture"
       width="100%">
</p>

Key RTL modules:

| File | Purpose |
|---|---|
| `src/top_level.vhd` | Integrates the complete processor datapath and control signals |
| `src/cu.vhd` | Main instruction decoder and control-unit logic |
| `src/alu.vhd` | 32-bit add/sub ALU |
| `src/cla_32.vhd` | 32-bit carry-lookahead adder used by the ALU and PC arithmetic |
| `src/reg_file.vhd` | 32 × 32-bit register file; `$zero` remains hardwired to zero |
| `src/program_counter.vhd` | Clocked program-counter register |
| `src/instruction_memory.vhd` | ROM wrapper initialized by `imemory.mif` |
| `src/data_memory.vhd` | Single-port RAM wrapper initialized by `dmemory.mif` |
| `src/tb_top_level.vhd` | Functional testbench with clock and reset generation |

## Supported Instruction Subset

| Category | Instructions | Implemented behavior |
|---|---|---|
| R-type arithmetic | `add`, `sub` | Register-to-register addition and subtraction |
| I-type arithmetic | `addi` | Register plus sign-extended immediate |
| Conditional control flow | `beq`, `bne` | Equality and inequality branch decisions via a 32-bit comparator |
| Memory access | `lw`, `sw` | Base-plus-offset load and store |
| Unconditional control flow | `j` | Absolute jump target formed from `PC + 4` and the 26-bit instruction field |
| No operation | `nop` | Encoded as `sll $zero, $zero, 0` (`0x00000000`) |

## Verification Program

The instruction program in `src/imemory.mif` exercises the supported datapath paths listed below.

| Address | Machine code | Assembly interpretation | Verification purpose | Expected effect |
|---:|---:|---|---|---|
| `0x00` | `20100013` | `addi $s0, $zero, 19` | Immediate arithmetic | `$s0 = 19` |
| `0x04` | `20110015` | `addi $s1, $zero, 21` | Immediate arithmetic | `$s1 = 21` |
| `0x08` | `16530008` | `bne $s2, $s3, +8` | Branch decode and comparator path | Not taken because both registers initialize to `0`; sequential execution continues |
| `0x0C` | `00000000` | `nop` | No-operation encoding | No architectural state change |
| `0x10` | `02119822` | `sub $s3, $s0, $s1` | R-type subtraction | `$s3 = 19 - 21 = -2` (`0xFFFFFFFE`) |
| `0x14` | `22730000` | `addi $s3, $s3, 0` | I-type add path using a non-zero source register | `$s3` remains `-2` |
| `0x18` | `22140004` | `addi $s4, $s0, 4` | Effective-address generation | `$s4 = 23` (`0x00000017`) |
| `0x1C` | `AE910000` | `sw $s1, 0($s4)` | Store path | Stores `21` at the address held by `$s4` |
| `0x20` | `8E950000` | `lw $s5, 0($s4)` | Load and write-back path | `$s5 = 21` |
| `0x24` | `02A50020` | `add $zero, $s5, $a1` | R-type addition datapath | ALU evaluates the addition, but the destination is `$zero`, so no register state is modified |
| `0x28` | `08000000` | `j 0x00000000` | Jump target and PC redirection | Restarts the test program |
| `0x2C` | `00000000` | `nop` | Branch-target placeholder | Reached only when the `bne` condition is true |

## Functional Timing Result

![Top-Level Functional Timing Waveform](results/top_level_timing.png)

In this timing simulation, when a shorter period was used, the observed processor output became inconsistent; therefore, the timing result shows that **25 MHz as the simulation-validated operating frequency**.

The waveform shows the expected activation of the `bne`, memory-write, memory-read/write-back, and jump control paths. It also shows the program counter progressing through the instruction sequence before returning to address `0x00000000` after the jump instruction.

### Requirements

- Intel Quartus Prime, or another VHDL/FPGA toolchain compatible with Intel/Altera `altsyncram`
- ModelSim-Intel FPGA Edition or an equivalently configured simulator
- Access to the `altera_mf` simulation library
