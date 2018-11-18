-- EECS 361 Single-Cycle Processor
-- by Alvin Tan

-- This component contains 32 32-bit registers, which we can read from and write to.
-- Inputs: RegWr, Rw (5-bits), Ra (5-bits), Rb (5-bits), busW (32-bits), clk
-- Outputs: busA (32-bits), busB(32-bits)

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;

entity reg_comp is
    port (
        RegWr   :  in std_logic;
        Rw      :  in std_logic_vector(4 downto 0);
        Ra      :  in std_logic_vector(4 downto 0);
        Rb      :  in std_logic_vector(4 downto 0);
        busW    :  in std_logic_vector(31 downto 0);
        clk     :  in std_logic;
        busA    : out std_logic_vector(31 downto 0);
        busB    : out std_logic_vector(31 downto 0);
        reg7to0 : out std_logic_vector(255 downto 0)
    );
end reg_comp;

architecture structural of reg_comp is
    signal RegWrBinary : std_logic_vector(31 downto 0);
    signal RegWrBinaryActual : std_logic_vector(31 downto 0);
    signal RegABinary : std_logic_vector(31 downto 0);
    signal RegBBinary : std_logic_vector(31 downto 0);
    signal RegOuts : std_logic_vector(1023 downto 0);
    signal MuxAOuts : std_logic_vector(1023 downto 0);
    signal MuxBOuts : std_logic_vector(1023 downto 0);
    begin
        regWrToBin : reg_addToBinary
        port map (Rw, RegWrBinary);
            
        regAToBin : reg_addToBinary
        port map (Ra, RegABinary);
            
        regBToBin : reg_addToBinary
        port map (Rb, RegBBinary);
        
        andMaps : for i in 0 to 31 generate
           andMap : and_gate
           port map (RegWr, RegWrBinary(i), RegWrBinaryActual(i));
        end generate andMaps;
        
        -- These are the registers. In this implementation, we assume we never
        --  RESET the registers, but adding that should be relatively easy.
        -- Note that since Register 0 is hardwired to 0, we don't actually need to instantiate it.
        --  We can simply set the first 31 bits of RegOuts to 0.
        RegOuts(31 downto 0) <= "00000000000000000000000000000000";
        regs : for i in 1 to 31 generate
           regMap : reg_32
           port map (busW, RegWrBinaryActual(i), '0', clk, RegOuts((32*i + 31) downto (32*i)));
        end generate regs;
        
        -- These are the MUXs to select the output for busA
        busAMux0 : mux_32
        port map (
           RegABinary(0),
           MuxAOuts(1023 downto 992),
           RegOuts(31 downto 0),
           MuxAOuts(31 downto 0)
        );
        
        busAMuxs : for i in 1 to 31 generate
           busAMux : mux_32
           port map (
              RegABinary(i),
              MuxAOuts((32*(i-1) + 31) downto (32*(i-1))),
              RegOuts((32*i + 31) downto (32*i)),
              MuxAOuts((32*i + 31) downto (32*i))
           );
        end generate busAMuxs;

        -- These are the MUXs to select the output for busB
        busBMux0 : mux_32
        port map (
           RegBBinary(0),
           MuxBOuts(1023 downto 992),
           RegOuts(31 downto 0),
           MuxBOuts(31 downto 0)
        );
        
        busBMuxs : for i in 1 to 31 generate
           busBMux : mux_32
           port map (
              RegBBinary(i),
              MuxBOuts((32*(i-1) + 31) downto (32*(i-1))),
              RegOuts((32*i + 31) downto (32*i)),
              MuxBOuts((32*i + 31) downto (32*i))
           );
        end generate busBMuxs;

        busA <= MuxAOuts(31 downto 0);
        busB <= MuxBOuts(31 downto 0);
        reg7to0 <= RegOuts(255 downto 0);
end structural;



















