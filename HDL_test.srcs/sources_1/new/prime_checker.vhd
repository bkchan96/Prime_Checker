
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.NUMERIC_STD.ALL;

entity prime_checker is
    Generic (N : natural := 32;
             number_of_modules : integer := 280);
    Port ( clk, reset, go : in STD_LOGIC;
           number, start : in STD_LOGIC_VECTOR (N-1 downto 0);
           done : out STD_LOGIC := '0';
           flag : out STD_LOGIC);
end prime_checker;

architecture Behavioral of prime_checker is
    -------------------------------------------------------------------------------------------------
    -- component declarations
    -------------------------------------------------------------------------------------------------
    
    -- declare component 
    component modulo is
        Generic (N : natural := 32);
        Port ( dividend : in  STD_LOGIC_VECTOR (N - 1 downto 0);
               divisor : in  STD_LOGIC_VECTOR (N -1 downto 0);
               go,clk : in  STD_LOGIC;
               done, divides_evenly : out  STD_LOGIC);
    end component;
    
    -------------------------------------------------------------------------------------------------
    -- declare internal connecting wires
    -------------------------------------------------------------------------------------------------
    
    -- start number array
    type start_array is array (number_of_modules-1 downto 0) of std_logic_vector (N-1 downto 0);
    signal start_internal : start_array;
    
    -- done "array"
    signal done_internal : std_logic_vector (number_of_modules-1 downto 0);
    
    -- divides_evenly "array"
    signal divides_evenly_internal : std_logic_vector (number_of_modules-1 downto 0);
    
    -- internal go signal
    signal go_internal : std_logic;
    
    -- state signal
    type state_type is (IDLE, PROCESSING, FINISHED);
    signal state : state_type := IDLE;
    
    -- one constant
    constant one : unsigned (N-1 downto 0) := to_unsigned(1,N); 
    
begin
    -------------------------------------------------------------------------------------------------
    -- instantiation and connection of modules
    -------------------------------------------------------------------------------------------------
    
    -- generate modules
    GEN_MODULO:
        for i in 0 to number_of_modules-1 generate
            MODULOX: modulo generic map (N => N)
                            port map (dividend => number,
                                      divisor => start_internal(i),
                                      go => go_internal,
                                      clk => clk,
                                      done => done_internal(i),
                                      divides_evenly => divides_evenly_internal(i));
    end generate GEN_MODULO;
    
    -- tie divides_evenly together with reduction or
    flag <= or_reduce(divides_evenly_internal);
    
    -------------------------------------------------------------------------------------------------
    -- internal state machines
    -------------------------------------------------------------------------------------------------
    
    -- run state machine
    process (clk) begin
        if rising_edge(clk) then
            case (state) is
                when IDLE =>
                    done <= '0';
                    -- initialize working values
                    start_internal(0) <= start; 
                    for i in 1 to number_of_modules-1 loop
                        if (std_logic_vector(unsigned(start) + to_unsigned(i,N)) >= number) then
                            start_internal(i) <= (others => '0');
                        else
                            start_internal(i) <= std_logic_vector(unsigned(start) + to_unsigned(i,N));
                        end if;
                    end loop;
                    -- check next state conditions
                    if (go = '1') then
                        go_internal <= '1';
                        state <= PROCESSING;
                    else
                        go_internal <= '0';
                        state <= IDLE;
                    end if;
                when PROCESSING =>
                    go_internal <= '0';
                    if (and_reduce(done_internal) = '1') then
                        state <= FINISHED;
                    else
                        state <= PROCESSING;
                    end if;
                when FINISHED =>
                    done <= '1';
                    if (reset = '1') then
                        state <= IDLE;
                    else
                        state <= FINISHED;
                    end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;
    
    
end Behavioral;
