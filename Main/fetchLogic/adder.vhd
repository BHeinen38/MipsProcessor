-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a structural 
-- adder operating on bitsinputs. 
--
--

-- NOTES:
-- 9/16/21 Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity adder is
  port(
       i_A               : in std_logic;
       i_B               : in std_logic;
       i_C               : in std_logic;
       o_F               : out std_logic;
       o_C               : out std_logic);

end Adder;

architecture structure of adder is

  component xorg2 is
    port( i_A : in std_logic;
          i_B : in std_logic;
          o_F : out std_logic);
  end component;

  component andg2 is
    port( i_A : in std_logic;
          i_B : in std_logic;
          o_F : out std_logic);
  end component;

  component org2 is
    port( i_A : in std_logic;
          i_B : in std_logic;
          o_F : out std_logic);
  end component;

  signal s_xor1 : std_logic;
  signal s_xor2 : std_logic;
  signal s_sum : std_logic;
  signal s_and1 : std_logic;
  signal s_and2 : std_logic;

begin
  xor1: xorg2
    port map (i_A => i_A,
              i_B => i_B,
              o_F => s_xor1);

  xor2: xorg2
    port map (i_A => s_xor1,
              i_B => i_C,
              o_F => s_xor2);
  and1: andg2
    port map (i_A => i_C,
              i_B => s_xor1,
	      o_F => s_and1);

  and2: andg2
    port map (i_A => i_A,
              i_B => i_B,
	      o_F => s_and2);

  or1: org2
    port map (i_A => s_and1,
              i_B => s_and2,
	      o_F => o_C);
  o_F <= s_xor2;

  
end structure;