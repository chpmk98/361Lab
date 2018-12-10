library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.InstructionFetchUnitPackage.all;

entity fatPipeline_test is
end fatPipeline_test;

architecture behavioral of fatPipeline_test is
   component fatPipeline is
       port(
       clk: in std_logic;
       arst: in std_logic;
       Reg7to0Out: out std_logic_vector(255 downto 0);
       IDImm16: out std_logic_vector(15 downto 0);
       PCD: out std_logic_vector(31 downto 0);
       InFile: string
       );
   end component fatPipeline;
   
   signal clk, arst : std_logic;
   signal Reg7to0   : std_logic_vector(255 downto 0);
   signal IDImm16   : std_logic_vector(15 downto 0);
   signal PCD       : std_logic_vector(31 downto 0);
   
   signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : std_logic_vector(31 downto 0);
   
   begin
       testComp : fatPipeline
          port map (clk, arst, Reg7to0, IDImm16, PCD, "/home/atr7967/eecs361lib_cpu/eecs361/data/sort_corrected_branch.dat");

       reg0 <= reg7to0(31 downto 0);
       reg1 <= reg7to0(63 downto 32);
       reg2 <= reg7to0(95 downto 64);
       reg3 <= reg7to0(127 downto 96);
       reg4 <= reg7to0(159 downto 128);
       reg5 <= reg7to0(191 downto 160);
       reg6 <= reg7to0(223 downto 192);
       reg7 <= reg7to0(255 downto 224);
       
       testbench : process
       begin
           arst <= '1';
           wait for 10 ns;
           arst <= '0';
           wait;
       end process;
       
       clk_process : process
       begin
           clk <= '0';
           wait for 5 ns;
           clk <= '1';
           wait for 5 ns;
       end process;
   end;
   
end architecture behavioral;