-- Component : Left Shift 26-bit to 28-bit (<< 2)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A combinational shifter that shifts a 26-bit input left by 2 bits
-- to produce a 28-bit output. Used in jump address construction.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY lshift_26_28 IS
    PORT (
        D_IN  : IN  STD_LOGIC_VECTOR(25 DOWNTO 0);
        D_OUT : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE BEHAVIOR OF lshift_26_28 IS
BEGIN
    PROCESS (D_IN)
    BEGIN
        D_OUT <= D_IN & "00";
    END PROCESS;
END ARCHITECTURE;