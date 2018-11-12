library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity InstructionFetchUnitTest is
end InstructionFetchUnitTest;

architecture behavioral of InstructionFetchUnitTest is
    signal clk: std_logic := 0;
    component InstructionFetchUnit is
        port(
            clk: in std_logic;
            Branch: in std_logic_vector(1 downto 0);
            Zero: in std_logic;
            Sign: in std_logic;
            Instruction: out std_logic_vector(31 downto 0);
            InFile: string
        );
    end component InstructionFetchUnit;
    begin
    
    
    clk_process: process
    begin
        clk <= 0;
        wait for 5 ns;
        clk <= 1;
        wait for 5 ns;
    end process;
    
end architecture;