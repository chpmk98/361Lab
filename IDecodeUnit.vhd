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
signal mux_in, mux_out: std_logic_vector(132 downto 0);
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
	IFIDReg1: reg_n_ar generic map(n => 32) port map(inWrite => Instruction,
													RegWr => IFIDWrite,
													Rst => flush_reg,
													arst => '0',
													aload => IFID_Inst,
													clk => clk,
													Q => IFID_Inst);
	IFIDReg2: reg_n_ar generic map(n => 32) port map(inWrite => PCPFour,
													RegWr => IFIDWrite,
													Rst => flush_reg,
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
	 makeFWRegA0: regCompare port map(Rs,InputRw, compA);
	 makeFWRegA1: and_gate port map(compA, InputRegWr,FWRegA);
	 
	 makeFWRegB0: regCompare port map(Rt, InputRw, compB);
	 makeFWRegB1: and_gate port map(compB, InputRegWr, FWRegB);
	 
	 busASelect: mux_32 port map(FWRegA, BusA, InputBusW,BusAOut_t);
	 busBSelect: mux_32 port map(FWRegB, BusB, InputBusW,BusBOut_t);
	 
	 --Mux for stalling zeros out everything if stall flag occurs
	 mux_in <= PCPFourOut_t &
              Imm16_t &
              Rt &
              Rd &
              ALUSrc_t &
              ALUCtr_t &  
              RegDst_t &
              MemWr_t & 
              Branch_t &
              MemtoReg_t &
              RegWr_t &
              BusAOut_t &
              BusBOut_t;
    --if LoadHazard flag is raised if stall is needed
	 stallmux: mux_n generic map(n => 133) port map(LoadHazard,mux_in,
	 "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
	 mux_out); --lol there's probably an easier way to represent 0 in 133 bits
	 
	 PCPFourOut <= mux_out(132 downto 101);
    Imm16 <= mux_out(100 downto 85);
    Rtout <= mux_out(84 downto 80);
    Rdout  <= mux_out(79 downto 75);
    ALUSrc <= mux_out(74);
    ALUCtr <= mux_out(73 downto 70);
    RegDst <= mux_out(69);
    MemWr  <= mux_out(68);
    Branch <= mux_out(67 downto 66);
    MemtoReg <= mux_out(65);
    RegWr <= mux_out(64);
    BusAOut <= mux_out(63 downto 32);
    BusBOut <= mux_out(31 downto 0);
end architecture structural;