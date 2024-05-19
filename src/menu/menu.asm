; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

                    include  "custom.i"
                    include  "cia.i"
                    include  "dmabits.i"
                    include  "intbits.i"

                    mc68000

; -----------------------------------------------------

WAIT_BLIT           MACRO
wait\@:             btst     #DMAB_BLITTER,CUSTOM+DMACONR
                    bne.b    wait\@
                    ENDM

; -----------------------------------------------------

                    section  menu,code_c

start:              move.l   d5,number_players
                    move.l   d7,share_credits
                    move.l   a1,reg_vbr
                    bsr      setup_context
                    bsr      lbC00112C
                    bsr      lbC00173C
                    clr.l    lbL000A08
                    lea      copper_palette_stars(pc),a0
                    lea      stars_palette(pc),a1
                    moveq    #8,d0
                    bsr      fade_in
                    bsr      lbC001B7A
                    bsr      wait_button_press
                    bsr      lbC00173C
                    move.w   #1,lbW00198A
                    clr.w    lbW001844
                    move.l   #134,d0
.pause:             move.l   d0,-(sp)
                    move.l   (sp)+,d0
                    subq.l   #1,d0
                    bne.b    .pause
                    bsr      lbC001284
                    move.l   share_credits(pc),d1
                    moveq    #0,d4
                    move.l   number_players(pc),d6
                    move.l   return_value(pc),d7
                    bra      restore_lev3irq

reg_vbr:            dc.l     0

wait_button_press:  btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    wait_button_press
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    wait_button_press
                    rts

return_value:       dc.l     0
number_players:     dc.l     0

lbL000A08:          dc.l     0
lbL000A0C:          dc.l     0

lbC000A10:          move.l   #1,lbL000A08
                    move.w   #1,flag_quit
                    bsr      lbC003F74
                    bsr      wait_sync2
                    lea      lbW0028D6(pc),a0
                    move.l   #$DF01FF00,(a0)+
                    move.l   #$1980000,(a0)+
                    move.l   #$EF01FF00,(a0)+
                    move.l   #$1980444,(a0)+
                    move.l   #$FFD7FFFE,(a0)+
                    tst.w    return_value
                    bne.b    lbC000A5C
                    bsr      lbC000ED6
lbC000A5C:          move.w   #1,lbW00195E
                    move.w   #2,lbW000C42
                    clr.w    d0
                    clr.l    lbL000A0C
lbC000A74:          addq.l   #1,lbL000A0C
                    cmp.l    #1000,lbL000A0C
                    bpl      lbC000BB2
                    move.w   CUSTOM+JOY1DAT,d1
                    and.w    #$303,d1
                    beq.b    lbC000A9C
                    clr.l    lbL000A0C
lbC000A9C:          move.w   lbW000C42(pc),d1
                    mulu     #13,d1
                    ext.l    d1
                    add.w    #167,d1
                    lsl.w    #8,d1
                    or.w     #1,d1
                    move.w   d1,lbW0028D6
                    add.w    #$C00,d1
                    move.w   d1,lbW0028DE
                    move.w   CUSTOM+JOY1DAT,d1
                    and.w    #$303,d1
                    cmp.w    d1,d0
                    beq.b    lbC000B04
                    move.w   #10,lbW000C44
                    move.w   d1,d0
                    cmp.w    #256,d0
                    bne.b    lbC000AEE
                    tst.w    lbW000C42
                    beq.b    lbC000AEE
                    subq.w   #1,lbW000C42
lbC000AEE:          cmp.w    #1,d0
                    bne.b    lbC000B04
                    cmp.w    #2,lbW000C42
                    beq.b    lbC000B04
                    addq.w   #1,lbW000C42
lbC000B04:          bsr      wait_sync2
                    addq.w   #1,lbW000C44
                    cmp.w    #20,lbW000C44
                    bne.b    lbC000B22
                    clr.w    lbW000C44
                    clr.w    d0
lbC000B22:          tst.l    return_value
                    bne      lbC000B44
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      lbC000B44
                    btst     #CIAB_GAMEPORT0,CIAA
                    bne      lbC000A74
lbC000B44:          cmp.w    #2,lbW000C42
                    beq      lbC000BA2
                    cmp.w    #1,lbW000C42
                    bne      lbC000B78
                    move.l   share_credits(pc),d0
                    not.l    d0
                    and.l    #1,d0
                    move.l   d0,share_credits
                    bsr      lbC000ED6
                    bra      lbC000A74

lbC000B78:          tst.w    lbW000C42
                    bne.b    lbC000B9E
                    move.l   number_players(pc),d0
                    bchg     #0,d0
                    bchg     #1,d0
                    move.l   d0,number_players
                    bsr      lbC000ED6
                    bra      lbC000A74

lbC000B9E:          bra      lbC000A74

lbC000BA2:          clr.w    lbW000C40
                    cmp.w    #2,lbW000C42
                    beq.b    lbC000BBA
lbC000BB2:          move.w   #1,lbW000C40
lbC000BBA:          clr.l    lbL000A08
                    clr.w    lbW00195E
                    lea      lbW002952(pc),a0
                    lea      lbL0042E4(pc),a1
                    lea      lbW0028B6(pc),a2
                    moveq    #8,d0
                    bsr      lbC001BA2
                    bsr      lbC001B8C
                    bsr      lbC00173C
                    lea      lbW0028D6(pc),a0
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    bsr      lbC003F74
lbC000C24:          btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    lbC000C24
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    lbC000C24
                    clr.w    lbW001844
                    rts

lbW000C40:          dc.w     0
lbW000C42:          dc.w     0
lbW000C44:          dc.w     0

lbC000ED6:          move.w   #1,flag_quit
                    WAIT_BLIT
                    move.l   #$1000000,CUSTOM+BLTCON0
                    clr.w    CUSTOM+BLTDMOD
                    lea      lbL01FF94,a0
                    move.l   a0,CUSTOM+BLTDPTH
                    move.w   #(438*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    lea      text_menu(pc),a0
                    cmp.l    #1,share_credits
                    bne.b    lbC000F22
                    add.l    #124,a0
lbC000F22:          cmp.l    #2,number_players
                    bne.b    lbC000F34
                    add.l    #62,a0
lbC000F34:          lea      lbL003DAE(pc),a1
                    cmp.l    #1,lbL000A08
                    beq.b    lbC000F4C
                    lea      lbL003DD6(pc),a1
lbC000F4C:          bsr      display_text
                    cmp.l    #1,lbL000A08
                    beq      lbC001006
                    bsr      wait_sync2
                    lea      lbL0052E4(pc),a1
                    move.l   #(94*40),d0
                    add.l    d0,a1
                    lea      lbL01FF94,a0
                    WAIT_BLIT
                    move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    move.l   #$9f00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(146*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(146*40),a0
                    add.l    #(240*40),a1
                    move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(146*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(146*40),a0
                    add.l    #(240*40),a1
                    move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(146*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
lbC001006:          clr.l    lbL000A08
lbC00100C:          btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    lbC00100C
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    lbC00100C
                    move.l   #2,lbL000A08
                    rts

text_menu:          dc.w     16,112
                    dc.b     ' ONE PLAYER GAME  ',0
                    dc.b     'SHARE CREDITS  OFF',0
                    dc.b     '    START GAME    '
                    dc.b     -1,-1
                    dc.w     16,112
                    dc.b     ' TWO PLAYER GAME  ',0
                    dc.b     'SHARE CREDITS  OFF',0
                    dc.b     '    START GAME    '
                    dc.b     -1,-1
                    dc.w     16,112
                    dc.b     ' ONE PLAYER GAME  ',0
                    dc.b     'SHARE CREDITS  ON ',0
                    dc.b     '    START GAME    '
                    dc.b     -1,-1
                    dc.w     16,112
                    dc.b     ' TWO PLAYER GAME  ',0
                    dc.b     'SHARE CREDITS  ON ',0
                    dc.b     '    START GAME    '
                    dc.b     -1,-1
                    even

lbC001124:          clr.b    (a0)+
                    subq.l   #1,d0
                    bne.b    lbC001124
                    rts

lbC00112C:          lea      lbL0042E4(pc),a0
                    lea      lbW0028B6(pc),a1
                    move.l   #8,d0
                    bsr      set_palette
                    move.l   #$2C01FF00,lbW002912
                    lea      copyright_bps(pc),a0
                    move.l   #copyright_pic,d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(16*40),d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(16*40),d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    lea      copyright_palette,a0
                    lea      lbW00292E(pc),a1
                    move.l   #8,d0
                    bsr      set_palette
                    lea      empty_bps(pc),a0
                    move.l   #empty_pic,d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    lea      lbL0042E4(pc),a0
                    lea      copper_palette_title(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    lea      lbL0042E4(pc),a0
                    lea      lbW0028B6(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    move.w   #1,lbW002570
                    clr.w    lbW00198A
                    move.w   #-40,copper_modulo
                    lea      lbL0042E4(pc),a0
                    lea      copper_palette_stars(pc),a1
                    move.l   #8,d0
                    bsr      set_palette
                    lea      lbW0028D6(pc),a0
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #copperlist_main,CUSTOM+COP1LCH
                    clr.w    copper_modulo
                    lea      copper_palette_title(pc),a0
                    lea      palette_logo(pc),a1
                    moveq    #8,d0
                    bsr      fade_in
                    bra      lbC001B7A

lbC001284:          clr.w    lbW001844
                    bsr      lbC000A10
                    tst.w    lbW000C40
                    beq      lbC0012AC
                    bsr      lbC003E2A
                    tst.w    lbW001844
                    bne      lbC001284
                    clr.w    lbW001844
lbC0012AC:          move.w   #1,lbW002088
                    clr.w    lbW00198A
                    move.w   #1,lbW002570
                    lea      copper_palette_title(pc),a0
                    lea      lbL0042E4(pc),a1
                    moveq    #8,d0
                    bsr      fade_out
                    bsr      lbC001B7A
                    lea      lbW00292E(pc),a0
                    lea      lbL0042E4(pc),a1
                    moveq    #8,d0
                    bsr      fade_out
                    bsr      lbC001B7A
                    lea      lbW0028B6(pc),a0
                    lea      lbL0042E4(pc),a1
                    moveq    #8,d0
                    bsr      fade_out
                    bsr      lbC001B7A
                    lea      copper_palette_stars(pc),a0
                    lea      lbL0042E4,a1
                    moveq    #8,d0
                    bsr      fade_out
                    bra      lbC001B7A

stars_palette:      dc.w     $000,$111,$222,$333,$555,$888,$AAA,0

setup_context:      bsr      setup_stars
                    bsr      install_lev3irq
                    bsr      display_title
                    lea      menu_bps(pc),a0
                    move.l   #lbL0060F4,d0
                    bsr      set_menu_bps
                    move.l   #copperlist_blank,CUSTOM+COP1LCH
                    lea      lbW002396(pc),a0
                    bsr      lbC00227A
                    lea      lbW002396(pc),a0
                    bra      set_random_seed

display_title:      move.l   #title_pic,d0
                    not.w    flag_swap_title
                    beq.b    .becond_title
                    add.l    #(89*40),d0
.becond_title:      lea      title_bps(pc),a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #(180*40),d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #(180*40),d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    rts

flag_swap_title:    dc.w     0

set_menu_bps:       moveq    #3,d1
.loop:              move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(240*40),d0
                    addq.l   #8,a0
                    subq.l   #1,d1
                    bne.b    .loop
                    rts

lbL001466:          dc.l     lbW00146A
lbW00146A:          dcb.w    24,$10
                    dcb.w    18,$20
                    dcb.w    14,$30
                    dcb.w    12,$40
                    dcb.w    11,$50
                    dcb.w    10,$60
                    dcb.w    9,$70
                    dcb.w    8,$80
                    dcb.w    9,$90
                    dcb.w    10,$A0
                    dcb.w    11,$B0
                    dcb.w    12,$C0
                    dcb.w    14,$D0
                    dcb.w    18,$E0
                    dcb.w    24,$F0
                    dcb.w    18,$E0
                    dcb.w    14,$D0
                    dcb.w    12,$C0
                    dcb.w    11,$B0
                    dcb.w    10,$A0
                    dcb.w    9,$90
                    dcb.w    8,$80
                    dcb.w    9,$70
                    dcb.w    10,$60
                    dcb.w    11,$50
                    dcb.w    12,$40
                    dcb.w    14,$30
                    dcb.w    18,$20
                    dc.w     $FFFF

lbC00173C:          rts

install_lev3irq:    move.l   reg_vbr(pc),a0
                    move.l   $6C(a0),old_lev3irq
                    move.l   #lev3irq,$6C(a0)
                    rts

restore_lev3irq:    move.l   reg_vbr(pc),a0
                    move.l   old_lev3irq,$6C(a0)
                    rts

lbW001844:          dc.w     0

lev3irq:            movem.l  d0-d7/a0-a6,-(sp)
                    btst     #5,CUSTOM+INTREQR+1
                    beq      lbC0018D0
                    bsr      lbC001DB6
                    bsr      lbC001F94
                    bsr      lbC001C54
                    bsr      lbC001916
                    bsr      display_title
                    lea      lbW002396(pc),a0
                    bsr      lbC0022B0
                    move.w   #321,lbW002396
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    lbC001894
                    btst     #CIAB_GAMEPORT1,CIAA
                    bne.b    lbC00189C
lbC001894:          move.w   #1,lbW001844
lbC00189C:          tst.w    lbW00198A
                    beq      lbC0018BC
                    cmp.l    #$1D01FF00,lbW002912
                    bmi.b    lbC0018BC
                    sub.l    #$1000000,lbW002912
lbC0018BC:          bsr      display_stars
                    bsr      lbC00198C
                    move.l   #200,d0
lbC0018CC:          subq.l   #1,d0
                    bne.b    lbC0018CC
lbC0018D0:          movem.l  (sp)+,d0-d7/a0-a6
                    move.l   old_lev3irq(pc),-(sp)
                    rts

old_lev3irq:        dc.l    0 

lbC0018F6:          move.w   lbW0028C8(pc),lbW0028DC
                    move.w   lbW0028C8(pc),lbW0028E4
                    move.l   #lbW001966,lbL001960
                    rts

lbC001916:          tst.w    lbW00195E
                    beq      lbC0018F6
                    addq.w   #1,lbW001964
                    cmp.w    #3,lbW001964
                    bmi.b    lbC001988
                    clr.w    lbW001964
                    move.l   lbL001960(pc),a0
                    tst.w    (a0)
                    bpl.b    lbC001950
                    lea      lbW001966(pc),a0
                    move.l   a0,lbL001960
lbC001950:          addq.l   #2,lbL001960
                    move.w   (a0),lbW0028DC
                    rts

lbW00195E:          dc.w     0
lbL001960:          dc.l     lbW001966
lbW001964:          dc.w     0
lbW001966:          dc.w     $444,$555,$666,$777,$888,$999,$AAA,$AAA,$999,$888
                    dc.w     $777,$666,$555,$444,$333,$333,$FFFF

lbC001988:          rts

lbW00198A:          dc.w     0

lbC00198C:          tst.w    lbW00198A
                    beq      lbC001988
                    tst.w    lbW002570
                    beq      lbC001988
                    move.w   #4,lbW00256C
                    move.l   lbL0019DA(pc),a0
                    tst.l    (a0)
                    bne.b    lbC0019BE
                    lea      lbL0019E2(pc),a0
                    move.l   a0,lbL0019DA
lbC0019BE:          addq.l   #4,lbL0019DA
                    move.l   (a0),a1
                    move.l   -4(a0),a0
                    lea      copper_palette_title(pc),a2
                    moveq    #8,d0
                    bra      lbC0023DE

lbL0019DA:          dc.l     lbL0019E6
                    dc.l     palette_logo
lbL0019E2:          dc.l     palette_logo
lbL0019E6:          dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l     palette_logo
                    dc.l    0
palette_logo:       dc.w    $000,$111,$100,$200,$400,$800,$D00,$F30

lbC001B7A:          bsr      wait_sync2
                    tst.w    flag_quit
                    beq.b    lbC001B7A
                    rts

lbC001B8C:          tst.w    flag_quit
                    beq.b    lbC001B7A
                    rts

lbC001B96:          clr.w    2(a0)
                    addq.l   #4,a0
                    subq.w   #1,d0
                    bne.b    lbC001B96
                    rts

lbC001BA2:          movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #1,lbW002086
                    move.w   d0,lbW00208E
                    move.l   a1,lbL002090
                    move.l   a2,lbL002094
                    move.l   a0,a2
                    lea      lbL002098(pc),a3
                    move.w   lbW00208E(pc),d0
lbC001BCE:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bmi.b    lbC001BE4
                    bhi.b    lbC001BEA
                    clr.b    (a3)+
                    bra.b    lbC001BEE

lbC001BE4:          move.b   #-1,(a3)+
                    bra.b    lbC001BEE

lbC001BEA:          move.b   #1,(a3)+
lbC001BEE:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bmi.b    lbC001C04
                    bhi.b    lbC001C0A
                    clr.b    (a3)+
                    bra.b    lbC001C0E

lbC001C04:          move.b   #-1,(a3)+
                    bra.b    lbC001C0E

lbC001C0A:          move.b   #1,(a3)+
lbC001C0E:          move.w   (a2)+,d1
                    move.w   (a1)+,d2
                    and.w    #$F,d1
                    and.w    #$F,d2
                    cmp.w    d1,d2
                    bmi.b    lbC001C24
                    bhi.b    lbC001C2A
                    clr.b    (a3)+
                    bra.b    lbC001C2E

lbC001C24:          move.b   #-1,(a3)+
                    bra.b    lbC001C2E

lbC001C2A:          move.b   #1,(a3)+
lbC001C2E:          subq.b   #1,d0
                    bne.b    lbC001BCE
                    move.l   lbL002094,a2
                    move.w   lbW00208E,d0
                    addq.l   #2,a2
lbC001C40:          move.w   (a0)+,(a2)
                    addq.l   #4,a2
                    subq.b   #1,d0
                    bne.b    lbC001C40
                    clr.w    flag_quit
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC001C54:          cmp.w    #1,lbW002086
                    bne      lbC0020F8
                    tst.w    flag_quit
                    bne      lbC0020F8
                    moveq    #0,d7
                    add.w    #1,lbW00208A
                    move.w   lbW00208A(pc),d0
                    cmp.w    lbW002088(pc),d0
                    bmi      lbC0020F8
                    clr.w    lbW00208A
                    move.w   lbW00208E(pc),d0
                    move.l   lbL002094(pc),a0
                    move.l   lbL002090(pc),a1
                    lea      lbL002098(pc),a3
                    addq.l   #2,a0
lbC001CA4:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bne.b    lbC001CBA
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    lbC001CC8

lbC001CBA:          move.b   (a3)+,d3
                    lsr.w    #8,d1
                    add.b    d3,d1
                    lsl.w    #8,d1
                    and.w    #$FF,(a0)
                    or.w     d1,(a0)
lbC001CC8:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bne.b    lbC001CDE
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    lbC001CEC

lbC001CDE:          move.b   (a3)+,d3
                    lsr.w    #4,d1
                    add.b    d3,d1
                    lsl.w    #4,d1
                    and.w    #$F0F,(a0)
                    or.w     d1,(a0)
lbC001CEC:          move.w   (a0),d1
                    move.w   (a1)+,d2
                    and.w    #15,d1
                    and.w    #15,d2
                    cmp.w    d1,d2
                    bne.b    lbC001D02
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    lbC001D0C

lbC001D02:          move.b   (a3)+,d3
                    add.b    d3,d1
                    and.w    #$FF0,(a0)
                    or.w     d1,(a0)
lbC001D0C:          addq.l   #4,a0
                    subq.b   #1,d0
                    bne.b    lbC001CA4
                    divu     #3,d7
                    cmp.w    lbW00208E(pc),d7
                    bne.b    lbC001D2C
                    move.w   #1,flag_quit
                    clr.w    lbW002086
lbC001D2C:          rts

set_palette:        addq.l   #2,a1
lbC001D30:          move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #1,d0
                    bne.b    lbC001D30
                    rts

fade_in:            move.w   #2,lbW002086
                    lea      lbL0021BA(pc),a4
                    moveq    #48,d2
lbC001D4E:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC001D4E
                    move.l   d0,d7
                    move.l   a1,a2
                    moveq    #0,d6
                    lea      lbL0020FA(pc),a3
.loop:              move.w   (a2),d6
                    and.w    #$F00,d6
                    divu     #$F,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    move.w   (a2),d6
                    lsl.w    #4,d6
                    and.w    #$F00,d6
                    divu     #$F,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    move.w   (a2)+,d6
                    lsl.w    #8,d6
                    and.w    #$F00,d6
                    divu     #$F,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    subq.w   #1,d7
                    bne.b    .loop
                    move.l   d1,d4
                    subq.l   #2,a0
                    subq.l   #2,a1
                    move.w   d0,lbW00208E
                    move.l   a0,lbL002094
                    move.l   a1,lbL002090
                    clr.w    flag_quit
                    rts

lbC001DB6:          cmp.w    #2,lbW002086
                    bne      lbC0020F8
                    tst.w    flag_quit
                    bne      lbC0020F8
                    addq.w   #1,lbW00208A
                    move.w   lbW00208A(pc),d0
                    cmp.w    lbW002088(pc),d0
                    bmi      lbC0020F8
                    clr.w    lbW00208A
                    move.l   lbL002094(pc),a0
                    move.l   lbL002090(pc),a1
                    moveq    #0,d0
                    move.w   lbW00208E(pc),d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      lbL0020FA(pc),a2
                    lea      lbL0021BA(pc),a3
                    move.l   d6,d7
                    move.l   d0,d1
lbC001E14:          addq.l   #4,a0
                    addq.l   #2,a1
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F00,d2
                    and.w    #$F00,d3
                    cmp.w    d2,d3
                    beq.b    lbC001E3C
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC001E3C:          addq.l   #2,a2
                    addq.l   #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq.b    lbC001E6E
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC001E6E:          addq.l   #2,a2
                    addq.l   #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F,d2
                    and.w    #$F,d3
                    cmp.w    d2,d3
                    beq.b    lbC001EA0
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC001EA0:          addq.l   #2,a2
                    addq.l   #2,a3
                    subq.w   #1,d1
                    bne.b    lbC001E14
                    cmp.l    d6,d7
                    bne.b    lbC001EC6
                    move.w   #1,flag_quit
                    clr.w    lbW002086
lbC001EC6:          rts

fade_out:           move.w   #3,lbW002086
                    lea      lbL0021BA(pc),a4
                    moveq    #48,d2
lbC001EDC:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne.b    lbC001EDC
                    move.l   d0,d7
                    move.l   a0,a2
                    addq.l   #2,a2
                    moveq    #0,d6
                    lea      lbL0020FA(pc),a3
lbC001EF6:          move.w   (a2),d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    move.w   (a2),d6
                    lsl.w    #4,d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    move.w   (a2),d6
                    add.l    #4,a2
                    lsl.w    #8,d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    subq.w   #1,d7
                    bne.b    lbC001EF6
                    lea      lbL0021BA(pc),a3
                    move.l   a0,a2
                    addq.l   #2,a2
                    move.l   d0,d4
lbC001F40:          move.w   (a2),d7
                    and.w    #$F00,d7
                    move.w   d7,(a3)+
                    move.w   (a2),d7
                    and.w    #$F0,d7
                    lsl.w    #4,d7
                    move.w   d7,(a3)+
                    move.w   (a2),d7
                    and.w    #$F,d7
                    lsl.w    #8,d7
                    move.w   d7,(a3)+
                    addq.l   #4,a2
                    subq.l   #1,d4
                    bne.b    lbC001F40
                    lea      lbL0020FA(pc),a2
                    lea      lbL0021BA(pc),a3
                    move.l   d1,d4
                    subq.l   #2,a0
                    move.w   d0,lbW00208E
                    move.l   a0,lbL002094
                    clr.w    flag_quit
                    rts

lbC001F94:          cmp.w    #3,lbW002086
                    bne      lbC0020F8
                    tst.w    flag_quit
                    bne      lbC0020F8
                    addq.w   #1,lbW00208A
                    move.w   lbW00208A(pc),d0
                    cmp.w    lbW002088(pc),d0
                    bmi      lbC0020F8
                    clr.w    lbW00208A
                    moveq    #0,d0
                    move.w   lbW00208E(pc),d0
                    move.l   lbL002094(pc),a0
                    move.l   d0,d1
                    moveq    #0,d7
                    lea      lbL0020FA(pc),a2
                    lea      lbL0021BA(pc),a3
lbC001FE6:          addq.l   #4,a0
                    move.w   (a0),d2
                    and.w    #$F00,d2
                    beq.b    lbC002006
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC002006:          addq.l   #2,a2
                    addq.l   #2,a3
                    move.w   (a0),d2
                    and.w    #$F0,d2
                    beq.b    lbC002032
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC002032:          addq.l   #2,a2
                    addq.l   #2,a3
                    move.w   (a0),d2
                    and.w    #$F,d2
                    beq.b    lbC00205E
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.l    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC00205E:          addq.l   #2,a2
                    addq.l   #2,a3
                    subq.w   #1,d1
                    bne.b    lbC001FE6
                    tst.l    d7
                    bne.b    lbC002084
                    move.w   #1,flag_quit
                    clr.w    lbW002086
lbC002084:          rts

lbW002086:          dc.w     0
lbW002088:          dc.w     3
lbW00208A:          dc.w     0
flag_quit:          dc.w     0
lbW00208E:          dc.w     0
lbL002090:          dc.l     0
lbL002094:          dc.l     0
lbL002098:          dcb.l    24,0

lbC0020F8:          rts

lbL0020FA:          dcb.l    48,0
lbL0021BA:          dcb.l    48,0

lbC00227A:          tst.l    $10(a0)
                    bne.b    lbC00229C
                    move.l   12(a0),d0
lbC002284:          move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

lbC00229C:          move.l   16(a0),a1
                    move.l   a1,20(a0)
                    move.w   6(a1),24(a0)
                    move.l   (a1),d0
                    bra.b    lbC002284

lbC0022B0:          move.l   8(a0),a1
                    tst.l    $10(a0)
                    bne      lbC002348
lbC0022BC:          and.w    #$80,14(a1)
                    move.w   0(a0),d0
                    add.w    #$80,d0
                    btst     #0,d0
                    beq.b    lbC0022D6
                    or.w     #1,14(a1)
lbC0022D6:          lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    add.w    #$2C,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #$100,d1
                    bmi.b    lbC0022FA
                    sub.w    #$FF,d1
                    or.b     #2,15(a1)
lbC0022FA:          move.b   d1,14(a1)
                    cmp.w    #$100,d0
                    bmi.b    lbC00230E
                    sub.w    #$FF,d0
                    or.b     #4,15(a1)
lbC00230E:          move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.b    lbC002346
                    move.w   10(a1),26(a1)
                    move.w   14(a1),30(a1)
                    move.w   2(a1),d0
                    swap     d0
                    move.w   6(a1),d0
                    move.w   4(a0),d1
                    ext.l    d1
                    add.l    d1,d1
                    add.l    d1,d1
                    addq.l   #4,d1
                    add.l    d1,d0
                    move.w   d0,22(a1)
                    swap     d0
                    move.w   d0,18(a1)
lbC002346:          rts

lbC002348:          subq.w   #1,24(a0)
                    bpl      lbC0022BC
                    addq.l   #8,20(a0)
lbC002354:          move.l   20(a0),a2
                    move.l   (a2),d0
                    bmi.b    lbC002372
                    move.w   6(a2),24(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      lbC0022BC

lbC002372:          move.l   16(a0),20(a0)
                    bra.b    lbC002354

lbW002396:          dcb.w    2,$FFE0
                    dc.w     11,0
                    dc.l     sprites_bps
                    dc.l     lbL0023B2
                    dcb.w    6,0
lbL0023B2:          dcb.l    11,$FFF00000

lbC0023DE:          movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #1,lbW00256A
                    move.w   d0,lbW002572
                    move.l   a1,lbL002574
                    move.l   a2,lbL002578
                    move.l   a0,a2
                    lea      lbL00257C(pc),a3
                    move.w   lbW002572(pc),d0
lbC00240A:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bmi.b    lbC002420
                    bhi.b    lbC002426
                    clr.b    (a3)+
                    bra.b    lbC00242A

lbC002420:          move.b   #-1,(a3)+
                    bra.b    lbC00242A

lbC002426:          move.b   #1,(a3)+
lbC00242A:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bmi.b    lbC002440
                    bhi.b    lbC002446
                    clr.b    (a3)+
                    bra.b    lbC00244A

lbC002440:          move.b   #-1,(a3)+
                    bra.b    lbC00244A

lbC002446:          move.b   #1,(a3)+
lbC00244A:          move.w   (a2)+,d1
                    move.w   (a1)+,d2
                    and.w    #$F,d1
                    and.w    #$F,d2
                    cmp.w    d1,d2
                    bmi.b    lbC002460
                    bhi.b    lbC002466
                    clr.b    (a3)+
                    bra.b    lbC00246A

lbC002460:          move.b   #-1,(a3)+
                    bra.b    lbC00246A

lbC002466:          move.b   #1,(a3)+
lbC00246A:          subq.b   #1,d0
                    bne.b    lbC00240A
                    move.l   lbL002578(pc),a2
                    move.w   lbW002572(pc),d0
                    addq.l   #2,a2
lbC00247C:          move.w   (a0)+,(a2)
                    addq.l   #4,a2
                    subq.b   #1,d0
                    bne.b    lbC00247C
                    clr.w    lbW002570
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbW00256A:          dc.w     0
lbW00256C:          dc.w     12
lbW00256E:          dc.w     0
lbW002570:          dc.w     0
lbW002572:          dc.w     0
lbL002574:          dc.l     0
lbL002578:          dc.l     0
lbL00257C:          dcb.l    24,0

lbW002952:          dc.w     $000,$222,$D31,$B11,$444,$333,$222,$F52

lbW002962:          dc.w     $000,$822,$A31,$811,$F44,$833,$A22,$852
                    dc.w     $000,$111,$222,$333,$444,$500,$700,$900

; -----------------------------------------------------

copperlist_blank:   dc.w     BPLCON0,$200
                    dc.w     COLOR00,0
                    dc.w     DMACON,DMAF_SPRITE
                    dc.w     $FFFF,$FFFE

copperlist_main:    dc.w     COLOR00,0
                    dc.w     BPLCON0,$6600
                    dc.w     DIWSTRT,$2C81,DIWSTOP,$2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,8,BPL2MOD
copper_modulo:      dc.w     0
                    dc.w     BPLCON2,$64,BPLCON1,0
                    dc.w     $2001,$FF00
                    dc.w     DMACON,DMAF_SETCLR|DMAF_SPRITE
                    dc.w     COLOR17,$FFF
sprites_bps:        dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
copper_palette_stars:
                    dc.w     COLOR00,0,COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
stars_bps:          dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL5PTH,0,BPL5PTL,0
title_bps:          dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
copper_palette_title:
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     $8501,$FF00
menu_bps:           dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
                    dc.w     $8A01,$FF00
lbW0028B6:          dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12
lbW0028C8:          dc.w     0
                    dc.w     COLOR13,0,COLOR14,0,COLOR15,0
lbW0028D6:          dc.w     $8A01,$FF00
                    dc.w     COLOR00
lbW0028DC:          dc.w     $20
lbW0028DE:          dc.w     $9A01,$FF00
                    dc.w     COLOR00
lbW0028E4:          dc.w     0
                    dc.w     $FFD7,$FFFE
lbW0028EA:          dc.w     $FFD7,$FFFE
                    dc.w     BPLCON1
lbW0028F0:          dc.w     0
                    dc.w     $601,$FF00
                    dc.w     $1A01
lbW0028F8:          dc.w     $FF00
empty_bps:          dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
lbW002912:          dc.w     0,0
copyright_bps:      dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
lbW00292E:          dc.w     COLOR08,$000,COLOR09,$222,COLOR10,$444,COLOR11,$555,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

display_stars:      bsr      move_stars
                    bsr      set_stars_buffer
                    bsr.b    clear_stars
                    bra.b    do_stars

clear_stars:        move.l   stars_bitplanes_ptr(pc),a0
                    lea      256*48(a0),a1
                    lea      256*48(a1),a2
                    move.l   stars_screen_coords_ptr(pc),a3
                    move.w   stars_nbr(pc),d1
.clear:             move.l   (a3)+,d0
                    clr.b    0(a0,d0.l)
                    clr.b    0(a1,d0.l)
                    clr.b    0(a2,d0.l)
                    dbra     d1,.clear
                    rts

do_stars:           lea      stars_3d_coords,a0
                    lea      (a0),a1
                    lea      stars_pos_x(pc),a2
                    movem.w  (a2)+,d0-d3
                    lea      stars_centers(pc),a3
                    move.l   stars_bitplanes_ptr(pc),a2
                    move.l   stars_screen_coords_ptr(pc),a4
.plots:             movem.w  (a0)+,d4-d6
                    add.w    d0,d4
                    add.w    d1,d5
                    add.w    d2,d6
                    cmp.w    #384,d4
                    blt.b    .max_x
                    sub.w    #768,d4
.max_x:             cmp.w    #-384,d4
                    bgt.b    .min_x
                    add.w    #768,d4
.min_x:             cmp.w    #256,d5
                    blt.b    .max_y
                    sub.w    #512,d5
.max_y:             cmp.w    #-256,d5
                    bgt.b    .min_y
                    add.w    #512,d5
.min_y:             cmp.w    #1024,d6
                    ble.b    .max_z
                    sub.w    #960,d6
.max_z:             cmp.w    #64,d6
                    bgt.b    .min_z
                    add.w    #960,d6
.min_z:             move.w   d4,(a1)+
                    move.w   d5,(a1)+
                    move.w   d6,(a1)+
                    muls     stars_aspect_x(pc),d4
                    muls     stars_aspect_y(pc),d5
                    divs     d6,d4
                    divs     d6,d5
                    add.w    (a3),d4
                    add.w    2(a3),d5
                    bsr.b    plot_star
                    dbra     d3,.plots
no_plot:            rts

plot_star:          tst.w    d4
                    bmi.b    no_plot
                    tst.w    d5
                    bmi.b    no_plot
                    cmp.w    #384,d4
                    bge.b    no_plot
                    cmp.w    #256,d5
                    bge.b    no_plot
                    move.w   d5,d7
                    asl.w    #5,d5
                    asl.w    #4,d7
                    add.w    d7,d5                      ; * 40
                    move.w   d4,d7
                    asr.w    #3,d4                      ; / 8
                    add.w    d4,d5                      ; x + y
                    ext.l    d5
                    lea      (a2,d5.l),a5
                    and.b    #7,d7
                    moveq    #7,d4
                    sub.b    d7,d4
                    asr.w    #7,d6
                    btst     #0,d6
                    bne.b    .plane_1
                    bset     d4,(a5)
.plane_1:           btst     #1,d6
                    bne.b    .plane_2
                    bset     d4,(256*48)(a5)
.plane_2:           btst     #2,d6
                    bne.b    .plane_3
                    bset     d4,(256*2*48)(a5)
.plane_3:           move.l   d5,(a4)+                   ; save the coordinate
                    rts

set_stars_buffer:   lea      stars_swap_buffers(pc),a0
                    not.w    (a0)
                    beq.b    .buffer_2
                    lea      stars_bps_dat2(pc),a0
                    lea      stars_bps(pc),a1
                    moveq    #6-1,d0
.copy_1:            move.l   (a0)+,(a1)+
                    dbra     d0,.copy_1
                    lea      stars_bitplane1,a0
                    move.l   a0,stars_bitplanes_ptr
                    lea      stars_screen_coords1(pc),a0
                    move.l   a0,stars_screen_coords_ptr
                    rts

.buffer_2:          lea      stars_bps_dat1(pc),a0
                    lea      stars_bps(pc),a1
                    moveq    #6-1,d0
.copy_2:            move.l   (a0)+,(a1)+
                    dbra     d0,.copy_2
                    lea      stars_bitplane2,a0
                    move.l   a0,stars_bitplanes_ptr
                    lea      stars_screen_coords2(pc),a0
                    move.l   a0,stars_screen_coords_ptr
                    rts

stars_swap_buffers: dc.w     0

setup_stars:        bsr.b    prepare_stars_bitplanes
                    ; no rts
create_stars_coords:
                    move.l   #$4D373729,d0
                    move.l   d0,d1
                    rol.w    #3,d1
                    swap     d1
                    eor.l    #$5A5AA5A5,d1
                    bsr      set_random_seed
                    lea      stars_3d_coords,a5
                    move.w   #409-1,d5
.create_x:          move.w   #768,d0
                    bsr      rand
                    sub.w    #384,d0
                    move.w   d0,(a5)
                    lea      6(a5),a5
                    dbra     d5,.create_x

                    lea      stars_3d_coords+2,a5
                    move.w   #409-1,d5
.create_y:          move.w   #512,d0
                    bsr      rand
                    sub.w    #256,d0
                    move.w   d0,(a5)
                    lea      6(a5),a5
                    dbra     d5,.create_y
                    
                    lea      stars_3d_coords+4,a5
                    move.w   #409-1,d5
.create_z:          move.w   #1024,d0
                    bsr      rand
                    move.w   d0,(a5)
                    lea      6(a5),a5
                    dbra     d5,.create_z
                    rts

prepare_stars_bitplanes:
                    lea      stars_bitplane1,a0
                    move.w   #(256*48*3)-1,d0
.clear_plane_1:     clr.b    (a0)+
                    dbra     d0,.clear_plane_1
                    lea      stars_bitplane2,a0
                    move.w   #(256*48*3)-1,d0
.clear_plane_2:     clr.b    (a0)+
                    dbra     d0,.clear_plane_2
                    move.l   #stars_bitplane1,d0
                    lea      stars_bps_dat1(pc),a0
                    move.w   #BPL1PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL1PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #BPL3PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL3PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #BPL5PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL5PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.l   #stars_bitplane2,d0
                    lea      stars_bps_dat2(pc),a0
                    move.w   #BPL1PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL1PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #BPL3PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL3PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #BPL5PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL5PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    rts

stars_screen_coords1:
                    dcb.l    200,0
stars_screen_coords2:
                    dcb.l    200,0
stars_bps_dat1:     dcb.l    6,0
stars_bps_dat2:     dcb.l    6,0
stars_bitplanes_ptr:
                    dc.l     stars_bitplane1
stars_screen_coords_ptr:
                    dc.l     stars_screen_coords1
stars_pos_x:        dc.w     0
stars_pos_y:        dc.w     0
stars_pos_z:        dc.w     1
stars_nbr:          dc.w     81-1

stars_centers:      dc.w     144,128
stars_aspect_x:     dc.w     160
stars_aspect_y:     dc.w     127

move_stars:         move.l   stars_direction_x(pc),a0
                    cmp.w    #-32,(a0)
                    bne.b    reset_stars_dir_x
                    move.l   #stars_directions_table,stars_direction_x
                    lea      stars_directions_table(pc),a0
reset_stars_dir_x:  addq.l   #2,stars_direction_x
                    move.w   (a0),stars_pos_x
                    move.l   stars_direction_y(pc),a0
                    cmp.w    #-32,(a0)
                    bne.b    reset_stars_dir_y
                    move.l   #stars_directions_table,stars_direction_y
                    lea      stars_directions_table(pc),a0
reset_stars_dir_y:  addq.l   #2,stars_direction_y
                    move.w   (a0),stars_pos_y
                    move.l   stars_direction_z(pc),a0
                    cmp.w    #-32,(a0)
                    bne.b    reset_stars_dir_z
                    move.l   #stars_directions_table,stars_direction_z
                    lea      stars_directions_table(pc),a0
reset_stars_dir_z:  addq.l   #2,stars_direction_z
                    move.w   (a0),stars_pos_z
                    rts

stars_direction_x:  dc.l     stars_directions_table
stars_direction_y:  dc.l     stars_directions_table+(256*2)
stars_direction_z:  dc.l     stars_directions_table+(384*2)

stars_directions_table:
                    dcb.w    32,0
                    dcb.w    32,1
                    dcb.w    32,2
                    dcb.w    32,3
                    dcb.w    32,4
                    dcb.w    32,5
                    dcb.w    32,6
                    dcb.w    32,7
                    dcb.w    32,8
                    dcb.w    32,7
                    dcb.w    32,6
                    dcb.w    32,5
                    dcb.w    32,4
                    dcb.w    32,3
                    dcb.w    32,2
                    dcb.w    32,1
                    dcb.w    32,0
                    dcb.w    32,-1
                    dcb.w    32,-2
                    dcb.w    32,-3
                    dcb.w    32,-4
                    dcb.w    32,-5
                    dcb.w    32,-6
                    dcb.w    32,-7
                    dcb.w    32,-8
                    dcb.w    32,-7
                    dcb.w    32,-6
                    dcb.w    32,-5
                    dcb.w    32,-4
                    dcb.w    32,-3
                    dcb.w    32,-2
                    dcb.w    32,-1
                    dc.w     -32

display_text:       movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW002952(pc),a0
                    lea      lbW0028B6(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    movem.l  (sp)+,d0-d7/a0-a6
                    lea      CUSTOM,a6
                    moveq    #0,d0
                    moveq    #0,d1
                    move.w   (a0)+,d0
                    move.w   (a0)+,d1
                    add.w    #68,d0
                    add.w    #12,d1
                    move.l   d0,d7
next_letter:        move.l   (a1),a2
                    move.l   d0,d2
                    move.l   d2,d3
                    and.w    #15,d3
                    swap     d3
                    lsr.l    #4,d3
                    and.w    #$F000,d3
                    lsr.l    #3,d2
                    add.l    d2,a2
                    move.l   12(a1),d2
                    addq.l   #4,d2
                    mulu     d1,d2
                    add.l    d2,a2
                    moveq    #0,d4
                    move.b   (a0)+,d2
                    cmp.b    #' ',d2
                    beq      space_letter
                    move.l   36(a1),a3
search_letter:      cmp.b    (a3)+,d2
                    beq.b    display_letter
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.b    search_letter
                    bra      return

display_letter:     move.l   32(a1),a3
                    add.l    d4,a3
                    WAIT_BLIT
                    move.l   #$1000000,BLTCON0(a6)
                    move.l   #letter_buffer,BLTDPTH(a6)
                    move.w   #2,BLTDMOD(a6)
                    move.w   #(16*64)+1,BLTSIZE(a6)
                    WAIT_BLIT
                    move.l   8(a1),d2
                    move.l   28(a1),d5
                    move.l   #letter_buffer,d4
                    move.l   #-1,BLTAFWM(a6)
                    move.l   #$DFC0000,BLTCON0(a6)
                    move.l   24(a1),d6
                    addq.w   #2,d6
                    move.w   d6,BLTAMOD(a6)
                    move.w   #2,BLTDMOD(a6)
                    move.w   #2,BLTBMOD(a6)
                    move.l   a3,d6
blit_letter_mask:          
                    WAIT_BLIT
                    move.l   d6,BLTAPTH(a6)
                    move.l   d4,BLTBPTH(a6)
                    move.l   d4,BLTDPTH(a6)
                    move.w   #(16*64)+1,BLTSIZE(a6)
                    add.l    d5,d6
                    subq.w   #1,d2
                    bne.b    blit_letter_mask
                    WAIT_BLIT
                    move.l   #$FFFF0000,BLTAFWM(a6)
                    move.w   d3,BLTCON1(a6)
                    or.w     #$FE2,d3
                    move.w   d3,BLTCON0(a6)
                    clr.w    BLTBMOD(a6)
                    move.w   26(a1),BLTAMOD(a6)
                    move.w   14(a1),BLTDMOD(a6)
                    move.w   14(a1),BLTCMOD(a6)
                    move.l   8(a1),d5
                    move.l   4(a1),d2
                    move.l   28(a1),d3
                    move.l   #letter_buffer,d4
                    move.w   22(a1),d6
                    lsl.w    #6,d6
                    addq.w   #2,d6
blit_letter_on_screen:          
                    WAIT_BLIT
                    move.l   d4,BLTBPTH(a6)
                    move.l   a3,BLTAPTH(a6)
                    move.l   a2,BLTCPTH(a6)
                    move.l   a2,BLTDPTH(a6)
                    move.w   d6,BLTSIZE(a6)
                    add.l    d2,a2
                    add.l    d3,a3
                    subq.b   #1,d5
                    bne.b    blit_letter_on_screen
                    cmp.l    #2,lbL000A08
                    beq.b    space_letter
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW002396(pc),a0
                    move.w   d0,(a0)
                    move.w   d1,2(a0)
                    add.w    #16,(a0)
                    addq.w   #1,2(a0)
                    bsr      wait_sync
                    movem.l  (sp)+,d0-d7/a0-a6
space_letter:       add.l    #9,d0
                    tst.b    (a0)
                    bmi.b    return
                    bne      next_letter
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    #12,d1
                    addq.l   #1,d1
                    bra      next_letter

return:             rts

letter_buffer:      dcb.l    32,0

wait_sync:          cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    wait_sync
.wait:              cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    .wait
                    rts

lbL003DAE:          dc.l     lbL0052E4,9600,3,36,16,16,80,1344
                    dc.l     font_pic
                    dc.l     ascii_letters
lbL003DD6:          dc.l     lbL01F0E4,5840,3,36,16,16,80,1344
                    dc.l     font_pic
                    dc.l     ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ>1234567890.!?:'
lbB003E27:          dc.b     ' '
lbW003E28:          dc.w     0

lbC003E2A:          move.l   text_credits_ptr(pc),a0
                    tst.l    (a0)
                    bne.b    lbC003E7C
                    lea      text_credits_table(pc),a0
                    cmp.l    #text_credits_table,text_credits_ptr
                    bmi.b    lbC003E76
                    cmp.l    #text_credits1,text_credits_ptr
                    bpl.b    lbC003E76
                    move.l   #-1,return_value                   ; run story_exe
                    move.w   #1,lbW001844
                    move.l   a0,text_credits_ptr
                    rts

lbC003E76:          move.l   a0,text_credits_ptr
lbC003E7C:          addq.l   #8,text_credits_ptr
                    moveq    #0,d0
                    move.l   a0,-(sp)
                    moveq    #20,d0
                    bsr      rand
                    move.l   d0,d1
                    move.l   (sp)+,a0
                    moveq    #0,d0
                    cmp.l    #15,d1
                    bmi.b    lbC003EB6
                    move.l   #4,d0
lbC003EB6:          addq.l   #1,lbL0042DA
                    cmp.l    #16,lbL0042DA
                    bpl.b    lbC003ECA
                    moveq    #0,d0
lbC003ECA:          move.l   0(a0,d0.l),a0
                    lea      lbL003DAE(pc),a1
                    bsr      display_text
                    move.l   #350,d0
lbC003EDE:          tst.w    lbW001844
                    bne      lbC003F52
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    lbC003F54
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      lbC003F54
                    bsr      wait_sync2
                    subq.l   #1,d0
                    bne.b    lbC003EDE
                    lea      lbW002952(pc),a0
                    lea      lbW002962(pc),a1
                    lea      lbW0028B6(pc),a2
                    moveq    #8,d0
                    bsr      lbC001BA2
                    bsr      lbC001B7A
                    lea      lbW002962(pc),a0
                    lea      lbL0042E4(pc),a1
                    lea      lbW0028B6(pc),a2
                    moveq    #8,d0
                    bsr      lbC001BA2
                    bsr      lbC001B7A
                    bsr      lbC003F74
                    bra      lbC003E2A

lbC003F52:          rts

lbC003F54:          move.w   #1,lbW001844
                    rts

wait_sync2:         cmp.b   #255,CUSTOM+VHPOSR
                    bne.b   wait_sync2
.wait:              cmp.b   #0,CUSTOM+VHPOSR
                    bne.b   .wait
                    rts

lbC003F74:          lea      lbL0061E4(pc),a0
                    WAIT_BLIT
                    move.l   #$1000000,CUSTOM+BLTCON0
                    clr.w    CUSTOM+BLTDMOD
                    moveq    #3,d0
blit_clear:         move.l   a0,CUSTOM+BLTDPTH
                    move.w   #(144*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(240*40),a0
                    subq.l   #1,d0
                    bne.b    blit_clear
                    rts

text_credits_ptr:   dc.l    text_credits_table
text_credits_table: dc.l    text_credits1
                    dc.l    text_credits1
                    dc.l    text_credits2
                    dc.l    text_credits2
                    dc.l    text_credits3
                    dc.l    text_credits3
                    dc.l    text_credits4
                    dc.l    text_credits4
                    dc.l    text_credits5
                    dc.l    text_credits5
                    dc.l    text_credits6
                    dc.l    text_credits6
                    dc.l    text_credits7
                    dc.l    text_credits7
                    dc.l    text_credits8
                    dc.l    text_credits8
                    dc.l    text_credits9
                    dc.l    text_credits9
                    dc.l    0
                    dc.l    0

text_credits1:      dc.w     4,136
                    dc.b     '   PROGRAMMED BY:   ',0
                    dc.b     '   ANDREAS TADIC    ',0
                    dc.b     '    PETER TULEBY    '
                    dc.b     -1
                    even
text_credits2:      dc.w     4,136
                    dc.b     'GRAPHICS AND CONCEPT',0
                    dc.b     '         BY:        ',0
                    dc.b     '     RICO HOLMES    '
                    dc.b     -1
                    even
text_credits3:      dc.w     4,136
                    dc.b     ' SOUND AND MUSIC BY:',0
                    dc.b     '  ALLISTER BRIMBLE  '
                    dc.b     -1
                    even
text_credits4:      dc.w     4,136
                    dc.b     'ADDITIONAL CODE AND ',0
                    dc.b     'CD32 PROGRAMMING BY:',0
                    dc.b     '   STEFAN BOBERG    '
                    dc.b     -1
                    even
text_credits5:      dc.w     2,136
                    dc.b     'SPECIAL EDITION CODING:',0
                    dc.b     '     ANDREAS TADIC     '
                    dc.b     -1
                    even
text_credits6:      dc.w     4,136
                    dc.b     'SPEECH COURTESY OF: ',0
                    dc.b     '   LYNETTE READE    '
                    dc.b     -1
                    even
text_credits7:      dc.w     4,136
                    dc.b     '  GAME DESIGNED BY: ',0
                    dc.b     '     RICO HOLMES    ',0
                    dc.b     '     MARTYN BROWN   '
                    dc.b     -1
                    even
text_credits8:      dc.w     4,136
                    dc.b     ' PROJECT MANAGEMENT ',0
                    dc.b     '         BY:        ',0
                    dc.b     '    MARTYN BROWN    '
                    dc.b     -1
                    even
text_credits9:      dc.w     4,136
                    dc.b     ' A TEAM 17 SOFTWARE ',0
                    dc.b     '     PRODUCTION     ',0
                    dc.b     '        1992        '
                    dc.b     -1
                    even

set_random_seed:    add.l    d0,d1
                    movem.l  d0/d1,seed
get_rnd_number:     movem.l  d2/d3,-(sp)
                    movem.l  seed(pc),d0/d1
                    and.b    #14,d0
                    or.b     #$20,d0
                    move.l   d0,d2
                    move.l   d1,d3
                    add.l    d2,d2
                    addx.l   d3,d3
                    add.l    d2,d0
                    addx.l   d3,d1
                    swap     d3
                    swap     d2
                    move.w   d2,d3
                    clr.w    d2
                    add.l    d2,d0
                    addx.l   d3,d1
                    movem.l  d0/d1,seed
                    move.l   d1,d0
                    movem.l  (sp)+,d2/d3
                    rts

rand:               addq.w   #1,d0
                    move.w   d0,d2
                    beq.b    .nop
                    bsr.b    get_rnd_number
                    clr.w    d0
                    swap     d0
                    divu     d2,d0
                    clr.w    d0
                    swap     d0
.nop:               rts

seed:               dcb.l    2,0
lbL0042DA:          dc.l     0
share_credits:      dc.l     0
lbL0042E4:          dcb.l    16,0

; -----------------------------------------------------

font_pic:           incbin   "font_16x672x3.raw"

lbL0052E4:          dcb.b    3600,0
lbL0060F4:          dcb.b    240,0
lbL0061E4:          dcb.b    3680,0
lbL007044:          dcb.b    21280,0
stars_bitplane1:    dcb.b    (256*48*3),0
stars_bitplane2:    dcb.b    (256*48*3),0

copyright_pic:      incbin   "copyright_320x16x3.raw"

copyright_palette:  dc.w     $000,$620,$720,$830,$940,$A40,$B50,$C60
empty_pic:          dcb.b    1280,0
stars_3d_coords:    dcb.w    120,0
lbL01F0E4:          dcb.b    3760,0
lbL01FF94:          dcb.b    17520,0

title_pic:          incbin   "title_320x90x6.raw"

                    end
