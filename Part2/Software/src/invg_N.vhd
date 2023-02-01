-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- invg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-input NOT 
-- gate.
--
--
-- NOTES:
-- 9/21/21 Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity invg_N is
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end invg_N;

architecture structure of invg_N is

  component invg is
    port( i_A : in std_logic;
	  o_F : out std_logic);
  end component;

begin

  G_NBit_inv: for i in 0 to N-1 generate
    invgN: invg port map (
	i_A => i_A(i),
	o_F => o_F(i));
  end generate G_NBit_inv;
  
end structure;
