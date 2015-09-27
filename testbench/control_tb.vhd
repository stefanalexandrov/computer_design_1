--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:35:23 09/27/2015
-- Design Name:   
-- Module Name:   /home/camilo/computer_design/exercise_1/computer_design_1/testbench/control_tb.vhd
-- Project Name:  sol_ex_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control
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
 
ENTITY control_tb IS
END control_tb;
 
ARCHITECTURE behavior OF control_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Opcode : IN  std_logic_vector(5 downto 0);
         start : IN  std_logic;
         RegDst : OUT  std_logic;
         Branch : OUT  std_logic;
         MemRead : OUT  std_logic;
         MemtoReg : OUT  std_logic;
         ALUop : OUT  std_logic_vector(1 downto 0);
         MemWrite : OUT  std_logic;
         ALUSrc : OUT  std_logic;
         RegWrite : OUT  std_logic;
         PCWrite : OUT  std_logic;
         Jump : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal Opcode : std_logic_vector(5 downto 0) := (others => '0');
   signal start : std_logic := '0';

 	--Outputs
   signal RegDst : std_logic;
   signal Branch : std_logic;
   signal MemRead : std_logic;
   signal MemtoReg : std_logic;
   signal ALUop : std_logic_vector(1 downto 0);
   signal MemWrite : std_logic;
   signal ALUSrc : std_logic;
   signal RegWrite : std_logic;
   signal PCWrite : std_logic;
   signal Jump : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control PORT MAP (
          clk => clk,
          rst => rst,
          Opcode => Opcode,
          start => start,
          RegDst => RegDst,
          Branch => Branch,
          MemRead => MemRead,
          MemtoReg => MemtoReg,
          ALUop => ALUop,
          MemWrite => MemWrite,
          ALUSrc => ALUSrc,
          RegWrite => RegWrite,
          PCWrite => PCWrite,
          Jump => Jump
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

	report "Test begin" severity note;
    wait for clk_period/4;
    rst <= '1';
    wait for clk_period;
	 -- in fetch state
    rst <= '0';
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'1', 	"PCWrite result incorrect!");
	 report "Test 1 passed";
	 
    wait for clk_period;
	 -- in decode state
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 Opcode <= "100011"; -- next state load_execution
	 report "Test 2 passed";
	 
	 wait for clk_period;
	 -- in load_execution state
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(ALUSrc = 	'1', 	"ALUSrc result incorrect!");
	 check(MemtoReg = '1', 	"MemtoReg result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(MemRead = 	'1', 	"MemRead result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	report "Test 3 passed";
	
    wait for clk_period;
    -- in stall_load state -> the control values remain the same as in load execution
	 -- for one more clock cycle
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(ALUSrc = 	'1', 	"ALUSrc result incorrect!");
	 check(MemtoReg = '1', 	"MemtoReg result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(MemRead = 	'1', 	"MemRead result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 report "Test 4 passed";
	 
	 wait for clk_period;
    -- in fetch state again
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'1', 	"PCWrite result incorrect!");
	 report "Test 5 passed";
	 
	  wait for clk_period;
	 -- in decode state
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 Opcode <= "101011"; -- next state store_execution
	report "Test 6 passed";
	
	 wait for clk_period;
	 -- in store _execution
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(ALUSrc = 	'1', 	"ALUSrc result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(RegWrite = '0', 	"RegWrite result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemWrite = '1', 	"MemWrite result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 report "Test 7 passed";
	 
	 wait for clk_period;
    -- in stall_store state -> the control values remain the same as in store execution
	 -- for one more clock cycle
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(ALUSrc = 	'1', 	"ALUSrc result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(RegWrite = '0', 	"RegWrite result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemWrite = '1', 	"MemWrite result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 report "Test 8 passed";
	 
	 wait for clk_period;
    -- in fetch state again
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'1', 	"PCWrite result incorrect!");
	 report "Test 9 passed";
	 
	  wait for clk_period;
	 -- in decode state
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 Opcode <= "000000"; -- next state R_execution
	report "Test 10 passed";
	
	 wait for clk_period;
	 -- in R_execution
	 check(RegDst = 	'1', 	"RegDst result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(ALUop = 	"10", "ALUop result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 report "Test 11 passed";
	 
	 
	 wait for clk_period;
    -- in fetch state again
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'1', 	"PCWrite result incorrect!");
	 report "Test 12 passed";
	 
	  wait for clk_period;
	 -- in decode state
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 Opcode <= "000100"; -- next state branch_execution
	report "Test 13 passed";
	
	 wait for clk_period;
	 -- in branch_execution
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(RegWrite = '0', 	"RegWrite result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(Branch = 	'1', 	"Branch result incorrect!");
	 check(ALUop = 	"01", "ALUop result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(PCWrite = 	'1', 	"PCWrite result incorrect!");
	 report "Test 14 passed";
	 
	 
	 wait for clk_period;
    -- in fetch state again
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'1', 	"PCWrite result incorrect!");
	 report "Test 15 passed";
	 
	  wait for clk_period;
	 -- in decode state
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(Jump = 		'0', 	"Jump result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(ALUop = 	"00", "ALUop result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(RegWrite = '1', 	"RegWrite result incorrect!");
	 check(PCWrite = 	'0', 	"PCWrite result incorrect!");
	 Opcode <= "000010"; -- next state jump_execution
	report "Test 16 passed";
	
	 wait for clk_period;
	 -- in branch_execution
	 check(RegDst = 	'0', 	"RegDst result incorrect!");
	 check(ALUSrc = 	'0', 	"ALUSrc result incorrect!");
	 check(MemtoReg = '0', 	"MemtoReg result incorrect!");
	 check(RegWrite = '0', 	"RegWrite result incorrect!");
	 check(MemRead = 	'0', 	"MemRead result incorrect!");
	 check(MemWrite = '0', 	"MemWrite result incorrect!");
	 check(Branch = 	'0', 	"Branch result incorrect!");
	 check(ALUop = 	"10", "ALUop result incorrect!");
	 check(Jump = 		'1', 	"Jump result incorrect!");
	 check(PCWrite = 	'1', 	"PCWrite result incorrect!");
	 report "Test 17 passed";
	 
	 
	 
	 wait for clk_period;
   end process;

END;
