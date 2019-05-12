library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity modulo is
    Generic (N : natural := 32);
    Port ( dividend : in  STD_LOGIC_VECTOR (N - 1 downto 0);
           divisor : in  STD_LOGIC_VECTOR (N -1 downto 0);
           go,clk : in  STD_LOGIC;
           done, divides_evenly : out  STD_LOGIC);
end modulo;

architecture Behavioral of modulo is
    -- Interntal Registers
    signal state : std_logic_vector(1 downto 0) :="00";
    signal Q : unsigned(2*N downto 0) := (others => '0');
    signal B : unsigned(N - 1 downto 0) := (others => '0');
    signal counter : natural:=0;
    signal remainder : STD_LOGIC_VECTOR (N-1 downto 0);
    
    -- Aliases
    alias R : unsigned(N-1 downto 0)is Q(2*N downto N + 1);
    alias R0 : std_logic is Q(N);
    alias A : unsigned(N-1 downto 0) is Q(N-1 downto 0);
    
    -- difference signal
    signal difference : unsigned(N downto 0);
    
    -- constant for comparison
    constant zero : std_logic_vector(N-1 downto 0) := (others => '0');
    
begin
    -- calculate difference
    difference <= (R & R0) - B;
    
    -- run through algorithm
    process (clk) begin
        if rising_edge(clk) then
            case (state) is
                when "00" =>
                    if(go='1') then
                        A <= unsigned(dividend);
                        B <= unsigned(divisor);
                        R <= (others => '0');
                        R0 <='0';
                        done <= '0';
                        state <= "01";
                end if;
                when "01" =>
                    counter <= N;
                    Q <= (Q(2*N-1 downto 0)&'0');
                    state <= "10";
                when "10" =>
                    if((R & R0) >= B) then 
                        Q <= (difference(N-1 downto 0)& A(N -1 downto 0)& '1');
                    else
                        Q <= (Q(2*N-1 downto 0)&'0');
                    end if;
                    if(counter = 0) then
                        done <= '1';
                        remainder <= std_logic_vector(R);
                        state <="00";
                    end if;
                    counter <= counter -1;
                when others =>
                    state <= "00";
            end case;
        end if;
    end process;
    
    -- output and check if the numbers divide evenly
    divides_evenly <= '0' when (remainder = zero) else '1';
    
end Behavioral;
