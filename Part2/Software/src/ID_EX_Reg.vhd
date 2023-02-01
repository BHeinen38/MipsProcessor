-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity ID_EX_reg is
	port(i_CLK		        : in std_logic; 
	     i_RST		        : in std_logic; 
	     i_PC_4		        : in std_logic_vector(31 downto 0); --
	     i_readData1 	    : in std_logic_vector(31 downto 0); --
	     i_readData2 	    : in std_logic_vector(31 downto 0); --
	     i_signExtender 	: in std_logic_vector(31 downto 0);--
	     i_jumpAddr 	    : in std_logic_vector(31 downto 0);--
	     i_Inst_20_16 	    : in std_logic_vector(4 downto 0);--
	     i_Inst_15_11 	    : in std_logic_vector(4 downto 0);--
         i_Inst_5_0         : in std_logic_vector(5 downto 0);--
	     
          --control logic   
            i_AluOPSignal    	: in std_logic_vector(3 downto 0);
            i_JumpSignal	    : in std_logic;
            i_BranchSignal		: in std_logic;
           i_BranchNotSignal	: in std_logic;
            i_MemRegSignal		: in std_logic;
            i_MemWriteSignal	: in std_logic;
            i_ALUSrcSignal		: in std_logic;
            i_RegWrteSignal	    : in std_logic;
            i_JALSignal         : in std_logic;
            i_JRSignal          : in std_logic;
            i_RegDstSignal		: in std_logic;
            i_Reg31DstSignal	: in std_logic;
            i_haltSignal        : in std_logic;
            --i_SignExt         : in std_logic;

	     o_PC_4		    : out std_logic_vector(31 downto 0);
	     o_readData1 	: out std_logic_vector(31 downto 0);
	     o_readData2 	: out std_logic_vector(31 downto 0);
	     o_signExtender	: out std_logic_vector(31 downto 0);
	     o_jumpAddr 	: out std_logic_vector(31 downto 0);
	     o_Inst_20_16 	: out std_logic_vector(4 downto 0);
	     o_Inst_15_11 	: out std_logic_vector(4 downto 0);
         o_Inst_5_0     : out std_logic_vector(5 downto 0);
        
	     --o_control_bits 	: out std_logic_vector(14 downto 0));

            
            o_AluOPSignal    	: out std_logic_vector(3 downto 0); -- This is the operational control for the alu controller
            o_JumpSignal		  : out std_logic;
            o_BranchSignal		: out std_logic;
            o_BranchNotSignal		: out std_logic;
            o_MemRegSignal		: out std_logic;
            o_MemWriteSignal	: out std_logic;
            o_ALUSrcSignal		: out std_logic;
            o_RegWrteSignal	  : out std_logic;
            o_JALSignal       : out std_logic;
            o_JRSignal        : out std_logic;
            o_RegDstSignal		: out std_logic;
            o_Reg31DstSignal		: out std_logic;
            o_haltSignal      : out std_logic);
            --o_SignExt   : out std_logic);
end ID_EX_reg;

-- architecture
architecture structural of ID_EX_reg is

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
	generic map(N => 32) --this is good 
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_PC_4,
		 o_Q	=> o_PC_4);

  x2: dffg_N
	generic map(N => 32) --this is good 
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_readData1,
		 o_Q	=> o_readData1);

  x3: dffg_N
	generic map(N => 32) --this is good 
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_readData2,
		 o_Q	=> o_readData2);

    x3_1: dffg_N
    generic map(N => 32) --this is good 
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> '1',
        i_D	=> i_jumpAddr,
        o_Q	=> o_jumpAddr);

  x4: dffg_N
	generic map(N => 32) --this is good 
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_signExtender,
		 o_Q	=> o_signExtender);

   x5: dffg_N
    generic map(N => 5)
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> '1',
        i_D	=> i_Inst_20_16,
        o_Q	=> o_Inst_20_16);
     
   x6: dffg_N
    generic map(N => 5)
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> '1',
        i_D	=> i_Inst_15_11,
        o_Q	=> o_Inst_15_11);

    x22: dffg_N
    generic map(N => 6)
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> '1',
        i_D	=> i_Inst_5_0,
        o_Q	=> o_Inst_5_0);

   x7: dffg_N
    generic map(N => 4)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_AluOPSignal,
            o_Q	=> o_AluOPSignal);

    x8: dffg      
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_JumpSignal,
            o_Q	=> o_JumpSignal);

    x9: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_BranchSignal,
            o_Q	=> o_BranchSignal);

   x10: dffg
	--generic map(N => 1)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=> i_BranchNotSignal,
		 o_Q	=> o_BranchNotSignal);

    x11: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> '1',
        i_D	=> i_MemRegSignal,
        o_Q	=> o_MemRegSignal);

    x12: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_MemWriteSignal,
            o_Q	=> o_MemWriteSignal);

    x13: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_ALUSrcSignal,
            o_Q	=> o_ALUSrcSignal);

    x14: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_RegWrteSignal,
            o_Q	=> o_RegWrteSignal);

    x15: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_JALSignal,
            o_Q	=> o_JALSignal);
    
    x16: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_JRSignal,
            o_Q	=> o_JRSignal);

    x17: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=> i_RegDstSignal,
            o_Q	=> o_RegDstSignal);

    x18: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> '1',
            i_D	=>  i_Reg31DstSignal,
            o_Q	=>  o_Reg31DstSignal);
		
  x19: dffg
	--generic map(N => 1)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> '1',
		 i_D	=>  i_haltSignal,
		 o_Q	=>  o_haltSignal);



end structural;

            
            
            

           
            