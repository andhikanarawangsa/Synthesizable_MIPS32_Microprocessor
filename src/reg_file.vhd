-- Component : Register File for MIPS32
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 24 November 2024
-- Description :
-- A 32x32-bit register file module with two read ports and one write port.
-- Supports simultaneous read operations and synchronous write with clock.
-- Register 0 is hardwired to zero and cannot be modified.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg_file IS
    PORT (
        clock      : IN STD_LOGIC;                         -- Clock signal
        WR_EN      : IN STD_LOGIC;                         -- Write enable signal
        ADDR_1     : IN STD_LOGIC_VECTOR (4 DOWNTO 0);     -- Address for read 1
        ADDR_2     : IN STD_LOGIC_VECTOR (4 DOWNTO 0);     -- Address for read 2
        ADDR_3     : IN STD_LOGIC_VECTOR (4 DOWNTO 0);     -- Address for write
        WR_Data_3  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);    -- Data to write
        RD_Data_1  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);   -- Data from read 1
        RD_Data_2  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)    -- Data from read 2
    );
END ENTITY;

ARCHITECTURE behavior OF reg_file IS
    TYPE ramtype IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR (31 DOWNTO 0); -- Memory array
    SIGNAL mem : ramtype := (OTHERS => (OTHERS => '0'));                   -- Initialize all to 0
BEGIN
    PROCESS(clock)
    BEGIN
        -- Read process (falling edge)
        IF (clock'EVENT AND clock = '0') THEN
            -- Read data from memory based on ADDR_1 and ADDR_2
            RD_Data_1 <= mem(CONV_INTEGER(ADDR_1));
            RD_Data_2 <= mem(CONV_INTEGER(ADDR_2));
        END IF;

        -- Write process (rising edge)
        IF (clock'EVENT AND clock = '1') THEN
            -- Register 0 always holds 0
            mem(0) <= (OTHERS => '0');

        -- Write data if WR_EN is active and ADDR_3 is not 0
        IF (WR_EN = '1' AND CONV_INTEGER(ADDR_3) /= 0) THEN
                mem(CONV_INTEGER(ADDR_3)) <= WR_Data_3;
        END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;