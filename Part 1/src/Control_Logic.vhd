
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_Logic is

  port(i_RegOpCode  : in std_logic_vector(5 downto 0); --this is the op code
			 i_Funct			:	in std_logic_vector(5 downto 0);
       o_AluOP    	: out std_logic_vector(3 downto 0); -- This is the operational control for the alu controller
       o_Jump		: out std_logic;
       o_Branch		: out std_logic;
       o_BranchNot	: out std_logic;
       o_MemReg		: out std_logic;
       o_MemWrite	: out std_logic;
       o_ALUSrc		: out std_logic;
       o_RegWrte	: out std_logic;
       o_RegDst		: out std_logic;
       o_Reg31Dst		: out std_logic;
       o_JAL 	: out std_logic;
       o_JR 	: out std_logic;
	   o_halt		: out std_logic;
	   o_SignExt	: out std_logic);
end Control_Logic;

architecture dataflow of Control_Logic is

begin 
  process(i_RegOpcode, i_funct) is
  begin

    case i_RegOpcode is
	when "000000" => -- R format 
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegDst  <= '1';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_AluOP <= "0000";

		case i_funct is
			when "001000" =>	-- jr
				o_JR <= '1';
				o_RegWrte <= '0';

			when others =>	-- literally everything else
				o_JR <= '0';
				o_RegWrte <= '1';

		end case;

	 when "001000" =>  
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "0001";

	when "001001" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "1110";

	  when "001100" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '1';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "0010";

	   when "001111" => 
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "0011";

  when "100011" => -- lw
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "0100";

  when"001110" =>
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "1101";

  when "001101" => -- 
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '1';
		o_JAL <= '0';
		o_JR <= '0';	-- Zero extend
		o_AluOP <= "0101";

  when "001010" => -- slti
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '0';
  		o_ALUSrc <= '1';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "0110";


  when "101011" => -- sw
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '0';
		o_MemReg <= '1';
		o_MemWrite <= '1';
  		o_ALUSrc <= '1';
		o_RegWrte <= '0';
		o_RegDst  <= '1';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "0111";
	

  when "000100" => -- beq
		o_Jump <= '0';
		o_Branch <= '1';
		o_BranchNot <= '0';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "1000";


	     when "000101" => -- bne
		o_Jump <= '0';
		o_Branch <= '0';
		o_BranchNot <= '1';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "1111";

	      
	      when "000010" => --
		o_Jump <= '1';
		o_Branch <= '0';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "1001";


    when "000011" => -- jal
		o_Jump <= '1';
		o_Branch <= '0';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '1';
		o_RegDst  <= '0';
		o_Reg31Dst <= '1';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '1';
		o_JR <= '0';
		o_AluOP <= "1001";	

		when "010100" => -- halt
		o_Jump <= '0';
		o_Branch <= '0';
		o_MemReg <= '0';
		o_MemWrite <= '0';
  		o_ALUSrc <= '0';
		o_RegWrte <= '0';
		o_RegDst  <= '0';
		o_Reg31Dst <= '0';
		o_Halt	  <= '1';
		o_SignExt <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP <= "0000";

		when others =>
		o_Jump <= 'X';
		o_Branch <= 'X';
		o_MemReg <= 'X';
		o_MemWrite  <= '0';
  		o_ALUSrc  <= 'X';
		o_RegWrte  <= '0';
		o_RegDst   <= 'X';
		o_Reg31Dst <= 'X';
		o_Halt	  <= '0';
		o_SignExt <= '0';
		o_JAL <= '0';
		o_JR <= '0';
		o_AluOP  <= "XXXX";
		
		end case;

	end process;
end dataflow;
