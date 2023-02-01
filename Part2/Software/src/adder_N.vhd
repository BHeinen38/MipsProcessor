-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a structural 
-- N-bit adder. 
--
--

-- NOTES:
-- 9/16/21 Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity adder_N is
  generic(N : integer := 32);
  port( i_A               : in std_logic_vector(N-1 downto 0);
        i_B               : in std_logic_vector(N-1 downto 0);
        i_C               : in std_logic;
        o_F               : out std_logic_vector(N-1 downto 0);
        o_C               : out std_logic);

end adder_N;

architecture structure of adder_N is

  component adder is
    port( i_A : in std_logic;
          i_B : in std_logic;
	        i_C : in std_logic;
          o_F : out std_logic;
	        o_C : out std_logic);
  end component;

  -- Vector with extra bit is used as the connector between adder carry bits
  signal s_C : std_logic_vector(N downto 0) := (others => '0');

begin
  -- Initialize s_C with i_C
  s_C(0) <= i_C;


  G_NBit_Adder: for i in 0 to N-1 generate
    adderN: adder port map (
	i_A => i_A(i),
	i_B => i_B(i),
	i_C => s_C(i),  -- Input the bit from carry
	o_F => o_F(i),
	o_C => s_C(i+1)); -- Outpit to the next carry input
  end generate G_NBit_Adder;
  
  o_C <= s_C(N); -- Output carry bit is the last carry output

end structure;
