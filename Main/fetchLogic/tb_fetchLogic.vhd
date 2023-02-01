library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;

use std.textio.all;            

entity tb_fetchLogic is
generic(gCLK_HPER   : time := 10 ns);  
end tb_fetchLogic;

architecture mixed of tb_fetchLogic is

constant cCLK_PER  : time := gCLK_HPER * 2;

component fetchLogic is

  port(
    i_CLK       : in std_logic;                       -- Clock
    i_RST       : in std_logic;                       -- Resets register file
    i_PC        : in std_logic_vector(31 downto 0);
    o_PC        : out std_logic_vector(31 downto 0));

end component;

signal CLK, reset : std_logic := '0';

signal si_PC: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";      
signal so_PC: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";    

begin

  DUT0: fetchLogic
  port map ( 
    i_CLK  => CLK,
    i_RST  => reset,
    i_PC   => si_PC,
    o_PC   => so_PC);

  P_CLK: process
  begin
    CLK <= '1';         
    wait for gCLK_HPER;
    CLK <= '0';        
    wait for gCLK_HPER;
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
    wait for gCLK_HPER/2;
   
    si_PC <= so_PC;
    wait for gCLK_HPER*2;

    si_PC <= so_PC;
    wait for gCLK_HPER*2;

    si_PC <= so_PC;
    wait for gCLK_HPER*2;

    si_PC <= so_PC;
    wait for gCLK_HPER*2;

    si_PC <= so_PC;
    wait for gCLK_HPER*2;

    si_PC <= so_PC;
    wait for gCLK_HPER*2;
      
  wait;
end process;

end mixed;
