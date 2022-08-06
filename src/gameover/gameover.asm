                    section  gameover,code_c
start:
                    tst.w    lbW000C06
                    bne.s    lbC000010
                    move.w   #$4000,$dff09a
lbC000010:          lea      lbL000C0E,a0
                    lea      lbL005C0E,a1
                    lea      iff_animation,a2
                    lea      lbW000BE4(pc),a3
                    moveq    #$28,d0
                    move.l   #$100,d1
                    bsr      lbC000992
                    bsr      lbC0008C4
                    moveq    #0,d7
                    lea      copper_palette,a0
                    lea      palette,a1
                    move.l   #4,d0
                    jsr      lbC000378
lbC000050:          addq.l   #1,lbL000C0A
                    cmp.l    #$25,lbL000C0A
                    beq      lbC0000D8
                    lea      lbW000BE4(pc),a0
                    bsr      lbC000A10
                    tst.w    d0
                    bne.s    lbC0000D8
                    bsr      lbC00012E
                    bsr      lbC0008C4
                    movem.l  d0-d7/a0-a6,-(sp)
                    tst.w    lbW0006CA
                    bne.s    lbC000092
                    move.w   #2,lbW0006C6
                    jsr      lbC0003F4
lbC000092:          movem.l  (sp)+,d0-d7/a0-a6
                    btst     #6,$bfe001
                    beq      lbC000100
                    btst     #7,$bfe001
                    beq.s    lbC000100
                    lea      lbW000BE4(pc),a0
                    bsr      lbC000A10
                    tst.w    d0
                    bne.s    lbC0000D8
                    bsr      lbC00012E
                    bsr      lbC0008BA
                    bra      lbC000050

lbC0000D8:          bsr      lbC0008C4
                    move.l   #$96,d0
lbC0000E2:          bsr      lbC000118
                    subq.l   #1,d0
                    beq      lbC000100
                    btst     #7,$bfe001
                    beq.s    lbC000100
                    btst     #6,$bfe001
                    bne.s    lbC0000E2
lbC000100:          jsr      lbC00014E
                    tst.w    lbW000C06
                    bne.s    lbC000116
                    move.w   #$C000,$dff09a
lbC000116:          rts

lbC000118:          cmp.b    #255,$dff006
                    bne.s    lbC000118
lbC000122:          cmp.b    #44,$dff006
                    bne.s    lbC000122
                    rts

lbC00012E:          cmp.b    #255,$dff006
                    bne.s    lbC00012E
lbC000138:          cmp.b    #254,$dff006
                    bne.s    lbC000138
lbC000142:          cmp.b    #44,$dff006
                    bne.s    lbC000142
                    rts

lbC00014E:          lea      copper_palette,a0
                    lea      lbL000182,a1
                    move.l   #4,d0
                    move.w   #1,lbW0006C6
                    jsr      lbC000506
lbC00016E:          bsr      lbC000118
                    jsr      fade_palette
                    tst.w    lbW0006CA
                    beq.s    lbC00016E
                    rts

lbL000182:          dcb.l    16,0
palette:            dc.w     0,$A99,$766,$333

lbC000378:          move.w   #2,lbW0006C4
                    lea      lbL0007F8,a4
                    move.l   #48,d2
lbC00038C:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC00038C
                    move.l   d0,d7
                    move.l   a1,a2
                    clr.l    d6
                    lea      lbL000738,a3
lbC0003A0:          move.w   (a2),d6
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
                    bne      lbC0003A0
                    move.l   d1,d4
                    subq.l   #2,a0
                    subq.l   #2,a1
                    move.w   d0,lbW0006CC
                    move.l   a0,lbL0006D2
                    move.l   a1,lbL0006CE
                    clr.w    lbW0006CA
                    rts

lbC0003F4:          cmp.w    #2,lbW0006C4
                    bne      return
                    tst.w    lbW0006CA
                    bne      return
                    add.w    #1,lbW0006C8
                    move.w   lbW0006C8,d0
                    cmp.w    lbW0006C6,d0
                    bmi      return
                    clr.w    lbW0006C8
                    move.l   lbL0006D2,a0
                    move.l   lbL0006CE,a1
                    clr.l    d0
                    move.w   lbW0006CC,d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      lbL000738,a2
                    lea      lbL0007F8,a3
                    move.l   d6,d7
                    move.l   d0,d1
lbC000452:          addq.l   #4,a0
                    addq.l   #2,a1
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F00,d2
                    and.w    #$F00,d3
                    cmp.w    d2,d3
                    beq      lbC00047A
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC00047A:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq      lbC0004AC
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC0004AC:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #15,d2
                    and.w    #15,d3
                    cmp.w    d2,d3
                    beq      lbC0004DE
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC0004DE:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC000452
                    cmp.l    d6,d7
                    bne      lbC000504
                    move.w   #1,lbW0006CA
                    clr.w    lbW0006C4
lbC000504:          rts

lbC000506:          move.w   #3,lbW0006C4
                    lea      lbL0007F8,a4
                    move.l   #$30,d2
lbC00051A:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC00051A
                    move.l   d0,d7
                    move.l   a0,a2
                    add.l    #2,a2
                    clr.l    d6
                    lea      lbL000738,a3
lbC000534:          move.w   (a2),d6
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
                    move.w   (a2),d6
                    add.l    #4,a2
                    lsl.w    #8,d6
                    and.w    #$F00,d6
                    divu     #$F,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    subq.w   #1,d7
                    bne      lbC000534
                    lea      lbL0007F8,a3
                    move.l   a0,a2
                    add.l    #2,a2
                    move.l   d0,d4
lbC00057E:          move.w   (a2),d7
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
                    bne      lbC00057E
                    lea      lbL000738,a2
                    lea      lbL0007F8,a3
                    move.l   d1,d4
                    sub.l    #2,a0
                    move.w   d0,lbW0006CC
                    move.l   a0,lbL0006D2
                    clr.w    lbW0006CA
                    rts

fade_palette:       cmp.w    #3,lbW0006C4
                    bne      return
                    tst.w    lbW0006CA
                    bne      return
                    add.w    #1,lbW0006C8
                    move.w   lbW0006C8,d0
                    cmp.w    lbW0006C6,d0
                    bmi      return
                    clr.w    lbW0006C8
                    clr.l    d0
                    move.w   lbW0006CC,d0
                    move.l   lbL0006D2,a0
                    move.l   d0,d1
                    clr.l    d7
                    lea      lbL000738,a2
                    lea      lbL0007F8,a3
lbC000624:          addq.l   #4,a0
                    move.w   (a0),d2
                    and.w    #$F00,d2
                    tst.w    d2
                    beq      lbC000644
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000644:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F0,d2
                    tst.w    d2
                    beq      lbC000670
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000670:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F,d2
                    tst.w    d2
                    beq      lbC00069C
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.l    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC00069C:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC000624
                    tst.l    d7
                    bne      lbC0006C2
                    move.w   #1,lbW0006CA
                    clr.w    lbW0006C4
lbC0006C2:          rts

lbW0006C4:          dc.w     0
lbW0006C6:          dc.w     $19
lbW0006C8:          dc.w     0
lbW0006CA:          dc.w     0
lbW0006CC:          dc.w     0
lbL0006CE:          dc.l     0
lbL0006D2:          dc.l     0
lbL0006D6:          dcb.l    $18,0

return:             rts

lbL000738:          dcb.l    48,0
lbL0007F8:          dcb.l    48,0

lbC0008BA:          lea      lbL000C0E,a1
                    bra      lbC0008CA

lbC0008C4:          lea      lbL005C0E,a1
lbC0008CA:          lea      copperlist_main(pc),a0
                    lea      copper_bitplanes(pc),a2
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    addq.l   #8,a2
                    add.w    #10240,a1
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    addq.l   #8,a2
                    add.w    #10240,a1
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    addq.l   #8,a2
                    add.w    #10240,a1
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    addq.l   #8,a2
                    add.w    #10240,a1
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    move.l   a0,$dff080
                    rts

copperlist_main:    dc.w    $100,$2200
                    dc.w    $8E,$2C81,$90,$2CC1
                    dc.w    $92,$38,$94,$D0
                    dc.w    $108,0,$10A,0
                    dc.w    $102,0,$96,$20
copper_bitplanes:                    
                    dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $E8,0,$EA,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F0,0,$F2,0
copper_palette:     dc.w    $180,0,$182,0,$184,0,$186,0
                    dc.w    $FFFF,$FFFE

lbC000992:          movem.l  d0-d7/a0-a6,-(sp)
                    move.l   a3,a6
                    movem.l  d0/d1/a0-a2,0(a6)
                    clr.b    $19(a6)
                    clr.l    $1E(a6)
                    move.l   (a2)+,d0
                    cmp.l    #'FORM',d0
                    bne.s    lbC0009F8
                    addq.l   #4,a2
                    move.l   (a2)+,d0
                    cmp.l    #'ANIM',d0
                    bne.s    lbC0009F8
                    move.l   a2,a0
                    move.l   8(a6),a1
                    move.l   0(a6),d0
                    move.l   4(a6),d1
                    bsr      lbC000B1E
                    move.l   a0,$1A(a6)
                    move.l   12(a6),a1
                    move.l   8(a6),a0
                    move.l   0(a6),d0
                    moveq    #0,d1
                    move.b   $18(a6),d1
                    mulu     d1,d0
                    move.l   4(a6),d1
                    mulu     d1,d0
                    subq.l   #1,d0
                    lsr.l    #2,d0
lbC0009F0:          move.l   (a0)+,(a1)+
                    dbra     d0,lbC0009F0
                    bra.s    lbC000A0A

lbC0009F8:          move.w   #$F00,$dff180
                    btst     #6,$bfe001
                    bne.s    lbC0009F8
lbC000A0A:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC000A10:          movem.l  d1-d7/a0-a6,-(sp)
                    move.l   a0,a6
                    move.l   $1A(a6),d0
                    addq.l   #1,d0
                    and.w    #$FFFE,d0
                    move.l   d0,a5
                    move.l   (a5)+,d0
                    cmp.l    #'FORM',d0
                    bne      lbC000B0E
                    addq.l   #4,a5
                    move.l   (a5)+,d0
                    cmp.l    #'ILBM',d0
                    bne      lbC000B0E
lbC000A3C:          move.l   (a5)+,d0
                    cmp.l    #'ANHD',d0
                    beq.s    lbC000A54
                    cmp.l    #'DLTA',d0
                    beq.s    lbC000A6C
                    move.l   (a5)+,d0
                    add.l    d0,a5
                    bra.s    lbC000A3C

lbC000A54:          addq.l   #4,a5
                    move.b   (a5)+,d0
                    cmp.b    #5,d0
                    bne      lbC000B0E
                    add.w    #$13,a5
                    move.l   (a5)+,d7
                    add.w    #$10,a5
                    bra.s    lbC000A3C

lbC000A6C:          move.l   (a5)+,d4
                    move.l   a5,a3
                    add.l    d4,a3
                    move.l   a5,a4
                    move.l   0(a6),d4
                    move.b   $18(a6),d5
                    tst.b    $19(a6)
                    beq.s    lbC000A88
                    move.l   8(a6),a1
                    bra.s    lbC000A8C

lbC000A88:          move.l   12(a6),a1
lbC000A8C:          move.w   $14(a6),d6
                    move.l   a1,a2
                    move.l   (a5)+,d0
                    lea      0(a4,d0.l),a0
lbC000A98:          move.b   (a0)+,d3
                    beq.s    lbC000ACE
lbC000A9C:          moveq    #0,d0
                    move.b   (a0)+,d0
                    bmi.s    lbC000ABC
                    beq.s    lbC000AAA
                    mulu     d4,d0
                    add.w    d0,a1
                    bra.s    lbC000ACA

lbC000AAA:          moveq    #0,d0
                    move.b   (a0)+,d0
                    move.b   (a0)+,d1
                    subq.w   #1,d0
lbC000AB2:          move.b   d1,(a1)
                    add.w    d4,a1
                    dbra     d0,lbC000AB2
                    bra.s    lbC000ACA

lbC000ABC:          and.w    #$7F,d0
                    subq.w   #1,d0
lbC000AC2:          move.b   (a0)+,(a1)
                    add.w    d4,a1
                    dbra     d0,lbC000AC2
lbC000ACA:          subq.b   #1,d3
                    bne.s    lbC000A9C
lbC000ACE:          addq.w   #1,a2
                    move.l   a2,a1
                    subq.w   #1,d6
                    bne.s    lbC000A98
                    sub.l    0(a6),a2
                    move.l   0(a6),d0
                    move.l   4(a6),d1
                    mulu     d1,d0
                    add.l    d0,a2
                    move.l   a2,a1
                    subq.b   #1,d5
                    bne.s    lbC000A8C
                    move.l   a3,d0
                    addq.l   #1,d0
                    and.l    #$FFFFFFFE,d0
                    move.l   d0,a3
                    move.l   a3,$1A(a6)
                    not.b    $19(a6)
                    tst.l    $1E(a6)
                    bne.s    lbC000B0A
                    move.l   a3,$1E(a6)
lbC000B0A:          moveq    #0,d0
                    bra.s    lbC000B10

lbC000B0E:          moveq    #-1,d0
lbC000B10:          movem.l  (sp)+,d1-d7/a0-a6
                    rts

lbC000B1E:          movem.l  d0-d7/a1-a6,-(sp)
                    move.l   d0,d6
                    move.l   d1,d7
                    move.l   (a0)+,d0
                    cmp.l    #'FORM',d0
                    bne      lbC000B9A
                    addq.l   #4,a0
                    move.l   (a0)+,d0
                    cmp.l    #'ILBM',d0
                    bne      lbC000B9A
lbC000B40:          move.l   (a0)+,d0
                    cmp.l    #'BMHD',d0
                    beq.s    lbC000B58
                    cmp.l    #'BODY',d0
                    beq.s    lbC000B78
                    move.l   (a0)+,d0
                    add.l    d0,a0
                    bra.s    lbC000B40

lbC000B58:          addq.l   #4,a0
                    move.w   (a0)+,d4
                    lsr.w    #3,d4
                    move.w   d4,$14(a6)
                    move.w   (a0)+,d5
                    move.w   d5,$16(a6)
                    addq.l   #4,a0
                    move.b   (a0)+,d3
                    move.b   d3,$18(a6)
                    add.w    #11,a0
                    bra      lbC000B40

lbC000B78:          addq.l   #4,a0
                    move.l   a1,a5
                    move.w   d6,d2
                    mulu     d7,d2
lbC000B80:          move.l   a5,a1
                    swap     d5
                    move.b   d3,d5
lbC000B86:          bsr      lbC000BB2
                    add.w    d2,a1
                    subq.b   #1,d5
                    bne.s    lbC000B86
                    swap     d5
                    add.w    d6,a5
                    subq.w   #1,d5
                    bne.s    lbC000B80
                    bra.s    lbC000BAC

lbC000B9A:          move.w   #$F00,$dff180
                    btst     #6,$bfe001
                    bne.s    lbC000B9A
lbC000BAC:          movem.l  (sp)+,d0-d7/a1-a6
                    rts

lbC000BB2:          movem.l  d2/a1,-(sp)
                    move.w   d4,d2
                    subq.w   #1,d2
lbC000BBA:          tst.w    d2
                    bmi.s    lbC000BDE
                    move.b   (a0)+,d0
                    bmi.s    lbC000BCE
                    ext.w    d0
lbC000BC4:          move.b   (a0)+,(a1)+
                    subq.w   #1,d2
                    dbra     d0,lbC000BC4
                    bra.s    lbC000BBA

lbC000BCE:          ext.w    d0
                    neg.w    d0
                    move.b   (a0)+,d1
lbC000BD4:          move.b   d1,(a1)+
                    subq.w   #1,d2
                    dbra     d0,lbC000BD4
                    bra.s    lbC000BBA

lbC000BDE:          movem.l  (sp)+,d2/a1
                    rts

lbW000BE4:          dcb.w    $11,0
lbW000C06:          dcb.w    2,1
lbL000C0A:          dc.l     0
lbL000C0E:          dcb.b    20480,0
lbL005C0E:          dcb.b    20480,0
iff_animation:      incbin  "gameover/anim/gameover.anim"

                    end
