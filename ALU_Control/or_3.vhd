library ieee;
use ieee.std_logic_1164.all;

entity or_3 is
  port (
    a   : in  std_logic;
    b   : in  std_logic;
    c   : in  std_logic;
    z   : out std_logic
  );
end or_3;

architecture dataflow of or_3 is
begin
  z <= a or b or c;
end dataflow;