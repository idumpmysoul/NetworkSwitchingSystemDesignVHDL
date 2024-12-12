# Network Switch System Design with VHDL
Network switch system design with VHDL merupakan replika dari perangkat switch pada jaringan yang didesain menggunakan bahasa VHDL. Switch akan menerima packet dari port yang dimilikinya, lalu switch akan menentukan alamat pengiriman packet berdasarkan mac-address tujuan dalam MAC table yang dimilikinya.
Model ini akan mereplikasi switch yang memiliki system buffer sederhana yang diimplementasikan pada memory dari ram tersebut.
Desain switch akan menggunakan FSM dengan microprograming yang akan berperan sebagai processor dari switch tersebut. Loop construct akan digunakan di dalam testbench bersamaan dengan procedure/functions untuk mereplikasi contoh input berupa packet yang akan diterima oleh switch.

## Rangkaian

!(masukkan gambar)[]

Rangkaian ini memiliki 5 komponen yang akan berinteraksi satu sama lain, yaitu Switch, Switchport, Switch Memory, Frame encoder, dan Frame Decoder. Switch akan menjadi entity utama yang bertugas untuk menerima paket dari port-port yang ada dan menentukan port tujuan berdasarkan informasi yang terkandung di dalam paket tersebut. Switchport bertugas untuk menerima maupun mengirim frame data seperti port interface pada switch aslinya. Switch memory bertugas untuk menyimpan mac address dari setiap port interface agar switch dapat menentukan apakah mac address tujuan dari paket yang dikirim terdapat pada MAC table tersebut. Frame Decoder bertugas untuk mendecode frame yang diterima dari port dan menampilkan output berupa mac address tujuan, mac address asal, dan juga payload byte sebagai data yang dikirimkan bersamaan dengan paket tersebut. Frame encoder memiliki tugas yang berkebalikan dengan decoder. Frame encoder bertugas untuk menyusun data-data yang dimilikinya berupa mac address asal, mac address tujuan, serta payload byte yang menjadi data utama yang dikirim bersama dengan paket tersebut menjadi sebuah frame 

## State Diagram

![picture 0](https://i.imgur.com/JouJtAU.jpeg)  

Program ini memiliki 8 State. Antara lain LOAD, yang berfungsi untuk mengisi buffer dengan frame di switchport. ACTIVE merupakan state ketika switch sudah dalam keadaan aktif. DECODE merupakan state ketika switch menerima input frame dan memecahkan frame tersebut menjadi data-data seperti payload, dest. address, dan source address. SEARCH merupakan state ketika switch mencari port yang mac addressnya sesuai dengan mac address tujuan pada frame yang masuk. HOLD merupakan state ketika switch menahan data dalam signal buffer. FORWARD merupakan state ketika ada port yang ingin mengirim frame pada port lain. RECEIVE merupakan state ketika terdapat port yang menerima input dari port lain. Complete merupakan state ketika seluruh operasi telah selesai.

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
            dest_mac : INout STD_LOGIC_VECTOR(47 DOWNTO 0);
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
                    frame_out <= (OTHERS => '0');
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

```

### Switch memory

komponen yang memiliki fungsi seperti MAC table pada address. bertugas untuk menyimpan mac address tiap port serta menentukan apakah frame yang diterima switch memiliki mac address tujuan yang terdapat pada MAC table switch tersebut.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity SwCAM is --simple cam to buffer;
    port (
        main_clk    :   in  std_logic;
        main_rst    :   in  std_logic;
        r_bit       :   inout  std_logic;
        w_bit       :   inout  std_logic;
        mac_in      :   in  std_logic_vector(47 downto 0);
        port_out    :   out std_logic_vector(3 downto 0); --assuming a switch with max 24 ethernet-port, so max bit is 2^5
        hit_flag    :   out std_logic_vector(1 downto 0) --if found '11', not found '10';
    );
end entity SwCAM;

architecture rtl of SwCAM is
    constant max_port : integer := 24;
    type State_Type is (LOAD, ACTIVE, READ, WRITE, ASSIGN, COMPLETE);
    signal state : State_Type := LOAD;
    type MAC_Arr is array (0 to max_port) of std_logic_vector(47 downto 0);
    signal MAC : MAC_Arr := ( --initial cam value
        0 => "010101010101010101010101010101010101010101010101", --cam(0) would be the error assigned value
        1 => "000000000000000000000000000000000000000000000000",
        2 => "000000000000000000000000000000000000000000000000",
        3 => "000000000000000000000000000000000000000000000000",
        4 => "000000000000000000000000000000000000000000000000",
        5 => "000000000000000000000000000000000000000000000000",
        6 => "000000000000000000000000000000000000000000000000",
        7 => "000000000000000000000000000000000000000000000000",
        8 => "000000000000000000000000000000000000000000000000",
        9 => "000000000000000000000000000000000000000000000000",
        10 => "000000000000000000000000000000000000000000000000",
        11 => "000000000000000000000000000000000000000000000000",
        12 => "000000000000000000000000000000000000000000000000",
        13 => "000000000000000000000000000000000000000000000000",
        14 => "000000000000000000000000000000000000000000000000",
        15 => "000000000000000000000000000000000000000000000000",
        16 => "000000000000000000000000000000000000000000000000",
        17 => "000000000000000000000000000000000000000000000000",
        18 => "000000000000000000000000000000000000000000000000",
        19 => "000000000000000000000000000000000000000000000000",
        20 => "000000000000000000000000000000000000000000000000",
        21 => "000000000000000000000000000000000000000000000000",
        22 => "000000000000000000000000000000000000000000000000",
        23 => "000000000000000000000000000000000000000000000000",
        24 => "000000000000000000000000000000000000000000000000"
    );
    -- Procedure to fill CAM
    procedure fill_cam_from_file(
        signal macs  : inout MAC_Arr;                      -- CAM array to be filled
        file_name  : in string                             -- File name to read from                         
    ) is
        variable mac            : MAC_Arr;
        file mac_file           : text open read_mode is file_name;  
        variable line_buffer    : line;                               
        variable value          : std_logic_vector(47 downto 0);
    begin
        mac(0) := "010101010101010101010101010101010101010101010101";
        for i in 1 to max_port loop
            mac(i) := (others=>'0');
        end loop;
        -- Read the file and fill the MAC
        for i in 1 to max_port-1 loop
            if (not endfile(mac_file)) then
                readline(mac_file, line_buffer);
                read(line_buffer, value);
                mac(i) := value;
            else 
                exit;
            end if;
        end loop;
        macs <= mac;
    end procedure;

    signal portOut     : std_logic_vector(3 downto 0);
    signal hitFlag     : std_logic_vector(1 downto 0) := "00";
    signal macIn       : std_logic_vector(47 downto 0);
    -- Procedure to find MAC
    procedure find_MAC(
        signal macs     : in MAC_Arr;
        signal portout  : out std_logic_vector(3 downto 0);
        signal hit      : out std_logic_vector(1 downto 0);
        signal macIn    : in std_logic_vector(47 downto 0)
    ) is
        variable portoutd : std_logic_vector(3 downto 0);
        variable hitd     : std_logic_vector(1 downto 0);
        variable mac : MAC_Arr := macs;
    begin
        for i in 1 to max_port-1 loop
            if (mac(i) = macIn) then 
                portoutd := std_logic_vector(to_unsigned(i, 4));
                hitd := "11";
                exit; -- exit the loop if found
            end if;
        end loop;
        if (hitd = "00") then 
            portoutd := "0000";
            hitd := "10";
        end if;
        portout <= portoutd;
        hit <= hitd;
    end procedure;
    signal k : integer := max_port;
--processes
begin
    process (main_clk, main_rst, mac_in)
    begin
        if main_rst = '1' then
            state <= LOAD;
            port_out <= (others => '0');
            hit_flag <= "00";
            r_bit   <= 'Z';
            w_bit   <= 'Z';
        elsif rising_edge(main_clk) then
            case state is
                when LOAD =>
                    port_out <= (others => '0');
                    hit_flag <= "00";
                    macIn <= mac_in;
                    fill_cam_from_file(MAC, "macTable.txt");
                    state <= ACTIVE;
                when ACTIVE =>
                    if (r_bit = '1') then 
                        state <= READ;
                    elsif (w_bit = '1') then state <= WRITE;
                    else state <= ACTIVE;
                    end if;
                when READ =>
                    find_MAC(MAC, portOut, hitFlag, macIn);
                    if (k > 0 and hitFlag = "00") then
                        state <= READ;
                        k <= k - 1;
                    else state <= ASSIGN;
                    end if;
                when WRITE => 
                    --not now, future update;
                when ASSIGN =>
                    k <= max_port;
                    port_out <= portOut;
                    hit_Flag <= hitFlag;
                    state <= COMPLETE;
                when COMPLETE =>
                    state <= ACTIVE;
                    r_bit   <= '0';
                    w_bit   <= '0';
                when others =>
                    state <= LOAD;
                    r_bit   <= 'Z';
                    w_bit   <= 'Z';
            end case;
        end if;
    end process;
end architecture rtl;
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