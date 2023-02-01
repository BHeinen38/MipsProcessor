
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Forwarder is

  port( i_RA1  	  		: in std_logic_vector(4 downto 0);
				i_RA2	  			: in std_logic_vector(4 downto 0);

				i_WA	  			: in std_logic_vector(4 downto 0);
				i_WE      		: in std_logic;

				o_Forward1		: out std_logic;
				o_Forward2		: out std_logic);
end Forwarder;

architecture dataflow of Forwarder is
begin

o_Forward1 <= '1' when (NOT i_WA = "00000" AND i_RA1 = i_WA AND i_WE = '1')
else '0';
o_Forward2 <= '1' when (NOT i_WA = "00000" AND i_RA2 = i_WA AND i_WE = '1')
else '0';

end dataflow;

