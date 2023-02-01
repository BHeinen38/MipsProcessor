library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
               
use std.textio.all;             


entity tb_rightBarrelShifter is
  generic(gCLK_HPER   : time := 10 ns);   
end tb_rightBarrelShifter;

architecture mixed of tb_rightBarrelShifter is


constant cCLK_PER  : time := gCLK_HPER * 2;


component rightBarrelShifter is
  port(i_InputBits      : in std_logic_vector(31 downto 0);  
       i_SelShiftOne	: in std_logic;
       i_SelShiftTwo	: in std_logic;
       i_SelShiftFour	: in std_logic;
       i_SelShiftEight	: in std_logic;
       i_SelShiftSixteen: in std_logic;
       i_Zero 		: in std_logic;
       o_OutputBits    : out std_logic_vector(31 downto 0));
end component;


signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.

signal si_InputBits  	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";      
signal si_SelShiftOne   : std_logic := '0';    	
signal si_SelShiftTwo   : std_logic := '0';		
signal si_SelShiftFour  : std_logic := '0';		
signal si_SelShiftEight : std_logic := '0';	
signal si_SelShiftSixteen   	: std_logic := '0';
signal si_Zero     	: std_logic := '0';		
signal so_OutputBits    : std_logic_vector(31 downto 0);	

begin

  DUT0: rightBarrelShifter
  port map(
            i_InputBits  	=> si_InputBits,
	    i_SelShiftOne       =>  si_SelShiftOne,
            i_SelShiftTwo       => si_SelShiftTwo,
            i_SelShiftFour      => si_SelShiftFour,
            i_SelShiftEight     => si_SelShiftEight,
            i_SelShiftSixteen   => si_SelShiftSixteen,
            i_Zero	        => si_Zero, 
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

    
    si_InputBits  <= "11111111111111111111111111111111";      
    si_SelShiftOne <= '1';  	
    si_SelShiftTwo <= '1'; 	
    si_SelShiftFour <= '1';
    si_SelShiftEight <= '1'; 
    si_SelShiftSixteen <= '1'; 	
    si_Zero <= '0';
    wait for gCLK_HPER*2;
  

    si_InputBits  <= "11111000000000000000000000000000";      
    si_SelShiftOne <= '1';  	
    si_SelShiftTwo <= '1'; 	
    si_SelShiftFour <= '0';
    si_SelShiftEight <= '0'; 
    si_SelShiftSixteen <= '0'; 	
    si_Zero <= '0';
    wait for gCLK_HPER*2;



    si_InputBits  <= "10000000000000000000000000000000";          
    si_SelShiftOne <= '0';  	
    si_SelShiftTwo <= '0'; 	
    si_SelShiftFour <= '0';
    si_SelShiftEight <= '1'; 
    si_SelShiftSixteen <= '0'; 	
    si_Zero <= '0';
    wait for gCLK_HPER*2;



    si_InputBits  <= "10000000000000000000000000000000";      
    si_SelShiftOne <= '0';  	
    si_SelShiftTwo <= '0'; 	
    si_SelShiftFour <= '0';
    si_SelShiftEight <= '0'; 
    si_SelShiftSixteen <= '1'; 	
    si_Zero <= '0';
    wait for gCLK_HPER*2;


   
    wait;
  end process;

end mixed;