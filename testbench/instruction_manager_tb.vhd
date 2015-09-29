library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_manager_tb is
  
end instruction_manager_tb;

architecture behaviour of instruction_manager_tb is
  	constant ADDR_WIDTH : integer := 8;
	constant DATA_WIDTH : integer := 32;

         signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal processor_enable : std_logic := '0';
   signal imem_data_in : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
   signal imem_address : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
   signal imem_data_out : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
   signal imem_write_enable : std_logic_vector(0 downto 0) := (others => '0');
   signal tb_address : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal alu_zero : std_logic;
   signal branch : std_logic;
   signal jump : std_logic;
   signal branch_address   :  std_logic_vector(31 downto 0);
   signal instruction_out : std_logic_vector(31 downto 0);
   signal PC_to_memory : std_logic_vector(31 downto 0) := x"00000000";
        
   constant clk_period : time := 10 ns;
    procedure check (
      condition : in boolean;
      error_msg : in string) is
    begin  -- procedure check
      assert condition report error_msg severity failure;
    end procedure check;
begin  -- behaviour
  
  
  InstrMem: entity work.DualPortMem port map(
    clka => clk, clkb => clk,
    wea => imem_write_enable,
    dina => imem_data_out,
    addra => imem_address,
    douta => imem_data_in,
    web => "0",
    dinb => x"00",
    addrb => "0000000000");

  IntrManager : entity work.instruction_manager port map (
    clk => clk,
    rst => reset,
    alu_zero => alu_zero,
    branch => branch,
    jump => jump,
    branch_address => branch_address,
    instruction_out => instruction_out,
    imem_data_in => imem_data_in,
    imem_address => PC_to_memory);
    
  with processor_enable select
    imem_address <= 
    tb_address when '0',
    std_logic_vector(PC_to_memory(7 downto 0)) when '1';

    -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

  stim_proc: process
    procedure WriteInstr (
      instruction : in std_logic_vector(31 downto 0);
      address : in unsigned(ADDR_WIDTH-1 downto 0)) is
      begin
        tb_address <= std_logic_vector(address);
        imem_data_out <= instruction;
        imem_write_enable <= "1";
        wait until rising_edge(clk);
        imem_write_enable <= "0";
      end WriteInstr;

      procedure FillInstrMemory is
        begin
          WriteInstr(x"11111111", to_unsigned(0, ADDR_WIDTH));
          WriteInstr(x"22222222", to_unsigned(1, ADDR_WIDTH));
          WriteInstr(x"33333333", to_unsigned(2, ADDR_WIDTH));
          WriteInstr(x"44444444", to_unsigned(3, ADDR_WIDTH));
          WriteInstr(x"55555555", to_unsigned(4, ADDR_WIDTH));
          WriteInstr(x"00000000", to_unsigned(5, ADDR_WIDTH));  --jump to
                                                                --address 11
          WriteInstr(x"77777777", to_unsigned(6, ADDR_WIDTH));
          WriteInstr(x"88888888", to_unsigned(7, ADDR_WIDTH));
          WriteInstr(x"99999999", to_unsigned(8, ADDR_WIDTH));
          WriteInstr(x"AAAAAAAA", to_unsigned(9, ADDR_WIDTH));
          WriteInstr(x"BBBBBBBB", to_unsigned(10, ADDR_WIDTH));
          WriteInstr(x"CCCCCCCC", to_unsigned(11, ADDR_WIDTH));
          WriteInstr(x"DDDDDDDD", to_unsigned(12, ADDR_WIDTH));
          WriteInstr(x"EEEEEEEE", to_unsigned(13, ADDR_WIDTH));
          WriteInstr(x"FFFFFFFF", to_unsigned(14, ADDR_WIDTH));
        end FillInstrMemory;
      begin
        processor_enable <= '0';
        FillInstrMemory;
        processor_enable <= '1';
        reset <= '1';
        alu_zero <= '0';
        branch <= '0';
        jump <= '0';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        check(instruction_out = x"11111111", "Test1 - First error");
        wait for clk_period;
        check(instruction_out = x"22222222", "Test1 - Second error");
        wait for clk_period;
        check(instruction_out = x"33333333", "Test1 - Third error");
        wait for clk_period;
        check(instruction_out = x"44444444", "Test1 - 4th error");
        wait for clk_period;
        check(instruction_out = x"55555555", "Test1 - 5th error");
        report "Test 1 passed" severity note;
        jump <= '1';
        wait for clk_period;
        jump <= '0';
        wait for clk_period;
        wait for clk_period;
        --End of simple pc increment test

        
        check(instruction_out = x"11111111", "Test2 - First jump error");
        wait for clk_period;
        check(instruction_out = x"22222222", "Test2 - Second jump error");
        report "Test 2 passed" severity note;

        branch <= '1';
        branch_address <= x"00000003";
        wait for clk_period;
        wait for clk_period;
        check(instruction_out = x"44444444", "Test3 - First Branch error");
        alu_zero <= '1';
        wait for clk_period;
        branch <= '0';
        wait for clk_period;            --check the clock period here
        wait for clk_period;
        check(instruction_out = x"aaaaaaaa", "Test3 - Second Branch error");
        
        assert false report "TEST SUCCESS" severity failure;
        
  end process;

end behaviour;
