-------- Written by Rabin Zhao EECS361--------
library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
use work.CtrlUnitsPackage.all;

entity WBUnit is
    port(
        --------Inputs--------
        Din : in std_logic_vector (31 downto 0);
        ALUin : in std_logic_vector (31 downto 0);
        RegWR : in std_logic;
        MemtoReg : in std_logic;
        
        
        --------Outputs--------
        RegWR_out : out std_logic;
        Dout : out std_logic_vector (31 downto 0)
        );
end entity WBUnit;

architecture structural of WBUnit is
    
    begin
        RegWR_out <= RegWR;
        
        themux : mux_32 port map (sel => MemtoReg,
        src0 => Din,
        src1 => ALUin,
        z => Dout);
        
    end architecture structural;
