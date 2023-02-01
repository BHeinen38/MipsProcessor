-------------------------------------------------------------------------
-- Austin Rognes
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32to1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 32:1mux
--
--
-- NOTES:
-- 9/30/2021 CREATED
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux32to1_N is
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
       i_D16          : in std_logic_vector(N-1 downto 0);
       i_D17          : in std_logic_vector(N-1 downto 0);
       i_D18          : in std_logic_vector(N-1 downto 0);
       i_D19          : in std_logic_vector(N-1 downto 0);
       i_D20          : in std_logic_vector(N-1 downto 0);
       i_D21          : in std_logic_vector(N-1 downto 0);
       i_D22          : in std_logic_vector(N-1 downto 0);
       i_D23          : in std_logic_vector(N-1 downto 0);
       i_D24          : in std_logic_vector(N-1 downto 0);
       i_D25          : in std_logic_vector(N-1 downto 0);
       i_D26          : in std_logic_vector(N-1 downto 0);
       i_D27          : in std_logic_vector(N-1 downto 0);
       i_D28          : in std_logic_vector(N-1 downto 0);
       i_D29          : in std_logic_vector(N-1 downto 0);
       i_D30          : in std_logic_vector(N-1 downto 0);
       i_D31          : in std_logic_vector(N-1 downto 0);
       i_S           : in std_logic_vector(4 downto 0);
       o_F           : out std_logic_vector(N-1 downto 0));

end mux32to1_N;

architecture structural of mux32to1_N is

  component mux2to1_N is
    generic(N : integer := 32);
    Port(
      i_D0  : in std_logic_vector(N-1 downto 0);
      i_D1  : in std_logic_vector(N-1 downto 0);
      i_S   : in std_logic;
      o_O   : out std_logic_vector(N-1 downto 0));
  end component;

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

  signal s_mux0, s_mux1, s_mux2, s_mux3, s_mux4, s_mux5, s_mux6, s_mux7, s_mux8, s_mux9  : std_logic_vector(N-1 downto 0);

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

  mux4: mux4to1_N port map (
    i_D0 => i_D16,
    i_D1 => i_D17,
    i_D2 => i_D18,
    i_D3 => i_D19,
    i_S  => i_S(1 downto 0),
    o_F  => s_mux4);

  mux5: mux4to1_N port map (
    i_D0 => i_D20,
    i_D1 => i_D21,
    i_D2 => i_D22,
    i_D3 => i_D23,
    i_S  => i_S(1 downto 0),
    o_F  => s_mux5);

  mux6: mux4to1_N port map (
    i_D0 => i_D24,
    i_D1 => i_D25,
    i_D2 => i_D26,
    i_D3 => i_D27,
    i_S  => i_S(1 downto 0),
    o_F  => s_mux6);
  
  mux7: mux4to1_N port map (
    i_D0 => i_D28,
    i_D1 => i_D29,
    i_D2 => i_D30,
    i_D3 => i_D31,
    i_S  => i_S(1 downto 0),
    o_F  => s_mux7);


  -- Second layer

  mux8: mux4to1_N port map (
    i_D0 => s_mux0,
    i_D1 => s_mux1,
    i_D2 => s_mux2,
    i_D3 => s_mux3,
    i_S  => i_S(3 downto 2),
    o_F  => s_mux8);

  mux9: mux4to1_N port map (
    i_D0 => s_mux4,
    i_D1 => s_mux5,
    i_D2 => s_mux6,
    i_D3 => s_mux7,
    i_S  => i_S(3 downto 2),
    o_F  => s_mux9);

  -- Third layer

  mux10: mux2to1_N port map (
    i_D0 => s_mux8,
    i_D1 => s_mux9,
    i_S  => i_S(4),
    o_O  => o_F);
  
end structural;