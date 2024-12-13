# Network Switch System Design with VHDL
Network switch system design with VHDL merupakan replika dari perangkat switch pada jaringan yang didesain menggunakan bahasa VHDL. Switch akan menerima packet dari port yang dimilikinya, lalu switch akan menentukan alamat pengiriman packet berdasarkan mac-address tujuan dalam MAC table yang dimilikinya.
Model ini akan mereplikasi switch yang memiliki system buffer sederhana yang diimplementasikan pada memory dari ram tersebut.
Desain switch akan menggunakan FSM dengan microprograming yang akan berperan sebagai processor dari switch tersebut. Loop construct akan digunakan di dalam testbench bersamaan dengan procedure/functions untuk mereplikasi contoh input berupa packet yang akan diterima oleh switch.

## Rangkaian

![![Masukkan Gambar]() 1](https://i.imgur.com/soKUTU7.jpeg)  

Rangkaian ini memiliki 5 komponen yang akan berinteraksi satu sama lain, yaitu Switch, Switchport, Switch Memory, Frame encoder, dan Frame Decoder. Switch akan menjadi entity utama yang bertugas untuk menerima paket dari port-port yang ada dan menentukan port tujuan berdasarkan informasi yang terkandung di dalam paket tersebut. Switchport bertugas untuk menerima maupun mengirim frame data seperti port interface pada switch aslinya. Switch memory bertugas untuk menyimpan mac address dari setiap port interface agar switch dapat menentukan apakah mac address tujuan dari paket yang dikirim terdapat pada MAC table tersebut. Frame Decoder bertugas untuk mendecode frame yang diterima dari port dan menampilkan output berupa mac address tujuan, mac address asal, dan juga payload byte sebagai data yang dikirimkan bersamaan dengan paket tersebut. Frame encoder memiliki tugas yang berkebalikan dengan decoder. Frame encoder bertugas untuk menyusun data-data yang dimilikinya berupa mac address asal, mac address tujuan, serta payload byte yang menjadi data utama yang dikirim bersama dengan paket tersebut menjadi sebuah frame 

## State Diagram

![picture 3](https://i.imgur.com/QkMjixY.jpeg)  


Program ini memiliki 8 State. Antara lain LOAD, yang berfungsi untuk mengisi buffer dengan frame di switchport. ACTIVE merupakan state ketika switch sudah dalam keadaan aktif. DECODE merupakan state ketika switch menerima input frame dan memecahkan frame tersebut menjadi data-data seperti payload, dest. address, dan source address. SEARCH merupakan state ketika switch mencari port yang mac addressnya sesuai dengan mac address tujuan pada frame yang masuk. HOLD merupakan state ketika switch menahan data dalam signal buffer. FORWARD merupakan state ketika ada port yang ingin mengirim frame pada port lain. RECEIVE merupakan state ketika terdapat port yang menerima input dari port lain. Complete merupakan state ketika seluruh operasi telah selesai.

## Frame input

![picture 1](https://i.imgur.com/aggkayH.jpeg)  

Diagram di atas merupakan diagram yang menunjukkan pembagian dari input pada rangkaian ini, yaitu frame yang merupakan data yang mengalir pada layer 2 jaringan, lebih tepatnya pada switch. Untuk program ini, perubahan hanya terletak pada Destination MAC address, Src MAC address, dan Payload. Data-data lainnya seperti Preamble, SFD, IPv4 init, dan initial FCS akan dibuat constant. Destination mac address merupakan mac address tujuan yang disimpan pada frame. Src MAC address merupakan mac address asal paket tersebut dikirim, dan Payload merupakan data utama yang dikirimkan antar device.

## Snippet Code

### Switch

Entity top level yang akan menyatukan semua komponen-komponen lainnya seperti switchport, SwRAM, dan frame-decoder. Alur pengiriman paket akan dijalankan dengan menggunakan FSM (Finite State Machine) dengan state[masukkan state yang ada]

```vhdl
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
                    temp_src_port <= STD_LOGIC_VECTOR(to_unsigned(buffer_index, 4));
                    decode_frame <= buffer_frame(2015 DOWNTO 1848);
                    sent_frame <= buffer_frame(2015 DOWNTO 1848);
                    state <= DECODE;
                WHEN DECODE =>
                    IF (decode_frame = zeros) THEN
                        state <= COMPLETE;
                    ELSIF (decode_frame(167) = 'U') THEN
                        state <= COMPLETE;
                    ELSE
                        state <= SEARCH;
                    END IF;
                    buffer_frame(2015 DOWNTO 0) <= buffer_frame(1847 DOWNTO 0) & zeros; --shift left
                WHEN SEARCH =>
                    enable <= '1';
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
                            temp_fa02_DataIn <= temp_payload;
                        END IF;

                        IF (temp_src_port /= "0011") THEN
                            fa03_DataIn <= temp_payload;
                            temp_fa03_DataIn <= temp_payload;
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
                                    temp_fa02_DataIn <= temp_payload;
                                END IF;

                            WHEN "0011" =>
                                IF (temp_src_port /= "0011") THEN
                                    fa03_DataIn <= temp_payload;
                                    temp_fa03_DataIn <= temp_payload;
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
                    buffer_index <= buffer_index + 1;
                    if (buffer_index = port_num) then state <= LOAD;
                    else state <= ACTIVE;
                    end if;
            END CASE;
        END IF;
    END PROCESS;
```

### Switchport

komponen yang akan bertugas seperti port pada switch asli. Berfungsi untuk menerima frame dari port lain maupun mengirimkan frame kepada port lainnya.

```vhdl
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
```

### Switch memory

komponen yang memiliki fungsi seperti MAC table pada address. bertugas untuk menyimpan mac address tiap port serta menentukan apakah frame yang diterima switch memiliki mac address tujuan yang terdapat pada MAC table switch tersebut.

```vhdl
    process (main_clk, mac_find)
    begin
        if main_rst = '1' then
            state <= LOAD;
            port_out <= (others => '0');
            hit_flag <= "00";
        elsif rising_edge(main_clk) then
            case state is
                when LOAD =>
                    port_out <= (others => '0');
                    hit_flag <= "00";
                    macIn <= mac_find;
                    fill_cam_from_file(MAC, "macTable.txt");
                    state <= ACTIVE;
                when ACTIVE => --constantly in read mode if not write
                    if (rw_bit = '0') then 
                        state <= READ;
                    elsif (rw_bit = '1') then state <= WRITE;
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
                    state <= ASSIGN;
                    --not now, future update;
                when ASSIGN =>
                    k <= max_port;
                    port_out <= portOut;
                    hit_Flag <= hitFlag;
                    state <= COMPLETE;
                when COMPLETE =>
                    state <= ACTIVE;
            end case;
        end if;
    end process;
```

### Frame Decoder

komponen yang bertugas untuk mendecode frame yang diterima sehingga switch akan memiliki mac address tujuan serta mac address asal sehingga switch dapat menentukan port mana yang menjadi tujuan dari paket tersebut.

```vhdl
  process (frame_in)
  begin
    dest_mac <= frame_in(151 downto 104); 
    src_mac <= frame_in(103 downto 56);
    payload_byte <= frame_in(39 downto 32);
  end process;
```

### Frame Encoder

berkebalikan dengan frame decoder, frame encoder akan menyusun data-data yang dimiliki seperti mac address asal, mac address tujuan, dan data payload menjadi 1 frame utuh.

```vhdl
-- Logika untuk Frame Encoder 
begin
  process (dest_mac, payload_byte)
  begin
    frame_out <= "0101010110101011" & dest_mac & src_mac & "0000100000000000" & payload_byte & "11111111111111111111111111111111"; -- Gathering all the fields of the frame
  end process;
```