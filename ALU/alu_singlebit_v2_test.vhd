library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity alu_singlebit_test_v2 is
end alu_singlebit_test_v2;

architecture behavioral of alu_singlebit_test_v2 is
signal a	: std_logic;
signal b	: std_logic;
signal cin: std_logic;
signal less: std_logic;
signal ctrl: std_logic_vector(3 downto 0);
signal s: std_logic;
signal cout: std_logic;

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

begin
  test_comp : alu_singlebit_v2
	port map(
	a  => a,
	b => b,
	cin => cin,
	less => less,
	ctrl=> ctrl,
	s => s,
	cout => cout
	);
  testbench : process is
  begin
   cin <= '0';
   less <= '1';
	ctrl <= "0000";
	a <= '0';
	b <= '1';
	wait for 5 ns;
	assert s = '1' report "add 0" severity error;
	assert cout = '0' report "add cout 0" severity error;
	ctrl <= "0000";
	a <= '1';
	b <= '1';
	wait for 5 ns;
	assert s = '0' report "add 1" severity error;
	assert cout = '1' report "add cout 1" severity error;
	ctrl <= "0000";
	a <= '0';
	b <= '0';
	wait for 5 ns;
	assert s = '0' report "add 2" severity error;
	assert cout = '0' report "add cout 2" severity error;
	a <= '1';
	b <= '0';
	wait for 5 ns;
	assert s = '1' report "add 3" severity error;
	assert cout = '0' report "add cout 3" severity error;
	
	cin <= '1';
	ctrl <= "0001";
	a <= '0';
	b <= '1';
	wait for 5 ns;
	assert s = '1' report "sub 0" severity error;
	assert cout = '0' report "sub cout 0" severity error;
	ctrl <= "0001";
	a <= '1';
	b <= '1';
	wait for 5 ns;
	assert s = '0' report "sub 1" severity error;
	assert cout = '1' report "sub cout 1" severity error;
	a <= '0';
	b <= '0';
	wait for 5 ns;
	assert s = '0' report "sub 2" severity error;
	assert cout = '1' report "sub cout 2" severity error;
	a <= '1';
	b <= '0';
	wait for 5 ns;
	assert s = '1' report "sub 4" severity error;
	assert cout = '1' report "sub cout 4" severity error;
	
	ctrl <= "0010";
	a <= '0';
	b <= '1';
	wait for 5 ns;
	assert s = '0' report "and 0" severity error;
	a <= '1';
	b <= '0';
	wait for 5 ns;
	assert s = '0' report "and 1" severity error;
	a <= '1';
	b <= '1';
	wait for 5 ns;
	assert s = '1' report "and 2" severity error;
	a <= '0';
	b <= '0';
	wait for 5 ns;
	assert s = '0' report "and 3" severity error;
	
	ctrl <= "0011";
	a <= '0';
	b <= '1';
	wait for 5 ns;
	assert s = '1' report "xor 0" severity error;
	a <= '1';
	b <= '0';
	wait for 5 ns;
	assert s = '1' report "xor 1" severity error;
	a <= '1';
	b <= '1';
	wait for 5 ns;
	assert s = '0' report "xor 2" severity error;
	a <= '0';
	b <= '0';
	wait for 5 ns;
	assert s = '0' report "xor 3" severity error;

	ctrl <= "0100";
	a <= '0';
	b <= '1';
	wait for 5 ns;
	assert s = '1' report "or 0" severity error;
	a <= '1';
	b <= '0';
	wait for 5 ns;
	assert s = '1' report "or 1" severity error;
	a <= '1';
	b <= '1';
	wait for 5 ns;
	assert s = '1' report "or 2" severity error;
	a <= '0';
	b <= '0';
	wait for 5 ns;
	assert s = '0' report "or 3" severity error;
	
	ctrl <= "0110";
	a <= '1';
   b <= '0';
   wait for 5 ns;
   assert s = '1' report "slt 1" severity error;
   less <= '0';
   wait for 5 ns;
   assert s = '0' report "slt 1" severity error;
	a <= '0';
   b <= '1';
   wait for 5 ns;
   assert s = '0' report "slt 1" severity error;
   
   less <= '1';
 	ctrl <= "0111";
	a <= '1';
   b <= '0';
   wait for 5 ns;
   assert s = '1' report "sltu 1" severity error;
   less <= '0';
	a <= '0';
   b <= '1';
   wait for 5 ns;
   assert s = '0' report "sltu 1" severity error;
	
	wait;
  end process;
end behavioral;