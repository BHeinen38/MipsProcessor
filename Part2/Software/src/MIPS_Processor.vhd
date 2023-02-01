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

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal 
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input


  --THIS NEEDS SOME LOOKING
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input -- this could be potentially wrong.
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file -- I think I created a signal so we do not need this.  BH
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrAddr0    : std_logic_vector(4 downto 0);
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- use this signal as the instruction signal 

  signal s_FinalNextInstAddr : std_logic_vector(N-1 downto 0);

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  -- Required control signal  -- 
  signal so_AluOP     : std_logic_vector(3 downto 0);
  signal s_AluSel     : std_logic_vector(3 downto 0);
  signal so_Jump      : std_logic;
  signal so_Branch    : std_logic;
  signal so_BranchNot    : std_logic;
  signal so_MemReg    : std_logic;
  signal so_ALUSrc    : std_logic;
  signal so_ALUOut	: std_logic_vector(31 downto 0);
  signal sss_RegDst    : std_logic;
  signal s_S_AndGateOut : std_logic;
  signal s_S_AndGateOutTwo : std_logic;
  signal s_BranchSel : std_logic;
  signal so_JAL  : std_logic;
  signal so_JR  : std_logic;
  signal so_RegisterWR : std_logic;
  signal so_memWrite : std_logic;
  signal so_Halt    : std_logic;


  --Required Register Files---
 signal s_regFile_D0 : std_logic_vector(31 downto 0); --output of register A
 signal s_regFile_D1 : std_logic_vector(31 downto 0); --output of register B
 signal s_ALU_B      : std_logic_vector(31 downto 0); --this is the input of Alu B 

  --ALU control signal -- 
  signal s_SignExt        : std_logic;
  signal s_extenderOutput : std_logic_vector(31 downto 0);
  signal s_OneBitOut  : std_logic;


  --Required signals from the Instruction Fetch with Jumps block --
  signal s_BranchAdr : std_logic_vector(31 downto 0);
  signal s_Throw     : std_logic;
  --signal s_Throw2   :std_logic;
  signal s_ImShift     : std_logic_vector(31 downto 0);
  signal s_Mux_Branch  : std_logic_vector(31 downto 0);
  signal s_JumpLeftShift  : std_logic_vector(27 downto 0);
  signal s_JumpAdr        : std_logic_vector(31 downto 0);
  signal s_NotOneBitOut   : std_logic;
  signal so_JumpAndLink   : std_logic_vector(31 downto 0);
  signal s_RegWrDataFinal : std_logic_vector(31 downto 0);
  signal sss_Reg31Dst      : std_logic; --this could potentially cause errors 

  signal so_PC : std_logic_vector(31 downto 0);
  --signal so_JAL_PC : std_logic_vector(31 downto 0);
  signal s_JumpLeftShiftUnclipped  : std_logic_vector(31 downto 0);


  --Required signals for the pipeline procedure. 

  --IF/ID
  signal s_Inst_31_0 : std_logic_vector(31 downto 0); --

 -- ID/EX
 signal s_registerWR : std_logic;
 signal s_memWrite : std_logic;
 signal s_hault : std_logic;
 signal so_Regdst : std_logic;
 signal so_Reg31dst : std_logic;
 signal s_ALUSrc : std_logic;
 signal s_AluOP : std_logic_vector(3 downto 0);
 signal s_Branch : std_logic;
 signal s_BranchNot : std_logic;
 signal s_Jump : std_logic;
 signal s_JR   : std_logic;
 signal s_JAL  : std_logic;
 signal s_MemReg : std_logic;
 signal oo_PC : std_logic_vector(31 downto 0);
 signal s_datamemaddr :std_logic_vector(31 downto 0);
 signal so_regFileD0 : std_logic_vector(31 downto 0);
 signal so_regFileD1 : std_logic_vector(31 downto 0);
 signal so_ext :std_logic_vector(31 downto 0);


 --EX/MEM
 signal ss_hault : std_logic;
 signal ss_registerWR : std_logic;
 signal ss_branch : std_logic;
 signal  ss_branchNot : std_logic; 
 signal ss_jump : std_logic;
 signal ss_jr : std_logic;
 signal ss_jal : std_logic;
 signal ss_memreg : std_logic;
 signal ss_pc  : std_logic_vector(31 downto 0);
 --signal ss_DMemData : std_logic_vector(31 downto 0);
 signal ss_Inst_20_16 :std_logic_vector(20 downto 16); -- this could be 5-0
 signal ss_Inst_15_11 :std_logic_vector(15 downto 11); --this could be 5-0
 signal ss_Inst_5_0 :std_logic_vector(5 downto 0); --this could be 6-0
 signal ss_JumpAdr : std_logic_vector(31 downto 0); 
 signal sso_JumpAdr    : std_logic_vector(31 downto 0);
 signal ss_secondAddOut : std_logic_vector(31 downto 0);
 signal soo_RegWrAddr : std_logic_vector(4 downto 0);
 signal sss_RegWrAddr : std_logic_vector(4 downto 0);
 --signal ss_DMemOut : std_logic_vector(31 downto 0); --this needs double checked 
signal ss_OneBitOut : std_logic;
signal ss_DMemAddr : std_logic_vector(31 downto 0);


 --MEM/WB
 signal Jump : std_logic;
 signal JR : std_logic;
 signal JAL : std_logic;
 signal MemReg : std_logic;
 signal jumpadr : std_logic_vector(31 downto 0);
signal ss_DataMemOut : std_logic_vector(31 downto 0);




  
 

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

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component ALU_contr is
    port(
    i_Funct:	in std_logic_vector(5 downto 0);
		i_ALUop:	in std_logic_vector(3 downto 0);
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
      o_AluOP    	: out std_logic_vector(3 downto 0); -- This is the operational control for the alu controller
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
	     i_PC_4		: in std_logic_vector(31 downto 0);
	     i_Inst  	: in std_logic_vector(31 downto 0);
	     o_PC_4	  	: out std_logic_vector(31 downto 0);
	     o_Inst	: out std_logic_vector(31 downto 0));
end component;

component ID_EX_reg is
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
end component;

component EX_MEM_reg is
	port(i_CLK		        : in std_logic;
	     i_RST		        : in std_logic; 
	     i_secondAddOut	    : in std_logic_vector(31 downto 0);--
         i_jumpAddr         : in std_logic_vector(31 downto 0);--
	     i_readData2 	    : in std_logic_vector(31 downto 0);----
	     i_aluOutput	    : in std_logic_vector(31 downto 0);----
	     i_writeRegister    : in std_logic_vector(4 downto 0);----

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

	     o_secondAddout		    : out std_logic_vector(31 downto 0);
         o_readData2 	        : out std_logic_vector(31 downto 0);
	     o_jumpAddr 	        : out std_logic_vector(31 downto 0);
	     o_aluOutput	 	    : out std_logic_vector(31 downto 0);
	     o_writeRegister 	    : out std_logic_vector(4 downto 0);

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
	     i_writeRegister    : in std_logic_vector(4 downto 0);

        --D-flip flop one bits
	     
	     --i_overflow		    : in std_logic; --this will be needed for the slt and others
         i_JumpSignal		  : in std_logic; -- 
         i_MemRegSignal		: in std_logic;--
         i_RegWrteSignal	  : in std_logic; --
         i_JALSignal       : in std_logic;--
         i_JRSignal        : in std_logic;--
         i_haltSignal      : in std_logic;--

	     o_jumpAddr     	    : out std_logic_vector(31 downto 0); 
	     o_readDataMEM 	        : out std_logic_vector(31 downto 0);
	     o_aluOutput	 	    : out std_logic_vector(31 downto 0);
	     o_writeRegister 	    : out std_logic_vector(4 downto 0);

	-- one bit outputs
	     --o_overflow		: out std_logic;
	     o_JumpSignal           : out std_logic; --
         o_MemRegSignal         : out std_logic; --
         o_RegWrteSignal        : out std_logic;  --
         o_JALSignal            : out std_logic;
         o_JRSignal             :out std_logic;
         o_haltSignal           :out std_logic);

end component;


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst_31_0); --this was s_Inst and is needed for the pipline to input into the register file 
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

--IF/ID stage
  ------------------------------------------------
 
  fetch: fetchLogic
    port map (
      i_CLK   => iCLK,
      i_RST   => iRST,
      i_PC    => s_FinalNextInstAddr,
      o_PC  => s_NextInstAddr,
      o_PCNext    => so_PC);

     IFID: IF_ID_reg
        port map (i_CLK	=> 	iCLK ,
             i_RST => iRST,
             i_PC_4	=> s_NextInstAddr, --this needs to take in pc+4 
             i_Inst  => s_Inst_31_0,
             o_PC_4	 => oo_PC, --this needs to output pc+4 
             o_Inst	=> s_Inst);


-----------------------------------------------------------------
    
-- ID/EX stage 

  control: Control_Logic
    port map (
      i_RegOpCode => s_Inst(31 downto 26),--
      i_funct => s_Inst(5 downto 0),--
      o_AluOP    	=> so_AluOP,
      o_Jump		  => so_Jump,
      o_Branch		=> so_Branch,
      o_BranchNot => so_BranchNot,
      o_MemReg		=> so_MemReg,
      o_MemWrite	=> so_memWrite,
      o_ALUSrc		=> so_ALUSrc,
      o_JAL       => so_JAL,
      o_JR        => so_JR,
      o_RegWrte	  => so_RegisterWR,
      o_RegDst		=> sss_RegDst,
      o_Reg31Dst	=> sss_Reg31Dst,
      o_halt      => so_Halt,
      o_SignExt   => s_SignExt);

    regFile: registerFile
      port map (
        i_D          => s_RegWrData,
        i_WA         => s_RegWrAddr,
        i_WE         => s_RegWr,
        i_RA0        => s_Inst(25 downto 21),
        i_RA1        => s_Inst(20 downto 16),
        i_CLK        => iCLK,
        i_RST        => iRST,
        o_D0         => s_regFile_D0,	-- Output data 0
        o_D1         => s_regFile_D1);  -- Output data 1
  
   -- s_DMemData <= s_regFile_D1;
  
    bitExtend: bitExtender
      port map (
          i_D => s_Inst(15 downto 0),
          i_S => s_SignExt,
          o_F => s_extenderOutput);

    -- Shift jump(25-0) left by 2 this is needed with the register file section. 
  leftShift2Jump: barrelShifter generic map (N => 32) port map (
    i_InputBits => s_Inst(31 downto 0),
    i_S_Shift => "00010",
    i_S_Dir   => '1',
    i_Zero => '0',
    o_OutputBits => s_JumpLeftShiftUnclipped);

  s_JumpLeftShift <= s_JumpLeftShiftUnclipped(27 downto 0);

  -- JumpAdr = combine jump address and PC + 4 = ((jump(25-0) << 2) + (PC + 4)(31-28))
  s_JumpAdr(27 downto 0) <= s_JumpLeftShift(27 downto 0);
  s_JumpAdr(31 downto 28) <= so_PC(31 downto 28);


  IDEX: ID_EX_reg
	port map(i_CLK => iCLK,
	     i_RST => iRST,
	     i_PC_4	=> oo_PC,
	     i_readData1 => s_regFile_D0, 
	     i_readData2 => s_regFile_D1,
	     i_signExtender => s_extenderOutput,
	     i_jumpAddr => s_JumpAdr, 	
	     i_Inst_20_16 => s_Inst(20 downto 16),
	     i_Inst_15_11 => s_Inst(15 downto 11),
       i_Inst_5_0  => s_Inst(5 downto 0),     
	     
        --control logic   
        i_AluOPSignal => so_AluOP,
        i_JumpSignal  => so_Jump,	
        i_BranchSignal	=> so_Branch,
        i_BranchNotSignal => so_BranchNot,	
        i_MemRegSignal  => so_MemReg,		
        i_MemWriteSignal => so_memWrite, 	
        i_ALUSrcSignal => so_ALUSrc,
        i_RegWrteSignal	=> so_RegisterWR,    
        i_JALSignal => so_JAL,       
        i_JRSignal  => so_JR,       
        i_RegDstSignal	=> sss_RegDst,	
        i_Reg31DstSignal	=> sss_Reg31Dst, 
        i_haltSignal => so_Halt,       
        --i_SignExt         

	     o_PC_4	=> ss_pc,	  --this needs to be new output of pc +4   
	     o_readData1 => so_regFileD0, 	
	     o_readData2 => so_regFileD1, 	
	     o_signExtender	=> so_ext,
	     o_jumpAddr => ss_JumpAdr,
	     o_Inst_20_16 => ss_Inst_20_16,
	     o_Inst_15_11 => ss_Inst_15_11,
         o_Inst_5_0 => ss_Inst_5_0,
        
        o_AluOPSignal   => s_AluOP, 	
        o_JumpSignal	=> s_Jump,
        o_BranchSignal		=> s_Branch,
        o_BranchNotSignal => s_BranchNot,
        o_MemRegSignal		=> s_MemReg,
        o_MemWriteSignal	=> s_memWrite,
        o_ALUSrcSignal		=> s_ALUSrc,
        o_RegWrteSignal	=> s_RegisterWR,
        o_JALSignal       => s_JAL,
        o_JRSignal        => s_JR,
        o_RegDstSignal	=> so_Regdst,
        o_Reg31DstSignal	=> so_Reg31dst,
        o_haltSignal   => s_hault);
            --o_SignExt   );

  --------------------------------------------------------------------------------------------------


  -- (PC + 8)
  -- addBranch: adder_N 
  --   generic map (N => 32)
  --   port map (
  --     i_A => so_PC,
  --     i_B => x"00000004",
  --     i_C => '0',
  --     o_F => so_JAL_PC,
  --     o_C => s_Throw2);

  
  immShift: barrelShifter generic map (N => 32) port map ( --this is the left shift before the add
  i_InputBits => so_ext,
  i_S_Shift   => "00010",
  i_S_Dir     => '1',
  i_Zero      => '0',
  o_OutputBits  =>  s_ImShift);

-- (PC + 4) + (Immediate << 2)
addBranch2: adder_N port map ( --this is the fetch logic output and the left shift two
  i_A => ss_PC,
  i_B => s_ImShift,
  i_C => '0',
  o_F => ss_secondAddOut,
  o_C => s_Throw);
  

  -- Input reg 2 or immediate into ALU
  mux5: mux2to1_N
  port map (
    i_D0 =>  so_regFileD1,
    i_D1 =>  so_ext,  
    i_S =>  s_ALUSrc,
    o_O =>  s_ALU_B);  

    alu0: ALU
    port map (
      i_A           => so_regFileD0,
      i_B           => s_ALU_B,
      i_ALUSelect   => s_AluSel,
      o_F	          => so_ALUOut,  
      o_Zero        => s_OneBitOut);

        s_Ovfl <= '0';

 --oALUOut <= s_DMemOut; --this was ss_DMemOut

  alu_control: ALU_contr
          port map(
            i_Funct => ss_Inst_5_0(5 downto 0),
            i_ALUop => s_AluOP,
            o_Op    => s_AluSel);


     -- Input rd or rt into register file
    mux0: mux2to1_N
    generic map (N => 5)
    port map (
        i_D0 =>  ss_Inst_20_16(20 downto 16),
        i_D1 => ss_Inst_15_11(15 downto 11),
        i_S =>  so_Regdst,
        o_O =>  s_RegWrAddr0);

    mux1: mux2to1_N -- reg 31 mux 
    generic map (N => 5)
    port map (
        i_D0 =>  s_RegWrAddr0,
        i_D1 =>  "11111",
        i_S =>  so_Reg31dst,
        o_O =>  sss_RegWrAddr);

    EXMEM: EX_MEM_reg 
        port map (i_CLK => iCLK,
        i_RST	=> iRST,
        i_secondAddOut	=> ss_secondAddOut,  
        i_jumpAddr => ss_JumpAdr,     
        i_readData2 => so_regFileD1,	  
        i_aluOutput  => so_ALUOut, 	   
        i_writeRegister => sss_RegWrAddr,  

        --D-flip flop one bits
        i_ALUzero => s_OneBitOut,
        --i_overflow		    
        i_JumpSignal	=> s_Jump,	 
        i_BranchSignal	=> s_Branch,
        i_BranchNotSignal	=> s_BranchNot,
        i_MemRegSignal	=> s_MemReg,
        i_MemWriteSignal	=> s_memWrite,
        i_RegWrteSignal => s_RegisterWR,	
        i_JALSignal  => s_JAL,   
        i_JRSignal   => s_JR, 
        i_haltSignal  => s_hault,  

        o_secondAddout	=> s_BranchAdr,	 
        o_readData2  => s_DMemData,  	    
        o_jumpAddr => sso_JumpAdr, 	      
        o_aluOutput => s_DMemAddr,	 	    
        o_writeRegister => soo_RegWrAddr, --input	   

        -- one bit outputs
        o_ALUzero	=> ss_OneBitOut,	       
        --o_overflow		
        o_JumpSignal   => ss_jump,        
        o_BranchSignal   => ss_branch,      
        o_BranchNotSignal  => ss_branchNot,    
        o_MemRegSignal   => ss_memreg,     
        o_MemWriteSignal => s_DMemWr,      
        o_RegWrteSignal  => ss_registerWR,       
        o_JALSignal => ss_jal,           
        o_JRSignal => ss_jr,          
        o_haltSignal =>  ss_hault);


--------------------------------------------------------------------------------------------------------
 
  --this is done 
  andBranch: andg2 port map (
    i_A => ss_branch,
    i_B => ss_OneBitOut,
    o_F => s_S_AndGateOut);

  -- aluNot: invg port map ( --I think we need this for it to function right
  --   i_A => s_OneBitOut,
  --   o_F => s_NotOneBitOut);

  andBranchNot: andg2 port map (
    i_A => ss_branch,
    i_B => ss_OneBitOut,
    o_F => s_S_AndGateOutTwo);

  orBranch: org2 port map (
    i_A => s_S_AndGateOut,
    i_B => s_S_AndGateOutTwo,
    o_F => s_BranchSel);

   MEMWB: MEM_WB_reg 
    port map (i_CLK	=> iCLK,	       
            i_RST	=> iRST,	        
            i_jumpAddr 	=> sso_JumpAdr,    
            i_readDataMEM 	=> s_DMemOut,   
            i_aluOutput	=> s_DMemAddr,   
            i_writeRegister  => soo_RegWrAddr,

        --D-flip flop one bits
            
            --i_overflow		    
            i_JumpSignal	=> ss_jump,	 
            i_MemRegSignal	=> ss_memreg,	
            i_RegWrteSignal => ss_registerWR,	  
            i_JALSignal  => ss_jal,    
            i_JRSignal   => ss_jr,     
            i_haltSignal => ss_hault,     

            o_jumpAddr    => jumpadr, 	    
           o_readDataMEM 	=> ss_DataMemOut,        
            o_aluOutput	=> ss_DMemAddr,  --this needs done 	  
            o_writeRegister => s_RegWrAddr,

    -- one bit outputs
            --o_overflow	
            o_JumpSignal   => Jump,       
            o_MemRegSignal  => MemReg,      
            o_RegWrteSignal  => s_RegWr,    
            o_JALSignal  => JAL,          
            o_JRSignal => JR,          
            o_haltSignal => s_Halt);
    
  



-------------------------------------------------------------------------
-- this is the MEM/ WB stage


  -- s_S_Branch ? (PC + 4) : (PC + 4) + (Immediate << 2)
  muxBranch: mux2to1_N port map (
	i_D0	=> so_PC,  --this might be wrong  
	i_D1	=> s_BranchAdr, --this needs double checked
	i_S	=> s_BranchSel, --I changed this to the correct select line and think it may help our branch problem.  -- s_S_AndGate;
	o_O	=> s_Mux_Branch);


  -- i_S_Jump ? ((PC + 4) << 2) : s_Mux_Branch
  muxJump: mux2to1_N port map (
	i_D0	=> s_Mux_Branch,
	i_D1	=> jumpadr, --this needs double checked but I beleive that it is right. 
	i_S	    => Jump,
	o_O	    => so_JumpAndLink);


   muxJal: mux2to1_N port map (
	i_D0	=> so_JumpAndLink, 
	i_D1	=> so_regFileD0,
	i_S	=> JR,
	o_O	=> s_FinalNextInstAddr);

    -- Data memory mux --
  mux2: mux2to1_N
  port map (
    i_D0 =>  ss_DataMemOut,   -- Mem out
    i_D1 =>  ss_DMemAddr,  -- ALU out
    i_S =>  MemReg,
    o_O =>  s_RegWrDataFinal); --

	oALUOut <= ss_DMemAddr; --this was ss_DMemOut



    mux3: mux2to1_N  --this might be our last mux, we will see
    generic map (N => 32)
    port map (
      i_D0	=> s_RegWrDataFinal, --
      i_D1	=> so_PC,  -- PC + 8 --or ss_PC +4 
      i_S	=> JAL,
      o_O	=> s_RegWrData);
    


end structure;
