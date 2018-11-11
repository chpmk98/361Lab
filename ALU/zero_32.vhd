library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity zero_32 is
	port(
	a	: in std_logic_vector(31 downto 0);
	z	: out std_logic
	);
end entity zero_32;

architecture structural of zero_32 is

signal lnk: std_logic_vector(30 downto 0);

component or_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component or_gate;


component not_gate is
  port (
    x   : in  std_logic;
    z   : out std_logic
  );
end component not_gate;
begin

OR_1: or_gate port map(a(0),a(1),lnk(0));
--or the entire signal together and invert
GEN_OR: for ii in 1 to 30 generate
	U1: or_gate port map(a(ii+1),lnk(ii-1),lnk(ii));
end generate GEN_OR;

INV_OUT: not_gate port map(lnk(30),z);

end architecture structural;