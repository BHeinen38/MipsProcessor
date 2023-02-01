-------------------------------------------------------------------------
-- Austin, Erik, Bailey
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an ALU
-- + - and or xor, set less than, equal, not equal, repl.qb, shift left, shift right, shift right logical
--
--
-- NOTES:
-- 10/31/2021 Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
	port(
    i_A         : in std_logic_vector(31 downto 0);		-- Read register A
    i_B         : in std_logic_vector(31 downto 0);		-- Read register B
    i_ALUSelect : in std_logic_vector(3 downto 0);	-- Add/Sub
    o_F	        : out std_logic_vector(31 downto 0);		-- Output w/out carry
    o_Zero      : out std_logic);
end ALU;

architecture structural of ALU is

component addsub_N is 
  generic (N : integer := 32);
  port(
    i_A               : in std_logic_vector(N-1 downto 0);
    i_B               : in std_logic_vector(N-1 downto 0);
    i_nAdd_Sub        : in std_logic;
    o_F               : out std_logic_vector(N-1 downto 0);
    o_C               : out std_logic);
end component;

component andg2 is
	port(
		i_A	:	in std_logic;
		i_B	:	in std_logic;
		o_F	:	out std_logic);
end component;

component org2 is
  port(
      i_A   : in std_logic;
      i_B   : in std_logic;
      o_F   : out std_logic);
end component;

component xorg2 is
	port(
      i_A   : in std_logic;
      i_B   : in std_logic;
      o_F   : out std_logic);
end component;

component equalsZero is
	port(
      i_A   : in std_logic_vector(31 downto 0);
      o_F   : out std_logic);
end component;

component repl_qb is
	port(
		i_A	: in std_logic_vector(7 downto 0);
		o_F	: out std_logic_vector(31 downto 0));
end component;

component barrelShifter is
	port(
    i_InputBits       : in std_logic_vector(31 downto 0);
		i_S_Shift	        : in std_logic_vector(4 downto 0);
    i_S_Dir           : in std_logic; -- [right: 0, left: 1]
		i_Zero 		        : in std_logic;
		o_OutputBits      : out std_logic_vector(31 downto 0));
end component;

component invg is
  port(i_A          : in std_logic;
      o_F          : out std_logic);
end component;

component mux2to1 is
  port( i_D0		: in std_logic;
        i_D1		: in std_logic;
        i_S		: in std_logic;
        o_O		: out std_logic);
end component;

component mux16to1_N is
  port( i_D0		: in std_logic_vector(31 downto 0);
        i_D1		: in std_logic_vector(31 downto 0);
        i_D2		: in std_logic_vector(31 downto 0);
        i_D3		: in std_logic_vector(31 downto 0);
        i_D4		: in std_logic_vector(31 downto 0);
        i_D5		: in std_logic_vector(31 downto 0);
        i_D6		: in std_logic_vector(31 downto 0);
        i_D7		: in std_logic_vector(31 downto 0);
        i_D8		: in std_logic_vector(31 downto 0);
        i_D9		: in std_logic_vector(31 downto 0);
        i_D10		: in std_logic_vector(31 downto 0);
        i_D11		: in std_logic_vector(31 downto 0);
        i_D12		: in std_logic_vector(31 downto 0);
        i_D13		: in std_logic_vector(31 downto 0);
        i_D14		: in std_logic_vector(31 downto 0);
        i_D15		: in std_logic_vector(31 downto 0);
        i_S		: in std_logic_vector(3 downto 0);
        o_F		: out std_logic_vector(31 downto 0));
end component;

  signal s_F_addSub, s_F_lui, s_F_and, s_F_or, s_F_nor, s_F_xor, s_F_equal, s_F_neq, s_F_sll, s_F_slt, s_F_srl, s_F_sra, s_F_repl : std_logic_vector(31 downto 0);
  signal s_addSub, s_C : std_logic;	-- Throw away carry bit
  signal s_ShiftLeft : Integer := 1;
  signal s_ShiftRight : Integer := 0;
  signal s_neq : std_logic_vector(31 downto 0) := (others => '0');


begin

  mux0: mux2to1 port map (
    i_D0 => i_ALUSelect(0),
    i_D1 => '0',
    i_S  => i_ALUSelect(1),
    o_O  => s_addSub);

  -- Addition subtraction function
  addSub: addsub_N port map (
	  i_A          => i_A,
    i_B          => i_B,
    i_nAdd_Sub   => s_addSub,
    o_F          => s_F_addSub,
    o_C          => s_C);

  eq: equalsZero port map (
    i_A => s_F_addSub,
    o_F => o_Zero);

  -- And function
  G_and: for i in 0 to 31 generate
    and0: andg2 port map (
      i_A   => i_A(i),
      i_B   => i_B(i),
      o_F   => s_F_and(i));
  end generate G_and;

  -- Or function
  G_or: for i in 0 to 31 generate
    or0: org2 port map (
      i_A   => i_A(i),
      i_B   => i_B(i),
      o_F   => s_F_or(i));

    inv1: invg port map (
      i_A => s_F_or(i),
      o_F => s_f_nor(i));
  end generate G_or;

  -- Xor function
  G_xor: for i in 0 to 31 generate
    xor0: xorg2 port map (
      i_A   => i_A(i),
      i_B   => i_B(i),
      o_F   => s_F_xor(i));
  end generate G_xor;

  shifterleft: barrelShifter port map (
    i_InputBits => i_A,
    i_S_Shift   => i_B(4 downto 0),
    i_S_Dir     => '1',
    i_Zero      => '0',
    o_OutputBits => s_F_sll);

  shifterRight: barrelShifter port map (
      i_InputBits => i_A,
      i_S_Shift   => i_B(4 downto 0),
      i_S_Dir     => '0',
      i_Zero      => '0',
      o_OutputBits => s_F_srl);

   G_equal: for i in 0 to 31 generate
    beq: andg2 port map (
    i_A   => i_A(i),
    i_B   => i_B(i),
    o_F   => s_F_equal(i));
  end generate G_equal;
  
  G_notEqual: for i in 0 to 31 generate
    bne: xorg2 port map (
    i_A   => i_A(i),
    i_B   => i_B(i),
    o_F   => s_neq(i));
  end generate G_notEqual;

  s_F_neq(0) <= s_neq(31);

  inv0: invg port map (
    i_A => s_neq(31),
    o_F => s_f_equal(0));


  s_F_lui(31 downto 16) <= i_B(15 downto 0);
  s_F_lui(15 downto 0) <= "0000000000000000";
  -- s_F_lui <= "01010101010101010101010101010101";
  
  
  -- i_ALUSelect dispersal into operation signals
  muxB: mux16to1_N port map ( -- ALUSelect: control logic google excel document
    i_D0    =>  s_F_addSub,   -- 0000 add
    i_D1    =>  s_F_addSub,   -- 0001 sub
    i_D2    =>  s_F_and,      -- 0010 and
    i_D3    =>  s_F_or,       -- 0011 or
    i_D4    =>  s_F_nor,      -- 0100 nor
    i_D5    =>  s_F_xor,      -- 0101 xor
    i_D6    =>  s_F_repl,     -- 0110 repl.qb
    i_D7    =>  s_F_slt,      -- 0111 set less than
    i_D8    =>  s_F_sll,      -- 1000 shift left logical <<
    i_D9    =>  s_F_srl,      -- 1001 shift right logical >>
    i_D10    =>  s_F_sra,     -- 1010 shift right arithmetic >>>
    i_D11    =>  s_F_equal,   -- 1011 equal
    i_D12    =>  s_F_neq,     -- 1100 not equal
    i_D13    =>  s_F_lui,     -- 1101 lui
    i_D14    =>  s_F_addSub,     -- 1110 lw
    i_D15    =>  s_F_addSub,     -- 1111 sw
    i_S     =>  i_ALUSelect,
    o_F     =>  o_F);

  end structural;
