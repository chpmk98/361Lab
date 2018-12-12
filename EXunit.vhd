-- EECS 361 Pipelined Processor
-- by Alvin Tan (12/08/2018)
-- This is the EX stage of the pipeline

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity EXunit is
    port (
        -- For controlling the ID/EX register
        clk       :  in std_logic;
        arst      :  in std_logic;
        IDEXwrite :  in std_logic;
        EXkill    :  in std_logic; -- To be same as BranchSel from Mem stage
        -- To be stored in the ID/EX register
           -- Normal fatBoi stuff
        ALUctr    :  in std_logic_vector(3 downto 0);
           -- Rs is unnecessary for subsequent stages.
           -- The values for busA and busB will be calculated in Funit,
           --  which should take in Rs and Rt.
           -- However, Rt and Rd are still necessary for WB and forwarding.
        Rs        :  in std_logic_vector(4 downto 0);
        Rt        :  in std_logic_vector(4 downto 0);
        Rd        :  in std_logic_vector(4 downto 0);
        Shamt     :  in std_logic_vector(4 downto 0);
        Imm16     :  in std_logic_vector(15 downto 0);
        RegDst    :  in std_logic;
        RegWr     :  in std_logic;
        ALUsrc    :  in std_logic;
        MemWr     :  in std_logic;
        MemtoReg  :  in std_logic;
           -- Weird IDunit stuff
        PCPFourOut:  in std_logic_vector(31 downto 0);
        Branch    :  in std_logic_vector(1 downto 0);
        BusA      :  in std_logic_vector(31 downto 0);
        BusB      :  in std_logic_vector(31 downto 0);
        -- Values from the forwarding unit
        BusAFor   :  in std_logic_vector(31 downto 0);
        BusBFor   :  in std_logic_vector(31 downto 0);
        -- Debugging material
        Reg7to0in :  in std_logic_vector(255 downto 0);
        -----------------------------------------------
        -- Information for Forwarding
         -- Note that Rw and ALUout are necessary for forwarding as well
        WrEX      : out std_logic;
        RsO       : out std_logic_vector(4 downto 0);
        RtO       : out std_logic_vector(4 downto 0);
        -- Information for Data Memory access
        MemWrout  : out std_logic;
        ALUout    : out std_logic_vector(31 downto 0);
        BusAOut   : out std_logic_vector(31 downto 0);
        BusBout   : out std_logic_vector(31 downto 0);
        -- Information for Writeback
        MemtoRegO : out std_logic;
        RegWrO    : out std_logic;
        Rw        : out std_logic_vector(4 downto 0);
        -- Information for Branch detection
        BrchTarget: out std_logic_vector(31 downto 0);
        BranchO   : out std_logic_vector(1 downto 0);
		  Zero      : out std_logic;
        -- Debugging material
        Carry     : out std_logic;
        Overflow  : out std_logic;
        Reg7to0out: out std_logic_vector(255 downto 0);
        -------------------------------------------------
        --Information for Hazard Unit
        ExMemRt   : out std_logic_vector(4 downto 0);
        BranchSel : out std_logic
    );
end EXunit;

architecture structural of EXunit is
    signal IDin   : std_logic_vector(142 downto 0);
    signal IDregM : std_logic_vector(142 downto 0);
    signal RegregM: std_logic_vector(255 downto 0);
    signal kill   : std_logic;
    signal extImm : std_logic_vector(31 downto 0);
    signal shftImm: std_logic_vector(31 downto 0);
    signal ALUin  : std_logic_vector(31 downto 0);
    signal nMtR   : std_logic;
    -- Useless signals generated from the branch adder
    signal Bc, Bo : std_logic;
    signal Branch_t: std_logic_vector(1 downto 0);
    
    signal Zero_t, Sign_t: std_logic;
    
    signal ALUOut_t: std_logic_vector(31 downto 0); 
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
    -- Determines whether or not we should reset the register to zeros
    rstLogic   : or_gate
       port map (arst, EXkill, kill);
    
    -- Lines up all the inputs into a single large register
    IDin <= Rs & ALUctr & Rt & Rd & Shamt & Imm16 & RegDst & RegWr & ALUsrc & MemWr & MemtoReg & PCPFourOut & Branch & BusA & BusB;
    
    -- This is the main register at the beginning of the stage
    IDEXreg    : reg_n_ar
       generic map (n => 143)
       port map (IDin, IDEXwrite, kill, '0', IDregM, clk, IDregM);
    
    -- Stores the seven registers for debugging purposes
    RegsReg    : reg_n_ar
       generic map (n => 256)
       port map (Reg7to0in, IDEXwrite, kill, '0', RegregM, clk, RegregM);
    
    -- Selects the register for Rw
    destRegMux : mux_n
       generic map (n => 5)
       port map (IDregM(102), IDregM(133 downto 129), IDregM(128 downto 124), Rw);
       --port map (RegDst, Rt, Rd, Rw);
    
    -- Sign-extends the immediate to 32 bits
    extender   : extender_signed
       port map (IDregM(118 downto 103), extImm);
       --port map (Imm16, extImm);
           
    -- Shifts the extended immediate for branch target calculation
    shifter    : shift_32
       port map (extImm, "00010", shftImm);

    -- Selects the second input to the ALU
    aluMux     : mux_32
       port map (IDregM(100), BusBFor, extImm, ALUin);
       --port map (ALUsrc, BusB, extImm, ALUin);
    
    -- This is our ALU
    alu_comp   : final_alu_32_v2
       port map (IDregM(123 downto 119), BusAFor, ALUin, IDregM(137 downto 134), ALUout_t, Zero_t, Carry, Overflow);
       --port map (Shamt, BusA, ALUin, ALUctr, ALUout, Zero, Carry, Overflow);
           
    -- This is our adder for branch target calculation
    adder_comp : add_32
       port map (IDregM(97 downto 66), shftImm, '0', BrchTarget, Bc, Bo);
       --port map (PCPFourOut, shftImm, '0', BrchTarget, Bc, Bo);

    -- This calculates whether or not our ALUout value should be forwarded to future steps.
    -- WrEX is set if the value generated by the ALU is to be written back to Rw
    not_comp   : not_gate
       port map (IDregM(98), nMtR);
       --port map (MemtoReg, nMtR);
    
    -- Gives input data to the Funit
    --and_comp   : and_gate
       --port map (nMtR, IDregM(101), WrEX);
       --port map (nMtR, RegWr, WrEX);
    WrEX <= IDregM(101);
    RsO <= IDregM(142 downto 138);
    ExMemRt <= IDregM(133 downto 129);

    -- Gives input data to MemWr stage for branch detection purposes
    BranchO <= IDregM(65 downto 64);
    --BranchO <= Branch;

    -- Gives input data to MemWr stage for memory access purposes
    --  and exposes BusA and BusB for the Funit
    MemWrout <= IDregM(99);
    BusAout <= IDregM(63 downto 32);
    BusBout <= IDregM(31 downto 0);
    --MemWrout <= MemWr;
    --BusBout <= BusB;
    
    -- Gives input data to MemWr stage for write back purposes
    MemtoRegO <= IDregM(98);
    RegWrO <= IDregM(101);
    --MemtoRegO <= MemtoReg;
    --RegWrO <= RegWr;
    
    ALUOut <= ALUOut_t;
    Sign_t <= ALUOut_t(31);
    Zero <= Zero_t;
    Branch_t <= IDregM(65 downto 64);

    invertBranch: not_gate_n generic map(n => 2) port map(Branch_t,invBranch);
    OneHot1: and_gate port map(invBranch(1),Branch_t(0),BranchOneHot(0)); -- Branch == 1
    OneHot2: and_gate port map(Branch_t(1),invBranch(0),BranchOneHot(1)); -- Branch == 2
    OneHot3: and_gate port map(Branch_t(1),Branch_t(0),BranchOneHot(2));    -- Branch == 3
        
    invertZero: not_gate port map(Zero_t,notZero);
    invertsign: not_gate port map(Sign_t,notSign);
        
    getBEQ: and_gate port map(BranchOneHot(0),Zero_t,beq_sel); -- Branch == 1 and Zero == 1
    getBNE: and_gate port map(BranchOneHot(1),notZero,bne_sel); -- Branch == 2 and Zero == 0
    setGTZ: and_gate port map(notSign,notZero,gtz);--greater than zero if not nonnegative and not zero
    getBGTZ: and_gate port map(BranchOneHot(2),gtz,bgtz_sel); -- Branch == 3 and Sign == 0 and Zero == 0
    
    Branchsel1: or_gate port map(beq_sel,bne_sel, beq_bne_sel);
    Branchsel2: or_gate port map(beq_bne_sel,bgtz_sel,BranchSel);

end architecture structural;





























