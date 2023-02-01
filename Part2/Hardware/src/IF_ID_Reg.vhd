library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity IF_ID_reg is
	port(i_CLK		: in std_logic;
	     i_RST		: in std_logic; -- (1 sets reg to 0)
			 i_Flush	: in std_logic;
       i_Stall  : in std_logic;
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

  component mux2to1_N is 
    generic(N : integer := 32);
      port (
        i_D0   : in  std_logic_vector(N-1 downto 0);
        i_D1   : in  std_logic_vector(N-1 downto 0);
        i_S    : in  std_logic;
        o_O    : out std_logic_vector(N-1 downto 0));
  end component;

  component invg is
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;

	signal s_PC_4, s_Inst : std_logic_vector(31 downto 0);

  signal s_Stall_Not : std_logic;

begin

  not0: invg port map (
    i_A => i_Stall,
    o_F => s_Stall_Not);

  mux0: mux2to1_N generic map (N => 32) port map (i_S => i_Flush, i_D1 => x"00000000", i_D0 => i_PC_4, o_O => s_PC_4);
  mux1: mux2to1_N generic map (N => 32) port map (i_S => i_Flush, i_D1 => x"00000000", i_D0 => i_Inst, o_O => s_Inst);



  x1: dffg_N
	generic map(N => 32)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> s_Stall_Not,
		 i_D	=> s_PC_4,
		 o_Q	=> o_PC_4);

  x2: dffg_N
	generic map(N => 32)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> s_Stall_Not,
		 i_D	=> s_Inst,
		 o_Q	=> o_Inst);
		
end structural;