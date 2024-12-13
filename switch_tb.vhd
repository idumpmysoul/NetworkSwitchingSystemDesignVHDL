LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_switch IS
END ENTITY tb_switch;

ARCHITECTURE behavior OF tb_switch IS

    -- Component declaration for the unit under test (UUT)
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

    -- Signals to connect to UUT
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

        -- Test frame on port fa01
        fa01_MAC <= X"000A0B0C0D0E";
        fa01_InoutBit <= '1';
        fa01_Payload <= X"AA";
        fa01_DestMac <= X"001A1B1C1D1E";

        WAIT FOR 100 ns;

        -- Test frame on port fa02
        fa02_MAC <= X"000F1F2F3F4F";
        fa02_InoutBit <= '1';
        fa02_Payload <= X"BB";
        fa02_DestMac <= X"002A2B2C2D2E";

        WAIT FOR 100 ns;

        -- Test frame on port fa03
        fa03_MAC <= X"001E2E3E4E5E";
        fa03_InoutBit <= '1';
        fa03_Payload <= X"CC";
        fa03_DestMac <= X"003A3B3C3D3E";

        WAIT FOR 200 ns;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
