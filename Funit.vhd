-- EECS 361 Pipelined Processor
-- by Alvin Tan (12/08/2018)
-- This is the forwarding unit of the pipeline

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity Funit is
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
end Funit;

architecture structural of Funit is
    signal BusAmid, BusBmid : std_logic_vector(31 downto 0);
    signal WrMemA, WrEXA, WrMemB, WrEXB : std_logic;
    
    begin
        and1   : Funit_ander
           port map (WrMem, Rs, RwMem, WrMemA);
        and2   : Funit_ander
           port map (WrEX, Rs, RwEX, WrEXA);
        and3   : Funit_ander
           port map (WrMem, Rt, RwMem, WrMemB);
        and4   : Funit_ander
           port map (WrEX, Rt, RwMem, WrEXB);
        
        mux1   : mux_32
           port map (WrMemA, BusAin, BusWMem, BusAmid);
        mux2   : mux_32
           port map (WrEXA, BusAmid, BusWEX, BusA);
        mux3   : mux_32
           port map (WrMemB, BusBin, BusWMem, BusBmid);
        mux4   : mux_32
           port map (WrEXB, BusBmid, BusWEX, BusB);

end architecture structural;

















