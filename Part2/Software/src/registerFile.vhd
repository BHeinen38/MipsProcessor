-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- registerFile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of MIPS register file
--
--
-- NOTES:
-- 10/3/2021 Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity registerFile is
  port( i_D         : in std_logic_vector(31 downto 0);		-- Input data
	i_WA         : in std_logic_vector(4 downto 0);		-- Write address
	i_WE         : in std_logic;				-- Write enable
	i_RA0         : in std_logic_vector(4 downto 0);	-- Read address 0
	i_RA1         : in std_logic_vector(4 downto 0);	-- Read address 1
	i_CLK         : in std_logic;				-- Clock
        i_RST         : in std_logic;				-- Reset
	o_D0         : out std_logic_vector(31 downto 0);	-- Output data 0
	o_D1         : out std_logic_vector(31 downto 0));	-- Output data 1
end registerFile;

architecture structural of registerFile is

component andg2 is
  port( i_A         : in std_logic;
	i_B         : in std_logic;
        o_F         : out std_logic);
end component;

component fiveTo32Decoder is
  port(i_A         : in std_logic_vector(4 downto 0);
       o_F         : out std_logic_vector(31 downto 0));
end component;

component mux32to1_N is
  port(i_D0          : in std_logic_vector(31 downto 0);
       i_D1          : in std_logic_vector(31 downto 0);
       i_D2          : in std_logic_vector(31 downto 0);
       i_D3          : in std_logic_vector(31 downto 0);
       i_D4          : in std_logic_vector(31 downto 0);
       i_D5          : in std_logic_vector(31 downto 0);
       i_D6          : in std_logic_vector(31 downto 0);
       i_D7          : in std_logic_vector(31 downto 0);
       i_D8          : in std_logic_vector(31 downto 0);
       i_D9          : in std_logic_vector(31 downto 0);
       i_D10          : in std_logic_vector(31 downto 0);
       i_D11          : in std_logic_vector(31 downto 0);
       i_D12          : in std_logic_vector(31 downto 0);
       i_D13          : in std_logic_vector(31 downto 0);
       i_D14          : in std_logic_vector(31 downto 0);
       i_D15          : in std_logic_vector(31 downto 0);
       i_D16          : in std_logic_vector(31 downto 0);
       i_D17          : in std_logic_vector(31 downto 0);
       i_D18          : in std_logic_vector(31 downto 0);
       i_D19          : in std_logic_vector(31 downto 0);
       i_D20          : in std_logic_vector(31 downto 0);
       i_D21          : in std_logic_vector(31 downto 0);
       i_D22          : in std_logic_vector(31 downto 0);
       i_D23          : in std_logic_vector(31 downto 0);
       i_D24          : in std_logic_vector(31 downto 0);
       i_D25          : in std_logic_vector(31 downto 0);
       i_D26          : in std_logic_vector(31 downto 0);
       i_D27          : in std_logic_vector(31 downto 0);
       i_D28          : in std_logic_vector(31 downto 0);
       i_D29          : in std_logic_vector(31 downto 0);
       i_D30          : in std_logic_vector(31 downto 0);
       i_D31          : in std_logic_vector(31 downto 0);
       i_S           : in std_logic_vector(4 downto 0);
       o_F           : out std_logic_vector(31 downto 0));
end component;

component register_N is 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_F          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

signal s_dec32 : std_logic_vector(31 downto 0);				-- Stored decoder output
type t_reg is array (31 downto 0) of std_logic_vector(31 downto 0);	-- Array of 32 register outputs o_F (32 bits)
signal s_reg : t_reg;

signal s_zeros : std_logic_vector(31 downto 0) := (others => '0');	-- $0 register

signal s_WE : std_logic_vector(31 downto 0);

begin

dec32: fiveTo32Decoder port Map (
    i_A => i_WA,
    o_F => s_dec32);

G_reg: for i in 0 to 31 generate
  and_N: andg2
    port map (i_A => i_WE,
	      i_B => s_dec32(i),
	      o_F => s_WE(i));
  reg_N: register_N 
    port map (i_CLK => i_CLK,
	      i_RST => i_RST,
	      i_WE  => s_WE(i),	-- Only write enable if i_WE and decoder selected this register
	      i_D   => i_D,
              o_F => s_reg(i));
  end generate G_reg;

mux32_0: mux32to1_N port map (
    i_D0 => s_zeros,
    i_D1 => s_reg(1),
    i_D2 => s_reg(2),
    i_D3 => s_reg(3),
    i_D4 => s_reg(4),
    i_D5 => s_reg(5),
    i_D6 => s_reg(6),
    i_D7 => s_reg(7),
    i_D8 => s_reg(8),
    i_D9 => s_reg(9),
    i_D10 => s_reg(10),
    i_D11 => s_reg(11),
    i_D12 => s_reg(12),
    i_D13 => s_reg(13),
    i_D14 => s_reg(14),
    i_D15 => s_reg(15),
    i_D16 => s_reg(16),
    i_D17 => s_reg(17),
    i_D18 => s_reg(18),
    i_D19 => s_reg(19),
    i_D20 => s_reg(20),
    i_D21 => s_reg(21),
    i_D22 => s_reg(22),
    i_D23 => s_reg(23),
    i_D24 => s_reg(24),
    i_D25 => s_reg(25),
    i_D26 => s_reg(26),
    i_D27 => s_reg(27),
    i_D28 => s_reg(28),
    i_D29 => s_reg(29),
    i_D30 => s_reg(30),
    i_D31 => s_reg(31),
    i_S  => i_RA0,
    o_F  => o_D0);

mux32_1: mux32to1_N port map (
    i_D0 => s_zeros,
    i_D1 => s_reg(1),
    i_D2 => s_reg(2),
    i_D3 => s_reg(3),
    i_D4 => s_reg(4),
    i_D5 => s_reg(5),
    i_D6 => s_reg(6),
    i_D7 => s_reg(7),
    i_D8 => s_reg(8),
    i_D9 => s_reg(9),
    i_D10 => s_reg(10),
    i_D11 => s_reg(11),
    i_D12 => s_reg(12),
    i_D13 => s_reg(13),
    i_D14 => s_reg(14),
    i_D15 => s_reg(15),
    i_D16 => s_reg(16),
    i_D17 => s_reg(17),
    i_D18 => s_reg(18),
    i_D19 => s_reg(19),
    i_D20 => s_reg(20),
    i_D21 => s_reg(21),
    i_D22 => s_reg(22),
    i_D23 => s_reg(23),
    i_D24 => s_reg(24),
    i_D25 => s_reg(25),
    i_D26 => s_reg(26),
    i_D27 => s_reg(27),
    i_D28 => s_reg(28),
    i_D29 => s_reg(29),
    i_D30 => s_reg(30),
    i_D31 => s_reg(31),
    i_S  => i_RA1,
    o_F  => o_D1);



end structural;