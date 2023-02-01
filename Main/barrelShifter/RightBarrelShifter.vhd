
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity rightBarrelShifter is
generic(N : integer := 32); -- Generic of type integer for input/output data width.
  port(i_InputBits      : in std_logic_vector(N-1 downto 0);
       
       i_SelShiftOne	: in std_logic;
       i_SelShiftTwo	: in std_logic;
       i_SelShiftFour	: in std_logic;
       i_SelShiftEight	: in std_logic;
       i_SelShiftSixteen: in std_logic;
       i_Zero 		: in std_logic;
       o_OutputBits    : out std_logic_vector(N-1 downto 0));
end rightBarrelShifter;

architecture structural of rightBarrelShifter is

component mux2to1 is 
    Port (i_S    : in  std_logic;
         i_D0    : in  std_logic;
         i_D1    : in  std_logic;
         o_O    : out std_logic);
end component;

signal p1_out, p2_out, p3_out, p4_out :std_logic_vector(31 downto 0);

begin 

G_NBit_rightBarrelShifter1: for i in 0 to N-2 generate
    	ShiftOne: mux2to1  port map(
              i_S      => i_SelShiftOne,      
              i_D0     => i_InputBits(i),  
              i_D1     => i_InputBits(i+1),  
              o_O     => p1_out(i)); 
end generate G_NBit_rightBarrelShifter1;

	ShiftOneEndCase: mux2to1 port map(
              i_S      => i_SelShiftOne,     
              i_D0     => i_InputBits(31), 
              i_D1     => i_Zero,  
              o_O      => p1_out(31));
 
G_NBit_rightBarrelShifter2: for i in 0 to N-3 generate
	ShiftTwo: mux2to1 port map(
		i_S	=> i_SelShiftTwo,
		i_D0	=> p1_out(i),
		i_D1	=> p1_out(i+2),
		o_O	=> p2_out(i));

end generate G_NBit_rightBarrelShifter2;

	ShiftTwoEndCaseOne: mux2to1 port map(
		i_S	=> i_SelShiftTwo, 
		i_D0	=> p1_out(30),
		i_D1	=> i_Zero,
		o_O	=> p2_out(30));

	ShiftTwoEndCaseTwo: mux2to1 port map(
		i_S	=> i_SelShiftTwo,
		i_D0	=> p1_out(31),
		i_D1	=> i_Zero, 
		o_O 	=> p2_out(31));

G_NBit_rightBarrelShifter4: for i in 0 to N-5 generate
	ShiftFour: mux2to1 port map(
		i_S	=> i_SelShiftFour,
		i_D0	=> p2_out(i),
		i_D1	=> p2_out(i+4),
		o_O     => p3_out(i));
end generate G_NBit_rightBarrelShifter4;

	ShiftFourEndCaseOne: mux2to1 port map(
		i_S	=> i_SelShiftFour,
		i_D0	=> p2_out(28),
		i_D1	=> i_Zero,
		o_O	=> p3_out(28));

	ShiftFourEndCaseTwo: mux2to1 port map(
		i_S	=> i_SelShiftFour,
		i_D0	=> p2_out(29),
		i_D1	=> i_Zero,
		o_O	=> p3_out(29));  

	ShiftFourEndCaseThree: mux2to1 port map(
		i_S	=> i_SelShiftFour,
		i_D0	=> p2_out(30),
		i_D1	=> i_Zero,
		o_O	=> p3_out(30)); 

	ShiftFourEndCaseFour: mux2to1 port map(
		i_S	=> i_SelShiftFour,
		i_D0	=> p2_out(31),
		i_D1	=> i_Zero,
		o_O	=> p3_out(31));

G_NBit_rightBarrelShifter8: for i in 0 to N-9 generate

	ShiftEight: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(i),
		i_D1	=> p3_out(i+8),
		o_O	=> p4_out(i));
end generate G_NBit_rightBarrelShifter8;

	ShiftEightEndCaseOne: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(24),
		i_D1	=> i_Zero,
		o_O	=> p4_out(24));

	ShiftEightEndCaseTwo: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(25),
		i_D1	=> i_Zero,
		o_O	=> p4_out(25));

	ShiftEightEndCaseThree: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(26),
		i_D1	=> i_Zero,
		o_O	=> p4_out(26));

	ShiftEightEndCaseFour: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(27),
		i_D1	=> i_Zero,
		o_O	=> p4_out(27));


	ShiftEightEndCaseFive: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(28),
		i_D1	=> i_Zero,
		o_O	=> p4_out(28));

	ShiftEightEndCaseSix: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(29),
		i_D1	=> i_Zero,
		o_O	=> p4_out(29));

	ShiftEightEndCaseSeven: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(30),
		i_D1	=> i_Zero,
		o_O	=> p4_out(30));

	ShiftEightEndCaseEight: mux2to1 port map(
		i_S	=> i_SelShiftEight,
		i_D0	=> p3_out(31),
		i_D1	=> i_Zero,
		o_O	=> p4_out(31));

G_NBit_rightBarrelShifter16: for i in 0 to N-17 generate

	ShiftSixteen: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(i),
		i_D1	=> p4_out(i+16),
		o_O	=> o_OutputBits(i));
end generate G_NBit_rightBarrelShifter16;

	ShiftSixteenEndCaseOne: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(16),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(16));

	ShiftSixteenEndCaseTwo: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(17),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(17));

	ShiftSixteenEndCaseThree: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(18),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(18));

	ShiftSixteenEndCaseFour: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(19),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(19));


	ShiftSixteenEndCaseFive: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(20),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(20));

	ShiftSixteenEndCaseSix: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(21),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(21));

	ShiftSixteenEndCaseSeven: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(22),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(22));

	ShiftSixteenEndCaseEight: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(23),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(23));

	ShiftSixteenEndCaseNine: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(24),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(24));

	ShiftSixteenEndCaseTen: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(25),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(25));

	ShiftSixteenEndCaseEleven: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(26),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(26));

	ShiftSixteenEndCaseTwelve: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(27),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(27));


	ShiftSixteenEndCaseThirteen: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(28),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(28));

	ShiftSixteenEndCaseFourteen: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(29),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(29));

	ShiftSixteenEndCaseFifteen: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(30),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(30));

	ShiftSixteenEndCaseSixteen: mux2to1 port map(
		i_S	=> i_SelShiftSixteen,
		i_D0	=> p4_out(31),
		i_D1	=> i_Zero,
		o_O	=> o_OutputBits(31));
	
end structural;