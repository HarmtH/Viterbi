library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.anu.all;

architecture bhv2 of viterby is
	signal state: state_array;
	signal tb: tb_type;
	-- state 0: -1 -1
	-- state 1: -1 +1
	-- state 2: +1 -1
	-- state 3: +1 +1

begin
	P0: process(state(3 downto 0),tb(0 to 3)(0))
	begin
		if (state(0)<state(1) and state(0)<state(2) and state(0)<state(3)) then
			likely <= tb(0)(0);
		elsif (state(1)<state(2) and state(1)<state(3)) then
			likely <= tb(1)(0);
		elsif (state(2)<state(3)) then
			likely <= tb(2)(0);
		else
			likely <= tb(3)(0);
		end if;
	end process;

	P1: process(clk,rst)
		variable count: integer range 0 to 512;
		variable trans_val_dec_path1: signed(3 downto 0);
		variable trans_val_dec_path2: signed(3 downto 0);
		variable path1: state_array := (others => 0);
		variable path2: state_array := (others => 0);
		variable path1_total: state_type;
		variable path2_total: state_type;
	begin
		if rst='1' then
			count := 0;
			path1 := (others => 0);
			path2 := (others => 0);
			path1_total := 0;
			path2_total := 0;
			state <= (others => 0);
			tb <= (others => (others => '0'));
			valid <= '0';
		elsif rising_edge(clk) then
			-- state 0
			trans_val_dec_path1 := to_signed(trans_val(0,0),trans_val_dec_path1'length);
			trans_val_dec_path2 := to_signed(trans_val(1,0),trans_val_dec_path2'length);
			if (rate=1) then
				path1(0) := (input_stream(0)-trans_val(0,0)) ** 2;
				path1(3 downto 1) := (others => 0);
				path2(0) := (input_stream(0)-trans_val(1,0)) ** 2;
				path2(3 downto 1) := (others => 0);
			elsif (rate=2) then
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
			path1_total := state(0)+path1(0)+path1(1)+path1(2)+path1(3);
			path2_total := state(1)+path2(0)+path2(1)+path2(2)+path2(3);
			if (path1_total<path2_total) or count<2 then
				state(0) <= path1_total;
				tb(0) <= '0' & tb(0)(7 downto 1);
			else
				state(0) <= path2_total;
				tb(0) <= '0' & tb(1)(7 downto 1);
			end if;

			-- state 1
			trans_val_dec_path1 := to_signed(trans_val(2,1),trans_val_dec_path1'length);
			trans_val_dec_path2 := to_signed(trans_val(3,1),trans_val_dec_path2'length);
			if (rate=1) then
				path1(0) := (input_stream(0)-trans_val(2,1)) ** 2;
				path1(3 downto 1) := (others => 0);
				path2(0) := (input_stream(0)-trans_val(3,1)) ** 2;
				path2(3 downto 1) := (others => 0);
			elsif (rate=2) then
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
			path1_total:=state(2)+path1(0)+path1(1)+path1(2)+path1(3);
			path2_total:=state(3)+path2(0)+path2(1)+path2(2)+path2(3);
			if (path1_total<path2_total or count <2) then
				state(1) <= path1_total;
				tb(1) <= '0' & tb(2)(7 downto 1);
			else
				state(1) <= path2_total;
				tb(1) <= '0' & tb(3)(7 downto 1);
			end if;

			-- state 2
			trans_val_dec_path1 := to_signed(trans_val(0,2),trans_val_dec_path1'length);
			trans_val_dec_path2 := to_signed(trans_val(1,2),trans_val_dec_path2'length);
			if (rate=1) then
				path1(0) := (input_stream(0)-trans_val(0,2)) ** 2;
				path1(3 downto 1) := (others => 0);
				path2(0) := (input_stream(0)-trans_val(1,2)) ** 2;
				path2(3 downto 1) := (others => 0);
			elsif (rate=2) then
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
			path1_total:=state(0)+path1(0)+path1(1)+path1(2)+path1(3);
			path2_total:=state(1)+path2(0)+path2(1)+path2(2)+path2(3);
			
			if (path1_total<path2_total) or count <2 then
				state(2) <= path1_total;
				tb(2) <= '1' & tb(0)(7 downto 1);
			else
				state(2) <= path2_total;
				tb(2) <= '1' & tb(1)(7 downto 1);
			end if;

			-- state 3
			trans_val_dec_path1 := to_signed(trans_val(2,3),trans_val_dec_path1'length);
			trans_val_dec_path2 := to_signed(trans_val(3,3),trans_val_dec_path2'length);
			if (rate=1) then
				path1(0) := (input_stream(0)-trans_val(2,3)) ** 2;
				path1(3 downto 1) := (others => 0);
				path2(0) := (input_stream(0)-trans_val(3,3)) ** 2;
				path2(3 downto 1) := (others => 0);
			elsif (rate=2) then
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
			path1_total:=state(2)+path1(0)+path1(1)+path1(2)+path1(3);
			path2_total:=state(3)+path2(0)+path2(1)+path2(2)+path2(3);
			if (path1_total<path2_total or count<2) then
				state(3) <= path1_total;
				tb(3) <= '1' & tb(2)(7 downto 1);
			else
				state(3) <= path2_total;
				tb(3) <= '1' & tb(3)(7 downto 1);
			end if;
			count := count + 1;
			if count >= 8 then
				valid <= '1';
			end if;
		end if;
	end process;
end bhv2;

