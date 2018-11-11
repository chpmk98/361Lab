library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;

entity reg_mux_test is
end reg_mux_test;

architecture behavioral of reg_mux_test is
    signal selA, selB : std_logic_vector(1 downto 0);
    signal src0, src1, rsltA, rsltB : std_logic_vector(3 downto 0);
    
    begin
        testComp : reg_muxTest
           port map (selA, selB, src0, src1, rsltA, rsltB);
        testbench : process
        begin
            src0 <= "0101";
            src1 <= "0011";
            selA <= "00";
            selB <= "01";
            wait for 5 ns;
            assert rsltB = "0101" report "01 selB" severity error;
            wait for 5 ns;
            selA <= "10";
            selB <= "10";
            wait for 5 ns;
            assert rsltA = "0011" report "10 selA" severity error;
            assert rsltB = "0011" report "10 selB" severity error;
            wait for 5 ns;
            selA <= "01";
            src0 <= "1101";
            src1 <= "0110";
            wait for 5 ns;
            assert rsltA = "1101" report "01 selA" severity error;
            assert rsltB = "0110" report "10 selB 2" severity error;
            wait for 5 ns;
            wait;
        end process;
end;

















