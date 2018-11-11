library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity shift_32 is
	port(
	a	: in std_logic_vector(31 downto 0);
	b	: in std_logic_vector(4 downto 0);
	s	: out std_logic_vector(31 downto 0)
	);
end entity shift_32;

architecture structural of shift_32 is

signal im1: std_logic_vector(31 downto 0);
signal im2: std_logic_vector(31 downto 0);
signal im3: std_logic_vector(31 downto 0);
signal im4: std_logic_vector(31 downto 0);

component mux is
  port (
	sel	  : in	std_logic;
	src0  :	in	std_logic;
	src1  :	in	std_logic;
	z	  : out std_logic
  );
end component mux;

component mux_n is
  generic (
	n	: integer
  );
  port (
	sel	  : in	std_logic;
	src0  :	in	std_logic_vector(n-1 downto 0);
	src1  :	in	std_logic_vector(n-1 downto 0);
	z	  : out std_logic_vector(n-1 downto 0)
  );
end component mux_n;

begin

mux_map01: mux port map(b(0),a(0),'0',im1(0));

LAYER1: for ii in 1 to 31 generate
mux_map11: mux port map(b(0),a(ii),a(ii-1),im1(ii));
end generate LAYER1;

mux_map02: mux_n generic map(n=>2) port map(b(1),im1(1 downto 0),"00",im2(1 downto 0));

LAYER2: for ii in 1 to 15 generate
mux_map12: mux_n generic map(n => 2)
				port map(b(1),im1(2*ii+1 downto 2*ii),im1(2*ii-1 downto 2*ii-2),im2(2*ii+1 downto 2 * ii));
end generate LAYER2;

mux_map03: mux_n generic map(n=>4) port map(b(2),im2(3 downto 0),"0000",im3(3 downto 0));

LAYER3: for ii in 1 to 7 generate
mux_map13: mux_n generic map(n => 4)
				port map(b(2),im2(4*ii + 3 downto 4*ii),im2(4*ii-1 downto 4*ii-4),im3(4*ii+3 downto 4*ii));
end generate LAYER3;

mux_map04: mux_n generic map(n=>8) port map(b(3),im3(7 downto 0),"00000000",im4(7 downto 0));

LAYER4: for ii in 1 to 3 generate
mux_map14: mux_n generic map(n => 8)
				port map(b(3),im3(8*ii+7 downto 8*ii),im3(8*ii-1 downto 8*ii - 8),im4(8*ii+7 downto 8*ii));
end generate LAYER4;

mux_map05: mux_n generic map(n=>16) port map(b(4),im4(15 downto 0),"0000000000000000",s(15 downto 0));

mux_map15: mux_n generic map(n => 16)
				port map(b(4),im4(31 downto 16),im4(15 downto 0),s(31 downto 16));

end architecture structural;