library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

package ALUPackage is
    component final_alu_32_v2 is
	    port(
	    shamt : in std_logic_vector(4 downto 0);
	    a	: in std_logic_vector(31 downto 0);
	    b	: in std_logic_vector(31 downto 0);
	    ctrl: in std_logic_vector(3 downto 0);
	    s 	: out std_logic_vector(31 downto 0);
	    z   : out std_logic;
	    cout: out std_logic;
	    ovflow: out std_logic
	    );
	end component final_alu_32_v2;
end;