
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity prime_checker_test is
--  Port ( );
end prime_checker_test;

architecture Behavioral of prime_checker_test is
    -- declare component
    component prime_checker is
        Generic (N : natural := 32;
                 number_of_modules : integer := 10);
        Port ( clk, reset,  go : in STD_LOGIC;
               number, start : in STD_LOGIC_VECTOR (N-1 downto 0);
               done, flag : out STD_LOGIC);
    end component;
    
    -- declare test signals
    signal clk, go, reset, done, flag : std_logic;
    signal number, start : std_logic_vector(31 downto 0);
    
begin
    -- instantitate device-under-test
    DUT: prime_checker generic map (N => 32, number_of_modules => 100)
                       port map (clk => clk, reset => reset, go => go, number => number, start => start, done => done, flag => flag);
    
    -- generate clock
    process begin
        clk <= '1';
        loop
            wait for 5ns;
            clk <= not clk;
        end loop;
    end process;
    
    -- begin test routine
    process begin
        reset <= '0';
        number <= std_logic_vector(to_unsigned(89,32));
        start <= std_logic_vector(to_unsigned(2,32));
        go <= '0';
        wait for 10ns;
        go <= '1';
        wait for 10ns;
        go <= '0';
        wait for 800ns;
        reset <= '1';
        wait for 10ns;
        reset <= '0';
        number <= std_logic_vector(to_unsigned(97,32));
        start <= std_logic_vector(to_unsigned(2,32));
        wait for 10ns;
        go <= '1';
        wait for 10ns;
        go <= '0';
        wait;
    end process;
    
end Behavioral;
