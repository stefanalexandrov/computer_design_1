----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:35:09 09/26/2015 
-- Design Name: 
-- Module Name:    control - Behavioral 
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

entity control is
    Port ( 	
		clk 			: IN		STD_LOGIC;
		rst 			: IN		STD_LOGIC;
		Opcode 		: IN 		STD_LOGIC_VECTOR( 5 DOWNTO 0 );
		start			: IN		STD_LOGIC;
		RegDst 		: OUT 	STD_LOGIC;
		Branch 		: OUT 	STD_LOGIC;
		MemRead 		: OUT 	STD_LOGIC;
		MemtoReg 	: OUT 	STD_LOGIC;
		ALUop 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		MemWrite 	: OUT 	STD_LOGIC;
		ALUSrc 		: OUT 	STD_LOGIC;
		RegWrite 	: OUT 	STD_LOGIC;
		PCWrite		: OUT 	STD_LOGIC;
		Jump			: OUT    STD_LOGIC); -- write enable for the pc
end control;

architecture Behavioral of control is

type   state_t is (FETCH, DECODE, LOAD_EXECUTION, STORE_EXECUTION, R_EXECUTION,
		BRANCH_EXECUTION, JUMP_EXECUTION, STALL_LOAD, STALL_STORE);  -- the name of the states
		
  -- Fill in type and signal declarations here.
  signal current_state, next_state : state_t;  -- The current and the next step

function fetch_transition(start : std_logic) return state_t is
  begin
    if start = '1' then
      return DECODE;
    else
      return FETCH;
    end if;
  end fetch_transition;
  
  

function decode_transition(Opcode : STD_LOGIC_VECTOR( 5 DOWNTO 0 )) return state_t is
  begin
    if Opcode = "100011" then -- if the instruction is lw
      return LOAD_EXECUTION;
	 elsif Opcode = "101011" then -- if the instruction is sw
      return STORE_EXECUTION;
	 elsif Opcode = "000000" then -- if the instruction is R type
      return R_EXECUTION;
	 elsif Opcode = "000100" then -- if the instruction is beq 
      return BRANCH_EXECUTION;
	 elsif Opcode = "000010" then -- if the instruction is jump 
      return JUMP_EXECUTION;
    else
      return FETCH;
    end if;
  end decode_transition;



begin-- architecture behavioural

--FETCH, DECODE, LOAD_EXECUTION, STORE_EXECUTION, R_EXECUTION,
	--	BRANCH_EXECUTION, JUMP_EXECUTION, STALL
	
with current_state select
    next_state <=
    --fetch_transition(start)        		when FETCH,
	 DECODE						        		when FETCH,
    decode_transition(Opcode)		  		when DECODE,
    STALL_LOAD								  	when LOAD_EXECUTION,
    STALL_STORE	                     when STORE_EXECUTION,
    FETCH				                  when R_EXECUTION,
    FETCH                        		when BRANCH_EXECUTION,
    FETCH                    				when JUMP_EXECUTION,
	 FETCH                    				when STALL_LOAD,
	 FETCH                    				when STALL_STORE;



--FETCH, DECODE, LOAD_EXECUTION, STORE_EXECUTION, R_EXECUTION,
	--	BRANCH_EXECUTION, JUMP_EXECUTION, STALL


  process(current_state) is
  begin
	
		RegDst 	<= '0';
		Branch 	<= '0';
		Jump	   <= '0';
		MemRead 	<= '0';
		MemtoReg <= '0';
		ALUop 	<= "00";	
		MemWrite <= '0';	
		ALUSrc 	<= '0';
		RegWrite <= '0';
		PCWrite  <= '0';
		
    case current_state is
      when FETCH =>
       -- IR = memory(PC)
		 -- pc = pc +4

			
			
			
			
			RegDst 	<= '0';  -- 0 The register destination number for the Write register comes from the rt field (bits 20:16).
			ALUSrc 	<= '0';  -- 0 The second ALU operand comes from the second register file output (Read data 2).
			MemtoReg <= '0';  -- 0 The value fed to the register Write data input comes from the ALU.
			RegWrite <= '1';  -- 0 None.
			MemRead 	<= '0';  -- 0 None.
			MemWrite <= '0';  -- 0 None.
			Branch 	<= '0'; 
			ALUop 	<= "00"; -- alu control		
			
			Jump	   <= '0';
			PCWrite  <= '1';--enable PC write?	
			
		  
      when DECODE =>
			-- performs actions being either applicable to all instructions
			-- or not harmful to any isntructions
			-- -> Read operand registers specified by rs and rt
			-- -> after this state, the function decode_transition determines which is the next 
			-- state based on the current state
			
			RegDst 	<= '0';
			Branch 	<= '0'; 
			Jump	   <= '0';
			MemRead 	<= '0';
			MemtoReg <= '0';
			ALUop 	<= "00";	
			MemWrite <= '0';	
			ALUSrc 	<= '0';
			RegWrite <= '1'; -- the register file can be written
			PCWrite  <= '0'; -- the pc can be written
			
			
       
      when LOAD_EXECUTION =>
       
		 
			RegDst 	<= '0';  -- 0 The register destination number for the Write register comes from the rt field (bits 20:16).
			ALUSrc 	<= '1';  -- 0 The second ALU operand comes from the second register file output (Read data 2).
			MemtoReg <= '1';  -- 0 The value fed to the register Write data input comes from the ALU.
			RegWrite <= '1';  -- 0 None.
			MemRead 	<= '1';  -- 0 None.
			MemWrite <= '0';  -- 0 None.
			Branch 	<= '0'; 
			ALUop 	<= "00"; -- alu control		
			
			Jump	   <= '0';
			PCWrite  <= '0';--enable PC write?			
			
		 
			
			
      when STORE_EXECUTION =>
		
			RegDst 	<= '0';  -- dont care
			ALUSrc 	<= '1';  -- 0 The second ALU operand comes from the second register file output (Read data 2).
			MemtoReg <= '0';  -- dont care
			RegWrite <= '0';  -- 0 None.
			MemRead 	<= '0';  -- 0 None.
			MemWrite <= '1';  -- 0 None.
			Branch 	<= '0'; 
			ALUop 	<= "00"; -- alu control		
			
			Jump	   <= '0';
			PCWrite  <= '0';--enable PC write?	
		
		
		when R_EXECUTION =>
		
			RegDst 	<= '1';  -- 0 The register destination number for the Write register comes from the rt field (bits 20:16).
			ALUSrc 	<= '0';  -- 0 The second ALU operand comes from the second register file output (Read data 2).
			MemtoReg <= '0';  -- 0 The value fed to the register Write data input comes from the ALU.
			RegWrite <= '1';  -- 0 None.
			MemRead 	<= '0';  -- 0 None.
			MemWrite <= '0';  -- 0 None.
			Branch 	<= '0'; 
			ALUop 	<= "10"; -- alu control		
			
			Jump	   <= '0';
			PCWrite  <= '0';--enable PC write?	
		
		
      when BRANCH_EXECUTION =>
		
			RegDst 	<= '0';  -- do not care
			ALUSrc 	<= '0';  -- 0 The second ALU operand comes from the second register file output (Read data 2).
			MemtoReg <= '0';  -- do not care
			RegWrite <= '0';  -- 0 None.
			MemRead 	<= '0';  -- 0 None.
			MemWrite <= '0';  -- 0 None.
			Branch 	<= '1'; 
			ALUop 	<= "01"; -- alu control		
			
			Jump	   <= '0';
			PCWrite  <= '1';  --enable PC write?	
		
		when JUMP_EXECUTION =>
		
			RegDst 	<= '0';  -- 0 The register destination number for the Write register comes from the rt field (bits 20:16).
			ALUSrc 	<= '0';  -- 0 The second ALU operand comes from the second register file output (Read data 2).
			MemtoReg <= '0';  -- 0 The value fed to the register Write data input comes from the ALU.
			RegWrite <= '0';  -- 0 None.
			MemRead 	<= '0';  -- 0 None.
			MemWrite <= '0';  -- 0 None.
			Branch 	<= '0'; 
			ALUop 	<= "10"; -- do not care, alu control		
			
			Jump	   <= '1';
			PCWrite  <= '1';  --enable PC write?
		
		when STALL_LOAD =>
			RegDst 	<= '0';  -- 0 The register destination number for the Write register comes from the rt field (bits 20:16).
			ALUSrc 	<= '1';  -- 0 The second ALU operand comes from the second register file output (Read data 2).
			MemtoReg <= '1';  -- 0 The value fed to the register Write data input comes from the ALU.
			RegWrite <= '1';  -- 0 None.
			MemRead 	<= '1';  -- 0 None.
			MemWrite <= '0';  -- 0 None.
			Branch 	<= '0'; 
			ALUop 	<= "00"; -- alu control		
			
			Jump	   <= '0';
			PCWrite  <= '0';--enable PC write?		

		when STALL_STORE =>
			RegDst 	<= '0';  -- dont care
			ALUSrc 	<= '1';  -- 0 The second ALU operand comes from the second register file output (Read data 2).
			MemtoReg <= '0';  -- dont care
			RegWrite <= '0';  -- 0 None.
			MemRead 	<= '0';  -- 0 None.
			MemWrite <= '1';  -- 0 None.
			Branch 	<= '0'; 
			ALUop 	<= "00"; -- alu control		
			
			Jump	   <= '0';
			PCWrite  <= '0';--enable PC write?						
	
      when others =>
        null;
    end case;
  end process;
  
  
process(clk, rst) is
    -- this process allow to go to a next state or reset the FSM
  begin
    if rst = '1' then
      current_state <= FETCH;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;
  



end Behavioral;
