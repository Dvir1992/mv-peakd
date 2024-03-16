# mv-peakd
I created a verification environment using uvm. the environment checks a design which get a noisy signal and output a clean signal and its peak data. 

The design has 2 main blocks:
1.movavg_fltr (can be seen in moving_average.v file): 
  a. when the block is enabled and the valid signal (vald_din) is high, it gets data with the size of 12 bits each clock.
  b. when the valid out signal (valid_out) is high, the block outputs new data according to the explanation in mv_logic file.
2.peak_detector (can be seen in peak_detector.v file): 
 a.  when the block is enabled and the valid signal (vald_data) is high, it gets data with the size of 12 bits each clock from the movavg_fltr module.
 b.  when the valid out signal (peak_valid) is high, the block outputs the pixel with the 'peak' data according to the explanation in peakd file.

* The module 'top' (can be seen in design.sv file) connects the the two modules described above.

* The verification environment using 3 tests to check the design:
    1. test_mv: using the transaction class as sequence item to send data to the driver. in this test the peak_detector module is not enabled and the movavg_fltr module is enabled. The goal is to check the movavg_fltr module alone with data that not relvant for peak 
       detector chek. the check is performed by the scoreboared right after the block outputs the data (can ben seen in inside_check file).
    2. test_pd: using the transaction_pd class (a derived class of transaction) as sequence item to send data to the driver. in this test the peak_detector module is enabled and the movavg_fltr module is not enabled. The goal is to check the peak_detector module alone   
       with data that relevant for peak detector check. the check is performed by the scoreboared right after the block outputs the data (can ben seen in inside_check file).
    3. test_both: using the transaction_both class as sequence item to send data to the driver. in this test the peak_detector module is enabled and the movavg_fltr module is enabled. The goal is to check the movavg_fltr module and the peak_detector module together with          data that relevant for peak detctor check (for the movavg_fltr the data just need to be random).

* You can watch the file full_env to watch all the blocks (verification and design) together.

* Bugs:
    1. I found that the movavg_fltr module never outputs the first data correctly. To verify my environment and the movavg_fltr ref model, I checked the inputs of the movavg_fltr module in the waveform and I performed a manual calculation. The result proved that the 
        movavg_fltr ref model is correct (bugs can be seen in the 'errors in the data_check out of the moving average block' file.
    2.  I found that part of the peak_info of the peak_detector module is not correct. I did the same process that I did in section 1 and the result proved that the peak_detector ref model is correct. errors can be seen in the 'data_check out of the peak detection block'
        file.
 
    * Another verification I did is checking my understanding of the architecture. From the data I had, It seemes that I created the both ref models according to the architecture.


* Things I improved and learn from this mission:
    1. Good understanding of factory overriding and polymorphism and how its relevant and useful in uvm verifcation environment.
    2. How to check a design with many blocks in one verification environment by using different tests in a comfortable way.
    3. delaying the simulation finish after the sequence items sequencer fifo is empty by using built-in 'phase_ready_to_end' function (raises one more objection after the the last objection is dropped).
    4. improving my systemverilog and uvm skills.
        
  
