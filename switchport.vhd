LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE STD.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY switchport IS
    PORT (
        clk : IN STD_LOGIC;
        inout_bit : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- "00" off, "01" idle, "10" receive, "11" send
        port_id : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        frame_out : OUT STD_LOGIC_VECTOR(167 DOWNTO 0); -- Changed to OUT
        data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        MAC_dest : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        MAC_add : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0)
    );
END ENTITY switchport;

ARCHITECTURE rtl OF switchport IS
    CONSTANT total_port : INTEGER := 12;
    COMPONENT frame_encoder IS -- frame encoder
        PORT (
            frame_out : OUT STD_LOGIC_VECTOR(167 DOWNTO 0); -- Assuming 168-bit frame
            dest_mac : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            src_mac : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            payload_byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT frame_encoder;

    SIGNAL tempDest : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL tempAdd : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL tempOut : STD_LOGIC_VECTOR(167 DOWNTO 0);
    SIGNAL tempPayload : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL frame_ready : STD_LOGIC := '0'; -- Trigger for frame_out update

BEGIN
    -- Instance of frame_encoder
    encoder : frame_encoder PORT MAP(
        frame_out => tempOut,
        dest_mac => tempDest,
        src_mac => tempAdd,
        payload_byte => tempPayload
    );

    PROCESS (inout_bit, clk)
    BEGIN
        IF rising_edge(clk) THEN
            CASE inout_bit IS
                WHEN "00" => -- Off state
                    data <= (OTHERS => '0');
                    MAC_add <= (OTHERS => '0');
                    MAC_dest <= (OTHERS => '0');
                    frame_out <= (OTHERS => '0');
                    frame_ready <= '0';
                WHEN "01" => -- Idle state
                    tempDest <= (OTHERS => '0');
                    tempAdd <= (OTHERS => '0');
                    tempPayload <= (OTHERS => '0');
                    frame_ready <= '0';
                WHEN "10" => -- Receive state
                    inout_bit <= "01";
                    frame_ready <= '0';
                WHEN "11" => -- Send state
                    tempDest <= MAC_dest;
                    tempAdd <= MAC_add;
                    tempPayload <= data;
                    frame_ready <= '1'; -- Mark frame as ready to update
                WHEN OTHERS =>
                    inout_bit <= (OTHERS => 'Z');
                    data <= (OTHERS => 'Z');
                    MAC_add <= (OTHERS => 'Z');
                    MAC_dest <= (OTHERS => 'Z');
            END CASE;
        END IF;

        -- Update frame_out based on frame_ready signal
        IF frame_ready = '1' THEN
            frame_out <= tempOut;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;
