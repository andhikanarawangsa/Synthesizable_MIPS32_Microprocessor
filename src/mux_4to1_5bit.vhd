-- Component : 4-to-1 Multiplexer (5-bit)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A 4-to-1 multiplexer that selects one of four 5-bit input signals
-- based on a 2-bit selector input. The selected input is routed to
-- the output according to the selector value.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_4to1_5bit IS
    PORT (
        D1 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        D2 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        D3 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        D4 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);

        Y  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        S  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE BEHAVIOR OF mux_4to1_5bit IS
BEGIN
    PROCESS (D1, D2, D3, D4, S)
    BEGIN
        CASE S IS
            WHEN "00" =>
                Y <= D1;
            WHEN "01" =>
                Y <= D2;
            WHEN "10" =>
                Y <= D3;
            WHEN "11" =>
                Y <= D4;
            WHEN OTHERS =>
                Y <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END ARCHITECTURE;
