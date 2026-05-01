-- Component : Data Memory (RAM) for MIPS32
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 24 November 2024
-- Description :
-- A single-port RAM-based data memory module that supports read and write
-- operations using enable signals. Data is accessed based on the input address
-- and synchronized with the clock.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY altera_mf;
USE altera_mf.ALL;

ENTITY data_memory IS
    PORT (
        ADDR     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  
        WR_EN    : IN  STD_LOGIC;                       
        RD_EN    : IN  STD_LOGIC;                      
        clock    : IN  STD_LOGIC := '1';               

        RD_Data  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        WR_Data  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE STRUCTURAL OF data_memory IS
    COMPONENT altsyncram
        GENERIC (
            init_file      : STRING;
            operation_mode : STRING;
            widthad_a      : NATURAL;
            width_a        : NATURAL
        );
        PORT (
            wren_a    : IN  STD_LOGIC;
            rden_a    : IN  STD_LOGIC;
            clock0    : IN  STD_LOGIC;
            address_a : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            q_a       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_a    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    altsyncram_component : altsyncram
        GENERIC MAP (
            init_file      => "dmemory.mif",
            operation_mode => "SINGLE_PORT",
            widthad_a      => 8,
            width_a        => 32
        )
        PORT MAP (
            wren_a    => WR_EN,
            rden_a    => RD_EN,
            clock0    => clock,
            address_a => ADDR(7 DOWNTO 0),
            q_a       => RD_Data,
            data_a    => WR_Data
        );
END ARCHITECTURE;