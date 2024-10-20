# SA-1 reboot test  

Tests the registers when SA-1 is reset from the SNES CPU.  

## Required  

Uses IRQ vector from SA-1 to SNES CPU for sending test data.  
No interrupts are generated.  

* `$220E-$220F SIV`  
* `$2209 SCNT.IVSW`  

## For automated testing  

The test ends when address `$000000 (TestFinished)` becomes non-zero.  
The meaning of the value of this address is:  

* `$00` = Running  
* `$01` = Passed  
* `$FF` = Failed  
* `$FE` = Halted (No response from SA-1)  

The screen text is at address `$001000 (TilemapBuffer)` .

See [RamMap.asm](RamMap.asm) for other memory usage.  

## Test details  

Enter the registers of SA-1 into a stop state with a specific value and reset them from the SNES side.  
Test the state of the registers of the rebooted SA-1.  

However, no strict checking.  
This is because there are registers whose values are indeterminate for electrical reasons.  

### Status   

The `x` parts are not tested.  

| Register	| (input) Reset status	| RST (Power on)			| RST (Reset button)				| `JMP`, `WAI`, `STP`			|
|:--------------|:----------------------|:--------------------------------------|:----------------------------------------------|:--------------------------------------|
| `A`		| `$AABB`		| `$0000`				| `$AABB`					| `$AABB`				|
| `X`		| `$CCDD`		| `$0000`				| `$00DD`					| `$00DD`				|
| `Y`		| `$EEFF`		| `$0000`				| `$00FF`					| `$00FF`				|
| `S`		| `$1234`		| `$01xx` (probably `$01FD` )		| `$01xx` (probably `$0131` )			| `$01xx` (probably `$0131` )		|
| `P`		| `$CB,0 NVmxDiZC e`	| `$34,1 nvMXdIzc E`			| `$F7,1 NVMXdIZC E`				| `$F7,1 NVMXdIZC E`			|
| `D`		| `$5678`		| `$0000`				| `$0000`					| `$0000`				|
| `K`		| `$80`			| `$00`					| `$00`						| `$00`					|
| `B`		| `$88`			| `$00`					| `$00`						| `$00`					|
| `$2306 MR1`	| `$11`			| `$xx` (probably `$FF` )		| `$xx` (probably SA-1 openbus or `$00` )	| `$11`					|
| `$2307 MR2`	| `$22`			| `$xx` (probably `$FF` )		| `$xx` (probably SA-1 openbus or `$00` )	| `$22`					|
| `$2308 MR3`	| `$33`			| `$xx` (probably `$00` )		| `$xx` (probably `$00` )			| `$33`					|
| `$2309 MR4`	| `$44`			| `$xx` (probably `$80` )		| `$xx` (probably `$00` )			| `$44`					|
| `$230A MR5`	| `$55`			| `$xx` (probably SA-1 openbus )	| `$xx` (probably SA-1 openbus or `$00` )	| `$55`					|
| `$230B OF`	| `$00`			| `$xx` (probably `$00` )		| `$xx` (probably `$00` )			| `$00`					|
| `$230C VDPL`	| `$66`			| `$xx`					| `$66`						| `$66`					|
| `$230D VDPH`	| `$77`			| `$xx`					| `$77`						| `$77`					|

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

| Board				| Power on						| Reset button						|
|:------------------------------|:-----------------------------------------------------:|:-----------------------------------------------------:|
| `SHVC-1L5B-20` (with BW-RAM)	| ![SHVC-1L5B-20 Power](Image/SHVC-1L5B-20%20Power.png)	| ![SHVC-1L5B-20 Reset](Image/SHVC-1L5B-20%20Reset.png)	|
| `SHVC-1L0B-01` (no BW-RAM)	| ![SHVC-1L0B-01 Power](Image/SHVC-1L0B-01%20Power.png)	| ![SHVC-1L0B-01 Reset](Image/SHVC-1L0B-01%20Reset.png)	|


