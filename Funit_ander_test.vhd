library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.InstructionFetchUnitPackage.all;

entity Funit_ander_test is
end Funit_ander_test;

architecture behavioral of Funit_ander_test is
   component Funit_ander is
       port (
           Wr   :  in std_logic;
           R    :  in std_logic_vector(4 downto 0);
           Rw   :  in std_logic_vector(4 downto 0);
           WrOut: out std_logic
       );
   end component Funit_ander;
   
   signal Wr : std_logic;
   signal R, Rw : std_logic_vector(4 downto 0);
   signal WrOut : std_logic;
   
   begin
       testComp : Funit_ander
          port map (Wr, R, Rw, WrOut);
       
       testbench : process
       begin
           Wr <= '0';
           R <= "01010";
           Rw <= "01010";
           wait for 5 ns;
           Rw <= "10010";
           wait for 5 ns;
           Wr <= '1';
           R <= "01010";
           Rw <= "01010";
           wait for 5 ns;
           Rw <= "10010";
           wait for 5 ns;
           wait;
       end process;
   end architecture behavioral;
    
















