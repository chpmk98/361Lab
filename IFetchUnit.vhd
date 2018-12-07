library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;

entity IFetchUnit is
    port(
        clk: in std_logic;
        arst: in std_logic; -- resets the PC to 0x00400020
        PCWrite: in std_logic; -- stop PC from updating if there is a stall
        BranchSel: in std_logic;
        BranchPC: in std_logic_vector(31 downto 0);
        PCD: out std_logic_vector(31 downto 0);
        PCPFour: out std_logic_vector(31 downto 0);
        --BPC: out std_logic_vector(31 downto 0);
        Instruction: out std_logic_vector(31 downto 0);
        InFile: string
    );
end entity IFetchUnit;

architecture structural of IFetchUnit is
    signal PCin: std_logic_vector(31 downto 0);
    signal PCout: std_logic_vector(31 downto 0);
    
    signal PCplus4: std_logic_vector(31 downto 0);
    signal PCplusOffset: std_logic_vector(31 downto 0);
    signal InstrMemOut: std_logic_vector(31 downto 0);
    signal ExtOut: std_logic_vector(31 downto 0);
    signal ImmAdd: std_logic_vector(31 downto 0);

    signal invBranch: std_logic_vector(1 downto 0);
    signal BranchOneHot: std_logic_vector(2 downto 0);
    signal notZero: std_logic;
    signal notSign: std_logic;
    signal beq_sel: std_logic;
    signal bne_sel: std_logic;
    signal beq_bne_sel: std_logic;
    signal bgtz_sel: std_logic;
    signal gtz: std_logic;
    
    component reg_32_ar is
        port (
            inWrite :  in std_logic_vector(31 downto 0);
            RegWr   :  in std_logic;
            Rst     :  in std_logic;
            arst    :  in std_logic;
            aload   :  in std_logic_vector(31 downto 0);
            clk     :  in std_logic;
            Q       : out std_logic_vector(31 downto 0)
        );
    end component reg_32_ar;
    
    component add_32 is
	    port(
	    a_in 	: in std_logic_vector(31 downto 0);
	    b_in	: in std_logic_vector(31 downto 0);
	    c_in : in std_logic;
	    sout	: out std_logic_vector(31 downto 0);
	    cout: out std_logic;
	    oflow: out std_logic
	    );
    end component add_32;
    
    begin
        PC: reg_32_ar port map(Pcin,PCWrite,'0',arst,x"00400020",clk,Pcout);
        
        Add4toPC: add_32 port map("00000000000000000000000000000100",Pcout,'0',PCplus4,open,open);
        
        SelectPC: mux_32 port map(BranchSel,PCplus4,BranchPC,PCin); --select PC when branch condition met
        
        MakeInstructionMemory: sram 
        generic map(mem_file => InFile)
        port map(
        cs => '1',
        oe =>'1',
        we => '0',
        addr => PCout,
        din => "00000000000000000000000000000000",
        dout => InstrMemOut);
        
        Instruction <= InstrMemOut;     
        PCD <= PCout;
        PCPFour <= PCPlus4;
        --BPC <= BranchPC;
                
        
        
end architecture structural;