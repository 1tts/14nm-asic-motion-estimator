class scoreboard;

  transaction tr_exp;
  transaction tr_act;

  mailbox mbx_drv;
  mailbox mbx_mon;

  integer pass_count;
  integer fail_count;
  integer num_tests =1500;

  // Functional coverage for expected motion X/Y
  covergroup motion_cov;

    cp_motionX: coverpoint tr_exp.Expected_motionX {
      bins motionX_bins[] = {[-8:7]};
    }

    cp_motionY: coverpoint tr_exp.Expected_motionY {
      bins motionY_bins[] = {[-8:7]};
    }

    cross_motionXY: cross cp_motionX, cp_motionY;

  endgroup

  extern function new(mailbox mbx_drv, mbx_mon);
  extern virtual task run();
  extern virtual task wrap_up();

endclass : scoreboard


function scoreboard::new(mailbox mbx_drv, mbx_mon);

  this.mbx_drv = mbx_drv;
  this.mbx_mon = mbx_mon;

  tr_exp = new();
  tr_act = new();

  pass_count = 0;
  fail_count = 0;

  // Create coverage object
  motion_cov = new();

endfunction : new


task scoreboard::run();

  forever begin

    // Get expected transaction from driver
    mbx_drv.get(tr_exp);

    // Get actual output transaction from monitor
    mbx_mon.get(tr_act);

    // Sample functional coverage using expected motion values
    motion_cov.sample();

    // Compare expected and actual motion vector + BestDist
    if ((tr_exp.Expected_motionX  == tr_act.actual_motionX) &&
        (tr_exp.Expected_motionY  == tr_act.actual_motionY) &&
        (tr_exp.Expected_BestDist == tr_act.actual_BestDist)) begin

      pass_count = pass_count + 1;

      $display("PASS: Expected X=%0d Y=%0d BestDist=%0d | Actual X=%0d Y=%0d BestDist=%0d",
          tr_exp.Expected_motionX,
          tr_exp.Expected_motionY,
          tr_exp.Expected_BestDist,
          tr_act.actual_motionX,
          tr_act.actual_motionY,
          tr_act.actual_BestDist);

    end
    else begin

      fail_count = fail_count + 1;

      $display("FAIL: Expected X=%0d Y=%0d BestDist=%0d | Actual X=%0d Y=%0d BestDist=%0d",
          tr_exp.Expected_motionX,
          tr_exp.Expected_motionY,
          tr_exp.Expected_BestDist,
          tr_act.actual_motionX,
          tr_act.actual_motionY,
          tr_act.actual_BestDist);

    end

  end

endtask : run


task scoreboard::wrap_up();

  $display("--------------------------------------------------");
  $display("MOTION ESTIMATOR SCOREBOARD SUMMARY");
  $display("PASS count = %0d", pass_count);
  $display("FAIL count = %0d", fail_count);
  $display("Functional coverage = %0.2f%%", motion_cov.get_coverage());

  if (motion_cov.get_coverage() >= 90.0)
    $display("COVERAGE PASS: Minimum 90%% coverage reached.");
  else
    $display("COVERAGE FAIL: Minimum 90%% coverage not reached.");

  $display("--------------------------------------------------");

endtask : wrap_up