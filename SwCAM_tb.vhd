library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_SwCAM is
end entity tb_SwCAM;

architecture behavior of tb_SwCAM is
    -- Component declaration for the DUT (Device Under Test)
    component SwCAM
        port (
            main_clk    : in  std_logic;
            main_rst    : in  std_logic;
            rw_bit      : in  std_logic;
            mac_find    : in  std_logic_vector(47 downto 0);
            port_out    : out std_logic_vector(3 downto 0);
            hit_flag    : out std_logic_vector(1 downto 0)
        );
    end component;

    -- Signals for the DUT inputs
    signal main_clk    : std_logic := '0';
    signal main_rst    : std_logic := '1';
    signal rw_bit      : std_logic := '0';
    signal mac_find    : std_logic_vector(47 downto 0) := (others => '0');

    -- Signals for the DUT outputs
    signal port_out    : std_logic_vector(3 downto 0);
    signal hit_flag    : std_logic_vector(1 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the DUT
    uut: SwCAM
        port map (
            main_clk    => main_clk,
            main_rst    => main_rst,
            rw_bit      => rw_bit,
            mac_find    => mac_find,
            port_out    => port_out,
            hit_flag    => hit_flag
        );

    -- Clock generation process
    clk_process : process
    begin
        while true loop
            main_clk <= '0';
            wait for clk_period / 2;
            main_clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Reset the system
        main_rst <= '1';
        wait for 20 ns;
        main_rst <= '0';

        -- Wait for system to load
        wait for 50 ns;

        -- Test Case 1: Find existing MAC address
        mac_find <= "001100010110101100000100110010111111010001010000"; 
        rw_bit <= '0'; -- Read mode
        wait for 50 ns;
        assert (hit_flag = "11") report "Test Case 1 Failed: MAC not found!" severity error;
        assert (port_out = "0001") report "Test Case 1 Failed: Incorrect port output!" severity error;

        -- Test Case 2: Find non-existing MAC address
        mac_find <= "001100010111101100000111110010111111010001010011"; -- Non-existent MAC
        wait for 50 ns;
        assert (hit_flag = "10") report "Test Case 2 Failed: MAC found incorrectly!" severity error;
        assert (port_out = "0000") report "Test Case 2 Failed: Incorrect port output!" severity error;

        -- Future cases like WRITE mode can be added here

        -- Stop simulation
        wait;
    end process;

end architecture behavior;
