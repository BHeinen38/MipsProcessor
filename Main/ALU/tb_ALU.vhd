library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
               
use std.textio.all;             

entity tb_ALU is
  generic(gCLK_HPER   : time := 10 ns);   
end tb_ALU;

architecture mixed of tb_ALU is

constant cCLK_PER  : time := gCLK_HPER * 2;

component ALU is
  port(
    i_A         : in std_logic_vector(31 downto 0);		-- Read register A
    i_B         : in std_logic_vector(31 downto 0);		-- Read register B
    i_ALUSelect : in std_logic_vector(3 downto 0);	-- Add/Sub
    o_F	        : out std_logic_vector(31 downto 0);		-- Output w/out carry
    o_Zero      : out std_logic);
end component;


signal CLK, reset : std_logic := '0';

signal s_A, s_B, s_F : std_logic_vector(31 downto 0);
signal s_ALUSelect : std_logic_vector(3 downto 0);
signal s_Zero : std_logic;


begin

  DUT0: ALU
  port map(
      i_A         =>  s_A,
      i_B         =>  s_B,
      i_ALUSelect =>  s_ALUSelect,
      o_F         =>  s_F,
      o_Zero      =>  s_Zero);
  
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;


  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
      --add
    s_A  <= "00000000000000000000000000000001";       
    s_B  <= "00000000000000000000000000000010";       
    s_ALUSelect  <= "0000";       
    wait for gCLK_HPER*2;
    --sub
    s_A  <= "00000000000000000000000000000010";       
    s_B  <= "00000000000000000000000000000001";       
    s_ALUSelect  <= "0001";       
    wait for gCLK_HPER*2;
    --and 
    s_A  <= "00000000000000000000000000000110";       
    s_B  <= "00000000000000000000000000000011";       
    s_ALUSelect  <= "0010";       
    wait for gCLK_HPER*2;
    --or
    s_A  <= "00000000000000000000000000000110";       
    s_B  <= "00000000000000000000000000000011";       
    s_ALUSelect  <= "0011";       
    wait for gCLK_HPER*2;


    --nor
    s_A  <= "00000000000000000000000000000110";       
    s_B  <= "00000000000000000000000000000011";       
    s_ALUSelect  <= "0100";       
    wait for gCLK_HPER*2;

    --expecting 11111111111111111111111111111000

    --xor
    s_A  <= "00000000000000000000000000000110";       
    s_B  <= "00000000000000000000000000000011";       
    s_ALUSelect  <= "0101";       
    wait for gCLK_HPER*2;
    -- 00000000000000000000000000000101

    --sll
    s_A  <= "00000000000000000000000000000110";       
    s_B  <= "00000000000000000000000000000010";       
    s_ALUSelect  <= "1000";       
    wait for gCLK_HPER*2;
  -- expecting 00000000000000000000000000110000
              
    --srl
    s_A  <= "01100000000000000000000000000000";       
    s_B  <= "00000000000000000000000000000010";       
    s_ALUSelect  <= "1000";       
    wait for gCLK_HPER*2;
--expeccting 00001100000000000000000000000000

--lw
  s_A  <= "00000000000000000000000000000110";       
  s_B  <= "00000000000000000000000000000010";       
  s_ALUSelect  <= "1110";       
  wait for gCLK_HPER*2;
--expeccting 00000000000000000000000000001000
-- should be aluSelect 0000 for add, not 0010 for and

--sw
  s_A  <= "00000000000000000000000000000110";       
  s_B  <= "00000000000000000000000000000010";       
  s_ALUSelect  <= "1110";       
  wait for gCLK_HPER*2;
--expeccting 00000000000000000000000000001000

--lui
s_A  <= "00000000000000000000000000000010";       
s_B  <= "00000000000000000000000000000010";       
s_ALUSelect  <= "1101";       
wait for gCLK_HPER*2;
--expeccting "00000000000001000000000000000000"
  
  wait;
  end process;

end mixed;
