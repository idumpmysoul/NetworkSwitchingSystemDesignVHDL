LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY switch_tb IS
END ENTITY switch_tb;

ARCHITECTURE behavior OF switch_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT switch
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            rw_bit_in : IN STD_LOGIC;
            sent_frame : OUT STD_LOGIC_VECTOR(167 DOWNTO 0);
            src_port : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            src_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            dest_port : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            dest_mac : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            output_payload : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa01_MAC : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa01_InoutBit : IN STD_LOGIC;
            fa01_Payload : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa01_DataIn : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa01_DestMac : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa01_FrameOut : OUT STD_LOGIC_VECTOR(167 DOWNTO 0);
            fa02_MAC : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa02_InoutBit : IN STD_LOGIC;
            fa02_Payload : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa02_DataIn : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa02_DestMac : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa02_FrameOut : OUT STD_LOGIC_VECTOR(167 DOWNTO 0);
            fa03_MAC : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa03_InoutBit : IN STD_LOGIC;
            fa03_Payload : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa03_DataIn : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            fa03_DestMac : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            fa03_FrameOut : OUT STD_LOGIC_VECTOR(167 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for the UUT
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL rw_bit_in : STD_LOGIC := '0';
    SIGNAL sent_frame : STD_LOGIC_VECTOR(167 DOWNTO 0);
    SIGNAL src_port : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL src_mac : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL dest_port : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL dest_mac : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL output_payload : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL fa01_MAC : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa01_InoutBit : STD_LOGIC := '0';
    SIGNAL fa01_Payload : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa01_DataIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL fa01_DestMac : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa01_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0);
    SIGNAL fa02_MAC : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa02_InoutBit : STD_LOGIC := '0';
    SIGNAL fa02_Payload : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa02_DataIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL fa02_DestMac : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa02_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0);
    SIGNAL fa03_MAC : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa03_InoutBit : STD_LOGIC := '0';
    SIGNAL fa03_Payload : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa03_DataIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL fa03_DestMac : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fa03_FrameOut : STD_LOGIC_VECTOR(167 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: switch PORT MAP (
        clk => clk,
        reset => reset,
        rw_bit_in => rw_bit_in,
        sent_frame => sent_frame,
        src_port => src_port,
        src_mac => src_mac,
        dest_port => dest_port,
        dest_mac => dest_mac,
        output_payload => output_payload,
        fa01_MAC => fa01_MAC,
        fa01_InoutBit => fa01_InoutBit,
        fa01_Payload => fa01_Payload,
        fa01_DataIn => fa01_DataIn,
        fa01_DestMac => fa01_DestMac,
        fa01_FrameOut => fa01_FrameOut,
        fa02_MAC => fa02_MAC,
        fa02_InoutBit => fa02_InoutBit,
        fa02_Payload => fa02_Payload,
        fa02_DataIn => fa02_DataIn,
        fa02_DestMac => fa02_DestMac,
        fa02_FrameOut => fa02_FrameOut,
        fa03_MAC => fa03_MAC,
        fa03_InoutBit => fa03_InoutBit,
        fa03_Payload => fa03_Payload,
        fa03_DataIn => fa03_DataIn,
        fa03_DestMac => fa03_DestMac,
        fa03_FrameOut => fa03_FrameOut
    );

    -- Clock process definition
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
        -- Reset the switch
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';

        -- Test case 1: Sending a frame from port 1
        fa01_MAC <= x"112233445566";
        fa01_InoutBit <= '1';
        fa01_Payload <= x"AA";
        fa01_DestMac <= x"AABBCCDDEEFF";
        WAIT FOR 50 ns;

        -- Test case 2: Sending a frame from port 2
        fa02_MAC <= x"223344556677";
        fa02_InoutBit <= '1';
        fa02_Payload <= x"BB";
        fa02_DestMac <= x"FFAABBCCDDEE";
        WAIT FOR 50 ns;

        -- Test case 3: Broadcast scenario
        fa03_MAC <= x"334455667788";
        fa03_InoutBit <= '1';
        fa03_Payload <= x"CC";
        fa03_DestMac <= x"FFFFFFFFFFFF";
        WAIT FOR 50 ns;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
