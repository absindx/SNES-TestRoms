# SA-1 RAM protection test  

TODO: Write later

## Required  

Uses IRQ from SA-1 to SNES CPU for sending test data.

* `$220E-$220F SIV`
* `$2209 SCNT.IVSW`
* `$00FFEE NativeMode IRQ`

## Notes  

* TEST ID : 35, 38  
  BW-RAM Protection will not be reflected unless protection is enabled on both SNES and SA-1.  
* TEST ID : 93-144  
  BW-RAM Protection's BWPA is for SNES CPUs, but also affects SA-1.  

## For automated testing  

The test ends when address `$000000 (TestFinished)` becomes non-zero.  
The meaning of the value of this address is `0=Running, 1=Passed, 255=Failed` .  

See [RamMap.asm](RamMap.asm) for other memory usage.  

## Test environment  

* SNES:  
  * Board: `SNSRGB01`  
* SA-1:  
  * Board: `SHVC-1L5B-20` [(A4WJ expanded to 1Mbit SRAM)](https://absindx.github.io/ZpIndIndY/Articles/SnesSA1Cartridge/)  
  * Chip: `RF5A123 / 6KD 80`  


