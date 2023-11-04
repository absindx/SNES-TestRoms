;--------------------------------------------------
; IO name - Standard(PPU, CPU)
;--------------------------------------------------

includeonce

; PPU registers (Address Bus B)

!PPU_INIDISP		= $2100	;W  B--- FFFF  Initial settings for screen
!PPU_OBJSEL		= $2101	;W  SSSN NAAA  Object size & Object data area designation
!PPU_OAMADDL		= $2102	;W  AAAA AAAA  Address for accessing OAM (Low)
!PPU_OAMADDH		= $2103	;W  P--- ---A  Address for accessing OAM (High)
!PPU_OAMDATA		= $2104	;W  DDDD DDDD  Data for OAM write
!PPU_BGMODE		= $2105	;W  SSSS PMMM  BG mode & Character size settings
!PPU_MOSAIC		= $2106	;W  MMMM EEEE  Size & Screen designation for mosaic display
!PPU_BG1SC		= $2107	;W  AAAA AASS  Address for storing SC-data of each BG & SC size designation (Mode 0-6) (BG-1)
!PPU_BG2SC		= $2108	;W  AAAA AASS  Address for storing SC-data of each BG & SC size designation (Mode 0-6) (BG-2)
!PPU_BG3SC		= $2109	;W  AAAA AASS  Address for storing SC-data of each BG & SC size designation (Mode 0-6) (BG-3)
!PPU_BG4SC		= $210A	;W  AAAA AASS  Address for storing SC-data of each BG & SC size designation (Mode 0-6) (BG-4)
!PPU_BG12NBA		= $210B	;W  2222 1111  BG character data area designation (BG-1, 2)
!PPU_BG34NBA		= $210C	;W  4444 3333  BG character data area designation (BG-3, 4)
!PPU_BG1HOFS		= $210D	;WW XXXX XXXX, ---X XXXX  H scroll value designation for BG-1
!PPU_BG1VOFS		= $210E	;WW XXXX XXXX, ---X XXXX  V scroll value designation for BG-1
!PPU_BG2HOFS		= $210F	;WW XXXX XXXX, ---- --XX  H scroll value designation for BG-2
!PPU_BG2VOFS		= $2110	;WW XXXX XXXX, ---- --XX  V scroll value designation for BG-2
!PPU_BG3HOFS		= $2111	;WW XXXX XXXX, ---- --XX  H scroll value designation for BG-3
!PPU_BG3VOFS		= $2112	;WW XXXX XXXX, ---- --XX  V scroll value designation for BG-3
!PPU_BG4HOFS		= $2113	;WW XXXX XXXX, ---- --XX  H scroll value designation for BG-4
!PPU_BG4VOFS		= $2114	;WW XXXX XXXX, ---- --XX  V scroll value designation for BG-4
!PPU_VMAINC		= $2115	;W  T--- GGII  VRAM address increment value designation
!PPU_VMADDL		= $2116	;W  AAAA AAAA  Address for VRAM read and write (Low)
!PPU_VMADDH		= $2117	;W  AAAA AAAA  Address for VRAM read and write (High)
!PPU_VMDATAL		= $2118	;W  AAAA AAAA  Data for VRAM write (Low)
!PPU_VMDATAH		= $2119	;W  AAAA AAAA  Data for VRAM write (High)
!PPU_M7SEL		= $211A	;W  SS-- --VH  Initial setting in screen Mode-7
!PPU_M7A		= $211B	;WW AAAA AAAA, AAAA AAAA  Rotation/Enlargement/Reduction in Mode-7, Matrix parameter A (Low, High)
!PPU_M7B		= $211C	;WW BBBB BBBB, BBBB BBBB  Rotation/Enlargement/Reduction in Mode-7, Matrix parameter B (Low, High)
!PPU_M7C		= $211D	;WW CCCC CCCC, CCCC CCCC  Rotation/Enlargement/Reduction in Mode-7, Matrix parameter C (Low, High)
!PPU_M7D		= $211E	;WW DDDD DDDD, DDDD DDDD  Rotation/Enlargement/Reduction in Mode-7, Matrix parameter D (Low, High)
!PPU_M7X		= $211F	;WW XXXX XXXX, ---X XXXX  Rotation/Enlargement/Reduction in Mode-7, Center position X0 (Low, High)
!PPU_M7Y		= $2120	;WW YYYY YYYY, ---Y YYYY  Rotation/Enlargement/Reduction in Mode-7, Center position Y0 (Low, High)
!PPU_CGADD		= $2121	;W  AAAA AAAA  Address for CG-RAM read and write
!PPU_CGDATA		= $2122	;WW DDDD DDDD, -DDD DDDD  Data for CG-RAM write
!PPU_W12SEL		= $2123	;W  EIEI EIEI  Window mask settings (BG-1, 2)
!PPU_W34SEL		= $2124	;W  EIEI EIEI  Window mask settings (BG-3, 4)
!PPU_WOBJSEL		= $2125	;W  EIEI EIEI  Window mask settings (OBJ, Color)
!PPU_WH0		= $2126	;W  PPPP PPPP  Window position designation (Window-1 left position)
!PPU_WH1		= $2127	;W  PPPP PPPP  Window position designation (Window-1 right position)
!PPU_WH2		= $2128	;W  PPPP PPPP  Window position designation (Window-2 left position)
!PPU_WH3		= $2129	;W  PPPP PPPP  Window position designation (Window-2 right position)
!PPU_WBGLOG		= $212A	;W  4433 2211  Mask logic settings for Window-1 & 2 on each screen
!PPU_WOBJLOG		= $212B	;W  ---- CCOO  Mask logic settings for Window-1 & 2 on each screen
!PPU_TM			= $212C	;W  ---O 4321  Main screen designation
!PPU_TS			= $212D	;W  ---O 4321  Sub screen designation
!PPU_TMW		= $212E	;W  ---O 4321  Window mask designation for main screen
!PPU_TSW		= $212F	;W  ---O 4321  Window mask designation for sub screen
!PPU_CGSWSEL		= $2130	;W  MMSS --CD  Initial settings for fixed color addition on screen addition
!PPU_CGADSUB		= $2131	;W  SEBO 4321  Addition/Subtraction & Subtraction designation for each BG screen OBJ & Background color
!PPU_COLDATA		= $2132	;W  BGRD DDDD  Fixed color data for fixed color addition/subtraction
!PPU_SETINI		= $2133	;W  SI-- PBOI  Screen initial setting
!PPU_MPYL		= $2134	;R  MMMM MMMM  Multiplication result (Low)
!PPU_MPYM		= $2135	;R  MMMM MMMM  Multiplication result (Middle)
!PPU_MPYH		= $2136	;R  MMMM MMMM  Multiplication result (High)
!PPU_SLHV		= $2137	;-  SSSS SSSS  Software latch for H/V counter
!PPU_OAMDATAREAD	= $2138	;RR DDDD DDDD, DDDD DDDD  Read data from OAM
!PPU_VMDATALREAD	= $2139	;R  DDDD DDDD  Read data from VRAM (Low)
!PPU_VMDATAHREAD	= $213A	;R  DDDD DDDD  Read data from VRAM (High)
!PPU_CGDATAREAD		= $213B	;RR DDDD DDDD, -DDD DDDD  Read data from CG-RAM
!PPU_OPHCT		= $213C	;RR HHHH HHHH, ---- ---H  H counter data by external or software latch
!PPU_OPVCT		= $213D	;RR VVVV VVVV, ---- ---V  V counter data by external or software latch
!PPU_STAT77		= $213E	;R  TRM- VVVV  PPU status flag & Version number (5C77)
!PPU_STAT78		= $213F	;R  FL-D VVVV  PPU status flag & Version number (5C78)
!APU_APUIO0		= $2140	;RW DDDD DDDD  Communication port with APU
!APU_APUIO1		= $2141	;RW DDDD DDDD  Communication port with APU
!APU_APUIO2		= $2142	;RW DDDD DDDD  Communication port with APU
!APU_APUIO3		= $2143	;RW DDDD DDDD  Communication port with APU
!WRAM_WMDATA		= $2180	;RW DDDD DDDD  DATA to consecutively read from and write to WRAM
!WRAM_WMADDL		= $2181	;W  AAAA AAAA  Address to consecutively read and write WRAM (Low)
!WRAM_WMADDM		= $2182	;W  AAAA AAAA  Address to consecutively read and write WRAM (Middle)
!WRAM_WMADDH		= $2183	;W  ---- ---A  Address to consecutively read and write WRAM (High)



; CPU registers (Internal)

!CPU_NMITIMEN		= $4200	;W  N-VH ---C  Enable flag for V-Blank, Timer interrupt & Standard controller read
!CPU_WRIO		= $4201	;W  DDDD DDDD  Programmable I/O port (Out port)
!CPU_WRMPYA		= $4202	;W  AAAA AAAA  Multiplicand by multiplication
!CPU_WRMPYB		= $4203	;W  BBBB BBBB  Multiplier by multiplication
!CPU_WRDIVL		= $4204	;W  CCCC CCCC  Dividend by divide (Low)
!CPU_WRDIVH		= $4205	;W  CCCC CCCC  Dividend by divide (High)
!CPU_WRDIVB		= $4206	;W  BBBB BBBB  Divisor by divide
!CPU_HTIMEL		= $4207	;W  HHHH HHHH  H-count timer settings (Low)
!CPU_HTIMEH		= $4208	;W  ---- ---H  H-count timer settings (High)
!CPU_VTIMEL		= $4209	;W  VVVV VVVV  V-count timer settings (Low)
!CPU_VTIMEH		= $420A	;W  ---- ---V  V-count timer settings (High)
!CPU_MDMAEN		= $420B	;W  7654 3210  Channel designation for general purpose DMA & Trigger (start)
!CPU_HDMAEN		= $420C	;W  7654 3210  Channel designation for H-DMA
!CPU_MEMSEL		= $420D	;W  ---- ---A  Access cycle designation in memory [2] area
!CPU_RDNMI		= $4210	;R  N--- VVVV  NMI flag by V-Blank & Version number
!CPU_TIMEUP		= $4211	;R  T--- ----  IRQ flag by H/V count timer
!CPU_HVBJOY		= $4212	;R  VH-- ---C  H/V Blank flag & Standard controller enable flag
!CPU_RDIO		= $4213	;R  DDDD DDDD  Programmable I/O port (In port)
!CPU_RDDIVL		= $4214	;R  AAAA AAAA  Quotient of divide result (Low)
!CPU_RDDIVH		= $4215	;R  AAAA AAAA  Quotient of divide result (High)
!CPU_RDMPYL		= $4216	;R  CCCC CCCC  Product of multiplication result or remainder of divide result (Low)
!CPU_RDMPYH		= $4217	;R  CCCC CCCC  Product of multiplication result or remainder of divide result (High)
!CPU_STDCNTRL1L		= $4218	;R  AXLR ----  Data for standard controller 1 (Low)
!CPU_STDCNTRL1H		= $4219	;R  BYST UDLR  Data for standard controller 1 (High)
!CPU_STDCNTRL2L		= $421A	;R  AXLR ----  Data for standard controller 2 (Low)
!CPU_STDCNTRL2H		= $421B	;R  BYST UDLR  Data for standard controller 2 (High)
!CPU_STDCNTRL3L		= $421C	;R  AXLR ----  Data for standard controller 3 (Low)
!CPU_STDCNTRL3H		= $421D	;R  BYST UDLR  Data for standard controller 3 (High)
!CPU_STDCNTRL4L		= $421E	;R  AXLR ----  Data for standard controller 4 (Low)
!CPU_STDCNTRL4H		= $421F	;R  BYST UDLR  Data for standard controller 4 (High)



; Old Style Joypad Registers

!JOY_JOYSER0		= $4016	;R: ---- --31 W: ---- -xxL
!JOY_JOYSER1		= $4017	;R  ---- --42



; DMA / HDMA Registers

!DMA_DMAP0		= $4300	;RW DT-I FDDD  Parameter for DMA transfer (Channel 0)
!DMA_BBAD0		= $4301	;RW AAAA AAAA  B-bus address for DMA (Channel 0)
!DMA_A1T0L		= $4302	;RW AAAA AAAA  Table address of A-bus for DMA (Low) (Channel 0)
!DMA_A1T0H		= $4303	;RW AAAA AAAA  Table address of A-bus for DMA (High) (Channel 0)
!DMA_A1B0		= $4304	;RW BBBB BBBB  Table address of A-bus for DMA (Bank) (Channel 0)
!DMA_DAS0L		= $4305	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (Low) (Channel 0)
!DMA_DAS0H		= $4306	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (High) (Channel 0)
!DMA_DASB0		= $4307	;RW BBBB BBBB  Data address store by H-DMA (Bank) (Channel 0)
!DMA_A2A0L		= $4308	;RW AAAA AAAA  Table address of A-bus by DMA (Low) (Channel 0)
!DMA_A2A0H		= $4309	;RW AAAA AAAA  Table address of A-bus by DMA (High) (Channel 0)
!DMA_NTLR0		= $430A	;RW CLLL LLLL  The number of lines to be transferred by H-DMA (Channel 0)
!DMA_DMAUNKNOWN00	= $430B	;RW ???? ????  Unknown (Channel 0)
!DMA_DMAUNKNOWN01	= $430F	;RW ???? ????  Unknown (Channel 0)
!DMA_DMAP1		= $4310	;RW DT-I FDDD  Parameter for DMA transfer (Channel 1)
!DMA_BBAD1		= $4311	;RW AAAA AAAA  B-bus address for DMA (Channel 1)
!DMA_A1T1L		= $4312	;RW AAAA AAAA  Table address of A-bus for DMA (Low) (Channel 1)
!DMA_A1T1H		= $4313	;RW AAAA AAAA  Table address of A-bus for DMA (High) (Channel 1)
!DMA_A1B1		= $4314	;RW BBBB BBBB  Table address of A-bus for DMA (Bank) (Channel 1)
!DMA_DAS1L		= $4315	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (Low) (Channel 1)
!DMA_DAS1H		= $4316	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (High) (Channel 1)
!DMA_DASB1		= $4317	;RW BBBB BBBB  Data address store by H-DMA (Bank) (Channel 1)
!DMA_A2A1L		= $4318	;RW AAAA AAAA  Table address of A-bus by DMA (Low) (Channel 1)
!DMA_A2A1H		= $4319	;RW AAAA AAAA  Table address of A-bus by DMA (High) (Channel 1)
!DMA_NTLR1		= $431A	;RW CLLL LLLL  The number of lines to be transferred by H-DMA (Channel 1)
!DMA_DMAUNKNOWN10	= $431B	;RW ???? ????  Unknown (Channel 1)
!DMA_DMAUNKNOWN11	= $431F	;RW ???? ????  Unknown (Channel 1)
!DMA_DMAP2		= $4320	;RW DT-I FDDD  Parameter for DMA transfer (Channel 2)
!DMA_BBAD2		= $4321	;RW AAAA AAAA  B-bus address for DMA (Channel 2)
!DMA_A1T2L		= $4322	;RW AAAA AAAA  Table address of A-bus for DMA (Low) (Channel 2)
!DMA_A1T2H		= $4323	;RW AAAA AAAA  Table address of A-bus for DMA (High) (Channel 2)
!DMA_A1B2		= $4324	;RW BBBB BBBB  Table address of A-bus for DMA (Bank) (Channel 2)
!DMA_DAS2L		= $4325	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (Low) (Channel 2)
!DMA_DAS2H		= $4326	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (High) (Channel 2)
!DMA_DASB2		= $4327	;RW BBBB BBBB  Data address store by H-DMA (Bank) (Channel 2)
!DMA_A2A2L		= $4328	;RW AAAA AAAA  Table address of A-bus by DMA (Low) (Channel 2)
!DMA_A2A2H		= $4329	;RW AAAA AAAA  Table address of A-bus by DMA (High) (Channel 2)
!DMA_NTLR2		= $432A	;RW CLLL LLLL  The number of lines to be transferred by H-DMA (Channel 2)
!DMA_DMAUNKNOWN20	= $432B	;RW ???? ????  Unknown (Channel 2)
!DMA_DMAUNKNOWN21	= $432F	;RW ???? ????  Unknown (Channel 2)
!DMA_DMAP3		= $4330	;RW DT-I FDDD  Parameter for DMA transfer (Channel 3)
!DMA_BBAD3		= $4331	;RW AAAA AAAA  B-bus address for DMA (Channel 3)
!DMA_A1T3L		= $4332	;RW AAAA AAAA  Table address of A-bus for DMA (Low) (Channel 3)
!DMA_A1T3H		= $4333	;RW AAAA AAAA  Table address of A-bus for DMA (High) (Channel 3)
!DMA_A1B3		= $4334	;RW BBBB BBBB  Table address of A-bus for DMA (Bank) (Channel 3)
!DMA_DAS3L		= $4335	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (Low) (Channel 3)
!DMA_DAS3H		= $4336	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (High) (Channel 3)
!DMA_DASB3		= $4337	;RW BBBB BBBB  Data address store by H-DMA (Bank) (Channel 3)
!DMA_A2A3L		= $4338	;RW AAAA AAAA  Table address of A-bus by DMA (Low) (Channel 3)
!DMA_A2A3H		= $4339	;RW AAAA AAAA  Table address of A-bus by DMA (High) (Channel 3)
!DMA_NTLR3		= $433A	;RW CLLL LLLL  The number of lines to be transferred by H-DMA (Channel 3)
!DMA_DMAUNKNOWN30	= $433B	;RW ???? ????  Unknown (Channel 3)
!DMA_DMAUNKNOWN31	= $433F	;RW ???? ????  Unknown (Channel 3)
!DMA_DMAP4		= $4340	;RW DT-I FDDD  Parameter for DMA transfer (Channel 4)
!DMA_BBAD4		= $4341	;RW AAAA AAAA  B-bus address for DMA (Channel 4)
!DMA_A1T4L		= $4342	;RW AAAA AAAA  Table address of A-bus for DMA (Low) (Channel 4)
!DMA_A1T4H		= $4343	;RW AAAA AAAA  Table address of A-bus for DMA (High) (Channel 4)
!DMA_A1B4		= $4344	;RW BBBB BBBB  Table address of A-bus for DMA (Bank) (Channel 4)
!DMA_DAS4L		= $4345	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (Low) (Channel 4)
!DMA_DAS4H		= $4346	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (High) (Channel 4)
!DMA_DASB4		= $4347	;RW BBBB BBBB  Data address store by H-DMA (Bank) (Channel 4)
!DMA_A2A4L		= $4348	;RW AAAA AAAA  Table address of A-bus by DMA (Low) (Channel 4)
!DMA_A2A4H		= $4349	;RW AAAA AAAA  Table address of A-bus by DMA (High) (Channel 4)
!DMA_NTLR4		= $434A	;RW CLLL LLLL  The number of lines to be transferred by H-DMA (Channel 4)
!DMA_DMAUNKNOWN40	= $434B	;RW ???? ????  Unknown (Channel 4)
!DMA_DMAUNKNOWN41	= $434F	;RW ???? ????  Unknown (Channel 4)
!DMA_DMAP5		= $4350	;RW DT-I FDDD  Parameter for DMA transfer (Channel 5)
!DMA_BBAD5		= $4351	;RW AAAA AAAA  B-bus address for DMA (Channel 5)
!DMA_A1T5L		= $4352	;RW AAAA AAAA  Table address of A-bus for DMA (Low) (Channel 5)
!DMA_A1T5H		= $4353	;RW AAAA AAAA  Table address of A-bus for DMA (High) (Channel 5)
!DMA_A1B5		= $4354	;RW BBBB BBBB  Table address of A-bus for DMA (Bank) (Channel 5)
!DMA_DAS5L		= $4355	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (Low) (Channel 5)
!DMA_DAS5H		= $4356	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (High) (Channel 5)
!DMA_DASB5		= $4357	;RW BBBB BBBB  Data address store by H-DMA (Bank) (Channel 5)
!DMA_A2A5L		= $4358	;RW AAAA AAAA  Table address of A-bus by DMA (Low) (Channel 5)
!DMA_A2A5H		= $4359	;RW AAAA AAAA  Table address of A-bus by DMA (High) (Channel 5)
!DMA_NTLR5		= $435A	;RW CLLL LLLL  The number of lines to be transferred by H-DMA (Channel 5)
!DMA_DMAUNKNOWN50	= $435B	;RW ???? ????  Unknown (Channel 5)
!DMA_DMAUNKNOWN51	= $435F	;RW ???? ????  Unknown (Channel 5)
!DMA_DMAP6		= $4360	;RW DT-I FDDD  Parameter for DMA transfer (Channel 6)
!DMA_BBAD6		= $4361	;RW AAAA AAAA  B-bus address for DMA (Channel 6)
!DMA_A1T6L		= $4362	;RW AAAA AAAA  Table address of A-bus for DMA (Low) (Channel 6)
!DMA_A1T6H		= $4363	;RW AAAA AAAA  Table address of A-bus for DMA (High) (Channel 6)
!DMA_A1B6		= $4364	;RW BBBB BBBB  Table address of A-bus for DMA (Bank) (Channel 6)
!DMA_DAS6L		= $4365	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (Low) (Channel 6)
!DMA_DAS6H		= $4366	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (High) (Channel 6)
!DMA_DASB6		= $4367	;RW BBBB BBBB  Data address store by H-DMA (Bank) (Channel 6)
!DMA_A2A6L		= $4368	;RW AAAA AAAA  Table address of A-bus by DMA (Low) (Channel 6)
!DMA_A2A6H		= $4369	;RW AAAA AAAA  Table address of A-bus by DMA (High) (Channel 6)
!DMA_NTLR6		= $436A	;RW CLLL LLLL  The number of lines to be transferred by H-DMA (Channel 6)
!DMA_DMAUNKNOWN60	= $436B	;RW ???? ????  Unknown (Channel 6)
!DMA_DMAUNKNOWN61	= $436F	;RW ???? ????  Unknown (Channel 6)
!DMA_DMAP7		= $4370	;RW DT-I FDDD  Parameter for DMA transfer (Channel 7)
!DMA_BBAD7		= $4371	;RW AAAA AAAA  B-bus address for DMA (Channel 7)
!DMA_A1T7L		= $4372	;RW AAAA AAAA  Table address of A-bus for DMA (Low) (Channel 7)
!DMA_A1T7H		= $4373	;RW AAAA AAAA  Table address of A-bus for DMA (High) (Channel 7)
!DMA_A1B7		= $4374	;RW BBBB BBBB  Table address of A-bus for DMA (Bank) (Channel 7)
!DMA_DAS7L		= $4375	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (Low) (Channel 7)
!DMA_DAS7H		= $4376	;RW AAAA AAAA  Data address store by H-DMA & Number of byte to be transferred settings by general purpose DMA (High) (Channel 7)
!DMA_DASB7		= $4377	;RW BBBB BBBB  Data address store by H-DMA (Bank) (Channel 7)
!DMA_A2A7L		= $4378	;RW AAAA AAAA  Table address of A-bus by DMA (Low) (Channel 7)
!DMA_A2A7H		= $4379	;RW AAAA AAAA  Table address of A-bus by DMA (High) (Channel 7)
!DMA_NTLR7		= $437A	;RW CLLL LLLL  The number of lines to be transferred by H-DMA (Channel 7)
!DMA_DMAUNKNOWN70	= $437B	;RW ???? ????  Unknown (Channel 7)
!DMA_DMAUNKNOWN71	= $437F	;RW ???? ????  Unknown (Channel 7)


