library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometro_959 is
    port (
        relojBase     : in  std_logic;
        botonReinicio : in  std_logic;
        botonArranque : in  std_logic;
        botonParada   : in  std_logic;
        unidadesSec   : out std_logic_vector(6 downto 0);
        decenasSec    : out std_logic_vector(6 downto 0);
        unidadesMin   : out std_logic_vector(6 downto 0)
    );
end entity;

architecture logica of cronometro_959 is
    signal cuentaUniSec : unsigned(3 downto 0);
    signal cuentaDecSec : unsigned(3 downto 0);
    signal cuentaMin    : unsigned(3 downto 0);
    signal estadoActivo : std_logic;
begin
    process (relojBase, botonReinicio)
    begin
        if botonReinicio = '0' then
            cuentaUniSec <= (others => '0');
            cuentaDecSec <= (others => '0');
            cuentaMin    <= (others => '0');
            estadoActivo <= '0';
				
				
        elsif relojBase'event and relojBase = '1' then
            if botonArranque = '0' then
                estadoActivo <= '1';
            elsif botonParada = '0' then
                estadoActivo <= '0';
            end if;  
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
	 process(cuentaUniSec)
    begin
        case std_logic_vector(cuentaUniSec) is
            when "0000" => unidadesSec <= "1000000"; -- Muestra 0[cite: 2]
            when "0001" => unidadesSec <= "1111001"; -- Muestra 1[cite: 2]
            when "0010" => unidadesSec <= "0100100"; -- Muestra 2[cite: 2]
            when "0011" => unidadesSec <= "0110000"; -- Muestra 3[cite: 2]
            when "0100" => unidadesSec <= "0011001"; -- Muestra 4[cite: 2]
            when "0101" => unidadesSec <= "0010010"; -- Muestra 5[cite: 2]
            when "0110" => unidadesSec <= "0000010"; -- Muestra 6[cite: 2]
            when "0111" => unidadesSec <= "1111000"; -- Muestra 7[cite: 2]
            when "1000" => unidadesSec <= "0000000"; -- Muestra 8[cite: 2]
            when "1001" => unidadesSec <= "0010000"; -- Muestra 9[cite: 2]
            when others => unidadesSec <= "1111111"; -- Apagado total[cite: 2, 6]
        end case;
    end process;

    -- Decodificador interno para Decenas de Segundo
    process(cuentaDecSec)
    begin
        case std_logic_vector(cuentaDecSec) is
            when "0000" => decenasSec <= "1000000"; 
            when "0001" => decenasSec <= "1111001"; 
            when "0010" => decenasSec <= "0100100"; 
            when "0011" => decenasSec <= "0110000"; 
            when "0100" => decenasSec <= "0011001"; 
            when "0101" => decenasSec <= "0010010"; 
            when others => decenasSec <= "1111111"; 
        end case;
    end process;

    -- Decodificador interno para Unidades de Minuto
    process(cuentaMin)
    begin
        case std_logic_vector(cuentaMin) is
            when "0000" => unidadesMin <= "1000000"; 
            when "0001" => unidadesMin <= "1111001"; 
            when "0010" => unidadesMin <= "0100100"; 
            when "0011" => unidadesMin <= "0110000"; 
            when "0100" => unidadesMin <= "0011001"; 
            when "0101" => unidadesMin <= "0010010"; 
            when "0110" => unidadesMin <= "0000010"; 
            when "0111" => unidadesMin <= "1111000"; 
            when "1000" => unidadesMin <= "0000000"; 
            when "1001" => unidadesMin <= "0010000"; 
            when others => unidadesMin <= "1111111"; 
        end case;
    end process;
end architecture;