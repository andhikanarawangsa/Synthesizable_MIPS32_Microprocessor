-- Component : 16-bit to 32-bit Sign Extender
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- Extends a 16-bit input into a 32-bit value using sign extension.
-- Preserves the sign bit for signed arithmetic operations.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY sign_extender IS
    PORT (
        D_IN  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);  -- input 16-bit
        D_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)   -- output 32-bit
    );
END sign_extender;

ARCHITECTURE BEHAVIOR OF sign_extender IS
BEGIN

    PROCESS (D_IN)
    BEGIN
        -- sign extension
        IF (D_IN(15) = '0') THEN
            D_OUT <= (15 DOWNTO 0 => '0') & D_IN;
        ELSE
            D_OUT <= (15 DOWNTO 0 => '1') & D_IN;
        END IF;
    END PROCESS;

END BEHAVIOR;