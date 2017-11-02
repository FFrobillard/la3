
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY MIPS IS
	PORT (Instruction, Data : IN std_logic_vector(31 downto 0);
		  Reset, Clock : IN std_logic;
		  Result, PC, Rd2 : OUT std_logic_vector(31 downto 0);
		  MemWrite, MemRead: OUT std_logic );
end MIPS;

ARCHITECTURE MIPS_arc OF MIPS IS

SIGNAL Bit_ctl : std_logic;

Component Controller is
	
    PORT (OP, Funct: IN std_logic_vector(5 downto 0);
		  Zero : IN std_logic;
		  MemtoReg, MemWrite, MemRead: OUT std_logic;
		  PCSrc, AluSrc : OUT std_logic;
		  RegDst, RegWrite : OUT std_logic;
		  Jump : OUT std_logic;
		  AluControl : OUT std_logic_vector(3 downto 0)
		  );
		  
end component;

Component DataPath is
	
	PORT (ReadData, Instruction : IN std_logic_vector(31 DOWNTO 0);
		  AluControl : IN std_logic_vector(3 DOWNTO 0);
		  Clk, Reset, MemtoReg, PCSrc : IN std_logic;
		  AluSrc, RegDst, RegWrite, Jump : IN std_logic;
		  Zero : OUT std_logic;
		  PC, AluResult, WriteData : OUT std_logic_vector(31 DOWNTO 0)
		  );
end component;

BEGIN

To_datapath : ENTITY DataPath
	PORT MAP ( 




END MIPS_arc;
