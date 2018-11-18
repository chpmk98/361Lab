library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity MainControl is
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
end entity MainControl;

architecture structural of MainControl is
signal iop: std_logic_vector(5 downto 0);
signal eq_sw: std_logic;
signal eq_lw: std_logic;
signal eq_addi: std_logic;
signal eq_beq: std_logic;
signal eq_bne: std_logic;
signal eq_bgtz: std_logic;

signal alu_src_temp: std_logic;
signal regwr_temp: std_logic;
signal regdst_temp: std_logic;
signal ALUop_i: std_logic;

component and_gate_6bit is
	port(
	a: in std_logic;
	b: in std_logic;
	c: in std_logic;
	d: in std_logic;
	e: in std_logic;
	f: in std_logic;
	z: out std_logic
	);
end component and_gate_6bit;

component or_gate_6bit is
	port(
	a: in std_logic;
	b: in std_logic;
	c: in std_logic;
	d: in std_logic;
	e: in std_logic;
	f: in std_logic;
	z: out std_logic
	);
end component or_gate_6bit;

begin
	invert_op: not_gate_n generic map(n => 6) port map(op,iop);

	andlayer1: and_gate_6bit port map(op(5),iop(4),op(3),iop(2),op(1),op(0),eq_sw); --sw 0x2B 101011
	andlayer2: and_gate_6bit port map(op(5),iop(4),iop(3),iop(2),op(1),op(0),eq_lw); --lw 0x23 100011
	andlayer3: and_gate_6bit port map(iop(5),iop(4),op(3),iop(2),iop(1),iop(0),eq_addi); --addi 0x08 001000
	andlayer4: and_gate_6bit port map(iop(5),iop(4),iop(3),op(2),iop(1),iop(0),eq_beq); --beq 0x04 000100
	andlayer5: and_gate_6bit port map(iop(5),iop(4),iop(3),op(2),iop(1),op(0),eq_bne); --bne 0x05 000101
	andlayer6: and_gate_6bit port map(iop(5),iop(4),iop(3),op(2),op(1),op(0),eq_bgtz); --bgtz 0x07 000111

	RegWr1: or_gate_6bit port map(eq_sw,eq_beq,eq_bne,eq_bgtz,'0','0',regwr_temp);
	RegWr2: not_gate port map(regwr_temp,RegWr);

	ExtOp <= '1';

   ALUSrc1: or_gate_6bit port map(eq_sw, eq_lw,eq_addi,'0','0','0',alu_src_temp);
	ALUSrc <= alu_src_temp;

	RegDst1: or_gate_6bit port map(eq_addi,eq_lw,eq_sw,'0','0','0',regdst_temp);
	RegDst2: not_gate port map(regdst_temp,RegDst);

	MemWr <= eq_sw;

	MemtoReg <= eq_lw;

	Branch1b: or_gate port map(eq_bne,eq_bgtz,Branch(1));
	Branch0b: or_gate port map(eq_beq,eq_bgtz,Branch(0));

	ALUop1b1: or_gate_6bit port map(eq_addi,eq_lw,eq_sw,eq_beq,eq_bne,eq_bgtz,ALUop_i);
	ALUop1b2: not_gate port map(ALUop_i,ALUop(1));
	ALUop0b: or_gate_6bit port map(eq_beq,eq_bne,eq_bgtz,'0','0','0',ALUop(0));
end architecture structural;