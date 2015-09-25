--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:35:06 09/24/2015
-- Design Name:   
-- Module Name:   /home/stefan/lab_comp_design/computer_design_1/alu_tb.vhd
-- Project Name:  lab_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.defs.all;
use work.testutil.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alu_tb IS
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
 
   --Inputs
   signal operand_A : std_logic_vector(31 downto 0) := (others => '0');
   signal operand_B : std_logic_vector(31 downto 0) := (others => '0');
   signal control : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(31 downto 0);
   signal zero : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 20 ns;
   -- component instantiation
  DUT: entity work.alu
    port map (
			 operand_A => operand_A,
          operand_B => operand_B,
          result => result,
          zero => zero,
          control => control);
 

 
 
BEGIN
 
  -- clock generation
  --clk <= not clk after clk_period/2;

  ALU_run: process
  begin
    -- insert signal assignments here
    wait for clk_period;
	 operand_A <= x"00000001"
	 operand_B <= x"00000001"
	 control <= b"0010"
    wait for clk_period;
    check(result = x"00000002", "result incorrect!");
    report "Test 1 passed";

	end process;

END;
