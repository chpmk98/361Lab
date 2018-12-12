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
        MemtoReg: in std_logic;
        Branch : in std_logic_vector (1 downto 0);
        Zero : in std_logic;
        Sign : in std_logic;
        
        --------Other Inputs--------
        arst :in std_logic;
        clk : in std_logic;
        MemFile : in string;
        
        --------Outputs--------
        BranchPCOut: out std_logic_vector(31 downto 0);
        BranchSel : out std_logic;
        Dout : out std_logic_vector (31 downto 0);
        MemtoRegO: out std_logic;
        ALUout : out std_logic_vector (31 downto 0);
        RegWR_out : out std_logic;
        WrEXO   : out std_logic;
        RwO   : out std_logic_vector(4 downto 0)
        );
end entity MemUnit;
        
architecture structural of MemUnit is
    signal BranchPC_t : std_logic_vector (31 downto 0);
    signal BusB_t : std_logic_vector (31 downto 0);
    signal ALUin_t : std_logic_vector (31 downto 0);
    signal Rw_t : std_logic_vector (4 downto 0);         -- NOTE: FIX ALL THE NUMBERINGS
    signal WrEX_t : std_logic;
    signal MemWR_t : std_logic;
    signal RegWR_t : std_logic;
    signal MemtoReg_t: std_logic;
    signal Branch_t : std_logic_vector (1 downto 0);
    signal Zero_t : std_logic;
    signal Sign_t : std_logic;
    
    signal reg_in : std_logic_vector(108 downto 0);
    signal reg_out : std_logic_vector(108 downto 0);
    
    signal invBranch: std_logic_vector(1 downto 0);
    signal BranchOneHot: std_logic_vector(2 downto 0);
    signal notZero: std_logic;
    signal notSign: std_logic;
    signal beq_sel: std_logic;
    signal bne_sel: std_logic;
    signal beq_bne_sel: std_logic;
    signal bgtz_sel: std_logic;
    signal gtz: std_logic;
    
    begin
        reg_in <= BranchSel & BranchPC & BusB & ALUin & Rw & WrEX & MemWR & RegWR & MemtoReg & Branch & Zero & Sign;
        
        BranchSel <= reg_out (109);
        BranchPC_t <= reg_out (108 downto 77);
        BusB_t <= reg_out (76 downto 45);
        ALUin_t <= reg_out (44 downto 13);
        Rw_t <= reg_out (12 downto 8);
        WrEX_t <= reg_out (7);
        MemWR_t <= reg_out (6);
        RegWR_t <= reg_out (5);
        MemtoReg_t <= reg_out (4);
        Branch_t <= reg_out (3 downto 2);
        Zero_t <= reg_out (1);
        Sign_t <= reg_out (0);
        
        ALUout <= ALUin_t;
        regWR_out <= RegWR_t;
        RwO <= Rw_t;
        WrEXO <= WrEX_t;
        MemtoRegO <= MemtoReg_t;
        BranchPCOut <= BranchPC_t;
        
        makeregister: reg_n_ar generic map(n => 110) port map(inWrite => reg_in,
								                        RegWr => '1',
								                        Rst => arst,
								                        arst => '0',
								                        aload => reg_out,
								                        clk => clk,
								                        Q => reg_out);
								                        
        makememory: sram generic map(mem_file => MemFile) port map(
        cs => '1',
        oe => '1',
        we => MemWr_t,
        addr => ALUin_t,
        din => BusB_t,
        dout => Dout);
        
        --invertBranch: not_gate_n generic map(n => 2) port map(Branch_t,invBranch);
        --OneHot1: and_gate port map(invBranch(1),Branch_t(0),BranchOneHot(0)); -- Branch == 1
        --OneHot2: and_gate port map(Branch_t(1),invBranch(0),BranchOneHot(1)); -- Branch == 2
        --OneHot3: and_gate port map(Branch_t(1),Branch_t(0),BranchOneHot(2));    -- Branch == 3
        
        --invertZero: not_gate port map(Zero_t,notZero);
        --invertsign: not_gate port map(Sign_t,notSign);
        
        --getBEQ: and_gate port map(BranchOneHot(0),Zero_t,beq_sel); -- Branch == 1 and Zero == 1
        --getBNE: and_gate port map(BranchOneHot(1),notZero,bne_sel); -- Branch == 2 and Zero == 0
        --setGTZ: and_gate port map(notSign,notZero,gtz);--greater than zero if not nonnegative and not zero
        --getBGTZ: and_gate port map(BranchOneHot(2),gtz,bgtz_sel); -- Branch == 3 and Sign == 0 and Zero == 0
        
        --Branchsel1: or_gate port map(beq_sel,bne_sel, beq_bne_sel);
        --Branchsel2: or_gate port map(beq_bne_sel,bgtz_sel,BranchSel);
        
        
end architecture structural;

