library ieee;
use ieee.std_logic_1164.all;

entity and_6 is
  port (
    a   : in  std_logic;
    b   : in  std_logic;
    c   : in  std_logic;
    d   : in  std_logic;
    e   : in  std_logic;
    f   : in  std_logic;
    z   : out std_logic
  );
end and_6;

architecture dataflow of and_6 is
begin
  z <= a and b and c and d and e and f;
end dataflow;