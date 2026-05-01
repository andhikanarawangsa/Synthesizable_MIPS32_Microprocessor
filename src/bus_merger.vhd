-- Component : Bus Merger (4-bit & 28-bit to 32-bit)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A combinational module that concatenates a 4-bit input and a 28-bit input
-- into a single 32-bit output bus. The 4-bit input forms the higher bits,
-- while the 28-bit input forms the lower bits of the output.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bus_merger IS
PORT (
    DATA_IN1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Input data 1 (4-bit)
    DATA_IN2 : IN STD_LOGIC_VECTOR(27 DOWNTO 0); -- Input data 2 (28-bit)
    DATA_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Output data (32-bit)
);
END bus_merger;

ARCHITECTURE behavior OF bus_merger IS
BEGIN
    PROCESS (DATA_IN1, DATA_IN2)
    BEGIN
        DATA_OUT <= DATA_IN1 & DATA_IN2;
    END PROCESS;
END behavior;
