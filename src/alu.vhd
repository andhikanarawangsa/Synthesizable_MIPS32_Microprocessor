-- Component : 32-bit Arithmetic Logic Unit (ALU)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A 32-bit ALU supporting addition and subtraction operations.
-- Uses a custom CLA adder and operation select control.

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

ENTITY ALU IS 
	PORT  ( 
		OPRND_1  : IN std_logic_vector (31 DOWNTO 0); 
		OPRND_2  : IN std_logic_vector (31 DOWNTO 0); 
		OP_SEL   : IN std_logic_vector (1 DOWNTO 0);  
		RESULT   : OUT std_logic_vector (31 DOWNTO 0)
	); 
END ALU; 

ARCHITECTURE behavior OF ALU IS
	COMPONENT cla_32
		PORT ( 
			OPRND_1 : IN std_logic_vector(31 DOWNTO 0);
			OPRND_2 : IN std_logic_vector(31 DOWNTO 0);
			C_IN    : IN std_logic;
			RESULT  : OUT std_logic_vector(31 DOWNTO 0);
			C_OUT   : OUT std_logic
		);
	END COMPONENT;

	SIGNAL twoscomplement : std_logic_vector(31 DOWNTO 0);
	SIGNAL cla_in2        : std_logic_vector(31 DOWNTO 0);

BEGIN
	add_ins : cla_32
		PORT MAP (
			OPRND_1 => OPRND_1,
			OPRND_2 => cla_in2,
			C_IN    => '0',
			RESULT  => RESULT,
			C_OUT   => OPEN
		);

	PROCESS (OPRND_1, OPRND_2, OP_SEL)
	BEGIN
		twoscomplement <= std_logic_vector(unsigned(not OPRND_2) + 1);
		IF (OP_SEL = "00") then
			cla_in2 <= OPRND_2;          -- ADD
		ELSIF (OP_SEL = "01") then
			cla_in2 <= twoscomplement;   -- SUB
		ELSE
			cla_in2 <= (others => '0');
		END IF;
	END PROCESS;
END behavior;