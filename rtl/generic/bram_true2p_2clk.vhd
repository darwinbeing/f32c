-- Generated by Quartus II Template

-- File->New File->VHDL File
-- Edit->Insert Template->VHDL->Full designs->RAMs and ROMs->True dual port RAM (singled clock)

-- True Dual-Port RAM with single clock
-- Read-during-write on port A or B should return newly written data on real device

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bram_true2p_2clk is
	generic 
	(
	        dual_port: boolean := True; -- set to False for single port A
	        pass_thru_a, pass_thru_b: boolean := True;
		data_width: natural := 8;
		addr_width: natural := 6
	);
	port 
	(
		clk_a: in std_logic;
		clk_b: in std_logic;
		addr_a: in std_logic_vector((addr_width-1) downto 0);
		addr_b: in std_logic_vector((addr_width-1) downto 0) := (others => '-');
		we_a: in std_logic := '0';
		we_b: in std_logic := '0';
		data_in_a: in std_logic_vector((data_width-1) downto 0);
		data_in_b: in std_logic_vector((data_width-1) downto 0) := (others => '-');
		data_out_a: out std_logic_vector((data_width -1) downto 0);
		data_out_b: out std_logic_vector((data_width -1) downto 0)
	);
end bram_true2p_2clk;

architecture rtl of bram_true2p_2clk is
	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((data_width-1) downto 0);
	type memory_t is array(2**addr_width-1 downto 0) of word_t;

	-- Declare the RAM 
	shared variable ram: memory_t;
begin
	-- Port A
	process(clk_a)
	begin
	if(rising_edge(clk_a)) then
            if not pass_thru_a then
                data_out_a <= ram(conv_integer(addr_a));
            end if;
            if(we_a = '1') then
                ram(conv_integer(addr_a)) := data_in_a;
            end if;
            if pass_thru_a then
                data_out_a <= ram(conv_integer(addr_a));
            end if;
	end if;
	end process;

	-- Port B 
	G_dual_port: if dual_port generate
	process(clk_b)
	begin
	if(rising_edge(clk_b)) then
            if not pass_thru_b then
                data_out_b <= ram(conv_integer(addr_b));
            end if;
            if(we_b = '1') then
                ram(conv_integer(addr_b)) := data_in_b;
            end if;
            if pass_thru_b then
                data_out_b <= ram(conv_integer(addr_b));
            end if;
	end if;
	end process;
	end generate;
end rtl;
