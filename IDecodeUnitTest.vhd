library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity IDecodeUnitTest is
end IDecodeUnitTest;

architecture behavioral of IDecodeUnitTest is
    signal clk: std_logic := '0';
    signal arst: std_logic;
    signal Instruction: std_logic_vector(31 downto 0);
    signal PCD, PCPFour: std_logic_vector(31 downto 0);
    signal BranchPC: std_logic_vector(31 downto 0);
    signal PCPFourOut: std_logic_vector(31 downto 0);
    signal Imm16:  std_logic_vector(15 downto 0);
    signal Rsout: std_logic_vector(4 downto 0);
    signal Rtout:  std_logic_vector(4 downto 0);
    signal Rdout:  std_logic_vector(4 downto 0);
    signal ALUSrc:  std_logic;
    signal ALUCtr:  std_logic_vector(3 downto 0);
    signal RegDst:  std_logic;
    signal MemWr:  std_logic;
    signal Branch:  std_logic_vector(1 downto 0);
    signal MemtoReg:  std_logic;
    signal RegWr:  std_logic;
    signal BusA:  std_logic_vector(31 downto 0);
    signal BusB:  std_logic_vector(31 downto 0);
    signal Reg7to0: std_logic_vector(255 downto 0);
    signal TempRegOut: std_logic_vector(31 downto 0);
    signal IFFlush: std_logic;
    component IFetchUnit is
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
	 end component IFetchUnit;
	 
	 component IDecodeUnit is
		 port(
			 clk: in std_logic;
			 arst: in std_logic;
			 IFIDWrite: in std_logic;
			 Instruction: in std_logic_vector(31 downto 0);
			 PCPFour: in std_logic_vector(31 downto 0);
			 InputRegWr: in std_logic;
			 InputRw: in std_logic_vector(4 downto 0);
			 InputBusW: in std_logic_vector(31 downto 0);
			 LoadHazard: in std_logic;
			 IFFlush: in std_logic;
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
			 Reg7to0: out std_logic_vector(255 downto 0)
		 );
	 end component IDecodeUnit;
	 
    begin
    testcomp: IFetchUnit
    port map(
    clk => clk,
    arst => arst,
    PCWrite => '1',
    BranchSel => '0',
    --PCD,
    BranchPC => x"00000000",
    PCD => PCD,
    PCPFour => PCPFour,
    Instruction => Instruction,
    InFile => "/home/jly965/EECS361/eecs361/data/bills_branch.dat");
    decodecomp: IDecodeUnit
    port map(
	    clk => clk,
	    arst => arst,
	    IFIDWrite => '1',
	    Instruction => Instruction,
	    PCPFour => PCPFour,
	    InputRegWr => '1',
	    InputRw => "00001",
	    InputBusW => x"00000001",
	    LoadHazard => '0',
	    IFFlush => IFFlush,
	    ------------------------------------------------
	    PCPFourOut => PCPFourOut,
	    Imm16 => Imm16,
	    Rsout => Rsout,
	    Rtout => Rtout,
	    Rdout => Rdout,
	    ALUSrc => ALUSrc,
	    ALUCtr => ALUCtr,
	    RegDst => RegDst,
	    MemWr => MemWr,
	    Branch => Branch,
	    MemtoReg => MemtoReg,
	    RegWr => RegWr,
	    BusAOut => BusA,
	    BusBOut => BusB,
	    Reg7to0 => Reg7to0
    );
    tempreg: reg_n_ar
    generic map(n => 32)
    port map(
        Reg7to0(63 downto 32),
        --PCPFourOut,
        '1',
        arst,
        '0',
        x"00000000",
        clk,
        TempRegOut
    );
        
    testbench: process
    begin
       arst <= '1';
       
       wait for 3 ns;
       arst <= '0';
       wait for 17 ns;
       IFFlush <= '1';
       wait for 5 ns;
       IFFlush <= '0';
       wait;
    end process;
    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
end architecture;
