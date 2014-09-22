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
		in_tb0       : in  tb_type;
		in_tb1       : in  tb_type;
		out_tb       : out tb_type;
		input_stream : in  input_array;
		trans_val0   : in  trans_type;
		trans_val1   : in  trans_type
	);
end entity su;

architecture bhv of su is
begin
	P0 : process(clk, rst) is
		type path_array is array (0 to 1) of state_array;
		type trans_val_dec_array is array (0 to 1) of signed(3 downto 0);
		--variable trans_val_dec_path1 : signed(3 downto 0);
		--variable trans_val_dec_path2 : signed(3 downto 0);
		variable trans_val_dec : trans_val_dec_array;
		variable path          : path_array := (others => (others => 0));
		variable path_total    : state_array;
	begin
		if rst = '1' then
			out_state <= 0;
			out_tb    <= (others => '0');
		elsif rising_edge(clk) then
			trans_val_dec(0) := to_signed(trans_val0, trans_val_dec(0)'length);
			trans_val_dec(1) := to_signed(trans_val1, trans_val_dec(1)'length);
			if (rate = 1) then
				path(0)(0)          := (input_stream(0) - trans_val0) * (input_stream(0) - trans_val0);
				path(0)(3 downto 1) := (others => 0);
				path(1)(0)          := (input_stream(0) - trans_val1) * (input_stream(0) - trans_val1);
				path(1)(3 downto 1) := (others => 0);
			else 
				path(0)(3 downto rate) := (others => 0);
				path(1)(3 downto rate) := (others => 0);
				for i in 0 to (rate - 1) loop
					for j in 0 to 1 loop
						if trans_val_dec(j)(i) = '0' then
							path(j)(i) := input_stream(i);
						else
							path(j)(i) := -input_stream(i);
						end if;
					end loop;
				end loop;
			end if;
			path_total(0) := in_state0;
			path_total(1) := in_state1;
			for i in 0 to 3 loop
				for j in 0 to 1 loop
					path_total(j) := path_total(j) + path(j)(i);
				end loop;
			end loop;
			if (path_total(0) < path_total(1)) or count < 2 then
				out_state <= path_total(0);
				out_tb    <= bit & in_tb0(7 downto 1);
			else
				out_state <= path_total(1);
				out_tb    <= bit & in_tb1(7 downto 1);
			end if;
		end if;
	end process p0;
end architecture bhv;
