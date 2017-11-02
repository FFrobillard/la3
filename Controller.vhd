--================ alu.vhd =================================
-- ELE-343 Conception des systèmes ordinés
-- HIV 2017, Ecole de technologie supérieure
-- Chakib Tadj, Yves Blaquiere
-- =============================================================
-- Description: 
--
-- Auteur:
--	Johan Solorzano chavez
--	Francois Robillard
--Date:
--	18-10-2017
-- =============================================================



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY Controller IS
	PORT (OP, Funct: IN std_logic_vector(5 downto 0);
		  Zero : IN std_logic;
		  MemtoReg, MemWrite, MemRead: OUT std_logic;
		  PCSrc, AluSrc : OUT std_logic;
		  RegDst, RegWrite : OUT std_logic;
		  Jump : OUT std_logic;
		  AluControl : OUT std_logic_vector(3 downto 0));
end Controller;

ARCHITECTURE controller_arc OF Controller IS

SIGNAL OpType 	:std_logic_vector(9 DOWNTO 0);
SIGNAL Branch	:std_logic;
SIGNAL ALUOp 	:std_logic_vector(1 DOWNTO 0);

BEGIN

--Assgnation des code d'instructions
RegWrite <= OpType(9);
RegDst <= OpType(8);
AluSrc <= OpType(7);
Branch <= OpType(6);
MemRead <= OpType(5);
MemWrite <= OpType(4);
MemtoReg <= OpType(3);
ALUOp <= OpType(2 DOWNTO 1);
Jump <= OpType(0);

-- Assgnation des operation pour ALU
AluControl <= "0010" WHEN ALUOp = "00" ELSE "1111"; -- v
AluControl <= "0110" WHEN ALUOp = "01" ELSE "1111";
	

-- Process pour generer les signaux des commande	
Main_decoder : Process (OP)

BEGIN

		CASE OP IS
		WHEN "000000"  => OpType <= X"304"; -- R-Type
		WHEN "100011"  => OpType <= X"2A8"; -- Lw
		WHEN "101011"  => OpType <= X"090"; -- Sw
		WHEN "000100"  => OpType <= X"042"; -- BEQ
		WHEN "001000"  => OpType <= X"280"; -- Addi
		WHEN "000010"  => OpType <= X"001"; -- Jump
		WHEN OTHERS    => OpType <= X"000"; -- Nothing
	END CASE;
	
END process Main_decoder;


-- Process pour generer le signal AluControl
Alu_decoder : Process (ALUOp, Funct) 

BEGIN

IF ALUOp = "10" THEN
	Case Funct IS
		WHEN "100000"  => AluControl <= "0010"; -- Add
		WHEN "100010"  => AluControl <= "0110"; -- Sub
		WHEN "100100"  => AluControl <= "0000"; -- And
		WHEN "100101"  => AluControl <= "0001"; -- Or
		WHEN "101010"  => AluControl <= "0111"; -- Slt
		WHEN OTHERS    => AluControl <= "1111"; -- Nothing
	END CASE;
		
END IF;

END process Alu_decoder;


END controller_arc;