library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity SwRAM is --simple rom to check MAC-Add table
    port (
        port_in     :   in  std_logic_vector(4 downto 0); --input port, so don't check
        mac_in      :   in  std_logic_vector(47 downto 0);
        rw_flag     :   in  std_logic; --read 0, write 1
        port_out    :   out std_logic_vector(4 downto 0); --assuming a switch with 24 ethernet-port, so max bit is 2^5
        hit_flag    :   out std_logic; --if found '1'
    );
end entity SwRAM;

architecture rtl of SwRAM is
    type State_Type is (LOAD, IDLE, READ, WRITE, COMPLETE)
    type RAM_Arr is array (0 to 24) of std_logic_vector(47 downto 0);
    signal RAM : RAM_Arr := (
        0 => "00000000"; --ram(0) wouldn't be touched
        1 => "00000000";
        2 => "00000000";
        3 => "00000000";
        4 => "00000000";
        5 => "00000000";
        6 => "00000000";
        7 => "00000000";
        8 => "00000000";
        9 => "00000000";
        10 => "00000000";
        11 => "00000000";
        12 => "00000000";
        13 => "00000000";
        14 => "00000000";
        15 => "00000000";
        16 => "00000000";
        17 => "00000000";
        18 => "00000000";
        19 => "00000000";
        20 => "00000000";
        21 => "00000000";
        22 => "00000000";
        23 => "00000000";
        24 => "00000000";
    )
begin
    process (port_in, mac_in)
    begin
        
    
    
end architecture rtl;