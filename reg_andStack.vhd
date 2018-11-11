-- EECS 361 Single-Cycle Processor
-- by Alvin Tan

-- This component takes in 5 inputs and outputs the cumulative AND of all of them.

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity reg_andStack is
    port(
        in0, in1, in2, in3, in4 :  in std_logic;
        rslt                    : out std_logic
    );
end reg_andStack;

architecture structural of reg_andStack is
    signal andRslts : std_logic_vector(2 downto 0);
    begin
        and1 : and_gate
           port map (in0, in1, andRslts(0));
        and2 : and_gate
           port map (in2, in3, andRslts(1));
        and3 : and_gate
           port map (andRslts(0), andRslts(1), andRslts(2));
        and4 : and_gate
           port map (andRslts(2), in4, rslt);
end structural;








