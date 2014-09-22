library ieee;
use ieee.std_logic_1164.all;
package anu is
	constant m: integer :=4;
	
	subtype state_type is integer range -65536 to 65535;
	subtype trans_type is integer range -64 to 63; -- transition type
	subtype input_type is integer range -512 to 511;
	subtype rate_type is integer range 1 to 4;
	
	type state_array is array(natural range m-1 downto 0) of state_type;
	type trans_array is array(0 to 3, 0 to 3) of trans_type;
	type input_array is array(0 to 3) of input_type;
	
	type tb_type is array(0 to 3) of std_logic_vector(7 downto 0); -- traceback
	
end anu;