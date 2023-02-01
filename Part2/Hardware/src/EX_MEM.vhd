library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity EX_MEM_reg is
	port(	i_CLK		        : in std_logic;
	     	i_RST		        : in std_logic; 
	     	i_secondAddOut	    : in std_logic_vector(31 downto 0);--
      	i_jumpAddr         : in std_logic_vector(31 downto 0);--
	     	i_readData2 	    : in std_logic_vector(31 downto 0);----
	     	i_aluOutput	    : in std_logic_vector(31 downto 0);----
	     	i_RWA    : in std_logic_vector(4 downto 0);----

        --D-flip flop one bits
	     i_ALUzero		    : in std_logic;
	     --i_overflow		    : in std_logic; --this will be needed for the slt and others
         i_JumpSignal		: in std_logic; --same 
         i_BranchSignal		: in std_logic;
         i_BranchNotSignal	: in std_logic;
         i_MemRegSignal		: in std_logic;
         i_MemWriteSignal	: in std_logic;
         i_RegWrteSignal	: in std_logic;
         i_JALSignal        : in std_logic;
         i_JRSignal         : in std_logic;
         i_haltSignal       : in std_logic;
				 i_Inst							: in std_logic_vector(31 downto 0);
				 i_PC								: in std_logic_vector(31 downto 0);

				o_Inst								: out std_logic_vector(31 downto 0);
				o_PC								: out std_logic_vector(31 downto 0);
	     	o_secondAddout		    : out std_logic_vector(31 downto 0);
      	o_readData2 	        : out std_logic_vector(31 downto 0);
	     	o_jumpAddr 	        : out std_logic_vector(31 downto 0);
	     	o_aluOutput	 	    : out std_logic_vector(31 downto 0);
	     	o_RWA 	    : out std_logic_vector(4 downto 0);

	-- one bit outputs
	     o_ALUzero		        : out std_logic;
	     --o_overflow		: out std_logic;
	     o_JumpSignal           : out std_logic; --
         o_BranchSignal         : out std_logic; --
         o_BranchNotSignal      : out std_logic; --
         o_MemRegSignal         : out std_logic; --
         o_MemWriteSignal       : out std_logic; --
         o_RegWrteSignal        : out std_logic;  --
         o_JALSignal            : out std_logic;
         o_JRSignal             : out std_logic;
         o_haltSignal           : out std_logic);

end EX_MEM_reg;

-- architecture
architecture structural of EX_MEM_reg is

  component dffg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
  end component;

  component dffg_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;

begin

  x1: dffg_N
	generic map(N => 32)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_secondAddOut,
		 o_Q	=> o_secondAddOut);

    x1_2: dffg_N
    generic map(N => 32)
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> '1',
        i_D	=> i_jumpAddr,
        o_Q	=> o_jumpAddr);

  x2: dffg_N
	generic map(N => 32)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_readData2,
		 o_Q	=> o_readData2);

  x3: dffg_N
	generic map(N => 32)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_aluOutput,
		 o_Q	=> o_aluOutput);

  x4: dffg_N
	generic map(N => 5)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_RWA,
		 o_Q	=> o_RWA);

  x5: dffg
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_ALUzero,
		 o_Q	=> o_ALUzero);

--   x6: dffg
-- 	port map(i_CLK 	=> i_CLK, --this will be needed for the updated alu 
-- 		 i_RST 	=> i_RST,
-- 		 i_WE	=> '1',
-- 		 i_D	=> i_overflow,
-- 		 o_Q	=> o_overflow);

  x7: dffg
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_JumpSignal,
		 o_Q	=> o_JumpSignal);

  x8: dffg
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_BranchSignal,
		 o_Q	=> o_BranchSignal);

  x9: dffg
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_BranchNotSignal,
		 o_Q	=> o_BranchNotSignal);

  x10: dffg
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_MemRegSignal,
		 o_Q	=> o_MemRegSignal);

  x11: dffg
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_MemWriteSignal,
		 o_Q	=> o_MemWriteSignal);

  x12: dffg
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_RegWrteSignal,
		 o_Q	=> o_RegWrteSignal);

  x13: dffg
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_JALSignal,
		 o_Q	=> o_JALSignal);

   x14: dffg
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> '1',
        i_D	=> i_JRSignal,
        o_Q	=> o_JRSignal);
        
   x15: dffg
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> '1',
        i_D	=> i_haltSignal,
        o_Q	=> o_haltSignal);

	x16: dffg_N
	generic map(N => 32)
		port map(i_CLK 	=> i_CLK,
				i_RST 	=> i_RST,
				i_WE	=> '1',
				i_D	=> i_Inst,
				o_Q	=> o_Inst);

	x17: dffg_N 
	generic map(N => 32)
	port map(i_CLK 	=> i_CLK,
			i_RST 	=> i_RST,
			i_WE	=> '1',
			i_D	=> i_PC,
			o_Q	=> o_PC);

end structural;