library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity SwCAM is --simple cam to buffer;
    port (
        main_clk    :   in  std_logic;
        main_rst    :   in  std_logic;
        enable      :   in  std_logic;
        rw_bit      :   in  std_logic;
        mac_find    :   in  std_logic_vector(47 downto 0);
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
            else hitd := "00";
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
                    fill_cam_from_file(MAC, "macTable.txt");
                    state <= ACTIVE;
                when ACTIVE => --constantly in read mode if not write
                    macIn <= mac_find;
                    if (enable = '1') then
                        if (rw_bit = '0') then 
                            state <= READ;
                        else state <= WRITE;
                        end if;
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
end architecture rtl;