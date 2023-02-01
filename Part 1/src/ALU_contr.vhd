library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_contr is
		port (i_Funct:	in std_logic_vector(5 downto 0);
		      i_ALUop:	in std_logic_vector(3 downto 0);
		      o_Op:	out std_logic_vector(3 downto 0));
end ALU_contr;

architecture dataflow of ALU_contr is 
begin
	process(i_ALUop, i_Funct) is
	begin
	case i_ALUop is
		when "0000" =>
			case i_Funct is
				when "100000" =>
					o_Op <= "0000";
				when "100001" =>
					o_Op <= "0000";
				when "100100" =>
					o_Op <= "0010";
				when "100111" =>
					o_Op <= "0100";
				when "100110" =>
					o_Op <= "0101";
				when "100101" =>
					o_Op <= "0011";
				when "101010" =>
					o_Op <= "0111";
				when "000000" =>
					o_Op <= "1000";
				when "000010" =>
					o_Op <= "1010";
				when "000011" =>
					o_Op <= "1001";
				when "100010" =>
					o_Op <= "0001";
				when "100011" =>
					o_Op <= "0001";
				when others =>
					o_Op <= "XXXX";
			end case;
		when "0001" =>
			o_Op <= "0000";
		when "1110" =>
			o_Op <= "0000";
		when "0010" =>
			o_Op <= "0010";
		when "0011" =>
			o_Op <= "1101";
		when "0100" =>
			o_Op <= "1110";
		when "1101" =>
			o_Op <= "0101";
		when "0101" =>
			o_Op <= "0011";
		when "0110" =>
			o_Op <= "0111";
		when "0111" =>
			o_Op <= "1111";
		when "1000" =>
			o_Op <= "1011";
		when "1111" =>
			o_Op <= "1100";
		when others =>
			o_Op <= "XXXX";
	end case;
	end process;
end dataflow;


