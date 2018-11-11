library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;

entity reg_comp_test is
end reg_comp_test;

architecture behavioral of reg_comp_test is
    signal RegWr, clk : std_logic;
    signal Rw, Ra, Rb : std_logic_vector(4 downto 0);
    signal busW, busA, busB : std_logic_vector(31 downto 0);
    
    begin
        testComp : reg_comp
        port map (RegWr, Rw, Ra, Rb, busW, clk, busA, busB);
            
        testbench: process
        begin
            RegWr <= '0';
            clk <= '0';
            Rw <= "00101";
            Ra <= "00000";
            Rb <= "01011";
            busW <= "10011001100110011001100110011001";
            wait for 5 ns;
            assert busA = "00000000000000000000000000000000" report "read reg0" severity error;
            wait for 5 ns;
            RegWr <= '1';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            Rb <= "00101";
            wait for 5 ns;
            assert busB = "10011001100110011001100110011001" report "read after write" severity error;
            wait for 5 ns;
            RegWr <= '0';
            busW <= "01100110011001100110011001100110";
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            assert busB = "10011001100110011001100110011001" report "RegWr = 0" severity error;
            wait for 5 ns;
            Ra <= "00011";
            Rw <= "00011";
            RegWr <= '1';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            assert busA = "01100110011001100110011001100110" report "read after write 2" severity error;
            assert busB = "10011001100110011001100110011001" report "changed without write" severity error;
            wait for 5 ns;
            wait;
        end process;
end;

















