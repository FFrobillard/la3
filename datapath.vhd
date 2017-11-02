--================ alu.vhd =================================
-- ELE-343 Conception des systèmes ordinés
-- HIV 2017, Ecole de technologie supérieure
-- Chakib Tadj, Yves Blaquiere
--
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;


ENTITY datapath IS
	PORT (  clk   : IN std_logic;
		reset : IN std_logic;
		mem_to_reg : IN std_logic;
		PC_Src : IN std_logic;
		Alu_Src : IN std_logic;
		Reg_Dst :IN std_logic;
		Reg_Write : IN std_logic;
		Jump : IN std_logic;
		Alu_control :IN std_logic_vector(3 downto 0);
 		Zero : OUT std_logic;
		PC :  OUT std_logic_vector(31 downto 0);
		Instruction : IN std_logic_vector(31 downto 0);
		Alu_Result : OUT std_logic_vector(31 downto 0);
		Write_Data  : OUT std_logic_vector(31 downto 0);
		Read_Data   : IN std_logic_vector(31 downto 0));
		
		  
END datapath; 

ARCHITECTURE datapath_arc OF datapath IS

	SIGNAL PC_Plus4 : std_logic_vector(31 downto 0);
	SIGNAL PC_Branch : std_logic_vector(31 downto 0);
	SIGNAL PC_Jump : std_logic_vector(31 downto 0);
	SIGNAL PC_sig : std_logic_vector(31 downto 0);
	SIGNAL Sign_Imm_Sh : std_logic_vector(31 downto 0);
	SIGNAL PC_Nextbr : std_logic_vector(31 downto 0);
	SIGNAL PC_Next : std_logic_vector(31 downto 0);
	-- des signaux a placer
	SIGNAL Sign_Imm : std_logic_vector(31 downto 0);
	SIGNAL WriteReg : std_logic_vector(4 downto 0);
	SIGNAL Result : std_logic_vector(31 downto 0);
	SIGNAL ScrA : std_logic_vector(31 downto 0);
	SIGNAL ScrB : std_logic_vector(31 downto 0);
	SIGNAL rd_sig : std_logic_vector(31 downto 0);

	SIGNAL c_out      : std_logic; -- non utilise

BEGIN

	PC_Plus4 <= PC_sig(31 downto 28) + "0100";
	PC_Branch <= PC_Plus4 + Sign_Imm_Sh;
	
	PC_Jump(1 downto 0) <= "00";		--deux dernier bits de PC_Jump sont 00
	PC_Jump(27 downto 2) <= Instruction(25 downto 0); -- instruction 0-25 sont decales a gauche 2 fois
	PC_Jump(31 downto 28) <= PC_Plus4(3 downto 0); -- concatenation de PC_Plus4 
	
	PROCESS (clk, reset) -- bascule synchrone D avec reset pour PC
	BEGIN 
		IF reset = '0' THEN
		PC_sig <= (others=>'0');
		ELSIF rising_edge (clk) THEN
		PC_sig <= PC_Next;
		END IF;
		PC <= PC_sig;
	END PROCESS;
	
	Sign_Imm_Sh (31 downto 2) <= Sign_Imm (29 downto 0); --decale de 2 bits vers la gauche. 
	Sign_Imm(15 downto 0) <= Instruction(15 downto 0);  -- copie les 14 premiers bits dans Sign_Imm
	
	signImm : FOR i IN 0 TO 16 GENERATE		
	Sign_Imm(15+i) <= Instruction(15);	-- copie le 15eme bit de l'instruction dans les 16 bits restant de Sign_Imm 
	
	END GENERATE;
	
	PC_Nextbr <= PC_Branch WHEN PC_Src = '1' ELSE PC_Plus4;
	
	PC_Next   <= PC_Jump   WHEN Jump = '1' ELSE PC_Branch;

	--connection des signaux pour le Banc de Registres
	--appel de la fonction RegFile
	
	WriteReg   <= Instruction(15 downto 11)  WHEN Reg_Dst = '1' ELSE Instruction(20 downto 16);

	banc_registre : ENTITY work.RegFile(RegFile_arch)
	PORT MAP (clk, Instruction(25 downto 21), Instruction(20 downto 16), WriteReg, 
		  Result, ScrA, rd_sig); 

	ScrB   <= Sign_Imm   WHEN Alu_Src = '1' ELSE rd_sig;

	Result <= Read_Data   WHEN mem_to_reg = '1' ELSE Alu_Result;

	ual : ENTITY work.ual(ual_arc)
	PORT MAP (SrcA, SrcB, Alu_control, c_out, Alu_Result, Zero); 
	

END datapath_arc;