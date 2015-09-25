----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:16:03 09/24/2015 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( operand_A : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           operand_B : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           result : out  STD_LOGIC_VECTOR(31 DOWNTO 0);
           zero : out  STD_LOGIC;
           control : in  STD_LOGIC_VECTOR(3 DOWNTO 0));
end alu;

architecture Behavioral of alu is
	signal a_extended, b_extended                 : std_logic_vector(32 downto 0);
	signal result_extended                        : unsigned(32 downto 0);
	--signal same_input_sign, different_result_sign  : std_logic;
	
begin
	a_extended            <= '0' & operand_A;
	b_extended            <= '0' & operand_B;
	process(control, operand_A, operand_B) is
	begin
		case control is
		when b"0010" => --load word -> add
			result_extended       <= unsigned(a_extended) + unsigned(b_extended);
			result <= std_logic_vector(result_extended(31 downto 0));
		end case;
	end process;


end Behavioral;

