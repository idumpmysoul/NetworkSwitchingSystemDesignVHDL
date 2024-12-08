LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE STD.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY switchport IS
    PORT (
        inout_bit : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- "00" off, "01" idle, "10" receive, "11" send
        port_id : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        frame_out : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
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
BEGIN
    encoder : frame_encoder PORT MAP(
        frame_out => frame_out,
        dest_mac => tempDest,
        src_mac => tempAdd,
        payload_byte => tempPayload
    );
    PROCESS (inout_bit)
    BEGIN
        IF inout_bit = "00" THEN
            data <= (OTHERS => '0');
            MAC_Add <= (OTHERS => '0');
            MAC_dest <= (OTHERS => '0');
            frame_out <= (OTHERS => '0');
        ELSIF inout_bit = "01" THEN
            tempDest <= (OTHERS => '0');
            tempAdd <= (OTHERS => '0');
            tempOut <= (OTHERS => '0');
            tempPayload <= (OTHERS => '0');
            frame_out <= (OTHERS => '0');
        ELSIF inout_bit = "10" then
            inout_bit <= "01";
        ELSIF inout_bit = "11" then
            tempDest <= MAC_dest;
            tempAdd <= MAC_Add;
            tempPayload <= data;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;