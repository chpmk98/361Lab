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
        clk : in std_logic;
        Din : in std_logic_vector (31 downto 0);
        ALUin : in std_logic_vector (31 downto 0);
        RwIn  : in std_logic_vector (4 downto 0);
        RegWR : in std_logic;
        MemtoReg : in std_logic;
        
        
        --------Outputs--------
        RegWR_out : out std_logic;
        Dout : out std_logic_vector (31 downto 0);
        Rw   : out std_logic_vector(4 downto 0)
        );
end entity WBUnit;

architecture structural of WBUnit is
    signal inputString, MWR : std_logic_vector(70 downto 0);
    
    begin
        inputString <= Din & ALUin & RwIn & RegWR & MemtoReg;
        
        MemWbReg   : reg_n_ar
           generic map (n => 71)
           port map (inputString, '1', '0', '0', MWR, clk, MWR);
        
        RegWR_out <= MWR(1); -- RegWR
        Rw <= MWR(6 downto 2); -- RwIn
        
        themux : mux_32 port map (sel => MWR(0), --MemtoReg,
        src0 => MWR(70 downto 39), --Din,
        src1 => MWR(38 downto 7), --ALUin,
        z => Dout);
        
    end architecture structural;
