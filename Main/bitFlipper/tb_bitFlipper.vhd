library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
               
use std.textio.all;             


entity tb_bitFlipper is
  generic(gCLK_HPER   : time := 10 ns);   
end tb_bitFlipper;

architecture mixed of tb_bitFlipper is


constant cCLK_PER  : time := gCLK_HPER * 2;


component bitFlipper is
  generic(N : integer := 32);
  port(i_InputBits      : in std_logic_vector(N-1 downto 0);
       o_OutputBits    : out std_logic_vector(N-1 downto 0));
end component;


signal CLK, reset : std_logic := '0';

signal si_InputBits  	: std_logic_vector(31 downto 0);
signal so_OutputBits    : std_logic_vector(31 downto 0);	

begin

  DUT0: bitFlipper
  port map(
    i_InputBits  	=> si_InputBits,
    o_OutputBits  => so_OutPutBits);

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

si_InputBits  <= "01111111111111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00111111111111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00011111111111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00001111111111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000111111111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000011111111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000001111111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000111111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000011111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000001111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000111111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000011111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000001111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000111111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000011111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000001111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000111111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000011111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000001111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000111111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000011111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000001111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000111111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000011111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000001111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000000111111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000000011111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000000001111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000000000111";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000000000011";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000000000001";
wait for gCLK_HPER*2;

si_InputBits  <= "00000000000000000000000000000000";
wait for gCLK_HPER*2;
    
wait;
  end process;

end mixed;