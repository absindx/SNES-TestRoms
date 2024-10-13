# SA-1 reboot test  

Tests the registers when SA-1 is reset from the SNES CPU.  

**under development**  
Result judgment is not implemented yet.  


## For automated testing  

The test ends when address `$000000 (TestFinished)` becomes non-zero.  
The meaning of the value of this address is:  

* `$00` = Running  
* `$01` = Passed  
* `$FF` = Failed  
* `$FE` = Halted (No response from SA-1)  

See [RamMap.asm](RamMap.asm) for other memory usage.  

## Test environment  

* SNES:  
  * Super Famicom  
  * Board: `SNSRGB01`  
* SA-1 cartridge:  
  * Board: `SHVC-1L5B-20` [(A4WJ)](https://absindx.github.io/ZpIndIndY/Articles/SnesSA1Cartridge/)  
  * Chip: `RF5A123 / 6LF 8Y`  


