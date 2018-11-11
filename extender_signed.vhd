-- EECS 361 Single-Cycle Processor
-- by Alvin Tan

-- This component sign-extends a 16-bit input to a 32-bit output.

library ieee;
use ieee.std_logic_1164.all;

entity extender_signed is
    port (
       src    :  in std_logic_vector(15 downto 0);
       rslt   : out std_logic_vector(31 downto 0)
    );
end extender_signed;

architecture structural of extender_signed is
    begin
        extension : for i in 16 to 31 generate
           rslt(i) <= src(15);
        end generate extension;
        
        rslt(15 downto 0) <= src;
end structural;






