library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
               
use std.textio.all;             


entity tb_Control_Logic is
  generic(gCLK_HPER   : time := 10 ns);   
end tb_Control_Logic;

architecture mixed of tb_Control_Logic is


constant cCLK_PER  : time := gCLK_HPER * 2;


component Control_Logic is

  port(i_RegOpCode      : in std_logic_vector(5 downto 0); --this is the op code
       o_AluOP    	: out std_logic_vector(3 downto 0); -- This is the operational control for the alu controller
       o_Jump		: out std_logic;
       o_Branch		: out std_logic;
       o_MemReg		: out std_logic;
       o_MemWrite	: out std_logic;
       o_ALUSrc		: out std_logic;
       o_RegWrte	: out std_logic;
       o_RegDst		: out std_logic);

end component;


signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.

signal si_RegOpCode  : std_logic_vector(5 downto 0) := "000000";      
signal so_AluOP      : std_logic_vector(3 downto 0) := "0000";    	
signal so_Jump       : std_logic := '0';		
signal so_Branch     : std_logic := '0';		
signal so_MemReg     : std_logic := '0';	
signal so_MemWrite   : std_logic := '0';
signal so_ALUSrc     : std_logic := '0';		
signal so_RegWrte    : std_logic := '0';
signal so_RegDst     : std_logic := '0';	

begin

  DUT0: Control_Logic
  port map(
            i_RegOpCode  => si_RegOpCode,
	    o_AluOP      =>  so_AluOP,
            o_Jump      => so_Jump,
            o_Branch    => so_Branch,
            o_MemReg    => so_MemReg,
            o_MemWrite => so_MemWrite,
            o_ALUSrc   => so_ALUSrc, 
            o_RegWrte   => so_RegWrte,
            o_RegDst   => so_RegDst);


  
  
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

    
    si_RegOpCode <= "001000";  
    wait for gCLK_HPER*2;
  

    si_RegOpCode <= "001001";
    wait for gCLK_HPER*2;

   si_RegOpCode <= "000000";
    wait for gCLK_HPER*2;

si_RegOpCode <= "000010";
    wait for gCLK_HPER*2;
    
si_RegOpCode <= "000011";
    wait for gCLK_HPER*2;
    -- Expect: o_Y output signal to be 85 = 3*10+25 and o_X output signal to be 3 after two positive edge of clock.
   
    
  end process;

end mixed;