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
  signal so_RegDst    : std_logic;
  signal s_S_AndGateOut : std_logic;
  signal s_S_AndGateOutTwo : std_logic;
  signal s_BranchSel : std_logic;
  signal so_JAL  : std_logic;
  signal so_JR  : std_logic;


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
  signal s_Throw, s_Throw2     : std_logic;
  signal s_ImShift     : std_logic_vector(31 downto 0);
  signal s_Mux_Branch  : std_logic_vector(31 downto 0);
  signal s_JumpLeftShift  : std_logic_vector(27 downto 0);
  signal s_JumpAdr        : std_logic_vector(31 downto 0);
  signal s_NotOneBitOut   : std_logic;
  signal so_JumpAndLink   : std_logic_vector(31 downto 0);
  signal s_RegWrDataFinal : std_logic_vector(31 downto 0);
  signal so_Reg31Dst      : std_logic;

  signal so_PC, so_JAL_PC  : std_logic_vector(31 downto 0);
  signal s_JumpLeftShiftUnclipped  : std_logic_vector(31 downto 0);
  
 

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
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);


  ------------------------------------------------

  fetch: fetchLogic
    port map (
      i_CLK   => iCLK,
      i_RST   => iRST,
      i_PC    => s_FinalNextInstAddr,
      o_PC  => s_NextInstAddr,
      o_PCNext    => so_PC);

  control: Control_Logic
    port map (
      i_RegOpCode => s_Inst(31 downto 26),
      i_funct => s_Inst(5 downto 0),
      o_AluOP    	=> so_AluOP,
      o_Jump		  => so_Jump,
      o_Branch		=> so_Branch,
      o_BranchNot => so_BranchNot,
      o_MemReg		=> so_MemReg,
      o_MemWrite	=> s_DMemWr,
      o_ALUSrc		=> so_ALUSrc,
      o_JAL       => so_JAL,
      o_JR        => so_JR,
      o_RegWrte	  => s_RegWr,
      o_RegDst		=> so_RegDst,
      o_Reg31Dst	=> so_Reg31Dst,
      o_halt      => s_Halt,
      o_SignExt   => s_SignExt);

  -- Input rd or rt into register file
  mux0: mux2to1_N
    generic map (N => 5)
    port map (
      i_D0 =>  s_Inst(20 downto 16),
      i_D1 =>  s_Inst(15 downto 11),
      i_S =>  so_RegDst,
      o_O =>  s_RegWrAddr0);

  mux1: mux2to1_N
    generic map (N => 5)
    port map (
      i_D0 =>  s_RegWrAddr0,
      i_D1 =>  "11111",
      i_S =>  so_Reg31Dst,
      o_O =>  s_RegWrAddr);

  -- (PC + 8)
  -- addBranch: adder_N 
  --   generic map (N => 32)
  --   port map (
  --     i_A => so_PC,
  --     i_B => x"00000004",
  --     i_C => '0',
  --     o_F => so_JAL_PC,
  --     o_C => s_Throw2);

  mux3: mux2to1_N 
    generic map (N => 32)
    port map (
      i_D0	=> s_RegWrDataFinal, --
      i_D1	=> so_PC,  -- PC + 8
      i_S	=> so_JAL,
      o_O	=> s_RegWrData);

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

  s_DMemData <= s_regFile_D1;

  -- Input reg 2 or immediate into ALU
  mux5: mux2to1_N
  port map (
    i_D0 =>  s_regFile_D1,
    i_D1 =>  s_extenderOutput,  
    i_S =>  so_ALUSrc,
    o_O =>  s_ALU_B);  

  alu_control: ALU_contr
          port map(
            i_Funct => s_Inst(5 downto 0),
            i_ALUop => so_AluOP,
            o_Op    => s_AluSel);

  bitExtend: bitExtender
    port map (
        i_D => s_Inst(15 downto 0),
        i_S => s_SignExt,
        o_F => s_extenderOutput);

  alu0: ALU
    port map (
      i_A           => s_regFile_D0,
      i_B           => s_ALU_B,
      i_ALUSelect   => s_AluSel,
      o_F	          => s_DMemAddr,
      o_Zero        => s_OneBitOut);
  s_Ovfl <= '0';

  oALUOut <= s_DMemAddr;

  -- Data memory mux --
  mux2: mux2to1_N
  port map (
    i_D0 =>  s_DMemOut,   -- Mem out
    i_D1 =>  s_DMemAddr,  -- ALU out
    i_S =>  so_MemReg,
    o_O =>  s_RegWrDataFinal); --

  immShift: barrelShifter generic map (N => 32) port map (
    i_InputBits => s_extenderOutput,
    i_S_Shift   => "00010",
    i_S_Dir     => '1',
    i_Zero      => '0',
    o_OutputBits  =>  s_ImShift);

  -- (PC + 4) + (Immediate << 2)
  addBranch2: adder_N port map (
    i_A => so_PC,
    i_B => s_ImShift,
    i_C => '0',
    o_F => s_BranchAdr,
    o_C => s_Throw);
  
  -- Shift jump(25-0) left by 2
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

  --this is done 
  andBranch: andg2 port map (
    i_A => so_Branch,
    i_B => s_OneBitOut,
    o_F => s_S_AndGateOut);

  -- aluNot: invg port map (
  --   i_A => s_OneBitOut,
  --   o_F => s_NotOneBitOut);

  andBranchNot: andg2 port map (
    i_A => so_BranchNot,
    i_B => s_OneBitOut,
    o_F => s_S_AndGateOutTwo);

  orBranch: org2 port map (
    i_A => s_S_AndGateOut,
    i_B => s_S_AndGateOutTwo,
    o_F => s_BranchSel);

  -- s_S_Branch ? (PC + 4) : (PC + 4) + (Immediate << 2)
  muxBranch: mux2to1_N port map (
	i_D0	=> so_PC, 
	i_D1	=> s_BranchAdr,
	i_S	=> s_S_AndGateOut,
	o_O	=> s_Mux_Branch);


  -- i_S_Jump ? ((PC + 4) << 2) : s_Mux_Branch
  muxJump: mux2to1_N port map (
	i_D0	=> s_Mux_Branch,
	i_D1	=> s_JumpAdr,
	i_S	    => so_Jump,
	o_O	    => so_JumpAndLink);

   muxJal: mux2to1_N port map (
	i_D0	=> so_JumpAndLink, 
	i_D1	=> s_regFile_D0,
	i_S	=> so_JR,
	o_O	=> s_FinalNextInstAddr);

end structure;
