library IEEE;
use IEEE.std_logic_1164.all;

entity repl_qb is

  port(i_A          : in std_logic_vector(7 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end repl_qb;

architecture dataflow of repl_qb is
begin

  o_F(31) <= i_A(7);
  o_F(30) <= i_A(6);
  o_F(29) <= i_A(5);
  o_F(28) <= i_A(4);
  o_F(27) <= i_A(3);
  o_F(26) <= i_A(2);
  o_F(25) <= i_A(1);
  o_F(24) <= i_A(0);

  o_F(23) <= i_A(7);
  o_F(22) <= i_A(6);
  o_F(21) <= i_A(5);
  o_F(20) <= i_A(4);
  o_F(19) <= i_A(3);
  o_F(18) <= i_A(2);
  o_F(17) <= i_A(1);
  o_F(16) <= i_A(0);

  o_F(15) <= i_A(7);
  o_F(14) <= i_A(6);
  o_F(13) <= i_A(5);
  o_F(12) <= i_A(4);
  o_F(11) <= i_A(3);
  o_F(10) <= i_A(2);
  o_F(9) <= i_A(1);
  o_F(8) <= i_A(0);

  o_F(7) <= i_A(7);
  o_F(6) <= i_A(6);
  o_F(5) <= i_A(5);
  o_F(4) <= i_A(4);
  o_F(3) <= i_A(3);
  o_F(2) <= i_A(2);
  o_F(1) <= i_A(1);
  o_F(0) <= i_A(0);
  
end dataflow;