--========================= dmem.vhd ============================
-- ELE-343 Conception des systèmes ordinés
-- hiver 2017, Ecole de technologie supérieure
-- Auteur: Yves Blaquiere
-- =============================================================
-- Description: Memoire de donnee realise avec une memoire a
--              deux ports: un port d'ecriture synchrone
--                          un port de lecture combinatoire     
-- =============================================================

LIBRARY ieee;
LIBRARY std;
USE ieee.math_real.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY dmem IS                          -- Memoire de donnees
  PORT (clk, MemWrite      : IN  std_logic;
        adresse, WriteData : IN  std_logic_vector(31 DOWNTO 0);
        ReadData           : OUT std_logic_vector(31 DOWNTO 0));
END;  -- dmem;

-- =====================================================
ARCHITECTURE dmem_arch OF dmem IS
  CONSTANT MEM_SIZE     : integer := 128; -- Nombre de mots (a ajuster en
                                          -- fonction des adresses utilises par
                                          -- le programme
  TYPE ramtype IS ARRAY (MEM_SIZE-1 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
  SIGNAL mem            : ramtype;
  -- Nombre de bits d'adresse selon le nombre de mots
  CONSTANT LOG_MEM_SIZE : integer := integer(ceil(log2(real(MEM_SIZE))));
-- =====================================================
BEGIN
  -- port d'ecriture synchrone
  PROCESS(clk) IS
  BEGIN
    IF (clk'event AND clk = '1') THEN
      --si memwrite=1, ecriture dans la memoire                   
      IF (memwrite = '1') THEN
        mem(to_integer(unsigned((adresse(LOG_MEM_SIZE-1 DOWNTO 0))))) <= WriteData;
      END IF;
    END IF;
  END PROCESS;

  -- Port de lecture combinatoire
  ReadData <= mem(to_integer(unsigned((adresse(LOG_MEM_SIZE-1 DOWNTO 0)))));
END dmem_arch;
