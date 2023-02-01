library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
               
use std.textio.all;             


entity tb_barrelShifter is
  generic(gCLK_HPER   : time := 10 ns);   
end tb_barrelShifter;

architecture mixed of tb_barrelShifter is


constant cCLK_PER  : time := gCLK_HPER * 2;


component barrelShifter is
  port(i_InputBits      : in std_logic_vector(31 downto 0);
       i_S_Shift	        : in std_logic_vector(4 downto 0);
       i_S_Dir          : in std_logic;
       i_Zero 		      : in std_logic;
       o_OutputBits     : out std_logic_vector(31 downto 0));
end component;


signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.

signal si_InputBits  	: std_logic_vector(31 downto 0);
signal si_SelShift   : std_logic_vector(4 downto 0);
signal si_SelDir     	: std_logic := '0';		
signal si_Zero     	: std_logic := '0';		
signal so_OutputBits    : std_logic_vector(31 downto 0);	

begin

  DUT0: barrelShifter
  port map(
            i_InputBits  	      => si_InputBits,
	          i_S_Shift           => si_SelShift,
            i_S_Dir	            => si_SelDir, 
            i_Zero	            => si_Zero, 
            o_OutputBits        => so_OutPutBits);

  
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



    si_InputBits  <= "10000000000000000000000000000000";       
    si_SelShift <= "00001";  	
    si_SelDir <= '0';
    si_Zero <= '0';
    wait for gCLK_HPER*2;

    si_InputBits  <= "00000000000000000000000000000001";      
    si_SelShift <= "00001";  	
    si_SelDir <= '1';
    si_Zero <= '0';
    wait for gCLK_HPER*2;



    si_InputBits  <= "10000000000000000000000000000000";              
    si_SelShift <= "00010";  	
    si_SelDir <= '0';
    si_Zero <= '0';
    wait for gCLK_HPER*2;

    si_InputBits  <= "00000000000000000000000000000001";      
    si_SelShift <= "00010";  	
    si_SelDir <= '1';
    si_Zero <= '0';
    wait for gCLK_HPER*2;



    si_InputBits  <= "10000000000000000000000000000000";              
    si_SelShift <= "00100";  	
    si_SelDir <= '0';
    si_Zero <= '0';
    wait for gCLK_HPER*2;

    si_InputBits  <= "00000000000000000000000000000001";      
    si_SelShift <= "00100";  	
    si_SelDir <= '1';
    si_Zero <= '0';
    wait for gCLK_HPER*2;



    si_InputBits  <= "10000000000000000000000000000000";          
    si_SelShift <= "01000";  	
    si_SelDir <= '0';
    si_Zero <= '0';
    wait for gCLK_HPER*2;

    si_InputBits  <= "00000000000000000000000000000001";           
    si_SelShift <= "01000";  	
    si_SelDir <= '1';
    si_Zero <= '0';
    wait for gCLK_HPER*2;



    si_InputBits  <= "10000000000000000000000000000000";      
    si_SelShift <= "10000";  	
    si_SelDir <= '0';
    si_Zero <= '0';
    wait for gCLK_HPER*2;

    si_InputBits  <= "00000000000000000000000000000001";      
    si_SelShift <= "10000";  	
    si_SelDir <= '1';
    si_Zero <= '0';
    wait for gCLK_HPER*2;



    si_InputBits  <= "10000000000000000000000000000000";      
    si_SelShift <= "11111";  	
    si_SelDir <= '0';
    si_Zero <= '0';
    wait for gCLK_HPER*2;

    si_InputBits  <= "00000000000000000000000000000001";      
    si_SelShift <= "11111";  	
    si_SelDir <= '1';
    si_Zero <= '0';
    wait for gCLK_HPER*2;

  
  wait;
  end process;

end mixed;