-- Component : Control Unit (MIPS32)
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 4 December 2024
-- Description :
-- A main control unit for a MIPS32 processor that generates control
-- signals based on opcode and function fields. It controls ALU,
-- memory, register file, branching, and jump operations.

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL; 
 
ENTITY cu IS  
	PORT  ( 
		OP_In : IN STD_LOGIC_VECTOR (5 DOWNTO 0); 
		FUNCT_In : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		Sig_Jmp : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); 
		Sig_Bne : OUT STD_LOGIC; 
		Sig_Branch : OUT STD_LOGIC; 
		Sig_MemtoReg : OUT STD_LOGIC; 
		Sig_MemRead : OUT STD_LOGIC; 
		Sig_MemWrite : OUT STD_LOGIC; 
		Sig_RegDest : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); 
		Sig_RegWrite : OUT STD_LOGIC; 
		Sig_ALUSrc : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); 
		Sig_ALUCtrl : OUT STD_LOGIC_VECTOR (1 DOWNTO 0) 
	); 
END cu; 

ARCHITECTURE behavior OF cu IS
BEGIN
    Process (OP_IN, FUNCT_In)
	Begin 
		IF (OP_IN = "000000") THEN -- Rtype
			Sig_RegDest <= "01";
			Sig_RegWrite <= '1';
			Sig_ALUSrc <= "00";
			Sig_MemWrite <= '0';
			Sig_Jmp <= "00"; 
			Sig_Bne <= '0'; 
			Sig_Branch <= '0'; 
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
			IF (FUNCT_In = "100000") THEN -- add
				Sig_ALUCtrl <= "00";
			ELSIF (FUNCT_In = "100010") THEN -- sub
				Sig_ALUCtrl <= "01";
			ELSE 
				Sig_MemWrite <= '0';
				Sig_RegDest <= "00";
				Sig_RegWrite <= '0';
				Sig_ALUSrc <= "00";
				Sig_ALUCtrl <= "00";
				Sig_Jmp <= "00"; 
				Sig_Bne <= '0'; 
				Sig_Branch <= '0'; 
				Sig_MemtoReg <= '0';
				Sig_MemRead <= '0';
			END IF;
		ELSIF (OP_IN = "000100") THEN --beq
			Sig_Branch <= '1';
			Sig_MemWrite <= '0';
			Sig_RegWrite <= '0';
			Sig_Jmp <= "00"; 
			Sig_Bne <= '0';  
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
		ELSIF (OP_IN = "000101") THEN --bne
			Sig_Bne <= '1';
			Sig_MemWrite <= '0';
			Sig_RegWrite <= '0';
			Sig_Jmp <= "00"; 
			Sig_Branch <= '0'; 
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
		ELSIF (OP_IN = "001000") THEN --addi
			Sig_MemWrite <= '0';
			Sig_RegDest <= "00";
			Sig_RegWrite <= '1';
			Sig_ALUSrc <= "01";
			Sig_ALUCtrl <= "00";
			Sig_Jmp <= "00"; 
			Sig_Bne <= '0'; 
			Sig_Branch <= '0'; 
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
		ELSIF (OP_IN = "100011") THEN --Load Word
			Sig_MemWrite <= '0';
			Sig_RegDest <= "00";
			Sig_RegWrite <= '1';
			Sig_ALUSrc <= "01";
			Sig_ALUCtrl <= "00";
			Sig_Jmp <= "00"; 
			Sig_Bne <= '0'; 
			Sig_Branch <= '0'; 
			Sig_MemtoReg <= '1';
			Sig_MemRead <= '1';
		ELSIF (OP_IN = "101011") THEN --Store Word
			Sig_MemWrite <= '1';
			Sig_RegDest <= "00";
			Sig_RegWrite <= '0';
			Sig_ALUSrc <= "01";
			Sig_ALUCtrl <= "00";
			Sig_Jmp <= "00"; 
			Sig_Bne <= '0'; 
			Sig_Branch <= '0'; 
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
		ELSIF (OP_IN = "000010") THEN --jump
			Sig_MemWrite <= '0';
			Sig_RegWrite <= '0';
			Sig_Jmp <= "01"; 
			Sig_Bne <= '0'; 
			Sig_Branch <= '0'; 
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
		ELSE
			Sig_MemWrite <= '0';
			Sig_RegDest <= "00";
			Sig_RegWrite <= '0';
			Sig_ALUSrc <= "00";
			Sig_ALUCtrl <= "00";
			Sig_Jmp <= "00"; 
			Sig_Bne <= '0'; 
			Sig_Branch <= '0'; 
			Sig_MemtoReg <= '0';
			Sig_MemRead <= '0';
		END IF;
	END PROCESS;
END behavior; 