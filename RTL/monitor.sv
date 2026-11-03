class monitor;

  virtual me_if.test meif;

  transaction tr;

  mailbox mbx;

  extern function new(mailbox mbx, input virtual me_if.test meif);
  extern virtual task run();
  extern virtual task wrap_up();

endclass : monitor


function monitor::new(mailbox mbx, input virtual me_if.test meif);

  this.mbx  = mbx;
  this.meif = meif;

  tr = new();

endfunction : new


task monitor::run();

  forever begin

    // Wait for the DUT to start
    wait (meif.start == 1'b1);

    // Wait for DUT to complete the motion estimation
    wait (meif.completed == 1'b1);

    @meif.cb;

    tr = new();

    // Capture DUT outputs
    tr.BestDist = meif.cb.BestDist;
    tr.motionX  = meif.cb.motionX;
    tr.motionY  = meif.cb.motionY;
    tr.actual_BestDist = tr.BestDist;

    // Convert 4-bit encoded motion values to signed integers
    tr.convert_motion();

    $display("MONITOR: Captured DUT result. BestDist = %0d, motionX = %0d, motionY = %0d",
              tr.BestDist, tr.actual_motionX, tr.actual_motionY);

    // Send actual DUT result to scoreboard
    mbx.put(tr);

    // Wait for completed to go low before monitoring next test
    wait (meif.completed == 1'b0);

  end

endtask : run


task monitor::wrap_up();
  // empty for now
endtask : wrap_up