all: rpm.v test_rpm.v rpm_config.v
	iverilog -o rpm rpm.v test_rpm.v 7seg.v bcd.v
