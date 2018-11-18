-- EECS 361 Single-Cycle Processor
-- by Alvin Tan

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

package alvinPackage is
    -- A single, 32-bit register
    component reg_32
        port (
            inWrite :  in std_logic_vector(31 downto 0);
            RegWr   :  in std_logic;
            Rst     :  in std_logic;
            clk     :  in std_logic;
            Q       : out std_logic_vector(31 downto 0)
        );
    end component reg_32;
    
    -- A 5 to 1 AND stack
    component reg_andStack is
	     port(
	         in0, in1, in2, in3, in4 :  in std_logic;
	         rslt                    : out std_logic
	     );
	 end component reg_andStack;
    
    -- Given a 5-bit input, returns a 32-bit 1-hot output
    component reg_addToBinary is
	     port (
	         addr   :  in std_logic_vector(4 downto 0);
	         binary : out std_logic_vector(31 downto 0)
	     );
	 end component reg_addToBinary;
    
    -- Used to test a mechanism I used in reg_comp
    component reg_muxTest is
        port (
            selA  : in std_logic_vector(1 downto 0);
            selB  : in std_logic_vector(1 downto 0);
            src0  : in std_logic_vector(3 downto 0);
            src1  : in std_logic_vector(3 downto 0);
            rsltA : out std_logic_vector(3 downto 0);
            rsltB : out std_logic_vector(3 downto 0)
        );
    end component reg_muxTest;
    
    -- The 32 32-bit register component
    component reg_comp is
	     port (
	         RegWr   :  in std_logic;
	         Rw      :  in std_logic_vector(4 downto 0);
	         Ra      :  in std_logic_vector(4 downto 0);
	         Rb      :  in std_logic_vector(4 downto 0);
	         busW    :  in std_logic_vector(31 downto 0);
	         clk     :  in std_logic;
	         busA    : out std_logic_vector(31 downto 0);
	         busB    : out std_logic_vector(31 downto 0);
	         reg7to0: out std_logic_vector(255 downto 0)
	     );
	 end component reg_comp;
	 
	 -- Sign-extends a 16-bit input to 32-bits
	 component extender_signed is
        port (
           src    :  in std_logic_vector(15 downto 0);
           rslt   : out std_logic_vector(31 downto 0)
        );
    end component extender_signed;
    
    -- 32-bit ALU
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
    
    -- This is the processor part with the registers, ALU,
    --  and data memory. Doesn't include instruction memory
    --  or calculation of flags or anything.
    component fatBoi is
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
            dOut        : out std_logic_vector(31 downto 0);
            MemWrAdd    : out std_logic_vector(31 downto 0);
            Rw          : out std_logic_vector(4 downto 0);
            Zero        : out std_logic;
            Carry       : out std_logic;
            Overflow    : out std_logic;
            Sign        : out std_logic;
            dMemFile    :     string
        );
    end component fatBoi;
    
    component ALU_Control is
	     port(
	         func   : in std_logic_vector(5 downto 0);
	         ALUop  : in std_logic_vector(1 downto 0);
	         ALUctr : out std_logic_vector(3 downto 0)
	     );
	 end component ALU_Control;
	 
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
    
    component sc_proc is
        port (
            clk         :  in std_logic;
            instMemFile :  string;
            dataMemFile :  string;
            pcReset     :  in std_logic;
            reg7to0     : out std_logic_vector(255 downto 0);
            instruction : out std_logic_vector(31 downto 0);
            MemWrAdd    : out std_logic_vector(31 downto 0);
            dOut        : out std_logic_vector(31 downto 0);
            Rw          : out std_logic_vector(4 downto 0);
            regWr       : out std_logic;
            memWr       : out std_logic
        );
    end component sc_proc;
end;