library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity frame_decoder is -- frame decoder
  port (
    frame_in : in std_logic_vector(167 downto 0); -- Assuming 168-bit frame

    dest_mac : out std_logic_vector(47 downto 0);
    src_mac  : out std_logic_vector(47 downto 0); 
    payload_byte : out std_logic_vector(7 downto 0)
  );
end entity frame_decoder;

architecture rtl of frame_decoder is
begin
  dest_mac <= frame_in(151 downto 104); 
  src_mac <= frame_in(103 downto 56);
  payload_byte <= frame_in(39 downto 32);
end architecture rtl;