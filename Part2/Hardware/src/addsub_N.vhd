-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- addsub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a structural 
-- N-bit add / subtract component. 

-- NOTES:
-- 9/21/21 Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity addsub_N is
  generic(N : integer := 32);
  port(
       i_A               : in std_logic_vector(N-1 downto 0);
       i_B               : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub        : in std_logic;
       o_F               : out std_logic_vector(N-1 downto 0);
       o_C               : out std_logic;
       o_Overflow        : out std_logic);

end addsub_N;

architecture structure of addsub_N is

  component adder is
    port ( i_A   : in std_logic;
           i_B   : in std_logic;
           i_C   : in std_logic;
           o_F   : out std_logic;
           o_C   : out std_logic);
  end component;

  component xorg2 is
    port( i_A : in std_logic;
          i_B : in std_logic;
          o_F : out std_logic);
  end component;

  -- component adder_N is
  --   generic(N : integer := 32);
  --   port( i_A : in std_logic_vector(N-1 downto 0);
  --         i_B : in std_logic_vector(N-1 downto 0);
	--   i_C : in std_logic;
  --         o_F : out std_logic_vector(N-1 downto 0);
	--   o_C : out std_logic);
  -- end component;

  component mux2to1_N is
    generic(N : integer := 32);
    port( i_D0 : in std_logic_vector(N-1 downto 0);
	  i_D1 : in std_logic_vector(N-1 downto 0);
	  i_S  : in std_logic;
	  o_O  : out std_logic_vector(N-1 downto 0));
  end component;

  component invg_N is
    generic(N : integer := 32);
    port( i_A : in std_logic_vector(N-1 downto 0);
	  o_F : out std_logic_vector(N-1 downto 0));
  end component;

  -- This stored inverted B (-B) if needed for subtraction
  signal s_IB : std_logic_vector(N-1 downto 0);

  -- This is either i_B or s_IB depending on addition/subtraction
  signal s_BB : std_logic_vector(N-1 downto 0);

  signal s_C : std_logic_vector(N-1 downto 0);

  signal s_expect_0, s_expect_1 : std_logic;

begin

  -- Invert i_B
  invgN: invg_N port map (
	i_A => i_B,
	o_F => s_IB);

  -- Use i_B or s_IB for adding/subtracting
  mux2t1N: mux2to1_N port map (
	i_D0 => i_B,
	i_D1 => s_IB,
	i_S  => i_nAdd_Sub,
	o_O  => s_BB);

  -- Initial adder
  adderInit: adder port map (
    i_A   => i_A(0),
    i_B   => s_BB(0),
    i_C   => i_nAdd_Sub,
    o_F   => o_F(0),
    o_C   => s_C(0));

  G_adders: for i in 1 to 31 generate
    adderN: adder port map (
      i_A   => i_A(i),
      i_B   => s_BB(i),
      i_C   => s_C(i - 1),
      o_F   => o_F(i),
      o_C   => s_C(i));
  end generate G_adders;

  xor0: xorg2 port map (
    i_A =>  s_C(30),
    i_B =>  s_C(31),
    o_F =>  o_Overflow);

  o_C <= s_C(31);

  -- s_expect_0 <= (not i_A(31)) and (i_B(31) xnor i_nAdd_Sub);
  -- s_expect_1 <= i_A(31) and (i_B(31) xor i_nAdd_Sub);
  
  -- o_Negative <= s_expect_0 and (o_F(31) or s_expect_1);

end structure;
