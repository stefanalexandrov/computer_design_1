----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:50 09/26/2015 
-- Design Name: 
-- Module Name:    instruction_decoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_decoder is
    Port ( instruction : in  STD_LOGIC_VECTOR(31 downto 0);
           opcode : out  STD_LOGIC_VECTOR(5 downto 0);
           reg_a : out  STD_LOGIC_VECTOR(4 downto 0);
           reg_b : out  STD_LOGIC_VECTOR(4 downto 0);
           reg_d : out  STD_LOGIC_VECTOR(4 downto 0);
           imm : out  STD_LOGIC_VECTOR(15 downto 0);
           func : out  STD_LOGIC_VECTOR(5 downto 0);
			  jump : out  STD_LOGIC_VECTOR(25 downto 0));
end instruction_decoder;

architecture Behavioral of instruction_decoder is
	
begin
		opcode <= instruction(31 downto 26);
		reg_a <= instruction(25 downto 21);
		reg_b <= instruction(20 downto 16);
		reg_d <= instruction(15 downto 11);
		imm <= instruction(15 downto 0);
		func <= instruction(5 downto 0);
		jump <= instruction(25 downto 0);
end Behavioral;

