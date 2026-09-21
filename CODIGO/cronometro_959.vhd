library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometro_959 is
    port (
        relojBase     : in  std_logic;
        botonReinicio : in  std_logic;
        botonArranque : in  std_logic;
        botonParada   : in  std_logic;
        unidadesSec   : out std_logic_vector(3 downto 0);
        decenasSec    : out std_logic_vector(3 downto 0);
        unidadesMin   : out std_logic_vector(3 downto 0)
    );
end entity;

architecture logica of cronometro_959 is
    signal cuentaUniSec : unsigned(3 downto 0);
    signal cuentaDecSec : unsigned(3 downto 0);
    signal cuentaMin    : unsigned(3 downto 0);
    signal estadoActivo : std_logic;
begin
    process (relojBase, botonReinicio, botonArranque, botonParada)
    begin
        if botonReinicio = '1' then
            cuentaUniSec <= (others => '0');
            cuentaDecSec <= (others => '0');
            cuentaMin    <= (others => '0');
            estadoActivo <= '0';
				
        elsif botonArranque = '1' then
            estadoActivo <= '1'; 
            
        elsif botonParada = '1' then
            estadoActivo <= '0';   
				
				
        elsif relojBase'event and relojBase = '1' then
               
            -- Lógica de conteo del reloj
            if estadoActivo = '1' then
                -- Si llega a 9:59, se detiene automáticamente
                if cuentaMin = 9 and cuentaDecSec = 5 and cuentaUniSec = 9 then
                    estadoActivo <= '0';
                else
                    if cuentaUniSec = 9 then
                        cuentaUniSec <= (others => '0');
                        
                        if cuentaDecSec = 5 then
                            cuentaDecSec <= (others => '0');
                            cuentaMin <= cuentaMin + 1;
                        else
                            cuentaDecSec <= cuentaDecSec + 1;
                        end if;
                        
                    else
                        cuentaUniSec <= cuentaUniSec + 1;
                    end if;
                end if;
            end if;
            
        end if;
    end process;
    
    unidadesSec <= std_logic_vector(cuentaUniSec);
    decenasSec  <= std_logic_vector(cuentaDecSec);
    unidadesMin <= std_logic_vector(cuentaMin);
end architecture;