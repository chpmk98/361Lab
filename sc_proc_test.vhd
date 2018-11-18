library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.InstructionFetchUnitPackage.all;

entity sc_proc_test is
end sc_proc_test;

architecture behavioral of sc_proc_test is
    signal clk, pcReset : std_logic;
    signal inst         : std_logic_vector(31 downto 0);
    signal reg7to0      : std_logic_vector(255 downto 0);
    signal reg0         : std_logic_vector(31 downto 0);
    signal reg1         : std_logic_vector(31 downto 0);
    signal reg2         : std_logic_vector(31 downto 0);
    signal reg3         : std_logic_vector(31 downto 0);
    signal reg4         : std_logic_vector(31 downto 0);
    signal reg5         : std_logic_vector(31 downto 0);
    signal reg6         : std_logic_vector(31 downto 0);
    signal reg7         : std_logic_vector(31 downto 0);
    
    begin
       testComp : sc_proc
          port map (clk, "/home/atr7967/eecs361lib_cpu/eecs361/data/bills_branch.dat",
                   "/home/atr7967/eecs361lib_cpu/eecs361/data/bills_branch.dat", pcReset,
                   reg7to0, inst);
       reg7to0 <= reg7 & reg6 & reg5 & reg4 & reg3 & reg2 & reg1 & reg0;
       
       testbench: process
       begin
           pcReset <= '1';
           wait for 10 ns;
           pcReset <= '0';
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








