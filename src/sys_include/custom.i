                        IFND    HARDWARE_CUSTOM_I
HARDWARE_CUSTOM_I       SET     1

;**
;** $VER: custom.i 39.1 (18.9.92)
;** Includes Release 40.13
;**
;** Offsets of Amiga custom chip registers
;**
;** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
;**     All Rights Reserved
;**

CUSTOM                  EQU   $DFF000

BLTDDAT                 EQU   $000
DMACONR                 EQU   $002
VPOSR                   EQU   $004
VHPOSR                  EQU   $006
DSKDATR                 EQU   $008
JOY0DAT                 EQU   $00A
JOY1DAT                 EQU   $00C
CLXDAT                  EQU   $00E

ADKCONR                 EQU   $010
POT0DAT                 EQU   $012
POT1DAT                 EQU   $014
POTINP                  EQU   $016
SERDATR                 EQU   $018
DSKBYTR                 EQU   $01A
INTENAR                 EQU   $01C
INTREQR                 EQU   $01E

DSKPTH                  EQU   $020
DSKPTL                  EQU   $022
DSKLEN                  EQU   $024
DSKDAT                  EQU   $026
REFPTR                  EQU   $028
VPOSW                   EQU   $02A
VHPOSW                  EQU   $02C
COPCON                  EQU   $02E
SERDAT                  EQU   $030
SERPER                  EQU   $032
POTGO                   EQU   $034
JOYTEST                 EQU   $036
STREQU                  EQU   $038
STRVBL                  EQU   $03A
STRHOR                  EQU   $03C
STRLONG                 EQU   $03E

BLTCON0                 EQU   $040
BLTCON1                 EQU   $042
BLTAFWM                 EQU   $044
BLTALWM                 EQU   $046
BLTCPTH                 EQU   $048
BLTCPTL                 EQU   $04A
BLTBPTH                 EQU   $04C
BLTBPTL                 EQU   $04E
BLTAPTH                 EQU   $050
BLTAPTL                 EQU   $052
BLTDPTH                 EQU   $054
BLTDPTL                 EQU   $056
BLTSIZE                 EQU   $058
BLTCON0L                EQU   $05B      ; NOTE: BYTE ACCESS ONLY
BLTSIZV                 EQU   $05C
BLTSIZH                 EQU   $05E

BLTCMOD                 EQU   $060
BLTBMOD                 EQU   $062
BLTAMOD                 EQU   $064
BLTDMOD                 EQU   $066

BLTCDAT                 EQU   $070
BLTBDAT                 EQU   $072
BLTADAT                 EQU   $074

DENISEID                EQU   $07C
DSKSYNC                 EQU   $07E

COP1LCH                 EQU   $080
COP1LCL                 EQU   $082
COP2LCH                 EQU   $084
COP2LCL                 EQU   $086
COPJMP1                 EQU   $088
COPJMP2                 EQU   $08A
COPINS                  EQU   $08C
DIWSTRT                 EQU   $08E
DIWSTOP                 EQU   $090
DDFSTRT                 EQU   $092
DDFSTOP                 EQU   $094
DMACON                  EQU   $096
CLXCON                  EQU   $098
INTENA                  EQU   $09A
INTREQ                  EQU   $09C
ADKCON                  EQU   $09E

AUD0LCH                 EQU   $0A0
AUD0LCL                 EQU   $0A2
AUD0LEN                 EQU   $0A4
AUD0PER                 EQU   $0A6
AUD0VOL                 EQU   $0A8
AUD0DAT                 EQU   $0AA

AUD1LCH                 EQU   $0B0
AUD1LCL                 EQU   $0B2
AUD1LEN                 EQU   $0B4
AUD1PER                 EQU   $0B6
AUD1VOL                 EQU   $0B8
AUD1DAT                 EQU   $0BA

AUD2LCH                 EQU   $0C0
AUD2LCL                 EQU   $0C2
AUD2LEN                 EQU   $0C4
AUD2PER                 EQU   $0C6
AUD2VOL                 EQU   $0C8
AUD2DAT                 EQU   $0CA

AUD3LCH                 EQU   $0D0
AUD3LCL                 EQU   $0D2
AUD3LEN                 EQU   $0D4
AUD3PER                 EQU   $0D6
AUD3VOL                 EQU   $0D8
AUD3DAT                 EQU   $0DA

BPL1PTH                 EQU   $0E0
BPL1PTL                 EQU   $0E2
BPL2PTH                 EQU   $0E4
BPL2PTL                 EQU   $0E6
BPL3PTH                 EQU   $0E8
BPL3PTL                 EQU   $0EA
BPL4PTH                 EQU   $0EC
BPL4PTL                 EQU   $0EE
BPL5PTH                 EQU   $0F0
BPL5PTL                 EQU   $0F2
BPL6PTH                 EQU   $0F4
BPL6PTL                 EQU   $0F6
BPL7PTH                 EQU   $0F8
BPL7PTL                 EQU   $0FA
BPL8PTH                 EQU   $0FC
BPL8PTL                 EQU   $0FE

BPLCON0                 EQU   $100
BPLCON1                 EQU   $102
BPLCON2                 EQU   $104
BPLCON3                 EQU   $106
BPL1MOD                 EQU   $108
BPL2MOD                 EQU   $10A
BPLCON4                 EQU   $10C
CLXCON2                 EQU   $10E

BPL1DAT                 EQU   $110
BPL2DAT                 EQU   $112
BPL3DAT                 EQU   $114
BPL4DAT                 EQU   $116
BPL5DAT                 EQU   $118
BPL6DAT                 EQU   $11A
BPL7DAT                 EQU   $11C
BPL8DAT                 EQU   $11E

SPR0PTH                 EQU   $120
SPR0PTL                 EQU   $122
SPR1PTH                 EQU   $124
SPR1PTL                 EQU   $126
SPR2PTH                 EQU   $128
SPR2PTL                 EQU   $12A
SPR3PTH                 EQU   $12C
SPR3PTL                 EQU   $12E
SPR4PTH                 EQU   $130
SPR4PTL                 EQU   $132
SPR5PTH                 EQU   $134
SPR5PTL                 EQU   $136
SPR6PTH                 EQU   $138
SPR6PTL                 EQU   $13A
SPR7PTH                 EQU   $13C
SPR7PTL                 EQU   $13E

SPR0POS                 EQU   $140
SPR0CTL                 EQU   $142
SPR0DATA                EQU   $144
SPR0DATB                EQU   $146
SPR1POS                 EQU   $148
SPR1CTL                 EQU   $14A
SPR1DATA                EQU   $14C
SPR1DATB                EQU   $14E
SPR2POS                 EQU   $150
SPR2CTL                 EQU   $152
SPR2DATA                EQU   $154
SPR2DATB                EQU   $156
SPR3POS                 EQU   $158
SPR3CTL                 EQU   $15A
SPR3DATA                EQU   $15C
SPR3DATB                EQU   $15E
SPR4POS                 EQU   $160
SPR4CTL                 EQU   $162
SPR4DATA                EQU   $164
SPR4DATB                EQU   $166
SPR5POS                 EQU   $168
SPR5CTL                 EQU   $16A
SPR5DATA                EQU   $16C
SPR5DATB                EQU   $16E
SPR6POS                 EQU   $170
SPR6CTL                 EQU   $172
SPR6DATA                EQU   $174
SPR6DATB                EQU   $176
SPR7POS                 EQU   $178
SPR7CTL                 EQU   $17A
SPR7DATA                EQU   $17C
SPR7DATB                EQU   $17E

COLOR00                 EQU   $180
COLOR01                 EQU   $182
COLOR02                 EQU   $184
COLOR03                 EQU   $186
COLOR04                 EQU   $188
COLOR05                 EQU   $18A
COLOR06                 EQU   $18C
COLOR07                 EQU   $18E
COLOR08                 EQU   $190
COLOR09                 EQU   $192
COLOR10                 EQU   $194
COLOR11                 EQU   $196
COLOR12                 EQU   $198
COLOR13                 EQU   $19A
COLOR14                 EQU   $19C
COLOR15                 EQU   $19E
COLOR16                 EQU   $1A0
COLOR17                 EQU   $1A2
COLOR18                 EQU   $1A4
COLOR19                 EQU   $1A6
COLOR20                 EQU   $1A8
COLOR21                 EQU   $1AA
COLOR22                 EQU   $1AC
COLOR23                 EQU   $1AE
COLOR24                 EQU   $1B0
COLOR25                 EQU   $1B2
COLOR26                 EQU   $1B4
COLOR27                 EQU   $1B6
COLOR28                 EQU   $1B8
COLOR29                 EQU   $1BA
COLOR30                 EQU   $1BC
COLOR31                 EQU   $1BE

HTOTAL                  EQU   $1C0
HSSTOP                  EQU   $1C2
HBSTRT                  EQU   $1C4
HBSTOP                  EQU   $1C6
VTOTAL                  EQU   $1C8
VSSTOP                  EQU   $1CA
VBSTRT                  EQU   $1CC
VBSTOP                  EQU   $1CE
SPRHSTRT                EQU   $1D0
SPRHSTOP                EQU   $1D2
BPLHSTRT                EQU   $1D4
BPLHSTOP                EQU   $1D6
HHPOSW                  EQU   $1D8
HHPOSR                  EQU   $1DA
BEAMCON0                EQU   $1DC
HSSTRT                  EQU   $1DE
VSSTRT                  EQU   $1E0
HCENTER                 EQU   $1E2
DIWHIGH                 EQU   $1E4
BPLHMOD                 EQU   $1E6
SPRHPTH                 EQU   $1E8
SPRHPTL                 EQU   $1EA
BPLHPTH                 EQU   $1EC
BPLHPTL                 EQU   $1EE
FMODE                   EQU   $1FC

                        ENDC
