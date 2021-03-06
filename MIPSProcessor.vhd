-- Part of TDT4255 Computer Design laboratory exercises
-- Group for Computer Architecture and Design
-- Department of Computer and Information Science
-- Norwegian University of Science and Technology

-- MIPSProcessor.vhd
-- The MIPS processor component to be used in Exercise 1 and 2.

-- TODO replace the architecture DummyArch with a working Behavioral

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPSProcessor is
  generic (
    ADDR_WIDTH : integer := 8;
    DATA_WIDTH : integer := 32
    );
  port (
    clk, reset        : in  std_logic;
    processor_enable  : in  std_logic;
    imem_data_in      : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    imem_address      : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    dmem_data_in      : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    dmem_address      : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    dmem_data_out     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    dmem_write_enable : out std_logic
    );
end MIPSProcessor;

architecture Behavioral of MIPSProcessor is
  signal counterReg : unsigned(31 downto 0);

  signal operand_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal operand_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal result    : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal zero      : STD_LOGIC;
  signal control   : STD_LOGIC_VECTOR(3 DOWNTO 0);

  signal reg_write      : std_logic;
  signal read_reg_1     : std_logic_vector(4 downto 0);
  signal read_reg_2     : std_logic_vector(4 downto 0);
  signal write_register : std_logic_vector(4 downto 0);
  signal write_data     : std_logic_vector(31 downto 0);
  signal read_data_1    : std_logic_vector(31 downto 0);
  signal read_data_2    : std_logic_vector(31 downto 0);


  signal alu_op      : STD_LOGIC_VECTOR(1 downto 0);
  signal func        : STD_LOGIC_VECTOR(5 downto 0);
  signal alu_control : STD_LOGIC_VECTOR(3 downto 0);

  signal instruction  : STD_LOGIC_VECTOR(31 downto 0);
  signal opcode       : STD_LOGIC_VECTOR(5 downto 0);
  signal reg_a        : STD_LOGIC_VECTOR(4 downto 0);
  signal reg_b        : STD_LOGIC_VECTOR(4 downto 0);
  signal reg_d        : STD_LOGIC_VECTOR(4 downto 0);
  signal imm          : STD_LOGIC_VECTOR(15 downto 0);
  signal imm_extended : STD_LOGIC_VECTOR(31 downto 0);
  signal func_decoder : STD_LOGIC_VECTOR(5 downto 0);
  signal jump_addr    : STD_LOGIC_VECTOR(25 downto 0);

  signal alu_zero        : std_logic;
  signal branch          : std_logic;
  signal jump            : std_logic;
  signal branch_address  : std_logic_vector(31 downto 0);
  signal instruction_out : std_logic_vector(31 downto 0);
  --signal imem_data_in    : std_logic_vector(31 downto 0);
  signal imem_address_32 : std_logic_vector(31 downto 0);

  signal RegDst : STD_LOGIC; 
    signal MemRead : STD_LOGIC; 
                               signal MemtoReg : STD_LOGIC; 
                                  signal ALUop : STD_LOGIC_VECTOR(1 DOWNTO 0); 
                                                              signal ALUSrc : STD_LOGIC;
  signal PCWrite : STD_LOGIC;
  
  
begin
-- instantiate the alu

  
  MIPSalu : entity work.alu(Behavioral)
    port map (
      operand_A => operand_A,
      operand_B => operand_B,
      result    => result,
      zero      => zero,
      control   => control
      );
------------------------ alu

-- istantiate alu control
  MIPSalu_control : entity work.alu_control(Behavioral)
    port map (
      alu_op      => alu_op,
      func        => func,
      alu_control => alu_control
      );
-------------------------- alu_control

-- general register
  MIPSgen_reg : entity work.general_register(Behavioral)
    generic map(
      number => 32)
    port map (
      clk            => clk,
      rst            => reset,
      reg_write      => reg_write,
      read_reg_1     => read_reg_1,
      read_reg_2     => read_reg_2,
      write_register => write_register,
      write_data     => write_data,
      read_data_1    => read_data_1,
      read_data_2    => read_data_2
      );
---------------------- general register

-- instruction decoder
  MIPSinstruction_decoder : entity work.instruction_decoder(Behavioral)
    port map (
      instruction => instruction,
      opcode      => opcode,
      reg_a       => reg_a,
      reg_b       => reg_b,
      reg_d       => reg_d,
      imm         => imm,
      func        => func_decoder,
      jump_addr   => jump_addr
      );
------------------------------- instr decoder

-- instruction manager
  MIPSinstruction_manager : entity work.instruction_manager(Behavioral)
    port map (
      clk              => clk,
      rst              => reset,
      alu_zero         => zero,
      processor_enable => processor_enable,
      branch           => branch,
      jump             => jump,
      branch_address   => branch_address,
      instruction_out  => instruction_out,
      imem_data_in     => imem_data_in,
      imem_address     => imem_address_32,
      pc_enable        => PCWrite
      );

------------------- instr manager

--- control 
  MIPScontrol : entity work.control(Behavioral)
    port map (
      clk      => clk,
      rst      => reset,
      Opcode   => Opcode,
      start    => processor_enable,
      RegDst   => RegDst,
      Branch   => Branch,
      MemRead  => MemRead,
      MemtoReg => MemtoReg,
      ALUop    => ALUop,
      MemWrite => dmem_write_enable,
      ALUSrc   => ALUSrc,
      RegWrite => reg_write,
      PCWrite  => PCWrite,
      Jump     => Jump
      );
----------------------------------------------- control
  
  
  -- PC is on less bit than the address of the instruction memory
  imem_address   <= std_logic_vector(imem_address_32(7 downto 0));
  instruction    <= instruction_out;
  read_reg_1     <= reg_a;
  read_reg_2     <= reg_b;
  -- The mux on the register to write
  write_register <= reg_b when (RegDst = '0') else
                    reg_d when (RegDst = '1');
  operand_A                  <= read_data_1;
  -- sign extend
  imm_extended(15 downto 0)  <= imm;
  imm_extended(31 downto 16) <= (31 downto 16 => imm(15));
  branch_address             <= imm_extended;
  -- The mux on the second operand
  operand_B                  <= read_data_2 when (ALUSrc = '0') else
                                imm_extended when (ALUSrc = '1');
  alu_op        <= ALUop;
  func          <= func_decoder;
  control       <= alu_control;
  dmem_address  <= std_logic_vector(result(7 downto 0));
  dmem_data_out <= read_data_2;
  -- The mux on write data
  write_data    <= dmem_data_in when (MemtoReg = '1') else
                   result when (MemtoReg = '0');
  
  
  

end Behavioral;

