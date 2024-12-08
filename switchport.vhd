library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

ENTITY switchport IS
    PORT (
        inout_bit   : in std_logic_vector(1 downto 0);  -- "00" off, "01" idle, "10" receive, "11" send
        port_id     : in std_logic_vector(3 downto 0);
        frame_out   : out  STD_LOGIC_VECTOR(167 DOWNTO 0);
        data        : in std_logic_vector(3 downto 0);
        MAC_dest    : inout STD_LOGIC_VECTOR(47 DOWNTO 0);
        MAC_add     : inout  STD_LOGIC_VECTOR(47 DOWNTO 0);
    );
END ENTITY switchport;

ARCHITECTURE rtl OF switchport IS
    CONSTANT total_port : INTEGER := 12;
    component frame_encoder is -- frame encoder
    port (
        frame_out : out std_logic_vector(167 downto 0); -- Assuming 168-bit frame
        dest_mac : in std_logic_vector(47 downto 0);
        src_mac  : in std_logic_vector(47 downto 0); 
        payload_byte : in std_logic_vector(7 downto 0)
    );
    end component frame_encoder;

    signal tempDest : STD_LOGIC_VECTOR(47 DOWNTO 0);
    signal tempAdd  : STD_LOGIC_VECTOR(47 DOWNTO 0);
    signal tempOut  : std_logic_vector(167 downto 0);
    signal tempPayload : std_logic_vector(7 downto 0);
BEGIN
    encoder : frame_encoder portmap (
        frame_out => tempOut
        dest_mac =>
        src_mac => MAC_add
        frame_out =>
    );
    process (inout_bit)
    begin
        case inout_bit is
            when "00" =>
                MAC_dest <= (others=>'0');
                frame_out <= (others=>'0');
            when  "01" =>
                tempDest <= MAC_dest;
                tempAdd <= frame_out;
            when "10" =>
                tempDest <= MAC_dest;
                tempAdd <= frame_out;
            when "11" =>
        end case;
    end process;
END ARCHITECTURE rtl;