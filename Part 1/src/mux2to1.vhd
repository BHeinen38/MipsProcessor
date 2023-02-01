-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2to1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2 to 1 Multiplexer
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2to1 is

  port(i_D0          : in std_logic;
       i_D1          : in std_logic;
       i_S          : in std_logic;
       o_O          : out std_logic);

end mux2to1;

architecture structure of mux2to1 is

  component andg2 is
    Port( i_A : in std_logic;
          i_B : in std_logic;
          o_F  : out std_logic);
  end component;

  component org2 is
    Port( i_A : in std_logic;
          i_B : in std_logic;
          o_F  : out std_logic);
  end component;

  component invg is
    Port( i_A       : in std_logic;
          o_F       : out std_logic);
  end component;

  signal s_si : std_logic;
  signal s_and1 : std_logic;
  signal s_and2 : std_logic;

begin
  si: invg 
    port map (i_A => i_S, 
              o_F => s_si);
  and1: andg2 
    port map (i_A => i_D0, 
              i_B => s_si, 
              o_F => s_and1);
  and2: andg2 
    port map (i_A => i_D1, 
              i_B => i_s, 
              o_F => s_and2);
  or1: org2 
    port map (i_A => s_and1, 
              i_B => s_and2, 
              o_F => o_O);

  --o_O <= (i_D0 and not i_S) or (i_D1 and i_S);
  
end structure;
