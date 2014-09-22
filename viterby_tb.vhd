library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;						 -- For text file I/O
use ieee.std_logic_textio.all;	-- To use IEEE datatypes with text file I/O
use work.anu.all;

entity viterby_tb is
end viterby_tb;

architecture bhv of viterby_tb is
	--component viterby
	--	port (	clk: 			in std_logic;
	--			rst: 			in std_logic;
	--			input_stream: 	in integer range 0 to 1023;
	--			likely:			out std_logic_vector(7 downto 0)
	--	);
	--end component;

	constant eq_trans_val: trans_array := ( -- equaliser - Molisch
		( -8,  0, 12,  0),
		( -2,  0, 18,  0),
		(  0,-18,  0,  2),
		(  0,-12,  0,  8));
		
	constant dec_trans_val: trans_array := ( -- decoder - DSPlog
	  ( 2#00#,     0, 2#11#,     0),
		( 2#11#,     0, 2#00#,     0),
		(     0, 2#01#,     0, 2#10#),
		(     0, 2#10#,     0, 2#01#));
		
	constant INIT_FILE : string := "../Matlab/Dsplog/dec_input_stream.txt";	-- File with initial memory contents
	constant OUTPUT_FILE  : string := "dec_output_stream_modelsim.txt";   -- File to write changed memory contents to
	
	constant clk_period	: time := 10 ns;
	
	signal stop_simulation: boolean := false;
	signal input_finished: boolean := false;
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal input_stream : input_array := (others => 0);
	signal rate : rate_type;
	signal trans_val : trans_array;
	signal likely: std_ulogic;
	signal valid : std_ulogic;

begin
		
	dut : entity work.viterby(bhv2)
		port map(
			clk => clk,
			rst => rst,
			rate => rate,
			input_stream => input_stream,
			trans_val => trans_val,
			likely => likely,
			valid => valid
		);

	clk_gen: clk <= clk when stop_simulation else not clk after clk_period/2;
	trans_val <= eq_trans_val when rate=1 else dec_trans_val;
	
	tester : process
		procedure get_init_data is
			file		 indata_file : text;
			variable i					 : integer := -1;
			variable inline			: line;
			variable good				: boolean;
			variable input_data	: input_type;
			variable int_rate : rate_type;
		begin
			report ("Using memory init file " & INIT_FILE) severity note;
			file_open(indata_file, INIT_FILE, READ_MODE);		-- Open file
			-- Keep going until end of file or memory full
			while (not endfile(indata_file)) loop
				readline(indata_file, inline);					-- Read text line from file
				read(inline, input_data, good);					-- Get one field from line
				assert good report "Invalid data in memory init file." severity error;
				if i=-1 then
					int_rate := input_data;
					rate <= int_rate;
				else
					input_stream(i mod int_rate) <= input_data;						-- Convert data and put in mem
					if (i mod int_rate) = (int_rate-1) then
						wait until falling_edge(clk);
					end if;
				end if;
				i := i + 1;										-- Increment address				
			end loop;
			file_close(indata_file);							-- Close file
		end procedure;
	begin
		wait until falling_edge(clk);
		rst <= '1';
		wait until falling_edge(clk);
		rst <= '0';
		get_init_data;
		input_finished <= true;
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		stop_simulation <= true;
		wait;
	end process;
	
	dump_output: process
      file     outdata_file : text;
      variable outline      : line;
  begin
  	  report "dump output waiting for reset";
  	  wait until rst = '1';
  	  wait until rst = '0';
  	  report "dump output started";
      file_open(outdata_file, OUTPUT_FILE, WRITE_MODE); -- Open file
      while not input_finished loop
        if valid = '1' then
        	write(outline, likely);                    -- Compose line of text
        	report "output found";
        end if;
        wait until falling_edge(clk); 
      end loop;
      writeline(outdata_file, outline);               -- Write line to file
      file_close(outdata_file);                         -- Close file
      report "output written";
      wait;
    end process;
	
	
end architecture bhv;
