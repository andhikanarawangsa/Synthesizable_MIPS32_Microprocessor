-- Component : Program Counter (32-bit)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A 32-bit program counter register that updates its output value
-- on the rising edge of the clock. The module stores the next instruction
-- address (PC_in) and outputs it as the current program counter (PC_out).

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY program_counter IS
    PORT (
        clk     : IN  STD_LOGIC;
        PC_in   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE BEHAVIOR OF program_counter IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            PC_out <= PC_in;
        END IF;
    END PROCESS;
END ARCHITECTURE;