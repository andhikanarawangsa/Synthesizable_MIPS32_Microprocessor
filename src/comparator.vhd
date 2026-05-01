-- Component : 32-bit Comparator (Equality Checker)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A combinational comparator that compares two 32-bit input signals.
-- The output is set to '1' when both inputs are equal, and '0' otherwise.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY comparator IS
PORT (
    D_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  	
    D_2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  	
    EQ  : OUT STD_LOGIC                    		
);
END comparator;

ARCHITECTURE behavior OF comparator IS
BEGIN
    PROCESS (D_1, D_2)
    BEGIN
        IF D_1 = D_2 THEN
            EQ <= '1';
        ELSE
            EQ <= '0';
        END IF;
    END PROCESS;
END behavior;
