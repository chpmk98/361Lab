library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity alu_test_v2 is
end alu_test_v2;

architecture behavioral of alu_test_v2 is
signal a	: std_logic_vector(31 downto 0);
signal b	: std_logic_vector(31 downto 0);
signal ctrl: std_logic_vector(3 downto 0);
signal s: std_logic_vector(31 downto 0);
signal z : std_logic;
signal cout: std_logic;
signal ovflow: std_logic;

component final_alu_32_v2 is
	port(
	a	: in std_logic_vector(31 downto 0);
	b	: in std_logic_vector(31 downto 0);
	ctrl: in std_logic_vector(3 downto 0);
	s 	: out std_logic_vector(31 downto 0);
	z   : out std_logic;
	cout: out std_logic;
	ovflow: out std_logic
	);
end component final_alu_32_v2;

begin
  test_comp : final_alu_32_v2
	port map(
	a  => a,
	b => b,
	ctrl=> ctrl,
	s => s,
	z => z,
	cout => cout,
	ovflow => ovflow
	);
  testbench : process is
  begin
	ctrl <= "0000";
	a <= "01000000000000000000000000001010";
	b <= "01000000000000000000000000001001";
	wait for 5 ns;
	assert s = "10000000000000000000000000010011" report "add 0" severity error;
	assert ovflow = '1' report "add ovflow 1" severity error;
	assert cout = '0' report "add cout 0" severity error;
	ctrl <= "0000";
	a <= "10000000000000000000000000000001";
	b <= "10000000000000000000000000000111";
	wait for 5 ns;
	assert s = "00000000000000000000000000001000" report "add 1" severity error;
	assert ovflow = '1' report "add ovflow 1" severity error;
	assert cout = '1' report "add cout 1" severity error;
	ctrl <= "0000";
	a <= "00000000000000000000000000000010";
	b <= "11111111111111111111111111111110";
	wait for 5 ns;
	assert s = "00000000000000000000000000000000" report "add 2" severity error;
	assert ovflow = '0' report "add ovflow 0" severity error;
	assert cout = '1' report "add cout 1" severity error;
	assert z = '1' report "add z 1 fail" severity error;
	
	
	ctrl <= "0001";
	a <= "01000000000000000000000000001010";
	b <= "01000000000000000000000000001001";
	wait for 5 ns;
	assert s = "00000000000000000000000000000001" report "sub 0" severity error;
	assert ovflow = '0' report "sub ovflow 0" severity error;
	assert cout = '1' report "sub cout 0" severity error;
	ctrl <= "0001";
	a <= "10000000000000000000000000000000";
	b <= "00000000000000000000000000000111";
	wait for 5 ns;
	assert s = "01111111111111111111111111111001" report "sub 1" severity error;
	assert ovflow = '1' report "sub ovflow 1" severity error;
	assert cout = '1' report "sub cout 1" severity error;
	
	ctrl <= "0010";
	a <= "01000000000000000000000000001010";
	b <= "01000000000000000000000000001001";
	wait for 5 ns;
	assert s = "01000000000000000000000000001000" report "and 0" severity error;
	
	ctrl <= "0011";
	a <= "00000000000000000000000000001010";
	b <= "00000000000000000000000000001001";
	wait for 5 ns;
	assert s = "00000000000000000000000000000011" report "xor 0" severity error;

	ctrl <= "0100";
	a <= "00000000000000000000000000001010";
	b <= "00000000000000000000000000001001";
	wait for 5 ns;
	assert s = "00000000000000000000000000001011" report "or 0" severity error;
	
	ctrl <= "0110";
	a <= "10000000000000000000000000000000";
   b <= "01111111111111111111111111111110";
   wait for 5 ns;
   assert s = "00000000000000000000000000000001" report "slt 0" severity error;
	a <= "01111111111111111111111111111110";
   b <= "10000000000000000000000000000000";
   wait for 5 ns;
   assert s = "00000000000000000000000000000000" report "slt 1" severity error;
	a <= "01111111111111111111111111111110";
   b <= "01111111111111111111111111111110";
   wait for 5 ns;
   assert s = "00000000000000000000000000000000" report "slt 2" severity error;
	a <= "11111111111111111111111111111111";
   b <= "00000000000000000000000000000001";
   wait for 5 ns;
   assert s = "00000000000000000000000000000001" report "slt 3" severity error;
   
 	ctrl <= "0111";
	a <= "10000000000000000000000000000000";
   b <= "01111111111111111111111111111110";
   wait for 5 ns;
   assert s = "00000000000000000000000000000000" report "sltu 0" severity error;
	a <= "01111111111111111111111111111110";
   b <= "10000000000000000000000000000000";
   wait for 5 ns;
   assert s = "00000000000000000000000000000001" report "sltu 1" severity error;
	a <= "01111111111111111111111111111110";
   b <= "01111111111111111111111111111110";
   wait for 5 ns;
   assert s = "00000000000000000000000000000000" report "sltu 2" severity error;
	a <= "11111111111111111111111111111111";
   b <= "00000000000000000000000000000001";
   wait for 5 ns;
   assert s = "00000000000000000000000000000000" report "sltu 3" severity error;
	a <= "00000000000000000000000000000001";
   b <= "11111111111111111111111111111111";
   wait for 5 ns;
   assert s = "00000000000000000000000000000001" report "sltu 4" severity error;
   
 	ctrl <= "1000";
	a <= "10101010101010101010101010101010";
   b <= "00000000000000000000000000001001";
   wait for 5 ns;
   assert s = "01010101010101010101010000000000" report "sll 0" severity error;
	a <= "10101010101010101010101010101010";
   b <= "00000000000000000000000000010111";
   wait for 5 ns;
   assert s = "01010101000000000000000000000000" report "sll 1" severity error;
	
	wait;
  end process;
end architecture behavioral;