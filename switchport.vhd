LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE STD.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY switchport IS
    PORT (
        clk : IN STD_LOGIC;
        port_id : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        frame_out : OUT STD_LOGIC_VECTOR(167 DOWNTO 0); -- Changed to OUT
        inout_bit : IN STD_LOGIC; -- generate frame when "1", 0 is idle or read mode
        data_in : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        payload : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        MAC_dest : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        MAC_add : IN STD_LOGIC_VECTOR(47 DOWNTO 0)
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
                WHEN '0'=>
                    frame_out <= (others=> '0');
                    frame_ready <= '0';
                WHEN '1' => -- Send state
                    tempDest <= MAC_dest;
                    tempAdd <= MAC_add;
                    tempPayload <= payload;
                    frame_ready <= '1'; -- Mark frame as ready to update
                WHEN OTHERS => 
                    tempDest <= (others=> '0');
                    tempAdd <= (others=> '0');
                    tempPayload <= (others=> '0');
                    frame_ready <= '0'; 
            END CASE;
        END IF;
        -- Update frame_out based on frame_ready signal
        IF frame_ready = '1' THEN
            frame_out <= tempOut;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;
