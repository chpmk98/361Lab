-- EECS 361 Single-Cycle Processor

-- This is the complete single-cycle processor

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.InstructionFetchUnitPackage.all;

entity sc_proc is
    port (
        clk         :  in std_logic;
        instMemFile :  string;
        dataMemFile :  string;
        pcReset     :  in std_logic;
        reg7to0     : out std_logic_vector(255 downto 0);
        instruction : out std_logic_vector(31 downto 0);
        MemWrAdd    : out std_logic_vector(31 downto 0);
        dOut        : out std_logic_vector(31 downto 0);
        Rw          : out std_logic_vector(4 downto 0);
        regWr       : out std_logic;
        memWr       : out std_logic
    );
end sc_proc;

architecture structural of sc_proc is
    signal Inst        : std_logic_vector(31 downto 0);
    signal MCALUop     : std_logic_vector(1 downto 0);
    signal MCALUsrc    : std_logic;
    signal MCRegWr     : std_logic;
    signal MCRegDst    : std_logic;
    signal MCExtOp     : std_logic;
    signal MCMemWr     : std_logic;
    signal MCMemtoReg  : std_logic;
    signal MCbranch    : std_logic_vector(1 downto 0);
    signal ACALUctr    : std_logic_vector(3 downto 0);
    signal fbZero      : std_logic;
    signal fbCarry     : std_logic;
    signal fbOverflow  : std_logic;
    signal fbSign      : std_logic;
    
    begin
        IFU : InstructionFetchUnit
           port map (clk, pcReset, MCbranch, fbZero, fbSign, Inst, instMemFile);
               
        MC  : MainControl
           port map (Inst(31 downto 26), MCALUop, MCALUsrc, MCRegWr, MCRegDst, MCExtOp, MCMemWr, MCMemtoReg, MCbranch);
        
        AC  : ALU_Control
           port map (Inst(5 downto 0), MCALUop, ACALUctr);
               
        FB  : fatBoi
           port map ( clk, ACALUctr, Inst(25 downto 21), Inst(20 downto 16), Inst(15 downto 11), Inst(10 downto 6),
                      Inst(15 downto 0), MCRegDst, MCRegWr, MCALUsrc, MCMemWr, MCMemtoReg, reg7to0, MemWrAdd, dOut, Rw, fbZero, fbCarry,
                      fbOverflow, fbSign, dataMemFile);
                      
        instruction <= Inst;
        regWr <= MCRegWr;
        memWr <= MCMemWr;
end structural;






