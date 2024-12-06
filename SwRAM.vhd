library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity SwRAM is --simple ram to keep MAC-Add table
    port (
        main_clk    :   in  std_logic;
        main_rst    :   in  std_logic;
        rw_bit      :   in  std_logic; --input port, so don't check
        mac_in      :   in  std_logic_vector(47 downto 0);
        port_out    :   out std_logic_vector(3 downto 0); --assuming a switch with 24 ethernet-port, so max bit is 2^5
        hit_flag    :   out std_logic_vector(1 downto 0) --if found '11', not found '10';
    );
end entity SwRAM;

architecture rtl of SwRAM is
    constant ram_size : integer := 25;
    type State_Type is (LOAD, ACTIVE, READ, ASSIGN, COMPLETE);
    signal state : State_Type := LOAD;
    type RAM_Arr is array (0 to ram_size-1) of std_logic_vector(47 downto 0);
    signal RAM : RAM_Arr := ( --initial ram value
        0 => "010101010101010101010101010101010101010101010101", --ram(0) would be the error assigned value
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
    -- Procedure to fill RAM
    procedure fill_ram_from_file(
        signal rams  : inout RAM_Arr;                      -- RAM array to be filled
        file_name  : in string                          -- File name to read from                         
    ) is
        variable ram : RAM_Arr;
        file ram_file  : text open read_mode is file_name;  
        variable line_buffer : line;                               
        variable value     : std_logic_vector(47 downto 0);
    begin
        ram(0) := "010101010101010101010101010101010101010101010101";
        for i in 1 to ram_size-1 loop
            ram(i) := (others=>'0');
        end loop;
        -- Read the file and fill the RAM
        for i in 1 to ram_size-1 loop
            if (not endfile(ram_file)) then
                readline(ram_file, line_buffer);
                read(line_buffer, value);
                ram(i) := value;
            else exit;
            end if;
        end loop;
        rams <= ram;
    end procedure;

    signal portOut     : std_logic_vector(3 downto 0);
    signal hitFlag     : std_logic_vector(1 downto 0);
    signal macIn       : std_logic_vector(47 downto 0);
    -- Procedure to find MAC
    procedure find_MAC(
        signal rams     : in RAM_Arr;
        signal portout  : out std_logic_vector(3 downto 0);
        signal hit      : out std_logic_vector(1 downto 0);
        signal macIn    : in std_logic_vector(47 downto 0)
    ) is
        variable portoutd : std_logic_vector(3 downto 0);
        variable hitd     : std_logic_vector(1 downto 0);
        variable ram : RAM_Arr := rams;
    begin
        for i in 1 to ram_size-1 loop
            if (ram(i) = "100100111100111111010011010110101100000010101101") then 
                portoutd := std_logic_vector(to_unsigned(i, 4));
                hitd := "11"    ;
            else 
                portoutd := "0000";
                hitd := "10";
            end if;
        end loop;
        portout <= portoutd;
        hit <= hitd;
    end procedure;

--processes
begin
    process (main_clk, main_rst)
    begin
        if main_rst = '1' then
            state <= LOAD;
            port_out <= (others => '0');
            hit_flag <= "00";
        elsif rising_edge(main_clk) then
            case state is
                when LOAD =>
                    macIn <= mac_in;
                    fill_ram_from_file(RAM, "arpTable.txt");
                    state <= ACTIVE;
                when ACTIVE =>
                    if (rw_bit = '1') then 
                        state <= READ;
                    else state <= ACTIVE;
                    end if;
                when READ =>
                    find_MAC(RAM, portOut, hitFlag, macIn);
                    state <= ASSIGN;
                when ASSIGN =>
                    port_out <= portOut;
                    hit_Flag <= hitFlag;
                    state <= COMPLETE;
                when COMPLETE =>
                    state <= ACTIVE;
            end case;
        end if;
    end process;
end architecture rtl;