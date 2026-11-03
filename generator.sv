class transaction;

  rand bit [7:0] Smem [0:1023];
  bit [7:0] Rmem [0:255];

  rand integer Expected_motionX;
  rand integer Expected_motionY;
  rand int Expected_BestDist;
  rand int signed Noise;

  integer test_type;

  bit [7:0] BestDist;
  bit [3:0] motionX;
  bit [3:0] motionY;

  integer actual_motionX;
  integer actual_motionY;
  integer actual_BestDist;

  constraint c {
    Expected_motionX inside {[-8:7]};
    Expected_motionY inside {[-8:7]};

    // One nonzero noise value per transaction
    Noise inside {[-5:-1], [1:5]};
  }

  function void build_Rmem();

  integer i;
  integer row;
  integer col;
  integer idx;
  integer noise_start_x;
  integer noise_start_y;
  integer signed base_val;
  integer signed noise;
  integer signed noisy_val;
  integer signed diff;

  case (test_type)

    // 0: No match / worst case
    0: begin
      foreach (Smem[i])
        Smem[i] = 8'h00;

      foreach (Rmem[i])
        Rmem[i] = 8'hFF;

      Expected_BestDist = 255;
    end

    // 1: Small distortion
    1: begin
      foreach (Rmem[i]) begin
        Rmem[i] = Smem[
          32*8 + 8 +
          (((i/16) + Expected_motionY) * 32) +
          ((i%16) + Expected_motionX)
        ];
      end

      if (Rmem[0] < 8'hFF)
        Rmem[0] = Rmem[0] + 1;
      else
        Rmem[0] = Rmem[0] - 1;

      Expected_BestDist = 1;
    end

    // 2: High distortion
    2: begin
      foreach (Smem[i])
        Smem[i] = 8'hFF;

      foreach (Rmem[i])
        Rmem[i] = 8'h00;

      Rmem[0] = 8'hFF;
      Rmem[1] = 8'hFF;

      Expected_BestDist = 255;
    end

    // 3: Noise patch
    3: begin
      Expected_BestDist = 0;
    
      foreach (Rmem[i]) begin
        Rmem[i] = Smem[
          32*8 + 8 +
          (((i/16) + Expected_motionY) * 32) +
          ((i%16) + Expected_motionX)
        ];
      end
    
      noise_start_x = $urandom_range(0, 12);
      noise_start_y = $urandom_range(0, 12);
    
      for (row = noise_start_y; row < noise_start_y + 4; row++) begin
        for (col = noise_start_x; col < noise_start_x + 4; col++) begin
          idx = row * 16 + col;
    
          noise = Noise;
    
          base_val = integer'(Rmem[idx]);
          noisy_val = base_val + noise;
    
          if (noisy_val > 255)
            noisy_val = 255;
          else if (noisy_val < 0)
            noisy_val = 0;
    
          diff = noisy_val - base_val;
    
          if (diff < 0)
            diff = -diff;
    
          Expected_BestDist = Expected_BestDist + diff;
    
          Rmem[idx] = noisy_val[7:0];
        end
      end
    end

    // 4: Amplitude offset patch
    4: begin
      Expected_BestDist = 0;
    
      foreach (Rmem[i]) begin
        Rmem[i] = Smem[
          32*8 + 8 +
          (((i/16) + Expected_motionY) * 32) +
          ((i%16) + Expected_motionX)
        ];
      end
    
      noise_start_x = $urandom_range(0, 12);
      noise_start_y = $urandom_range(0, 12);
    
      // Use the single constrained Noise value
      noise = Noise;
    
      for (row = noise_start_y; row < noise_start_y + 4; row++) begin
        for (col = noise_start_x; col < noise_start_x + 4; col++) begin
          idx = row * 16 + col;
    
          base_val = integer'(Rmem[idx]);
          noisy_val = base_val + noise;
    
          if (noisy_val > 255)
            noisy_val = 255;
          else if (noisy_val < 0)
            noisy_val = 0;
    
          diff = noisy_val - base_val;
    
          if (diff < 0)
            diff = -diff;
    
          Expected_BestDist = Expected_BestDist + diff;
    
          Rmem[idx] = noisy_val[7:0];
        end
      end
    end

    // default: perfect match
    default: begin
      foreach (Rmem[i]) begin
        Rmem[i] = Smem[
          32*8 + 8 +
          (((i/16) + Expected_motionY) * 32) +
          ((i%16) + Expected_motionX)
        ];
      end

      Expected_BestDist = 0;
    end

  endcase

endfunction : build_Rmem


  function void convert_motion();

    if (motionX >= 8)
      actual_motionX = motionX - 16;
    else
      actual_motionX = motionX;

    if (motionY >= 8)
      actual_motionY = motionY - 16;
    else
      actual_motionY = motionY;

  endfunction : convert_motion

endclass : transaction


class generator;

  transaction tr;
  mailbox mbx, rtn;

  integer num_tests = 1500;

  extern function new(mailbox mbx, rtn);
  extern virtual task run();
  extern virtual task wrap_up();

endclass : generator


function generator::new(mailbox mbx, rtn);
  this.mbx = mbx;
  this.rtn = rtn;
endfunction : new


task generator::run();

  integer i;
  int randomTest;

  for (i = 0; i < num_tests; i = i + 1) begin

    tr = new();
    randomTest = $urandom_range(0,8);

    if (!tr.randomize()) begin
      $display("ERROR: Generator transaction randomization failed");
    end

    case (randomTest)

      0: begin
        tr.test_type = 0; // no match
        tr.Expected_motionX = 0;
        tr.Expected_motionY = 0;
      end

      1: begin
        tr.test_type = 1; // small distortion
        tr.Expected_motionX = 0;
        tr.Expected_motionY = 0;
      end

      2: begin
        tr.test_type = 2; // high distortion
        tr.Expected_motionX = 0;
        tr.Expected_motionY = 0;
      end

      3: begin
        tr.test_type = 5; // motionX +, motionY +
        tr.Expected_motionX = $urandom_range(1, 7);
        tr.Expected_motionY = $urandom_range(1, 7);
        tr.Expected_BestDist = 0;
      end

      4: begin
        tr.test_type = 5; // motionX +, motionY -
        tr.Expected_motionX = $urandom_range(1, 7);
        tr.Expected_motionY = -$urandom_range(1, 8);
        tr.Expected_BestDist = 0;
      end

      5: begin
        tr.test_type = 5; // motionX -, motionY +
        tr.Expected_motionX = -$urandom_range(1, 8);
        tr.Expected_motionY = $urandom_range(1, 7);
        tr.Expected_BestDist = 0;
      end

      6: begin
        tr.test_type = 5; // motionX -, motionY -
        tr.Expected_motionX = -$urandom_range(1, 8);
        tr.Expected_motionY = -$urandom_range(1, 8);
        tr.Expected_BestDist = 0;
      end

      7: begin
        tr.test_type = 3; // noise patch
      end

      8: begin
        tr.test_type = 4; // amplitude patch
      end

      default: begin
        tr.test_type = 5; // perfect match
        tr.Expected_BestDist = 0;
      end

    endcase

    tr.build_Rmem();

    $display("GENERATOR: Test %0d: Type=%0d, Expected motionX=%0d, Expected motionY=%0d, Expected BestDist=%0d",
              i,
              tr.test_type,
              tr.Expected_motionX,
              tr.Expected_motionY,
              tr.Expected_BestDist);

    mbx.put(tr);

    rtn.get(tr);

  end

endtask : run


task generator::wrap_up();
  // empty for now
endtask : wrap_up