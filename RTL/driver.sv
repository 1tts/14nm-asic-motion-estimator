class driver;

  virtual me_if.test meif;

  transaction tr;

  mailbox mbx;
  mailbox rtn;
  mailbox mbx_scb;

  extern function new(mailbox mbx, rtn, mbx_scb,
                      input virtual me_if.test meif);
  extern virtual task run();
  extern virtual task wrap_up();

endclass : driver


function driver::new(mailbox mbx, rtn, mbx_scb,
                     input virtual me_if.test meif);

  this.mbx     = mbx;
  this.rtn     = rtn;
  this.mbx_scb = mbx_scb;
  this.meif    = meif;

  tr = new();

endfunction : new


task driver::run();

  integer addrR;
  integer addrS1;
  integer addrS2;

  // Initial reset/idle values. The DUT uses start=0 as reset/idle.
  meif.start = 1'b0;
  meif.R     = 8'h00;
  meif.S1    = 8'h00;
  meif.S2    = 8'h00;

  meif.tb_test_type         = -1;
  meif.tb_expected_motionX  = 0;
  meif.tb_expected_motionY  = 0;
  meif.tb_expected_BestDist = 0;

  // Hold start low for a few clocks so the DUT resets cleanly.
  repeat (3) @meif.cb;

  forever begin

    // Get transaction from generator.
    mbx.get(tr);

    meif.tb_test_type         = tr.test_type;
    meif.tb_expected_motionX  = tr.Expected_motionX;
    meif.tb_expected_motionY  = tr.Expected_motionY;
    meif.tb_expected_BestDist = tr.Expected_BestDist;

    $display("DRIVER: Got transaction. Expected motionX = %0d, Expected motionY = %0d, Expected BestDist = %0d",
              tr.Expected_motionX, tr.Expected_motionY, tr.Expected_BestDist);

    // ------------------------------------------------------------
    // RESET / START SEQUENCE
    // Requirement:
    // 1. Start with RMEM and SMEM
    // 2. Start pin begins at 0
    // 3. Start pin goes to 1, then check output
    // 4. Then goes 0
    // 5. Goes 1 when starting next search
    // ------------------------------------------------------------

    // Start low before each search.
    meif.start = 1'b0;

    // Drive valid initial RMEM/SMEM data while start is still low.
    meif.R  = tr.Rmem[0];
    meif.S1 = tr.Smem[0];
    meif.S2 = tr.Smem[0];

    // Give DUT time to see reset/idle state and valid memory inputs.
    repeat (2) @meif.cb;

    // Send expected result to scoreboard before DUT finishes.
    mbx_scb.put(tr);

    // Start search.
    meif.start = 1'b1;

    // Wait one clock after start rises.
    @meif.cb;

    // Drive RMEM/SMEM using DUT address outputs while search is running.
    fork
      begin : mem_drive
        forever begin

          if (!$isunknown(meif.AddressR))
            addrR = meif.AddressR;
          else
            addrR = 0;

          if (!$isunknown(meif.AddressS1))
            addrS1 = meif.AddressS1;
          else
            addrS1 = 0;

          if (!$isunknown(meif.AddressS2))
            addrS2 = meif.AddressS2;
          else
            addrS2 = 0;

          meif.R  = tr.Rmem[addrR];
          meif.S1 = tr.Smem[addrS1];
          meif.S2 = tr.Smem[addrS2];

          @(meif.AddressR or meif.AddressS1 or meif.AddressS2 or meif.start);

          if (meif.start == 1'b0)
            disable mem_drive;

        end
      end
    join_none

    // Wait for DUT to finish the current search.
    wait (meif.completed == 1'b1);

    // Leave outputs stable for monitor/scoreboard.
    @meif.cb;

    // Drop start back to 0 after checking/output completion.
    meif.start = 1'b0;

    // Wait until DUT returns to idle/reset state.
    wait (meif.completed == 1'b0);

    // Kill memory drive thread.
    disable fork;

    // Small clean idle gap before next search.
    repeat (2) @meif.cb;

    $display("DRIVER: Finished driving one motion-estimator test.");
    $display("====================================================================================================");

    rtn.put(tr);

  end

endtask : run


task driver::wrap_up();
  // empty for now
endtask : wrap_up