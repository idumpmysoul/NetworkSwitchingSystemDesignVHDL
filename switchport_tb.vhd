LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY switchport_tb IS
END switchport_tb;

ARCHITECTURE behavior OF switchport_tb IS
    -- Component Declaration for Unit Under Test (UUT)
    COMPONENT switchport
        PORT (
            clk : IN STD_LOGIC;
            inout_bit : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            port_id : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            frame_out : OUT STD_LOGIC_VECTOR(167 DOWNTO 0);
            data : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            MAC_dest : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            MAC_add : INOUT STD_LOGIC_VECTOR(47 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench Signals
    SIGNAL clk_tb : STD_LOGIC := '0';
    SIGNAL inout_bit_tb : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL port_id_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL frame_out_tb : STD_LOGIC_VECTOR(167 DOWNTO 0);
    SIGNAL data_tb : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL MAC_dest_tb : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    SIGNAL MAC_add_tb : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');

    -- Reference values for comparison
    CONSTANT zero_168bit : STD_LOGIC_VECTOR(167 DOWNTO 0) := (OTHERS => '0');
    CONSTANT zero_48bit : STD_LOGIC_VECTOR(47 DOWNTO 0) := (OTHERS => '0');
    CONSTANT zero_8bit : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

    -- Clock Period Constant
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : switchport
        PORT MAP (
            clk => clk_tb,
            inout_bit => inout_bit_tb,
            port_id => port_id_tb,
            frame_out => frame_out_tb,
            data => data_tb,
            MAC_dest => MAC_dest_tb,
            MAC_add => MAC_add_tb
        );

    -- Clock Generation Process
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk_tb <= '0';
            WAIT FOR clk_period / 2;
            clk_tb <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    -- Stimulus Process
    stimulus_process : PROCESS
    BEGIN
        -- Set inout_bit to 'Z' before getting input

        inout_bit_tb <= (OTHERS => 'Z');
        WAIT FOR clk_period * 2;

        -- Test "00" (Off State)
        inout_bit_tb <= "00";
        WAIT FOR clk_period * 2;
        ASSERT frame_out_tb = zero_168bit REPORT "Frame should be zero in state 00" SEVERITY FAILURE;

        -- Test "01" (Idle State)
        inout_bit_tb <= "01";
        WAIT FOR clk_period * 2;
        ASSERT frame_out_tb = zero_168bit REPORT "Frame should be zero in state 01" SEVERITY FAILURE;

        -- Test "10" (Receive State)
        inout_bit_tb <= "10";
        WAIT FOR clk_period * 2;
        -- ASSERT inout_bit_tb = "01" REPORT "State did not transition to 01 after 10" SEVERITY FAILURE;

        -- Test "11" (Send State)
        data_tb <= X"AA"; -- Example data
        MAC_dest_tb <= X"112233445566"; -- Example destination MAC
        MAC_add_tb <= X"AABBCCDDEEFF"; -- Example source MAC
        inout_bit_tb <= "11";
        WAIT FOR clk_period * 2;

        -- Wait to ensure frame_out updates
        WAIT FOR clk_period * 2;
        ASSERT frame_out_tb /= zero_168bit REPORT "Frame_out did not update in state 11" SEVERITY FAILURE;

        -- Test Complete
        WAIT;
    END PROCESS;
END ARCHITECTURE behavior;
