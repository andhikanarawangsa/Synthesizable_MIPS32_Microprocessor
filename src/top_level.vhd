-- Component : Top Level MIPS32 Single-Cycle Processor
-- Author    : Andhika Narawangsa Susilo
-- GitHub    : https://github.com/andhikanarawangsa
-- Created   : 18 December 2024
-- Description :
-- A top-level integration module of a single-cycle MIPS32 processor that
-- connects instruction memory, data memory, register file, ALU, control unit,
-- and supporting datapath components. It handles instruction fetch, decode,
-- execute, memory access, and write-back operations synchronized with the clock.
-- The design supports R-type, I-type, branch, load/store, and jump instructions.

LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.numeric_std.ALL; 

ENTITY top_level IS 
PORT ( 
	CLK			: IN std_logic ;                       
	reset  		: IN std_logic;
  
	ALU_OUT       : OUT std_logic_vector(31 DOWNTO 0);
	PC_IN         : OUT std_logic_vector(31 DOWNTO 0);
	PC_OUT        : OUT std_logic_vector(31 DOWNTO 0);
	
	cu_jmp        : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
	cu_bne        : OUT STD_LOGIC;
	cu_branch     : OUT STD_LOGIC;
	cu_memtoreg   : OUT STD_LOGIC;
	cu_memread    : OUT STD_LOGIC;
	cu_memwrite   : OUT STD_LOGIC;
	cu_regdest    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
	cu_regwrite   : OUT STD_LOGIC;
	cu_alusrc     : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
	cu_aluctrl    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);  
	
	REG_OUT_1     : OUT std_logic_vector(31 DOWNTO 0);
	REG_OUT_2     : OUT std_logic_vector(31 DOWNTO 0);
	INSTRUCTION   : OUT std_logic_vector(31 DOWNTO 0)                      
 ); 
END top_level;

ARCHITECTURE behavioral OF top_level IS 
 
component instruction_memory
PORT ( 
	ADDR   : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    clock  : IN STD_LOGIC := '1';
    INSTR  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);
END component;

component data_memory
PORT (
	ADDR  	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	WR_EN 	: IN STD_LOGIC;
	RD_EN 	: IN STD_LOGIC;
	clock  	: IN STD_LOGIC := '1';
	RD_Data : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);   
	WR_Data : IN STD_LOGIC_VECTOR (31 DOWNTO 0)    
);  
END component;

component reg_file  
PORT (
	clock       : IN STD_LOGIC;
	WR_EN       : IN STD_LOGIC;
	ADDR_1      : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	ADDR_2      : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	ADDR_3      : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	WR_Data_3   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	RD_Data_1   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	RD_Data_2   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
); 
END component; 

component mux_2to1_32bit 
PORT ( 
	D1 : IN std_logic_vector (31 DOWNTO 0);
	D2 : IN std_logic_vector (31 DOWNTO 0);
	Y  : OUT std_logic_vector (31 DOWNTO 0);
	S  : IN std_logic
); 
END component;

component mux_4to1_32bit  
PORT ( 
	D1 : IN std_logic_vector (31 DOWNTO 0);   
	D2 : IN std_logic_vector (31 DOWNTO 0); 
	D3 : IN std_logic_vector (31 DOWNTO 0);  
	D4 : IN std_logic_vector (31 DOWNTO 0);   
	Y  : OUT std_logic_vector (31 DOWNTO 0); 
	S  : IN std_logic_vector (1 DOWNTO 0)  
); 
END component;

component mux_4to1_5bit  
PORT ( 
D1 : IN std_logic_vector (4 DOWNTO 0); -- Data Input 1  
D2 : IN std_logic_vector (4 DOWNTO 0); -- Data Input 2  
D3 : IN std_logic_vector (4 DOWNTO 0); -- Data Input 3  
D4 : IN std_logic_vector (4 DOWNTO 0); -- Data Input 4  
Y  : OUT std_logic_vector (4 DOWNTO 0); -- Selected Data 
S  : IN std_logic_vector (1 DOWNTO 0) -- Selector 
); 
END component;

component comparator  
PORT ( 
	D_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);  
	D_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);  
	EQ 	: OUT STD_LOGIC  
); 
END component;

component bus_merger  
PORT ( 
	DATA_IN1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
	DATA_IN2 : IN STD_LOGIC_VECTOR (27 DOWNTO 0); 
	DATA_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) 
); 
END component;

component program_counter  
PORT ( 
	clk : IN STD_LOGIC; 
	PC_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 
	PC_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) 
); 
END component; 

component lshift_32_32  
PORT ( 
	D_IN 	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);  
	D_OUT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0) 
); 
END component;

component lshift_26_28  
PORT ( 
	D_IN 	: IN STD_LOGIC_VECTOR (25 DOWNTO 0);  
	D_OUT 	: OUT STD_LOGIC_VECTOR (27 DOWNTO 0) 
); 
END component;

component cla_32  
PORT (
	OPRND_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);   
	OPRND_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);  
	C_IN 	: IN STD_LOGIC;     
	RESULT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);  
	C_OUT 	: OUT STD_LOGIC     
); 
END component; 

component sign_extender  
PORT ( 
	D_In 	: IN std_logic_vector (15 DOWNTO 0); 
	D_Out 	: OUT std_logic_vector (31 DOWNTO 0)  
); 
END component;

component ALU  
PORT ( 
	OPRND_1 : IN std_logic_vector (31 DOWNTO 0); 
	OPRND_2 : IN std_logic_vector (31 DOWNTO 0); 
	OP_SEL 	: IN std_logic_vector (1 DOWNTO 0);  
	RESULT 	: OUT  std_logic_vector (31 DOWNTO 0)  
); 
END component;  

component cu  
PORT ( 
	OP_In 			: IN STD_LOGIC_VECTOR (5 DOWNTO 0); 
	FUNCT_In 		: IN STD_LOGIC_VECTOR (5 DOWNTO 0); 
	Sig_Jmp 		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0); 
	Sig_Bne 		: OUT STD_LOGIC; 
	Sig_Branch 		: OUT STD_LOGIC; 
	Sig_MemtoReg 	: OUT STD_LOGIC; 
	Sig_MemRead 	: OUT STD_LOGIC; 
	Sig_MemWrite 	: OUT STD_LOGIC; 
	Sig_RegDest 	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0); 
	Sig_RegWrite 	: OUT STD_LOGIC; 
	Sig_ALUSrc 		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0); 
	Sig_ALUCtrl 	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0) 
); 
END component; 


SIGNAL instr_mem_instr 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL data_mem_rd_data	: STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL reg_file_rd_data1: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL reg_file_rd_data2: STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL mux_2to1_y      	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mux2_2to1_y      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mux3_2to1_y      : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mux_4to1_y      	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mux2_4to1_y      : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL pcout          	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL comp_eq         	: STD_LOGIC;
SIGNAL cu_sig_jmp      	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL cu_sig_bne      	: STD_LOGIC;
SIGNAL cu_sig_branch   	: STD_LOGIC;
SIGNAL cu_sig_memtoreg 	: STD_LOGIC;
SIGNAL cu_sig_memread  	: STD_LOGIC;
SIGNAL cu_sig_memwrite 	: STD_LOGIC;
SIGNAL cu_sig_regdest  	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL cu_sig_regwrite 	: STD_LOGIC;
SIGNAL cu_sig_alusrc   	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL cu_sig_aluctrl  	: STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL alu_result  		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL sign_ext_out 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL bus_merge_out 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL lshift_32_out 	: STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL cla_result  		: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL cla_c_in    		: STD_LOGIC;
SIGNAL cla_c_out   		: STD_LOGIC;

SIGNAL cla2_result  	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL cla2_c_in    	: STD_LOGIC;
SIGNAL cla2_c_out   	: STD_LOGIC;

SIGNAL mux_4to1_5bit_y  : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL smux_2to1_32bit 	: STD_LOGIC;
SIGNAL lshift_26_out 	: STD_LOGIC_VECTOR(27 DOWNTO 0);

BEGIN
smux_2to1_32bit <= ((NOT(comp_eq) AND cu_sig_bne) OR (comp_eq AND cu_sig_branch));

lshift_26_28_inst : lshift_26_28
PORT MAP (
	D_IN  => instr_mem_instr(25 downto 0),
    D_OUT => lshift_26_out
);

mux_4to1_inst : mux_4to1_32bit
PORT MAP (
	D1 => reg_file_rd_data2,
    D2 => sign_ext_out,
    D3 => "00000000000000000000000000000000",
    D4 => "00000000000000000000000000000000",
    S  => cu_sig_alusrc,
    Y  => mux_4to1_y
    );
    
mux_4to1_inst2 : mux_4to1_32bit
PORT MAP (
    D1 => mux_2to1_y,
    D2 => bus_merge_out,
    D3 => "00000000000000000000000000000000",
    D4 => "00000000000000000000000000000000",
    S  => cu_sig_jmp,
    Y  => mux2_4to1_y
);

cla_inst : cla_32
PORT MAP (
    OPRND_1 => pcout,
    OPRND_2 => "00000000000000000000000000000100",
    C_IN    => cla_c_in,
    RESULT  => cla_result,
    C_OUT   => cla_c_out
);

cla_inst2 : cla_32
PORT MAP (
    OPRND_1 => lshift_32_out,
    OPRND_2 => cla_result,
    C_IN    => cla2_c_in,
    RESULT  => cla2_result,
    C_OUT   => cla2_c_out
);

lshift_32_inst : lshift_32_32
PORT MAP (
    D_IN  => sign_ext_out,
    D_OUT => lshift_32_out
);

bus_merger_inst : bus_merger
PORT MAP (
    DATA_IN1 => cla_result(31 downto 28),
    DATA_IN2 => lshift_26_out,
    DATA_OUT => bus_merge_out
);

sign_ext_inst : sign_extender
PORT MAP (
    D_In  => instr_mem_instr(15 downto 0),
    D_Out => sign_ext_out
);

alu_inst : ALU
PORT MAP (
    OPRND_1 => reg_file_rd_data1,
    OPRND_2 => mux_4to1_y,
    OP_SEL  => cu_sig_aluctrl,
    RESULT  => alu_result
);

cu_inst : cu
PORT MAP (
    OP_In        => instr_mem_instr (31 downto 26),
    FUNCT_In     => instr_mem_instr (5 downto 0),
    Sig_Jmp      => cu_sig_jmp,
    Sig_Bne      => cu_sig_bne,
    Sig_Branch   => cu_sig_branch,
    Sig_MemtoReg => cu_sig_memtoreg,
    Sig_MemRead  => cu_sig_memread,
    Sig_MemWrite => cu_sig_memwrite,
    Sig_RegDest  => cu_sig_regdest,
    Sig_RegWrite => cu_sig_regwrite,
    Sig_ALUSrc   => cu_sig_alusrc,
    Sig_ALUCtrl  => cu_sig_aluctrl
);

comp_inst : comparator
PORT MAP (
    D_1 => reg_file_rd_data1,
    D_2 => reg_file_rd_data2,
    EQ  => comp_eq
);

pc_inst : program_counter
PORT MAP (
    clk    => CLK,
    PC_in  => mux2_2to1_y,
    PC_out => pcout
);

mux_2to1_inst : mux_2to1_32bit
PORT MAP (
    D1 => cla_result,
    D2 => cla2_result,
    S  => smux_2to1_32bit,
    Y  => mux_2to1_y
);

mux_2to1_inst2 : mux_2to1_32bit
PORT MAP (
    D1 => mux2_4to1_y,
    D2 => "00000000000000000000000000000000",
    S  => reset,
    Y  => mux2_2to1_y
);

mux_2to1_inst3 : mux_2to1_32bit
PORT MAP (
    D1 => alu_result,
    D2 => data_mem_rd_data,
    S  => cu_sig_memtoreg,
    Y  => mux3_2to1_y
);

reg_file_inst : reg_file
PORT MAP (
    clock      => CLK,
    WR_EN      => cu_sig_regwrite,
    ADDR_1     => instr_mem_instr (25 downto 21),
    ADDR_2     => instr_mem_instr (20 downto 16),
    ADDR_3     => mux_4to1_5bit_y,
    WR_Data_3  => mux3_2to1_y,
    RD_Data_1  => reg_file_rd_data1,
    RD_Data_2  => reg_file_rd_data2
);

data_mem_inst : data_memory
PORT MAP (
    ADDR    => alu_result,
    WR_EN   => cu_sig_memwrite,
    RD_EN   => cu_sig_memread,
    clock   => CLK,
    RD_Data => data_mem_rd_data,
    WR_Data => reg_file_rd_data2
);

instr_mem_inst : instruction_memory
PORT MAP (
    ADDR  => pcout,
    clock => CLK,
    INSTR => instr_mem_instr
);

mux_4to1_5bit_inst : mux_4to1_5bit
PORT MAP (
    D1 => instr_mem_instr(20 downto 16),
    D2 => instr_mem_instr(15 downto 11),
    D3 => "00000",
    D4 => "00000",
    S  => cu_sig_regdest,
    Y  => mux_4to1_5bit_y
);

ALU_OUT      	<= alu_result;
PC_IN        	<= mux2_2to1_y;
PC_OUT       	<= pcout;
cu_jmp      	<= cu_sig_jmp;
cu_bne      	<= cu_sig_bne;
cu_branch  	 	<= cu_sig_branch;
cu_memtoreg 	<= cu_sig_memtoreg;
cu_memread  	<= cu_sig_memread;
cu_memwrite 	<= cu_sig_memwrite;
cu_regdest  	<= cu_sig_regdest;
cu_regwrite 	<= cu_sig_regwrite;
cu_alusrc   	<= cu_sig_alusrc;
cu_aluctrl  	<= cu_sig_aluctrl;
REG_OUT_1    	<= reg_file_rd_data1;
REG_OUT_2    	<= reg_file_rd_data2;
INSTRUCTION		<= instr_mem_instr;

END behavioral;