library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sistema_top is
    port (
        reloj50Mhz    : in  std_logic;
        botonReinicio : in  std_logic;
        botonArranque : in  std_logic;
        botonParada   : in  std_logic;
        
        dispMinutos   : out std_logic_vector(6 downto 0);
        dispDecenas   : out std_logic_vector(6 downto 0);
        dispUnidades  : out std_logic_vector(6 downto 0)
    );
end entity;

architecture estructural of sistema_top is
    
    component divisor_1hz is
        port (reloj50Mhz, reset1 : in std_logic; reloj1hz : out std_logic);
    end component;

    component cronometro_959 is
        port (
            relojBase     : in  std_logic;
            botonReinicio : in  std_logic;
            botonArranque : in  std_logic;
            botonParada   : in  std_logic;
            unidadesSec   : out std_logic_vector(3 downto 0);
            decenasSec    : out std_logic_vector(3 downto 0);
            unidadesMin   : out std_logic_vector(3 downto 0)
        );
    end component;

    component decodificador_7seg is
        port (
            entradaBCD : in std_logic_vector(3 downto 0);
            salida7seg : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Cables de interconexión interna
    signal cableReloj1hz : std_logic;
    signal cableUniSec   : std_logic_vector(3 downto 0);
    signal cableDecSec   : std_logic_vector(3 downto 0);
    signal cableMin      : std_logic_vector(3 downto 0);

begin
    
    U1: divisor_1hz port map (
        reloj50Mhz => reloj50Mhz,
        reset1     => botonReinicio,
        reloj1hz   => cableReloj1hz
    );

    U2: cronometro_959 port map (
        relojBase     => cableReloj1hz,
        botonReinicio => botonReinicio,
        botonArranque => botonArranque,
        botonParada   => botonParada,
        unidadesSec   => cableUniSec,
        decenasSec    => cableDecSec,
        unidadesMin   => cableMin
    );

    U3_Minutos: decodificador_7seg port map (
        entradaBCD => cableMin, 
        salida7seg => dispMinutos
    );
    
    U4_Decenas: decodificador_7seg port map (
        entradaBCD => cableDecSec, 
        salida7seg => dispDecenas
    );
    
    U5_Unidades: decodificador_7seg port map (
        entradaBCD => cableUniSec, 
        salida7seg => dispUnidades
    );

end architecture;