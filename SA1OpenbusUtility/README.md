# SA-1 Openbus utility  

**It is a utility ROM that does not judge.**  

## For automated testing  

The test ends when address `$000000 (TestFinished)` becomes non-zero.  
The meaning of the value of this address is `0=Running, 1=Finished` .  

See [RamMap.asm](RamMap.asm) for other memory usage.  

## Test details  

Displays the value read from the specified address on both the SNES and SA-1 sides.  
Test the SNES Openbus value against the high byte of the target address and `$AA`.  
[SA-1 BW-RAM Openbus](https://github.com/absindx/SNES-TestRoms/wiki/SA%E2%80%901-BW%E2%80%90RAM-Openbus) is set to `$BB`.  
BW-RAM is initialized with `$CC`.  
The list of addresses to test is in `TestPattern.asm`.  

## Test environment  

* SNES:  
  * Super Famicom  
  * Board: `SNSRGB01`  
* SA-1 cartridge:  
  * Board: `SHVC-1L5B-20` [(A4WJ)](https://absindx.github.io/ZpIndIndY/Articles/SnesSA1Cartridge/)  
    * Chip: `RF5A123 / 6LF 8Y`  
  * Board: `SHVC-1L0B-01` [(A2WJ)](https://github.com/absindx/SNES-TestRoms/issues/2#issue-2447184008)  
    * Chip: `RF5A123 / 5GF 7N`  

### Hardware result  

| Board				| Mode1							| Mode2							|
|:------------------------------|:-----------------------------------------------------:|:-----------------------------------------------------:|
| `SHVC-1L5B-20` (with BW-RAM)	| ![SHVC-1L5B-20 Power](Image/SHVC-1L5B-20%20Mode1.png)	| ![SHVC-1L5B-20 Power](Image/SHVC-1L5B-20%20Mode2.png)	|
| `SHVC-1L0B-01` (no BW-RAM)	| ![SHVC-1L0B-01 Power](Image/SHVC-1L0B-01%20Mode1.png)	| ![SHVC-1L0B-01 Power](Image/SHVC-1L0B-01%20Mode2.png)	|


