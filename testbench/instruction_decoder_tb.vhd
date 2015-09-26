--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:58:36 09/26/2015
-- Design Name:   
-- Module Name:   /home/stefan/lab_comp_design/computer_design_1/instruction_decoder_tb.vhd
-- Project Name:  lab_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: instruction_decoder
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY instruction_decoder_tb IS
END instruction_decoder_tb;
 
ARCHITECTURE behavior OF instruction_decoder_tb IS 

   --Inputs
   signal instruction : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal opcode : std_logic_vector(5 downto 0);
   signal reg_a : std_logic_vector(4 downto 0);
   signal reg_b : std_logic_vector(4 downto 0);
   signal reg_d : std_logic_vector(4 downto 0);
   signal imm : std_logic_vector(15 downto 0);
   signal func : std_logic_vector(5 downto 0);
   signal jump : std_logic_vector(25 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 20 ns;
	
	procedure check (
      condition : in boolean;
      error_msg : in string) is
    begin  -- procedure check
      assert condition report error_msg severity failure;
    end procedure check;
 
BEGIN
	
	  DUT: entity instruction_decoder 
	  PORT MAP (
          instruction => instruction,
          opcode => opcode,
          reg_a => reg_a,
          reg_b => reg_b,
          reg_d => reg_d,
          imm => imm,
          func => func,
          jump => jump
        );
	
   -- Stimulus process
   instruction_decode: process
   begin		
     wait for clk_period; -- addition of positive numbers
	 instruction <= b"101000_11100_11010_00101_110_1011_0100";
    wait for clk_period;
    check(opcode = b"101000", "opcode incorrect!");
	 check(reg_a = b"11100", "reg_a incorrect!");
	 check(reg_b = b"11010", "reg_b incorrect!");
	 check(reg_d = b"00101", "reg_d incorrect!");
	 check(imm = b"0010111010110100", "imm incorrect!");
	 check(func = b"110100", "func incorrect!");
	 check(jump = b"11100110100010111010110100", "func incorrect!");
    report "Test  passed" severity note;
      
	 report "SUCCESS" severity failure;
      
   end process;

END;
