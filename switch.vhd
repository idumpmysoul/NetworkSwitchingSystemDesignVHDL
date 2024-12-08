library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity switch is --only 1 port receiver, 3 port sending
    
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        input_frame : in std_logic_vector(127 downto 0);  -- Assuming 128-bit frame
        mac_address : in std_logic_vector(47 downto 0);   -- Source MAC address
        port_num    : in integer range 0 to 3;           -- Port number (0 to 3)
        learn       : in std_logic;
        forward     : in std_logic;
        output_port : out integer range 0 to 3           -- Port to forward the frame
    );
end entity switch;

architecture rtl of switch is
    
begin
    
    
    
end architecture rtl;