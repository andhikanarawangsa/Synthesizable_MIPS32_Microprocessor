-- Component : 32-bit Carry Lookahead Adder (CLA)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A 32-bit carry lookahead adder that performs fast binary addition
-- using generate and propagate logic. Outputs sum and carry out.

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 
 
ENTITY cla_32 IS 
	PORT ( 
		OPRND_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
		OPRND_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);  
		C_IN : IN  STD_LOGIC;     					  
		RESULT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);  
		C_OUT : OUT STD_LOGIC       				  
	); 
END cla_32; 

ARCHITECTURE behavior OF cla_32 IS
    SIGNAL Gen : STD_LOGIC_VECTOR (31 DOWNTO 0);  
    SIGNAL Pro : STD_LOGIC_VECTOR (31 DOWNTO 0);  
    SIGNAL Car : STD_LOGIC_VECTOR (31 DOWNTO 0);  

BEGIN
    GEN_PROP: FOR i IN 0 TO 31 GENERATE 
        Gen(i) <= OPRND_1(i) AND OPRND_2(i);
        Pro(i) <= OPRND_1(i) OR OPRND_2(i);
    END GENERATE;

    Car(0) <= C_IN; 

    CARRY_CALC: FOR i IN 1 TO 31 GENERATE
        Car(i) <= Gen(i-1) OR (Pro(i-1) AND Car(i-1));
    END GENERATE;

    SUM_PROC: FOR i IN 0 TO 31 GENERATE
        RESULT(i) <= OPRND_1(i) XOR OPRND_2(i) XOR Car(i);
    END GENERATE;

    C_OUT <= Car(31);
END behavior; 