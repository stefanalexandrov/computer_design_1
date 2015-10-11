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
use IEEE.NUMERIC_STD.ALL;

entity instruction_manager is

  port(
    clk              : in  std_logic;
    rst              : in  std_logic;
    processor_enable : in  std_logic;
    alu_zero         : in  std_logic;
    branch           : in  std_logic;
    jump             : in  std_logic;
    pc_enable        : in  std_logic;
    branch_address   : in  std_logic_vector(31 downto 0);
    instruction_out  : out std_logic_vector(31 downto 0);
    imem_data_in     : in  std_logic_vector(31 downto 0);
    imem_address     : out std_logic_vector(31 downto 0));

end instruction_manager;

architecture Behavioral of instruction_manager is
  -- The actual value of PC
  signal PC                  : std_logic_vector(31 downto 0) := x"00000000";
  -- The Value of PC which will be updated
  signal next_PC             : std_logic_vector(31 downto 0);
  -- PC +1
  signal increment_PC        : std_logic_vector(31 downto 0);
  -- The output of the branch adress + PC
  signal out_alu             : std_logic_vector(31 downto 0);
  signal first_mux_out       : std_logic_vector(31 downto 0);
  signal jump_address        : std_logic_vector(31 downto 0);
  signal current_instruction : std_logic_vector(31 downto 0);

  

begin  -- behavioural
  increment_PC        <= std_logic_vector(unsigned(PC) + 1);  -- PC +1
  imem_address        <= PC;            -- The address of the instruction will
                                        -- be in PC
  current_instruction <= imem_data_in;
  instruction_out     <= current_instruction;
  out_alu             <= std_logic_vector(unsigned(increment_PC) + unsigned(branch_address));
  jump_address        <= next_PC(31 downto 26) & current_instruction(25 downto 0);

  -- The first mux
  with (branch and alu_zero) select
    first_mux_out <=
    increment_PC when '0',
    out_alu      when '1';

  -- The second mux
  with jump select
    next_PC <=
    first_mux_out when '0',
    jump_address  when '1';

  process(clk, rst, processor_enable) is
  begin
    if rst = '1' then
      PC <= x"00000000";
      -- if the processor is enable, if we are not reseting and if control
      -- allow it
    elsif rising_edge(clk) and processor_enable = '1' and pc_enable = '1' then
      -- PC takes the next value
      PC <= next_PC;
    end if;
  end process;
  



end Behavioral;



