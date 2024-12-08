LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY switch IS --only 1 port receiver, 3 port sending
    PORT (
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;
        input_frame     : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0); -- Assuming 168-bit frame
        src_port        : out STD_LOGIC_VECTOR(7 DOWNTO 0);
        src_mac         : out STD_LOGIC_VECTOR(47 DOWNTO 0);
        output_port     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        output_mac      : out STD_LOGIC_VECTOR(47 DOWNTO 0);
        output_payload : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        --fa01
        fa01_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa01_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --indicator for port receiving = "10", sending = "11", idle = "01", off = "00";
        fa01_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa01_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa01_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa02
        fa02_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa02_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa02_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa02_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa02_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --faa03
        fa03_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa03_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa03_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa03_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa03_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa04
        fa04_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa04_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa04_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa04_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa04_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa05
        fa05_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa05_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa05_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa05_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa05_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa06
        fa06_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa06_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa06_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa06_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa06_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa07
        fa07_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa07_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa07_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa07_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa07_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa08
        fa08_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa08_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa08_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa08_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa08_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa09
        fa09_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa09_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa09_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa09_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa09_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa010
        fa010_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa010_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa010_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa010_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa010_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa011
        fa011_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa011_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa011_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa011_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa011_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
        --fa012
        fa012_MAC       : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa012_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa012_data      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa012_DestMac   : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa012_FrameOut  : INOUT STD_LOGIC_VECTOR(168 DOWNTO 0);
    );
END ENTITY switch;

ARCHITECTURE rtl OF switch IS
    COMPONENT switchport IS
        PORT (
            inout_bit   : in std_logic_vector(1 downto 0); -- "00" off, "01" idle, "10" receive, "11" send
            port_id     : in std_logic_vector(3 downto 0);
            frame_out   : out  STD_LOGIC_VECTOR(167 DOWNTO 0);
            data        : in std_logic_vector(3 downto 0);
            MAC_Dest    : in STD_LOGIC_VECTOR(47 DOWNTO 0);
            MAC_add     : inout  STD_LOGIC_VECTOR(47 DOWNTO 0);
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

    SIGNAL r_bit : STD_LOGIC;
    SIGNAL w_bit : STD_LOGIC;
    SIGNAL hit_flag : STD_LOGIC_VECTOR(1 DOWNTO 0);
    type State_Type is (LOAD, READ, HOLD, FORWARD, DONE);
    signal state  : State_Type := LOAD;


BEGIN
    SwCAM1 : SwCAM port map (
        main_clk => clk,
        main_rst => reset,
        r_bit => r_bit,
        w_bit => w_bit,
        mac_in => mac_in,
        port_out => port_out;
        hit_flag => hit_flag
    );

    FrameDecoder : frame_decoder port map (
        frame_in => input_frame;
        dest_mac => output_mac;
        src_mac  => src_mac;
        payload_byte => output_payload;
    );

    --instantiation
    fa01 : switchport port map (
        inout_bit => fa01_inoutBits,
        port_id => "0001",
        data => fa01_data,
        MAC_Add => fa01_MAC,
        MAC_Dest => fa01_DestMac,
        frame_out => fa01_FrameOut
    );

    fa02 : switchport port map (
        inout_bit => fa02_inoutBits,
        port_id => "0010",
        data => fa02_data;,
        MAC_Add => fa02_MAC,
        MAC_Dest => fa02_DestMac,
        frame_out => fa03_FrameOut
    );

    fa03 : switchport port map (
        inout_bit => fa03_inoutBits,
        port_id => "0011",
        data => fa03_data,
        MAC_Add => fa03_MAC,
        MAC_Dest => fa03_DestMac,
        frame_out => fa03_FrameOut
    );

    fa04 : switchport port map (
        inout_bit => fa04_inoutBits,
        port_id => "0100",
        data => fa04_data,
        MAC_Add => fa04_MAC,
        MAC_Dest => fa04_DestMac,
        frame_out => fa04_FrameOut
    );

    fa05 : switchport port map (
        inout_bit => fa05_inoutBits,
        port_id => "0101",
        data => fa05_data,
        MAC_Add => fa05_MAC,
        MAC_Dest => fa05_DestMac,
        frame_out => fa05_FrameOut
    );

    fa06 : switchport port map (
        inout_bit => fa06_inoutBits,
        port_id => '"0110",
        data => fa06_data,
        MAC_Add => fa06_MAC,
        MAC_Dest => fa06_DestMac,
        frame_out => fa06_FrameOut
    );

    fa07 : switchport port map (
        inout_bit => fa07_inoutBits,
        port_id => "0111",
        data => fa07_data,
        MAC_Add => fa07_MAC,
        MAC_Dest => fa07_DestMac,
        frame_out => fa07_FrameOut
    );

    fa08 : switchport port map (
        inout_bit => fa08_inoutBits,
        port_id => "1000",
        data => fa08_data,
        MAC_Add => fa08_MAC,
        MAC_Dest => fa08_DestMac,
        frame_out => fa08_FrameOut
    );

    fa09 : switchport port map (
        inout_bit => fa09_inoutBits,
        port_id => "1001",
        data => fa09_data,
        MAC_Add => fa09_MAC,
        MAC_Dest => fa09_DestMac,
        frame_out => fa09_FrameOut
    );

    fa10 : switchport port map (
        inout_bit => fa010_inoutBits,
        port_id => "1010",
        data => fa010_data,
        MAC_Add => fa010_MAC,
        MAC_Dest => fa010_DestMac,
        frame_out => fa010_FrameOut
    );

    fa11 : switchport port map (
        inout_bit => fa011_inoutBits,
        port_id => "1011",
        data => fa011_data,
        MAC_Dest => fa011_DestMac,
        MAC_Add => fa011_MAC,
        frame_out => fa012_FrameOut
    );

    fa12 : switchport port map (
        inout_bit => fa012_inoutBits,
        port_id => "1100",
        data => fa012_data,
        MAC_Add => fa012_MAC,
        MAC_Dest => fa012_DestMac,
        frame_out => fa012_FrameOut
    );

    process (clk, reset, input_frame)
        signal k : integer := 2;
    begin
        if reset = '1' then
            state <= LOAD;
            input_frame <= (others=>'0');
            src_port    <= (others=>'0');
            src_mac     <= (others=>'0');
            output_mac  <= (others=>'0');
            output_port <= (others=>'0');
            output_payload <= (others=>'0');
        elsif rising_edge(clk)
            case state is
                when LOAD => --wait for ram to load MAC Table, decoding, and encoding;
                    if (k > 0) then 
                        state <= LOAD;
                        k <= k - 1;
                    else state <= ACTIVE;
                    end if;
                when READ => --check if theres input frame;
                    k <= 2;
                    r_bit <= '1';
                    mac_in <= output_mac;
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
                        end case;
                    end if;
            end case
        end if
    end process;

END ARCHITECTURE rtl;