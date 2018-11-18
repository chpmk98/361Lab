library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity add_32 is
	port(
	a_in 	: in std_logic_vector(31 downto 0);
	b_in	: in std_logic_vector(31 downto 0);
	c_in : in std_logic;
	sout	: out std_logic_vector(31 downto 0);
	cout: out std_logic;
	oflow: out std_logic
	);
end entity add_32;

architecture structural of add_32 is
signal jn: std_logic_vector(31 downto 0);

component full_add is
	port(
	a 	: in std_logic;
	b 	: in std_logic;
	cin : in std_logic;
	s 	: out std_logic;
	cout: out std_logic
	);
end component full_add;

component xor_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component xor_gate;

begin

START_ADD: full_add port map(a_in(0),b_in(0),c_in,sout(0),jn(0));
GEN_ADD: for ii in 1 to 30 generate
	A1: full_add port map
	(a_in(ii),b_in(ii),jn(ii-1),sout(ii),jn(ii));
end generate GEN_ADD;

END_ADD: full_add port map(a_in(31),b_in(31),jn(30),sout(31),jn(31));
cout <= jn(31);

--ovflow <= cout xor jn(30);
OVFLW: xor_gate port map(jn(31),jn(30),oflow);


end architecture structural;