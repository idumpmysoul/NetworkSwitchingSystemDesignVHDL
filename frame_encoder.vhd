library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity frame_encoder is -- frame encoder
  port (
    frame_out : out std_logic_vector(167 downto 0); -- Assuming 168-bit frame
    dest_mac : inout std_logic_vector(47 downto 0);
    src_mac  : in std_logic_vector(47 downto 0); 
    payload_byte : in std_logic_vector(7 downto 0)
  );
end entity frame_encoder;

architecture rtl of frame_encoder is
begin
  process (dest_mac, payload_byte)
  begin
    frame_out <= "0101010110101011" & dest_mac & src_mac & "0000100000000000" & payload_byte & "11111111111111111111111111111111"; -- Gathering all the fields of the frame
  end process;
end architecture rtl;