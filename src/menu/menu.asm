; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

                    mc68000

WAIT_BLIT           MACRO
wait\@:             btst     #14,$dff002
                    bne.s    wait\@
                    ENDM

                    section  menu,code_c

start:              move.l   d5,number_players
                    move.l   d7,share_credits
                    move.l   a1,reg_vbr
                    bsr      setup_context
                    bsr      lbC00112C
                    bsr      lbC00173C
                    clr.l    lbL000A08
                    lea      copper_palette_stars,a0
                    lea      stars_palette,a1
                    move.l   #8,d0
                    bsr      fade_in
                    bsr      lbC001B7A
                    jsr      wait_button_press
                    bsr      lbC00173C
                    move.w   #1,lbW00198A
                    clr.w    lbW001844
                    move.l   #134,d0
.pause:             move.l   d0,-(sp)
                    move.l   (sp)+,d0
                    subq.l   #1,d0
                    bne.s    .pause
                    bsr      lbC001284
                    move.l   share_credits,d1
                    clr.l    d4
                    move.l   number_players,d6
                    move.l   return_value,d7
                    bsr      restore_lev3irq
                    rts

reg_vbr:            dc.l     0

wait_button_press:  btst     #7,$bfe001
                    beq.s    wait_button_press
                    btst     #6,$bfe001
                    beq.s    wait_button_press
                    rts

return_value:       dc.l     0
number_players:     dc.l     0

lbL000A08:          dc.l     0
lbL000A0C:          dc.l     0

lbC000A10:          move.l   #1,lbL000A08
                    move.w   #1,flag_quit
                    bsr      lbC003F74
                    bsr      wait_sync2
                    lea      lbW0028D6,a0
                    move.l   #$DF01FF00,(a0)+
                    move.l   #$1980000,(a0)+
                    move.l   #$EF01FF00,(a0)+
                    move.l   #$1980444,(a0)+
                    move.l   #$FFD7FFFE,(a0)+
                    tst.w    return_value
                    bne      lbC000A5C
                    bsr      lbC000ED6
lbC000A5C:          move.w   #1,lbW00195E
                    move.w   #2,lbW000C42
                    clr.w    d0
                    clr.l    lbL000A0C
lbC000A74:          addq.l   #1,lbL000A0C
                    cmp.l    #1000,lbL000A0C
                    bpl      lbC000BB2
                    move.w   $dff00c,d1
                    and.w    #$303,d1
                    tst.w    d1
                    beq.s    lbC000A9C
                    clr.l    lbL000A0C
lbC000A9C:          move.w   lbW000C42,d1
                    mulu     #13,d1
                    ext.l    d1
                    add.w    #$A7,d1
                    lsl.w    #8,d1
                    or.w     #1,d1
                    move.w   d1,lbW0028D6
                    add.w    #$C00,d1
                    move.w   d1,lbW0028DE
                    move.w   $dff00c,d1
                    and.w    #$303,d1
                    cmp.w    d1,d0
                    beq.s    lbC000B04
                    move.w   #10,lbW000C44
                    move.w   d1,d0
                    cmp.w    #256,d0
                    bne.s    lbC000AEE
                    tst.w    lbW000C42
                    beq.s    lbC000AEE
                    subq.w   #1,lbW000C42
lbC000AEE:          cmp.w    #1,d0
                    bne.s    lbC000B04
                    cmp.w    #2,lbW000C42
                    beq.s    lbC000B04
                    addq.w   #1,lbW000C42
lbC000B04:          bsr      wait_sync2
                    add.w    #1,lbW000C44
                    cmp.w    #20,lbW000C44
                    bne.s    lbC000B22
                    clr.w    lbW000C44
                    clr.w    d0
lbC000B22:          tst.l    return_value
                    bne      lbC000B44
                    btst     #7,$bfe001
                    beq      lbC000B44
                    btst     #6,$bfe001
                    bne      lbC000A74
lbC000B44:          cmp.w    #2,lbW000C42
                    beq      lbC000BA2
                    cmp.w    #1,lbW000C42
                    bne      lbC000B78
                    move.l   share_credits,d0
                    not.l    d0
                    and.l    #1,d0
                    move.l   d0,share_credits
                    bsr      lbC000ED6
                    bra      lbC000A74

lbC000B78:          cmp.w    #0,lbW000C42
                    bne.s    lbC000B9E
                    move.l   number_players,d0
                    bchg     #0,d0
                    bchg     #1,d0
                    move.l   d0,number_players
                    bsr      lbC000ED6
                    bra      lbC000A74

lbC000B9E:          bra      lbC000A74

lbC000BA2:          clr.w    lbW000C40
                    cmp.w    #2,lbW000C42
                    beq.s    lbC000BBA
lbC000BB2:          move.w   #1,lbW000C40
lbC000BBA:          clr.l    lbL000A08
                    clr.w    lbW00195E
                    lea      lbW002952,a0
                    lea      lbL0042E4,a1
                    lea      lbW0028B6,a2
                    move.l   #8,d0
                    bsr      lbC001BA2
                    bsr      lbC001B8C
                    bsr      lbC00173C
                    lea      lbW0028D6,a0
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    bsr      lbC003F74
lbC000C24:          btst     #6,$bfe001
                    beq.s    lbC000C24
                    btst     #7,$bfe001
                    beq.s    lbC000C24
                    clr.w    lbW001844
                    rts

lbW000C40:          dc.w     0
lbW000C42:          dc.w     0
lbW000C44:          dc.w     0

lbC000ED6:          move.w   #1,flag_quit
                    bsr      wait_blitter
                    move.l   #$1000000,$dff040
                    clr.w    $dff066
                    lea      lbL01FF94,a0
                    move.l   a0,$dff054
                    move.w   #(438*64)+20,$dff058
                    bsr      wait_blitter
                    lea      text_menu,a0
                    cmp.l    #1,share_credits
                    bne.s    lbC000F22
                    add.l    #124,a0
lbC000F22:          cmp.l    #2,number_players
                    bne.s    lbC000F34
                    add.l    #62,a0
lbC000F34:          lea      lbL003DAE,a1
                    cmp.l    #1,lbL000A08
                    beq.s    lbC000F4C
                    lea      lbL003DD6,a1
lbC000F4C:          jsr      display_text
                    cmp.l    #1,lbL000A08
                    beq      lbC001006
                    bsr      wait_sync2
                    lea      lbL0052E4,a1
                    move.l   #(94*40),d0
                    add.l    d0,a1
                    lea      lbL01FF94,a0
                    bsr      wait_blitter
                    move.w   #$8400,$dff096
                    move.l   #$9f00000,$dff040
                    move.l   #-1,$dff044
                    clr.l    $dff064
                    move.l   a0,$dff050
                    move.l   a1,$dff054
                    move.w   #(146*64)+20,$dff058
                    bsr      wait_blitter
                    add.l    #(146*40),a0
                    add.l    #(240*40),a1
                    move.l   a0,$dff050
                    move.l   a1,$dff054
                    move.w   #(146*64)+20,$dff058
                    bsr      wait_blitter
                    add.l    #(146*40),a0
                    add.l    #(240*40),a1
                    move.l   a0,$dff050
                    move.l   a1,$dff054
                    move.w   #(146*64)+20,$dff058
                    bsr      wait_blitter
                    move.w   #$400,$dff096
lbC001006:          clr.l    lbL000A08
lbC00100C:          btst     #6,$bfe001
                    beq.s    lbC00100C
                    btst     #7,$bfe001
                    beq.s    lbC00100C
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
                    bne.s    lbC001124
                    rts

lbC00112C:          lea      lbL0042E4,a0
                    lea      lbW0028B6,a1
                    move.l   #8,d0
                    jsr      set_palette
                    move.l   #$2C01FF00,lbW002912
                    lea      copyright_bps,a0
                    move.l   #copyright_pic,d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #$280,d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #$280,d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    lea      copyright_palette,a0
                    lea      lbW00292E,a1
                    move.l   #8,d0
                    jsr      set_palette
                    lea      empty_bps,a0
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
                    lea      lbL0042E4,a0
                    lea      copper_palette_title,a1
                    move.l   #8,d0
                    jsr      set_palette
                    lea      lbL0042E4,a0
                    lea      lbW0028B6,a1
                    move.l   #8,d0
                    jsr      set_palette
                    move.w   #1,lbW002570
                    clr.w    lbW00198A
                    move.w   #-40,copper_modulo
                    lea      lbL0042E4,a0
                    lea      copper_palette_stars,a1
                    move.l   #8,d0
                    jsr      set_palette
                    lea      lbW0028D6,a0
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #copperlist_main,$dff080
                    clr.w    copper_modulo
                    lea      copper_palette_title,a0
                    lea      palette_logo,a1
                    move.l   #8,d0
                    bsr      fade_in
                    bsr      lbC001B7A
                    rts

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
                    lea      copper_palette_title,a0
                    lea      lbL0042E4,a1
                    move.l   #8,d0
                    bsr      fade_out
                    bsr      lbC001B7A
                    lea      lbW00292E,a0
                    lea      lbL0042E4,a1
                    move.l   #8,d0
                    bsr      fade_out
                    bsr      lbC001B7A
                    lea      lbW0028B6,a0
                    lea      lbL0042E4,a1
                    move.l   #8,d0
                    bsr      fade_out
                    bsr      lbC001B7A
                    lea      copper_palette_stars,a0
                    lea      lbL0042E4,a1
                    move.l   #8,d0
                    bsr      fade_out
                    bsr      lbC001B7A
                    rts

stars_palette:      dc.w     $000,$111,$222,$333,$555,$888,$AAA,0

setup_context:      jsr      setup_stars
                    bsr      install_lev3irq
                    bsr      display_title
                    lea      menu_bps,a0
                    move.l   #lbL0060F4,d0
                    bsr      set_menu_bps
                    move.l   #copperlist_blank,$dff080
                    lea      lbW002396,a0
                    bsr      lbC00227A
                    lea      lbW002396,a0
                    jsr      set_random_seed
                    rts

display_title:      move.l   #title_pic,d0
                    not.w    flag_swap_title
                    beq.s    .second_title
                    add.l    #(89*40),d0
.second_title:      lea      title_bps,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #7200,d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #7200,d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    rts

flag_swap_title:    dc.w     0

set_menu_bps:       move.l   #3,d1
.loop:              move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(240*40),d0
                    addq.l   #8,a0
                    subq.l   #1,d1
                    bne.s    .loop
                    rts

lbL001466:          dc.l     lbW00146A
lbW00146A:          dcb.w    $18,$10
                    dcb.w    $12,$20
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
                    dcb.w    $12,$E0
                    dcb.w    $18,$F0
                    dcb.w    $12,$E0
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
                    dcb.w    $12,$20
                    dc.w     $FFFF

lbC00173C:          rts

install_lev3irq:    move.l   reg_vbr,a0
                    move.l   $6C(a0),old_lev3irq
                    move.l   #lev3irq,$6C(a0)
                    rts

restore_lev3irq:    move.l   reg_vbr,a0
                    move.l   old_lev3irq,$6C(a0)
                    rts

lbW00183C:          dcb.w    2,0
lbL001840:          dc.l     0
lbW001844:          dc.w     0

lev3irq:            movem.l  d0-d7/a0-a6,-(sp)
                    btst     #5,$dff01f
                    beq      lbC0018D0
                    bsr      lbC001DB6
                    bsr      lbC001F94
                    bsr      lbC001C54
                    bsr      lbC001916
                    bsr      display_title
                    lea      lbW002396,a0
                    bsr      lbC0022B0
                    move.w   #321,lbW002396
                    btst     #6,$bfe001
                    beq.s    lbC001894
                    btst     #7,$bfe001
                    bne.s    lbC00189C
lbC001894:          move.w   #1,lbW001844
lbC00189C:          tst.w    lbW00198A
                    beq      lbC0018BC
                    cmp.l    #$1D01FF00,lbW002912
                    bmi.s    lbC0018BC
                    sub.l    #$1000000,lbW002912
lbC0018BC:          jsr      display_stars
                    bsr      lbC00198C
                    move.l   #200,d0
lbC0018CC:          subq.l   #1,d0
                    bne.s    lbC0018CC
lbC0018D0:          movem.l  (sp)+,d0-d7/a0-a6
                    move.l   old_lev3irq(pc),-(sp)
                    rts

old_lev3irq:        dc.l    0 

lbC0018F6:          move.w   lbW0028C8,lbW0028DC
                    move.w   lbW0028C8,lbW0028E4
                    move.l   #lbW001966,lbL001960
                    rts

lbC001916:          tst.w    lbW00195E
                    beq      lbC0018F6
                    add.w    #1,lbW001964
                    cmp.w    #3,lbW001964
                    bmi      lbC001988
                    clr.w    lbW001964
                    move.l   lbL001960,a0
                    tst.w    (a0)
                    bpl.s    lbC001950
                    lea      lbW001966,a0
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
                    move.l   lbL0019DA,a0
                    tst.l    (a0)
                    bne.s    lbC0019BE
                    lea      lbL0019E2,a0
                    move.l   a0,lbL0019DA
lbC0019BE:          addq.l   #4,lbL0019DA
                    move.l   (a0),a1
                    move.l   -4(a0),a0
                    lea      copper_palette_title,a2
                    move.l   #8,d0
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
                    beq.s    lbC001B7A
                    rts

lbC001B8C:          tst.w    flag_quit
                    beq.s    lbC001B7A
                    rts

lbC001B96:          clr.w    2(a0)
                    addq.l   #4,a0
                    subq.w   #1,d0
                    bne.s    lbC001B96
                    rts

lbC001BA2:          movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #1,lbW002086
                    move.w   d0,lbW00208E
                    move.l   a1,lbL002090
                    move.l   a2,lbL002094
                    move.l   a0,a2
                    lea      lbL002098,a3
                    move.w   lbW00208E,d0
lbC001BCE:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bmi.s    lbC001BE4
                    bhi.s    lbC001BEA
                    clr.b    (a3)+
                    bra.s    lbC001BEE

lbC001BE4:          move.b   #-1,(a3)+
                    bra.s    lbC001BEE

lbC001BEA:          move.b   #1,(a3)+
lbC001BEE:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bmi.s    lbC001C04
                    bhi.s    lbC001C0A
                    clr.b    (a3)+
                    bra.s    lbC001C0E

lbC001C04:          move.b   #-1,(a3)+
                    bra.s    lbC001C0E

lbC001C0A:          move.b   #1,(a3)+
lbC001C0E:          move.w   (a2)+,d1
                    move.w   (a1)+,d2
                    and.w    #$F,d1
                    and.w    #$F,d2
                    cmp.w    d1,d2
                    bmi.s    lbC001C24
                    bhi.s    lbC001C2A
                    clr.b    (a3)+
                    bra.s    lbC001C2E

lbC001C24:          move.b   #-1,(a3)+
                    bra.s    lbC001C2E

lbC001C2A:          move.b   #1,(a3)+
lbC001C2E:          subq.b   #1,d0
                    bne.s    lbC001BCE
                    move.l   lbL002094,a2
                    move.w   lbW00208E,d0
                    addq.l   #2,a2
lbC001C40:          move.w   (a0)+,(a2)
                    addq.l   #4,a2
                    subq.b   #1,d0
                    bne.s    lbC001C40
                    clr.w    flag_quit
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC001C54:          cmp.w    #1,lbW002086
                    bne      lbC0020F8
                    tst.w    flag_quit
                    bne      lbC0020F8
                    clr.l    d7
                    add.w    #1,lbW00208A
                    move.w   lbW00208A,d0
                    cmp.w    lbW002088,d0
                    bmi      lbC0020F8
                    clr.w    lbW00208A
                    move.w   lbW00208E,d0
                    move.l   lbL002094,a0
                    move.l   lbL002090,a1
                    lea      lbL002098,a3
                    addq.l   #2,a0
lbC001CA4:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bne.s    lbC001CBA
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC001CC8

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
                    bne.s    lbC001CDE
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC001CEC

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
                    bne.s    lbC001D02
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC001D0C

lbC001D02:          move.b   (a3)+,d3
                    add.b    d3,d1
                    and.w    #$FF0,(a0)
                    or.w     d1,(a0)
lbC001D0C:          addq.l   #4,a0
                    subq.b   #1,d0
                    bne.s    lbC001CA4
                    divu     #3,d7
                    cmp.w    lbW00208E,d7
                    bne.s    lbC001D2C
                    move.w   #1,flag_quit
                    clr.w    lbW002086
lbC001D2C:          rts

set_palette:        addq.l   #2,a1
lbC001D30:          move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #1,d0
                    bne.s    lbC001D30
                    rts

fade_in:            move.w   #2,lbW002086
                    lea      lbL0021BA,a4
                    move.l   #48,d2
lbC001D4E:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC001D4E
                    move.l   d0,d7
                    move.l   a1,a2
                    clr.l    d6
                    lea      lbL0020FA,a3
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
                    bne      .loop
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
                    add.w    #1,lbW00208A
                    move.w   lbW00208A,d0
                    cmp.w    lbW002088,d0
                    bmi      lbC0020F8
                    clr.w    lbW00208A
                    move.l   lbL002094,a0
                    move.l   lbL002090,a1
                    clr.l    d0
                    move.w   lbW00208E,d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      lbL0020FA,a2
                    lea      lbL0021BA,a3
                    move.l   d6,d7
                    move.l   d0,d1
lbC001E14:          addq.l   #4,a0
                    addq.l   #2,a1
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F00,d2
                    and.w    #$F00,d3
                    cmp.w    d2,d3
                    beq      lbC001E3C
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC001E3C:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq      lbC001E6E
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC001E6E:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F,d2
                    and.w    #$F,d3
                    cmp.w    d2,d3
                    beq      lbC001EA0
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC001EA0:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC001E14
                    cmp.l    d6,d7
                    bne      lbC001EC6
                    move.w   #1,flag_quit
                    clr.w    lbW002086
lbC001EC6:          rts

fade_out:           move.w   #3,lbW002086
                    lea      lbL0021BA,a4
                    move.l   #48,d2
lbC001EDC:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC001EDC
                    move.l   d0,d7
                    move.l   a0,a2
                    add.l    #2,a2
                    clr.l    d6
                    lea      lbL0020FA,a3
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
                    bne      lbC001EF6
                    lea      lbL0021BA,a3
                    move.l   a0,a2
                    add.l    #2,a2
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
                    add.l    #4,a2
                    sub.l    #1,d4
                    bne      lbC001F40
                    lea      lbL0020FA,a2
                    lea      lbL0021BA,a3
                    move.l   d1,d4
                    sub.l    #2,a0
                    move.w   d0,lbW00208E
                    move.l   a0,lbL002094
                    clr.w    flag_quit
                    rts

lbC001F94:          cmp.w    #3,lbW002086
                    bne      lbC0020F8
                    tst.w    flag_quit
                    bne      lbC0020F8
                    add.w    #1,lbW00208A
                    move.w   lbW00208A,d0
                    cmp.w    lbW002088,d0
                    bmi      lbC0020F8
                    clr.w    lbW00208A
                    clr.l    d0
                    move.w   lbW00208E,d0
                    move.l   lbL002094,a0
                    move.l   d0,d1
                    clr.l    d7
                    lea      lbL0020FA,a2
                    lea      lbL0021BA,a3
lbC001FE6:          addq.l   #4,a0
                    move.w   (a0),d2
                    and.w    #$F00,d2
                    tst.w    d2
                    beq      lbC002006
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC002006:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F0,d2
                    tst.w    d2
                    beq      lbC002032
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC002032:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F,d2
                    tst.w    d2
                    beq      lbC00205E
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.l    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC00205E:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC001FE6
                    tst.l    d7
                    bne      lbC002084
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
lbL002098:          dcb.l    $18,0

lbC0020F8:          rts

lbL0020FA:          dcb.l    $30,0
lbL0021BA:          dcb.l    $30,0

lbC00227A:          tst.l    $10(a0)
                    bne.s    lbC00229C
                    move.l   12(a0),d0
lbC002284:          move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

lbC00229C:          move.l   $10(a0),a1
                    move.l   a1,$14(a0)
                    move.w   6(a1),$18(a0)
                    move.l   (a1),d0
                    bra      lbC002284

lbC0022B0:          move.l   8(a0),a1
                    tst.l    $10(a0)
                    bne      lbC002348
lbC0022BC:          and.w    #$80,14(a1)
                    move.w   0(a0),d0
                    add.w    #$80,d0
                    btst     #0,d0
                    beq.s    lbC0022D6
                    or.w     #1,14(a1)
lbC0022D6:          lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    add.w    #$2C,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #$100,d1
                    bmi.s    lbC0022FA
                    sub.w    #$FF,d1
                    or.b     #2,15(a1)
lbC0022FA:          move.b   d1,14(a1)
                    cmp.w    #$100,d0
                    bmi.s    lbC00230E
                    sub.w    #$FF,d0
                    or.b     #4,15(a1)
lbC00230E:          move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.s    lbC002346
                    move.w   10(a1),$1A(a1)
                    move.w   14(a1),$1E(a1)
                    move.w   2(a1),d0
                    swap     d0
                    move.w   6(a1),d0
                    move.w   4(a0),d1
                    ext.l    d1
                    add.l    d1,d1
                    add.l    d1,d1
                    addq.l   #4,d1
                    add.l    d1,d0
                    move.w   d0,$16(a1)
                    swap     d0
                    move.w   d0,$12(a1)
lbC002346:          rts

lbC002348:          subq.w   #1,$18(a0)
                    bpl      lbC0022BC
                    addq.l   #8,$14(a0)
lbC002354:          move.l   $14(a0),a2
                    move.l   (a2),d0
                    tst.l    d0
                    bmi.s    lbC002372
                    move.w   6(a2),$18(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      lbC0022BC

lbC002372:          move.l   $10(a0),$14(a0)
                    bra.s    lbC002354

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
                    lea      lbL00257C,a3
                    move.w   lbW002572,d0
lbC00240A:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bmi.s    lbC002420
                    bhi.s    lbC002426
                    clr.b    (a3)+
                    bra.s    lbC00242A

lbC002420:          move.b   #-1,(a3)+
                    bra.s    lbC00242A

lbC002426:          move.b   #1,(a3)+
lbC00242A:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bmi.s    lbC002440
                    bhi.s    lbC002446
                    clr.b    (a3)+
                    bra.s    lbC00244A

lbC002440:          move.b   #-1,(a3)+
                    bra.s    lbC00244A

lbC002446:          move.b   #1,(a3)+
lbC00244A:          move.w   (a2)+,d1
                    move.w   (a1)+,d2
                    and.w    #$F,d1
                    and.w    #$F,d2
                    cmp.w    d1,d2
                    bmi.s    lbC002460
                    bhi.s    lbC002466
                    clr.b    (a3)+
                    bra.s    lbC00246A

lbC002460:          move.b   #-1,(a3)+
                    bra.s    lbC00246A

lbC002466:          move.b   #1,(a3)+
lbC00246A:          subq.b   #1,d0
                    bne.s    lbC00240A
                    move.l   lbL002578,a2
                    move.w   lbW002572,d0
                    addq.l   #2,a2
lbC00247C:          move.w   (a0)+,(a2)
                    addq.l   #4,a2
                    subq.b   #1,d0
                    bne.s    lbC00247C
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

copperlist_blank:   dc.w    $100,$200,$180,0,$96,$20,$FFFF,$FFFE

copperlist_main:    dc.w    $180,0
                    dc.w    $100,$6600
                    dc.w    $8E,$2C81,$90,$2CC1
                    dc.w    $92,$38,$94,$D0
                    dc.w    $108,8,$10A
copper_modulo:      dc.w    0
                    dc.w    $104,$64,$102,0
                    dc.w    $2001,$FF00,$96,$8020
                    dc.w    $1A2,$FFF
sprites_bps:        dc.w    $120,0,$122,0,$140,0,$142,0,$180,0,$124,0,$126,0
                    dc.w    $148,0,$14A,0,$128,0,$12A,0,$150,0,$152,0,$12C,0
                    dc.w    $12E,0,$158,0,$15A,0,$130,0,$132,0,$160,0,$162,0
                    dc.w    $134,0,$136,0,$168,0,$16A,0,$138,0,$13A,0,$170,0
                    dc.w    $172,0,$13C,0,$13E,0,$178,0,$17A,0
copper_palette_stars:
                    dc.w    $180,0,$182,0,$184,0,$186,0,$188,0
                    dc.w    $18A,0,$18C,0,$18E,0
stars_bps:          dc.w    $E0,0,$E2,0
                    dc.w    $E8,0,$EA,0
                    dc.w    $F0,0,$F2,0
title_bps:          dc.w    $E4,0,$E6,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F4,0,$F6,2
copper_palette_title:
                    dc.w    $190,0,$192,0,$194,0,$196,0,$198,0,$19A,0
                    dc.w    $19C,0,$19E,0
                    dc.w    $8501,$FF00
menu_bps:           dc.w    $E4,0,$E6,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F4,0,$F6,2
                    dc.w    $8A01,$FF00
lbW0028B6:          dc.w    $190,0,$192,0,$194,0,$196,0,$198
lbW0028C8:          dc.w    0,$19A,0,$19C,0,$19E,0
lbW0028D6:          dc.w    $8A01,$FF00,$180
lbW0028DC:          dc.w    $20
lbW0028DE:          dc.w    $9A01,$FF00,$180
lbW0028E4:          dc.w    0
                    dc.w    $FFD7,$FFFE
lbW0028EA:          dc.w    $FFD7,$FFFE,$102
lbW0028F0:          dc.w    0
                    dc.w    $601,$FF00
                    dc.w    $1A01
lbW0028F8:          dc.w    $FF00
empty_bps:          dc.w    $E4,0,$E6,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F4,0,$F6,2
lbW002912:          dc.w    0,0
copyright_bps:      dc.w    $E4,0,$E6,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F4,0,$F6,2
lbW00292E:          dc.w    $190,$000,$192,$222,$194,$444,$196,$555,$198,0,$19A,0,$19C,0,$19E,0
                    dc.w    $FFFF,$FFFE

lbW002952:          dc.w    $000,$222,$D31,$B11,$444,$333,$222,$F52

lbW002962:          dc.w    $000,$822,$A31,$811,$F44,$833,$A22,$852,0,$111,$222
                    dc.w    $333,$444,$500,$700,$900

display_stars:      jsr      move_stars
                    bsr      set_stars_buffer
                    bsr.s    clear_stars
                    bsr.s    do_stars
                    rts

clear_stars:        move.l   stars_bitplanes_ptr,a0
                    lea      256*48(a0),a1
                    lea      256*48(a1),a2
                    move.l   stars_screen_coords_ptr(pc),a3
                    move.w   stars_nbr,d1
.clear:             move.l   (a3)+,d0
                    clr.b    0(a0,d0.l)
                    clr.b    0(a1,d0.l)
                    clr.b    0(a2,d0.l)
                    dbra     d1,.clear
                    rts

do_stars:           lea      stars_3d_coords,a0
                    lea      (a0),a1
                    lea      stars_pos_x,a2
                    movem.w  (a2)+,d0-d3
                    lea      stars_centers,a3
                    move.l   stars_bitplanes_ptr,a2
                    move.l   stars_screen_coords_ptr(pc),a4
.plots:             movem.w  (a0)+,d4-d6
                    add.w    d0,d4
                    add.w    d1,d5
                    add.w    d2,d6
                    cmp.w    #384,d4
                    blt.s    .max_x
                    sub.w    #768,d4
.max_x:             cmp.w    #-384,d4
                    bgt.s    .min_x
                    add.w    #768,d4
.min_x:             cmp.w    #256,d5
                    blt.s    .max_y
                    sub.w    #512,d5
.max_y:             cmp.w    #-256,d5
                    bgt.s    .min_y
                    add.w    #512,d5
.min_y:             cmp.w    #1024,d6
                    ble.s    .max_z
                    sub.w    #960,d6
.max_z:             cmp.w    #64,d6
                    bgt.s    .min_z
                    add.w    #960,d6
.min_z:             move.w   d4,(a1)+
                    move.w   d5,(a1)+
                    move.w   d6,(a1)+
                    muls     stars_aspect_x,d4
                    muls     stars_aspect_y,d5
                    divs     d6,d4
                    divs     d6,d5
                    add.w    (a3),d4
                    add.w    2(a3),d5
                    bsr.s    plot_star
                    dbra     d3,.plots
                    rts

no_plot:            rts

plot_star:          tst.w    d4
                    bmi.s    no_plot
                    tst.w    d5
                    bmi.s    no_plot
                    cmp.w    #384,d4
                    bge.s    no_plot
                    cmp.w    #256,d5
                    bge.s    no_plot
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
                    bne.s    .plane_1
                    bset     d4,(a5)
.plane_1:           btst     #1,d6
                    bne.s    .plane_2
                    bset     d4,(256*48)(a5)
.plane_2:           btst     #2,d6
                    bne.s    .plane_3
                    bset     d4,(256*2*48)(a5)
.plane_3:           move.l   d5,(a4)+                   ; save the coordinate
                    rts

set_stars_buffer:   lea      stars_swap_buffers(pc),a0
                    not.w    (a0)
                    beq.s    .buffer_2
                    lea      stars_bps_dat2,a0
                    lea      stars_bps,a1
                    moveq    #6-1,d0
.copy_1:            move.l   (a0)+,(a1)+
                    dbra     d0,.copy_1
                    lea      stars_bitplane1,a0
                    move.l   a0,stars_bitplanes_ptr
                    lea      stars_screen_coords1,a0
                    move.l   a0,stars_screen_coords_ptr
                    rts

.buffer_2:          lea      stars_bps_dat1,a0
                    lea      stars_bps,a1
                    moveq    #6-1,d0
.copy_2:            move.l   (a0)+,(a1)+
                    dbra     d0,.copy_2
                    lea      stars_bitplane2,a0
                    move.l   a0,stars_bitplanes_ptr
                    lea      stars_screen_coords2,a0
                    move.l   a0,stars_screen_coords_ptr
                    rts

stars_swap_buffers: dc.w     0

setup_stars:        bsr.s    prepare_stars_bitplanes
                    bsr.s    create_stars_coords
                    rts

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
                    lea      stars_bps_dat1,a0
                    move.w   #$E0,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #$E2,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #$E8,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #$EA,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #$F0,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #$F2,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.l   #stars_bitplane2,d0
                    lea      stars_bps_dat2,a0
                    move.w   #$E0,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #$E2,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #$E8,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #$EA,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #$F0,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #$F2,(a0)+
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

move_stars:         move.l   stars_direction_x,a0
                    cmp.w    #-32,(a0)
                    bne.s    reset_stars_dir_x
                    move.l   #stars_directions_table,stars_direction_x
                    lea      stars_directions_table,a0
reset_stars_dir_x:  addq.l   #2,stars_direction_x
                    move.w   (a0),stars_pos_x
                    move.l   stars_direction_y,a0
                    cmp.w    #-32,(a0)
                    bne.s    reset_stars_dir_y
                    move.l   #stars_directions_table,stars_direction_y
                    lea      stars_directions_table,a0
reset_stars_dir_y:  addq.l   #2,stars_direction_y
                    move.w   (a0),stars_pos_y
                    move.l   stars_direction_z,a0
                    cmp.w    #-32,(a0)
                    bne.s    reset_stars_dir_z
                    move.l   #stars_directions_table,stars_direction_z
                    lea      stars_directions_table,a0
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
                    lea      lbW002952,a0
                    lea      lbW0028B6,a1
                    moveq    #8,d0
                    bsr      set_palette
                    movem.l  (sp)+,d0-d7/a0-a6
                    lea      $dff000,a6
                    clr.l    d0
                    clr.l    d1
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
                    clr.l    d4
                    move.b   (a0)+,d2
                    cmp.b    #' ',d2
                    beq      space_letter
                    move.l   $24(a1),a3
search_letter:      cmp.b    (a3)+,d2
                    beq.s    display_letter
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.s    search_letter
                    bra      return

display_letter:     move.l   $20(a1),a3
                    add.l    d4,a3
                    WAIT_BLIT
                    move.l   #$1000000,$40(a6)
                    move.l   #letter_buffer,$54(a6)
                    move.w   #2,$66(a6)
                    move.w   #(16*64)+1,$58(a6)
                    WAIT_BLIT
                    move.l   8(a1),d2
                    move.l   $1C(a1),d5
                    move.l   #letter_buffer,d4
                    move.l   #-1,$44(a6)
                    move.l   #$DFC0000,$40(a6)
                    move.l   $18(a1),d6
                    addq.w   #2,d6
                    move.w   d6,$64(a6)
                    move.w   #2,$66(a6)
                    move.w   #2,$62(a6)
                    move.l   a3,d6
blit_letter_mask:          
                    WAIT_BLIT
                    move.l   d6,$50(a6)
                    move.l   d4,$4C(a6)
                    move.l   d4,$54(a6)
                    move.w   #(16*64)+1,$58(a6)
                    add.l    d5,d6
                    subq.w   #1,d2
                    bne.s    blit_letter_mask
                    WAIT_BLIT
                    move.l   #$FFFF0000,$44(a6)
                    move.w   d3,$dff042
                    or.w     #$FE2,d3
                    move.w   d3,$40(a6)
                    clr.w    $62(a6)
                    move.w   $1A(a1),$64(a6)
                    move.w   14(a1),$66(a6)
                    move.w   14(a1),$60(a6)
                    move.l   8(a1),d5
                    move.l   4(a1),d2
                    move.l   $1C(a1),d3
                    move.l   #letter_buffer,d4
                    move.w   $16(a1),d6
                    lsl.w    #6,d6
                    addq.w   #2,d6
blit_letter_on_screen:          
                    WAIT_BLIT
                    move.l   d4,$4C(a6)
                    move.l   a3,$50(a6)
                    move.l   a2,$48(a6)
                    move.l   a2,$54(a6)
                    move.w   d6,$58(a6)
                    add.l    d2,a2
                    add.l    d3,a3
                    subq.b   #1,d5
                    bne.s    blit_letter_on_screen
                    cmp.l    #2,lbL000A08
                    beq      space_letter
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW002396,a0
                    move.w   d0,(a0)
                    move.w   d1,2(a0)
                    add.w    #16,(a0)
                    addq.w   #1,2(a0)
                    jsr      wait_sync
                    movem.l  (sp)+,d0-d7/a0-a6
space_letter:       add.l    #9,d0
                    tst.b    (a0)
                    bmi      return
                    bne      next_letter
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    #12,d1
                    addq.l   #1,d1
                    bra      next_letter

return:             rts

letter_buffer:      dcb.l    32,0

wait_sync:          cmp.b    #255,$dff006
                    bne.s    wait_sync
.wait:              cmp.b    #255,$dff006
                    bne.s    .wait
                    rts

lbL003DAE:          dc.l     lbL0052E4,9600,3,$24,$10,$10,$50,$540
                    dc.l     font_pic
                    dc.l     ascii_letters
lbL003DD6:          dc.l     lbL01F0E4,5840,3,$24,$10,$10,$50,$540
                    dc.l     font_pic
                    dc.l     ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ>1234567890.!?:'
lbB003E27:          dc.b     ' '
lbW003E28:          dc.w     0

lbC003E2A:          move.l   text_credits_ptr,a0
                    tst.l    (a0)
                    bne.s    lbC003E7C
                    lea      text_credits_table,a0
                    cmp.l    #text_credits_table,text_credits_ptr
                    bmi.s    lbC003E76
                    cmp.l    #text_credits1,text_credits_ptr
                    bpl.s    lbC003E76
                    move.l   #-1,return_value                   ; run story_exe
                    move.w   #1,lbW001844
                    move.l   a0,text_credits_ptr
                    rts

lbC003E76:          move.l   a0,text_credits_ptr
lbC003E7C:          addq.l   #8,text_credits_ptr
                    clr.l    d0
                    move.l   a0,-(sp)
                    move.l   #$14,d0
                    bsr      rand
                    move.l   d0,d1
                    move.l   (sp)+,a0
                    clr.l    d0
                    cmp.l    #15,d1
                    bmi      lbC003EB6
                    move.l   #4,d0
lbC003EB6:          addq.l   #1,lbL0042DA
                    cmp.l    #16,lbL0042DA
                    bpl.s    lbC003ECA
                    clr.l    d0
lbC003ECA:          move.l   0(a0,d0.l),a0
                    lea      lbL003DAE,a1
                    bsr      display_text
                    move.l   #$15E,d0
lbC003EDE:          tst.w    lbW001844
                    bne      lbC003F52
                    btst     #6,$bfe001
                    beq.s    lbC003F54
                    btst     #7,$bfe001
                    beq      lbC003F54
                    bsr      wait_sync2
                    subq.l   #1,d0
                    bne.s    lbC003EDE
                    lea      lbW002952,a0
                    lea      lbW002962,a1
                    lea      lbW0028B6,a2
                    move.l   #8,d0
                    bsr      lbC001BA2
                    bsr      lbC001B7A
                    lea      lbW002962,a0
                    lea      lbL0042E4,a1
                    lea      lbW0028B6,a2
                    move.l   #8,d0
                    bsr      lbC001BA2
                    bsr      lbC001B7A
                    bsr      lbC003F74
                    bra      lbC003E2A

lbC003F52:          rts

lbC003F54:          move.w   #1,lbW001844
                    rts

wait_sync2:         cmp.b   #255,$dff006
                    bne.s   wait_sync2
.wait:              cmp.b   #0,$dff006
                    bne.s   .wait
                    rts

lbC003F74:          lea      lbL0061E4,a0
                    bsr      wait_blitter
                    move.l   #$1000000,$dff040
                    clr.w    $dff066
                    move.l   #3,d0
lbC003F94:          move.l   a0,$dff054
                    move.w   #(144*64)+20,$dff058
                    bsr      wait_blitter
                    add.l    #(240*40),a0
                    subq.l   #1,d0
                    bne.s    lbC003F94
                    rts

wait_blitter:       
                    WAIT_BLIT
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
                    movem.l  seed,d0/d1
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
                    beq.s    .nop
                    bsr.s    get_rnd_number
                    clr.w    d0
                    swap     d0
                    divu     d2,d0
                    clr.w    d0
                    swap     d0
.nop:               rts

seed:               dcb.l    2,0
lbL0042DA:          dc.l     0
share_credits:      dc.l     0
lbL0042E4:          dcb.l    $10,0

                    incdir   "src/menu/gfx/"
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
