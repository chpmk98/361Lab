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
    signal BussA        : std_logic_vector(31 downto 0);
    signal BussB        : std_logic_vector(31 downto 0);
    signal MemWrAdd     : std_logic_vector(31 downto 0);
    signal dOut         : std_logic_vector(31 downto 0);
    signal Rw           : std_logic_vector(4 downto 0);
    signal regWr, memWr : std_logic;
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
                   reg7to0, inst, BussA, BussB, MemWrAdd, dOut, Rw, regWr, memWr);
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








