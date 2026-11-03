
`timescale 1ns/1ps
`default_nettype none

interface motionEstimator_interface(input logic clock);

  logic start;
  logic [7:0] R, S1, S2;

  logic [7:0] BestDist;
  logic [3:0] motionX, motionY;
  logic [7:0] AddressR;
  logic [9:0] AddressS1, AddressS2;
  logic completed;

  clocking cb @(posedge clock);
    output start;
    input R, S1, S2;
    input BestDist, motionX, motionY;
    input AddressR, AddressS1, AddressS2, completed;
  endclocking

  modport DUT (input clock, start, R, S1, S2, output BestDist, motionX, motionY, AddressR, AddressS1, AddressS2, completed);
  modport TB (clocking cb, output start, input BestDist, motionX, motionY, input AddressR, AddressS1, AddressS2, completed, input R, S1, S2);

endinterface