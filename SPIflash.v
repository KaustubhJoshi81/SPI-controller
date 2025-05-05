`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kaustubh Joshi
// 
// Create Date: 22.04.2025 16:48:00
// Design Name: 
// Module Name: SPIflash
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: A simple SPI controller for peripheral devices such as Flash storage devices
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SPIflash(
    input    [7:0]datasend,     //data to send
    input    COPI,              //from Controller to peripheral
    input    SCK,               //Clock from controller 
    output   POCI,              //from peripheral to controller
    output   [7:0]datarec,      //data recieved from controller
    output   [2:0]counter       //To count from 1-8
);
    
    reg [7:0]datasend_buff;         //A Buffer to load the data
    reg [7:0]COPIbuff = 8'b0;       //A Buffer for recieving each bit
    reg POCIbuff;                   //Peripheral out Controller in buffer
    reg [2:0]counterbuff = 3'b0;    //To count clock pulses from 1-8
    
//Recieving data
always @(posedge SCK)
begin
    COPIbuff            <=  {COPIbuff[6:0], COPI};     //Recieving and left-shifting the bit 
    if (counterbuff==0)                              
    begin
        datasend_buff    <=    datasend;            //Load the data
    end
end

//Writing data + counter increment
always @(negedge SCK)
begin
    counterbuff       <=  counterbuff + 1'b1;                 //Incrementing the counter by 1
    POCIbuff          <=  {datasend_buff[7] & 1'b1};          //LSB sent first
    datasend_buff     <=  {datasend_buff[6:0], 1'b0};         //Right-Shifting to send next bit
end

assign datarec      =   (counterbuff ==0 & SCK == 1) ? COPIbuff: 8'bz;    //Data recieved
assign POCI         =   POCIbuff;                                         //Sending data
assign counter      =   counterbuff;                                      /*Just to check if the
                                                                          counter and related outputs 
                                                                          work properly*/
endmodule