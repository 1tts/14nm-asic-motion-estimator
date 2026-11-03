
`timescale 1ns/1ps
`default_nettype none
module top;

  // Clock generation
  bit clk = 0;
  always 
    #10 clk = ~clk;
    
  // Interface
  motionEstimator_interface motionEstimator_bus(clk);
  
  // Module accumulator & DUT
  motionEstimator DUT(
    .clock(motionEstimator_bus.clock), 
    .start(motionEstimator_bus.start), 
    .BestDist(motionEstimator_bus.BestDist), 
    .motionX(motionEstimator_bus.motionX), 
    .motionY(motionEstimator_bus.motionY), 
    .AddressR(motionEstimator_bus.AddressR), 
    .AddressS1(motionEstimator_bus.AddressS1), 
    .AddressS2(motionEstimator_bus.AddressS2), 
    .R(motionEstimator_bus.R), 
    .S1(motionEstimator_bus.S1), 
    .S2(motionEstimator_bus.S2), 
    .completed(motionEstimator_bus.completed)
    );
    
  ROM_R memR_u(
    .clock(clk),
    .AddressR(motionEstimator_bus.AddressR),
    .R(motionEstimator_bus.R)
  );

  ROM_S memS_u(
    .clock(clk),
    .AddressS1(motionEstimator_bus.AddressS1),
    .AddressS2(motionEstimator_bus.AddressS2),
    .S1(motionEstimator_bus.S1),
    .S2(motionEstimator_bus.S2)
  );
    
  // Program Test
  motionEstimator_programtest t1(motionEstimator_bus);
  
endmodule