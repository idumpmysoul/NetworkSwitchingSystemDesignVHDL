LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY switch IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        rw_bit_in : IN STD_LOGIC; --for SwCAM
        sent_frame : OUT STD_LOGIC_VECTOR(167 DOWNTO 0); --Assuming 168-bit frame
        src_port : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- from decoder
        src_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0); -- from decoder
        dest_port : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- from decoder
        dest_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0); -- from decoder
        output_payload : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        --fa01
        fa01_MAC : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa01_InoutBit : IN STD_LOGIC; --indicator for port receiving = "0", sending = "1";
        fa01_Payload : IN STD_LOGIC_VECTOR(7 DOWNTO 0); --data to send
        fa01_DataIn : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --data that received
        fa01_DestMac : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa01_FrameOut : OUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --fa02
        fa02_MAC : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa02_InoutBit : IN STD_LOGIC;
        fa02_Payload : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa02_DataIn : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa02_DestMac : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa02_FrameOut : OUT STD_LOGIC_VECTOR(167 DOWNTO 0);
        --faa03
        fa03_MAC : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa03_InoutBit : IN STD_LOGIC;
        fa03_Payload : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa03_DataIn : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        fa03_DestMac : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        fa03_FrameOut : OUT STD_LOGIC_VECTOR(167 DOWNTO 0)
        --add ports later
    );
END ENTITY switch;

ARCHITECTURE rtl OF switch IS
    COMPONENT switchport IS
        PORT (
            clk : IN STD_LOGIC;
            port_id : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            frame_out : OUT STD_LOGIC_VECTOR(167 DOWNTO 0); -- Changed to OUT
            inout_bit : IN STD_LOGIC; -- generate frame when "1", 0 is idle or read mode
            data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            payload : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            MAC_dest : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            MAC_add : IN STD_LOGIC_VECTOR(47 DOWNTO 0)
        );
    END COMPONENT switchport;

    COMPONENT SwCAM IS --simple cam to keep MAC-Add table
        PORT (
            main_clk : IN STD_LOGIC;
            main_rst : IN STD_LOGIC;
            rw_bit   : IN STD_LOGIC;
            enable   : IN STD_LOGIC;
            mac_find : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            port_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --assuming a switch with 24 ethernet-port, so max bit is 2^5
            hit_flag : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) --if found '11', not found '10';
        );
    END COMPONENT SwCAM;

    COMPONENT frame_decoder IS -- frame decoder
        PORT (
            frame_in : IN STD_LOGIC_VECTOR(167 DOWNTO 0); -- Assuming 168-bit frame
            dest_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            src_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            payload_byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT frame_decoder;

    TYPE State_Type IS (LOAD, ACTIVE, DECODE, SEARCH, HOLD, ASSIGN, FORWARD, RECEIVE, COMPLETE);
    SIGNAL state : State_Type := LOAD;
    SIGNAL rw_bit : STD_LOGIC := '0'; -- 0 = read, 1 = write, default read
    SIGNAL enable : STD_LOGIC := '0';
    SIGNAL temp_hit_flag : STD_LOGIC_VECTOR(1 DOWNTO 0); --if found '11', not found '10';
    SIGNAL buffer_frame : STD_LOGIC_VECTOR(2015 DOWNTO 0) := (others => '0'); --size  of 12 frame
    SIGNAL mac_find : STD_LOGIC_VECTOR(47 DOWNTO 0); -- decoded
    SIGNAL decode_frame : STD_LOGIC_VECTOR(167 DOWNTO 0); -- to decode
    SIGNAL temp_src_port : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL temp_dest_port : STD_LOGIC_VECTOR(3 DOWNTO 0); --decoded;
    SIGNAL temp_payload : STD_LOGIC_VECTOR(7 DOWNTO 0); -- decoded

    --temp frame out for ports, after being encoded, add for new ports later.
    signal temp_fa01_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0);
    signal temp_fa02_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0);
    signal temp_fa03_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0);

    --temp data in for ports, after being encoded, add for new ports later.
    signal temp_fa01_DataIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal temp_fa02_DataIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal temp_fa03_DataIn : STD_LOGIC_VECTOR(7 DOWNTO 0);

    --for assignments
    SIGNAL zeros : STD_LOGIC_VECTOR(167 DOWNTO 0) := (OTHERS => '0');
    SIGNAL buffer_index : integer := 1;
    SIGNAL hold_count   : integer := 2;
    CONSTANT port_num : integer := 3;
BEGIN
    SwCAM1 : SwCAM PORT MAP(
        main_clk => clk,
        main_rst => reset,
        rw_bit => rw_bit,
        enable => enable,
        mac_find => mac_find,
        port_out => temp_dest_port,
        hit_flag => temp_hit_flag
    );

    FrameDecoder : frame_decoder PORT MAP(
        frame_in => decode_frame,
        dest_mac => mac_find,
        src_mac => src_mac,
        payload_byte => temp_payload
    );

    --instantiation, 3 ports for starters
    fa01 : switchport PORT MAP(
        clk => clk,
        port_id => "0001",
        inout_bit => fa01_InoutBit,
        data_in => temp_fa01_DataIn,
        payload => fa01_Payload,
        MAC_Add => fa01_MAC,
        MAC_Dest => fa01_DestMac,
        frame_out => temp_fa01_FrameOut
    );

    fa02 : switchport PORT MAP(
        clk => clk,
        port_id => "0010",
        inout_bit => fa03_InoutBit,
        data_in => temp_fa02_DataIn,
        payload => fa02_Payload,
        MAC_Add => fa02_MAC,
        MAC_Dest => fa02_DestMac,
        frame_out => temp_fa02_FrameOut
    );

    fa03 : switchport PORT MAP(
        clk => clk,
        port_id => "0011",
        inout_bit => fa03_InoutBit,
        data_in => temp_fa03_DataIn,
        payload => fa03_Payload,
        MAC_Add => fa03_MAC,
        MAC_Dest => fa03_DestMac,
        frame_out => temp_fa03_FrameOut
    );

    --add other ports instantiation later.
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            state <= LOAD;
            sent_frame <= (OTHERS => '0');
            src_port <= (OTHERS => '0');
            dest_mac <= (OTHERS => '0');
            dest_port <= (OTHERS => '0');
            output_payload <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            CASE state IS
                WHEN LOAD =>
                    buffer_index <= 1;
                    buffer_frame(2015 DOWNTO 1848) <= temp_fa01_FrameOut;
                    buffer_frame(1847 DOWNTO 1680) <= temp_fa02_FrameOut;
                    buffer_frame(1679 DOWNTO 1512) <= temp_fa03_FrameOut;
                    --for future ports
                    --buffer_frame(1511 DOWNTO 1344) <= fa04_FrameOut;
                    --buffer_frame(1343 DOWNTO 1176) <= fa05_FrameOut;
                    --buffer_frame(1175 DOWNTO 1008) <= fa06_FrameOut;
                    --buffer_frame(1007 DOWNTO 840) <= fa07_FrameOut;
                    --buffer_frame(839 DOWNTO 672) <= fa08_FrameOut;
                    --buffer_frame(671 DOWNTO 504) <= fa09_FrameOut;
                    --buffer_frame(503 DOWNTO 336) <= fa010_FrameOut;
                    --buffer_frame(335 DOWNTO 168) <= fa011_FrameOut;
                    --buffer_frame(167 DOWNTO 0) <= fa012_FrameOut;
                    state <= ACTIVE;
                WHEN ACTIVE =>
                    decode_frame <= buffer_frame(2015 DOWNTO 1848);
                    sent_frame <= buffer_frame(2015 DOWNTO 1848);
                    state <= DECODE;
                WHEN DECODE =>
                    IF (decode_frame = zeros) THEN
                        state <= COMPLETE;
                    ELSIF (decode_frame(167) = 'U') THEN
                        state <= LOAD;
                    ELSE
                        state <= SEARCH;
                    END IF;
                    buffer_frame(2015 DOWNTO 0) <= buffer_frame(1847 DOWNTO 0) & zeros; --shift left
                WHEN SEARCH =>
                    enable <= '1';
                    temp_src_port <= STD_LOGIC_VECTOR(to_unsigned(buffer_index, 4));
                    if (rw_bit_in = '1') then
                        rw_bit <= '1';
                    else rw_bit <= '0';
                    end if;
                    state <= HOLD;
                WHEN HOLD =>
                    if (hold_count = 1) then
                        state <= ASSIGN;
                    else state <= HOLD;
                    end if;
                    hold_count <= hold_count - 1;
                WHEN ASSIGN => 
                    hold_count <= 2;
                    --assign
                    fa01_FrameOut <= temp_fa01_FrameOut;
                    fa02_FrameOut <= temp_fa02_FrameOut;
                    fa03_FrameOut <= temp_fa03_FrameOut;
                    --add ports in the future
                    src_port <= temp_src_port;
                    dest_port <= temp_dest_port;
                    dest_mac <= mac_find;
                    state <= FORWARD;
                WHEN FORWARD =>
                    output_payload <= temp_payload;
                    IF (temp_hit_flag = "10") THEN --broadcast, except to source port.
                        IF (temp_src_port /= "0001") THEN
                            fa01_DataIn <= temp_payload;
                            temp_fa01_DataIn <= temp_payload;
                        END IF;

                        IF (temp_src_port /= "0010") THEN
                            fa02_DataIn <= temp_payload;
                            temp_fa01_DataIn <= temp_payload;
                        END IF;

                        IF (temp_src_port /= "0011") THEN
                            fa03_DataIn <= temp_payload;
                            temp_fa01_DataIn <= temp_payload;
                        END IF;
                        --add another conditions for port id's as new ports added.
                    ELSIF (temp_hit_flag = "11") THEN
                        CASE temp_dest_port IS
                            WHEN "0001" =>
                                IF (temp_src_port /= "0001") THEN
                                    fa01_DataIn <= temp_payload;
                                    temp_fa01_DataIn <= temp_payload;
                                END IF;

                            WHEN "0010" =>
                                IF (temp_src_port /= "0010") THEN
                                    fa02_DataIn <= temp_payload;
                                    temp_fa01_DataIn <= temp_payload;
                                END IF;

                            WHEN "0011" =>
                                IF (temp_src_port /= "0011") THEN
                                    fa03_DataIn <= temp_payload;
                                    temp_fa01_DataIn <= temp_payload;
                                END IF;
                        --add another conditions for port id's as new ports added.

                            WHEN OTHERS =>
                                -- Optionally, you can add a default action here if necessary                                       
                        END CASE;
                    END IF;
                    state <= RECEIVE;
                WHEN RECEIVE =>
                    state <= COMPLETE;
                WHEN COMPLETE =>
                    enable <= '0';
                    rw_bit <= '0'; --write behavior not set
                    IF (buffer_index = port_num) THEN
                        state <= LOAD;
                    ELSE
                        state <= ACTIVE;
                    END IF;
                    buffer_index <= buffer_index + 1;
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;