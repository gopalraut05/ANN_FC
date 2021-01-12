----------------------------------------------------------------------------------
-- Create Date: 12.01.2021 16:19:55
-- Design Name: 
-- Module Name: Types package
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
use IEEE.numeric_std.all;
use work.fixed_pkg.all;

package Types is 

    type int_array is array(integer range<>) of integer;

    -- Neural Network information
    constant number_of_layers :Integer := 5;
    constant number_of_neurons_in_layer : int_array(number_of_layers-1 downto 0) := (784,256,128,128,10);
    
    constant number_of_weights : integer := 784*256*128*128*10;
    constant index_of_weights : int_array(number_of_layers-1 downto 0) := (number_of_weights,number_of_weights-784*256,number_of_weights-784*256-256*128,number_of_weights-784*256-256*128-128*128,number_of_weights-784*256-256*128-128*128-128*10);
    
    constant number_of_biases : integer := 256+128+128+10;
    constant index_of_biases : int_array(number_of_layers-1 downto 0) := (number_of_biases,number_of_biases-256,number_of_biases-258-128,number_of_biases-256-128-128,number_of_biases-256-128-128-10);
    
    constant number_of_layer_outputs : integer := 784+256+128+128+10;
    constant index_layer_output : int_array(number_of_layers downto 0) :=(number_of_layer_outputs,number_of_layer_outputs-784,number_of_layer_outputs-784-256,number_of_layer_outputs-784-256-128,number_of_layer_outputs-784-256-128-128,number_of_layer_outputs-784-256-128-128-10);
    -- The net width is of the bust i.e 1 sign bit and 8 magnitude  bits
    
    constant width : integer := 9;
    
    --bus and buss array description for std_ logic format
    subtype std_logic_bus is std_logic_vector(width-1 downto 0);
    type std_logic_bus_array is array (integer range <>) of std_logic_bus;
    
    --fixed point location details
    constant integer_part : integer := 5;
    constant fractional_part : integer := 4;
    
    --bus and bus array declarations for sfixed format
    subtype sfixed_bus is sfixed(integer_part-1 downto -fractional_part);
    type sfixed_bus_array is array (integer range<>) of sfixed_bus;
    -- Activation function rom type declaration
    
    constant sigmoid_rom : std_logic_bus_array(0 to 511) := (others=>(others=>'0'));
    
    --Type conversions
    function std_logic_bus_to_sfixed_bus(arg : std_logic_bus) return sfixed_bus; 
        
    
end package Types;
    
    
package body Types is 
    function std_logic_bus_to_sfixed_bus(arg : std_logic_bus) return sfixed_bus is
        variable result : sfixed_bus;
        begin
        result := to_sfixed(arg         => arg,
		                    left_index  => integer_part - 1,
		                    right_index => -fractional_part);
		return result;
	end function ;
end package body;
    
    
    
    
    