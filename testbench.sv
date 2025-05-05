`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kaustubh Joshi
// 
// Create Date: 24.04.2025 22:42:38
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench();

logic SCK;
logic [7:0] datasend;
logic [7:0] datarec;
logic COPI;
logic [2:0]counter;
logic POCI;

SPIflash DUT(.datasend(datasend), .COPI(COPI), .POCI(POCI), .SCK(SCK), .datarec(datarec), .counter(counter));

//generate clock
always
begin
SCK = 0;
#10
SCK = 1;
#10;
end

initial 
begin    
    #5;
    COPI = 0;       //Manually Checking COPI functionality
    #20;
    COPI = 1; 
    #20;
    COPI = 0;
    #20;
    COPI = 1;
    #20;
    COPI = 0;
    #20;
    COPI = 1; 
    #20;
    COPI = 0;
    #20;
    COPI = 1;
    #20;
    COPI = 0;
    datasend = 8'b10101010; //For checking POCI functionality
    #200;
    datasend = 8'b01010101;
end

endmodule
