library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity modulo_test is
end modulo_test;

architecture Behavioral of modulo_test is
    COMPONENT modulo
        Generic (N : natural := 32);
        PORT(
             dividend : IN  std_logic_vector(3 downto 0);
             divisor : IN  std_logic_vector(3 downto 0);
             go : IN  std_logic;
             clk : IN  std_logic;
             done, divides_evenly : out  STD_LOGIC);
    END COMPONENT;
    
    --Inputs
    signal dividend : std_logic_vector(3 downto 0) := (others => '0');
    signal divisor : std_logic_vector(3 downto 0) := (others => '0');
    signal go : std_logic := '0';signal clk : std_logic := '0';
    
    --Outputs
    signal done, divides_evenly : std_logic;
    signal result : std_logic_vector(3 downto 0);
    
    -- Clock period definitions
    constant clk_period : time := 0.5 ns;
    
    begin
        uut: modulo generic map (N => 4) PORT MAP (dividend => dividend, divisor => divisor, go => go, clk => clk, done => done, divides_evenly => divides_evenly);
        
        clk_process :process begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
        
        stim_proc: process begin        
            -- hold reset state for 100 ms.    
            dividend <= "0000"; divisor<="0000"; go <= '0'; wait for clk_period*10;
            dividend <= "1111"; divisor<="0100"; go <= '1';wait for clk_period;
            go <= '0';  wait for clk_period*15;
            dividend <= "0111"; divisor<="0011"; go <= '1';
            wait for clk_period;
            go <= '0';
            wait for clk_period*15;
            dividend <= "1111"; divisor<="0101"; go <= '1';
            wait for clk_period;
            go <= '0';
            wait for clk_period*15;
            dividend <= "1111"; divisor<="0000"; go <= '1';
            wait for clk_period;
            go <= '0'; 
            wait for clk_period*15;
            wait;
        end process;

end Behavioral;
