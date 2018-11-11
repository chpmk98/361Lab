-- EECS 361 Single-Cycle Processor
-- by Alvin Tan

-- This component is a single, 32-bit register that takes inputs inWrite (32-bits), RegWr, Rst,
--  RegRead, and clk;
--  and outputs Q, which is the value stored in the register. The value stored in the register
--  will be updated to In on the rising edge of clk when RegWr = 1. Otherwise, the register
--  maintains its current value.

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity reg_32 is
    port (
        inWrite :  in std_logic_vector(31 downto 0);
        RegWr   :  in std_logic;
        Rst     :  in std_logic;
        RegRead :  in std_logic;
        clk     :  in std_logic;
        Q       : out std_logic_vector(31 downto 0)
    );
end reg_32;

architecture structural of reg_32 is
   signal curQ : std_logic_vector(31 downto 0);
   begin
       dFFs   : for i in 0 to 31 generate
          dFF : dffr_a
             port map (clk, Rst, RegRead, curQ(i), inWrite(i), RegWr, curQ(i));
       end generate dFFs;
       
       Q <= curQ;
end structural;













