-------- Written by Rabin Zhao EECS361--------
library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity MemUnit is
    port(
        --------Inputs that get passed through the MUX--------
        BranchPC : in std_logic_vector (31 downto 0);
        BusB : in std_logic_vector (31 downto 0);
        ALUin : in std_logic_vector (31 downto 0);
        Rw : in std_logic_vector (4 downto 0);         -- NOTE: FIX ALL THE NUMBERINGS
        WrEX : in std_logic;
        MemWR : in std_logic;
        RegWR : in std_logic;
        Branch : in std_logic_vector (1 downto 0);
        Zero : in std_logic;
        Sign : in std_logic;
        
        --------Other Inputs--------
        arst :in std_logic;
        clk : in std_logic;
        MemFile : in string;
        BranchSel : out std_logic;
        
        --------Outputs--------
        Dout : out std_logic_vector (31 downto 0);
        ALUout : out std_logic_vector (31 downto 0);
        RegWR_out : out std_logic;
        WrEXO   : out std_logic
        );
end entity MemUnit;
        
architecture structural of MemUnit is
    signal Branch_t : std_logic_vector(1 downto 0);
    signal Zero_t : std_logic;
    signal Sign_t : std_logic;
    signal RegWR_t : std_logic;
    signal EXMEM_MemWr : std_logic_vector (31 downto 0);
    signal reg_in, reg_out : std_logic_vector (133 downto 0);
    signal BranchPC_t : std_logic_vector (31 downto 0);
    signal BusB_t : std_logic_vector (31 downto 0);
    signal ALUin_t : std_logic_vector (31 downto 0);
    signal Rw_t : std_logic_vector (31 downto 0);
    signal MemWR_t : std_logic;
    
    signal invBranch: std_logic_vector(1 downto 0);
    signal BranchOneHot: std_logic_vector(2 downto 0);
    signal notZero: std_logic;
    signal notSign: std_logic;
    signal beq_sel: std_logic;
    signal bne_sel: std_logic;
    signal beq_bne_sel: std_logic;
    signal bgtz_sel: std_logic;
    signal gtz: std_logic;
    
    signal fwRegM : std_logic;
    
    begin
        reg_in <= Branch & Zero & Sign & RegWR & BranchPC & BusB & ALUin & Rw & MemWR;
        
        Branch_t <= reg_out (133 downto 132);
        Zero_t <= reg_out (131);
        Sign_t <= reg_out (130);
        RegWR_t <= reg_out (129);
        BranchPC_t <= reg_out (128 downto 97);
        BusB_t <= reg_out (96 downto 65);
        ALUin_t <= reg_out (64 downto 33);
        Rw_t <= reg_out (32 downto 1);
        MemWR_t <= reg_out (0); 
        
        ALUout <= reg_out(37 downto 6);
        --ALUout <= ALUin;
        regWR_out <= RegWR_t;
        
        -- Stores WrEX for forwarding purposes
        forwardingReg: reg_n_ar
           generic map (n => 1)
           port map (WrEX, MemWR, arst, '0', fwRegM, clk, fwRegM);
        WrEXO <= fwRegM;
        
        makeregister: reg_n_ar generic map(n => 134) port map(inWrite => reg_in,
								                        RegWr => MemWR,
								                        Rst => arst,
								                        arst => '0',
								                        aload => x"00000000",
								                        clk => clk,
								                        Q => reg_out);
								                        
        makememory: sram generic map(mem_file => MemFile) port map(
        cs => '1',
        oe => '1',
        we => MemWr_t,
        addr => BusB_t,
        din => ALUin_t,
        dout => Dout);
        
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
        
        
end architecture structural;

