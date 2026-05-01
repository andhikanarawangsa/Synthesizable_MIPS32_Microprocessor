-- Component : Testbench for Top Level MIPS32 Single-Cycle Processor
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 18 December 2024
-- Description :
-- A simulation-only testbench for the top-level MIPS32 single-cycle processor.
-- This module generates clock and reset signals, instantiates the CPU design,
-- and monitors key datapath signals such as PC, instruction, ALU output,
-- register outputs, and control signals for functional verification.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_top_level IS
END tb_top_level;

ARCHITECTURE BEHAVIOR OF tb_top_level IS
    COMPONENT top_level
        PORT (
            CLK           : IN  STD_LOGIC;
            RESET         : IN  STD_LOGIC;

            ALU_OUT       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_IN         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_OUT        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            CU_JMP        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            CU_BNE        : OUT STD_LOGIC;
            CU_BRANCH     : OUT STD_LOGIC;
            CU_MEMTOREG   : OUT STD_LOGIC;
            CU_MEMREAD    : OUT STD_LOGIC;
            CU_MEMWRITE   : OUT STD_LOGIC;
            CU_REGDEST    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            CU_REGWRITE   : OUT STD_LOGIC;
            CU_ALUSRC     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            CU_ALUCTRL    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

            REG_OUT_1     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            REG_OUT_2     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            INSTRUCTION   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL CLK           : STD_LOGIC := '0';
    SIGNAL RESET         : STD_LOGIC := '1';

    SIGNAL ALU_OUT       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_IN         : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_OUT        : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL CU_JMP        : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL CU_BNE        : STD_LOGIC;
    SIGNAL CU_BRANCH     : STD_LOGIC;
    SIGNAL CU_MEMTOREG   : STD_LOGIC;
    SIGNAL CU_MEMREAD    : STD_LOGIC;
    SIGNAL CU_MEMWRITE   : STD_LOGIC;
    SIGNAL CU_REGDEST    : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL CU_REGWRITE   : STD_LOGIC;
    SIGNAL CU_ALUSRC     : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL CU_ALUCTRL    : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL REG_OUT_1     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL REG_OUT_2     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL INSTRUCTION   : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    -- DUT INSTANTIATION
    UUT : top_level
        PORT MAP (
            CLK         => CLK,
            RESET       => RESET,

            ALU_OUT     => ALU_OUT,
            PC_IN       => PC_IN,
            PC_OUT      => PC_OUT,

            CU_JMP      => CU_JMP,
            CU_BNE      => CU_BNE,
            CU_BRANCH   => CU_BRANCH,
            CU_MEMTOREG => CU_MEMTOREG,
            CU_MEMREAD  => CU_MEMREAD,
            CU_MEMWRITE => CU_MEMWRITE,
            CU_REGDEST  => CU_REGDEST,
            CU_REGWRITE => CU_REGWRITE,
            CU_ALUSRC   => CU_ALUSRC,
            CU_ALUCTRL  => CU_ALUCTRL,

            REG_OUT_1   => REG_OUT_1,
            REG_OUT_2   => REG_OUT_2,
            INSTRUCTION => INSTRUCTION
        );

    -- CLOCK GENERATOR
    CLK_PROCESS : PROCESS
    BEGIN
        WHILE TRUE LOOP
            CLK <= '0';
            WAIT FOR 5 ns;
            CLK <= '1';
            WAIT FOR 5 ns;
        END LOOP;
    END PROCESS;

    -- STIMULUS
    STIM_PROC : PROCESS
    BEGIN
        RESET <= '1';
        WAIT FOR 20 ns;
        RESET <= '0';
        WAIT FOR 500 ns;

        WAIT;
    END PROCESS;

END BEHAVIOR;