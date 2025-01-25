# SNES test roms  

Homebrew SNES test ROMs.  

## Test ROM  

* [SA1RamProtectionTest](SA1RamProtectionTest/)  
  Test the RAM protection of the SA-1.  
* [SA1RebootTest](SA1RamProtectionTest/)  
  Test the register values after rebooting SA-1.  

### Utility ROM  

These are ROMs created for hardware testing and do not match the expected values.  

* [PpuMultiplierUtility](PpuMultiplierUtility/)  
  It displays the result of accessing the PPU multipler calculation result in 1 CPU cycle (6 master cycles).  
* [SA1ReadRegisterDumpUtility](SA1ReadRegisterDumpUtility/)  
  SA-1 Read register boot initial values from both the SNES and SA-1 sides.  
* [SA1OpenbusUtility](SA1OpenbusUtility/)  
  Displays the value read from the specified address on both the SNES and SA-1 sides.  

## Test environment  

* SNES:  
  * Super Famicom (NTSC-J)  
  * Board: `SNSRGB01`  
* LoROM cartridge:  
  * Board: `SHVC-1A0N-20`  
* SA-1 cartridge:  
  * Board: `SHVC-1L5B-20` [(A4WJ)](https://absindx.github.io/ZpIndIndY/Articles/SnesSA1Cartridge/)  
    * Chip: `RF5A123 / 6KD 80`  
    * Chip: `RF5A123 / 6LF 8Y`  
  * Board: `SHVC-1L0B-01` [(A2WJ)](https://github.com/absindx/SNES-TestRoms/issues/2#issue-2447184008)  
    * Chip: `RF5A123 / 5GF 7N`  

## Technical information  

See [wiki](https://github.com/absindx/SNES-TestRoms/wiki) (It is written in Japanese).

## Assembler  

asar 1.81  

## License  

As a general rule, [Boost Software License 1.0](LICENSE) applies unless specified in each folder.  
