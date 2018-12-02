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
		valid: in std_logic;
		Instruction: in std_logic_vector(31 downto 0);
		PCPFour: in std_logic_vector(31 downto 0);
		InputRegWr: in std_logic;
		InputRw: in std_logic_vector(4 downto 0);
		InputBusW: in std_logic_vector(31 downto 0);
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
		BusA: out std_logic_vector(31 downto 0);
		BusB: out std_logic_vector(31 downto 0);
		Reg7to0: out std_logic_vector(255 downto 0)
	);
end entity IDecodeUnit;

architecture structural of IDecodeUnit is
signal ALUop: std_logic_vector(1 downto 0);
signal IFID_Inst: std_logic_vector(31 downto 0);
signal Rs, Rt, Rd: std_logic_vector(4 downto 0);
signal invclk: std_logic;
begin
    NOTCLOCK: not_gate port map(clk, invclk);
	IFIDReg1: reg_n_ar generic map(n => 32) port map(inWrite => Instruction,
													RegWr => valid,
													Rst => '0',
													arst => arst,
													aload => x"00000000",
													clk => clk,
													Q => IFID_Inst);
	IFIDReg2: reg_n_ar generic map(n => 32) port map(inWrite => PCPFour,
													RegWr => valid,
													Rst => '0',
													arst => arst,
													aload => x"00000000",
													clk => clk,
													Q => PCPFourOut);
	Rs <= IFID_Inst(25 downto 21);
	Rt <= IFID_Inst(20 downto 16);
	Rd <= IFID_Inst(15 downto 11);
	Imm16 <= IFID_Inst(15 downto 0);
	Rtout <= Rt;
	Rdout <= Rd;
	MainFlags: MainControl port map(op => IFID_Inst(31 downto 26),
            						ALUop => ALUop,
            						ALUSrc => ALUSrc,
            						RegWr => RegWr,
            						RegDst => RegDst,
            						ExtOp => open,
            						MemWr => MemWr,
            						MemtoReg => MemtoReg,
            						Branch => Branch);

    ALUFlags: ALU_Control port map(func => IFID_Inst(5 downto 0),
    							  ALUop => ALuop,
    							  ALUCtr => ALUCtr);

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
end architecture structural;