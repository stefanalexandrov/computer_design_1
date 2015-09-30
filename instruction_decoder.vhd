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
    Port ( clk : in std_logic;
			  rst : in std_logic;
			  instruction : in  STD_LOGIC_VECTOR(31 downto 0);
           opcode : out  STD_LOGIC_VECTOR(5 downto 0);
           reg_a : out  STD_LOGIC_VECTOR(4 downto 0);
           reg_b : out  STD_LOGIC_VECTOR(4 downto 0);
           reg_d : out  STD_LOGIC_VECTOR(4 downto 0);
           imm : out  STD_LOGIC_VECTOR(15 downto 0);
           func : out  STD_LOGIC_VECTOR(5 downto 0);
			  jump_addr : out  STD_LOGIC_VECTOR(25 downto 0));
end instruction_decoder;

architecture Behavioral of instruction_decoder is
		signal instruction_in:  STD_LOGIC_VECTOR(31 downto 0);
begin
		process(clk, rst) is

		begin
			 if rst = '1' then
				instruction_in <= x"00000000";
			 elsif rising_edge(clk) then
				instruction_in <= instruction;
			 end if;
		end process;
		
		opcode <= instruction_in(31 downto 26);
		reg_a <= instruction_in(25 downto 21);
		reg_b <= instruction_in(20 downto 16);
		reg_d <= instruction_in(15 downto 11);
		imm <= instruction_in(15 downto 0);
		func <= instruction_in(5 downto 0);
		jump_addr <= instruction_in(25 downto 0);
		
end Behavioral;

