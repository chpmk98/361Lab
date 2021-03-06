library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity IDecodeUnit is
	port(
		clk: in std_logic;
		arst: in std_logic;
		IFIDWrite: in std_logic;
		Instruction: in std_logic_vector(31 downto 0); --instruction from the IF stage
		PCPFour: in std_logic_vector(31 downto 0);
		InputRegWr: in std_logic;
		InputRw: in std_logic_vector(4 downto 0);
		InputBusW: in std_logic_vector(31 downto 0);
		LoadHazard: in std_logic; --LoadHazard and IFIDWrite should be opposite signals
		IFFlush: in std_logic; -- IFFlush is the same as BranchSel from Mem stage
		------------------------------------------------
		PCPFourOut: out std_logic_vector(31 downto 0);
		Imm16: out std_logic_vector(15 downto 0);
		Rsout: out std_logic_vector(4 downto 0);
		Rtout: out std_logic_vector(4 downto 0);
		Rdout: out std_logic_vector(4 downto 0);
		ALUSrc: out std_logic;
		ALUCtr: out std_logic_vector(3 downto 0);
		RegDst: out std_logic;
		MemWr: out std_logic;
		Branch: out std_logic_vector(1 downto 0);
		MemtoReg: out std_logic;
		RegWr: out std_logic;
		BusAOut: out std_logic_vector(31 downto 0);
		BusBOut: out std_logic_vector(31 downto 0);
		--debug stuff below
		Reg7to0: out std_logic_vector(255 downto 0)
	);
end entity IDecodeUnit;

architecture structural of IDecodeUnit is
signal ALUop: std_logic_vector(1 downto 0);
signal IFID_Inst: std_logic_vector(31 downto 0);
signal Rs, Rt, Rd: std_logic_vector(4 downto 0);
signal invclk: std_logic;
signal BusA, BusB: std_logic_vector(31 downto 0);
signal FWRegA: std_logic;
signal FWRegB: std_logic;
signal compA, compB: std_logic;
signal mux_in, mux_out: std_logic_vector(2 downto 0);
signal PCPFourOut_t: std_logic_vector(31 downto 0);
signal Imm16_t: std_logic_vector(15 downto 0);
signal Rtout_t: std_logic_vector(4 downto 0);
signal Rdout_t: std_logic_vector(4 downto 0);
signal ALUSrc_t: std_logic;
signal	ALUCtr_t: std_logic_vector(3 downto 0);
signal	RegDst_t: std_logic;
signal	MemWr_t: std_logic;
signal	Branch_t: std_logic_vector(1 downto 0);
signal	MemtoReg_t: std_logic;
signal	RegWr_t: std_logic;
signal	BusAOut_t: std_logic_vector(31 downto 0);
signal	BusBOut_t: std_logic_vector(31 downto 0);
signal flush_reg: std_logic;
signal RWZero, RwNotZero: std_logic;
signal FWRegA_t, FWRegB_t: std_logic;

component regCompare is
    port(
        Ra: in std_logic_vector(4 downto 0);
        Rb: in std_logic_vector(4 downto 0);
        eq: out std_logic
    );
end component regCompare;
begin
   --just in case
   NOTCLOCK: not_gate port map(clk, invclk);
   --make IFID Register
   RST_LOGIC: or_gate port map(arst,IFFlush,flush_reg);
	IFIDReg1: reg_n_sync generic map(n => 32) port map(inWrite => Instruction,
	                                    sFlush => IFFlush,
													RegWr => IFIDWrite,
													Rst => arst,
													arst => '0',
													aload => IFID_Inst,
													clk => clk,
													Q => IFID_Inst);
	IFIDReg2: reg_n_sync generic map(n => 32) port map(inWrite => PCPFour,
	                                    sFlush => IFFlush,
													RegWr => IFIDWrite,
													Rst => arst,
													arst => '0',
													aload => IFID_Inst,
													clk => clk,
													Q => PCPFourOut_t);
	--extract codes from instruction
	Rs <= IFID_Inst(25 downto 21);
	Rt <= IFID_Inst(20 downto 16);
	Rd <= IFID_Inst(15 downto 11);
	Imm16_t <= IFID_Inst(15 downto 0);
	--throw the codes into Control Units
	MainFlags: MainControl port map(op => IFID_Inst(31 downto 26),
            						ALUop => ALUop,
            						ALUSrc => ALUSrc_t,
            						RegWr => RegWr_t,
            						RegDst => RegDst_t,
            						ExtOp => open,
            						MemWr => MemWr_t,
            						MemtoReg => MemtoReg_t,
            						Branch => Branch_t);

    ALUFlags: ALU_Control port map(func => IFID_Inst(5 downto 0),
    							  ALUop => ALuop,
    							  ALUCtr => ALUCtr_t);
   	--registers get values from WB stage, and read values from IFID Register
    makeRegisters: reg_comp port map(RegWr => InputRegWr,
        							 Rw => InputRw,
        							 Ra => Rs,
        							 Rb => Rt,
        							 busW => InputBusW,
        							 clk => clk,
        							 busA => BusA,
        							 busB => BusB,
        							 reg7to0 => Reg7to0
        							 );
	 --Forward From WB stage in case we are reading and writing to same register
	 FWzeroCase: regCompare port map(InputRw, "00000", RwZero);
	 FWNZ: not_gate port map(RwZero, RwNotZero);

	 makeFWRegA0: regCompare port map(Rs,InputRw, compA);
	 makeFWRegA1: and_gate port map(compA, InputRegWr,FWRegA_t);
	 makeFWRegA2: and_gate port map(FWRegA_t, RWNotZero,FWRegA);
	 
	 makeFWRegB0: regCompare port map(Rt, InputRw, compB);
	 makeFWRegB1: and_gate port map(compB, InputRegWr, FWRegB_t);
	 makeFWRegB2: and_gate port map(FWRegB_t, RWNotZero, FWRegB);
	 
	 busASelect: mux_32 port map(FWRegA, BusA, InputBusW,BusAOut_t);
	 busBSelect: mux_32 port map(FWRegB, BusB, InputBusW,BusBOut_t);
	 
	 --Mux for stalling zeros out everything if stall flag occurs
	 mux_in <= MemWr_t & 
              MemtoReg_t &
              RegWr_t;
    --if LoadHazard flag is raised if stall is needed
	 stallmux: mux_n generic map(n => 3) port map(LoadHazard,mux_in,"000",mux_out);
	 stallmux2: mux_n generic map(n => 2) port map (LoadHazard, Branch_t, "00", Branch);
	 
	 PCPFourOut <= PCPFourOut_t;
    Imm16 <= Imm16_t;
    RsOut <= Rs;
    Rtout <= Rt;
    Rdout  <= Rd;
    ALUSrc <= ALUSrc_t;
    ALUCtr <= ALUCtr_t;
    RegDst <= RegDst_t;
    MemWr  <= mux_out(2);
    --Branch <= Branch_t;
    MemtoReg <= mux_out(1);
    RegWr <= mux_out(0);
    BusAOut <= BusAOut_t;
    BusBOut <= BusBOut_t;
    
end architecture structural;