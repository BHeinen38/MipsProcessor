-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of fetch logic
--
--
-- NOTES:
-- 10/14/2021 Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fetchLogic is
  port(
  i_CLK       : in std_logic;                       -- Clock
  i_RST       : in std_logic;                       -- Resets register file
  i_EN_NOT        : in std_logic;                       
  i_PC        : in std_logic_vector(31 downto 0);
  o_PCNext        : out std_logic_vector(31 downto 0);
  o_PC        : out std_logic_vector(31 downto 0));
end fetchLogic;

architecture structural of fetchLogic is

component pc is
    port( i_CLK        : in std_logic;                        -- Clock input
          i_RST        : in std_logic;                        -- Reset input to 0x00400000
          i_WE         : in std_logic;                        -- Write enable input
          i_D          : in std_logic_vector(31 downto 0);    -- Data value input
          o_Q          : out std_logic_vector(31 downto 0));  -- Data value output
end component;

component mux2to1_N is
  port( i_D0   : in std_logic_vector(31 downto 0);
        i_D1   : in std_logic_vector(31 downto 0);
        i_S   : in std_logic;
        o_O   : out std_logic_vector(31 downto 0));
end component;

component adder_N is
  port( i_A   : in std_logic_vector(31 downto 0);
        i_B   : in std_logic_vector(31 downto 0);
        i_C   : in std_logic;
        o_F   : out std_logic_vector(31 downto 0);
        o_C   : out std_logic);
end component;

component invg is
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;

signal s_PC, si_PC : std_logic_vector(31 downto 0);
signal s_Throw, s_EN : std_logic;

begin

  not0: invg port map (
    i_A => i_EN_NOT,
    o_F => s_EN);

  -- Update PC on positive clock edge
  pc1: pc port map ( 
    i_CLK => i_CLK,
    i_RST => i_RST, -- 0x00400000
    i_WE => s_EN,
    i_D => i_PC,
    o_Q => s_PC);

  o_PC <= s_PC;

  -- Increment PC by 4
  addPC: adder_N port map (
    i_A => s_PC,
    i_B => x"00000004",
    i_C => '0',
    o_F => o_PCNext,
    o_C => s_Throw);


end structural;
