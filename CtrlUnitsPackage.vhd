library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

package CtrlUnitsPackage is

    component reg_n_ar is
    generic (
        n : integer
    );
    port (
        inWrite :  in std_logic_vector(n-1 downto 0);
        RegWr   :  in std_logic;
        Rst     :  in std_logic;
        arst    :  in std_logic;
        aload   :  in std_logic_vector(n-1 downto 0);
        clk     :  in std_logic;
        Q       : out std_logic_vector(n-1 downto 0)
    );
    end component reg_n_ar;
end;