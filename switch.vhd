library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity switch is --only 1 port receiver, 3 port sending
    port (
        clk             : in std_logic;
        reset           : in std_logic;
        input_frame     : inout std_logic_vector(127 downto 0);  -- Assuming 128-bit frame
        output_port     : out std_logic_vector(7 downto 0);
        output_payload  : out std_logic_vector(7 downto 0);
        fa01_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa02_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa03_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa04_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa05_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa06_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa07_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa08_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa09_MAC        : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa010_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa011_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa012_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    );
end entity switch;

architecture rtl of switch is
    component switchport IS
    PORT (
        inout_bit   : in std_logic;
        port_id     : inout std_logic_vector(3 downto 0); --max 24 port
        frame       : inout STD_LOGIC_VECTOR(7 DOWNTO 0);
        MAC_Add     : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
    );
    end component switchport;

    component SwRAM is --simple ram to keep MAC-Add table
    port (
        main_clk    :   in  std_logic;
        main_rst    :   in  std_logic;
        r_bit       :   in  std_logic;
        w_bit       :   in  std_logic;
        mac_in      :   in  std_logic_vector(47 downto 0);
        port_out    :   out std_logic_vector(3 downto 0); --assuming a switch with 24 ethernet-port, so max bit is 2^5
        hit_flag    :   out std_logic_vector(1 downto 0) --if found '11', not found '10';
    );
    end component SwRAM;

    type inoutBit_array is array (1 to 12) of std_logic_vector (1 downto 0); --indicator for port receiving = "10", sending = "11", idle = "01", off = "00";
    signal inoutBits : inoutBit_array;
    type portId_array is array (1 to 12) of std_logic_vector(3 downto 0);
    signal ports : portId_array(
        1 <= "0001";
        2 <= "0010";
        3 <= "0011";
        4 <= "0100";
        5 <= "0101";
        6 <= "0110";
        7 <= "0111";
        8 <= "1000";
        9 <= "1001";
        10 <= "1010";
        11 <= "1011";
        12 <= "1100";
    );

    type frame_array  is array (1 to 12) of std_logic_vector(7 downto 0);
    signal frames   : frame_array;
    signal r_bit    : std_logic;
    signal w_bit    : std_logic;
    signal hit_flag : std_logic_vector(1 downto 0);

begin
    SwRAM1 : SwRAM portmap (
        main_clk => clk;
        main_rst => rst;
        r_bit    => r_bit;
        w_bit    => w_bit;
        mac_in   => port_out;
        hit_flag => hit_flag;
    );

    --instantiation
    fa01 : switchport portmap (
        inout_bit   => inoutBits(1);
        port_id     => ports(1);
        frame       => frames(1);
        MAC_Add     => fa01_MAC;
    );

    fa02 : switchport portmap (
        inout_bit   => inoutBits(2);
        port_id     => ports(2);
        frame       => frames(2);
        MAC_Add     => fa02_MAC;
    );

    fa03 : switchport portmap (
        inout_bit   => inoutBits(3);
        port_id     => ports(3);
        frame       => frames(3);
        MAC_Add     => fa03_MAC;
    );

    fa04 : switchport portmap (
        inout_bit   => inoutBits(4);
        port_id     => ports(4);
        frame       => frames(4);
        MAC_Add     => fa04_MAC;
    );

    fa05 : switchport portmap (
        inout_bit   => inoutBits(5);
        port_id     => ports(5);
        frame       => frames(5);
        MAC_Add     => fa05_MAC;
    );

    fa06 : switchport portmap (
        inout_bit   => inoutBits(6);
        port_id     => ports(6);
        frame       => frames(6);
        MAC_Add     => fa06_MAC;
    );
    
    fa07 : switchport portmap (
        inout_bit   => inoutBits(7);
        port_id     => ports(7);
        frame       => frames(7);
        MAC_Add     => fa07_MAC;
    );

    fa08 : switchport portmap (
        inout_bit   => inoutBits(8);
        port_id     => ports(8);
        frame       => frames(8);
        MAC_Add     => fa08_MAC;
    );

    fa09 : switchport portmap (
        inout_bit   => inoutBits(9);
        port_id     => ports(9);
        frame       => frames(9);
        MAC_Add     => fa09_MAC;
    );

    fa10 : switchport portmap (
        inout_bit   => inoutBits(10);
        port_id     => ports(10);
        frame       => frames(10);
        MAC_Add     => fa10_MAC;
    );

    fa11 : switchport portmap (
        inout_bit   => inoutBits(1);
        port_id     => ports(11);
        frame       => frames(11);
        MAC_Add     => fa011_MAC;
    );

    fa12 : switchport portmap (
        inout_bit   => inoutBits(12);
        port_id     => ports(12);
        frame       => frames(12);
        MAC_Add     => fa012_MAC;
    );


    
end architecture rtl;