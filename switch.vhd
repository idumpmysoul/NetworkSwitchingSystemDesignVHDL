LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY switch IS --only 1 port receiver, 3 port sending
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        input_frame : INOUT STD_LOGIC_VECTOR(127 DOWNTO 0); -- Assuming 128-bit frame
        src_port    : out STD_LOGIC_VECTOR(7 DOWNTO 0);
        src_mac     : out STD_LOGIC_VECTOR(47 DOWNTO 0);
        output_port : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        output_mac  : out STD_LOGIC_VECTOR(47 DOWNTO 0);
        output_payload : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa01_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa01_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --indicator for port receiving = "10", sending = "11", idle = "01", off = "00";
        fa01_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa02_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa02_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa02_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa03_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa03_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa03_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa04_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa04_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa04_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa05_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa05_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa05_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa06_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa06_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa06_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa07_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa07_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa07_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa08_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa08_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa08_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa09_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa09_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa09_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa010_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa010_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa010_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa011_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa011_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa011_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa012_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa012_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa012_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    );
END ENTITY switch;

ARCHITECTURE rtl OF switch IS
    COMPONENT switchport IS
        PORT (
            inout_bit : IN STD_LOGIC;
            port_id : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0); --max 24 port
            frame   : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            MAC_Add : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        );
    END COMPONENT switchport;

    COMPONENT SwCAM IS --simple ram to keep MAC-Add table
        PORT (
            main_clk : IN STD_LOGIC;
            main_rst : IN STD_LOGIC;
            r_bit : IN STD_LOGIC;
            w_bit : IN STD_LOGIC;
            mac_in : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            port_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --assuming a switch with 24 ethernet-port, so max bit is 2^5
            hit_flag : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) --if found '11', not found '10';
        );
    END COMPONENT SwCAM;

    component frame_decoder IS -- frame decoder
        PORT (
            frame_in : IN STD_LOGIC_VECTOR(167 DOWNTO 0); -- Assuming 168-bit frame
            dest_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            src_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            payload_byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END component frame_decoder;

    TYPE frame_array IS ARRAY (1 TO 12) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL frames : frame_array;
    SIGNAL r_bit : STD_LOGIC;
    SIGNAL w_bit : STD_LOGIC;
    SIGNAL hit_flag : STD_LOGIC_VECTOR(1 DOWNTO 0);
    type State_Type is (LOAD, READ, HOLD, FORWARD, DONE);
    signal state  : State_Type := LOAD;
    signal mac_in : STD_LOGIC_VECTOR(47 DOWNTO 0);
    signal src_mac
BEGIN
    SwCAM1 : SwCAM portmap (
        main_clk => clk,
        main_rst => reset,
        r_bit => r_bit,
        w_bit => w_bit,
        mac_in => mac_in,
        port_out => port_out;
        hit_flag => hit_flag
    );

    FrameDecoder : frame_decoder portmap (
        frame_in => input_frame;
        dest_mac => output_mac;
        src_mac  => src_mac;
        payload_byte => output_payload;
    );

    --instantiation
    fa01 : switchport portmap (
        inout_bit => fa01_inoutBits,
        port_id => "0001",
        frame => fa01_data,
        MAC_Add => fa01_MAC
    );

    fa02 : switchport portmap (
        inout_bit => fa02_inoutBits,
        port_id => "0010",
        frame => fa02_data;,
        MAC_Add => fa02_MAC
    );

    fa03 : switchport portmap (
        inout_bit => fa03_inoutBits,
        port_id => "0011",
        frame => fa03_data,
        MAC_Add => fa03_MAC
    );

    fa04 : switchport portmap (
        inout_bit => fa04_inoutBits,
        port_id => "0100",
        frame => fa04_data,
        MAC_Add => fa04_MAC
    );

    fa05 : switchport portmap (
        inout_bit => fa05_inoutBits,
        port_id => "0101",
        frame => fa05_data,
        MAC_Add => fa05_MAC
    );

    fa06 : switchport portmap (
        inout_bit => fa06_inoutBits,
        port_id => '"0110",
        frame => fa06_data,
        MAC_Add => fa06_MAC
    );

    fa07 : switchport portmap (
        inout_bit => fa07_inoutBits,
        port_id => "0111",
        frame => fa07_data,
        MAC_Add => fa07_MAC
    );

    fa08 : switchport portmap (
        inout_bit => fa08_inoutBits,
        port_id => "1000",
        frame => fa08_data,
        MAC_Add => fa08_MAC
    );

    fa09 : switchport portmap (
        inout_bit => fa09_inoutBits,
        port_id => "1001",
        frame => fa09_data,
        MAC_Add => fa09_MAC,
    );

    fa10 : switchport portmap (
        inout_bit => fa010_inoutBits,
        port_id => "1010",
        frame => fa010_data,
        MAC_Add => fa10_MAC
    );

    fa11 : switchport portmap (
        inout_bit => fa011_inoutBits,
        port_id => "1011",
        frame => fa011_data,
        MAC_Add => fa011_MAC
    );

    fa12 : switchport portmap (
        inout_bit => fa012_inoutBits,
        port_id => "1100",
        frame => fa012_data,
        MAC_Add => fa012_MAC
    );

    process (clk, reset, input_frame)
        signal k : integer := 2;
    begin
        if reset = '1' then
            input_frame <= (others=>'0');
            src_port    <= (others=>'0');
            src_mac     <= (others=>'0');
            output_mac  <= (others=>'0');
            output_port <= (others=>'0');
            output_payload <= (others=>'0');
        elsif rising_edge(clk)
            case state is
                when LOAD => --wait for ram to load MAC Table;
                    if (k > 0) then 
                        state <= LOAD;
                        k <= k - 1;
                    else state <= ACTIVE;
                    end if;
                when READ => --check if theres input frame;
                    k <= 2;
                    r_bit <= '1';
                    mac_in <= src_mac;
                    state <= HOLD;
                when HOLD =>
                    state <= FORWARD;
                when FORWARD =>
                    if (hit_flag = "10") then
                        frame(1) <= payload_byte;
                        frame(2) <= payload_byte;
                        frame(3) <= payload_byte;
                        frame(4) <= payload_byte;
                        frame(5) <= payload_byte;
                        frame(6) <= payload_byte;
                        frame(7) <= payload_byte;
                        frame(8) <= payload_byte;
                        frame(9) <= payload_byte;
                        frame(10) <= payload_byte;
                        frame(11) <= payload_byte;
                        frame(11) <= payload_byte;
                    elsif (hit_flag = "11") then
                        case port_out is
                            when "0001" then
                                frame(1) <= payload_byte;
                            when "0010" then
                                frame(2) <= payload_byte;
                            when "0011" then
                                frame(3) <= payload_byte;
                            when "0100" then
                                frame(4) <= payload_byte;
                            when "0101" then
                                frame(5) <= payload_byte;
                            when "0110" then
                                frame(6) <= payload_byte;
                            when "0111" then
                                frame(7) <= payload_byte;
                            when "1000" then
                                frame(8) <= payload_byte;
                            when "1001" then
                                frame(9) <= payload_byte;
                            when "1010" then
                                frame(10) <= payload_byte;
                            when "1011" then
                                frame(11) <= payload_byte;
                            when "1100" then
                                frame(12) <= payload_byte;
            end case
        end if
    end process;

END ARCHITECTURE rtl;
]
    7 <= "";
    8 <= "";
    9 <= "";
    10 <= "";
    11 <= "";
    12 <= "";