library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity final_alu_32_v2 is
	port(
	a	: in std_logic_vector(31 downto 0);
	b	: in std_logic_vector(31 downto 0);
	ctrl: in std_logic_vector(3 downto 0);
	s 	: out std_logic_vector(31 downto 0);
	z   : out std_logic;
	cout: out std_logic;
	ovflow: out std_logic
	);
end entity final_alu_32_v2;

architecture structural of final_alu_32_v2 is
    
signal sll_im: std_logic_vector(31 downto 0);
signal alu_im: std_logic_vector(31 downto 0);
signal s_0: std_logic_vector(31 downto 0);
signal cout_im: std_logic;
signal ovflow_im: std_logic;
signal tmp: std_logic_vector(1 downto 0);

signal toggle_cout_ov: std_logic;

component alu_32_v2 is
   port(
	  a_in	: in std_logic_vector(31 downto 0);
	  b_in	: in std_logic_vector(31 downto 0);
	  ctrl: in std_logic_vector(3 downto 0);
	  sout 	: out std_logic_vector(31 downto 0);
	  cout: out std_logic;
	  oflow: out std_logic
	   );
end component alu_32_v2;

component shift_32 is
	port(
	a	: in std_logic_vector(31 downto 0);
	b	: in std_logic_vector(4 downto 0);
	s	: out std_logic_vector(31 downto 0)
	);
end component shift_32;

component zero_32 is
	port(
	a	: in std_logic_vector(31 downto 0);
	z	: out std_logic
	);
end component zero_32;

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

component mux_32 is
  port (
	sel   : in  std_logic;
	src0  : in  std_logic_vector(31 downto 0);
	src1  : in  std_logic_vector(31 downto 0);
	z	    : out std_logic_vector(31 downto 0)
  );
end component mux_32;

component mux is
  port (
	sel	  : in	std_logic;
	src0  :	in	std_logic;
	src1  :	in	std_logic;
	z	  : out std_logic
  );
end component mux;

begin
    --CTRL INSTRUCTION
    --0000 add
    --0001 sub
    --0010 and
    --0011 xor
    --0100 or
    --0110 slt
    --0111 sltu
    --1000 sll
    ALU_OUT1: alu_32_v2 port map(a,b,ctrl,alu_im,cout_im,ovflow_im);
    SLL_OUT: shift_32 port map(a,b(4 downto 0),sll_im);
    
    SEL_OUT: mux_32 port map(ctrl(3),alu_im,sll_im,s_0);
    
    s <= s_0;
    
    --if ctrl == 0000 or 0001,
    --then output carry, else output 0
    SEL_CARRY1: or_gate port map(ctrl(1),ctrl(2),tmp(0));
    SEL_CARRY2: or_gate port map(ctrl(3),tmp(0),tmp(1));
    SEL_CARRY3: mux port map(tmp(1),cout_im,'0',cout);
    SEL_OVFLOW: mux port map(tmp(1),ovflow_im,'0',ovflow);
    --outputs 1 if whole sum is 0
    GET_ZERO: zero_32 port map(s_0,z);

end architecture structural;