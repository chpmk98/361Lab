library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity alu_32_v2 is
	port(
	a_in 	: in std_logic_vector(31 downto 0);
	b_in	: in std_logic_vector(31 downto 0);
	ctrl : in std_logic_vector(3 downto 0);
	sout	: out std_logic_vector(31 downto 0);
	cout: out std_logic;
	oflow: out std_logic
	);
end entity alu_32_v2;

architecture structural of alu_32_v2 is
signal cin: std_logic;
signal b_ctrl_temp: std_logic;
signal jn: std_logic_vector(31 downto 0);
signal set_bit: std_logic;
signal oflow_im : std_logic;
signal slt : std_logic;
signal sltu :std_logic;
signal slt_sltu: std_logic;

component alu_singlebit_v2 is
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
end component alu_singlebit_v2;

component mux is
  port (
	sel   : in  std_logic;
	src0  : in  std_logic;
	src1  : in  std_logic;
	z	    : out std_logic
  );
end component mux;

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

component not_gate is
  port (
    x   : in  std_logic;
    z   : out std_logic
  );
end component not_gate;

begin

--control signal to denote when to subtract. this simply changes cin
CTRL_SUB_0: and_gate port map(ctrl(1),ctrl(2),b_ctrl_temp);
CTRL_SUB_1: or_gate port map(ctrl(0),b_ctrl_temp,cin);

-- generate ripple carry adder
START_ADD: alu_singlebit_v2 port map(a_in(0),b_in(0),cin,slt_sltu,ctrl,sout(0),open,jn(0));
GEN_ADD: for ii in 1 to 30 generate
	A1: alu_singlebit_v2 port map
	(a_in(ii),b_in(ii),jn(ii-1),'0',ctrl,sout(ii),open,jn(ii));
end generate GEN_ADD;

END_ADD: alu_singlebit_v2 port map(a_in(31),b_in(31),jn(30),'0',ctrl,sout(31),set_bit,jn(31));
cout <= jn(31);

--ovflow <= cout xor jn(30);
OVFLW: xor_gate port map(jn(31),jn(30),oflow_im);
oflow <= oflow_im;

--slt and sltu handle, for sltu you invert carryout bit and for sltu you xor the overflow with sign bit
SLT_GET: xor_gate port map(set_bit,oflow_im,slt);
SLTU_GET: not_gate port map(jn(31),sltu);
SLT_MUX: mux port map(ctrl(0),slt,sltu,slt_sltu);




end architecture structural;