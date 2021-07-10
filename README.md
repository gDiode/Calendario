# Calendario
This is a HW implementation to an FPGA in VHDL, its features are counts seconds, minutes, hours, days, months and years (with proper leap years implemented!)

## I/O

The inputs are very simple, you get a CLK, RST and CTRL lines.
The outputs is where it gets more complex, it has 4 sets of outputs and each set has 4 lines in which they output in binary.

## How it works

In very broad terms what it does is a state machine of 3 states.
The first state and default state is a minute and hour display.
The second state can be reached by sending a HIGH value to the CTRL line in which it will change to display the day/month.
The third state will be reached after 2 seconds on the second state in which it will display the year. After which it will go back to the first state in 2 seconds.

![STATE MACHINE](https://github.com/gDiode/Calendario/blob/ef973e96c3a5e92e2f73420d9d826983267bcee8/image.png)
