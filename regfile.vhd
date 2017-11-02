--========================= regfile.vhd ============================
-- ELE-343 Conception des systèmes ordinés
-- hiver 2017, Ecole de technologie supérieure
-- Auteur: Yves Blaquiere
-- =============================================================
-- 1 cycle
-- ==============================================================
-- Description: Banc de registres realise avec une memoire a:
--              * un port d'ecriture (we, wd, wa) synchrone
--              * 2 ports de lecture combinatoire (ra1,ra2,rd1,rd2)
-- =============================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegFile IS  -- Fichier de registres a 3 ports (2 lecture, 1 ecriture)
  PORT (clk          : IN  std_logic;
        we           : IN  std_logic;
        ra1, ra2, wa : IN  std_logic_vector(4 DOWNTO 0);  -- adresses de lecture
        wd           : IN  std_logic_vector(31 DOWNTO 0);  -- donnee d'ecriture
        rd1, rd2     : OUT std_logic_vector(31 DOWNTO 0));  -- donnees de lecture
END;

ARCHITECTURE RegFile_arch OF RegFile IS
  TYPE RamType IS ARRAY (31 DOWNTO 1) OF std_logic_vector(31 DOWNTO 0);
  SIGNAL mem : RamType;
BEGIN

--Fichier de registres à trois ports
--    Deux ports de lecture, combinatoire
--    Un port d'écriture synchrone

  PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF we = '1' THEN
        mem(to_integer(unsigned(wa))) <= wd;
      END IF;
    END IF;
  END PROCESS;

  PROCESS (ra1, ra2, mem)
  BEGIN
    IF (to_integer(unsigned((ra1))) = 0) THEN
      rd1 <= (OTHERS => '0');           --reg 0 contient 0
    ELSE
      rd1 <= mem(to_integer(unsigned(ra1)));
    END IF;

    IF (to_integer(unsigned((ra2))) = 0) THEN
      rd2 <= (OTHERS => '0');           --reg 0 contient 0
    ELSE
      rd2 <= mem(to_integer(unsigned(ra2)));
    END IF;
  END PROCESS;
END RegFile_arch;
