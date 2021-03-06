library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PS2Emisor is
    port(CLK, RST: in std_logic; 
         enable : in std_logic;    
         Q : in std_logic_vector(255 downto 0);
         end_signal: out std_logic;
         bit_out: out std_logic);
end PS2Emisor;

architecture Behavioral of PS2Emisor is
    signal content: std_logic_vector(255 downto 0) := (others=>'0');
    signal counter: integer := 0;
    signal enab: std_logic;
    signal trampita: integer:=0;
    
begin
    process(CLK, Q) begin
        if(rising_edge(CLK)) then
            if (RST = '1') then
                --content <= (others => '0');
            else
                if(enable='1') then
                    if(trampita=1)then
                        if (enable = '1' and counter < 256) then
                            enab <= '1';
                            content <= Q;
                            end_signal <= '1';
                        end if;
                        if(enab = '1')then
                            content <= content(254 downto 0) & '0';
                            counter <= counter + 1;
                        end if;
                        if(counter = 256)then
                            
                        end if;
                    end if;
                    if(trampita=0)then
                        trampita <= trampita +1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    bit_out <= content(255);
end Behavioral;
