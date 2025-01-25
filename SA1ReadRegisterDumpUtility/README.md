# SA-1 read register dump utility  

**It is a utility ROM that does not judge.**  

SA-1 Read register boot initial values from both the SNES and SA-1 sides.  

## Test details  

If SNES Openbus activity is detected, it will display `OPEN`.  
[SA-1 BW-RAM Openbus](https://github.com/absindx/SNES-TestRoms/wiki/SA%E2%80%901-BW%E2%80%90RAM-Openbus) is set to `$BB`.  

## For automated testing  

The test ends when address `$000000 (TestFinished)` becomes non-zero.  
The meaning of the value of this address is `0=Running, 1=Finished` .  

See [RamMap.asm](RamMap.asm) for other memory usage.  

## Test environment  

* SNES:  
  * Super Famicom (NTSC-J)  
  * Board: `SNSRGB01`  
* SA-1 cartridge:  
  * Board: `SHVC-1L5B-20` [(A4WJ)](https://absindx.github.io/ZpIndIndY/Articles/SnesSA1Cartridge/)  
    * Chip: `RF5A123 / 6LF 8Y`  
  * Board: `SHVC-1L0B-01` [(A2WJ)](https://github.com/absindx/SNES-TestRoms/issues/2#issue-2447184008)  
    * Chip: `RF5A123 / 5GF 7N`  

### Hardware result  

| Board				| Power on						| Reset button						|
|:------------------------------|:-----------------------------------------------------:|:-----------------------------------------------------:|
| `SHVC-1L5B-20` (with BW-RAM)	| ![SHVC-1L5B-20 Power](Image/SHVC-1L5B-20%20Power.png)	| ![SHVC-1L5B-20 Reset](Image/SHVC-1L5B-20%20Reset.png)	|
| `SHVC-1L0B-01` (no BW-RAM)	| ![SHVC-1L0B-01 Power](Image/SHVC-1L0B-01%20Power.png)	| ![SHVC-1L0B-01 Reset](Image/SHVC-1L0B-01%20Reset.png)	|


