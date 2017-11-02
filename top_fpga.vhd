--========================= top_fpga.vhd ============================
-- ELE-343 Conception des systèmes ordinés
-- HIVER 2017, Ecole de technologie supérieure
-- Auteur : Yves Blaquière
-- =============================================================
-- Description: top_fpga
--              Enveloppe (wrapper) pour le top du MIPS qui
--              Nomme les ports en fonction du fichier des pins
--              du FPGA, tel que décrit dans le fichier
--              DE2_pin_assignments.csv du DE2
--              Ajoute des afficheurs 7-segment sur les ports de
--              sortie du top
-- =============================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY top_fpga IS
  PORT (KEY  : IN  std_logic_vector (0 TO 1);   -- KEY[0]=reset, KEY[1]=clock
        HEX0 : OUT std_logic_vector (0 TO 6);   -- PC(3 downto 0) 
        HEX1 : OUT std_logic_vector (0 TO 6);   -- PC(7 downto 4) 
        HEX4 : OUT std_logic_vector (0 TO 6);   -- DataAddress(3 downto 0) 
        HEX5 : OUT std_logic_vector (0 TO 6);   -- DataAddress(7 downto 4) 
        HEX6 : OUT std_logic_vector (0 TO 6);   -- WriteData(3 downto 0) 
        HEX7 : OUT std_logic_vector (0 TO 6));  -- WriteData(7 downto 4
END ENTITY top_fpga;

ARCHITECTURE rtl OF top_fpga IS
  SIGNAL Memwrite               : std_logic;
  SIGNAL PC                     : std_logic_vector (7 DOWNTO 0);
  SIGNAL WriteData, DataAddress : std_logic_vector (31 DOWNTO 0);
BEGIN  -- ARCHITECTURE tb
  -- Instantiation du top
  DUT : ENTITY work.top
    PORT MAP (Reset       => KEY(0),
              clock       => KEY(1),
              PC          => PC,
              WriteData   => WriteData,
              DataAddress => DataAddress);

  -- Afficheurs 7-segments pour les ports de sortie
  dec7seg_0 : ENTITY work.dec7seg PORT MAP (HEX0, PC(3 DOWNTO 0));
  dec7seg_1 : ENTITY work.dec7seg PORT MAP (HEX1, PC(7 DOWNTO 4));
  dec7seg_4 : ENTITY work.dec7seg PORT MAP (HEX4, DataAddress(3 DOWNTO 0));
  dec7seg_5 : ENTITY work.dec7seg PORT MAP (HEX5, DataAddress(7 DOWNTO 4));
  dec7seg_6 : ENTITY work.dec7seg PORT MAP (HEX6, WriteData(3 DOWNTO 0));
  dec7seg_7 : ENTITY work.dec7seg PORT MAP (HEX7, WriteData(7 DOWNTO 4));
END ARCHITECTURE rtl;
