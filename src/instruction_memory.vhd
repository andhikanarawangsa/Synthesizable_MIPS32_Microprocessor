-- Component : Instruction Memory (ROM)using .mif for MIPS32
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 24 November 2024
-- Description :
-- A ROM-based instruction memory module that stores 32-bit instructions
-- and outputs data based on the input address, synchronized with the clock.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.ALL;

ENTITY instruction_memory IS
    PORT (
        ADDR  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  
        clock : IN  STD_LOGIC := '1';               
        INSTR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)   
    );
END ENTITY;

ARCHITECTURE STRUCTURAL OF instruction_memory IS
    SIGNAL sub_wire0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    COMPONENT altsyncram
        GENERIC (
            init_file      : STRING;
            operation_mode : STRING;
            widthad_a      : NATURAL;
            width_a        : NATURAL
        );
        PORT (
            clock0    : IN  STD_LOGIC;
            address_a : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            q_a       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    INSTR <= sub_wire0;
    altsyncram_component : altsyncram
        GENERIC MAP (
            init_file      => "imemory.mif",
            operation_mode => "ROM",
            widthad_a      => 8,
            width_a        => 32
        )
        PORT MAP (
            clock0    => clock,
            address_a => ADDR(7 DOWNTO 0),
            q_a       => sub_wire0
        );
END ARCHITECTURE;