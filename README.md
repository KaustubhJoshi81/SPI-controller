# SPI-controller
This project implements a simple SPI (Serial Peripheral Interface) controller for communicating with peripheral devices like flash memory. The module is written in Verilog using AMD Vivado, with a SystemVerilog testbench for simulation.

The module has 3 input ports and 3 output ports.
Input ports:
1. SCK: Serial clock which is provided by the controller/Master device to peripheral/slave device
2. COPI: Controller out Peripheral in. The controller sends the data (serially/1-bit at a time) to the peripheral device.
3. datasend: This is a 8-bit wide port which is used by the peripheral device to send data to the controller device.

Output ports:
1. POCI: Peripheral out Controller in. Similar to the COPI port. Here the peripheral device uses this 1-bit bus to send data to controller device serially (1-bit at a time).
2. datarec: 8-bit parallel out representing the data received from the controller via COPI.
3. Counter (optional): A counter counts 8 clock pulses to track the progress of serial communication. Generally, the counter is only used as internal logic, but i also used it a output to simplify the verification/simulation/testbench process.

Few internal logic registers/buffer are also required to load and unload data:
reg [7:0]datasend_buff;
reg [7:0]COPIbuff = 8'b0;  
reg POCIbuff;
One more register is required for the counter:
reg [2:0]counterbuff = 3'b0;

The peripheral receives 1 bit per clock cycle from the COPI line. Assuming MSB is transmitted first, bits are shifted into COPIbuff 
COPIbuff            <=  {COPIbuff[6:0], COPI};

The data to be send by the peripheral deivce is loaded onto a buffer on the rising edge of the clock. The 2nd condition for loading the data is: the value of counter is equal 3'b111. Data transmission begins when the counter is 0; thus, the next byte loads in the preceding clock cycle.
if (counterbuff==3'b111)                              
    begin
        datasend_buff    <=    datasend;            
    end

At the falling edge, the peripheral writes the data to the controller device and the data loaded is shifted to send the next bit in the next clock cycle. The counter is also incremented at the falling edge of the clock.
counterbuff       <=  counterbuff + 1'b1;                 
POCIbuff          <=  {datasend_buff[7] & 1'b1};         
datasend_buff     <=  {datasend_buff[6:0], 1'b0};        

The conditional operator is used to assign datarec to COPIbuff only when the counter = 0.
assign datarec      =   (counterbuff ==0 & SCK == 1) ? COPIbuff: 8'bz;


//Testbench//


The testbench is basic and requires manual waveform inspection. It performs two primary tests:

1. Reading Test:
Values are assigned to the COPI input with a delay to verify if the controller correctly reads and assembles the incoming data.

2. Writing Test:
Later in the simulation, a value is assigned to datasend to test if the peripheral correctly sends data via the POCI line.
