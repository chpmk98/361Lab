-- EECS 361 Pipelined Processor
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
           -- Rs and Rt are unnecessary for subsequent stages.
           -- The values for busA and busB will be calculated in Funit,
           --  which should take in Rs and Rt.
           -- However, Rd is still necessary for WB and forwarding.
        --Rs        :  in std_logic_vector(4 downto 0);
        --Rt        :  in std_logic_vector(4 downto 0);
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
        -- Debugging material
        Reg7to0in :  in std_logic_vector(255 downto 0);
        ----------------------------------------------
        -- Debugging material
        Reg7to0out: out std_logic_vector(255 downto 0)
        -- more ports here eventually
    );
end entity EXunit

architecture structural of EXunit is
    signal IDin   : std_logic_vector(132 downto 0);
    signal kill   : std_logic;
    
    
    
    rstLogic : or_gate
       port map (arst, EXkill, kill);
    
    IDEXreg: reg_n_ar
       generic map (n => 133)
       port map (IDin, IDEXwrite, kill);


