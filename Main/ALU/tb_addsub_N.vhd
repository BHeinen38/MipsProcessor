library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
               
use std.textio.all;             

entity tb_addsub_N is
  generic(gCLK_HPER   : time := 10 ns);   
end tb_addsub_N;

architecture mixed of tb_addsub_N is

constant cCLK_PER  : time := gCLK_HPER * 2;

component addsub_N is
  port(
    i_A         : in std_logic_vector(31 downto 0);		-- Read register A
    i_B         : in std_logic_vector(31 downto 0);		-- Read register B
    i_nAdd_Sub  : in std_logic;	-- Add/Sub
    o_F	            : out std_logic_vector(31 downto 0);		-- Output w/out carry
    o_C             : out std_logic;
    o_Overflow      : out std_logic);
end component;


signal CLK, reset : std_logic := '0';

signal s_A, s_B, s_F : std_logic_vector(31 downto 0);
signal s_nAdd_Sub, s_C, s_Overflow : std_logic;

begin

  DUT0: addsub_N
  port map(
      i_A         =>  s_A,
      i_B         =>  s_B,
      i_nAdd_Sub =>  s_nAdd_Sub,
      o_F         =>  s_F,
      o_C         =>  s_C,
      o_Overflow  => s_Overflow);
  
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
    

    -- 0 + 0
    s_A  <= x"00000000";       
    s_B  <= x"00000000";   
    s_nAdd_Sub <= '0'; 
    wait for gCLK_HPER*2;
    
    -- 0 - 0
    s_A  <= x"00000000";   
    s_B  <= x"00000000";       
    s_nAdd_Sub <= '1';     
    wait for gCLK_HPER*2;
    
    -- 0 - -8ish
    s_A  <= x"00000000";       
    s_B  <= x"FFFFFFF0";   
    s_nAdd_Sub <= '1'; 
    wait for gCLK_HPER*2;
    
    -- -8ish - 0
    s_A  <= x"FFFFFFF0";   
    s_B  <= x"00000000";       
    s_nAdd_Sub <= '1';     
    wait for gCLK_HPER*2;

    -- 0 - 4
    s_A  <= x"00000000";       
    s_B  <= x"00000004";   
    s_nAdd_Sub <= '1'; 
    wait for gCLK_HPER*2;
    
    -- 4 - 0
    s_A  <= x"00000004";   
    s_B  <= x"00000000";       
    s_nAdd_Sub <= '1';     
    wait for gCLK_HPER*2;

    -- 0 - -max
    s_A  <= x"00000000";       
    s_B  <= x"80000000";   
    s_nAdd_Sub <= '1'; 
    wait for gCLK_HPER*2;
    
    -- -max - 0
    s_A  <= x"80000000";   
    s_B  <= x"00000000";       
    s_nAdd_Sub <= '1';     
    wait for gCLK_HPER*2;

    s_A  <= x"efffffff";   
    s_B  <= x"10000000";       
    s_nAdd_Sub <= '1';     
    wait for gCLK_HPER*2;

    s_A  <= x"10000000";   
    s_B  <= x"efffffff";       
    s_nAdd_Sub <= '1';     
    wait for gCLK_HPER*2;

  wait;
  end process;

end mixed;
