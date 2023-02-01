-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- register_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit register
--
--
-- NOTES:
-- 9/30/2021 CREATED
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity register_N is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_F          : out std_logic_vector(N-1 downto 0));   -- Data value output

end register_N;

architecture structural of register_N is

  component dffg is
    Port(i_CLK      : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
  end component;

begin
  G_NBit_MUX: for i in 0 to N-1 generate
  Dflipflop: dffg 
    port map (i_CLK => i_CLK,
	      i_RST => i_RST,
	      i_WE  => i_WE,
	      i_D   => i_D(i),
              o_Q => o_F(i));
  end generate G_NBit_MUX;
end structural;
