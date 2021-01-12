----------------------------------------------------------------------------------
-- Create Date: 12.01.2021 18:34:51
-- Design Name: 
-- Module Name: Neural Network 
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



entity Neural_Network is
generic(
    number_of_layers : Integer := number_of_layers;
    number_of_neurons_in_layer : int_array(4 downto 0) := number_of_neurons_in_layer
    );
port(
    clk : in std_logic;
    rst: in std_logic;
    ANNInit : in std_logic;
    InputLayer : in sfixed_bus_array(number_of_neurons_in_layer(number_of_layers-1) -1 downto 0);
    Weights : in sfixed_bus_array(number_of_weights-1 downto 0);
    Biases : in sfixed_bus_array(number_of_biases-1 downto 0);
    OutputLayer : out sfixed_bus_array(number_of_neurons_in_layer(0)-1 downto 0);
    ANNDone : out std_logic   
);
end Neural_Network;

architecture Neura_Network of Neural_Network is
    
    Component Layer is
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
        end Component;
    
    --signal LayerInit : std_logic_vector(number_of_layers-1 downto 0) ;
    signal LayerDone : std_logic_vector(number_of_layers-1 downto 0) := (others =>'0') ;
    signal LayerOutputs : sfixed_bus_array(number_of_layer_outputs-1 downto 0) := (others =>(others =>'0'));
    

begin
    
    LayerDone(number_of_layers-1) <= ANNInit;
    LayerOutputs(number_of_layer_outputs-1 downto number_of_layer_outputs-number_of_neurons_in_layer(number_of_layers-1) ) <= InputLayer;
    OutputLayer<=LayerOutputs(number_of_neurons_in_layer(0)-1 downto 0);
    
    Index : for i in number_of_layers-2 downto 0 generate 
        Layers : Layer Generic Map (number_of_inputs=>number_of_neurons_in_layer(i+1),number_of_neurons=>number_of_neurons_in_layer(i))
        port map ( clk =>clk, rst=>rst, ComputeInit =>LayerDone(i+1), Input => LayerOutputs((index_layer_output(i+2)-1) downto index_layer_output(i+1)),
        Bias => Biases((index_of_biases(i+1)-1) downto index_of_biases(i)), Weight =>Weights((index_of_weights(i+1)-1) downto index_of_weights(i)),
        Outputs => LayerOutputs((index_layer_output(i+1)-1) downto index_layer_output(i)),ComputeDone =>LayerDone(i)
        );
    end generate;

end architecture;
