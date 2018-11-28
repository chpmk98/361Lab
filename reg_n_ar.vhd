library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity reg_n_ar is
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
end reg_32_ar;

architecture structural of reg_n_ar is
   signal curQ : std_logic_vector(n-1 downto 0);
   begin
       dFFs   : for i in 0 to n-1 generate
          dFF : dffr_a
             port map (clk => clk,
              arst => Rst,
               aload => arst, 
               adata => aload(i),
                d =>inWrite(i),
                 enable => RegWr,
                  q => curQ(i)); --RegRead, curQ(i), inWrite(i), RegWr, curQ(i));
       end generate dFFs;
       
       Q <= curQ;
end structural;