library IEEE;
use IEEE.std_logic_1164.all;

entity equalsZero is
  generic (N : integer := 32); 
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic);

end equalsZero;

architecture dataflow of equalsZero is

  component org2 is
    port(
        i_A   : in std_logic;
        i_B   : in std_logic;
        o_F   : out std_logic);
  end component;

  signal s_Zero : std_logic_vector(N downto 0) := (others => '0');

begin

    G_or0: for i in 0 to N-1 generate
      or0: org2 port map (
        i_A   => i_A(i),
        i_B   => s_Zero(i),
        o_F   => s_Zero(i + 1));
    end generate G_or0;
  
    o_F <= s_Zero(N);
  
end dataflow;