--================ controller.vhd ============================
-- ELE-343 Conception des systèmes ordinés
-- hiver 2017, Ecole de technologie supérieure
-- Vincent Trudel-Lapierre et Yves Blaquière
-- =============================================================
-- Description: Décodeur 7-segment Alpha-numérique pour DE-2
-- =============================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dec7seg IS
-- Configuration des entrées et sortie du controller
  PORT (sortie : OUT std_logic_vector(0 TO 6);
        entree : IN  std_logic_vector(3 DOWNTO 0));
END dec7seg;

ARCHITECTURE dec7seg_archi OF dec7seg IS
BEGIN
  PROCESS(entree)
  BEGIN
    CASE entree IS
      WHEN "0000" => sortie <= "0000001";  -- 0
      WHEN "0001" => sortie <= "1001111";  -- 1
      WHEN "0010" => sortie <= "0010010";  -- 2
      WHEN "0011" => sortie <= "0000110";  -- 3
      WHEN "0100" => sortie <= "1001100";  -- 4
      WHEN "0101" => sortie <= "0100100";  -- 5
      WHEN "0110" => sortie <= "0100000";  -- 6
      WHEN "0111" => sortie <= "0001111";  -- 7
      WHEN "1000" => sortie <= "0000000";  -- 8
      WHEN "1001" => sortie <= "0000100";  -- 9
      WHEN "1010" => sortie <= "0001000";  -- A
      WHEN "1011" => sortie <= "1100000";  -- b
      WHEN "1100" => sortie <= "0110001";  -- C
      WHEN "1101" => sortie <= "1000010";  -- D
      WHEN "1110" => sortie <= "0110000";  -- E
      WHEN "1111" => sortie <= "0111000";  -- F   
      WHEN OTHERS => sortie <= "1111111";
    END CASE;
  END PROCESS;
END dec7seg_archi;
