-- EECS 361 Pipelined Processor
-- by Alvin Tan (12/08/2018)
-- This aides the forwarding unit of the pipeline

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity Funit_ander is
    port (
        Wr   :  in std_logic;
        R    :  in std_logic_vector(4 downto 0);
        Rw   :  in std_logic_vector(4 downto 0);
        WrOut: out std_logic
    );
end Funit_ander;

architecture structural of Funit_ander is
    signal xnO : std_logic_vector(4 downto 0);
    
    begin
        -- This should output "11111" iff the two registers match.
        xnor_comp : xnor_gate_n
           generic map (n => 5)
           port map (R, Rw, xnO);
        
        and_comp  : and_6
           port map (xnO(4), xnO(3), xnO(2), xnO(1), xnO(0), Wr, WrOut);
end architecture structural;

















