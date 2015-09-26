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
   signal alu_zero : std_logic;
   signal branch : std_logic;
   signal jump : std_logic;
   signal branch_adress   :  std_logic_vector(31 downto 0);
   signal instruction_out : std_logic_vector(31 downto 0);     
        
   constant clk_period : time := 10 ns; 
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
    branch_adress => branch_adress,
    instruction_out => instruction_out,
    imem_data_in => imem_data_out,
    imem_address => imem_address);
    

    -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

end behaviour;
