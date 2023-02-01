-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux16to1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 16:1 mux
--
--
-- NOTES:
-- 9/30/2021 CREATED
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux16to1_N is
  generic(N : integer := 32);
  port(i_D0          : in std_logic_vector(N-1 downto 0);
       i_D1          : in std_logic_vector(N-1 downto 0);
       i_D2          : in std_logic_vector(N-1 downto 0);
       i_D3          : in std_logic_vector(N-1 downto 0);
       i_D4          : in std_logic_vector(N-1 downto 0);
       i_D5          : in std_logic_vector(N-1 downto 0);
       i_D6          : in std_logic_vector(N-1 downto 0);
       i_D7          : in std_logic_vector(N-1 downto 0);
       i_D8          : in std_logic_vector(N-1 downto 0);
       i_D9          : in std_logic_vector(N-1 downto 0);
       i_D10          : in std_logic_vector(N-1 downto 0);
       i_D11          : in std_logic_vector(N-1 downto 0);
       i_D12          : in std_logic_vector(N-1 downto 0);
       i_D13          : in std_logic_vector(N-1 downto 0);
       i_D14          : in std_logic_vector(N-1 downto 0);
       i_D15          : in std_logic_vector(N-1 downto 0);
       i_S           : in std_logic_vector(3 downto 0);
       o_F           : out std_logic_vector(N-1 downto 0));

end mux16to1_N;

architecture structural of mux16to1_N is

  component mux4to1_N is
    generic(N : integer := 32);
    Port(
      i_D0  : in std_logic_vector(N-1 downto 0);
      i_D1  : in std_logic_vector(N-1 downto 0);
      i_D2  : in std_logic_vector(N-1 downto 0);
      i_D3  : in std_logic_vector(N-1 downto 0);
      i_S   : in std_logic_vector(1 downto 0);
      o_F   : out std_logic_vector(N-1 downto 0));
  end component;

  signal s_mux0, s_mux1, s_mux2, s_mux3 : std_logic_vector(N-1 downto 0);

begin

  -- First layer

  mux0: mux4to1_N port map (
    i_D0 => i_D0,
    i_D1 => i_D1,
    i_D2 => i_D2,
    i_D3 => i_D3,
    i_S  => i_S(1 downto 0),
    o_F  => s_mux0);

  mux1: mux4to1_N port map (
    i_D0 => i_D4,
    i_D1 => i_D5,
    i_D2 => i_D6,
    i_D3 => i_D7,
    i_S  => i_S(1 downto 0),
    o_F  => s_mux1);

  mux2: mux4to1_N port map (
    i_D0 => i_D8,
    i_D1 => i_D9,
    i_D2 => i_D10,
    i_D3 => i_D11,
    i_S  => i_S(1 downto 0),
    o_F  => s_mux2);
  
  mux3: mux4to1_N port map (
    i_D0 => i_D12,
    i_D1 => i_D13,
    i_D2 => i_D14,
    i_D3 => i_D15,
    i_S  => i_S(1 downto 0),
    o_F  => s_mux3);

  -- Second layer

  mux8: mux4to1_N port map (
    i_D0 => s_mux0,
    i_D1 => s_mux1,
    i_D2 => s_mux2,
    i_D3 => s_mux3,
    i_S  => i_S(3 downto 2),
    o_F  => o_F);
  
end structural;