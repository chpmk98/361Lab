library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity shift_test is
end shift_test;

architecture behavioral of shift_test is
signal a	: std_logic_vector(31 downto 0);
signal b	: std_logic_vector(4 downto 0);
signal s: std_logic_vector(31 downto 0);

component shift_32 is
	port(
	a	: in std_logic_vector(31 downto 0);
	b	: in std_logic_vector(4 downto 0);
	s	: out std_logic_vector(31 downto 0)
	);
end component shift_32;

begin
  test_comp : shift_32
	port map(
	a  => a,
	b => b,
	s => s
	);
  testbench : process is
  begin
	a <= "00000000000000000000000000001010";
	b <= "00001";
	wait for 5 ns;
	a <= "11111111111111111111111111111111";
	b <= "00111";
	wait for 5 ns;
	a <= "00000000000000000000000011110011";
	b <= "00110";
	wait for 5 ns;
	a <= "00000000000000000000000011110011";
	b <= "11111";
	wait;
  end process;
end behavioral;