library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity IF_ID_reg is
	port(i_CLK		: in std_logic;
	     i_RST		: in std_logic; -- (1 sets reg to 0)
	     i_PC_4		: in std_logic_vector(31 downto 0);
	     i_Inst  	: in std_logic_vector(31 downto 0);
	     o_PC_4	  	: out std_logic_vector(31 downto 0);
	     o_Inst	: out std_logic_vector(31 downto 0));
end IF_ID_reg;

-- architecture
architecture structural of IF_ID_reg is

  component dffg_N is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;    
       i_RST        : in std_logic;     
       i_WE         : in std_logic;     
       i_D          : in std_logic_vector(N-1 downto 0);     
       o_Q          : out std_logic_vector(N-1 downto 0));   
  end component;

begin

  x1: dffg_N
	generic map(N => 32)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_PC_4,
		 o_Q	=> o_PC_4);

  x2: dffg_N
	generic map(N => 32)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_Inst,
		 o_Q	=> o_Inst);
		
end structural;