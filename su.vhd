library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.anu.all;

entity su is
	generic(
		bit : std_ulogic
	);
	port(
		clk          : in  std_logic;
		rst          : in  std_logic;
		count        : in  integer range 0 to 512;
		rate         : in  rate_type;
		in_state0    : in  state_type;
		in_state1    : in  state_type;
		out_state    : out state_type;
		in_tb0       : in tb_type;
		in_tb1       : in tb_type;
		out_tb       : out tb_type;
		input_stream : in  input_array;
		trans_val0   : in  trans_type;
		trans_val1   : in  trans_type
	);
end entity su;

architecture bhv of su is
begin
	P0 : process(clk, rst) is
		variable trans_val_dec_path1 : signed(3 downto 0);
		variable trans_val_dec_path2 : signed(3 downto 0);
		variable path1               : state_array := (others => 0);
		variable path2               : state_array := (others => 0);
		variable path1_total         : state_type;
		variable path2_total         : state_type;
	begin
		if rst = '1' then
			out_state <= 0;
			out_tb    <= (others => '0');
		elsif rising_edge(clk) then
			trans_val_dec_path1 := to_signed(trans_val0, trans_val_dec_path1'length);
			trans_val_dec_path2 := to_signed(trans_val1, trans_val_dec_path2'length);
			if (rate = 1) then
				path1(0)          := (input_stream(0) - trans_val0) * (input_stream(0) - trans_val0);
				path1(3 downto 1) := (others => 0);
				path2(0)          := (input_stream(0) - trans_val1) * (input_stream(0) - trans_val1);
				path2(3 downto 1) := (others => 0);
			elsif (rate = 2) then
				path1(3 downto 2) := (others => 0);
				path1(3 downto 2) := (others => 0);
				
				if trans_val_dec_path1(0) = '0' then
					path1(0) := input_stream(0);
				else
					path1(0) := -input_stream(0);
				end if;
				if trans_val_dec_path1(1) = '0' then
					path1(1) := input_stream(1);
				else
					path1(1) := -input_stream(1);
				end if;
				if trans_val_dec_path2(0) = '0' then
					path2(0) := input_stream(0);
				else
					path2(0) := -input_stream(0);
				end if;
				if trans_val_dec_path2(1) = '0' then
					path2(1) := input_stream(1);
				else
					path2(1) := -input_stream(1);
				end if;
			else
				report "error" severity error;
			end if;
			path1_total := in_state0 + path1(0) + path1(1) + path1(2) + path1(3);
			path2_total := in_state1 + path2(0) + path2(1) + path2(2) + path2(3);
			if (path1_total < path2_total) or count < 2 then
				out_state <= path1_total;
				out_tb    <= bit & in_tb0(7 downto 1);
			else
				out_state <= path2_total;
				out_tb    <= bit & in_tb1(7 downto 1);
			end if;
		end if;
	end process p0;
end architecture bhv;
