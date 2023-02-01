-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
  iRST            : in std_logic;
  iInstLd         : in std_logic;
  iInstAddr       : in std_logic_vector(N-1 downto 0);
  iInstExt        : in std_logic_vector(N-1 downto 0);
  oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.
end  MIPS_Processor;


architecture structure of MIPS_Processor is
  
  -- Ordered from MOST to LEAST important
  
  signal s_stall              : std_logic;
  
  signal s_ID_RWE           : std_logic;
  signal s_ID_RWA           : std_logic_vector(4 downto 0);
  signal s_EX_RWE           : std_logic;
  signal s_EX_RWA           : std_logic_vector(4 downto 0);
  signal s_MEM_RWE          : std_logic;
  signal s_MEM_RWA          : std_logic_vector(4 downto 0);
  
  signal s_NextInstAddr   : std_logic_vector(N-1 downto 0); -- use this signal as your intended final instruction memory address input.
  signal s_InstOrNOP      : std_logic_vector(N-1 downto 0);
  signal s_ID_PC          : std_logic_vector(N-1 downto 0);
  signal s_Inst           : std_logic_vector(N-1 downto 0); -- use this signal as the instruction signal 
  signal s_EX_PC          : std_logic_vector(N-1 downto 0);
  signal s_EX_Inst        : std_logic_vector(N-1 downto 0);
  signal s_MEM_PC         : std_logic_vector(N-1 downto 0);
  signal s_MEM_Inst       : std_logic_vector(N-1 downto 0);
  signal s_WB_PC          : std_logic_vector(N-1 downto 0);
  signal s_WB_Inst        : std_logic_vector(N-1 downto 0);
  
  
  -- Required instruction memory signals
  signal s_IMemAddr                 : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_Pre_Inst                 : std_logic_vector(N-1 downto 0);
  signal s_NextInstAddrPlus4        : std_logic_vector(N-1 downto 0);
  -- signal s_LockNextInstAddr   : std_logic_vector(N-1 downto 0);
  signal s_FinalNextInstAddr        : std_logic_vector(N-1 downto 0);
  signal s_JumpLeftShiftUnclipped   : std_logic_vector(N-1 downto 0);
  signal s_forward1 , s_forward2    : std_logic;
  signal s_F_ID_D0, s_F_ID_D1       : std_logic_vector(N-1 downto 0); 
  -- signal s_PC_Stall                 : std_logic_vector(N-1 downto 0); 
  
  -- Required halt signal -- for simulation
  signal s_Halt : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  -- IF/ID
  signal s_IF_RST           : std_logic;
  signal s_ID_ALUOP         : std_logic_vector(3 downto 0);
  signal s_ID_ALUSrc        : std_logic;
  signal s_ID_MWE           : std_logic;
  signal s_ID_Branch        : std_logic;
  signal s_ID_BranchNot     : std_logic;
  signal s_ID_MemReg        : std_logic;
  signal s_ID_Jump          : std_logic;
  signal s_ID_Jal           : std_logic;
  signal s_ID_JR            : std_logic;
  signal s_ID_D0            : std_logic_vector(31 downto 0); --output of register A
  signal s_ID_D1            : std_logic_vector(31 downto 0); --output of register B
  signal s_ID_Ext           : std_logic_vector(31 downto 0);
  signal s_ID_JumpAddr      : std_logic_vector(31 downto 0);
  signal s_ID_JumpAndLink   : std_logic_vector(31 downto 0);
  signal s_ID_RegDst_Pre    : std_logic;
  signal s_ID_RegDst_31     : std_logic; --this could potentially cause errors 
  signal s_ID_Halt          : std_logic;

  -- ID/EX
  signal s_EX_ALUOP         : std_logic_vector(3 downto 0);
  signal s_EX_ALUOUT	      : std_logic_vector(31 downto 0);
  signal s_EX_ALUSrc        : std_logic;
  signal s_DMemWr           : std_logic; -- use this signal as the final active high data memory write enable signal 
  signal s_EX_MWE           : std_logic;
  signal s_EX_Branch        : std_logic;  
  signal s_EX_BranchNot     : std_logic; 
  signal s_EX_MemReg        : std_logic;
  signal s_EX_Jump          : std_logic;   
  signal s_EX_Jal           : std_logic;
  signal s_EX_JR            : std_logic;
  signal s_EX_D0            : std_logic_vector(31 downto 0);
  signal s_EX_D1            : std_logic_vector(31 downto 0);
  signal s_EX_Ext           : std_logic_vector(31 downto 0);
  signal s_EX_JumpAddr      : std_logic_vector(31 downto 0); 
  signal s_EX_branchAddOut  : std_logic_vector(31 downto 0);
  -- signal s_EX_RegDst        : std_logic;
  -- signal s_EX_Reg31Dst      : std_logic;

  signal s_EX_Halt          : std_logic;
  
  -- EX/MEM
  signal s_MEM_Branch     : std_logic;  
  signal s_MEM_BranchNot  : std_logic; 
  signal s_MEM_MemReg     : std_logic;
  signal s_MEM_Jump       : std_logic;
  signal s_MEM_Jal        : std_logic;
  signal s_MEM_Jr         : std_logic;
  signal s_MEM_JumpAddr   : std_logic_vector(N-1 downto 0);
  signal s_MEM_BranchAdr  : std_logic_vector(N-1 downto 0);
  signal s_MEM_DM         : std_logic_vector(N-1 downto 0);
  signal s_MEM_DMA        : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_MEM_OneBitOut  : std_logic;
  signal s_MEM_Halt       : std_logic;
  
  
  -- MEM/WB
  signal s_WB_MemReg  : std_logic;  --s_WB_MemReg
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file -- I think I created a signal so we do not need this.  BH
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RWA_Pre      : std_logic_vector(4 downto 0);
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_WB_Jump    : std_logic;  --s_WB_Jump
  signal s_WB_Jal     : std_logic;  --s_WB_Jal
  signal s_WB_JR      : std_logic;  --s_WB_JR
  signal s_WB_JumpAdr : std_logic_vector(N-1 downto 0);
  signal s_DMemAddr   : std_logic_vector(N-1 downto 0);

  signal s_S_AndGateOut     : std_logic;
  signal s_S_AndGateOutTwo  : std_logic;
  signal s_BranchSel        : std_logic;
  signal s_ALU_B            : std_logic_vector(N-1 downto 0); --this is the input of Alu B 
  signal s_SignExt          : std_logic;
  signal s_OneBitOut        : std_logic;


  --Required signals from the Instruction Fetch with Jumps block --
  signal s_ImShift        : std_logic_vector(N-1 downto 0);
  signal s_Mux_Branch     : std_logic_vector(N-1 downto 0);
  signal s_RegWrDataFinal : std_logic_vector(N-1 downto 0);
  signal s_JumpLeftShift  : std_logic_vector(27 downto 0);
  signal s_AluSel         : std_logic_vector(3 downto 0);
  
  -- TODO check this out
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input -- this could be potentially wrong.
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
  
  -- Required register file signals 
  signal s_Throw        : std_logic;
  

-- END OF SIGNALS
--#######################################################################################################
--#######################################################################################################
--#######################################################################################################
--#######################################################################################################
-- START OF COMPONENTS

 
  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
      clk          : in std_logic;
      addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
      data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
      we           : in std_logic := '1';
      q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  component ALU_contr is
    port(
    i_Funct:	in std_logic_vector(5 downto 0);
		i_ALUOP:	in std_logic_vector(3 downto 0);
		o_Op:	out std_logic_vector(3 downto 0));
  end component;

  component ALU is 
    port(
    i_A           : in std_logic_vector(31 downto 0);		  -- Read register A
    i_B           : in std_logic_vector(31 downto 0);		  -- Read register B
    i_ALUSelect   : in std_logic_vector(3 downto 0);	    -- Immediate                --this can not be here 
    o_F	          : out std_logic_vector(31 downto 0);		-- Output w/out carry
    o_Zero        : out std_logic);                       -- Output if o_F == zero
  end component;

  component barrelShifter is 
    generic(N : integer := 32); -- Generic of type integer for input/output data width.
      port(
        i_InputBits       : in std_logic_vector(N-1 downto 0);
        i_S_Shift	        : in std_logic_vector(4 downto 0);
        i_S_Dir           : in std_logic;
        i_Zero 		        : in std_logic;
        o_OutputBits      : out std_logic_vector(N-1 downto 0));
  end component;
  
  component Control_Logic is 
    port(
      i_RegOpCode : in std_logic_vector(5 downto 0);  --this is the op code
      i_funct : in std_logic_vector(5 downto 0);  --this is the funct code
      o_ALUOP    	: out std_logic_vector(3 downto 0); -- This is the operational control for the alu controller
      o_Jump		  : out std_logic;
      o_Branch		: out std_logic;
      o_BranchNot		: out std_logic;
      o_MemReg		: out std_logic;
      o_MemWrite	: out std_logic;
      o_ALUSrc		: out std_logic;
      o_RegWrte	  : out std_logic;
      o_JAL       : out std_logic;
      o_JR        : out std_logic;
      o_RegDst		: out std_logic;
      o_Reg31Dst		: out std_logic;
      o_halt      : out std_logic;
      o_SignExt   : out std_logic);
  end component;

  component fetchLogic is 
    port(
      i_CLK       : in std_logic;                       -- Clock
      i_RST       : in std_logic;
      i_EN_NOT       : in std_logic;
      i_PC        : in std_logic_vector(31 downto 0);
      o_PCNext        : out std_logic_vector(31 downto 0);
	    o_PC        : out std_logic_vector(31 downto 0));
  end component;

  component registerFile is
    port (
      i_D          : in std_logic_vector(31 downto 0);  -- Input data
      i_WA         : in std_logic_vector(4 downto 0);		-- Write address
      i_WE         : in std_logic;				              -- Write enable
      i_RA0        : in std_logic_vector(4 downto 0);	  -- Read address 0
      i_RA1        : in std_logic_vector(4 downto 0);	  -- Read address 1
      i_CLK        : in std_logic;				              -- Clock
      i_RST        : in std_logic;				              -- Reset
      o_D0         : out std_logic_vector(31 downto 0);	-- Output data 0
      o_D1         : out std_logic_vector(31 downto 0));  -- Output data 1
  end component;

  component mux2to1_N is 
    generic(N : integer := 32);
      port (
        i_D0   : in  std_logic_vector(N-1 downto 0);
        i_D1   : in  std_logic_vector(N-1 downto 0);
        i_S    : in  std_logic;
        o_O    : out std_logic_vector(N-1 downto 0));
  end component;

  component bitExtender is
    port(
      i_D          : in std_logic_vector(15 downto 0);      -- Data in
      i_S          : in std_logic;                          -- Switch 0 = signed 1 = unsigned
      o_F          : out std_logic_vector(31 downto 0));    -- Data out
  end component;

  component adder_N is
    generic (N : integer := 32);
    port( 
      i_A               : in std_logic_vector(N-1 downto 0);
      i_B               : in std_logic_vector(N-1 downto 0);
      i_C               : in std_logic;
      o_F               : out std_logic_vector(N-1 downto 0);
      o_C               : out std_logic);
  end component;
  
  component andg2 is
    port(
      i_A          : in std_logic;
      i_B          : in std_logic;
      o_F          : out std_logic);
  end component;

 	component org2 is

	  port(i_A          : in std_logic;
	       i_B          : in std_logic;
	       o_F          : out std_logic);

	end component;

component invg is

  port(i_A          : in std_logic;
       o_F          : out std_logic);


end component;

component IF_ID_reg is
	port(i_CLK		: in std_logic;
	     i_RST		: in std_logic; -- (1 sets reg to 0)
	     i_Flush	: in std_logic;
	     i_Stall	: in std_logic;
	     i_PC_4		: in std_logic_vector(31 downto 0);
	     i_Inst  	: in std_logic_vector(31 downto 0);
	     o_PC_4	  	: out std_logic_vector(31 downto 0);
	     o_Inst	: out std_logic_vector(31 downto 0));
end component;

component ID_EX_reg is port( 
        i_CLK		        : in std_logic; 
        i_RST		        : in std_logic; 
        i_Flush		        : in std_logic; 
        i_Stall		        : in std_logic; 
        i_RWA        : in std_logic_vector(4 downto 0);
        i_PC_4		        : in std_logic_vector(31 downto 0); --
        i_readData1 	    : in std_logic_vector(31 downto 0); --
        i_readData2 	    : in std_logic_vector(31 downto 0); --
        i_signExtender 	: in std_logic_vector(31 downto 0);--
        i_jumpAddr 	    : in std_logic_vector(31 downto 0);--
        i_Inst 	        : in std_logic_vector(31 downto 0);--
	     
        --control logic   
        i_ALUOPSignal    	: in std_logic_vector(3 downto 0);
        i_JumpSignal	    : in std_logic;
        i_BranchSignal		: in std_logic;
        i_BranchNotSignal	: in std_logic;
        i_MemRegSignal		: in std_logic;
        i_MemWriteSignal	: in std_logic;
        i_ALUSrcSignal		: in std_logic;
        i_RegWrteSignal	    : in std_logic;
        i_JALSignal         : in std_logic;
        i_JRSignal          : in std_logic;
        -- i_RegDstSignal		: in std_logic;
        -- i_Reg31DstSignal	: in std_logic;
        i_haltSignal        : in std_logic;
        --i_SignExt         : in std_logic;

       o_RWA        : out std_logic_vector(4 downto 0);
	     o_PC_4		    : out std_logic_vector(31 downto 0);
	     o_readData1 	: out std_logic_vector(31 downto 0);
	     o_readData2 	: out std_logic_vector(31 downto 0);
	     o_signExtender	: out std_logic_vector(31 downto 0);
	     o_jumpAddr 	: out std_logic_vector(31 downto 0);
	     o_Inst 	: out std_logic_vector(31 downto 0);
        
	     --o_control_bits 	: out std_logic_vector(14 downto 0));

            
    o_ALUOPSignal    	: out std_logic_vector(3 downto 0); -- This is the operational control for the alu controller
    o_JumpSignal		  : out std_logic;
    o_BranchSignal		: out std_logic;
    o_BranchNotSignal		: out std_logic;
    o_MemRegSignal		: out std_logic;
    o_MemWriteSignal	: out std_logic;
    o_ALUSrcSignal		: out std_logic;
    o_RegWrteSignal	  : out std_logic;
    o_JALSignal       : out std_logic;
    o_JRSignal        : out std_logic;
    -- o_RegDstSignal		: out std_logic;
    -- o_Reg31DstSignal		: out std_logic;
    o_haltSignal      : out std_logic);
    --o_SignExt   : out std_logic);
end component;

component EX_MEM_reg is
	port(i_CLK		        : in std_logic;
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
         i_PC              : in std_logic_vector(31 downto 0); 
         i_Inst            : in std_logic_vector(31 downto 0); 

         o_PC              : out std_logic_vector(31 downto 0); 
         o_Inst            : out std_logic_vector(31 downto 0); 
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

end component;

component MEM_WB_reg is
	port(i_CLK		        : in std_logic;
	     i_RST		        : in std_logic;
       i_jumpAddr 	    : in std_logic_vector(31 downto 0); --
	     i_readDataMEM 	    : in std_logic_vector(31 downto 0);
	     i_aluOutput	    : in std_logic_vector(31 downto 0);
	     i_RWA    : in std_logic_vector(4 downto 0);

        --D-flip flop one bits
	     
	     --i_overflow		    : in std_logic; --this will be needed for the slt and others
         i_JumpSignal		  : in std_logic; -- 
         i_MemRegSignal		: in std_logic;--
         i_RegWrteSignal	  : in std_logic; --
         i_JALSignal       : in std_logic;--
         i_JRSignal        : in std_logic;--
         i_haltSignal      : in std_logic;--
         i_PC              : in std_logic_vector(31 downto 0); 
         i_Inst            : in std_logic_vector(31 downto 0); 

         o_PC              : out std_logic_vector(31 downto 0); 
         o_Inst            : out std_logic_vector(31 downto 0); 
	     o_jumpAddr     	    : out std_logic_vector(31 downto 0); 
	     o_readDataMEM 	        : out std_logic_vector(31 downto 0);
	     o_aluOutput	 	    : out std_logic_vector(31 downto 0);
	     o_RWA 	    : out std_logic_vector(4 downto 0);

	-- one bit outputs
	     --o_overflow		: out std_logic;
	     o_JumpSignal           : out std_logic; --
         o_MemRegSignal         : out std_logic; --
         o_RegWrteSignal        : out std_logic;  --
         o_JALSignal            : out std_logic;
         o_JRSignal             :out std_logic;
         o_haltSignal           :out std_logic);

end component;

component Hazard_Control is
  port( i_ID_jump  	: in std_logic;
				i_EX_jump  	: in std_logic;
				i_MEM_jump  : in std_logic;
				i_WB_jump  	: in std_logic;

				i_branch  : in std_logic;

				i_IF_Opcode	: std_logic_vector(5 downto 0);

        i_RS	: std_logic_vector(4 downto 0);
				i_RT	: std_logic_vector(4 downto 0);

				i_ID_WA	: in std_logic_vector(4 downto 0); 
				i_EX_WA	: in std_logic_vector(4 downto 0);
				i_MEM_WA	: in std_logic_vector(4 downto 0);
			
				i_ID_WE	: in std_logic; 
				i_EX_WE	: in std_logic; 
				i_MEM_WE	: in std_logic; 
			
				o_stall	:	out std_logic);

end component;

component Forwarder is

  port( i_RA1  	  		: in std_logic_vector(4 downto 0);
				i_RA2	  			: in std_logic_vector(4 downto 0);

				i_WA	  			: in std_logic_vector(4 downto 0);
				i_WE      		: in std_logic;

				o_Forward1		: out std_logic;
				o_Forward2		: out std_logic);
end component;


-- END OF COMPONENTS
--#######################################################################################################
--#######################################################################################################
--#######################################################################################################
--#######################################################################################################
-- START OF WIRING


begin

  -- This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem generic map(ADDR_WIDTH => 10, DATA_WIDTH => N) port map(
    clk  => iCLK,
    addr => s_IMemAddr(11 downto 2),
    data => iInstExt,
    we   => iInstLd,
    q    => s_Pre_Inst); -- This was s_Inst
    -- It's muxed with NOP stall and then goes into the IF/ID Reg File (1st stage)

  DMem: mem generic map(ADDR_WIDTH => 10, DATA_WIDTH => N) port map(
    clk  => iCLK,
    addr => s_MEM_DMA(11 downto 2),
    data => s_DMemData,
    we   => s_DMemWr,
    q    => s_DMemOut);

--IF/ID stage
------------------------------------------------
 
  fetch: fetchLogic port map (
    i_CLK     => iCLK,
    i_RST     => iRST,
    i_EN_NOT  => s_Stall,
    i_PC      => s_FinalNextInstAddr,
    o_PC      => s_NextInstAddr,
    o_PCNext  => s_NextInstAddrPlus4);

  IFID: IF_ID_reg port map (
    i_CLK   => iCLK, 
    i_RST   => iRST, 
    i_Flush => s_Stall, 
    i_Stall => '0', 
    i_PC_4	=> s_NextInstAddr, 
    i_Inst  => s_InstOrNOP,
    o_PC_4	=> s_ID_PC,
    o_Inst	=> s_Inst);

  IDEX: ID_EX_reg port map(
    i_CLK => iCLK,
    i_RST => iRST,
    i_Flush => '0',
    i_Stall => '0', 
    i_PC_4	        => s_ID_PC,
    i_Inst          => s_Inst,  
    i_readData1     => s_F_ID_D0, 
    i_readData2     => s_F_ID_D1,
    i_signExtender  => s_ID_Ext,
    i_jumpAddr      => s_ID_JumpAddr, 	
  
    --control logic   
    i_ALUOPSignal     => s_ID_ALUOP,
    i_JumpSignal      => s_ID_Jump,	
    i_BranchSignal	  => s_ID_Branch,
    i_BranchNotSignal => s_ID_BranchNot,	
    i_MemRegSignal    => s_ID_MemReg,		
    i_MemWriteSignal  => s_ID_MWE, 	
    i_ALUSrcSignal    => s_ID_ALUSrc,
    i_RegWrteSignal	  => s_ID_RWE,    
    i_JALSignal       => s_ID_Jal,       
    i_JRSignal        => s_ID_JR,     
    i_haltSignal      => s_ID_Halt,   
    i_RWA   => s_ID_RWA,  

    o_RWA => s_EX_RWA,  
    o_PC_4	        => s_EX_PC,	  --this needs to be new output of pc +4   
    o_readData1     => s_EX_D0, 	
    o_readData2     => s_EX_D1, 	
    o_signExtender	=> s_EX_Ext,
    o_jumpAddr      => s_EX_JumpAddr,
    o_Inst          => s_EX_Inst,
        
    o_ALUOPSignal     => s_EX_ALUOP, 	
    o_JumpSignal	    => s_EX_Jump,
    o_BranchSignal		=> s_EX_Branch, 
    o_BranchNotSignal => s_EX_BranchNot, 
    o_MemRegSignal		=> s_EX_MemReg,
    o_MemWriteSignal	=> s_EX_MWE,
    o_ALUSrcSignal		=> s_EX_ALUSrc,
    o_RegWrteSignal	  => s_EX_RWE,
    o_JALSignal       => s_EX_Jal,
    o_JRSignal        => s_EX_JR,
    -- o_RegDstSignal	  => s_EX_RegDst,
    -- o_Reg31DstSignal	=> s_EX_Reg31Dst,
    o_haltSignal      => s_EX_Halt);
    --o_SignExt   );
    
  EXMEM: EX_MEM_reg port map (
    i_CLK => iCLK,
    i_RST	=> iRST,
    i_secondAddOut	=> s_EX_branchAddOut,  
    i_jumpAddr      => s_EX_JumpAddr,     
    i_readData2     => s_EX_D1,	  
    i_aluOutput     => s_EX_ALUOUT, 	   
    i_RWA => s_EX_RWA,  

    --D-flip flop one bits
    i_ALUzero => s_OneBitOut,
    --i_overflow		    
    i_JumpSignal	    => s_EX_Jump,	 
    i_BranchSignal	  => s_EX_Branch,  
    i_BranchNotSignal	=> s_EX_BranchNot,  
    i_MemRegSignal	  => s_EX_MemReg,
    i_MemWriteSignal	=> s_EX_MWE,
    i_RegWrteSignal   => s_EX_RWE,	
    i_JALSignal       => s_EX_Jal,   
    i_JRSignal        => s_EX_JR, 
    i_haltSignal      => s_EX_Halt,  
    i_PC            => s_EX_PC, 
    i_Inst          => s_EX_Inst, 

    o_Inst          => s_MEM_Inst, 
    o_PC            => s_MEM_PC,
    o_secondAddout	=> s_MEM_BranchAdr,	 
    o_readData2     => s_DMemData,  	    
    o_jumpAddr      => s_MEM_JumpAddr, 	      
    o_aluOutput     => s_MEM_DMA,	 	    
    o_RWA => s_MEM_RWA, --input	   

    -- one bit outputs
    o_ALUzero	=> s_MEM_OneBitOut,	       
    --o_overflow		
    o_JumpSignal      => s_MEM_Jump,        
    o_BranchSignal    => s_MEM_Branch,   
    o_BranchNotSignal => s_MEM_BranchNot,    
    o_MemRegSignal    => s_MEM_MemReg,     
    o_MemWriteSignal  => s_DMemWr,      
    o_RegWrteSignal   => s_MEM_RWE,       
    o_JALSignal       => s_MEM_Jal,           
    o_JRSignal        => s_MEM_Jr,          
    o_haltSignal      => s_MEM_Halt);

  MEMWB: MEM_WB_reg port map (
    i_CLK	=> iCLK,	       
    i_RST	=> iRST,	        
    i_jumpAddr 	      => s_MEM_JumpAddr,
    i_readDataMEM 	  => s_MEM_DM,   
    i_aluOutput	      => s_MEM_DMA,   
    i_RWA   => s_MEM_RWA,

    --D-flip flop one bits
            
    --i_overflow		    
    i_JumpSignal	  => s_MEM_Jump,	 
    i_MemRegSignal	=> s_MEM_MemReg,	
    i_RegWrteSignal => s_MEM_RWE,	  
    i_JALSignal     => s_MEM_Jal,    
    i_JRSignal      => s_MEM_Jr,     
    i_haltSignal    => s_MEM_Halt,    
    i_PC            => s_MEM_PC, 
    i_Inst          => s_MEM_Inst, 

    o_Inst          => s_WB_Inst, 
    o_PC            => s_WB_PC, 
    o_jumpAddr      => s_WB_JumpAdr, 	    
    o_readDataMEM 	=> s_DMemOut,        
    o_aluOutput	    => s_DMemAddr,  --this needs done 	  
    o_RWA           => s_RegWrAddr,

    -- one bit outputs
    o_JumpSignal    => s_WB_Jump,       
    o_MemRegSignal  => s_WB_MemReg,      
    o_RegWrteSignal => s_RegWr,    
    o_JALSignal     => s_WB_Jal,          
    o_JRSignal      => s_WB_JR,          
    o_haltSignal    => s_Halt);
    --o_overflow	
      
  
  -----------------------------------------------------------------
  -- IF/ID stage 

  control: Control_Logic port map (
    i_RegOpCode => s_Inst(31 downto 26),--
    i_funct     => s_Inst(5 downto 0),--
    o_ALUOP    	=> s_ID_ALUOP,
    o_Jump		  => s_ID_Jump,
    o_Branch		=> s_ID_Branch,
    o_BranchNot => s_ID_BranchNot,
    o_MemReg		=> s_ID_MemReg,
    o_MemWrite	=> s_ID_MWE,
    o_ALUSrc		=> s_ID_ALUSrc,
    o_JAL       => s_ID_Jal,
    o_JR        => s_ID_JR,
    o_RegWrte	  => s_ID_RWE,
    o_RegDst		=> s_ID_RegDst_Pre,
    o_Reg31Dst	=> s_ID_RegDst_31,
    o_halt      => s_ID_Halt,
    o_SignExt   => s_SignExt);

  regFile: registerFile port map (
    i_D          => s_RegWrData,
    i_WA         => s_RegWrAddr,
    i_WE         => s_RegWr,
    i_RA0        => s_Inst(25 downto 21),
    i_RA1        => s_Inst(20 downto 16),
    i_CLK        => iCLK,
    i_RST        => iRST,
    o_D0         => s_ID_D0,	-- Output data 0
    o_D1         => s_ID_D1);  -- Output data 1
  
   -- s_DMemData <= s_ID_D1;
  
  bitExtend: bitExtender port map (
    i_D => s_Inst(15 downto 0),
    i_S => s_SignExt,
    o_F => s_ID_Ext);

  -- Shift jump(25-0) left by 2 this is needed with the register file section. 
  leftShift2Jump: barrelShifter generic map (N => 32) port map (
    i_InputBits => s_Inst(31 downto 0),
    i_S_Shift => "00010",
    i_S_Dir   => '1',
    i_Zero => '0',
    o_OutputBits => s_JumpLeftShiftUnclipped);

  s_JumpLeftShift <= s_JumpLeftShiftUnclipped(27 downto 0);

  -- JumpAdr = combine jump address and PC + 4 = ((jump(25-0) << 2) + (PC + 4)(31-28))
  s_ID_JumpAddr(27 downto 0) <= s_JumpLeftShift(27 downto 0);
  s_ID_JumpAddr(31 downto 28) <= s_NextInstAddrPlus4(31 downto 28);

--------------------------------------------------------------------------------------------------
  -- ID/EX stage 

  immShift: barrelShifter generic map (N => 32) port map ( --this is the left shift before the add
    i_InputBits => s_EX_Ext,
    i_S_Shift   => "00010",
    i_S_Dir     => '1',
    i_Zero      => '0',
    o_OutputBits  =>  s_ImShift);

  -- (PC + 4) + (Immediate << 2)
  addBranch2: adder_N port map ( --this is the fetch logic output and the left shift two
    i_A => s_EX_Pc,
    i_B => s_ImShift,
    i_C => '0',
    o_F => s_EX_branchAddOut,
    o_C => s_Throw);
  

  -- Input reg 2 or immediate into ALU
  mux5: mux2to1_N port map (
    i_D0 =>  s_EX_D1,
    i_D1 =>  s_EX_Ext,  
    i_S =>  s_EX_ALUSrc,
    o_O =>  s_ALU_B);  

  
  alu0: ALU port map (
    i_A           => s_EX_D0,
    i_B           => s_ALU_B,
    i_ALUSelect   => s_AluSel,
    o_F	          => s_EX_ALUOUT,  
    o_Zero        => s_OneBitOut);

  s_Ovfl <= '0';

  alu_control: ALU_contr port map(
    i_Funct => s_EX_Inst(5 downto 0),
    i_ALUOP => s_EX_ALUOP,
    o_Op    => s_AluSel);


  -- Input rd or rt into register file
  muxrdrt: mux2to1_N generic map (N => 5) port map (
    i_D0 => s_Inst(20 downto 16),
    i_D1 => s_Inst(15 downto 11),
    i_S =>  s_ID_RegDst_Pre,
    o_O =>  s_RWA_Pre);

  muxReg31: mux2to1_N generic map (N => 5) port map (
    i_D0  =>  s_RWA_Pre,
    i_D1  =>  "11111",
    i_S   =>  s_ID_RegDst_31,
    o_O   =>  s_ID_RWA);

--------------------------------------------------------------------------------------------------------
  -- EX/MEM stage


  --this is done 
  andBranch: andg2 port map (
    i_A => s_MEM_Branch,
    i_B => s_MEM_OneBitOut,
    o_F => s_S_AndGateOut);

  andBranchNot: andg2 port map (
    i_A => s_MEM_Branch,
    i_B => s_MEM_OneBitOut,
    o_F => s_S_AndGateOutTwo);

  orBranch: org2 port map (
    i_A => s_S_AndGateOut,
    i_B => s_S_AndGateOutTwo,
    o_F => s_BranchSel);

-------------------------------------------------------------------------
-- MEM/ WB stage

  muxBranch: mux2to1_N port map (
    -- i_D0	=> s_PC_Stall,  --this might be wrong  
    i_D0	=> s_NextInstAddrPlus4,  --this might be wrong  
    i_D1	=> s_MEM_BranchAdr, --this needs double checked
    i_S	=> s_BranchSel, --I changed this to the correct select line and think it may help our branch problem.  -- s_S_AndGate;
    o_O	=> s_Mux_Branch);

  muxJump: mux2to1_N port map (
    i_D0	  => s_Mux_Branch,
    i_D1	  => s_WB_JumpAdr, --this needs double checked but I beleive that it is right. 
    i_S	    => s_WB_Jump,
    o_O	    => s_ID_JumpAndLink);
  
  muxJal: mux2to1_N port map (
    i_D0	=> s_ID_JumpAndLink, 
    i_D1	=> s_EX_D0,
    i_S	  => s_WB_JR,
    o_O	  => s_FinalNextInstAddr);
    -- o_O	  => s_LockNextInstAddr);

  -- -- Stall next instruction
  -- muxLock: mux2to1_N port map (
  --   i_D0	=> s_LockNextInstAddr,
  --   i_D1	=> s_IMemAddr,
  --   i_S	  => s_stall,
  --   o_O	  => s_FinalNextInstAddr);

  -- Data memory mux --
  mux2: mux2to1_N port map (
    i_D0 =>  s_MEM_DM,   -- Mem out
    i_D1 =>  s_DMemAddr,  -- ALU out
    i_S =>  s_WB_MemReg,
    o_O =>  s_RegWrDataFinal); --

	oALUOut <= s_DMemAddr; -- this was ss_DMemOut

  mux3: mux2to1_N generic map (N => 32) port map (
    i_D0	=> s_RegWrDataFinal, --
    i_D1	=> s_NextInstAddrPlus4,  -- PC + 8 --or s_EX_Pc +4 
    i_S	=> s_WB_Jal,
    o_O	=> s_RegWrData);
    
hazardcontrol: Hazard_Control port map(
  i_ID_jump =>  s_ID_Jump,
  i_EX_jump =>  s_EX_Jump,
  i_MEM_jump => s_MEM_Jump,
  i_WB_jump  => s_WB_Jump,

  i_branch  => s_BranchSel,

  i_IF_Opcode	=> s_InstOrNOP(31 downto 26),
  -- i_IF_Opcode	=> s_Inst(31 downto 26),

  i_RS	  => s_InstOrNOP(25 downto 21),
	i_RT	  => s_InstOrNOP(20 downto 16),
  -- i_RS	  => s_Inst(25 downto 21),
	-- i_RT	  => s_Inst(20 downto 16),
  
  -- i_ID_WA	  => s_RegWrAddr,
  i_ID_WA	  => s_ID_RWA,
  i_EX_WA	  => s_EX_RWA,
  i_MEM_WA	=> s_MEM_RWA,

  -- i_ID_WE	  => s_RegWr, 
  i_ID_WE	  => s_ID_RWE, 
  i_EX_WE	  => s_EX_RWE, 
  i_MEM_WE  => s_MEM_RWE,

  o_stall	=>  s_stall);

forwardcontrol: Forwarder port map(
  i_RA1 => s_Inst(25 downto 21),
  i_RA2  => s_Inst(20 downto 16),

  i_WA  => s_RegWrAddr,
  i_WE =>  s_RegWr,

  o_Forward1  => s_forward1,
  o_Forward2  => s_forward2);


-- stalladdr: mux2to1_N port map (
--   i_D0	=>  s_NextInstAddrPlus4, -- PC+4
--   i_D1	=>  s_IMemAddr,          -- PC
--   i_S	  =>  s_stall, 
--   o_O	  =>  s_PC_Stall);


-- stallInst: mux2to1_N port map (
  --   i_D0	=>  s_Pre_Inst,
  --   i_D1	=>  x"00000000",
  --   i_S	  =>  s_stall,
  --   o_O	  =>  s_InstOrNOP);
  
  s_InstOrNOP <= s_Pre_Inst;
  s_F_ID_D0 <= s_ID_D0;
  s_F_ID_D1 <= s_ID_D1;

-- forwardmux1: mux2to1_N port map (
--   i_D0	=>  s_ID_D0, --
--   i_D1	=>  s_RegWrData,
--   i_S	  =>  s_forward1,
--   o_O	  =>  s_F_ID_D0);

-- forwardmux2: mux2to1_N port map (
--   i_D0	=>  s_ID_D1, --
--   i_D1	=>  s_RegWrData,
--   i_S	  =>  s_forward2,
--   o_O	  =>  s_F_ID_D1);

end structure;
