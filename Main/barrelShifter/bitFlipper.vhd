-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- bitFlipper.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a bit flipper implementation

-- 11/04/2021 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitFlipper is
generic(N : integer := 32); -- Generic of type integer for input/output data width.
  port(
	  i_InputBits       : in std_logic_vector(N-1 downto 0);
	  o_OutputBits      : out std_logic_vector(N-1 downto 0));
end bitFlipper;

architecture structural of bitFlipper is

begin 

  G_FLIP: for i in 0 to N-1 generate
    o_OutputBits(i) <= i_InputBits((N-1) - i);
  end generate;
 
end structural;