library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.InstructionFetchUnitPackage.all;

entity fatPipeline_test is
end fatPipeline_test;

architecture behavioral of fatPipeline_test is
   component fatPipeline is
<<<<<<< HEAD
    port(
    clk: in std_logic;
    arst: in std_logic;
    --Most of this is for debug
    Reg7to0Out: out std_logic_vector(255 downto 0);
    BranchPCD: out std_logic_vector(31 downto 0);
    PCD: out std_logic_vector(31 downto 0);
    IFPCPFour: out std_logic_vector(31 downto 0);
    Inst: out std_logic_vector(31 downto 0);
    BrSelD : out std_logic;
    IDPCPFour: out std_logic_vector(31 downto 0);
    IDImm16 : out std_logic_vector(15 downto 0);
	 IDRs : out std_logic_vector(4 downto 0);
	 IDRt : out std_logic_vector(4 downto 0);
	 IDRd : out std_logic_vector(4 downto 0);
	 IDAluSrc : out std_logic;
	 IDRegDst: out std_logic;
	 IDMemWr : out std_logic;
	 IDBranch : out std_logic_vector(1 downto 0);
	 IDMemtoReg : out std_logic;
	 IDRegWr: out std_logic;
	 IDBusAOut: out std_logic_vector(31 downto 0);
	 IDBusBOut: out std_logic_vector(31 downto 0);
    BusAOG : out std_logic_vector(31 downto 0);
    BusBOG : out std_logic_vector(31 downto 0);
    BusAD : out std_logic_vector(31 downto 0);
    BusBD : out std_logic_vector(31 downto 0);
    EXRegWr : out std_logic;
    EXRw : out std_logic_vector(4 downto 0);
    EXALUout : out std_logic_vector(31 downto 0);
    EXBrchTarget: out std_logic_vector(31 downto 0);
    EXBranch0 : out std_logic_vector(1 downto 0);
    MemRegWr : out std_logic;
    MemRw : out std_logic_vector(4 downto 0);
    MemALUout : out std_logic_vector(31 downto 0);
    MemDout : out std_logic_vector(31 downto 0);
  	 WBRegWr: out std_logic;
	 WBBusW: out std_logic_vector(31 downto 0);
	 WBRw: out std_logic_vector(4 downto 0);
    InFile: string
    );
=======
       port(
       clk: in std_logic;
       arst: in std_logic;
       Reg7to0Out: out std_logic_vector(255 downto 0);
       IDImm16: out std_logic_vector(15 downto 0);
       PCD: out std_logic_vector(31 downto 0);
       Inst: out std_logic_vector(31 downto 0);
       BrSelD : out std_logic;
       RsD: out std_logic_vector(4 downto 0);
       RtD: out std_logic_vector(4 downto 0);
       RdD: out std_logic_vector(4 downto 0);
       BusAOG : out std_logic_vector(31 downto 0);
       BusBOG : out std_logic_vector(31 downto 0);
       BusAD : out std_logic_vector(31 downto 0);
       BusBD : out std_logic_vector(31 downto 0);
       EXRegWr : out std_logic;
       EXRw : out std_logic_vector(4 downto 0);
       EXALUout : out std_logic_vector(31 downto 0);
       MemRegWr : out std_logic;
       MemRw : out std_logic_vector(4 downto 0);
       MemALUout : out std_logic_vector(31 downto 0);
       MemDout : out std_logic_vector(31 downto 0);
         WBRegWr: out std_logic;
       WBBusW: out std_logic_vector(31 downto 0);
       WBRw: out std_logic_vector(4 downto 0);
       InFile: string
       );
>>>>>>> 9b1679126fdfeadfb66b41a0b2eb3688e69a2cc0
   end component fatPipeline;
   
   signal clk, arst : std_logic;
   signal Reg7to0   : std_logic_vector(255 downto 0);
<<<<<<< HEAD
   signal BranchPCD : std_logic_vector(31 downto 0);
   signal IFPCPFour : std_logic_vector(31 downto 0);
   signal PCD, Inst : std_logic_vector(31 downto 0);
   
   signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : std_logic_vector(31 downto 0);
   signal IDPCPFour: std_logic_vector(31 downto 0);
   signal IDImm16 : std_logic_vector(15 downto 0);
	signal IDRs : std_logic_vector(4 downto 0);
	signal IDRt : std_logic_vector(4 downto 0);
	signal IDRd : std_logic_vector(4 downto 0);
	signal IDAluSrc : std_logic;
	signal IDRegDst: std_logic;
	signal IDMemWr : std_logic;
	signal IDBranch : std_logic_vector(1 downto 0);
	signal IDMemtoReg : std_logic;
	signal IDRegWr: std_logic;
	signal IDBusAOut: std_logic_vector(31 downto 0);
	signal IDBusBOut: std_logic_vector(31 downto 0);
   
   signal EXRegWr :std_logic;
   signal EXBrchTarget: std_logic_vector(31 downto 0);
   signal EXALUout: std_logic_vector(31 downto 0);
   signal EXBranch : std_logic_vector(1 downto 0);
   signal EXRw: std_logic_vector(4 downto 0);
   
   signal MemRegWr: std_logic;
   signal MemRw: std_logic_vector(4 downto 0);
   signal MemALUout, MemDout : std_logic_vector(31 downto 0);
   signal BrSelD : std_logic;
   
   signal WBBusW : std_logic_vector(31 downto 0);
   signal WBRegWr: std_logic;
   signal WBRw: std_logic_vector(4 downto 0);
   
   
   signal BusAOG, BusBOG, BusAD, BusBD: std_logic_vector(31 downto 0);
   
   begin
       testComp : fatPipeline
          port map (
           clk => clk,
           arst => arst,
           Reg7to0Out => Reg7to0,
           BranchPCD => BranchPCD,
           PCD => PCD,
           IFPCPFour => IFPCPFour,
           Inst => Inst,
           BRSelD => BrSelD,
           IDPCPFour => IDPCPFour,
           IDImm16 => IDImm16,
	        IDRs => IDRs,
   	       IDRt => IDRt,
	        IDRd => IDRd,
	        IDAluSrc => IDAluSrc,
	        IDRegDst => IDRegDst,
	        IDMemWr => IDMemWr,
	        IDBranch => IDBranch,
	        IDMemtoReg => IDMemtoReg,
	        IDRegWr => IDRegWr,
	        IDBusAOut => IDBusAOut,
	        IDBusBOut => IDBusBOut,
           BusAOG => BusAOG,
           BusBOG => BusBOG,
           BusAD => BusAD,
           BusBD => BusBD,
           EXRegWr => EXRegWr,
           EXRw => EXRw, 
           EXALUout => EXALUout, 
           EXBrchTarget => ExBrchTarget,
           EXBranch0 => EXBranch,
           MemRegWr => MemRegWr, 
           MemRw => MemRw, 
           MemAluout => MemALUout, 
           MemDout => MemDout, 
           WBRegWr => WBRegWr, 
           WBBusW => WBBusW, 
           WBRw => WBRw, 
           InFile => "/home/atr7967/eecs361lib_cpu/eecs361/data/bills_branch.dat");
=======
   signal IDImm16   : std_logic_vector(15 downto 0);
   signal PCD, Inst : std_logic_vector(31 downto 0);
   
   signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : std_logic_vector(31 downto 0);
   signal rs, rt, rd : std_logic_vector(4 downto 0);
   signal EXRegWr, MemRegWr, WBRegWr : std_logic;
   signal WBBusW : std_logic_vector(31 downto 0);
   signal EXRw, MemRw, WBRw : std_logic_vector(4 downto 0);
   signal MemALUout, MemDout : std_logic_vector(31 downto 0);
   signal BrSelD : std_logic;
   signal BusAOG, BusBOG, BusAD, BusBD, EXALUout : std_logic_vector(31 downto 0);
   
   begin
       testComp : fatPipeline
          port map (clk, arst, Reg7to0, IDImm16, PCD, Inst, BrSelD, rs, rt, rd, BusAOG, BusBOG, BusAD, BusBD, EXRegWr, EXRw, EXALUout, MemRegWr, MemRw, MemALUout, MemDout, WBRegWr, WBBusW, WBRw, "/home/atr7967/eecs361lib_cpu/eecs361/data/bills_branch.dat");
>>>>>>> 9b1679126fdfeadfb66b41a0b2eb3688e69a2cc0

       reg0 <= reg7to0(31 downto 0);
       reg1 <= reg7to0(63 downto 32);
       reg2 <= reg7to0(95 downto 64);
       reg3 <= reg7to0(127 downto 96);
       reg4 <= reg7to0(159 downto 128);
       reg5 <= reg7to0(191 downto 160);
       reg6 <= reg7to0(223 downto 192);
       reg7 <= reg7to0(255 downto 224);
       
       testbench : process
       begin
           arst <= '1';
<<<<<<< HEAD
           wait for 1 ns;
=======
           wait for 4 ns;
>>>>>>> 9b1679126fdfeadfb66b41a0b2eb3688e69a2cc0
           arst <= '0';
           wait;
       end process;
       
       clk_process : process
       begin
           clk <= '0';
           wait for 5 ns;
           clk <= '1';
           wait for 5 ns;
       end process;
   
end architecture behavioral;