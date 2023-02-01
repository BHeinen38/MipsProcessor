library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity fourReg is
	port(	
			-- input IF/ID		
		iClk : in std_logic;
	     	iRst : in  std_logic;
                iFlush : in  std_logic;
		i_PC1   : in std_logic_vector(31 downto 0);
		i_Inst1 : in in std_logic_vector(31 downto 0);


			--input ID/EX
		 
	     -- i_PC2		        : in std_logic_vector(31 downto 0); --
	      i_D1 	    : in std_logic_vector(31 downto 0); --
	      i_D2	    : in std_logic_vector(31 downto 0); --
	      i_signExt 	  : in std_logic_vector(31 downto 0);--
	      i_jumpAddr1 	      : in std_logic_vector(31 downto 0);--
	      i_Inst2 	          : in std_logic_vector(31 downto 0); -- I am unsure why this is here 
		i_RWA1             : in std_logic_vector(4 downto 0);
		     
	       
	      i_AluOPSignal1    	: in std_logic_vector(3 downto 0);
	      i_JumpSignal1	    : in std_logic;
	      i_BranchSignal1		: in std_logic;
	      i_BranchNotSignal1	: in std_logic;
	      i_MemRegSignal1		: in std_logic;
	      i_MemWriteSignal1	: in std_logic;
	      i_ALUSrcSignal1		: in std_logic;
	      i_RegWrteSignal1	  : in std_logic;
	      i_JALSignal1       : in std_logic;
	      i_JRSignal1       : in std_logic;
	      i_haltSignal1      : in std_logic;

			--input EX/MEM
	     	i_secondAddOut1	   	 : in std_logic_vector(31 downto 0);--
      		i_jumpAddr2        	: in std_logic_vector(31 downto 0);--
	     	i_Data2 	    	: in std_logic_vector(31 downto 0);----
	     	i_aluOutput1	    	: in std_logic_vector(31 downto 0);----
	     	i_RWA2    		: in std_logic_vector(4 downto 0);----
	     	i_ALUzero1		    : in std_logic;	    
         	i_JumpSignal2		: in std_logic;  
         	i_BranchSignal2		: in std_logic;
         	i_BranchNotSignal2	: in std_logic;
         	i_MemRegSignal2		: in std_logic;
         	i_MemWriteSignal2	: in std_logic;
         	i_RegWrteSignal2		: in std_logic;
         	i_JALSignal2        	: in std_logic;
         	i_JRSignal2        	 : in std_logic;
         	i_haltSignal2      	 : in std_logic;
		 i_Inst3			: in std_logic_vector(31 downto 0);
		 i_PC3			: in std_logic_vector(31 downto 0);


			--input MEM/WB
		i_jumpAddr3 	    : in std_logic_vector(31 downto 0); --
		i_aluOutput2	    : in std_logic_vector(31 downto 0);
		i_RWA3    				: in std_logic_vector(4 downto 0);
		i_DataMEM 	: in std_logic_vector(31 downto 0);
	
	
	
		i_JumpSignal3		  : in std_logic; -- 
		i_MemRegSignal3		: in std_logic;--
		i_RegWrteSignal3  : in std_logic; --
		i_JALSignal3       : in std_logic;--
		i_JRSignal3        : in std_logic;--
		i_haltSignal3      : in std_logic;--
		i_Inst4      : in std_logic_vector(31 downto 0);--
		i_PC4      : in std_logic_vector(31 downto 0);--

		

		

			--output IF/ID
                o_PC1   : out std_logic_vector(31 downto 0); -- this is an input for the ID/EX reg
		o_Inst1 : out std_logic_vector(31 downto 0);

		--output ID/EX
	     	--o_PC2		: out std_logic_vector(31 downto 0);
	     	o_D1 	: out std_logic_vector(31 downto 0);
	     	o_D2 	: out std_logic_vector(31 downto 0);
	     	o_signExt	: out std_logic_vector(31 downto 0);
	     	o_JumpAddr1 	: out std_logic_vector(31 downto 0);
	     	o_Inst2 	        : out std_logic_vector(31 downto 0);
       		o_RWA2    : out std_logic_vector(4 downto 0);----
        
            	o_AluOPSignal1    	: out std_logic_vector(3 downto 0);
            	o_JumpSignal1		  : out std_logic;
            	o_BranchSignal1		: out std_logic;
            	o_BranchNotSignal1		: out std_logic;
            	o_MemRegSignal1		: out std_logic;
            	o_MemWriteSignal1	: out std_logic;
	    	o_ALUSrcSignal1		: out std_logic;
	    	o_RegWrteSignal1	  : out std_logic;
	    	o_JALSignal1       : out std_logic;
	    	o_JRSignal1        : out std_logic;
	    	o_haltSignal1      : out std_logic;

			
			--output of EX/MEM
		o_Inst3			: out std_logic_vector(31 downto 0);
		o_PC3			: out std_logic_vector(31 downto 0);
	     	o_secondAddout1		: out std_logic_vector(31 downto 0);
      		o_Data2 	        : out std_logic_vector(31 downto 0);
	     	o_jumpAddr2 	        : out std_logic_vector(31 downto 0);
	     	o_aluOutput1	 	    : out std_logic_vector(31 downto 0);
	     	o_RWA2 	    		: out std_logic_vector(4 downto 0);

	
	    	 o_ALUzero1		: out std_logic;
	     
	     	o_JumpSignal2           : out std_logic; --
         	o_BranchSignal2         : out std_logic; --
         	o_BranchNotSignal2      : out std_logic; --
         	o_MemRegSignal2         : out std_logic; --
         	o_MemWriteSignal2       : out std_logic; --
         	o_RegWrteSignal2        : out std_logic;  --
         	o_JALSignal2            : out std_logic;
         	o_JRSignal2             : out std_logic;
         	o_haltSignal2           : out std_logic;

			--output MEM/WB
		o_Inst4      : out std_logic_vector(31 downto 0);--
		o_PC4      : out std_logic_vector(31 downto 0);--
		o_DataMEM 	        : out std_logic_vector(31 downto 0);
		o_jumpAddr3     	    : out std_logic_vector(31 downto 0); 
		o_aluOutput2	 	    : out std_logic_vector(31 downto 0);
		o_RWA3 	    : out std_logic_vector(4 downto 0);

	
	
		o_JumpSignal3           : out std_logic; --
		o_MemRegSignal3         : out std_logic; --
		o_RegWrteSignal3        : out std_logic;  --
		o_JALSignal3            : out std_logic;
		o_JRSignal3             :out std_logic;
		o_haltSignal3           :out std_logic);

end fourReg;

-- architecture
architecture structural of fourReg is

component IF_ID_reg is
	port(i_CLK		: in std_logic;
	     i_RST		: in std_logic; 
			 i_Flush	: in std_logic;
	     i_PC_4		: in std_logic_vector(31 downto 0);
	     i_Inst  	: in std_logic_vector(31 downto 0);
	     o_PC_4	  	: out std_logic_vector(31 downto 0);
	     o_Inst	: out std_logic_vector(31 downto 0));
end component;

component ID_EX_reg is
	port(
      i_CLK		          : in std_logic; 
      i_RST		          : in std_logic; 
      i_Flush		        : in std_logic; 
      i_PC_4		        : in std_logic_vector(31 downto 0); --
      i_readData1 	    : in std_logic_vector(31 downto 0); --
      i_readData2 	    : in std_logic_vector(31 downto 0); --
      i_signExtender 	  : in std_logic_vector(31 downto 0);--
      i_jumpAddr 	      : in std_logic_vector(31 downto 0);--
      i_Inst 	          : in std_logic_vector(31 downto 0); -- I am unsure why this is here 
	i_RWA             : in std_logic_vector(4 downto 0);
	     
       
      i_AluOPSignal    	: in std_logic_vector(3 downto 0);
      i_JumpSignal	    : in std_logic;
      i_BranchSignal		: in std_logic;
      i_BranchNotSignal	: in std_logic;
      i_MemRegSignal		: in std_logic;
      i_MemWriteSignal	: in std_logic;
      i_ALUSrcSignal		: in std_logic;
      i_RegWrteSignal	  : in std_logic;
      i_JALSignal       : in std_logic;
      i_JRSignal        : in std_logic;
      i_haltSignal      : in std_logic;
      


	     o_PC_4		: out std_logic_vector(31 downto 0);
	     o_readData1 	: out std_logic_vector(31 downto 0);
	     o_readData2 	: out std_logic_vector(31 downto 0);
	     o_signExtender	: out std_logic_vector(31 downto 0);
	     o_jumpAddr 	: out std_logic_vector(31 downto 0);
	     o_Inst 	        : out std_logic_vector(31 downto 0);
       o_RWA    : out std_logic_vector(4 downto 0);----
        
	     

            
            o_AluOPSignal    	: out std_logic_vector(3 downto 0);
            o_JumpSignal		  : out std_logic;
            o_BranchSignal		: out std_logic;
            o_BranchNotSignal		: out std_logic;
            o_MemRegSignal		: out std_logic;
            o_MemWriteSignal	: out std_logic;
            o_ALUSrcSignal		: out std_logic;
            o_RegWrteSignal	  : out std_logic;
            o_JALSignal       : out std_logic;
            o_JRSignal        : out std_logic;
           
            o_haltSignal      : out std_logic);
            
end component;

component EX_MEM_reg is
	port(	i_CLK		        : in std_logic;
	     	i_RST		        : in std_logic; 
	     	i_secondAddOut	    : in std_logic_vector(31 downto 0);--
      	i_jumpAddr         : in std_logic_vector(31 downto 0);--
	     	i_readData2 	    : in std_logic_vector(31 downto 0);----
	     	i_aluOutput	    : in std_logic_vector(31 downto 0);----
	     	i_RWA    : in std_logic_vector(4 downto 0);----

  
	     i_ALUzero		    : in std_logic;
	    
         i_JumpSignal		: in std_logic;  
         i_BranchSignal		: in std_logic;
         i_BranchNotSignal	: in std_logic;
         i_MemRegSignal		: in std_logic;
         i_MemWriteSignal	: in std_logic;
         i_RegWrteSignal	: in std_logic;
         i_JALSignal        : in std_logic;
         i_JRSignal         : in std_logic;
         i_haltSignal       : in std_logic;
				 i_Inst							: in std_logic_vector(31 downto 0);
				 i_PC								: in std_logic_vector(31 downto 0);

				o_Inst								: out std_logic_vector(31 downto 0);
				o_PC								: out std_logic_vector(31 downto 0);
	     	o_secondAddout		    : out std_logic_vector(31 downto 0);
      	o_readData2 	        : out std_logic_vector(31 downto 0);
	     	o_jumpAddr 	        : out std_logic_vector(31 downto 0);
	     	o_aluOutput	 	    : out std_logic_vector(31 downto 0);
	     	o_RWA 	    : out std_logic_vector(4 downto 0);

	
	     o_ALUzero		        : out std_logic;
	     
	     o_JumpSignal           : out std_logic; --
         o_BranchSignal         : out std_logic; --
         o_BranchNotSignal      : out std_logic; --
         o_MemRegSignal         : out std_logic; --
         o_MemWriteSignal       : out std_logic; --
         o_RegWrteSignal        : out std_logic;  --
         o_JALSignal            : out std_logic;
         o_JRSignal             : out std_logic;
         o_haltSignal           : out std_logic);

end component;

component MEM_WB_reg is
	port(
		i_CLK		        : in std_logic;
		i_RST		        : in std_logic;
		i_jumpAddr 	    : in std_logic_vector(31 downto 0); --
		i_aluOutput	    : in std_logic_vector(31 downto 0);
		i_RWA    				: in std_logic_vector(4 downto 0);
		i_readDataMEM 	: in std_logic_vector(31 downto 0);
	
	
	
		i_JumpSignal		  : in std_logic; -- 
		i_MemRegSignal		: in std_logic;--
		i_RegWrteSignal	  : in std_logic; --
		i_JALSignal       : in std_logic;--
		i_JRSignal        : in std_logic;--
		i_haltSignal      : in std_logic;--
		i_Inst      : in std_logic_vector(31 downto 0);--
		i_PC      : in std_logic_vector(31 downto 0);--

		o_Inst      : out std_logic_vector(31 downto 0);--
		o_PC      : out std_logic_vector(31 downto 0);--
		o_readDataMEM 	        : out std_logic_vector(31 downto 0);
		o_jumpAddr     	    : out std_logic_vector(31 downto 0); 
		o_aluOutput	 	    : out std_logic_vector(31 downto 0);
		o_RWA 	    : out std_logic_vector(4 downto 0);

	
	
		o_JumpSignal           : out std_logic; --
		o_MemRegSignal         : out std_logic; --
		o_RegWrteSignal        : out std_logic;  --
		o_JALSignal            : out std_logic;
		o_JRSignal             :out std_logic;
		o_haltSignal           :out std_logic);

end component;

signal PC1, PC2, PC3 : std_logic_vector(31 downto 0);
signal inst1, inst2, inst3  : std_logic_vector (31 downto 0);
signal jumpAddr1, jumpAddr2, : std_logic_vector (31 downto 0);
signal halt1, halt2 : std_logic;
signal JR1, JR2 : std_logic;
signal Jal1, Jal2 : std_logic;
signal MemReg1, MemReg2 : std_logic:
signal RegWrte1, RegWrte2 :std_logic;
signal Jump1, Jump2 : std_logic;
signal Branch1 :std_logic;
signal BranchNot1  :std_logic;
signal MemWrite : std_logic:
signal aluOutput : std_logic_vector(31 downto 0);



begin


IFID: IF_ID_reg port map(
	i_CLK  => iClk,	
	i_RST  => iRst,
	i_Flush	=> iFlush,
	i_PC_4 => i_PC1,	
	i_Inst =>  i_Inst1, 	
	o_PC_4 => PC1,
	o_Inst => inst1);

IDEX: ID_EX_reg port map(
      	i_CLK => iClk,
      	i_RST => iRst,
      	i_Flush => iFlush,
      	i_PC_4 => PC1, 
      	i_readData1 => i_D1, 
      	i_readData2 => i_D2,
      	i_signExtender => i_signExt,
      	i_jumpAddr => i_jumpAddr1,
      	i_Inst => inst1,   
	i_RWA => i_RWA1,


	     
       
      	i_AluOPSignal =>  i_AluOPSignal1,
      	i_JumpSignal => i_JumpSignal1,
      	i_BranchSignal => i_BranchSignal1,
      	i_BranchNotSignal => i_BranchNotSignal1,	
      	i_MemRegSignal => i_MemRegSignal1,
      	i_MemWriteSignal => i_MemWriteSignal1,
      	i_ALUSrcSignal => i_ALUSrcSignal1,
      	i_RegWrteSignal =>  i_RegWrteSignal1,
      	i_JALSignal => i_JALSignal1,
      	i_JRSignal  => i_JRSignal1,
      	i_haltSignal => i_haltSignal1,



	o_PC_4	=> PC2,
	o_readData1 => o_D1,
     	o_readData2 => o_D2,
	o_signExtender => o_signExt,
	o_jumpAddr => jumpAddr1, --this needs to be a signal
	o_Inst => inst2,
       	o_RWA  => ,
        
	     

            
        o_AluOPSignal => o_AluOPSignal1,    
    	o_JumpSignal	=> Jump1, --this needs to be a signal 
    	o_BranchSignal	=> Branch1, --this needs to be a signal 
    	o_BranchNotSignal => BranchNot1, --this needs to be a signal 
    	o_MemRegSignal	=> MemReg1,  --this needs to be a signal 
    	o_MemWriteSignal => MemWrite, --this needs to be a signal 
    	o_ALUSrcSignal => o_ALUSrcSignal1,	
    	o_RegWrteSignal	=> RegWrte1, --this needs to be a signal 
    	o_JALSignal => Jal1, --this needs to be a signal 
    	o_JRSignal => JR1, --this needs to be a signal 
   
    	o_haltSignal => halt1); --this needs to be a signal 



EXMEM:  EX_MEM_reg  port map (
		i_CLK => iClk,
	     	i_RST => iRst,	 
	     	i_secondAddOut => ,	    
      		i_jumpAddr => jumpAddr1,         
	     	i_readData2 => , 	 
	     	i_aluOutput => i_aluOutput1,	    
	     	i_RWA => ,   

  
	     	i_ALUzero => i_ALUzero1,		  
	    
         	i_JumpSignal => Jump1,	 
         	i_BranchSignal	=> Branch1,	
         	i_BranchNotSignal => BranchNot1,	
         	i_MemRegSignal => MemReg1,		
         	i_MemWriteSignal => MemWrite,	
         	i_RegWrteSignal	=> RegWrte1,
         	i_JALSignal => Jal1,        
         	i_JRSignal => JR1,          
         	i_haltSignal => halt1,    
		i_Inst => inst2,
		i_PC => PC2,

		o_Inst	=> inst3,
		o_PC	=> PC3,
	     	o_secondAddout => ,	
      		o_readData2 => , 	
	     	o_jumpAddr => jumpAddr2,
	     	o_aluOutput => aluOutput,
	     	o_RWA => ,

	
	     	o_ALUzero => o_ALUzero1,	
	     
	     	o_JumpSignal => Jump2, 
         	o_BranchSignal  => o_BranchSignal2,
         	o_BranchNotSignal => o_BranchNotSignal2,
         	o_MemRegSignal  => MemReg2,
         	o_MemWriteSignal => o_MemWriteSignal2,
         	o_RegWrteSignal  => RegWrte2,
         	o_JALSignal  => Jal2,
         	o_JRSignal  => JR2,
         	o_haltSignal => halt2);

MEMWB:  MEM_WB_reg port map(
		i_CLK	=> iClk,
		i_RST => iRst,
		i_jumpAddr => jumpAddr2, 
		i_aluOutput => aluOutput,
		i_RWA => ,
		i_readDataMEM => , 
	
	
	
		i_JumpSignal => Jump2,
		i_MemRegSignal => MemReg2,
		i_RegWrteSignal => RegWrte2,
		i_JALSignal => Jal2,
		i_JRSignal  => JR2, 
		i_haltSignal => halt2, 
		i_Inst => inst3, 
		i_PC  => PC3, 

		o_Inst => o_Inst4,
		o_PC => o_PC4,
		o_readDataMEM => o_DataMEM, 	
		o_jumpAddr => o_jumpAddr3,
		o_aluOutput => o_aluOutput2, 
		o_RWA => o_RWA3,



	
	
		o_JumpSignal => o_JumpSignal3,
		o_MemRegSignal => o_MemRegSignal3,
		o_RegWrteSignal => o_RegWrteSignal3, 
		o_JALSignal => o_JALSignal3,
		o_JRSignal => o_JRSignal3,
		o_haltSignal => o_haltSignal3);


    
end structural;
