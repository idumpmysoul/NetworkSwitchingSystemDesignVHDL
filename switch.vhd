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
    component switchport IS
    PORT (
        inout_bit   : in std_logic;
        port_id     : inout std_logic_vector(3 downto 0); --max 24 port
        frame       : inout STD_LOGIC_VECTOR(7 DOWNTO 0);
        MAC         : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    );
    end component switchport;

    component SwRAM is --simple ram to keep MAC-Add table
    port (
        main_clk    :   in  std_logic;
        main_rst    :   in  std_logic;
        r_bit       :   in  std_logic; --input port, so don't check
        mac_in      :   in  std_logic_vector(47 downto 0);
        port_out    :   out std_logic_vector(3 downto 0); --assuming a switch with 24 ethernet-port, so max bit is 2^5
        hit_flag    :   out std_logic_vector(1 downto 0) --if found '11', not found '10';
    );
    
    end component SwRAM;
    type portId_array is array (1 to 12) of std_logic_vector(3 downto 0);
    signal ports : portId_array;
    type frame_Array  is array (1 to 12) of std_logic_vector(7 downto 0);
    signal frames : frame_Array;
begin
    --instantiation
    fa01 : switchport portmap (
        inout_bit   : in std_logic;
        port_id     : inout std_logic_vector(3 downto 0); --max 24 port
        frame       : inout STD_LOGIC_VECTOR(7 DOWNTO 0);
        MAC         : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    );
    
    
end architecture rtl;