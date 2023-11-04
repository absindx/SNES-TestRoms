;--------------------------------------------------
; IO name - SA-1
;--------------------------------------------------

includeonce

!SA1_CCNT		= $2200 ;W IRrN mmmm  (SNES) SA-1 CPU control
!SA1_SIE		= $2201 ;W I-C- ----  (SNES) Super NES CPU int enable
!SA1_SIC		= $2202 ;W I-C- ----  (SNES) Super NES CPU int clear
!SA1_CRVL		= $2203 ;W aaaa aaaa  (SNES) SA-1 CPU reset vector (Low)
!SA1_CRVH		= $2204 ;W aaaa aaaa  (SNES) SA-1 CPU reset vector (High)
!SA1_CNVL		= $2205 ;W aaaa aaaa  (SNES) SA-1 CPU NMI vector (Low)
!SA1_CNVH		= $2206 ;W aaaa aaaa  (SNES) SA-1 CPU NMI vector (High)
!SA1_CIVL		= $2207 ;W aaaa aaaa  (SNES) SA-1 CPU IRQ vector (Low)
!SA1_CIVH		= $2208 ;W aaaa aaaa  (SNES) SA-1 CPU IRQ vector (High)
!SA1_SCNT		= $2209 ;W IS-N mmmm  (SA-1) Super NES CPU control
!SA1_CIE		= $220A ;W ITDN ----  (SA-1) SA-1 CPU int enable
!SA1_CIC		= $220B ;W ITDN ----  (SA-1) SA-1 CPU int clear
!SA1_SNVL		= $220C ;W aaaa aaaa  (SA-1) Super NES CPU NMI vector (Low)
!SA1_SNVH		= $220D ;W aaaa aaaa  (SA-1) Super NES CPU NMI vector (High)
!SA1_SIVL		= $220E ;W aaaa aaaa  (SA-1) Super NES CPU IRQ vector (Low)
!SA1_SIVH		= $220F ;W aaaa aaaa  (SA-1) Super NES CPU IRQ vector (High)
!SA1_TMC		= $2210 ;W T--- --VH  (SA-1) H/V timer control
!SA1_CTR		= $2211 ;W ---- ----  (SA-1) SA-1 CPU timer restart
!SA1_HCNTL		= $2212 ;W HHHH HHHH  (SA-1) Set H-Count (Low)
!SA1_HCNTH		= $2213 ;W ---- ---H  (SA-1) Set H-Count (High)
!SA1_VCNTL		= $2214 ;W VVVV VVVV  (SA-1) Set V-Count (Low)
!SA1_VCNTH		= $2215 ;W ---- ---V  (SA-1) Set V-Count (High)

!SA1_CXB		= $2220 ;W B--- -AAA  (SNES) Set Super MMC bank C
!SA1_DXB		= $2221 ;W B--- -AAA  (SNES) Set Super MMC bank D
!SA1_EXB		= $2222 ;W B--- -AAA  (SNES) Set Super MMC bank E
!SA1_FXB		= $2223 ;W B--- -AAA  (SNES) Set Super MMC bank F
!SA1_BMAPS		= $2224 ;W ---B BBBB  (SNES) Super NES CPU BW-RAM address mapping
!SA1_BMAP		= $2225 ;W SBBB BBBB  (SA-1) SA-1 CPU BW-RAM address mapping
!SA1_SBWE		= $2226 ;W P--- ----  (SNES) Super NES CPU BW-RAM write enable
!SA1_CBWE		= $2227 ;W P--- ----  (SA-1) SA-1 CPU BW-RAM write enable
!SA1_BWPA		= $2228 ;W ---- AAAA  (SNES) BW-RAM Write-Protected area
!SA1_SIWP		= $2229 ;W 7654 3210  (SNES) Super NES I-RAM wirte protection
!SA1_CIWP		= $222A ;W 7654 3210  (SA-1) SA-1 I-RAM wirte protection

!SA1_DCNT		= $2230 ;W CPMT -DSS  (SA-1) DMA control
!SA1_CDMA		= $2231 ;W E--S SSCC  (SA-1) Character conversion DMA parameters
!SA1_SDAL		= $2232 ;W AAAA AAAA  (SNES/SA-1) DMA source device start address (Low)
!SA1_SDAH		= $2233 ;W AAAA AAAA  (SNES/SA-1) DMA source device start address (Middle)
!SA1_SDAB		= $2234 ;W AAAA AAAA  (SNES/SA-1) DMA source device start address (High)
!SA1_DDAL		= $2235 ;W AAAA AAAA  (SNES/SA-1) DMA destination start address (Low)
!SA1_DDAH		= $2236 ;W AAAA AAAA  (SNES/SA-1) DMA destination start address (Middle)
!SA1_DDAB		= $2237 ;W AAAA AAAA  (SNES/SA-1) DMA destination start address (High)
!SA1_DTCL		= $2238 ;W CCCC CCCC  (SA-1) DMA terminal counter (Low)
!SA1_DTCH		= $2239 ;W CCCC CCCC  (SA-1) DMA terminal counter (High)

!SA1_BBF		= $223F ;W C--- ----  (SA-1) BW-RAM bit map format
!SA1_BRF0		= $2240 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 1)
!SA1_BRF1		= $2241 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 1)
!SA1_BRF2		= $2242 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 1)
!SA1_BRF3		= $2243 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 1)
!SA1_BRF4		= $2244 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 1)
!SA1_BRF5		= $2245 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 1)
!SA1_BRF6		= $2246 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 1)
!SA1_BRF7		= $2247 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 1)
!SA1_BRF8		= $2248 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 2)
!SA1_BRF9		= $2249 ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 2)
!SA1_BRFA		= $224A ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 2)
!SA1_BRFB		= $224B ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 2)
!SA1_BRFC		= $224C ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 2)
!SA1_BRFD		= $224D ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 2)
!SA1_BRFE		= $224E ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 2)
!SA1_BRFF		= $224F ;W BBBB BBBB  (SA-1) Bit map register file (Buffer 2)
!SA1_MCNT		= $2250 ;W ---- --OO  (SA-1) Arithmetic control
!SA1_MAL		= $2251 ;W NNNN NNNN  (SA-1) Arithmetic parameters: Multiplicand / Dividend (Low)
!SA1_MAH		= $2252 ;W NNNN NNNN  (SA-1) Arithmetic parameters: Multiplicand / Dividend (High)
!SA1_MBL		= $2253 ;W NNNN NNNN  (SA-1) Arithmetic parameters: Multiplier / Divisor (Low)
!SA1_MBH		= $2254 ;W NNNN NNNN  (SA-1) Arithmetic parameters: Multiplier / Divisor (High)

!SA1_VBD		= $2258 ;W H--- VVVV  (SA-1) Variable-Length bit processing
!SA1_VDAL		= $2259 ;W AAAA AAAA  (SA-1) Variable-Length bit game pak ROM start address (Low)
!SA1_VDAH		= $225A ;W AAAA AAAA  (SA-1) Variable-Length bit game pak ROM start address (Middle)
!SA1_VDAB		= $225B ;W AAAA AAAA  (SA-1) Variable-Length bit game pak ROM start address (High)

!SA1_SFR		= $2300 ;R IVDN mmmm  (SNES) Super NES CPU flag read
!SA1_CFR		= $2301 ;R ITDN mmmm  (SA-1) SA-1 CPU flag read
!SA1_HCRL		= $2302 ;R HHHH HHHH  (SA-1) H-Count read (Low)
!SA1_HCRH		= $2303 ;R ---- ---H  (SA-1) H-Count read (High)
!SA1_VCRL		= $2304 ;R VVVV VVVV  (SA-1) V-Count read (Low)
!SA1_VCRH		= $2305 ;R ---- ---V  (SA-1) V-Count read (High)
!SA1_MR1		= $2306 ;R DDDD DDDD  (SA-1) Arithmetic result (product/quotient/cumulative sum)
!SA1_MR2		= $2307 ;R DDDD DDDD  (SA-1) Arithmetic result (product/quotient/cumulative sum)
!SA1_MR3		= $2308 ;R DDDD DDDD  (SA-1) Arithmetic result (product/remainder/cumulative sum)
!SA1_MR4		= $2309 ;R DDDD DDDD  (SA-1) Arithmetic result (product/remainder/cumulative sum)
!SA1_MR5		= $230A ;R DDDD DDDD  (SA-1) Arithmetic result (cumulative sum)
!SA1_OF			= $230B ;R O--- ----  (SA-1) Arithmetic overflow flag
!SA1_VDPL		= $230C ;R DDDD DDDD  (SA-1) Variable-Length data read port (Low)
!SA1_VDPH		= $230D ;R DDDD DDDD  (SA-1) Variable-Length data read port (High)
!SA1_VC			= $230E ;R VVVV VVVV  (SNES) Version code register

