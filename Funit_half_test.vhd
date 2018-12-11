library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.InstructionFetchUnitPackage.all;

entity Funit_half_test is
end Funit_half_test;

architecture behavioral of Funit_half_test is
   component Funit_half is
	    port (
	        -- From the ID/EX register
	        -- Note to future Alvin: Store the following from IDunit in a register
	        --  outside of EXunit, then feed the values from that register into
	        --  this Funit, and feed the output values from here into EXunit.
	        Rs     :  in std_logic_vector(4 downto 0);  -- Source of BusA
	        BusAin :  in std_logic_vector(31 downto 0);
	        -- From the EX/Mem register
	        WrEX   :  in std_logic;                     -- Set if BusWEX will be written into RwEX
	        RwEX   :  in std_logic_vector(4 downto 0);
	        BusWEX :  in std_logic_vector(31 downto 0);
	        -- From the Mem/WR register
	        WrMem  :  in std_logic;                     -- Set if BusWMem will be written into RwMem
	        RwMem  :  in std_logic_vector(4 downto 0);
	        BusWMem:  in std_logic_vector(31 downto 0);
	        -------------------------------------------
	        WrEXAO : out std_logic;
	        WrMemAO: out std_logic;
	        BusAmidO: out std_logic_vector(31 downto 0);
	        BusAfinO: out std_logic_vector(31 downto 0);
	        BusA   : out std_logic_vector(31 downto 0)
	    );
	end component Funit_half;
   
   signal Rs, RwEX, RwMem : std_logic_vector(4 downto 0);
   signal BusAin, BusWEX, BusWMem, BusAmid, BusAfin, BusA : std_logic_vector(31 downto 0);
   signal WrEX, WrMem, WrEXA, WrMemA : std_logic;
   
   begin
       testComp : Funit_half
          port map (Rs, BusAin, WrEx, RwEX, BusWEX, WrMem, RwMem, BusWMem, WrEXA, WrMemA, BusAmid, BusAfin, BusA);
                        
       testbench : process
       begin
           BusAin <= x"10000000";
           BusWEX <= x"00000010";
           BusWMem <= x"00000100";
           Rs <= "01000";
           wait for 5 ns;
           WrEx <= '0';
           WrMem <= '0';
           wait for 5 ns;
           WrEx <= '1';
           WrMem <= '1';
           RwEx <= "00100";
           RwMem <= "10000";
           wait for 5 ns;
           RwMem <= "01000";
           wait for 5 ns;
           RwEx <= "01000";
           wait for 5 ns;
           Rs <= "00000";
           wait for 5 ns;
           RwEx <= "00000";
           wait for 5 ns;
           
           
           
           
           
           wait;
       end process;
   end architecture behavioral;
           







