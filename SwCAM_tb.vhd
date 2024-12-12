LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY switch_tb IS
END ENTITY switch_tb;

ARCHITECTURE behavior OF switch_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT switch
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
            fa01_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa01_inoutBits : INOUT STD_LOGIC_VECTOR (1 DOWNTO 0);
            fa01_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa01_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa01_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0);
            fa02_MAC : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa02_inoutBits : INOUT STD_LOGIC_VECTOR (1 DOWNTO 0);
            fa02_data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa02_DestMac : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa02_FrameOut : INOUT STD_LOGIC_VECTOR(167 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to UUT
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';
    SIGNAL buffer_frame : STD_LOGIC_VECTOR(2015 DOWNTO 0) := (OTHERS => '0');
    SIGNAL input_frame : STD_LOGIC_VECTOR(167 DOWNTO 0) := (OTHERS => '0');
    SIGNAL src_port : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL src_mac : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dest_port : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dest_mac : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output_payload : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa01_MAC : STD_LOGIC_VECTOR(47 DOWNTO 0) := X"000000000001";
    SIGNAL fa01_inoutBits : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL fa01_data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa01_DestMac : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa01_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa02_MAC : STD_LOGIC_VECTOR(47 DOWNTO 0) := X"000000000002";
    SIGNAL fa02_inoutBits : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL fa02_data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa02_DestMac : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa02_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0) := (OTHERS => '0');

    -- Clock generation
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: switch PORT MAP (
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

    -- Clock process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Reset the system
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';

        -- Simulate frame transmission from port 1 to port 2
        fa01_inoutBits <= "10"; -- Port 1 is in receiving state
        fa01_FrameOut <= X"000000000002112233445566000000000001"; -- Dest MAC = Port 2, Src MAC = Port 1
        WAIT FOR 20 ns;

        fa01_inoutBits <= "01"; -- Port 1 idle after sending frame
        fa02_inoutBits <= "11"; -- Port 2 in sending state
        WAIT FOR 20 ns;

        -- Observe port 2 data
        ASSERT fa02_data = X"11" REPORT "Test failed: Port 2 did not receive the expected payload!" SEVERITY FAILURE;

        WAIT FOR 100 ns;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
