
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Logic is

  port(i_RegOpCode      : in std_logic_vector(5 downto 0); --this is the op code
       o_AluOP    	: out std_logic_vector(3 downto 0); -- This is the operational control for the alu controller
       o_Jump		: out std_logic;
       o_Branch		: out std_logic;
       o_MemReg		: out std_logic;
       o_MemWrite	: out std_logic;
       o_ALUSrc		: out std_logic;
       o_RegWrte	: out std_logic;
       o_RegDst		: out std_logic);
end Control_Logic;

architecture dataflow of Control_Logic is

begin 
  process(i_RegOpcode) is
  begin

    case i_RegOpcode is
	when "000000" =>
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '1';
		o_RegDst  <= '1';
		o_AluOP <= "0000";
 	
	
	 when "001000" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "0001";

	when "001001" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "1110";

	  when "001100" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "0010";

	   when "001111" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "0011";

           when "100011" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_AluOP <= "0100";

            when"001110" =>
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "1101";

             when "001101" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "0101";

             when "001010" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "0110";


             when "101011" =>
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '1';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '1';
		o_AluOP <= "0111";
	

              when "000100" =>
		o_Jump <= '0';
		o_Branch <= '1';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "1000";


	     when "000101" => 
		o_Jump <= '0';
		o_Branch <= '1';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "1111";

	      
	      when "000010" =>
		o_Jump <= '1';
		o_Branch <= '0';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "1001";


              when "000011" => 
		o_Jump <= '1';
		o_Branch <= '0';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_AluOP <= "1001";	

		when others =>
		o_Jump <= 'X';
		o_Branch <= 'X';
		o_MemReg <= 'X';
		o_MemWrite  <= 'X';
  		o_ALUSrc  <= 'X';
		o_RegWrte  <= 'X';
		o_RegDst   <= 'X';
		o_AluOP  <= "XXXX";
		
		end case;

	end process;
end dataflow;