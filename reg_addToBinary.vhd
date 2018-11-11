-- EECS 361 Single-Cycle Processor
-- by Alvin Tan

-- This component takes in a 5-bit input addr and returns a 32-bit output binary that has a 1 in the
--  element that the 5-bit input corresponds to, and 0 elsewhere. This is used repeatedly in reg_comp.

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;

entity reg_addToBinary is
    port (
        addr   :  in std_logic_vector(4 downto 0);
        binary : out std_logic_vector(31 downto 0)
    );
end reg_addToBinary;

architecture structural of reg_addToBinary is
    signal notAddr : std_logic_vector(4 downto 0);
    begin
        not_map : not_gate_n
           generic map (n => 5)
           port map (addr, notAddr);
        
        and0    : reg_andStack
           port map (notAddr(4), notAddr(3), notAddr(2), notAddr(1), notAddr(0), binary(0));
        and1    : reg_andStack
           port map (notAddr(4), notAddr(3), notAddr(2), notAddr(1), addr(0), binary(1));
        and2    : reg_andStack
           port map (notAddr(4), notAddr(3), notAddr(2), addr(1), notAddr(0), binary(2));
        and3    : reg_andStack
           port map (notAddr(4), notAddr(3), notAddr(2), addr(1), addr(0), binary(3));
        and4    : reg_andStack
           port map (notAddr(4), notAddr(3), addr(2), notAddr(1), notAddr(0), binary(4));
        and5    : reg_andStack
           port map (notAddr(4), notAddr(3), addr(2), notAddr(1), addr(0), binary(5));
        and6    : reg_andStack
           port map (notAddr(4), notAddr(3), addr(2), addr(1), notAddr(0), binary(6));
        and7    : reg_andStack
           port map (notAddr(4), notAddr(3), addr(2), addr(1), addr(0), binary(7));
        and8    : reg_andStack
           port map (notAddr(4), addr(3), notAddr(2), notAddr(1), notAddr(0), binary(8));
        and9    : reg_andStack
           port map (notAddr(4), addr(3), notAddr(2), notAddr(1), addr(0), binary(9));
        and10   : reg_andStack
           port map (notAddr(4), addr(3), notAddr(2), addr(1), notAddr(0), binary(10));
        and11   : reg_andStack
           port map (notAddr(4), addr(3), notAddr(2), addr(1), addr(0), binary(11));
        and12   : reg_andStack
           port map (notAddr(4), addr(3), addr(2), notAddr(1), notAddr(0), binary(12));
        and13   : reg_andStack
           port map (notAddr(4), addr(3), addr(2), notAddr(1), addr(0), binary(13));
        and14   : reg_andStack
           port map (notAddr(4), addr(3), addr(2), addr(1), notAddr(0), binary(14));
        and15   : reg_andStack
           port map (notAddr(4), addr(3), addr(2), addr(1), addr(0), binary(15));
        and16   : reg_andStack
           port map (addr(4), notAddr(3), notAddr(2), notAddr(1), notAddr(0), binary(16));
        and17   : reg_andStack
           port map (addr(4), notAddr(3), notAddr(2), notAddr(1), addr(0), binary(17));
        and18   : reg_andStack
           port map (addr(4), notAddr(3), notAddr(2), addr(1), notAddr(0), binary(18));
        and19   : reg_andStack
           port map (addr(4), notAddr(3), notAddr(2), addr(1), addr(0), binary(19));
        and20   : reg_andStack
           port map (addr(4), notAddr(3), addr(2), notAddr(1), notAddr(0), binary(20));
        and21   : reg_andStack
           port map (addr(4), notAddr(3), addr(2), notAddr(1), addr(0), binary(21));
        and22   : reg_andStack
           port map (addr(4), notAddr(3), addr(2), addr(1), notAddr(0), binary(22));
        and23   : reg_andStack
           port map (addr(4), notAddr(3), addr(2), addr(1), addr(0), binary(23));
        and24   : reg_andStack
           port map (addr(4), addr(3), notAddr(2), notAddr(1), notAddr(0), binary(24));
        and25   : reg_andStack
           port map (addr(4), addr(3), notAddr(2), notAddr(1), addr(0), binary(25));
        and26   : reg_andStack
           port map (addr(4), addr(3), notAddr(2), addr(1), notAddr(0), binary(26));
        and27   : reg_andStack
           port map (addr(4), addr(3), notAddr(2), addr(1), addr(0), binary(27));
        and28   : reg_andStack
           port map (addr(4), addr(3), addr(2), notAddr(1), notAddr(0), binary(28));
        and29   : reg_andStack
           port map (addr(4), addr(3), addr(2), notAddr(1), addr(0), binary(29));
        and30   : reg_andStack
           port map (addr(4), addr(3), addr(2), addr(1), notAddr(0), binary(30));
        and31   : reg_andStack
           port map (addr(4), addr(3), addr(2), addr(1), addr(0), binary(31));
end structural;








