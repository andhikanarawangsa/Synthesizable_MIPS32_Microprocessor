-- Component : Left Shift 32-bit (<< 2)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A combinational shifter that shifts a 32-bit input left by 2 bits.
-- Used for word alignment in branch/jump address calculation.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY lshift_32_32 IS
    PORT (
        D_IN  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        D_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE BEHAVIOR OF lshift_32_32 IS
BEGIN
    PROCESS (D_IN)
    BEGIN
        D_OUT <= D_IN(29 DOWNTO 0) & "00";
    END PROCESS;
END ARCHITECTURE;