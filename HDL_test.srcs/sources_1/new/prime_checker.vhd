
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.NUMERIC_STD.ALL;

entity prime_checker is
    Generic (N : natural := 32;
             number_of_modules : integer := 10);
    Port ( clk, go, reset : in STD_LOGIC;
           number, start : in STD_LOGIC_VECTOR (N-1 downto 0);
           done, flag : out STD_LOGIC);
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
    
    -------------------------------------------------------------------------------------------------
    -- declare internal signals/register
    -------------------------------------------------------------------------------------------------
    
    -- state signal
    type state_type is (IDLE
    
begin
    -------------------------------------------------------------------------------------------------
    -- instantiation and connection of modules
    -------------------------------------------------------------------------------------------------
    
    -- generate modules
    GEN_MODULO:
        for i in 0 to number_of_modules-1 generate
            MODULOX: modulo generic map (N => N)
                            port map (dividend => start,
                                      divisor => start_internal(i),
                                      go => go,
                                      clk => clk,
                                      done => done_internal(i),
                                      divides_evenly => divides_evenly_internal(i));
    end generate GEN_MODULO;
    
    -- tie divides_evenly together with reduction or
    flag <= or_reduce(divides_evenly_internal);
    
    -- tie done bits with reduction or
    --done <= or_reduce(done_internal);
    
    -------------------------------------------------------------------------------------------------
    -- internal state machines
    -------------------------------------------------------------------------------------------------
    
    
    
    
end Behavioral;
