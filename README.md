# Network Switch System Design with VHDL
Network switch system design with VHDL merupakan replika dari perangkat switch pada jaringan yang didesain menggunakan bahasa VHDL. Switch akan menerima packet dari port yang dimilikinya, lalu switch akan menentukan alamat pengiriman packet berdasarkan mac-address tujuan dalam MAC table yang dimilikinya.
Model ini akan mereplikasi switch yang memiliki system buffer sederhana yang diimplementasikan pada memory dari ram tersebut.
Desain switch akan menggunakan FSM dengan microprograming yang akan berperan sebagai processor dari switch tersebut. Loop construct akan digunakan di dalam testbench bersamaan dengan procedure/functions untuk mereplikasi contoh input berupa packet yang akan diterima oleh switch.

## Rangkaian

!(masukkan gambar)[]

Rangkaian ini memiliki 5 komponen yang akan berinteraksi satu sama lain, yaitu Switch, Switchport, Switch Memory, Frame encoder, dan Frame Decoder. Switch akan menjadi entity utama yang bertugas untuk menerima paket dari port-port yang ada dan menentukan port tujuan berdasarkan informasi yang terkandung di dalam paket tersebut. Switchport bertugas untuk menerima maupun mengirim frame data seperti port interface pada switch aslinya. Switch memory bertugas untuk menyimpan mac address dari setiap port interface agar switch dapat menentukan apakah mac address tujuan dari paket yang dikirim terdapat pada MAC table tersebut. Frame Decoder bertugas untuk mendecode frame yang diterima dari port dan menampilkan output berupa mac address tujuan, mac address asal, dan juga payload byte sebagai data yang dikirimkan bersamaan dengan paket tersebut. Frame encoder memiliki tugas yang berkebalikan dengan decoder. Frame encoder bertugas untuk menyusun data-data yang dimilikinya berupa mac address asal, mac address tujuan, serta payload byte yang menjadi data utama yang dikirim bersama dengan paket tersebut menjadi sebuah frame 

## State Diagram

## Frame input

## Frame Encoding

## Snippet Code

### Switch

Entity top level yang akan menyatukan semua komponen-komponen lainnya seperti switchport, SwRAM, dan frame-decoder. Alur pengiriman paket akan dijalankan dengan menggunakan FSM (Finite State Machine) dengan state[masukkan state yang ada]

```vhdl

```

### Switchport

komponen yang akan bertugas seperti port pada switch asli. Berfungsi untuk menerima frame dari port lain maupun mengirimkan frame kepada port lainnya.

```vhdl

```

### Switch memory

komponen yang memiliki fungsi seperti MAC table pada address. bertugas untuk menyimpan mac address tiap port serta menentukan apakah frame yang diterima switch memiliki mac address tujuan yang terdapat pada MAC table switch tersebut.

```vhdl

```

### Frame Decoder

komponen yang bertugas untuk mendecode frame yang diterima sehingga switch akan memiliki mac address tujuan serta mac address asal sehingga switch dapat menentukan port mana yang menjadi tujuan dari paket tersebut.

```vhdl
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
  process (frame_in)
  begin
    dest_mac <= frame_in(151 downto 104); 
    src_mac <= frame_in(103 downto 56);
    payload_byte <= frame_in(39 downto 32);
  end process;
end architecture rtl;
```

### Frame Encoder

berkebalikan dengan frame decoder, frame encoder akan menyusun data-data yang dimiliki seperti mac address asal, mac address tujuan, dan data payload menjadi 1 frame utuh.

```vhdl
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity frame_encoder is -- frame encoder
  port (
    frame_in : out std_logic_vector(167 downto 0); -- Assuming 168-bit frame
    dest_mac : in std_logic_vector(47 downto 0);
    src_mac  : in std_logic_vector(47 downto 0); 
    payload_byte : in std_logic_vector(7 downto 0)
  );
end entity frame_encoder;

architecture rtl of frame_encoder is
begin
  frame_in <= "0101010110101011" & dest_mac & src_mac & "0000100000000000" & payload_byte & "11111111111111111111111111111111"; -- Gathering all the fields of the frame
end architecture rtl;
```