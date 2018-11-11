library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity or_gate_6bit is
	port(
	a: in std_logic;
	b: in std_logic;
	c: in std_logic;
	d: in std_logic;
	e: in std_logic;
	f: in std_logic;
	z: out std_logic
	);
end entity or_gate_6bit;

architecture structural of or_gate_6bit is
signal i: std_logic_vector(3 downto 0);
begin
	and1:or_gate port map(a,b,i(3));
	and2:or_gate port map(i(3),c,i(2));
	and3:or_gate port map(i(2),d,i(1));
	and4:or_gate port map(i(1),e,i(0));
	and5:or_gate port map(i(0),f,z);
end architecture structural;