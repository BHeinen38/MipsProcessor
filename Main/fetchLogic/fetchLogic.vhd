-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of fetch logic
--
--
-- NOTES:
-- 10/14/2021 Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fetchLogic is
  port(
  i_CLK       : in std_logic;                       -- Clock
  i_RST       : in std_logic;                       -- Resets register file
  i_PC        : in std_logic_vector(31 downto 0);
  o_PC        : out std_logic_vector(31 downto 0));
end fetchLogic;

architecture structural of fetchLogic is

component register_N is
    port( i_CLK        : in std_logic;                        -- Clock input
          i_RST        : in std_logic;                        -- Reset input to 0x00400000
          i_WE         : in std_logic;                        -- Write enable input
          i_D          : in std_logic_vector(31 downto 0);    -- Data value input
          o_F          : out std_logic_vector(31 downto 0));  -- Data value output
end component;

component mux2to1_N is
  port( i_D0   : in std_logic_vector(31 downto 0);
        i_D1   : in std_logic_vector(31 downto 0);
        i_S   : in std_logic;
        o_O   : out std_logic_vector(31 downto 0));
end component;

component adder_N is
  port( i_A   : in std_logic_vector(31 downto 0);
        i_B   : in std_logic_vector(31 downto 0);
        i_C   : in std_logic;
        o_F   : out std_logic_vector(31 downto 0);
        o_C   : out std_logic);
end component;

-- component mem is 
--   generic( DATA_WIDTH : natural := 32;
--            ADDR_WIDTH : natural := 10);

--   port( clk   : in std_logic;
--         addr   : in std_logic_vector((ADDR_WIDTH - 1) downto 0);
--         data   : in std_logic_vector((DATA_WIDTH - 1) downto 0);
--         we   : in std_logic := '1';
--         q   : out std_logic_vector((DATA_WIDTH - 1) downto 0));
-- end component;

signal s_PC, si_PC : std_logic_vector(31 downto 0);
signal s_Throw : std_logic;

begin

  mux0: mux2to1_N port map (
    i_D0 => i_PC,
    i_D1 => "00000000010000000000000000000000",
    i_S  => i_RST,
    o_O  => si_PC);

  -- Update PC on positive clock edge
  pc: register_N port map ( 
    i_CLK => i_CLK,
    i_RST => '0', -- 0x00400000
    i_WE => '1',
    i_D => si_PC,
    o_F => s_PC);

  -- -- Read out instruction at s_PC
  -- -- DATA_WIDTH matches how many instructions we will implement, so 2^5 has 32 total instructions possible.
  -- -- ADDR_WIDTH may be changed if more instructions than 2^10 = 1024 are needed.
  -- instMem : mem generic map (DATA_WIDTH => 32, ADDR_WIDTH => 10) port map (
  --   clk => i_CLK,
  --   addr => s_PC(9 downto 0),
  --   data => "00000000000000000000000000000000",
  --   we => '0',
  --   q => o_Inst);

  -- Stage 2: Fetch next PC address

  -- Increment PC by 4
  addPC: adder_N port map (
    i_A => s_PC,
    i_B => x"00000004",
    i_C => '0',
    o_F => o_PC,
    o_C => s_Throw);

end structural;