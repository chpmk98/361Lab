library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity fatPipeline is
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
end entity fatPipeline;

architecture structural of fatPipeline is
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
	 end component IDecodeUnit;
	 
	 component EXunit is
	     port (
	         -- For controlling the ID/EX register
	         clk       :  in std_logic;
	         arst      :  in std_logic;
	         IDEXwrite :  in std_logic;
	         EXkill    :  in std_logic; -- To be same as BranchSel from Mem stage
	         -- To be stored in the ID/EX register
	            -- Normal fatBoi stuff
	         ALUctr    :  in std_logic_vector(3 downto 0);
	            -- Rs and Rt are unnecessary for subsequent stages.
	            -- The values for busA and busB will be calculated in Funit,
	            --  which should take in Rs and Rt.
	            -- However, Rd is still necessary for WB and forwarding.
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
	         ----------------------------------------------
	         -- Information for Forwarding
	          -- Note that Rw and ALUout are necessary for forwarding as well
	         WrEX      : out std_logic;
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
	         Reg7to0out: out std_logic_vector(255 downto 0)
	     );
	 end component EXunit;
	 
	 component MemUnit is
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
	         BranchSel : out std_logic;
	         Dout : out std_logic_vector (31 downto 0);
	         MemtoRegO: out std_logic;
	         ALUout : out std_logic_vector (31 downto 0);
	         RegWR_out : out std_logic;
	         WrEXO   : out std_logic;
	         RwO   : out std_logic_vector(4 downto 0)
	         );
	 end component MemUnit;
	 
	 component WBUnit is
	     port(
	         --------Inputs--------
	         clk : in std_logic;
	         Din : in std_logic_vector (31 downto 0);
	         ALUin : in std_logic_vector (31 downto 0);
	         RwIn : in std_logic_vector(4 downto 0);
	         RegWR : in std_logic;
	         MemtoReg : in std_logic;
	         
	         
	         --------Outputs--------
	         RegWR_out : out std_logic;
	         Dout : out std_logic_vector (31 downto 0);
	         Rw : out std_logic_vector( 4 downto 0)
	         );
	 end component WBUnit;
	 
	 component HazardUnit is
	     port(
	         IDEX_MemRead: in std_logic;
	         IDEX_Rt: in std_logic_vector(4 downto 0);
	         IFID_Rs: in std_logic_vector(4 downto 0);
	         IFID_Rt: in std_logic_vector(4 downto 0);
	         PCWrite: out std_logic;
	         IFIDWrite: out std_logic;
	         LoadHazard: out std_logic
	     );
	 end component HazardUnit;
	 
	 component Funit is
	     port (
	         -- From the ID/EX register
	         -- Note to future Alvin: Store the following from IDunit in a register
	         --  outside of EXunit, then feed the values from that register into
	         --  this Funit, and feed the output values from here into EXunit.
	         Rs     :  in std_logic_vector(4 downto 0);  -- Source of BusA
	         Rt     :  in std_logic_vector(4 downto 0);  -- Source of BusB
	         BusAin :  in std_logic_vector(31 downto 0);
	         BusBin :  in std_logic_vector(31 downto 0);
	         -- From the EX/Mem register
	         WrEX   :  in std_logic;                     -- Set if BusWEX will be written into RwEX
	         RwEX   :  in std_logic_vector(4 downto 0);
	         BusWEX :  in std_logic_vector(31 downto 0);
	         -- From the Mem/WR register
	         WrMem  :  in std_logic;                     -- Set if BusWMem will be written into RwMem
	         RwMem  :  in std_logic_vector(4 downto 0);
	         BusWMem:  in std_logic_vector(31 downto 0);
	         -------------------------------------------
	         BusA   : out std_logic_vector(31 downto 0);
	         BusB   : out std_logic_vector(31 downto 0)
	     );
	 end component Funit;
	 --intermediate signals for IF Stage
	 signal PCWrite: std_logic;
	 signal BranchSel: std_logic;
	 signal BranchPC,IFIDPCPFour, Instruction: std_logic_vector(31 downto 0);
	 --intermediate signals for ID Stage
	 signal IFIDWrite,LoadHazard: std_logic;
    signal IDEXPCPFour: std_logic_vector(31 downto 0);
    signal ALUSrc: std_logic;
    signal IDEXRs, IDEXRt, IDEXRd: std_logic_vector(4 downto 0);
    signal IDEXImm16: std_logic_vector(15 downto 0);
    signal IDEXALUCtr: std_logic_vector(3 downto 0);
    signal IDEXBranch: std_logic_vector(1 downto 0);
    signal IDEXalusrc, IDEXRegDst, IDEXRegWr, IDEXMemWr: std_logic;
    signal IDEXMemtoReg: std_logic;
    signal IDEXBusA, IDEXBusB: std_logic_vector(31 downto 0);
    signal Reg7to0: std_logic_vector(255 downto 0);
    --intermediate signals for EX Stage
    signal EXrst: std_logic;
    signal EXMEMWrEx: std_logic;
  	 signal EXMEMALUOut,EXMemBranchPC,EXMEMBusA,EXMEMBusB:std_logic_vector(31 downto 0);
	 signal EXMEMMemWr,EXMEMRegWr,EXMEMMemtoReg, EXMEMZero,EXMEMCarry,EXMEMOverflow:std_logic;
	 signal EXMEMRw: std_logic_vector(4 downto 0);
	 signal EXMEMBranch: std_logic_vector(1 downto 0);
	 --Intermediate signals for MEM Stage
	 signal MEMWBDout, MEMWBALUOut: std_logic_vector(31 downto 0);
    signal MEMWBRegWr, MEMWBWrEx, MemWBMemtoReg: std_logic;
    signal MEMWBRw: std_logic_vector(4 downto 0);
    --Intermediate Signals for MemWB
    signal WBIDRw: std_logic_vector(4 downto 0);
    signal WBIDRegWr: std_logic;
    signal WBIDBusW: std_logic_vector(31 downto 0);
    --Intermediate Signal for Hazard Unit
    signal IDEXMemRead: std_logic;
    -- Intermediate Signal for Forwarding Unit
    signal BusAFor, BusBFor: std_logic_vector(31 downto 0);
    begin
    makeIFetch: IFetchUnit port map(
								           clk => clk,
								           arst => arst,
								           PCWrite => PCWrite,
								           BranchSel => BranchSel,
								           BranchPC => BranchPC,
								           PCD => PCD,
								           PCPFour => IFIDPCPFour,
								           Instruction => Instruction,
								           InFile => InFile
								       );
								       
	 Inst <= Instruction;
	 BrSelD <= BranchSel;
	 
	 makeIDecode: IDecodeUnit port map(
	 clk => clk,
    arst => arst,
    IFIDWrite => IFIDWrite,
    Instruction => Instruction,
    PCPFour => IFIDPCPFour,
    InputRegWr => WBIDRegWr,
    InputRw => WBIDRw,
    InputBusW => WBIDBusW,
    LoadHazard => LoadHazard,
    IFFlush => BranchSel,
    ------------------------------------------------
    PCPFourOut => IDEXPCPFour,
    Imm16 => IDEXImm16,
    Rsout => IDEXRs,
    Rtout => IDEXRt,
    Rdout => IDEXRd,
    ALUSrc => IDEXAluSrc,
    ALUCtr => IDEXALUCtr,
    RegDst => IDEXRegDst,
    MemWr => IDEXMemWr,
    Branch => IDEXBranch,
    MemtoReg => IDEXMemtoReg,
    RegWr => IDEXRegWr,
    BusAOut => IDEXBusA,
    BusBOut => IDEXBusB,
    Reg7to0 => Reg7to0
	 );
	 
	 RsD <= IDEXRs;
	 RtD <= IDEXRt;
	 RdD <= IDEXRd;
	 exreset: or_gate port map(arst,BranchSel,EXrst);
	 
	 makeExUnit: ExUnit port map(
    clk => clk,
    arst => EXrst,
    IDEXwrite => '1',
    EXkill => BranchSel,
    ALUctr => IDEXALUCtr,
       -- Rs and Rt are unnecessary for subsequent stages.
       -- The values for busA and busB will be calculated in Funit,
       --  which should take in Rs and Rt.
       -- However, Rd is still necessary for WB and forwarding.
    Rs => IDEXRs,
    Rt => IDEXRt,
    Rd => IDEXRd,
    Shamt => IDEXImm16(10 downto 6),
    Imm16 => IDEXImm16,
    RegDst => IDEXRegDst,
    RegWr => IDEXRegWr,
    ALUsrc => IDEXALUsrc,
    MemWr => IDEXMemWr,
    MemtoReg => IDEXMemtoReg,
       -- Weird IDunit stuff
    PCPFourOut => IDEXPCPFour,
    Branch => IDEXBranch,
    BusA => IDEXBusA,
    BusB => IDEXBusB,
    BusAFor => BusAFor,
    BusBFor => BusBFor,
    -- Debugging material
    Reg7to0in => Reg7to0,
    ----------------------------------------------
    -- Information for Forwarding
    -- Note that Rw and ALUout are necessary for forwarding as well
    WrEX => EXMEMWrEx,
    -- Information for Data Memory access
    MemWrout  => EXMEMMemWr,
    ALUout => EXMEMALUOut,
    BusAOut => EXMEMBusA,
    BusBout => EXMEMBusB,
    -- Information for Writeback
    MemtoRegO => EXMEMMemtoReg,
    RegWrO => EXMEMRegWr,
    Rw => EXMEMRw,
    -- Information for Branch detection
    BrchTarget => EXMEMBranchPC,
    BranchO => EXMEMBranch,
	 Zero => EXMEMZero,
    -- Debugging material
    Carry => EXMEMCarry,
    Overflow => EXMEMOverflow,
    Reg7to0out => open
	 );
	 
	 BusAOG <= EXMEMBusA;
	 BusBOG <= EXMEMBusB;
	 EXRegWr <= EXMEMRegWr;
	 EXRw <= EXMEMRw;
	 EXALUout <= EXMEMALUout;
	 
	 makeMemUnit: MemUnit port map(
	 BranchPC => EXMEMBranchPC,
    BusB => BusBFor, --EXMEMBusB,
    ALUin => EXMEMALUOut,
    Rw => EXMEMRw,        -- NOTE: FIX ALL THE NUMBERINGS
    WrEX => EXMEMWrEx,
    MemWR => EXMEMMemWr,
    RegWR => EXMEMRegWr,
    MemtoReg => EXMEMMemtoReg,
    Branch => EXMEMBranch,
    Zero => EXMemZero,
    Sign => EXMEMALUout(31),
    
    --------Other Inputs--------
    arst => arst,
    clk => clk,
    MemFile => InFile,
    
    --------Outputs--------
    BranchSel => BranchSel,
    Dout => MEMWBDout,
    MemtoRegO => MemWBMemtoReg,
    ALUout => MEMWBALUout,
    RegWR_out => MEMWBRegWr,
    WrEXO => MEMWBWrEX,
    RwO => MEMWBRw
    );
    
    MemRegWr <= MEMWBRegWr;
    MemRw <= MEMWBRw;
    MemALUout <= MEMWBALUout;
    MemDout <= MEMWBDout;
    
	 makeWbUnit: WBUnit port map(
	         --------Inputs--------
	         clk => clk,
	         Din => MemWbDout,
	         ALUin => MemWBALUOut,
	         RwIn => MEMWBRw,
	         RegWR => MEMWBRegWr,
	         MemtoReg => MEMWBMemtoReg,
	         
	         
	         --------Outputs--------
	         RegWR_out => WBIDRegWr,
	         Dout => WBIDBusW,
	         Rw => WBIDRw
	 );
	 WBRegWr <= WBIDRegWr;
	 WBBusW <= WBIDBusW;
	 WBRw <= WBIDRw;
	 
	 makeIDEXMemread: and_gate port map(IDEXMemtoReg,IDEXRegWr,IDEXMemRead);
	 
	 makeHazardUnit: HazardUnit port map(
	    IDEX_MemRead => IDEXMemRead,
       IDEX_Rt => IDEXRt,
       IFID_Rs => Instruction(25 downto 21),
       IFID_Rt => Instruction(20 downto 16),
       PCWrite => PCWrite,
       IFIDWrite => IFIDWrite,
       LoadHazard => LoadHazard
	 );
	 
	 makeForwardUnit: Funit port map(
	         -- From the ID/EX register
	         -- Note to future Alvin: Store the following from IDunit in a register
	         --  outside of EXunit, then feed the values from that register into
	         --  this Funit, and feed the output values from here into EXunit.
	         Rs => IDEXRs,
	         Rt => IDEXRt,
	         BusAin => EXMEMBusA,                -- These are the BusA and BusB values generated
	         BusBin => EXMEMBusB,                --  by the ID stage
	         -- From the EX/Mem register
	         WrEX => MEMWBWrEX,                  -- Set if BusWEX will be written into RwEX
	         RwEX => MEMWBRw,
	         BusWEX => MEMWBALUOut,
	         -- From the Mem/WR register
	         WrMem => WBIDRegWr,                    -- Set if BusWMem will be written into RwMem
	         RwMem => WBIDRw,
	         BusWMem => WBIDBusW,
	         -------------------------------------------
	         BusA => BusAFor,
	         BusB => BusBFor
	     );
	 BusAD <= BusAFor;
	 BusBD <= BusBFor;
	     
	 --expose for debug
	 Reg7to0Out <= Reg7to0;
	 
        
end architecture structural;