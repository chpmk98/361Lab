library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

package CtrlUnitsPackage is
    
    component MainControl is
        port(
            op: in std_logic_vector(5 downto 0);
            ALUop: out std_logic_vector(1 downto 0);
            ALUSrc: out std_logic;
            RegWr: out std_logic;
            RegDst: out std_logic;
            ExtOp: out std_logic;
            MemWr: out std_logic;
            MemtoReg: out std_logic;
            Branch: out std_logic_vector(1 downto 0)
    );
    end component MainControl;
    
    component ALU_Control is
    port(
        func   : in std_logic_vector(5 downto 0);
        ALUop  : in std_logic_vector(1 downto 0);
        ALUctr : out std_logic_vector(3 downto 0)
    );
    end component ALU_Control;

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