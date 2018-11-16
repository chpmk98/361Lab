library ieee;
use ieee.std_logic_1164.all;

entity ALU_Control_testbench is
end ALU_Control_testbench;

architecture behavior of ALU_Control_testbench is 

component ALU_Control is
    port(
        func   : in std_logic_vector(5 downto 0);
        ALUop  : in std_logic_vector(1 downto 0);
        ALUctr : out std_logic_vector(3 downto 0)
    );
end component;

--Inputs
signal func_test       : std_logic_vector(5 downto 0) := "000000";
signal ALUop_test      : std_logic_vector(1 downto 0) := "00";


--Outputs
signal ALUctr_test   : std_logic_vector(3 downto 0);

begin

-- Instantiate the Unit Under Test (UUT)
uut: ALU_Control port map (func_test, ALUop_test, ALUctr_test);

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns; 

-- insert stimulus here
func_test <= "100000";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "100001";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "100010";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "100011";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "100100";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "100101";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "000000";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "101010";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "101011";
ALUop_test <= "10";
wait for 50 ns;

func_test <= "111000"; -- dont care
ALUop_test <= "00";
wait for 50 ns;

func_test <= "000111"; -- dont care
ALUop_test <= "01";
wait for 50 ns;


end process;

end;
