library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity alu_singlebit_v2 is
	port(
	a	: in std_logic;
	b	: in std_logic;
  cin : in std_logic;
  less : in std_logic;
	ctrl: in std_logic_vector(3 downto 0);
	s 	: out std_logic;
	sum   : out std_logic;
	cout: out std_logic
	);
end entity alu_singlebit_v2;

architecture structural of alu_singlebit_v2 is
signal a_not: std_logic;
signal b_not: std_logic;
signal b_in	: std_logic;
signal b_ctrl_temp : std_logic;
signal b_ctrl: std_logic;
signal addsub: std_logic;

signal andout: std_logic;
signal xorout: std_logic;
signal orout: std_logic;

signal andxor: std_logic;
signal slt_sltuout: std_logic;
signal add_sub_and_xor: std_logic;
signal or_less: std_logic;

component mux is
  port (
	sel   : in  std_logic;
	src0  : in  std_logic;
	src1  : in  std_logic;
	z	    : out std_logic
  );
end component mux;

component full_add is
	port(
	a 	: in std_logic;
	b	: in std_logic;
	cin : in std_logic;
	s	: out std_logic;
	cout: out std_logic
	);
end component full_add;

component not_gate is
  port (
    x   : in  std_logic;
    z   : out std_logic
  );
end component not_gate;

component and_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component and_gate;

component xor_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component xor_gate;

component or_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component or_gate;

begin
INV_B: not_gate port map(b,b_not);

-- select whether b is inverted or not
CTRL_B_0: and_gate port map(ctrl(1),ctrl(2),b_ctrl_temp);
CTRL_B_1: or_gate port map(ctrl(0),b_ctrl_temp,b_ctrl);
SEL_B: mux port map(b_ctrl,b,b_not,b_in);

ADD_PORT: full_add port map(a,b_in,cin,addsub,cout);
sum <= addsub;

AND_PORT: and_gate port map(a,b,andout);
XOR_PORT: xor_gate port map(a,b,xorout);
OR_PORT: or_gate port map(a,b,orout);

SEL_AND_XOR: mux port map(ctrl(0),andout,xorout,andxor);

CTRL2_0_IN: mux port map(ctrl(1),addsub,andxor,add_sub_and_xor);
CTRL2_1_IN: mux port map(ctrl(1),orout,less,or_less);

CTRL2_OUT: mux port map(ctrl(2),add_sub_and_xor,or_less,s);

end architecture structural;