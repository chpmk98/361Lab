library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.alvinPackage.all;
--This component detects and stalls for RAW Hazard
entity HazardUnit is
    port(
        IDEX_MemRead: in std_logic;
        IDEX_Rt: in std_logic_vector(4 downto 0);
        IFID_Rs: in std_logic_vector(4 downto 0);
        IFID_Rt: in std_logic_vector(4 downto 0);
        PCWrite: out std_logic;
        IFIDWrite: out std_logic;
        LoadHazard: out std_logic
    );
end entity HazardUnit;

architecture structural of HazardUnit is
    signal regCollision1: std_logic;
    signal regCollision2: std_logic;
    signal tmp: std_logic;
    signal notPCWrite: std_logic;
    
    component regCompare is
	     port(
	         Ra: in std_logic_vector(4 downto 0);
	         Rb: in std_logic_vector(4 downto 0);
	         eq: out std_logic
	     );
	 end component regCompare;
    begin
        test1: regCompare port map(IDEX_Rt,IFID_Rs, regCollision1);
        test2: regCompare port map(IDEX_Rt,IFID_Rt, regCollision2);
        Ortest: or_gate port map(regCollision1,regCollision2, tmp);
        
        --if notPCWrite evaluates to true, we need to stall the pipeline
        stallgate: and_gate port map(tmp,IDEX_MemRead,notPCWrite);
        stallgate2: not_gate port map(notPCWrite,PCWrite);
        --stalling means PCWrite and IFIDWrite get set to 0 if notPCWrite gets set to true
        IFIDWriteSignal: not_gate port map(notPCWrite,IFIDWrite);
        
        LoadHazard <= notPCWrite;
        
end architecture structural;