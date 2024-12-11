LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY switch IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        buffer_frame : INOUT STD_LOGIC_VECTOR(2015 DOWNTO 0);
        input_frame : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0); --Assuming 168-bit frame
        src_port : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        src_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        dest_port : inOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        dest_mac : inout STD_LOGIC_VECTOR(47 DOWNTO 0);
        output_payload : inOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        --fa01
        fa01_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa01_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --indicator for port receiving = "10", sending = "11", idle = "01", off = "00";
        fa01_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa01_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa01_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa02
        fa02_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa02_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa02_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa02_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa02_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --faa03
        fa03_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa03_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa03_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa03_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa03_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa04
        fa04_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa04_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa04_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa04_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa04_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa05
        fa05_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa05_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa05_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa05_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa05_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa06
        fa06_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa06_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa06_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa06_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa06_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa07
        fa07_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa07_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa07_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa07_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa07_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa08
        fa08_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa08_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa08_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa08_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa08_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa09
        fa09_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa09_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa09_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa09_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa09_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa010
        fa010_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa010_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa010_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa010_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa010_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa011
        fa011_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa011_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa011_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa011_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa011_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa012
        fa012_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa012_inoutBits : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        fa012_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa012_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa012_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0)
    );
END ENTITY switch;

ARCHITECTURE rtl OF switch IS
    COMPONENT switchport IS
        PORT (
            inout_bit : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- "00" off, "01" idle, "10" receive, "11" send
            port_id : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            frame_out : OUT STD_LOGIC_VECTOR(167 DOWNTO 0);
            data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            MAC_Dest : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            MAC_add : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0)
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

    COMPONENT frame_decoder IS -- frame decoder
        PORT (
            frame_in : IN STD_LOGIC_VECTOR(167 DOWNTO 0); -- Assuming 168-bit frame
            dest_mac : inout STD_LOGIC_VECTOR(47 DOWNTO 0);
            src_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            payload_byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT frame_decoder;

    SIGNAL r_bit : STD_LOGIC;
    SIGNAL w_bit : STD_LOGIC;
    SIGNAL hit_flag : STD_LOGIC_VECTOR(1 DOWNTO 0);
    TYPE State_Type IS (LOAD, ACTIVE, DECODE, SEARCH, HOLD, FORWARD, RECEIVE, COMPLETE);
    SIGNAL state : State_Type := LOAD;
    signal temp_buffer_frame : STD_LOGIC_VECTOR(2015 downto 0);
    signal zeros : std_logic_vector(167 downto 0) := (others=>'0');
BEGIN
    SwCAM1 : SwCAM PORT MAP(
        main_clk => clk,
        main_rst => reset,
        r_bit => r_bit,
        w_bit => w_bit,
        mac_in => dest_mac,
        port_out => dest_port,
        hit_flag => hit_flag
    );

    FrameDecoder : frame_decoder PORT MAP(
        frame_in => input_frame,
        dest_mac => dest_mac,
        src_mac => src_mac,
        payload_byte => output_payload
    );

    --instantiation
    fa01 : switchport PORT MAP(
        inout_bit => fa01_inoutBits,
        port_id => "0001",
        data => fa01_data,
        MAC_Add => fa01_MAC,
        MAC_Dest => fa01_DestMac,
        frame_out => fa01_FrameOut
    );

    fa02 : switchport PORT MAP(
        inout_bit => fa02_inoutBits,
        port_id => "0010",
        data => fa02_data,
        MAC_Add => fa02_MAC,
        MAC_Dest => fa02_DestMac,
        frame_out => fa03_FrameOut
    );

    fa03 : switchport PORT MAP(
        inout_bit => fa03_inoutBits,
        port_id => "0011",
        data => fa03_data,
        MAC_Add => fa03_MAC,
        MAC_Dest => fa03_DestMac,
        frame_out => fa03_FrameOut
    );

    fa04 : switchport PORT MAP(
        inout_bit => fa04_inoutBits,
        port_id => "0100",
        data => fa04_data,
        MAC_Add => fa04_MAC,
        MAC_Dest => fa04_DestMac,
        frame_out => fa04_FrameOut
    );

    fa05 : switchport PORT MAP(
        inout_bit => fa05_inoutBits,
        port_id => "0101",
        data => fa05_data,
        MAC_Add => fa05_MAC,
        MAC_Dest => fa05_DestMac,
        frame_out => fa05_FrameOut
    );

    fa06 : switchport PORT MAP(
        inout_bit => fa06_inoutBits,
        port_id => "0110",
        data => fa06_data,
        MAC_Add => fa06_MAC,
        MAC_Dest => fa06_DestMac,
        frame_out => fa06_FrameOut
    );

    fa07 : switchport PORT MAP(
        inout_bit => fa07_inoutBits,
        port_id => "0111",
        data => fa07_data,
        MAC_Add => fa07_MAC,
        MAC_Dest => fa07_DestMac,
        frame_out => fa07_FrameOut
    );

    fa08 : switchport PORT MAP(
        inout_bit => fa08_inoutBits,
        port_id => "1000",
        data => fa08_data,
        MAC_Add => fa08_MAC,
        MAC_Dest => fa08_DestMac,
        frame_out => fa08_FrameOut
    );

    fa09 : switchport PORT MAP(
        inout_bit => fa09_inoutBits,
        port_id => "1001",
        data => fa09_data,
        MAC_Add => fa09_MAC,
        MAC_Dest => fa09_DestMac,
        frame_out => fa09_FrameOut
    );

    fa10 : switchport PORT MAP(
        inout_bit => fa010_inoutBits,
        port_id => "1010",
        data => fa010_data,
        MAC_Add => fa010_MAC,
        MAC_Dest => fa010_DestMac,
        frame_out => fa010_FrameOut
    );

    fa11 : switchport PORT MAP(
        inout_bit => fa011_inoutBits,
        port_id => "1011",
        data => fa011_data,
        MAC_Dest => fa011_DestMac,
        MAC_Add => fa011_MAC,
        frame_out => fa012_FrameOut
    );

    fa12 : switchport PORT MAP(
        inout_bit => fa012_inoutBits,
        port_id => "1100",
        data => fa012_data,
        MAC_Add => fa012_MAC,
        MAC_Dest => fa012_DestMac,
        frame_out => fa012_FrameOut
    );

    PROCESS (clk, reset)
        VARIABLE buffer_index : INTEGER := 1;
    BEGIN
        IF reset = '1' THEN
            state <= LOAD;
            input_frame <= (OTHERS => '0');
            src_port <= (OTHERS => '0');
            src_mac <= (OTHERS => '0');
            dest_mac <= (OTHERS => '0');
            dest_port <= (OTHERS => '0');
            output_payload <= (OTHERS => '0');
        ELSIF rising_edge(clk) then
            CASE state IS
                WHEN LOAD =>
                    buffer_index := 12;
                    buffer_frame(2015 DOWNTO 1848) <= fa01_FrameOut;
                    buffer_frame(1847 DOWNTO 1680) <= fa02_FrameOut;
                    buffer_frame(1679 DOWNTO 1512) <= fa03_FrameOut;
                    buffer_frame(1511 DOWNTO 1344) <= fa04_FrameOut;
                    buffer_frame(1343 DOWNTO 1176) <= fa05_FrameOut;
                    buffer_frame(1175 DOWNTO 1008) <= fa06_FrameOut;
                    buffer_frame(1007 DOWNTO 840) <= fa07_FrameOut;
                    buffer_frame(839 DOWNTO 672) <= fa08_FrameOut;
                    buffer_frame(671 DOWNTO 504) <= fa09_FrameOut;
                    buffer_frame(503 DOWNTO 336) <= fa010_FrameOut;
                    buffer_frame(335 DOWNTO 168) <= fa011_FrameOut;
                    buffer_frame(167 DOWNTO 0) <= fa012_FrameOut;
                    state <= ACTIVE;
                WHEN ACTIVE =>
                    input_frame <= buffer_frame(2015 DOWNTO 1848);
                    state <= DECODE;
                WHEN DECODE =>
                    state <= SEARCH;
                WHEN SEARCH =>
                    r_bit <= '1';
                    state <= HOLD;
                WHEN HOLD =>
                    temp_buffer_frame(2015 DOWNTO 0) <= buffer_frame(1847 downto 0) & zeros;
                    state <= FORWARD;
                WHEN FORWARD =>
                    src_port <= STD_LOGIC_VECTOR(to_unsigned(buffer_index, 4));
                    IF (hit_flag = "10") THEN
                        fa01_data <= output_payload;
                        fa02_data <= output_payload;
                        fa03_data <= output_payload;
                        fa04_data <= output_payload;
                        fa05_data <= output_payload;
                        fa06_data <= output_payload;
                        fa07_data <= output_payload;
                        fa08_data <= output_payload;
                        fa09_data <= output_payload;
                        fa010_data <= output_payload;
                        fa011_data <= output_payload;
                        fa012_data <= output_payload;                    
                    ELSIF (hit_flag = "11") THEN
                        CASE dest_port IS
                            WHEN "0001" =>
                                fa01_data <= output_payload;
                            WHEN "0010" =>
                                fa02_data <= output_payload;
                            WHEN "0011" =>
                                fa03_data <= output_payload;
                            WHEN "0100" =>
                                fa04_data <= output_payload;
                            WHEN "0101" =>
                                fa05_data <= output_payload;
                            WHEN "0110" =>
                                fa06_data <= output_payload;
                            WHEN "0111" =>
                                fa07_data <= output_payload;
                            WHEN "1000" =>
                                fa08_data <= output_payload;
                            WHEN "1001" =>
                                fa09_data <= output_payload;
                            WHEN "1010" =>
                                fa010_data <= output_payload;
                            WHEN "1011" =>
                                fa011_data <= output_payload;
                            WHEN "1100" =>
                                fa012_data <= output_payload;
                            WHEN OTHERS =>                     
                        END CASE;
                    END IF;
                WHEN RECEIVE =>
                    state <= COMPLETE;
                WHEN COMPLETE =>
                    buffer_frame <= temp_buffer_frame;
                    r_bit <= '0';
                    w_bit <= '0';
                    IF (buffer_index = 12) THEN
                        state <= LOAD;
                    ELSE
                        state <= ACTIVE;
                    END IF;
                    buffer_index := buffer_index + 1;
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;