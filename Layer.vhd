----------------------------------------------------------------------------------
-- 
-- Create Date: 12.01.2021 18:34:51
-- Design Name: 
-- Module Name: Layer 
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


entity Layer is
generic(
    number_of_inputs : integer := 3;
    number_of_neurons : integer := 3
);
port(
    clk : in std_logic;
    rst : in std_logic;
    Computeinit : in std_logic;
    Input : in sfixed_bus_array(number_of_inputs-1 downto 0);
    Bias : in sfixed_bus_array(number_of_inputs-1 downto 0);
    Weight : in sfixed_bus_array(number_of_inputs*number_of_neurons-1 downto 0);
    Outputs : out sfixed_bus_array(number_of_neurons-1 downto 0);
    ComputeDone : out std_logic    
);
end Layer;

architecture Behavioral of Layer is
    
    Component Neuron is
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
        end Component;
    
    signal ComputeDoneArray : std_logic_vector(number_of_neurons-1 downto 0) := (others =>'0');

begin

    ComputeDone <= '1' when ComputeDoneArray = (number_of_neurons-1 downto 0 =>'1') else '0';
    
    index : for i in number_of_neurons-1 downto 0 generate
            Neurons : Neuron Generic Map (number_of_inputs => number_of_inputs) 
            Port map ( clk => clk, rst => rst, ComputeInit=>ComputeInit, Input=>Input,
            Weight => Weight((i+1)*number_of_inputs-1 downto (i)*number_of_inputs),
            Bias => Bias(i), Output => Outputs(i), 
            ComputeDone =>ComputeDonearray(i));
    end generate;

end architecture;
