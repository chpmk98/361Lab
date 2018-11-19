library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;

entity reg_comp_test2 is
end reg_comp_test2;

architecture behavioral of reg_comp_test2 is
    signal RegWr, clk : std_logic;
    signal Rw, Ra, Rb : std_logic_vector(4 downto 0);
    signal busW, busA, busB : std_logic_vector(31 downto 0);
    signal reg7to0: std_logic_vector(255 downto 0);
    signal reg7,reg6,reg5,reg4,reg3,reg2,reg1,reg0: std_logic_vector(31 downto 0);
    
    
    begin
        testComp : reg_comp
        port map (RegWr, Rw, Ra, Rb, busW, clk, busA, busB, reg7to0);
        reg0 <= reg7to0(31 downto 0);
        reg1 <= reg7to0(63 downto 32);
        reg2 <= reg7to0(95 downto 64);
        reg3 <= reg7to0(127 downto 96);
        reg4 <= reg7to0(159 downto 128);
        reg5 <= reg7to0(191 downto 160);
        reg6 <= reg7to0(223 downto 192);
        reg7 <= reg7to0(255 downto 224);
            
        testbench: process
        begin
            RegWr <= '1';
            Rw <= "00001";
            Ra <= "00001";
            Rb <= "00010";
            busW <= x"00000001";
            wait for 10 ns;
            Rw <= "00010";
            busW <= x"00000002";
            wait for 10 ns;
            Rw <= "00011";
            busW <= x"00000003";
            wait for 10 ns;
            Rw <= "00100";
            busW <= x"00000004";
            wait for 10 ns;
            Rw <= "00101";
            busW <= x"00000005";
            wait for 10 ns;
            Rw <= "00110";
            busW <= x"00000006";
            wait for 10 ns;
            Rw <= "00111";
            busW <= x"00000007";
            wait for 10 ns;
            RegWr <= '0';
            Ra <= "00001";
            wait for 5 ns;
            Ra <= "00010";
            wait for 5 ns;
            Ra <= "00011";
            wait for 5 ns;
            Ra <= "00100";
            wait for 5 ns;
            Ra <= "00101";
            wait for 5 ns;
            Ra <= "00110";
            wait for 5 ns;
            Ra <= "00111";
            wait for 5 ns;
            
            wait;
        end process;
        clk_process: process
        begin
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end process;
end;
