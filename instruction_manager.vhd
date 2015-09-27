library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_manager is

  port(
    clk             : in  std_logic;
    rst             : in  std_logic;
    alu_zero        : in  std_logic;
    branch          : in  std_logic;
    jump            : in  std_logic;
    branch_address   : in  std_logic_vector(31 downto 0);
    instruction_out : out std_logic_vector(31 downto 0);
    imem_data_in    : in  std_logic_vector(31 downto 0);
    imem_address    : out std_logic_vector(31 downto 0));

end entity instruction_manager;

architecture behavioural of instruction_manager is
  signal PC                  : std_logic_vector(31 downto 0) := x"00000000";
  signal next_PC             : std_logic_vector(31 downto 0);
  signal increment_PC        : std_logic_vector(31 downto 0);
  signal out_alu             : std_logic_vector(31 downto 0);
  signal first_mux_out       : std_logic_vector(31 downto 0);
  signal jump_address         : std_logic_vector(31 downto 0);
  signal current_instruction : std_logic_vector(31 downto 0);

  

begin  -- behavioural
  increment_PC        <= std_logic_vector(unsigned(PC) + 1);  -- PC +1
  imem_address        <= PC;
  current_instruction <= imem_data_in;
  instruction_out     <= current_instruction;
  out_alu             <= std_logic_vector(unsigned(increment_PC) + unsigned(branch_address));
  jump_address         <= current_instruction(25 downto 0) & next_PC(31 downto 26);

  with (branch and alu_zero) select
    first_mux_out <=
    increment_PC when '0',
    out_alu      when '1';

  with jump select
    next_PC <=
    first_mux_out when '0',
    jump_address   when '1';

  process(clk, rst) is
  begin
    if rst = '1' then
      PC <= x"00000000";
    elsif rising_edge(clk) then
      PC <= next_PC;
    end if;
  end process;
end behavioural;

