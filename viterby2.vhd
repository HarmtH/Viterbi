library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.anu.all;

architecture bhv2 of viterby is
	signal state : state_array;
	signal tb    : tb_array;
	signal count : integer range 0 to 512;
	-- state 0: -1 -1
	-- state 1: -1 +1
	-- state 2: +1 -1
	-- state 3: +1 +1
	component su is
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
	end component su;
begin
	P0 : process(state(3 downto 0), tb(0 to 3)(0))
	begin
		if (state(0) < state(1) and state(0) < state(2) and state(0) < state(3)) then
			likely <= tb(0)(0);
		elsif (state(1) < state(2) and state(1) < state(3)) then
			likely <= tb(1)(0);
		elsif (state(2) < state(3)) then
			likely <= tb(2)(0);
		else
			likely <= tb(3)(0);
		end if;
	end process;

	sc0 : su generic map(
			bit => '0'
		) port map(
			clk => clk,
			rst => rst,
			count => count,
			rate => rate,
			in_state0 => state(0),
			in_state1 => state(1),
			out_state => state(0),
			in_tb0 => tb(0),
			in_tb1 => tb(1),
			out_tb => tb(0),
			input_stream => input_stream,
			trans_val0 => trans_val(0, 0),
			trans_val1 => trans_val(1, 0)
		);
	sc1 : su generic map(
			bit => '0'
		) port map(
			clk => clk,
			rst => rst,
			count => count,
			rate => rate,
			in_state0 => state(2),
			in_state1 => state(3),
			out_state => state(1),
			in_tb0 => tb(2),
			in_tb1 => tb(3),
			out_tb => tb(1),
			input_stream => input_stream,
			trans_val0 => trans_val(2, 1),
			trans_val1 => trans_val(3, 1)
		);
	sc2 : su generic map(
			bit => '1'
		) port map(
			clk => clk,
			rst => rst,
			count => count,
			rate => rate,
			in_state0 => state(0),
			in_state1 => state(1),
			out_state => state(2),
			in_tb0 => tb(0),
			in_tb1 => tb(1),
			out_tb => tb(2),
			input_stream => input_stream,
			trans_val0 => trans_val(0, 2),
			trans_val1 => trans_val(1, 2)
		);
	sc3 : su generic map(
			bit => '1'
		) port map(
			clk => clk,
			rst => rst,
			count => count,
			rate => rate,
			in_state0 => state(2),
			in_state1 => state(3),
			out_state => state(3),
			in_tb0 => tb(2),
			in_tb1 => tb(3),
			out_tb => tb(3),
			input_stream => input_stream,
			trans_val0 => trans_val(2, 3),
			trans_val1 => trans_val(3, 3)
		);

	P1 : process(clk, rst)
	begin
		if rst = '1' then
			count <= 0;
			valid <= '0';
		elsif rising_edge(clk) then
			count <= count + 1;
			if count >= 7 then
				valid <= '1';
			end if;
		end if;
	end process;
end bhv2;

