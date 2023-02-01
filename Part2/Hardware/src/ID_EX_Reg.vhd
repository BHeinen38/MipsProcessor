-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity ID_EX_reg is
	port(
      i_CLK		          : in std_logic; 
      i_RST		          : in std_logic; 
      i_Flush		        : in std_logic; 
      i_Stall           : in std_logic;
      i_PC_4		        : in std_logic_vector(31 downto 0); --
      i_readData1 	    : in std_logic_vector(31 downto 0); --
      i_readData2 	    : in std_logic_vector(31 downto 0); --
      i_signExtender 	  : in std_logic_vector(31 downto 0);--
      i_jumpAddr 	      : in std_logic_vector(31 downto 0);--
      i_Inst 	          : in std_logic_vector(31 downto 0);
	     
      --control logic   
      i_AluOPSignal    	: in std_logic_vector(3 downto 0);
      i_JumpSignal	    : in std_logic;
      i_BranchSignal		: in std_logic;
      i_BranchNotSignal	: in std_logic;
      i_MemRegSignal		: in std_logic;
      i_MemWriteSignal	: in std_logic;
      i_ALUSrcSignal		: in std_logic;
      i_RegWrteSignal	  : in std_logic;
      i_JALSignal       : in std_logic;
      i_JRSignal        : in std_logic;
      i_haltSignal      : in std_logic;
      i_RWA             : in std_logic_vector(4 downto 0);


	     o_PC_4		: out std_logic_vector(31 downto 0);
	     o_readData1 	: out std_logic_vector(31 downto 0);
	     o_readData2 	: out std_logic_vector(31 downto 0);
	     o_signExtender	: out std_logic_vector(31 downto 0);
	     o_jumpAddr 	: out std_logic_vector(31 downto 0);
	     o_Inst 	        : out std_logic_vector(31 downto 0);
       o_RWA    : out std_logic_vector(4 downto 0);----
        
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
            o_haltSignal      : out std_logic);
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

  component invg is
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;

  component andg2 is
    port(
      i_A          : in std_logic;
      i_B          : in std_logic;
      o_F          : out std_logic);
  end component;

  component mux2to1_N is 
    generic(N : integer := 32);
      port (
        i_D0   : in  std_logic_vector(N-1 downto 0);
        i_D1   : in  std_logic_vector(N-1 downto 0);
        i_S    : in  std_logic;
        o_O    : out std_logic_vector(N-1 downto 0));
  end component;


  signal s_PC_4		        : std_logic_vector(31 downto 0); --
  signal s_readData1 	    : std_logic_vector(31 downto 0); --
  signal s_readData2 	    : std_logic_vector(31 downto 0); --
  signal s_signExtender 	: std_logic_vector(31 downto 0);--
  signal s_jumpAddr 	    : std_logic_vector(31 downto 0);--
  signal s_Inst 	        : std_logic_vector(31 downto 0);
  signal s_RWA            : std_logic_vector(4 downto 0);
  signal s_AluOPSignal    : std_logic_vector(3 downto 0);
  signal s_JumpSignal	    : std_logic;
  signal s_BranchSignal		: std_logic;
  signal s_BranchNotSignal  : std_logic;
  signal s_MemRegSignal		: std_logic;
  signal s_MemWriteSignal	: std_logic;
  signal s_ALUSrcSignal		: std_logic;
  signal s_RegWrteSignal	: std_logic;
  signal s_JALSignal      : std_logic;
  signal s_JRSignal       : std_logic;
  signal s_haltSignal     : std_logic;
  
  signal s_Flush_Not     : std_logic;
  signal s_Stall_Not     : std_logic;

begin

  not0: invg port map (
    i_A => i_Flush,
    o_F => s_Flush_Not);

  not1: invg port map (
    i_A => i_Stall,
    o_F => s_Stall_Not);
  

  mux0: mux2to1_N generic map (N => 32) port map (i_S => i_Flush, i_D1 => x"00000000", i_D0 => i_PC_4, o_O => s_PC_4);
  mux1: mux2to1_N generic map (N => 32) port map (i_S => i_Flush, i_D1 => x"00000000", i_D0 => i_readData1, o_O => s_readData1);
  mux2: mux2to1_N generic map (N => 32) port map (i_S => i_Flush, i_D1 => x"00000000", i_D0 => i_readData2, o_O => s_readData2);
  mux3: mux2to1_N generic map (N => 32) port map (i_S => i_Flush, i_D1 => x"00000000", i_D0 => i_signExtender, o_O => s_signExtender);
  mux4: mux2to1_N generic map (N => 32) port map (i_S => i_Flush, i_D1 => x"00000000", i_D0 => i_jumpAddr, o_O => s_jumpAddr);
  mux5: mux2to1_N generic map (N => 32) port map (i_S => i_Flush, i_D1 => x"00000000", i_D0 => i_Inst, o_O => s_Inst);
  mux6: mux2to1_N generic map (N => 5) port map (i_S => i_Flush, i_D1 => "00000", i_D0 => i_RWA, o_O => s_RWA);
  mux7: mux2to1_N generic map (N => 4) port map (i_S => i_Flush, i_D1 => "0000", i_D0 => i_AluOPSignal, o_O => s_AluOPSignal);

  and0: andg2 port map (i_A => s_Flush_Not, i_B => i_JumpSignal, o_F => s_JumpSignal);
  and1: andg2 port map (i_A => s_Flush_Not, i_B => i_BranchSignal, o_F => s_BranchSignal);
  and2: andg2 port map (i_A => s_Flush_Not, i_B => i_BranchNotSignal, o_F => s_BranchNotSignal);
  and3: andg2 port map (i_A => s_Flush_Not, i_B => i_MemRegSignal, o_F => s_MemRegSignal);
  and4: andg2 port map (i_A => s_Flush_Not, i_B => i_MemWriteSignal, o_F => s_MemWriteSignal);
  and5: andg2 port map (i_A => s_Flush_Not, i_B => i_ALUSrcSignal, o_F => s_ALUSrcSignal);
  and6: andg2 port map (i_A => s_Flush_Not, i_B => i_RegWrteSignal, o_F => s_RegWrteSignal);
  and7: andg2 port map (i_A => s_Flush_Not, i_B => i_JALSignal, o_F => s_JALSignal);
  and8: andg2 port map (i_A => s_Flush_Not, i_B => i_JRSignal, o_F => s_JRSignal);
  and9: andg2 port map (i_A => s_Flush_Not, i_B => i_haltSignal, o_F => s_haltSignal);


  x1: dffg_N
	generic map(N => 32) --this is good 
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> s_Stall_Not,
		 i_D => s_PC_4,
		 o_Q	=> o_PC_4);

  x2: dffg_N
	generic map(N => 32) --this is good 
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> s_Stall_Not,
		 i_D => s_readData1,
		 o_Q	=> o_readData1);

  x3: dffg_N
	generic map(N => 32) --this is good 
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> s_Stall_Not,
		 i_D => s_readData2,
		 o_Q	=> o_readData2);

    x3_1: dffg_N
    generic map(N => 32) --this is good 
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> s_Stall_Not,
        i_D => s_jumpAddr,
        o_Q	=> o_jumpAddr);

  x4: dffg_N
	generic map(N => 32) --this is good 
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> s_Stall_Not,
		 i_D => s_signExtender,
		 o_Q	=> o_signExtender);

   x5: dffg_N
    generic map(N => 32)
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> s_Stall_Not,
        i_D => s_Inst,
        o_Q	=> o_Inst);

   x7: dffg_N
    generic map(N => 4)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_AluOPSignal,
            o_Q	=> o_AluOPSignal);

    x8: dffg      
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_JumpSignal,
            o_Q	=> o_JumpSignal);

    x9: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_BranchSignal,
            o_Q	=> o_BranchSignal);

   x10: dffg
	--generic map(N => 1)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> s_Stall_Not,
		 i_D => s_BranchNotSignal,
		 o_Q	=> o_BranchNotSignal);

    x11: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
        i_RST 	=> i_RST,
        i_WE	=> s_Stall_Not,
        i_D => s_MemRegSignal,
        o_Q	=> o_MemRegSignal);

    x12: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_MemWriteSignal,
            o_Q	=> o_MemWriteSignal);

    x13: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_ALUSrcSignal,
            o_Q	=> o_ALUSrcSignal);

    x14: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_RegWrteSignal,
            o_Q	=> o_RegWrteSignal);

    x15: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_JALSignal,
            o_Q	=> o_JALSignal);
    
    x16: dffg
    --generic map(N => 1)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_JRSignal,
            o_Q	=> o_JRSignal);

    x17: dffg_N
    generic map(N => 5)
    port map(i_CLK 	=> i_CLK,
            i_RST 	=> i_RST,
            i_WE	=> s_Stall_Not,
            i_D => s_RWA,
            o_Q	=> o_RWA);
		
  x19: dffg
	--generic map(N => 1)
	port map(i_CLK 	=> i_CLK,
		 i_RST 	=> i_RST,
		 i_WE	=> s_Stall_Not,
		 i_D => s_haltSignal,
		 o_Q	=>  o_haltSignal);



end structural;

            
            
            

           
            