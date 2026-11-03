// Compile line: vcs -sverilog -full64 motionEstimator_interface.sv motionEstimator.v motionEstimator_programtest.sv motionEstimator_top.sv -o output.simv -debug_access+all -kdb

`timescale 1ns/1ps
`default_nettype none
program motionEstimator_programtest(motionEstimator_interface.TB mif);

  reg [7:0]	    Rmem[0:255]; 
  reg [7:0]	    Smem[0:1023];
  
  integer Expected_motionX, Expected_motionY;
  integer 		i;
  integer 		j;
  integer signed x, y;
  integer counter = 1;
  
  integer numb;
  
  integer noise_start_x;
  integer noise_start_y;
  integer row;
  integer col;
  integer idx;
  
  integer signed base_val;
  integer signed noise;
  integer signed noisy_val;
  
  logic signed [4:0] golden_x;
logic signed [4:0] golden_y;
logic [7:0] golden_bestDist;

  initial 
    begin
    $vcdpluson;
    $monitor("time=%5d ns, start = %b, BestDist = %b, motionX =%d, motionY =%d", $time, mif.start, mif.BestDist[7:0], mif.motionX[3:0], mif.motionY[3:0]);
        
    //1: Worst, Best distance doesn't exist
    run_test_case($urandom_range(0,15)-8, $urandom_range(0,15)-8, 0);
    
    //2: Min, Best distance change a little
    run_test_case($urandom_range(0,15)-8, $urandom_range(0,15)-8, 1);
    
    //3: Max, Best distance change alot
    run_test_case($urandom_range(0,15)-8, $urandom_range(0,15)-8, 2);
    
    // 4.1: Motion X = +, Motion Y = +
    run_test_case( $urandom_range(1,8),  $urandom_range(1,8),  5);

    // 4.2: Motion X = +, Motion Y = -
    run_test_case( $urandom_range(1,8), -$urandom_range(1,8),  5);

    // 4.3: Motion X = -, Motion Y = +
    run_test_case(-$urandom_range(1,8),  $urandom_range(1,8),  5);

    // 4.4: Motion X = -, Motion Y = -
    run_test_case(-$urandom_range(1,8), -$urandom_range(1,8),  5);
    
    //5: Noise 
    run_test_case($urandom_range(0,15)-8, $urandom_range(0,15)-8, 3);
    
    
    //6. Amp
    run_test_case($urandom_range(0,15)-8, $urandom_range(0,15)-8, 4);
    
    mif.cb.start <= 1'b0;
    
    $display("\nAll tests completed\n\n");
    $finish;
  end
  
  task automatic run_test_case(input integer inputMotionX, input integer inputMotionY, input integer Type);
    begin
    
    $display("\n========================================================================================================================");
    $display("Running test %d: motionX=%d motionY=%d", counter, inputMotionX, inputMotionY);
    $display("========================================================================================================================");
    counter++;
    
    mif.cb.start <= 0;
    @(mif.cb);#10;
	  mif.cb.start <= 1'b1;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    // Change value of expected motion X and Y. Also change the Smem so that we can add for a perentage
    ////////////////////////////////////////////////////////////////////////////////////////////////////
        
    //randomize expected motionX and motionY
	  Expected_motionX = inputMotionX;	
	  Expected_motionY = inputMotionY;
    
    //randomize Smem
    //extract Rmem from Smem for Expected_motionX and Expected_motionY
    case (Type)
      0: begin // No Match - worst case
        foreach (Smem[i]) Smem[i] = 8'h00; 
        foreach (Rmem[i]) Rmem[i] = 8'hFF;
      end
      
      1: begin // Minimum case - Least change Best Distance
        foreach (Smem[i]) begin
		      Smem[i] = $urandom_range(0,255);
        end
        
        foreach (Rmem[i]) begin
			    Rmem[i] = Smem[32*8+8+(((i/16)+Expected_motionY)*32)+((i%16)+Expected_motionX)];
			    if(i==0) Rmem[i] = Rmem[i] +1; //to puturb pixle 0
        end	
      end
            
      2: begin // Max case - Most change best distance
        foreach (Smem[i]) begin
		      Smem[i] = 8'hFF;
        end
    
	      foreach (Rmem[i]) begin
			    Rmem[i] = 8'h00;
          if(i <= 1) Rmem[i] = 8'hFF; //to puturb pixle 0
        end
      end
      
      3: begin // Noise case
        foreach (Smem[i]) begin
		      Smem[i] = $urandom_range(0,255); 
        end
    
	      foreach (Rmem[i]) begin
			    Rmem[i] = Smem[32*8+8+(((i/16)+Expected_motionY)*32)+((i%16)+Expected_motionX)];
        end	
        
        //print memory contnet
	      $display("Original Reference Memory content:");
	      foreach (Rmem[i]) begin
		    if(i%16 == 0) $display("  ");
		    $write("%h  ",Rmem[i]);
		    if(i == 255) $display("  ");
        end
    
        noise_start_x = $urandom_range(0, 12);
        noise_start_y = $urandom_range(0, 12); // valid 4x4 start inside 16x16
        
        for (row = noise_start_y; row < noise_start_y + 4; row++) begin
            for (col = noise_start_x; col < noise_start_x + 4; col++) begin
        
                idx = row * 16 + col;
        
                noise = int'($urandom_range(0, 10)) - 5;
                base_val = int'(Rmem[idx]);
                noisy_val = base_val + noise;
                
                if (noisy_val > 255)
                    noisy_val = 255;
                else if (noisy_val < 0)
                    noisy_val = 0;
                
                Rmem[idx] = noisy_val[7:0];
            end
        end
      end
      
      4: begin // Amp case
        foreach (Smem[i]) begin
		      Smem[i] = $urandom_range(0,255); 
        end
    
	      foreach (Rmem[i]) begin
			    Rmem[i] = Smem[32*8+8+(((i/16)+Expected_motionY)*32)+((i%16)+Expected_motionX)];
        end	
        
        //print memory contnet
	      $display("Original Reference Memory content:");
	      foreach (Rmem[i]) begin
		    if(i%16 == 0) $display("  ");
		    $write("%h  ",Rmem[i]);
		    if(i == 255) $display("  ");
        end
    
        noise_start_x = $urandom_range(0, 12);
        noise_start_y = $urandom_range(0, 12); // valid 4x4 start inside 16x16
        
        noise = int'($urandom_range(0, 10)) - 5;
        
        for (row = noise_start_y; row < noise_start_y + 4; row++) begin
            for (col = noise_start_x; col < noise_start_x + 4; col++) begin
        
                idx = row * 16 + col;
        
                base_val = int'(Rmem[idx]);
                noisy_val = base_val + noise;
                
                if (noisy_val > 255)
                    noisy_val = 255;
                else if (noisy_val < 0)
                    noisy_val = 0;
                
                Rmem[idx] = noisy_val[7:0];
            end
        end
      end
            
      default: begin // 100% match
        foreach (Smem[i]) begin
		      Smem[i] = $urandom_range(0,255); 
        end
    
	      foreach (Rmem[i]) begin
			    Rmem[i] = Smem[32*8+8+(((i/16)+Expected_motionY)*32)+((i%16)+Expected_motionX)];
        end	
      end
      
    endcase

    //initilize memories
    foreach (memR_u.Rmem[i]) begin
      memR_u.Rmem[i]= Rmem[i];
    end
    
	  foreach (memS_u.Smem[i]) begin
      memS_u.Smem[i]= Smem[i];
    end		
    
    for(i=0;i<4112;i=i+1) begin
		    if ($root.top.DUT.comp_u.newBest == 1'b1) 
		    begin
          $display("New Result Coming!");
		    end
		    @(mif.cb);#10;
		end

    @(mif.cb);#10;
    if (mif.cb.motionX >= 8)
    
	    x = mif.cb.motionX - 16;
    else
	    x = mif.cb.motionX;
      
    if (mif.cb.motionY >= 8)
	    y = mif.cb.motionY - 16;
    else
	    y = mif.cb.motionY;
      
    // Print test results
    
    $display("\n");
    
    //print memory contnet
	  $display("Reference Memory content:");
	  foreach (Rmem[i]) begin
		  if(i%16 == 0) $display("  ");
		  $write("%h  ",Rmem[i]);
		  if(i == 255) $display("  ");
    end

    $display("\n");

    $display("Search Memory content:");
    foreach (Smem[i]) begin
		  if(i%32 == 0) $display("  ");
		  $write("%h  ",Smem[i]);
		  if(i == 1023) $display("  ");
    end
    
    $display("\n");
    
    compute_golden_model(golden_x, golden_y, golden_bestDist);
    
    $display("Golden result: BestDist=%0d, motionX=%0d, motionY=%0d",
             golden_bestDist, golden_x, golden_y);
    
    $display("DUT result:    BestDist=%0d, motionX=%0d, motionY=%0d",
             mif.cb.BestDist, $signed(mif.cb.motionX), $signed(mif.cb.motionY));
    
    if (mif.cb.BestDist !== golden_bestDist) begin
        $error("BestDist mismatch: DUT=%0d GOLDEN=%0d",
               mif.cb.BestDist, golden_bestDist);
    end
    
    if ($signed(mif.cb.motionX) !== golden_x || $signed(mif.cb.motionY) !== golden_y) begin
        $error("Motion mismatch: DUT=(%0d,%0d), GOLDEN=(%0d,%0d)",
               $signed(mif.cb.motionX), $signed(mif.cb.motionY), golden_x, golden_y);
    end
    else begin
        $display("PASS: DUT matches golden model.");
    end
    
    if (mif.cb.BestDist == 8'b11111111) begin
      $display("Reference Memory Not Found in the Search Window!");
    end
    else begin
      if (mif.cb.BestDist == 8'b00000000) begin
        $display("Perfect Match Found for Reference Memory in the Search Window : \nmotionX = %d, motionY = %d, Expected motionX = %d, Expected motionY = %d, BestDist = %d", 
                  x, y, Expected_motionX, Expected_motionY, mif.cb.BestDist);
      end
      else begin
        $display("Non-perfect Match Found for Reference Memory in the Search Window : \nmotionX = %d, motionY = %d, Expected motionX = %d, Expected motionY = %d, BestDist = %d",
                  x, y, Expected_motionX, Expected_motionY, mif.cb.BestDist,);
      end
    end
    
    $display("\n");
    
    if (x == Expected_motionX && y == Expected_motionY) begin
      $display("DUT motion outputs DO match expected motions: \nDUT motionX = %d DUT motionY = %d Expected_motionX = %d Expected_motionY = %d",
                x, y, Expected_motionX, Expected_motionY);
    end
    else begin
      $display("DUT motion outputs DO NOT match expected motions: \nDUT motionX = %d DUT motionY = %d Expected_motionX = %d Expected_motionY = %d\n",
                x, y, Expected_motionX, Expected_motionY);
    end
    
    $display("\n");
    
    end
  endtask
  
    task automatic compute_golden_model(
      output logic signed [4:0] golden_x,
      output logic signed [4:0] golden_y,
      output logic [7:0]        golden_bestDist
  );
      int x, y;
      int row, col;
      int r_idx;
      int s_idx;
      int diff;
      int sad;
      int best_sad;
  
      best_sad = 255;
      golden_x = 0;
      golden_y = 0;
      golden_bestDist = 8'hFF;
  
      // Motion range: -8 to +7 in both directions
      for (y = -8; y <= 7; y++) begin
          for (x = -8; x <= 7; x++) begin
  
              sad = 0;
  
              for (row = 0; row < 16; row++) begin
                  for (col = 0; col < 16; col++) begin
                      r_idx = row * 16 + col;
  
                      s_idx = (8 + y + row) * 32 + (8 + x + col);
  
                      diff = int'(Rmem[r_idx]) - int'(Smem[s_idx]);
  
                      if (diff < 0)
                          diff = -diff;
  
                      sad += diff;
  
                      // Match DUT behavior: SAD saturates at 255
                      if (sad > 255)
                          sad = 255;
                  end
              end
              if (sad < best_sad) begin
                  best_sad = sad;
                  golden_x = x;
                  golden_y = y;
                  golden_bestDist = sad[7:0];
              end
          end
      end
  endtask


    
endprogram