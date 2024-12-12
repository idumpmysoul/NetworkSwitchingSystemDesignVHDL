LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE STD.TEXTIO.ALL;  -- Import the TEXTIO library for file handling

ENTITY switch_tb IS
END ENTITY switch_tb;

ARCHITECTURE behavior OF switch_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT switch IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            buffer_frame : INOUT STD_LOGIC_VECTOR(2015 DOWNTO 0);
            input_frame : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
            src_port : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            src_mac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            dest_port : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            dest_mac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            output_payload : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            -- fa01
            fa01_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa01_inoutBits : INOUT STD_LOGIC_VECTOR (1 DOWNTO 0);
            fa01_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa01_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa01_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
            -- fa02
            fa02_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa02_inoutBits : INOUT STD_LOGIC_VECTOR (1 DOWNTO 0);
            fa02_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa02_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa02_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0)
            -- Additional fa ports fa03 to fa012 are defined similarly...
        );
    END COMPONENT;

    -- Signals for UUT connections
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL buffer_frame : STD_LOGIC_VECTOR(2015 DOWNTO 0);
    SIGNAL input_frame : STD_LOGIC_VECTOR(167 DOWNTO 0);
    SIGNAL src_port : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL src_mac : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL dest_port : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL dest_mac : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL output_payload : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    -- Signals for fa ports (just for fa01 and fa02 in this example)
    SIGNAL fa01_MAC : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL fa01_inoutBits : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL fa01_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL fa01_DestMac : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL fa01_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0);
    
    SIGNAL fa02_MAC : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL fa02_inoutBits : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL fa02_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL fa02_DestMac : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL fa02_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0);

    -- File handling signals
    FILE macTable : TEXT; -- File for reading the MAC addresses
    SHARED VARIABLE line_var : LINE; -- Line variable to hold each line of text
    SHARED VARIABLE mac_address : STRING(1 TO 48); -- 48 bits, each representing a MAC address
    SHARED VARIABLE mac_val : STD_LOGIC_VECTOR(47 DOWNTO 0); -- The MAC address in std_logic_vector format

BEGIN
    -- Instantiate the UUT
    uut : switch PORT MAP (
        clk => clk,
        reset => reset,
        buffer_frame => buffer_frame,
        input_frame => input_frame,
        src_port => src_port,
        src_mac => src_mac,
        dest_port => dest_port,
        dest_mac => dest_mac,
        output_payload => output_payload,
        fa01_MAC => fa01_MAC,
        fa01_inoutBits => fa01_inoutBits,
        fa01_data => fa01_data,
        fa01_DestMac => fa01_DestMac,
        fa01_FrameOut => fa01_FrameOut,
        fa02_MAC => fa02_MAC,
        fa02_inoutBits => fa02_inoutBits,
        fa02_data => fa02_data,
        fa02_DestMac => fa02_DestMac,
        fa02_FrameOut => fa02_FrameOut
    );

    -- Clock generation
    CLK_PROC : PROCESS
    BEGIN
        clk <= NOT clk;
        WAIT FOR 10 ns;
    END PROCESS;

    -- Reset the system
    RESET_PROC : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        WAIT FOR 100 ns;
    END PROCESS;

    -- Read MAC table from the file and assign to fa01_MAC to fa012_MAC
    MAC_TABLE_PROC : PROCESS
    BEGIN
        -- Open the macTable.txt file
        FILE_OPEN(macTable, "macTable.txt", READ_MODE);

        -- Read and assign MAC addresses to each port (fa01_MAC to fa012_MAC)
        FOR i IN 1 TO 12 LOOP
            -- Read a line (MAC address) from the file
            READLINE(macTable, line_var);
            READ(line_var, mac_address);  -- Read the MAC address as a string

            -- Convert the string (binary) to a std_logic_vector for the MAC address
            mac_val := (OTHERS => '0'); -- Initialize to zero

            -- Convert the 48-character string (binary) to std_logic_vector (48-bits)
            FOR j IN 0 TO 47 LOOP
                IF mac_address(j + 1) = '1' THEN
                    mac_val(j) := '1';
                ELSE
                    mac_val(j) := '0';
                END IF;
            END LOOP;

            -- Assign to the corresponding port's MAC address
            CASE i IS
                WHEN 1 => fa01_MAC <= mac_val;
                WHEN 2 => fa02_MAC <= mac_val;
                -- Add the same for other fa ports fa03 to fa012 if needed
                WHEN OTHERS => NULL;
            END CASE;
        END LOOP;
        -- Close the file
        FILE_CLOSE(macTable);
        WAIT;
    END PROCESS;

    -- Assign random values to fa02_data and fa02_DestMac
    RANDOM_INPUT_PROC : PROCESS
    BEGIN
        WAIT FOR 50 ns;

        -- Assign random data to fa02_data
        fa02_data <= X"AA"; -- Random 8-bit data for example
        fa02_DestMac <= fa01_MAC; -- Set fa02 destination MAC to fa01 MAC

        WAIT FOR 50 ns;

        -- Now try random values in fa01
        fa01_DestMac <= X"00C0C0C0C0C0"; -- Random destination MAC
        fa01_data <= X"BB"; -- Random data

        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;