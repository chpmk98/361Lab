library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.InstructionFetchUnitPackage.all;

entity InstructionFetchUnit is
    port(
        clk: in std_logic;
        arst: in std_logic; -- resets the PC to 0x00400020
        Branch: in std_logic_vector(1 downto 0);
        Zero: in std_logic;
        Sign: in std_logic;
        PCD: out std_logic_vector(31 downto 0);
        --BPC: out std_logic_vector(31 downto 0);
        Instruction: out std_logic_vector(31 downto 0);
        InFile: string
    );
end entity InstructionFetchUnit;

architecture structural of InstructionFetchUnit is
    signal PCin: std_logic_vector(31 downto 0);
    signal PCout: std_logic_vector(31 downto 0);
    
    signal PCplus4: std_logic_vector(31 downto 0);
    signal PCplusOffset: std_logic_vector(31 downto 0);
    signal InstrMemOut: std_logic_vector(31 downto 0);
    signal ExtOut: std_logic_vector(31 downto 0);
    signal ImmAdd: std_logic_vector(31 downto 0);
    
    signal BranchPC: std_logic_vector(31 downto 0);
    signal BranchSel: std_logic;
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
        PC: reg_32_ar port map(Pcin,'1','0',arst,x"00400020",clk,Pcout);
        
        Add4toPC: add_32 port map("00000000000000000000000000000100",Pcout,'0',PCplus4,open,open);
        
        extendImm16: extender_signed port map(InstrMemOut(15 downto 0),ExtOut);
        leftshiftby2:ImmAdd <= ExtOut(29 downto 0) & "00"; --compensate for the fact that we are recycling 32 bit adders
        
        BranchCalc: add_32 port map(ImmAdd,PCPlus4,'0',BranchPC,open,open);
        
        invertBranch: not_gate_n generic map(n => 2) port map(Branch,invBranch);
        OneHot1: and_gate port map(invBranch(1),Branch(0),BranchOneHot(0)); -- Branch == 1
        OneHot2: and_gate port map(Branch(1),invBranch(0),BranchOneHot(1)); -- Branch == 2
        OneHot3: and_gate port map(Branch(1),Branch(0),BranchOneHot(2));    -- Branch == 3
        
        invertZero: not_gate port map(Zero,notZero);
        invertsign: not_gate port map(Sign,notSign);
        
        getBEQ: and_gate port map(BranchOneHot(0),Zero,beq_sel); -- Branch == 1 and Zero == 1
        getBNE: and_gate port map(BranchOneHot(1),notZero,bne_sel); -- Branch == 2 and Zero == 0
        setGTZ: and_gate port map(notSign,notZero,gtz);--greater than zero if not nonnegative and not zero
        getBGTZ: and_gate port map(BranchOneHot(2),gtz,bgtz_sel); -- Branch == 3 and Sign == 0 and Zero == 0
        
        Branchsel1: or_gate port map(beq_sel,bne_sel, beq_bne_sel);
        Branchsel2: or_gate port map(beq_bne_sel,bgtz_sel,BranchSel);
        
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
        --BPC <= BranchPC;
                
        
        
end architecture structural;