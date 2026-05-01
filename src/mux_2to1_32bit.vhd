-- Component : 2-to-1 Multiplexer (32-bit)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A 2-to-1 multiplexer that selects one of two 32-bit input signals
-- based on the selector input. When S = '0', output follows D1;
-- when S = '1', output follows D2.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_2to1_32bit IS
    PORT (
        D1 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        D2 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

        Y  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        S  : IN  STD_LOGIC
    );
END ENTITY;

ARCHITECTURE BEHAVIOR OF mux_2to1_32bit IS
BEGIN
    PROCESS (D1, D2, S)
    BEGIN
        IF S = '0' THEN
            Y <= D1;
        ELSE
            Y <= D2;
        END IF;
    END PROCESS;
END ARCHITECTURE;
