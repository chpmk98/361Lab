library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.InstructionFetchUnitPackage.all;

entity Funit_test is
end Funit_test;

architecture behavioral of Funit_test is
   component Funit is
       port (
           -- From the ID/EX register
           -- Note to future Alvin: Store the following from IDunit in a register
           --  outside of EXunit, then feed the values from that register into
           --  this Funit, and feed the output values from here into EXunit.
           Rs     :  in std_logic_vector(4 downto 0);  -- Source of BusA
           Rt     :  in std_logic_vector(4 downto 0);  -- Source of BusB
           BusAin :  in std_logic_vector(31 downto 0);
           BusBin :  in std_logic_vector(31 downto 0);
           -- From the EX/Mem register
           WrEX   :  in std_logic;                     -- Set if BusWEX will be written into RwEX
           RwEX   :  in std_logic_vector(4 downto 0);
           BusWEX :  in std_logic_vector(31 downto 0);
           -- From the Mem/WR register
           WrMem  :  in std_logic;                     -- Set if BusWMem will be written into RwMem
           RwMem  :  in std_logic_vector(4 downto 0);
           BusWMem:  in std_logic_vector(31 downto 0);
           -------------------------------------------
           BusA   : out std_logic_vector(31 downto 0);
           BusB   : out std_logic_vector(31 downto 0)
       );
   end component Funit;
   
   signal Rs, Rt, RwEX, RwMem : std_logic_vector(4 downto 0);
   signal BusAin, BusBin, BusWEX, BusWMem, BusA, BusB : std_logic_vector(31 downto 0);
   signal WrEX, WrMem : std_logic;
   
   begin
       testComp : Funit
          port map (Rs, Rt, BusAin, BusBin, WrEx, RwEX, BusWEX, WrMem, RwMem, BusWMem, BusA, BusB);
              
       testbench : process
       begin
           BusAin <= x"00000000";
           BusBin <= x"00000001";
           BusWEX <= x"00000010";
           BusWMem <= x"00000100";
           Rs <= "01000";
           Rt <= "10000";
           wait for 5 ns;
           WrEx <= '0';
           WrMem <= '0';
           wait for 5 ns;
           WrEx <= '1';
           WrMem <= '1';
           RwEx <= "00100";
           RwMem <= "10000";
           wait for 5 ns;
           
           
           
           
           
           wait;
       end process;
   end architecture behavioral;
           


















