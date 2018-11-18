-- EECS 361 Single-Cycle Processor
-- by Alvin Tan

-- This is the main processor thing... 
-- Includes registers, extender, ALU, and data memory.
-- Does not include instruction memory, flag calculation (except Zero), or any other control paths.

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;

entity fatBoi is
    port (
        clk         :  in std_logic;
        ALUctr      :  in std_logic_vector(3 downto 0);
        Rs          :  in std_logic_vector(4 downto 0);
        Rt          :  in std_logic_vector(4 downto 0);
        Rd          :  in std_logic_vector(4 downto 0);
        Shamt       :  in std_logic_vector(4 downto 0);
        Imm16       :  in std_logic_vector(15 downto 0);
        RegDst      :  in std_logic;
        RegWr       :  in std_logic;
        ALUsrc      :  in std_logic;
        MemWr       :  in std_logic;
        MemtoReg    :  in std_logic;
        Reg7to0     : out std_logic_vector(255 downto 0);
        BussA       : out std_logic_vector(31 downto 0);
        BussB       : out std_logic_vector(31 downto 0);
        MemWrAdd    : out std_logic_vector(31 downto 0);
        dOut        : out std_logic_vector(31 downto 0);
        Rw          : out std_logic_vector(4 downto 0);
        Zero        : out std_logic;
        Carry       : out std_logic;
        Overflow    : out std_logic;
        Sign        : out std_logic;
        dMemFile    :     string
    );
end fatBoi;

architecture structural of fatBoi is
    signal destReg : std_logic_vector(4 downto 0);
    signal busA    : std_logic_vector(31 downto 0);
    signal busB    : std_logic_vector(31 downto 0);
    signal busW    : std_logic_vector(31 downto 0);
    signal extImm  : std_logic_vector(31 downto 0);
    signal ALUin   : std_logic_vector(31 downto 0);
    signal ALUout  : std_logic_vector(31 downto 0);
    signal dataOut : std_logic_vector(31 downto 0);
    
    begin
        -- Selects the register for Rw
        destRegMux : mux_n
           generic map (n => 5)
           port map (RegDst, Rt, Rd, destReg);
        
        -- Our 32 32-bit registers
        registers : reg_comp
           port map (RegWr, destReg, Rs, Rt, busW, clk, busA, busB, Reg7to0);
        
        -- Zero-extends the immediate to 32 bits
        extender : extender_signed
           port map (imm16, extImm);
        
        -- Selects the second input to the ALU
        aluMux : mux_32
           port map (ALUsrc, busB, extImm, ALUin);
        
        -- This is our ALU
        alu_comp : final_alu_32_v2
           port map (Shamt, busA, ALUin, ALUctr, ALUout, Zero, Carry, Overflow);
        
        -- This is our data memory
        -- Writes perpetually when MemWr is set
        dataMem : sram
           generic map (dMemFile)
           port map ('1', '1', MemWr, ALUout, busB, dataOut);
        
        -- Selects the signal to be written back to the registers
        mem2regMux : mux_32
           port map (MemtoReg, ALUout, dataOut, busW);
               
        Sign <= ALUout(31);
        Rw <= destReg;
        dOut <= dataOut;
        MemWrAdd <= ALUout;
        BussA <= busA;
        BussB <= busB;
end structural;
        
        
               












