library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Receptor is
    Port (CLK,RST : in  std_logic;
          activate: in  std_logic;
          bit_in:   in  std_logic;
          msj:      out std_logic_vector(15 downto 0));
end Receptor;

architecture Structural of Receptor is
    component SP1Recep is
        Port (CLK,RST: in std_logic;
              bit_in, enable: in std_logic;
              end_SP1Recep: out std_logic;
              data_out: out std_logic_vector(255 downto 0));
    end component;
    
    component CHECKER is
        Port (CLK,RST: in std_logic;
             enable: in std_logic;
             data_in: in std_logic_vector(255 downto 0);
             end_signalCHECKER: out std_logic;
             data_out: out std_logic_vector(111 downto 0));
    end component;
    
    component PS1Recep is
        Port (CLK,RST: in std_logic;
              data_in: in std_logic_vector(111 downto 0);
              enable: in std_logic;
              end_signal_PS1Recep: out std_logic;
              bit_out: out std_logic);
    end component;
    
    component unbitstuffingFSM is
        port (CLK, RST:   in  std_logic;
          bit_in:     in  std_logic;
          enable:     in  std_logic;
          data_out:   out std_logic_vector(35 downto 0));   
    end component;
        
    component decodeSys is
        Port (data_in : in std_logic_vector(35 downto 0);
              data_out: out std_logic_vector(15 downto 0));
    end component;

    signal SP1_CHECKER: std_logic; -- acaba SP1 empieza CHECKER
    signal trama: std_logic_vector(255 downto 0);
    
    signal CHECKER_PS1: std_logic; --acaba CHECKER empieza PS1
    signal msj_pad: std_logic_vector(111 downto 0);
    
    signal PS1_FSM: std_logic; --acaba pa1 empieza unbitstuffingfsm;
    signal bit_out: std_logic; -- bit ue sale de ps1 y entra a fsm;
    
    signal encode_msj: std_logic_vector(35 downto 0); -- mesaje final pero codificado   
begin
    SP1R: SP1Recep port map(CLK=>CLK,RST=>RST,bit_in=>bit_in, enable=>activate, 
                            end_SP1Recep=>SP1_CHECKER, data_out=>trama);
    CHECK: CHECKER port map(CLK=>CLK,RST=>RST, enable=>SP1_CHECKER,data_in=>trama,
                            end_signalCHECKER=>CHECKER_PS1, data_out=>msj_pad);
    PS1R: PS1Recep port map(CLK=>CLK,RST=>RST, data_in=>msj_pad, enable=> CHECKER_PS1,
                            end_signal_PS1Recep=>PS1_FSM, bit_out=>bit_out);
    FSM: unbitstuffingFSM port map(CLK=>CLK,RST=>RST,bit_in=>bit_out, enable => PS1_FSM,
                                   data_out=>encode_msj);
    dec: decodeSys port map(data_in=>encode_msj, data_out=>msj);
    
end Structural;
