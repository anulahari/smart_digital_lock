# smart_digital_lock
The Smart Digital Lock System is a Verilog-based FPGA project that implements a secure access control mechanism with multiple user levels and custom PIN verification.
The system uses an 8-bit PIN, where:

The first 4 bits represent the user level.

The next 4 bits represent the user ID within that level.

Access is granted only if both parts match the stored values in the system memory.
The design includes failed attempt tracking and an alarm trigger after three consecutive denials.
