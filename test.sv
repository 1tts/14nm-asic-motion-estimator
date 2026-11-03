program automatic test(me_if.test meif);

  environment env;

  initial begin
    $vcdpluson;

    env = new(meif);
    env.build();
    env.run();
    env.wrap_up();
  end

endprogram