-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- bitExtender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 16-32 bit extender
--
--
-- NOTES:
-- 10/11/2021 CREATED
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity bitExtender is
  port(i_D          : in std_logic_vector(15 downto 0);      -- Data in
       i_S          : in std_logic;                          -- Switch 0 = signed 1 = unsigned
       o_F          : out std_logic_vector(31 downto 0));    -- Data out
end bitExtender;

architecture behavioral of bitExtender is
begin

  o_F <= x"FFFF" & i_D when i_D(15) = '1' and i_S = '0' else
         x"0000" & i_D;
    
end behavioral;