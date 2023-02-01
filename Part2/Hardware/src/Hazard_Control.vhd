library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hazard_Control is

  port( i_ID_jump  	: in std_logic;
				i_EX_jump  	: in std_logic;
				i_MEM_jump  : in std_logic;
				i_WB_jump  	: in std_logic;

				i_branch  : in std_logic;

				i_IF_Opcode	: std_logic_vector(5 downto 0);

				i_RS	: std_logic_vector(4 downto 0);
				i_RT	: std_logic_vector(4 downto 0);

				i_ID_WA	: in std_logic_vector(4 downto 0); 
				i_EX_WA	: in std_logic_vector(4 downto 0);
				i_MEM_WA	: in std_logic_vector(4 downto 0);
			
				i_ID_WE	: in std_logic; 
				i_EX_WE	: in std_logic; 
				i_MEM_WE	: in std_logic; 
			
				o_stall	:	out std_logic);
end Hazard_Control;

architecture dataflow of Hazard_Control is

	signal I_Type_Stall : std_logic;
	signal R_Type_Stall : std_logic;

begin 

	-- If a jump occurs anywhere in the pipeline, stall
	-- If a branch occurs, stall
	-- If a data dependency occurs, stall

	I_Type_Stall <= '1' WHEN (
		i_IF_Opcode /= "000000" AND	-- I-Type
		i_IF_Opcode /= "000010" AND	-- No J-type
		i_IF_Opcode /= "000011" AND  -- No J-type
		i_RS /= "00000" AND			-- RS not 0
		((i_ID_WE = '1' AND i_RS = i_ID_WA) OR	-- ID is going to write back to reg file
		(i_EX_WE = '1' AND i_RS = i_EX_WA) OR		-- EX is going to write back to reg file
		(i_MEM_WE = '1' AND i_RS = i_MEM_WA))		-- MEM is going to write back to reg file
	)
	ELSE '0';

	R_Type_Stall <= '1' WHEN (
		i_IF_Opcode = "000000" AND	-- R-Type
		(i_RS /= "00000" OR i_RT /= "00000") AND	-- RS or RT not 0
		((i_ID_WE = '1' AND (i_RS = i_ID_WA OR i_RT = i_ID_WA)) OR 
		(i_EX_WE = '1' AND (i_RS = i_EX_WA OR i_RT = i_EX_WA)) OR
		(i_MEM_WE = '1' AND (i_RS = i_MEM_WA OR i_RT = i_MEM_WA)))
	)
	ELSE '0';

	o_stall <= '1' WHEN (
		i_ID_jump   = '1'
		OR i_EX_jump   = '1'
		OR i_MEM_jump  = '1'
		OR i_WB_jump   = '1'
		OR i_branch = '1'
		OR I_Type_Stall = '1'
		OR R_Type_Stall = '1'
	)
	ELSE '0';

end dataflow;
