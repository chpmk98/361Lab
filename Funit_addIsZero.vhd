-- EECS 361 Pipelined Processor
-- by Alvin Tan (12/11/2018)
-- This aides the forwarding unit of the pipeline

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity Funit_addIsZero is
    port (
        R      :  in std_logic_vector(4 downto 0);
        isZero : out std_logic
    );
end Funit_addIsZero;

architecture structural of Funit_addIsZero is
    signal notR : std_logic_vector(4 downto 0);
    
    begin
        notComp : not_gate_n
           generic map (n => 5)
           port map (R, notR);
        
        andComp : and_6
           port map (notR(0), notR(1), notR(2), notR(3), notR(4), '1', isZero);
end architecture structural;



















