library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity full_add is
	port(
	a 	: in std_logic;
	b 	: in std_logic;
	cin : in std_logic;
	s 	: out std_logic;
	cout: out std_logic
	);
end entity full_add;

architecture structural of full_add is
signal axorb: std_logic;
signal aandb: std_logic;
signal im1: std_logic;

component xor_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component xor_gate;

component and_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component and_gate;

component or_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component or_gate;

begin
	-- s <= a xor b xor cin;
	PORT_ADD1: xor_gate port map(a,b,axorb);
	PORT_ADD2: xor_gate port map(axorb,cin,s);
	
	-- cout <= (a and b) or (cin and (a xor b));
	PORT_COUT1: and_gate port map(a,b,aandb);
	PORT_COUT2: and_gate port map(cin,axorb,im1);
	PORT_COUT3: or_gate port map(aandb,im1,cout);
end architecture structural;
