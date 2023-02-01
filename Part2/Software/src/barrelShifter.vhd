library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrelShifter is
generic(N : integer := 32); -- Generic of type integer for input/output data width.
  port(
	  i_InputBits       : in std_logic_vector(N-1 downto 0);
		i_S_Shift	        : in std_logic_vector(4 downto 0);
    i_S_Dir           : in std_logic; -- [right: 0, left: 1]
		i_Zero 		        : in std_logic;
		o_OutputBits      : out std_logic_vector(N-1 downto 0));
end barrelShifter;

architecture structural of barrelShifter is

component mux2to1_N is 
  generic(N : integer := 32);
    Port (
      i_D0   : in  std_logic_vector(N-1 downto 0);
      i_D1   : in  std_logic_vector(N-1 downto 0);
      i_S    : in  std_logic;
      o_O    : out std_logic_vector(N-1 downto 0));
end component;

component bitFlipper is
  generic(N : integer := 32);
    Port (
      i_InputBits   : in std_logic_vector(N-1 downto 0);
      o_OutputBits  : out std_logic_vector(N-1 downto 0));
end component;

component rightBarrelShifter is
  generic(N : integer := 32); -- Generic of type integer for input/output data width.
    port(
      i_InputBits       : in std_logic_vector(N-1 downto 0);
      i_SelShiftOne	    : in std_logic;
      i_SelShiftTwo	    : in std_logic;
      i_SelShiftFour	  : in std_logic;
      i_SelShiftEight	  : in std_logic;
      i_SelShiftSixteen : in std_logic;
      i_Zero 		        : in std_logic;
      o_OutputBits      : out std_logic_vector(N-1 downto 0));
end component;

signal s_OutputBits, s_OutputBits_Flip, s_InputBits_Flip, s_InputBits_Use : std_logic_vector(N-1 downto 0);

begin 

  flipInput: bitFlipper
    generic map(N => N)
    port map (
      i_InputBits => i_InputBits,
      o_OutputBits => s_InputBits_Flip);

  mux0: mux2to1_N
    generic map(N => N)
    port map (
      i_S   =>  i_S_Dir,
      i_D0  =>  i_InputBits,
      i_D1  =>  s_InputBits_Flip,
      o_O   =>  s_InputBits_Use);

  rbs: rightBarrelShifter
    generic map(N => N)
    port map (
      i_InputBits => s_InputBits_Use,
      i_SelShiftOne =>  i_S_Shift(0),
      i_SelShiftTwo =>  i_S_Shift(1),
      i_SelShiftFour =>  i_S_Shift(2),
      i_SelShiftEight =>  i_S_Shift(3),
      i_SelShiftSixteen =>  i_S_Shift(4),
      i_Zero  => i_Zero,
      o_OutputBits  =>  s_OutputBits);

  flipOutput: bitFlipper
    generic map(N => N)
    port map (
      i_InputBits => s_OutputBits,
      o_OutputBits => s_OutputBits_Flip);

  mux1: mux2to1_N
  generic map(N => N)
  port map (
    i_S => i_S_Dir,
    i_D0  =>  s_OutputBits,
    i_D1  =>  s_OutputBits_Flip,
    o_O   =>  o_OutputBits);
 
end structural;
