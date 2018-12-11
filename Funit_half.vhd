-- EECS 361 Pipelined Processor
-- by Alvin Tan (12/08/2018)
-- This is the forwarding unit of the pipeline

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity Funit_half is
    port (
        -- From the ID/EX register
        -- Note to future Alvin: Store the following from IDunit in a register
        --  outside of EXunit, then feed the values from that register into
        --  this Funit, and feed the output values from here into EXunit.
        Rs     :  in std_logic_vector(4 downto 0);  -- Source of BusA
        BusAin :  in std_logic_vector(31 downto 0);
        -- From the EX/Mem register
        WrEX   :  in std_logic;                     -- Set if BusWEX will be written into RwEX
        RwEX   :  in std_logic_vector(4 downto 0);
        BusWEX :  in std_logic_vector(31 downto 0);
        -- From the Mem/WR register
        WrMem  :  in std_logic;                     -- Set if BusWMem will be written into RwMem
        RwMem  :  in std_logic_vector(4 downto 0);
        BusWMem:  in std_logic_vector(31 downto 0);
        -------------------------------------------
        WrEXAO : out std_logic;
        WrMemAO: out std_logic;
        BusAmidO: out std_logic_vector(31 downto 0);
        BusAfinO: out std_logic_vector(31 downto 0);
        BusA   : out std_logic_vector(31 downto 0)
    );
end Funit_half;

architecture structural of Funit_half is

    component Funit_addIsZero is
        port (
            R      :  in std_logic_vector(4 downto 0);
            isZero : out std_logic
        );
    end component Funit_addIsZero;

    signal BusAmid, BusAfin : std_logic_vector(31 downto 0);
    signal WrMemA, WrEXA, RsIsZero : std_logic;
    
    begin
        and1   : Funit_ander
           port map (WrMem, Rs, RwMem, WrMemA);
        and2   : Funit_ander
           port map (WrEX, Rs, RwEX, WrEXA);
        
        mux1   : mux_32
           port map (WrMemA, BusAin, BusWMem, BusAmid);
        mux2   : mux_32
           port map (WrEXA, BusAmid, BusWEX, BusAfin);
                          
        -- checks if either Rs or Rt are zero, and changes outputs as necessary
        RsChecker : Funit_addIsZero
           port map (Rs, RsIsZero);
        
        mux0A  : mux_32
           port map (RsIsZero, BusAfin, x"00000000", BusA);
        
        WrEXAO <= WrEXA;
        WrMemAO <= WrMemA;
        BusAmidO <= BusAmid;
        BusAfinO <= BusAfin;


end architecture structural;






