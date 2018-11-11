library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity reg_muxTest is
    port (
        selA  : in std_logic_vector(1 downto 0);
        selB  : in std_logic_vector(1 downto 0);
        src0  : in std_logic_vector(3 downto 0);
        src1  : in std_logic_vector(3 downto 0);
        rsltA : out std_logic_vector(3 downto 0);
        rsltB : out std_logic_vector(3 downto 0)
    );
end reg_muxTest;

architecture structural of reg_muxTest is
    signal outA0, outA1  : std_logic_vector(3 downto 0);
    signal outB0, outB1  : std_logic_vector(3 downto 0);
    begin
        aMux0 : mux_n
           generic map (n => 4)
           port map (
               sel => selA(0),
               src0 => outA1,
               src1 => src0,
               z => outA0);
        aMux1 : mux_n
           generic map (n => 4)
           port map (
               sel => selA(1),
               src0 => outA0,
               src1 => src1,
               z => outA1);
        bMux0 : mux_n
           generic map (n => 4)
           port map (
               sel => selB(0),
               src0 => outB1,
               src1 => src0,
               z => outB0);
        bMux1 : mux_n
           generic map (n => 4)
           port map (
               sel => selB(1),
               src0 => outB0,
               src1 => src1,
               z => outB1);
               
        rsltA <= outA0;
        rsltB <= outB0;
end structural;