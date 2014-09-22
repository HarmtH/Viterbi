library ieee;
use ieee.std_logic_1164.all;
use work.anu.all;

architecture bhv of viterby is
	signal state: state_array;
	signal tb: tb_type;
	-- state 0: -1 -1
	-- state 1: -1 +1
	-- state 2: +1 -1
	-- state 3: +1 +1
--	constant trans_val: trans_array := (
--		( -8,  0, 12,  0),
--		( -2,  0, 18,  0),
--		(  0,-18,  0,  2),
--		(  0,-12,  0,  8));
begin
	P0: process(all)
	begin
		if (state(0)<state(1) and state(0)<state(2) and state(0)<state(3)) then
			likely <= tb(0);
		elsif (state(1)<state(2) and state(1)<state(3)) then
			likely <= tb(1);
		elsif (state(2)<state(3)) then
			likely <= tb(2);
		else
			likely <= tb(3);
		end if;
	end process;

	P1: process(clk,rst)
		variable count: integer range 0 to 15;
		variable path1: state_type;
		variable path2: state_type;
	begin
		if rst='1' then
			count := 0;
			path1 := 0;
			path2 := 0;
			state <= (others => 0);
		elsif rising_edge(clk) then
			-- state 0
			path1 := state(0)+(input_stream-trans_val(0,0)) ** 2;
			path2 := state(1)+(input_stream-trans_val(1,0)) ** 2;
			if (path1<path2) or count<2 then
				state(0) <= path1;
				tb(0)(count downto 0) <= '0' & tb(0)(count-1 downto 0);
			else
				state(0) <= path2;
				tb(0)(count downto 0) <= '0' & tb(1)(count-1 downto 0);
			end if;

			-- state 1
			path1 := state(2)+(input_stream-trans_val(2,1)) ** 2;
			path2 := state(3)+(input_stream-trans_val(3,1)) ** 2;
			if (path1<path2) then
				state(1) <= path1;
				tb(1)(count downto 0) <= '0' & tb(2)(count-1 downto 0);
			else
				state(1) <= path2;
				tb(1)(count downto 0) <= '0' & tb(3)(count-1 downto 0);
			end if;

			-- state 2
			path1 := state(0)+(input_stream-trans_val(0,2)) ** 2;
			path2 := state(1)+(input_stream-trans_val(1,2)) ** 2;
			if (path1<path2) or count <2 then
				state(2) <= path1;
				tb(2)(count downto 0) <= '1' & tb(0)(count-1 downto 0);
			else
				state(2) <= path2;
				tb(2)(count downto 0) <= '1' & tb(1)(count-1 downto 0);
			end if;

			-- state 3
			path1 := state(2)+(input_stream-trans_val(2,3)) ** 2;
			path2 := state(3)+(input_stream-trans_val(3,3)) ** 2;
			if (path1<path2) then
				state(3) <= path1;
				tb(3)(count downto 0) <= '1' & tb(2)(count-1 downto 0);
			else
				state(3) <= path2;
				tb(3)(count downto 0) <= '1' & tb(3)(count-1 downto 0);
			end if;
			count := count + 1;
		end if;
	end process;
end bhv;

