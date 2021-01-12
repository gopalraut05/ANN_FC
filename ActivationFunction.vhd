----------------------------------------------------------------------------------
-- Create Date: 12.01.2021 16:19:55
-- Design Name: 
-- Module Name: Activation Fucntions
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.fixed_pkg.all;
use work.Types.all;

entity ActivationFunction is
port(
    clk : in std_logic;
    input : in sfixed_bus;
    output : out sfixed_bus
    );
end entity;


architecture sigmoid of ActivationFunction is

signal output_temp : sfixed_bus;

begin

output_temp <= std_logic_bus_to_sfixed_bus(sigmoid_rom(to_integer(input)));

process(clk)
begin
    if (clk'event and clk = '1') then
        output <= output_temp;
    end if;
end process;


end architecture;

