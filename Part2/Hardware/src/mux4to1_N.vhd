-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux4to1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 4:1mux
--
--
-- NOTES:
-- 9/30/2021 CREATED
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux4to1_N is
  generic(N : integer := 32);
  port(i_D0          : in std_logic_vector(N-1 downto 0);
       i_D1          : in std_logic_vector(N-1 downto 0);
       i_D2          : in std_logic_vector(N-1 downto 0);
       i_D3          : in std_logic_vector(N-1 downto 0);
       i_S           : in std_logic_vector(1 downto 0);
       o_F           : out std_logic_vector(N-1 downto 0));
end mux4to1_N;

architecture structural of mux4to1_N is

  component mux2to1_N is
    generic(N : integer := 32);
    Port(
      i_D0  : in std_logic_vector(N-1 downto 0);
      i_D1  : in std_logic_vector(N-1 downto 0);
      i_S   : in std_logic;
      o_O   : out std_logic_vector(N-1 downto 0));
  end component;

  signal s_mux0, s_mux1    : std_logic_vector(N-1 downto 0);

begin

  mux0: mux2to1_N port map (
    i_D0 => i_D0,
    i_D1 => i_D1,
    i_S  => i_S(0),
    o_O  => s_mux0);

  mux1: mux2to1_N port map (
    i_D0 => i_D2,
    i_D1 => i_D3,
    i_S  => i_S(0),
    o_O  => s_mux1);

  mux2: mux2to1_N port map (
    i_D0 => s_mux0,
    i_D1 => s_mux1,
    i_S  => i_S(1),
    o_O  => o_F);

end structural;