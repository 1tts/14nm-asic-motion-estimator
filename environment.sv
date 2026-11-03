class environment;

  generator  gen;
  driver     drv;
  monitor    mon;
  scoreboard scb;

  mailbox gen2drv;
  mailbox drv2gen;
  mailbox mon2scb;
  mailbox drv2scb;

  virtual me_if.test meif;

  extern function new(input virtual me_if.test meif);
  extern virtual function void build();
  extern virtual task run();
  extern virtual task wrap_up();

endclass : environment


function environment::new(input virtual me_if.test meif);
  this.meif = meif;
endfunction : new


function void environment::build();

  gen2drv = new();
  drv2gen = new();
  mon2scb = new();
  drv2scb = new();

  gen = new(gen2drv, drv2gen);
  drv = new(gen2drv, drv2gen, drv2scb, meif);
  mon = new(mon2scb, meif);
  scb = new(drv2scb, mon2scb);

endfunction : build


task environment::run();

  fork
    gen.run();
    drv.run();
    mon.run();
    scb.run();
  join_none

endtask : run


task environment::wrap_up();

  // Wait until scoreboard has checked all tests
  wait ((scb.pass_count + scb.fail_count) == scb.num_tests);

  // Give final display time to settle
  @meif.cb;
  @meif.cb;
  
  gen.wrap_up();
  drv.wrap_up();
  mon.wrap_up();
  scb.wrap_up();

  $finish;

endtask : wrap_up