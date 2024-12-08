library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

ENTITY switchport IS
    PORT (
        inout_bit   : in std_logic;
        port_id     : inout std_logic_vector(3 downto 0); --max 24 port
        frame       : inout STD_LOGIC_VECTOR(7 DOWNTO 0);
        MAC         : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    );
END ENTITY switchport;

ARCHITECTURE rtl OF switchport IS
    CONSTANT total_port : INTEGER := 12;
    signal frame
BEGIN
    process (inout_bit)

    begin
        fa012_MAC <= fa0(11);
    end process;
END ARCHITECTURE rtl;