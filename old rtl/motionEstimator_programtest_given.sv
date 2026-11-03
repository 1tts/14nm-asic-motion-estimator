// Compile line: vcs -sverilog -full64 motionEstimator_interface.sv motionEstimator.v motionEstimator_programtest_given.sv motionEstimator_top.sv -o output.simv -debug_access+all -kdb

`timescale 1ns/1ps
`default_nettype none
program motionEstimator_programtest(motionEstimator_interface.TB mif);

  reg [7:0]	    Rmem[0:255]; 
  reg [7:0]	    Smem[0:1023];
  
  integer Expected_motionX, Expected_motionY;
  integer 		i;
  integer 		j;
  integer signed x, y;

  initial 
    begin
    $vcdpluson;
    $monitor("time=%5d ns, start = %b, BestDist = %b, motionX =%d, motionY =%d", $time, mif.start, mif.BestDist[7:0], mif.motionX[3:0], mif.motionY[3:0]);
    

    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Start of Testing
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    mif.cb.start <= 0;
    @(mif.cb);#10;
	  mif.cb.start <= 1'b1;
        
    //randomize expected motionX and motionY
	  Expected_motionX = $urandom_range(0,15)-8;	
	  Expected_motionY = $urandom_range(0,15)-8;
    
    //randomize Smem
	  foreach (Smem[i]) begin
		  Smem[i] = $urandom_range(0,255);
    end
    
    //extract Rmem from Smem for Expected_motionX and Expected_motionY
	  foreach (Rmem[i]) begin
			Rmem[i] = Smem[32*8+8+(((i/16)+Expected_motionY)*32)+((i%16)+Expected_motionX)];
			//if(i==0) Rmem[i] = Rmem[i] +1; //to puturb pixle 0
		end	
    
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
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // End of Testing
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    mif.cb.start <= 1'b0;
    
    $display("\nAll tests completed\n\n");
    $finish;
  end
  
endprogram