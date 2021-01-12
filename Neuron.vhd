----------------------------------------------------------------------------------
-- Create Date: 12.01.2021 18:34:51
-- Design Name: 
-- Module Name: Neuron 
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.fixed_pkg.all;
use work.Types.all;


entity Neuron is
generic(
    number_of_inputs : integer := 3
);
port(
    clk : in std_logic;
    rst : in std_logic;
    ComputeInit : in std_logic;
    Input : in sfixed_bus_array(number_of_inputs-1 downto 0);
    Weight : in sfixed_bus_array(number_of_inputs-1 downto 0);
    Bias : in sfixed_bus;
    Output : out sfixed_bus;
    ComputeDone : out std_logic
);
end Neuron;

architecture Neuron of Neuron is
    type state is (idle, RegisterInputs, Multiply, Accumulate, AFunction);
    signal CurrentState, NextState : state;
    signal input_s        : sfixed_bus_array(number_of_inputs - 1 downto 0) := 
		(others => (others => '0'));
	signal sum_s          : sfixed(integer_part downto -fractional_part)              := 
		(others => '0');
	signal mult_s         : sfixed(2 * integer_part - 1 downto -2 * fractional_part)  := 
		(others => '0');
	signal index          : integer  := number_of_inputs;
	signal weight_s       : sfixed_bus_array(number_of_inputs-1 downto 0) := Weight;
	signal bias_s         : sfixed_bus := Bias;
	signal output_s       : sfixed_bus := (others => '0');
	signal act_func_input : sfixed_bus  := resize(sum_s, integer_part - 1, -fractional_part);
	signal done_s         : std_logic := '0';
	
	Component ActivationFunction is
	   port(
        clk : in std_logic;
        input : in sfixed_bus;
        output : out sfixed_bus
        );
        end component;
	
begin

    FSM1 : process(clk,rst) is
    begin
        if rising_edge(clk) then
            if rst = '1' then 
                CurrentState<=idle;
            else
            CurrentState <= NextState;
            end if;
        end if;
        end process;
        
        FSM2 : process(CurrentState,Input,input_s, ComputeInit, weight_s, mult_s) is
        begin
            case CurrentState is
			when idle =>
				done_s <= '0';
				if ComputeInit = '1' then
					NextState <= RegisterInputs;
				else
					NextState <= CurrentState;
				end if;

			when RegisterInputs =>
				input_s <= Input;
				sum_s   <= bias_s;
				-- bias is already added to sum
				mult_s  <= (others => '0');
				index   <= number_of_inputs;

				NextState <= Multiply;

			when Multiply =>
				if index = 0 then
					NextState <= AFunction;
				else
					mult_s     <= input_s(index - 1) * weight_s(index - 1);
					mult_s <= resize(mult_s, integer_part - 1, -fractional_part);
					Nextstate <= Accumulate;
				end if;

			when Accumulate =>
				index      <= index - 1;
				sum_s      <= resize((resize(sum_s, integer_part - 1, -fractional_part) + mult_s),Integer_part-1,-fractional_part);
				NextState <= Multiply;

			when AFunction =>
				done_s     <= '1';
				NextState <= idle;

		end case;

	end process ;   
	
	Sigmoid_Activation : ActivationFunction Port map ( clk => clk, input => act_func_input, output => Output);

    ComputeDone         <= done_s;
	Output       <= output_s;
	weight_s       <= Weight;
	bias_s <= Bias;
    act_func_input <= sum_s;

end architecture;
