# SPI-controller
A simple SPI controller for peripherals like flash memory. 

The module has 3 input ports and 4 output ports.
Input ports:
1. SCK: Serial clock which is provided by the controller/Master device to peripheral/slave device
2. COPI: Controller out Peripheral in. Also known as SDO. The controller sends the data (serially/1-bit at a time) to the peripheral device using this 1-bit bus.
3. datasend: Data to send. This is a 8-bit wide port which is used by the peripheral device to send data to the controller device.

Output ports:
1. POCI: Peripheral out Controller in. Similar to the COPI port. Here the peripheral device uses this 1-bit bus to send data to controller device serially (1-bit at a time).
2. datarec: Data received. With the help of COPI, the 1-byte data sent serially by the controller device is unloaded.
3. Counter (optional): A counter counts 8 clock pulses to track the progress of serial communication. Generally, the counter is only used as internal logic, but i also used it a output to simplify the verification/simulation/testbench process.

Few internal logic registers/buffer are also required to load and unload data:
reg [7:0]datasend_buff;
reg [7:0]COPIbuff = 8'b0;  
reg POCIbuff;
One more register is required for the counter:
reg [2:0]counterbuff = 3'b0;

The data is recieved at the rising edge of the clock cycle and COPIbuff is left-shifted [assuming that MSB is sent first] by considering only the fist 7 bits [6:0] of COPIbuff and the LSB is the COPI. 
The data to be send by the peripheral deivce is loaded onto a buffer also on the rising edge if the counter is equal to 0 (3'b000).

