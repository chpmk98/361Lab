library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity ALU_Control is
    port(
        func   : in std_logic_vector(5 downto 0);
        ALUop  : in std_logic_vector(1 downto 0);
        ALUctr : out std_logic_vector(3 downto 0)
    );
end ALU_Control;

architecture structural of ALU_Control is

component and_6 is   --6 gate and
  port (
    a   : in  std_logic;
    b   : in  std_logic;
    c   : in  std_logic;
    d   : in  std_logic;
    e   : in  std_logic;
    f   : in  std_logic;
    z   : out std_logic
  );
end component;

component or_3 is   --3 gate or
  port (
    a   : in  std_logic;
    b   : in  std_logic;
    c   : in  std_logic;
    z   : out std_logic
  );
end component;

component mux_4 is   --4 bit mux
  port (
	sel	  : in	std_logic;
	src0  :	in	std_logic_vector(3 downto 0);
	src1  :	in	std_logic_vector(3 downto 0);
	z	  : out std_logic_vector(3 downto 0)
  );
end component;

signal sel3, sel2, sel1, sel0 : std_logic;      -- selection bit for mux when caculating ALUctr for R-type

signal ortemp1, ortemp2, ortemp3 :std_logic;      -- possible combinations of func code for selection bit

signal funcout, ALUopout, output : std_logic_vector(3 downto 0);      -- Possible ALUctr outputs

signal notfunc : std_logic_vector(5 downto 0);      -- Inverted inputs
signal notALUop : std_logic_vector(1 downto 0);

begin

    notf5: not_gate port map(func(5), notfunc(5));      --Invert inputs
    notf4: not_gate port map(func(4), notfunc(4));
    notf3: not_gate port map(func(3), notfunc(3));
    notf2: not_gate port map(func(2), notfunc(2));
    notf1: not_gate port map(func(1), notfunc(1));
    notf0: not_gate port map(func(0), notfunc(0));
    noto1: not_gate port map(ALUop(1), notALUop(1));
    noto0: not_gate port map(ALUop(0), notALUop(0));
    
    select3: and_6 port map(notfunc(5), notfunc(4), notfunc(3), notfunc(2), notfunc(1), notfunc(0), sel3);   -- func = "000000"
    mux3: mux port map(sel3,'0', '1', funcout(3));   -- ways to select '1' for 3rd digit of ALUctr
    
    select21: and_6 port map(func(5), notfunc(4), notfunc(3), func(2), notfunc(1), func(0), ortemp1);   -- func = "100101"
    select22: and_6 port map(func(5), notfunc(4), func(3), notfunc(2), func(1), notfunc(0), ortemp2);   -- func = "101010"
    select23: and_6 port map(func(5), notfunc(4), func(3), notfunc(2), func(1), func(0), ortemp3);   -- func = "101011"
    select2: or_3 port map (ortemp1, ortemp2, ortemp3, sel2);
    mux2: mux port map(sel2,'0', '1', funcout(2));   -- ways to select '1' for 2nd digit of ALUctr
    
    select11: and_6 port map(func(5), notfunc(4), notfunc(3), func(2), notfunc(1), notfunc(0), ortemp1);   -- func = "100100"
    select12: and_6 port map(func(5), notfunc(4), func(3), notfunc(2), func(1), notfunc(0), ortemp2);   -- func = "101010"
    select13: and_6 port map(func(5), notfunc(4), func(3), notfunc(2), func(1), func(0), ortemp3);   -- func = "101011"
    select1: or_3 port map (ortemp1, ortemp2, ortemp3, sel1);
    mux1: mux port map(sel1,'0', '1', funcout(1));   -- ways to select '1' for 1st digit of ALUctr
    
    select01: and_6 port map(func(5), notfunc(4), notfunc(3), notfunc(2), func(1), notfunc(0), ortemp1);   -- func = "100010"
    select02: and_6 port map(func(5), notfunc(4), notfunc(3), notfunc(2), func(1), func(0), ortemp2);   -- func = "100011"
    select03: and_6 port map(func(5), notfunc(4), func(3), notfunc(2), func(1), func(0), ortemp3);   -- func = "101011"
    select0: or_3 port map (ortemp1, ortemp2, ortemp3, sel0);
    mux0: mux port map(sel0,'0', '1', funcout(0));   -- ways to select '1' for 0th digit of ALUctr
    
    
    muxop: mux_4 port map(ALUop(0), "0000", "0001", ALUopout);      -- ALUctr if not R-type (depends on ALUop)
    selecttype : mux_4 port map(ALUop(1), ALUopout, funcout, output);      -- select ALUctr
    
    ALUctr <= output;
    
end structural;
