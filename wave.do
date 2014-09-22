onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /viterby_tb/done
add wave -noupdate /viterby_tb/clk
add wave -noupdate /viterby_tb/rst
add wave -noupdate /viterby_tb/input_stream
add wave -noupdate /viterby_tb/rate
add wave -noupdate /viterby_tb/likely
add wave -noupdate /viterby_tb/dut/clk
add wave -noupdate /viterby_tb/dut/rst
add wave -noupdate /viterby_tb/dut/rate
add wave -noupdate /viterby_tb/dut/input_stream
add wave -noupdate /viterby_tb/dut/trans_val
add wave -noupdate /viterby_tb/dut/likely
add wave -noupdate -expand /viterby_tb/dut/state
add wave -noupdate -expand /viterby_tb/dut/tb
add wave -noupdate /viterby_tb/dut/P1/count
add wave -noupdate /viterby_tb/done
add wave -noupdate /viterby_tb/clk
add wave -noupdate /viterby_tb/rst
add wave -noupdate /viterby_tb/input_stream
add wave -noupdate /viterby_tb/rate
add wave -noupdate /viterby_tb/likely
add wave -noupdate /viterby_tb/dut/clk
add wave -noupdate /viterby_tb/dut/rst
add wave -noupdate /viterby_tb/dut/rate
add wave -noupdate /viterby_tb/dut/input_stream
add wave -noupdate /viterby_tb/dut/trans_val
add wave -noupdate /viterby_tb/dut/likely
add wave -noupdate /viterby_tb/dut/state
add wave -noupdate /viterby_tb/dut/tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27455 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {4738 ps} {27810 ps}
