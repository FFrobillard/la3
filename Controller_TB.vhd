--================ ual_tb.vhd =================================
-- ELE-340 Conception des syst?mes ordin?s
-- ETE 2007, Ecole de technologie sup?rieure
-- Chakib Tadj, Yves Blaqui?re
-- =============================================================
-- Description: 
--   


-- vsim -gui work.UAL_tb(fichiersTexte) -do "add wave -unsigned -r *;run 500"
-- =============================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
USE WORK.txt_util.ALL;


ENTITY controller_tb IS
  GENERIC (TAILLE : integer := 32);
END controller_tb;

ARCHITECTURE controller_tb_arc OF controller_tb IS
  SIGNAL OP, Funct: std_logic_vector (5 DOWNTO 0);
  SIGNAL zero       : std_logic;  
  
  CONSTANT PERIODE  : time := 20 ns; -- periode d'injection des vecteurs

BEGIN  -- de l'architecture ual_tb_arch
  


------------------------------------------------------------------
  
-- process (#1) pour l'esthetique. On peut s'en passer!
  PROCESS(UALControl)   
  BEGIN
    CASE UALControl IS  -- Plus agreable pour le fichier de sortie!
      WHEN X"0"   => OpType <= "AND"; -- Operation ET logique
      WHEN X"1"   => OpType <= "OR "; -- Operation OU logique
      WHEN X"2"   => OpType <= "ADD"; -- Operation ADD logique
      WHEN X"6"   => OpType <= "SUB"; -- Operation SUB logique
      WHEN X"7"   => OpType <= "SLT"; -- Operation ET logique
      WHEN OTHERS => OpType <= "---"; -- Illegal
    END CASE;
  END PROCESS;


------------------------------------------------------------------
-- process (#2) principal de test 
    
  fichiersTexte : PROCESS

    -- Fichiers d'entr?es/sorties
    FILE fichierIn  : text OPEN read_mode IS "Control_IN.txt";
    FILE fichierOut : text OPEN write_mode IS "Control_OUT.txt";

    -- Variables pour lecture et ?criture dans les fichiers textes
    VARIABLE ligneEntree, ligneSortie : line;
    VARIABLE good                     : boolean;
    VARIABLE entete                   : boolean := true;
    VARIABLE discard                  : string(1 to 10);  
	 	--Variables local pour la simulation
  VARIABLE s_SrcA, s_SrcB : std_logic_vector (TAILLE-1 DOWNTO 0);
  VARIABLE s_UALControl : std_logic_vector (3 DOWNTO 0);
  VARIABLE s_c_out      : std_logic;
  VARIABLE s_result     : std_logic_vector (TAILLE-1 DOWNTO 0);
  VARIABLE s_zero       : std_logic;
  --VARIABLE OpType       : string(1 TO 3);
  VARIABLE clock        : std_logic; 
	
  BEGIN
  
  SrcA <= (others=>'0');
  SrcB <= (others=>'0');
  
  WAIT FOR PERIODE; -- attendre un periode
  
  IF entete THEN  -- ecrire les lignes d'ent?te dans le fichier de sortie
      write(ligneSortie, string'(" ALU SrcA SrcB Result Zero Resultat_UAL Zero_UAL | Commentaire:"));
      writeline(fichierOut, ligneSortie);

      entete := false;
    END IF;
		
    IF NOT(endfile(fichierIn)) THEN  	-- fin du fichier?
	
      -- Lire une ligne du fichier d'entr?es
      readline(fichierIn, ligneEntree);
      -- Analyse la ligne d'entr?e et extraire chaque element
      hread(ligneEntree, s_UALControl, good);  -- Lire l'operande a sur la ligne d'entree
      ASSERT good REPORT "Type d'operation" SEVERITY error;
      hread(ligneEntree, s_SrcA, good);  -- Lire l'operande b sur la ligne d'entree
      ASSERT good REPORT "no SrcA" SEVERITY error;
      hread(ligneEntree, s_SrcB, good);  -- Lire la somme attendue sur la ligne d'entree
      ASSERT good REPORT "no SrcB" SEVERITY error;
	  hread(ligneEntree, s_result, good);  -- Lire la somme attendue sur la ligne d'entree
      ASSERT good REPORT "no result" SEVERITY error;
	  read(ligneEntree, s_zero, good);  -- Lire la somme attendue sur la ligne d'entree
      ASSERT good REPORT "no zero" SEVERITY error;
      --read(ligneEntree, discard, good);  -- Lire le commentaire
     
    END IF;
	
	--Assignation des variables lues 
	UALControl <= s_UALControl;
	SrcA <= s_SrcA;
	SrcB <= s_SrcB;
	
	
	WAIT FOR PERIODE; 
	

    -- Ecrit les entr?es/sorties  dans le fichier de sortie
    write(ligneSortie, OpType, right, 0);   
	write(ligneSortie, s_SrcA, right, 1);	
    write(ligneSortie, s_SrcB, right, 9);              
    write(ligneSortie, s_result, right, 9);      
    write(ligneSortie, s_zero, right, 2);  
	write(ligneSortie, Result_UAL, right, 9);     
    write(ligneSortie, zero_UAL, right, 2); 
    write(ligneSortie, string'(" |"));
	
	--	Resultat des comparaisons
    IF(result = result_UAL) THEN
      write(ligneSortie, string'(" Succes")); 
	  ELSE
	  write(ligneSortie, string'(" Echec"));
    END IF;
    
    writeline(fichierOut, ligneSortie);
    
  END PROCESS fichiersTexte;

  verificateur : PROCESS
  BEGIN
  
    WAIT ON SrcA,SrcB;
	
    ASSERT (result = result_UAL)     -- V?rification du résultat
      REPORT "ERREUR: Résultat = " & str(to_integer(unsigned(result))) &
      " differente de Somme calcul?e = " & str(to_integer(unsigned(result_UAL))) &
      " au temps " & time'image(now)
      SEVERITY error;
    
  END PROCESS verificateur;
  
  
END ual_tb_arc;  --fin de larchitecture
