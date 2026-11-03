`timescale 1ns/1ps

module top;

  bit clk;
  parameter clk_per = 10;

  // Clock generation
  always #(clk_per/2) clk = ~clk;

  // Interface
  me_if meif(clk);

  // Test program
  test tst(meif);

  // DUT
  motionEstimator dut (
    .clock    (clk),
    .start    (meif.start),
    .BestDist (meif.BestDist),
    .motionX  (meif.motionX),
    .motionY  (meif.motionY),
    .AddressR (meif.AddressR),
    .AddressS1(meif.AddressS1),
    .AddressS2(meif.AddressS2),
    .R        (meif.R),
    .S1       (meif.S1),
    .S2       (meif.S2),
    .completed(meif.completed)
  );
  
  initial begin
  $fsdbDumpfile("motion.fsdb");
  $fsdbDumpvars(0, top);
  $fsdbDumpMDA();
end

endmodule