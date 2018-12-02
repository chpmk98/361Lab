library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;

--Compare two register addresses
--output 1 if they are equal

entity regCompare is
    port(
        Ra: in std_logic_vector(4 downto 0);
        Rb: in std_logic_vector(4 downto 0);
        eq: out std_logic
    );
end entity regCompare;

architecture structural of regCompare is
    signal tmp: std_logic_vector(4 downto 0);
    
    component and_gate_6bit is
		 port(
		 a: in std_logic;
		 b: in std_logic;
		 c: in std_logic;
		 d: in std_logic;
		 e: in std_logic;
		 f: in std_logic;
		 z: out std_logic
		 );
	 end component and_gate_6bit;
    begin
        XNORGates: xnor_gate_n generic map(n => 5) port map(Ra,Rb,tmp);
        EQResult: and_gate_6bit port map(tmp(0),tmp(1),tmp(2),tmp(3),tmp(4),'1',eq);
end architecture structural;