interface me_if(input bit clk);

  bit [4:0] tb_test_type;
  bit signed [3:0] tb_expected_motionX;
  bit signed [3:0] tb_expected_motionY;
  bit signed [7:0] tb_expected_BestDist;

  // DUT input controls
  logic start;

  // DUT memory data inputs
  logic [7:0] R;
  logic [7:0] S1;
  logic [7:0] S2;

  // DUT outputs
  logic [7:0] BestDist;
  logic [3:0] motionX;
  logic [3:0] motionY;
  logic [7:0] AddressR;
  logic [9:0] AddressS1;
  logic [9:0] AddressS2;
  logic completed;

  // Clocking block for testbench timing
clocking cb @(posedge clk);
    default input #1 output #1;

    // Testbench drives these
    output start;
    output R;
    output S1;
    output S2;

    // Debug / waveform-only
    output tb_test_type;
    output tb_expected_motionX;
    output tb_expected_motionY;
    output tb_expected_BestDist;

    // Testbench samples these
    input BestDist;
    input motionX;
    input motionY;
    input AddressR;
    input AddressS1;
    input AddressS2;
    input completed;
  endclocking : cb

  // DUT modport
  modport dut (
    input  clk,
    input  start,
    input  R,
    input  S1,
    input  S2,
    output BestDist,
    output motionX,
    output motionY,
    output AddressR,
    output AddressS1,
    output AddressS2,
    output completed
  );

modport test (
    clocking cb,
    input clk,

    output start,
    output R,
    output S1,
    output S2,

    output tb_test_type,
    output tb_expected_motionX,
    output tb_expected_motionY,
    output tb_expected_BestDist,

    input AddressR,
    input AddressS1,
    input AddressS2,
    input BestDist,
    input motionX,
    input motionY,
    input completed
  );

endinterface : me_if