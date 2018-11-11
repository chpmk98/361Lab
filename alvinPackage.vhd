-- EECS 361 Single-Cycle Processor
-- by Alvin Tan

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

package alvinPackage is
    -- A single, 32-bit register
    component reg_32
        port (
            inWrite :  in std_logic_vector(31 downto 0);
            RegWr   :  in std_logic;
            Rst     :  in std_logic;
            clk     :  in std_logic;
            Q       : out std_logic_vector(31 downto 0)
        );
    end component reg_32;
    
    -- A 5 to 1 AND stack
    component reg_andStack is
	     port(
	         in0, in1, in2, in3, in4 :  in std_logic;
	         rslt                    : out std_logic
	     );
	 end component reg_andStack;
    
    -- Given a 5-bit input, returns a 32-bit 1-hot output
    component reg_addToBinary is
	     port (
	         addr   :  in std_logic_vector(4 downto 0);
	         binary : out std_logic_vector(31 downto 0)
	     );
	 end component reg_addToBinary;
    
    -- Used to test a mechanism I used in reg_comp
    component reg_muxTest is
        port (
            selA  : in std_logic_vector(1 downto 0);
            selB  : in std_logic_vector(1 downto 0);
            src0  : in std_logic_vector(3 downto 0);
            src1  : in std_logic_vector(3 downto 0);
            rsltA : out std_logic_vector(3 downto 0);
            rsltB : out std_logic_vector(3 downto 0)
        );
    end component reg_muxTest;
    
    -- The 32 32-bit register component
    component reg_comp is
	     port (
	         RegWr   :  in std_logic;
	         Rw      :  in std_logic_vector(4 downto 0);
	         Ra      :  in std_logic_vector(4 downto 0);
	         Rb      :  in std_logic_vector(4 downto 0);
	         busW    :  in std_logic_vector(31 downto 0);
	         clk     :  in std_logic;
	         busA    : out std_logic_vector(31 downto 0);
	         busB    : out std_logic_vector(31 downto 0)
	     );
	 end component reg_comp;
	 
	 -- Sign-extends a 16-bit input to 32-bits
	 component extender_signed is
        port (
           src    :  in std_logic_vector(15 downto 0);
           rslt   : out std_logic_vector(31 downto 0)
        );
    end component extender_signed;
end;