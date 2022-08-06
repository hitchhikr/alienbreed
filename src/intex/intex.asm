; note: all prices are multiplied by 50

WAIT_BLIT           MACRO
wait\@:             btst     #14,$dff002
                    bne.s    wait\@
                    ENDM

                    section  intex,code_c
start:
                    move.l   d0,lbL00715E
                    move.l   d1,lbL007162
                    move.l   d2,owned_weapons
                    move.l   a0,lbL00717E
                    move.l   a0,cur_credits
                    move.l   a1,lbL007172
                    move.l   a2,lbL007176
                    move.l   a3,lbL007166
                    move.l   a4,lbL00716A
                    move.l   a5,lbL007156
                    move.l   a6,lbL00715A
                    bsr      lbC0017A6
                    bsr      lbC001BA6
                    bsr      lbC0011BA
                    lea      lbW0071B4,a6
                    move.l   lbL00715A,a5
                    jsr      (a5)
lbC0000AC:          bsr      lbC0019CC
                    lea      lbW002730,a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
                    bsr      lbC0015DA
lbC0000C4:          move.l   lbL007172,a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #$100,d0
                    bne.s    lbC0000FE
                    tst.l    lbL007188
                    beq.s    lbC0000FE
                    subq.l   #1,lbL007188
                    bsr      lbC0015DA
                    jsr      lbC001F7E
lbC0000FE:          cmp.w    #1,d0
                    bne.s    lbC000120
                    cmp.l    #7,lbL007188
                    beq.s    lbC000120
                    addq.l   #1,lbL007188
                    bsr      lbC0015DA
                    jsr      lbC001F7E
lbC000120:          jsr      lbC001F96
                    move.l   #7,d0
                    move.l   lbL007172,a0
                    cmp.l    #$dff00a,a0
                    bne.s    lbC000140
                    move.l   #6,d0
lbC000140:          btst     d0,$bfe001
                    bne      lbC0000C4
                    jsr      lbC000BD4
                    cmp.l    #4,lbL007188
                    beq      enter_holocode
lbC00015E:          cmp.l    #7,lbL007188
                    beq      lbC0001E4
                    cmp.l    #0,lbL007188
                    bne.s    lbC000190
                    move.l   #$980000,lbW00710C
                    bsr      lbC00159E
                    move.l   #$FFFFFFFE,lbW00710C
lbC000190:          cmp.l    #1,lbL007188
                    bne.s    lbC0001A0
                    bsr      scr_tools_supplies
lbC0001A0:          cmp.l    #2,lbL007188
                    bne.s    lbC0001B0
                    bsr      lbC001392
lbC0001B0:          cmp.l    #3,lbL007188
                    bne.s    lbC0001C0
                    bsr      lbC001146
lbC0001C0:          cmp.l    #5,lbL007188
                    bne.s    lbC0001D0
                    bsr      lbC000518
lbC0001D0:          cmp.l    #6,lbL007188
                    bne.s    lbC0001E0
                    bsr      lbC0003CC
lbC0001E0:          bra      lbC0000AC

lbC0001E4:          bsr      lbC0019CC
                    lea      lbW00268E,a0
                    lea      lbL00248E,a1
                    jsr      lbC002214
                    move.l   #1,d0
                    bsr      lbC001364
                    move.l   #6,d0
                    bsr      lbC0012BA
                    move.l   #copperlist_blank,$dff080
                    bsr      lbC001BCA
                    move.l   #copperlist_blank,$dff080
                    lea      cur_holocode,a0
                    move.l   lbL007190,d2
                    move.l   owned_weapons,d0
                    move.l   purchased_supplies,d1
                    rts

                    dc.b     'HERWQERQWERQWERQWERQWERQWERWQERWQERÿ'
lbW0002D6:          dc.w     $10,$E4
lbW0002DA:          dcb.w    $1D,$2020
                    dcb.w    $3F,$FFFF
                    dcb.w    $11,$FFFF
                    dc.w     $FF79

lbC0003B6:          cmp.b    #255,$dff006
                    bne.s    lbC0003B6
lbC0003C0:          cmp.b    #0,$dff006
                    bne.s    lbC0003C0
                    rts

lbC0003CC:          btst     #6,$bfe001
                    beq      lbC0003CC
                    btst     #7,$bfe001
                    beq      lbC0003CC
                    jsr      lbC0003B6
                    jsr      lbC0003B6
                    jsr      lbC0003B6
                    jsr      lbC0003B6
                    clr.l    lbL007188
                    move.l   #$960020,lbW006FD4
                    move.l   #lbL0004C8,lbL0004C4
lbC000416:          bsr      lbC0019CC
                    move.l   lbL0004C4,a0
                    move.l   (a0),a0
                    lea      lbL00248E,a1
                    move.w   #1,lbW0012B8
                    clr.w    lbW0012B6
                    bsr      lbC002214
                    clr.w    lbW0012B8
                    move.w   lbW0012B6,d7
                    clr.w    lbW0012B6
                    tst.w    d7
                    bne      lbC0004B8
lbC000452:          btst     #7,$bfe001
                    beq.s    lbC0004B8
                    btst     #6,$bfe001
                    beq.s    lbC0004B8
                    move.l   lbL007172,a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #3,d0
                    beq.s    lbC00047E
                    cmp.w    #$300,d0
                    bne.s    lbC000452
lbC00047E:          cmp.w    #3,d0
                    bne.s    lbC000498
                    move.l   lbL0004C4,a0
                    tst.l    4(a0)
                    beq      lbC000452
                    addq.l   #4,lbL0004C4
lbC000498:          cmp.w    #$300,d0
                    bne.s    lbC0004B4
                    move.l   lbL0004C4,a0
                    cmp.l    #lbL0004C8,a0
                    beq      lbC000452
                    subq.l   #4,lbL0004C4
lbC0004B4:          bra      lbC000416

lbC0004B8:          move.l   #$968020,lbW006FD4
                    rts

lbL0004C4:          dc.l     lbL0004C8
lbL0004C8:          dc.l     lbW002A38
                    dc.l     lbW002CF6
                    dc.l     lbW002FB4
                    dc.l     lbW003272
                    dc.l     lbW003530
                    dc.l     lbW0037EE
                    dc.l     lbW003AAC
                    dc.l     lbW003D6A
                    dc.l     lbW004028
                    dc.l     lbW0042E6
                    dc.l     lbW0045A4
                    dc.l     lbW004862
                    dc.l     lbW004B20
                    dc.l     lbW004DDE
                    dc.l     lbW00509C
                    dc.l     lbW00535A
                    dc.l     lbW005618
                    dc.l     lbW0058D6
                    dc.l     lbW005B94,0

lbC000518:          bsr      lbC0019CC
                    move.l   owned_weapons,d0
                    move.l   #2,d1
                    move.l   #6,d2
                    lea      NO_MSG,a0
lbC000534:          btst     d1,d0
                    beq.s    lbC00054A
                    move.b   #'Y',(a0)
                    move.b   #'E',1(a0)
                    move.b   #'S',2(a0)
                    bra.s    lbC00055A

lbC00054A:          move.b   #' ',(a0)
                    move.b   #'N',1(a0)
                    move.b   #'O',2(a0)
lbC00055A:          addq.w   #1,d1
                    add.l    #$29,a0
                    subq.w   #1,d2
                    bne.s    lbC000534
                    move.l   lbL00717E,a0
                    move.l   4(a0),d0
                    move.l   d0,lbL001CFA
                    bsr      lbC001E3E
                    lea      lbL001CFE,a0
                    lea      ascii_MSG0,a1
                    bsr      lbC000A8E
                    move.l   lbL00717E,a0
                    move.l   8(a0),d0
                    move.l   d0,lbL001CFA
                    bsr      lbC001E3E
                    lea      lbL001CFE,a0
                    lea      BULLETS_MSG,a1
                    bsr      lbC000A8E
                    move.l   lbL00717E,a0
                    move.l   (a0),d0
                    divu     #$32,d0
                    move.l   d0,12(a0)
                    move.l   d0,lbL001CFA
                    bsr      lbC001E3E
                    lea      lbL001CFE,a0
                    lea      CR_MSG,a1
                    bsr      lbC000A8E
                    move.l   lbL00717E,a0
                    move.l   $10(a0),d0
                    move.l   d0,lbL001CFA
                    bsr      lbC001E3E
                    lea      lbL001CFE,a0
                    lea      ascii_MSG1,a1
                    bsr      lbC000A8E
                    move.l   lbL00717E,a0
                    move.l   $14(a0),d0
                    move.l   d0,lbL001CFA
                    bsr      lbC001E3E
                    lea      lbL001CFE,a0
                    lea      CLIP_MSG,a1
                    bsr      lbC000A8E
                    move.l   lbL00717E,a0
                    move.l   $18(a0),d0
                    lea      LOWAVERAGEGOO_MSG,a0
                    lea      ascii_MSG2,a1
                    cmp.w    #$15,d0
                    bls.s    lbC00064E
                    add.l    #8,a0
                    cmp.w    #$2A,d0
                    bls.s    lbC00064E
                    add.l    #8,a0
lbC00064E:          move.l   #8,d0
lbC000654:          move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    lbC000654
                    move.l   lbL00717E,a0
                    move.l   $1C(a0),d0
                    lea      ascii_MSG3,a1
                    lea      lbL0006DC,a0
lbC000670:          cmp.l    #-1,(a0)
                    beq.s    lbC000684
                    cmp.l    (a0),d0
                    beq      lbC000684
                    addq.l   #8,a0
                    bra      lbC000670

lbC000684:          add.l    #4,a0
                    move.l   (a0),a0
                    move.l   #14,d0
lbC000692:          move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    lbC000692
                    lea      lbW00077E,a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
                    move.l   #$960020,lbW006FD4
                    jsr      lbC001190
                    move.l   #$968020,lbW006FD4
                    rts

LOWAVERAGEGOO_MSG:  dc.b     'LOW     AVERAGE GOOD    '
lbL0006DC:          dc.l     1
                    dc.l     MACHINEGUN_MSG,2
                    dc.l     TWINFIRE_MSG,3
                    dc.l     FLAMEARC_MSG,4
                    dc.l     PLASMAGUN_MSG,5
                    dc.l     FLAMETHROWER_MSG,6
                    dc.l     SIDEWINDERS_MSG,7
                    dc.l     LAZER_MSG,$FFFFFFFF
                    dc.l     MACHINEGUN_MSG
MACHINEGUN_MSG:     dc.b     'MACHINE GUN   '
TWINFIRE_MSG:       dc.b     'TWIN FIRE     '
FLAMEARC_MSG:       dc.b     'FLAME ARC     '
PLASMAGUN_MSG:      dc.b     'PLASMA GUN    '
FLAMETHROWER_MSG:   dc.b     'FLAME THROWER '
SIDEWINDERS_MSG:    dc.b     'SIDEWINDERS   '
LAZER_MSG:          dc.b     'LAZER         '
lbW00077E:          dc.w     0,16
                    dc.b     '           INTEX STATISTICS             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '     ALIENS KILLED:  '
ascii_MSG0:         dc.b     '                   ',0
                    dc.b     '       SHOTS FIRED:  '
BULLETS_MSG:        dc.b     '       BULLETS     ',0
                    dc.b     '      CREDIT LIMIT:  '
CR_MSG:             dc.b     '       CR          ',0
                    dc.b     '      DOORS OPENED:  '
ascii_MSG1:         dc.b     '                   ',0
                    dc.b     '        AMMO PACKS:  '
CLIP_MSG:           dc.b     '       CLIP        ',0
                    dc.b     '      ENERGY STATE:  '
ascii_MSG2:         dc.b     '                   ',0
                    dc.b     '    CURRENT WEAPON:  '
ascii_MSG3:         dc.b     '                   ',0
                    dc.b     ' WEAPONS AVAILABLE:                     ',0
                    dc.b     '                                        ',0
                    dc.b     '       MACHINE GUN.....     YES         ',0
                    dc.b     '       TWIN FIRE.......     '
NO_MSG:             dc.b     ' NO         ',0
                    dc.b     '       FLAME ARC.......      NO         ',0
                    dc.b     '       PLASMA GUN......      NO         ',0
                    dc.b     '       FLAME THROWER...      NO         ',0
                    dc.b     '       SIDEWINDERS.....      NO         ',0
                    dc.b     '       LAZER...........      NO         '
                    dc.b     $FF,$79

lbC000A8E:          move.l   #6,d0
                    tst.b    (a0)
                    beq      lbC000AA8
lbC000A9A:          tst.b    (a0)
                    beq      lbC000AA8
                    move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    lbC000A9A
                    rts

lbC000AA8:          move.b   #' ',(a1)+
                    subq.w   #1,d0
                    bpl.s    lbC000AA8
                    rts

lbW000AB2:          dc.w     $80,$78
cur_holocode:       dc.b     '00000'
                    dc.b     $FF
lbW000ABC:          dc.w     0

enter_holocode:     bsr      lbC0019CC
                    lea      lbW0028EC,a0
                    lea      lbL00248E,a1
                    jsr      lbC002214
                    bsr      lbC000BB4
lbC000AD8:          move.l   lbL007172,a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    move.w   lbW000ABC(pc),d1
                    lea      cur_holocode(pc),a1
                    cmp.w    #$100,d0
                    bne.s    lbC000B12
                    move.b   0(a1,d1.w),d2
                    cmp.b    #'9',d2
                    bne.s    lbC000B02
                    move.b   #'/',0(a1,d1.w)
lbC000B02:          addq.b   #1,0(a1,d1.w)
                    bsr      lbC000B98
                    jsr      lbC001F7E
                    bra.s    lbC000B70

lbC000B12:          cmp.w    #1,d0
                    bne.s    lbC000B38
                    move.b   0(a1,d1.w),d2
                    cmp.b    #$30,d2
                    bne.s    lbC000B28
                    move.b   #':',0(a1,d1.w)
lbC000B28:          subq.b   #1,0(a1,d1.w)
                    bsr      lbC000B98
                    jsr      lbC001F7E
                    bra.s    lbC000B70

lbC000B38:          cmp.w    #$300,d0
                    bne.s    lbC000B54
                    tst.w    d1
                    beq.s    lbC000B70
                    subq.w   #1,lbW000ABC
                    bsr      lbC000BB4
                    jsr      lbC001F7E
                    bra.s    lbC000B70

lbC000B54:          cmp.w    #3,d0
                    bne.s    lbC000B70
                    cmp.w    #4,d1
                    beq.s    lbC000B70
                    addq.w   #1,lbW000ABC
                    bsr      lbC000BB4
                    jsr      lbC001F7E
lbC000B70:          bsr      lbC001F96
                    moveq    #7,d0
                    move.l   lbL007172,a0
                    cmp.l    #$dff00a,a0
                    bne.s    lbC000B8A
                    move.l   #6,d0
lbC000B8A:          btst     d0,$bfe001
                    bne      lbC000AD8
                    bra      lbC00015E

lbC000B98:          bsr      lbC001960
                    lea      lbW000AB2,a0
                    lea      lbL00248E,a1
                    jsr      lbC002214
                    bsr      lbC000BB4
                    rts

lbC000BB4:          lea      lbW0020CC,a0
                    move.w   lbW000ABC,d0
                    lsl.w    #3,d0
                    add.w    #$80,d0
                    move.w   d0,(a0)
                    move.w   #$84,2(a0)
                    bsr      lbC001FE6
                    rts

lbC000BD4:          movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #14,d0
                    move.l   #0,d2
                    move.l   lbL007156,a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC000BF2:          movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #48,d0
                    move.l   #0,d2
                    move.l   lbL007156,a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

scr_tools_supplies: bsr      lbC0019CC
                    bsr      lbC001112
                    lea      text_tool_supplies,a0
                    lea      lbL00248E,a1
                    jsr      lbC002214
                    clr.l    lbL000DC4
lbC000C4E:          move.l   lbL007172,a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #$100,d0
                    bne.s    lbC000C78
                    tst.l    lbL000DC4
                    beq.s    lbC000C78
                    subq.l   #1,lbL000DC4
                    bsr      lbC0010EE
                    jsr      lbC001F7E
lbC000C78:          cmp.w    #1,d0
                    bne.s    lbC000C9A
                    cmp.l    #5,lbL000DC4
                    beq.s    lbC000C9A
                    addq.l   #1,lbL000DC4
                    bsr      lbC0010EE
                    jsr      lbC001F7E
lbC000C9A:          bsr      lbC0010EE
                    bsr      lbC001F96
                    move.l   #7,d0
                    move.l   lbL007172,a0
                    cmp.l    #$dff00a,a0
                    bne.s    lbC000CBC
                    move.l   #6,d0
lbC000CBC:          btst     d0,$bfe001
                    bne      lbC000C4E
                    jsr      lbC000BD4
                    move.l   lbL000DC4,d0
                    cmp.l    #5,d0
                    beq      lbC00180E
                    move.l   purchased_supplies,d1
                    btst     d0,d1
                    bne      lbC000C4E
                    lea      supplies_prices_list,a0
                    move.l   d0,d1
                    ext.l    d1
                    add.l    d1,d1
                    add.l    d1,d1
                    move.l   (a0,d1.w),d1
                    move.l   cur_credits,a5
                    move.l   (a5),d2
                    cmp.l    d1,d2
                    bge.s    enough_money
                    lea      text_insufficient_funds,a0
                    lea      lbL00248E,a1
                    jsr      lbC002214
                    move.l   #1,d0
                    bsr      lbC001364
                    bsr      lbC0018F4
                    bra      lbC000C4E

enough_money:       sub.l    d1,(a5)
                    cmp.w    #2,d0                      ; energy injection
                    bne.s    lbC000D52
                    add.l    #32,player_health
                    cmp.l    #64,player_health
                    bmi.s    lbC000D52
                    move.l   #64,player_health
lbC000D52:          movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC000DF6
                    movem.l  (sp)+,d0-d7/a0-a6
                    clr.l    d1
                    bset     d0,d1
                    or.l     d1,purchased_supplies
                    add.l    d0,d0
                    lea      REMOTELOCATIO_MSG,a0
                    mulu     #41,d0
                    add.l    #29,d0
                    add.l    d0,a0
                    move.b   #' ',(a0)+
                    move.b   #'B',(a0)+
                    move.b   #'O',(a0)+
                    move.b   #'U',(a0)+
                    move.b   #'G',(a0)+
                    move.b   #'H',(a0)+
                    move.b   #'T',(a0)+
                    move.b   #'.',(a0)+
                    bra      scr_tools_supplies

supplies_prices_list:
                    dc.l     500000
                    dc.l     100000
                    dc.l     250000
                    dc.l     250000
                    dc.l     1500000
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
lbL000DC4:          dc.l     0
purchased_supplies: dc.l     0
text_insufficient_funds:
                    dc.w     0,$E8
                    dc.b     '                  INSUFFICIENT FUNDS'
                    dc.b     $FF,$20

lbC000DF6:          move.l   lbL00715A,a5
                    cmp.w    #0,d0
                    bne.s    lbC000E0A
                    lea      lbW0071C8,a6
                    jmp      (a5)

lbC000E0A:          cmp.w    #1,d0
                    bne.s    lbC000E18
                    lea      lbW0071D2,a6
                    jmp      (a5)

lbC000E18:          cmp.w    #2,d0
                    bne.s    lbC000E26
                    lea      lbW00720E,a6
                    jmp      (a5)

lbC000E26:          cmp.w    #3,d0
                    bne.s    lbC000E34
                    lea      lbW0071FA,a6
                    jmp      (a5)

lbC000E34:          cmp.w    #4,d0
                    bne.s    lbC000E42
                    lea      lbW0071E6,a6
                    jmp      (a5)

lbC000E42:          rts

text_tool_supplies: dc.w     0,$24
                    dc.b     '          INTEX TOOL SUPPLIES           ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
REMOTELOCATIO_MSG:  dc.b     '    REMOTE LOCATION SCANNER  10000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '    AMMO CHARGE               2000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '    HIGH ENERGY INJECTION     5000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '    KEY PACK                  5000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '    ADDITIONAL LIFE          30000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '                  EXIT                  ',0
                    dc.b     '                                       ',0
                    dc.b     '             CREDIT LIMIT: '
lbB0010C9:          dcb.b    33,0
                    dcb.b    4,$FF

lbC0010EE:          lea      lbW0020CC,a0
                    move.l   lbL000DC4,d0
                    mulu     #$18,d0
                    add.l    #$48,d0
                    move.w   d0,2(a0)
                    move.w   #$10,(a0)
                    bsr      lbC001FE6
                    rts

lbC001112:          move.l   cur_credits,a0
                    move.l   (a0),d0
                    divu     #$32,d0
                    move.l   d0,lbL001CFA
                    bsr      lbC001C14
                    lea      lbL001CFE,a0
                    lea      lbB0010C9,a1
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    rts

lbC001146:          bsr      lbC0019CC
                    move.l   lbL007166,a0
                    lea      lbL00248E,a1
                    jsr      lbC002214
                    jsr      lbC001190
                    rts

lbC001164:          move.l   #7,d1
                    move.l   lbL007172,a0
                    cmp.l    #$dff00a,a0
                    bne.s    lbC00117E
                    move.l   #6,d1
lbC00117E:          clr.l    d0
                    btst     d1,$bfe001
                    bne.s    lbC00118E
                    move.l   #-1,d0
lbC00118E:          rts

lbC001190:          move.l   #7,d0
                    move.l   lbL007172,a0
                    cmp.l    #$dff00a,a0
                    bne.s    lbC0011AA
                    move.l   #6,d0
lbC0011AA:          btst     d0,$bfe001
                    bne.s    lbC0011AA
                    jsr      lbC000BD4
                    rts

lbC0011BA:          move.b   $bfd800,d1
                    cmp.b    #$7F,d1
                    bpl      lbC00122A
                    move.l   #10,d0
                    bsr      lbC0012BA
                    tst.w    lbW0012B6
                    bne      lbC00129E
                    move.l   #1,d0
                    bsr      lbC001364
                    tst.w    lbW0012B6
                    bne      lbC00129E
                    move.l   #$19,d0
                    bsr      lbC0012BA
                    tst.w    lbW0012B6
                    bne      lbC00129E
                    move.l   #1,d0
                    bsr      lbC001364
                    tst.w    lbW0012B6
                    bne      lbC00129E
                    move.l   #6,d0
                    bsr      lbC0012BA
                    tst.w    lbW0012B6
                    bne.s    lbC00129E
lbC00122A:          move.w   #1,lbW0012B8
                    lea      lbW002558,a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
                    tst.w    lbW0012B6
                    bne.s    lbC00129E
                    jsr      lbC001164
                    tst.l    d0
                    bmi      lbC00129E
                    move.l   #1,d0
                    bsr      lbC001342
                    lea      lbW0025A4,a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
                    tst.w    lbW0012B6
                    bne.s    lbC00129E
                    jsr      lbC001164
                    tst.l    d0
                    bmi      lbC00129E
                    move.l   #2,d0
                    bsr      lbC001342
                    lea      lbW002640,a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
lbC00129E:          clr.w    lbW0012B8
                    clr.w    lbW0012B6
                    move.l   #1,d0
                    bsr      lbC0019CC
                    rts

lbW0012B6:          dc.w     0
lbW0012B8:          dc.w     0

lbC0012BA:          movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #$4A,d0
                    move.l   #0,d2
                    move.l   lbL007156,a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
lbC0012D6:          btst     #7,$bfe001
                    beq.s    lbC001336
                    btst     #6,$bfe001
                    beq.s    lbC001336
                    bsr      lbC001F96
                    move.b   $bfd800,d1
                    ext.w    d1
                    move.b   d1,lbW006FBA
                    neg.w    d1
                    move.b   d1,lbW006FB6
                    subq.l   #1,d0
                    bne.s    lbC0012D6
lbC001308:          move.w   #$2C81,lbW006FB6
                    move.w   #$2CC1,lbW006FBA
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #$4B,d0
                    move.l   #0,d2
                    move.l   lbL007156,a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC001336:          move.w   #1,lbW0012B6
                    bra      lbC001308

lbC001342:          mulu     #$32,d0
                    move.l   d0,d7
lbC001348:          jsr      lbC001164
                    tst.l    d0
                    bmi.s    lbC00135E
                    jsr      lbC001F96
                    subq.l   #1,d7
                    bne.s    lbC001348
                    rts

lbC00135E:          addq.l   #4,sp
                    bra      lbC00129E

lbC001364:          mulu     #$32,d0
lbC001368:          btst     #7,$bfe001
                    beq.s    lbC001388
                    btst     #6,$bfe001
                    beq.s    lbC001388
                    jsr      lbC001F96
                    subq.l   #1,d0
                    bne.s    lbC001368
                    rts

lbC001388:          move.w   #1,lbW0012B6
                    rts

lbC001392:          bsr      lbC0019CC
                    bsr      lbC00141A
                    lea      lbW0024E2,a0
                    lea      lbL00248E,a1
                    jsr      lbC002214
                    move.l   lbL00715E,d0
                    move.l   lbL007162,d1
                    lsr.l    #3,d0
                    lsr.l    #3,d1
                    add.l    #$1E,d0
                    add.l    #$1C,d1
                    move.w   d0,lbW0020CC
                    move.w   d1,lbW0020CE
                    lea      lbW0020CC,a0
                    bsr      lbC001FE6
lbC0013DE:          jsr      lbC001F96
                    btst     #7,$bfe001
                    beq.s    lbC0013F8
                    btst     #6,$bfe001
                    bne.s    lbC0013DE
lbC0013F8:          lea      lbL027102,a0
                    move.l   #$2800,d0
                    bsr      lbC001596
                    bsr      lbC0019CC
                    rts

lbL00140E:          dc.l     $F8
lbL001412:          dc.l     $CA
lbL001416:          dc.l     $61D8

lbC00141A:          lea      lbL027102,a5
                    move.l   lbL00716A,a0
                    add.l    lbL001416,a0
                    move.l   lbL00140E,d0
                    move.l   lbL001412,d1
                    move.l   d0,d7
lbC00143A:          move.w   -(a0),d2
                    and.w    #$3F,d2
                    tst.w    d2
                    beq.s    lbC0014AE
                    cmp.w    #3,d2
                    beq      lbC0014BA
                    cmp.w    #1,d2
                    bhi.s    lbC0014AE
                    move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    add.l    #$20,d4
                    add.l    #$20,d5
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    bset     d2,0(a4,d5.w)
                    bset     d2,40(a4,d5.w)
                    move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    add.l    #$21,d4
                    add.l    #$20,d5
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    bset     d2,0(a4,d5.w)
                    bset     d2,40(a4,d5.w)
lbC0014AE:          subq.w   #2,d0
                    bne.s    lbC00143A
                    move.l   d7,d0
                    subq.w   #2,d1
                    bne.s    lbC00143A
                    rts

lbC0014BA:          move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    sub.l    #$A000,a4
                    add.l    #$20,d4
                    add.l    #$20,d5
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    sub.l    #$A000,a4
                    add.l    #$21,d4
                    add.l    #$20,d5
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    bra      lbC0014AE

lbC001596:          clr.b    (a0)+
                    subq.l   #1,d0
                    bne.s    lbC001596
                    rts

lbC00159E:          bsr      lbC0019CC
                    bsr      lbC001BE0
                    lea      lbW005E52,a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
                    bsr      lbC001F6C
lbC0015BA:          bsr      lbC001F96
                    bsr      lbC001EF4
                    tst.l    d0
                    beq.s    lbC0015CA
                    bsr      lbC001F6C
lbC0015CA:          bsr      lbC00162A
                    move.l   lbL007176,a0
                    bra      lbC0015BA

lbC0015D8:          rts

lbC0015DA:          lea      lbW0020CC,a0
                    move.l   lbL007188,d0
                    mulu     #12,d0
                    add.l    #$44,d0
                    move.w   d0,2(a0)
                    move.w   #$30,(a0)
                    bsr      lbC001FE6
                    rts

lbC0015FE:          lea      lbW0020CC,a0
                    move.l   lbL007182,d0
                    not.l    d0
                    and.l    #1,d0
                    mulu     #12,d0
                    add.l    #$E3,d0
                    move.w   d0,2(a0)
                    move.w   #$80,(a0)
                    bsr      lbC001FE6
                    rts

lbC00162A:          move.l   lbL007172,a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #1,d0
                    bne.s    lbC001642
                    clr.l    lbL007182
lbC001642:          cmp.w    #$100,d0
                    bne.s    lbC001652
                    move.l   #1,lbL007182
lbC001652:          bsr      lbC0015FE
                    bsr      lbC001164
                    tst.l    d0
                    beq      lbC00180E
                    tst.l    lbL007182
                    bne      lbC001670
                    addq.l   #4,sp
                    bra      lbC0015D8

lbC001670:          move.l   owned_weapons,d1
                    move.l   lbL00716E,d0
                    addq.l   #2,d0
                    clr.l    d2
                    bset     d0,d2
                    and.w    d2,d1
                    tst.b    d1
                    bne      lbC001766
                    move.l   lbL00716E,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    lea      lbL00174A(pc),a0
                    move.l   0(a0,d0.l),d0
                    move.l   cur_credits,a0
                    move.l   (a0),d1
                    divu     #50,d1
                    cmp.l    d0,d1
                    bmi      lbC001786
                    move.l   cur_credits,a0
                    move.l   (a0),d1
                    mulu     #50,d0
                    sub.l    d0,d1
                    move.l   d1,(a0)
                    or.l     d2,owned_weapons
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   lbL00715A,a5
                    lea      lbW0071D2,a6
                    jsr      (a5)
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   purchased_supplies,d0
                    or.l     #2,d0
                    move.l   d0,purchased_supplies
                    move.l   #2,d0
                    lea      REMOTELOCATIO_MSG,a0
                    mulu     #41,d0
                    add.l    #29,d0
                    add.l    d0,a0
                    move.b   #' ',(a0)+
                    move.b   #'B',(a0)+
                    move.b   #'O',(a0)+
                    move.b   #'U',(a0)+
                    move.b   #'G',(a0)+
                    move.b   #'H',(a0)+
                    move.b   #'T',(a0)+
                    move.b   #'.',(a0)+
                    bsr      lbC0019CC
                    lea      lbW0026B0,a0
                    lea      lbL00248E,a1
                    jsr      lbC002214
                    move.l   #1,d0
                    bsr      lbC001364
                    addq.l   #4,sp
                    bra      lbC00159E

lbL00174A:          dc.l    10000
                    dc.l    24000
                    dc.l    35000
                    dc.l    48000
                    dc.l    60000
                    dc.l    75000
                    dc.l    0

lbC001766:          lea      lbW0026E4,a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
                    move.l   #2,d0
                    bsr      lbC001364
                    addq.l   #4,sp
                    bra      lbC00159E

lbC001786:          lea      lbW00270A,a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
                    move.l   #2,d0
                    bsr      lbC001364
                    addq.l   #4,sp
                    bra      lbC00159E

lbC0017A6:          move.l   #copperlist_blank,$dff080
                    lea      lbW007058,a0
                    move.l   #bitplanes,d0
                    move.l   #5,d1
lbC0017D2:          move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(256*40),d0
                    addq.l   #8,a0
                    subq.b   #1,d1
                    bne.s    lbC0017D2
                    lea      background_pic+(40*256*4),a0
                    lea      copper_palette,a1
                    move.l   #16,d0
lbC0017FC:          move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #1,d0
                    bne.s    lbC0017FC
                    move.w   #$2D1,lbW007016
                    rts

lbC00180E:          rts

lbC001810:          addq.w   #1,lbW001852
                    cmp.w    #2,lbW001852
                    bmi      lbC00180E
                    clr.w    lbW001852
                    move.l   lbL001854,a0
                    tst.w    (a0)
                    bpl.s    lbC00183E
                    lea      lbW001858,a0
                    move.l   a0,lbL001854
lbC00183E:          addq.l   #2,lbL001854
                    move.w   (a0),lbW007056
                    move.w   (a0),lbW00713E
                    rts

lbW001852:          dc.w     0
lbL001854:          dc.l     lbW001858
lbW001858:          dc.w     $40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0
                    dc.w     $E0,$D0,$C0,$B0,$A0,$90,$80,$70,$60,$50,$40
                    dc.w     -1

lbC001888:          move.w   #$8400,$dff096
                    bsr      wait_blitter
                    move.l   #$9F00000,$dff040
                    move.l   #-1,$dff044
                    clr.l    $dff064
                    lea      background_pic+(82*40),a0
                    lea      lbL01DDD2,a1
                    move.l   #4,d0
lbC0018C0:          move.l   a0,$dff050
                    move.l   a1,$dff054
                    move.w   #(138*64)+20,$dff058
                    bsr      wait_blitter
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    sub.b    #1,d0
                    bne.s    lbC0018C0
                    move.w   #$400,$dff096
                    rts

lbC0018F4:          move.w   #$8400,$dff096
                    bsr      wait_blitter
                    move.l   #$9F00000,$dff040
                    move.l   #-1,$dff044
                    clr.l    $dff064
                    lea      background_pic+(228*40),a0
                    lea      lbL01F4A2,a1
                    move.l   #4,d0
lbC00192C:          move.l   a0,$dff050
                    move.l   a1,$dff054
                    move.w   #(28*64)+20,$dff058
                    bsr      wait_blitter
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    sub.b    #1,d0
                    bne.s    lbC00192C
                    move.w   #$400,$dff096
                    rts

lbC001960:          move.w   #$8400,$dff096
                    bsr      wait_blitter
                    move.l   #$9F00000,$dff040
                    move.l   #-1,$dff044
                    clr.l    $dff064
                    lea      background_pic+(108*40),a0
                    lea      lbL01E1E2,a1
                    move.l   #4,d0
lbC001998:          move.l   a0,$dff050
                    move.l   a1,$dff054
                    move.w   #(28*64)+20,$dff058
                    bsr      wait_blitter
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    sub.b    #1,d0
                    bne.s    lbC001998
                    move.w   #1024,$dff096
                    rts

lbC0019CC:          move.w   #$8400,$dff096
                    bsr      wait_blitter
                    move.l   #$9F00000,$dff040
                    move.l   #-1,$dff044
                    clr.l    $dff064
                    move.l   #background_pic,$dff050
                    move.l   #bitplanes,$dff054
                    move.l   #4,d0
lbC001A0C:          move.w   #(256*64)+20,$dff058
                    bsr      wait_blitter
                    sub.b    #1,d0
                    bne.s    lbC001A0C
                    move.w   #$400,$dff096
                    rts

wait_blitter:       
                    WAIT_BLIT
                    rts

lbC001A7C:          lea      lbL007222,a0
                    move.l   #2560,d0
lbC001A88:          clr.b    (a0)+
                    subq.w   #1,d0
                    bne.s    lbC001A88
                    lea      lbL001B8E(pc),a0
                    move.l   lbL00716E,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a0,d0.l),a0
                    lea      lbL01E37C,a1
                    bsr      wait_blitter
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #-1,$dff044
                    move.l   #$dfc0000,$dff040
                    clr.w    $dff066
                    clr.w    $dff062
                    move.w   #$14,$dff064
                    move.l   #4,d0
lbC001ADC:          move.l   a0,$dff050
                    move.l   #lbL007222,$dff054
                    move.l   #lbL007222,$dff04c
                    move.w   #(88*64)+10,$dff058
                    bsr      wait_blitter
                    add.l    #10560,a0
                    subq.w   #1,d0
                    bne.s    lbC001ADC
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.w   #$8400,$dff096
                    move.l   #-1,$dff044
                    move.l   #$fe20000,$dff040
                    move.w   #20,$dff066
                    move.w   #20,$dff064
                    move.w   #20,$dff060
                    clr.w    $dff062
                    moveq    #4,d0
lbC001B4C:          move.l   a0,$dff050
                    move.l   a1,$dff054
                    move.l   a1,$dff048
                    move.l   #lbL007222,$dff04c
                    move.w   #(88*64)+10,$dff058
                    bsr      wait_blitter
                    add.l    #(264*40),a0
                    add.l    #(256*40),a1
                    subq.b   #1,d0
                    bne.s    lbC001B4C
                    move.w   #$400,$dff096
                    rts

lbL001B8E:          dc.l     weapons_pic+(176*40)
                    dc.l     weapons_pic
                    dc.l     weapons_pic+20
                    dc.l     weapons_pic+(176*40)+20
                    dc.l     weapons_pic+(88*40)+20
                    dc.l     weapons_pic+(88*40)

lbC001BA6:          move.l   #copperlist_main,$dff080
                    bsr      lbC0019CC
                    lea      lbW0020CC,a0
                    bsr      lbC001FB0
                    lea      lbW0020CC,a0
                    bsr      lbC001FE6
                    rts

lbC001BCA:          lea      lbW0020CC,a0
                    move.w   #$FFF0,(a0)
                    move.w   #$FFF0,2(a0)
                    bsr      lbC001FE6
                    rts

lbC001BE0:          move.l   cur_credits,a0
                    move.l   (a0),d0
                    divu     #50,d0
                    move.l   d0,lbL001CFA
                    bsr      lbC001C14
                    lea      lbL001CFE,a0
                    lea      lbL006154,a1
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    rts

lbC001C14:          lea      lbL001CFE,a2
                    move.l   #32,d7
lbC001C20:          clr.b    (a2)+
                    subq.w   #1,d7
                    bne.s    lbC001C20
                    move.l   lbL001CFA,d0
                    lea      lbL001CFE,a0
                    lea      decimal_table,a1
                    cmp.l    #$3B9AC9FF,d0
                    bhi      lbC001CA2
                    clr.l    lbL001CF6
                    move.l   #$30,d2
lbC001C4E:          cmp.l    #0,(a1)
                    beq      lbC001CBC
                    move.l   (a1),d1
                    sub.l    d1,d0
                    add.b    #1,d2
                    cmp.l    #0,d0
                    beq      lbC001C76
                    bgt      lbC001C4E
                    add.l    d1,d0
                    sub.l    #1,d2
lbC001C76:          add.l    #4,a1
                    tst.b    lbL001CF6
                    bne      lbC001C8E
                    cmp.b    #$30,d2
                    beq      lbC001C98
lbC001C8E:          move.b   d2,(a0)+
                    move.b   #1,lbL001CF6
lbC001C98:          move.l   #$30,d2
                    bra      lbC001C4E

lbC001CA2:          move.l   #'9999',(a0)
                    move.l   #'9999',4(a0)
                    move.b   #'9',8(a0)
                    add.l    #9,a0
lbC001CBC:          move.b   #' ',(a0)+
                    move.b   #'C',(a0)+
                    move.b   #'R',(a0)+
                    move.b   #$FF,(a0)
                    rts

decimal_table:      dc.l    100000000
                    dc.l    10000000
                    dc.l    1000000
                    dc.l    100000
                    dc.l    10000
                    dc.l    1000
                    dc.l    100
                    dc.l    10
                    dc.l    1
                    dc.l    0
lbL001CF6:          dc.l    0
lbL001CFA:          dc.l    0
lbL001CFE:          dcb.l   $3F,0
                    dcb.l   $11,0

lbC001E3E:          lea      lbL001CFE,a2
                    move.l   #$20,d7
lbC001E4A:          clr.b    (a2)+
                    subq.w   #1,d7
                    bne.s    lbC001E4A
                    move.l   lbL001CFA,d0
                    lea      lbL001CFE,a0
                    lea      decimal_table,a1
                    cmp.l    #$3B9AC9FF,d0
                    bhi      lbC001ECC
                    clr.l    lbL001CF6
                    move.l   #$30,d2
lbC001E78:          cmp.l    #0,(a1)
                    beq      lbC001EE6
                    move.l   (a1),d1
                    sub.l    d1,d0
                    add.b    #1,d2
                    cmp.l    #0,d0
                    beq      lbC001EA0
                    bgt      lbC001E78
                    add.l    d1,d0
                    sub.l    #1,d2
lbC001EA0:          add.l    #4,a1
                    tst.b    lbL001CF6
                    bne      lbC001EB8
                    cmp.b    #$30,d2
                    beq      lbC001EC2
lbC001EB8:          move.b   d2,(a0)+
                    move.b   #1,lbL001CF6
lbC001EC2:          move.l   #$30,d2
                    bra      lbC001E78

lbC001ECC:          move.l   #'9999',(a0)
                    move.l   #'9999',4(a0)
                    move.b   #'9',8(a0)
                    add.l    #9,a0
lbC001EE6:          tst.b    (a0)
                    beq      lbC00180E
                    move.b   #0,(a0)+
                    bra      lbC001EE6

lbC001EF4:          move.l   lbL007172,a0
                    move.w   (a0),d1
                    clr.l    d0
                    and.w    #$303,d1
                    cmp.w    #$300,d1
                    bne.s    lbC001F26
                    move.l   #1,d0
                    subq.l   #1,lbL00716E
                    tst.l    lbL00716E
                    bpl.s    lbC001F26
                    move.l   #5,lbL00716E
lbC001F26:          cmp.w    #3,d1
                    bne.s    lbC001F4A
                    move.l   #1,d0
                    addq.l   #1,lbL00716E
                    cmp.l    #6,lbL00716E
                    bmi.s    lbC001F4A
                    clr.l    lbL00716E
lbC001F4A:          rts

lbC001F4C:          move.l   lbL00716E,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    lea      lbL006178,a0
                    move.l   0(a0,d0.l),a0
                    lea      lbL00248E,a1
                    bsr      lbC002214
                    rts

lbC001F6C:          bsr      lbC001888
                    bsr      lbC001A7C
                    bsr      lbC001F4C
                    bsr      lbC001F7E
                    rts

lbC001F7E:          move.l   lbL007172,a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    tst.w    d0
                    bne.s    lbC001F7E
                    jsr      lbC000BD4
                    rts

lbC001F96:          cmp.b    #255,$dff006
                    bne.s    lbC001F96
lbC001FA0:          cmp.b    #44,$dff006
                    bne.s    lbC001FA0
                    bsr      lbC001810
                    rts

lbC001FB0:          tst.l    $10(a0)
                    bne.s    lbC001FD2
                    move.l   12(a0),d0
lbC001FBA:          move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

lbC001FD2:          move.l   $10(a0),a1
                    move.l   a1,$14(a0)
                    move.w   6(a1),$18(a0)
                    move.l   (a1),d0
                    bra      lbC001FBA

lbC001FE6:          move.l   8(a0),a1
                    tst.l    $10(a0)
                    bne      lbC00207E
lbC001FF2:          and.w    #$80,14(a1)
                    move.w   0(a0),d0
                    add.w    #$80,d0
                    btst     #0,d0
                    beq.s    lbC00200C
                    or.w     #1,14(a1)
lbC00200C:          lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    add.w    #$2C,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #$100,d1
                    bmi.s    lbC002030
                    sub.w    #$FF,d1
                    or.b     #2,15(a1)
lbC002030:          move.b   d1,14(a1)
                    cmp.w    #$100,d0
                    bmi.s    lbC002044
                    sub.w    #$FF,d0
                    or.b     #4,15(a1)
lbC002044:          move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.s    lbC00207C
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
lbC00207C:          rts

lbC00207E:          subq.w   #1,$18(a0)
                    bpl      lbC001FF2
                    addq.l   #8,$14(a0)
lbC00208A:          move.l   $14(a0),a2
                    move.l   (a2),d0
                    tst.l    d0
                    bmi.s    lbC0020A8
                    move.w   6(a2),$18(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      lbC001FF2

lbC0020A8:          move.l   $10(a0),$14(a0)
                    bra.s    lbC00208A

;                    move.l   a1,$10(a0)
;                    move.l   a1,$14(a0)
;                    clr.w    $18(a0)
;                    rts

;                    move.l   8(a0),a0
;                    clr.w    14(a0)
;                    clr.w    10(a0)
;                    rts

lbW0020CC:          dc.w     $FFF0
lbW0020CE:          dc.w     $FFF0,11,0
                    dc.l     lbW0070FC
                    dc.l     lbW0020E8
                    dcb.w    6,0
lbW0020E8:          dcb.w    $16,$FF00
                    dcb.w    $3F,0
                    dcb.w    $3F,0
                    dcb.w    2,0

lbC002214:          lea      $dff000,a6
                    clr.l    d0
                    clr.l    d1
                    move.w   (a0)+,d0
                    move.w   (a0)+,d1
                    move.l   d0,d7
lbC002224:          tst.w    lbW0012B8
                    beq.s    lbC002252
                    move.w   #1,lbW0012B6
                    btst     #7,$bfe001
                    beq      lbC0023FA
                    btst     #6,$bfe001
                    beq      lbC0023FA
                    clr.w    lbW0012B6
lbC002252:          move.l   0(a1),a2
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
                    beq      lbC0023E0
                    move.l   $24(a1),a3
lbC002284:          cmp.b    (a3)+,d2
                    beq.s    lbC002292
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.s    lbC002284
                    bra      lbC0023E0

lbC002292:          move.l   $20(a1),a3
                    add.l    d4,a3
                    WAIT_BLIT
                    move.l   #$1000000,$40(a6)
                    move.l   #lbL00240E,$54(a6)
                    move.w   #2,$66(a6)
                    move.w   #(16*64)+1,$58(a6)
                    WAIT_BLIT
                    move.l   8(a1),d2
                    move.l   $1C(a1),d5
                    move.l   #lbL00240E,d4
                    move.l   #-1,$44(a6)
                    move.l   #$dfc0000,$40(a6)
                    move.l   $18(a1),d6
                    addq.w   #2,d6
                    move.w   d6,$64(a6)
                    move.w   #2,$66(a6)
                    move.w   #2,$62(a6)
                    move.l   a3,d6
lbC0022FE:          
                    WAIT_BLIT
                    move.l   d6,$50(a6)
                    move.l   d4,$4C(a6)
                    move.l   d4,$54(a6)
                    move.w   #(16*64)+1,$58(a6)
                    add.l    d5,d6
                    subq.w   #1,d2
                    bne.s    lbC0022FE
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
                    move.l   #lbL00240E,d4
                    move.w   $16(a1),d6
                    lsl.w    #6,d6
                    add.w    #2,d6
lbC002372:          
                    WAIT_BLIT
                    move.l   d4,$4C(a6)
                    move.l   a3,$50(a6)
                    move.l   a2,$48(a6)
                    move.l   a2,$54(a6)
                    move.w   d6,$58(a6)
                    add.l    d2,a2
                    add.l    d3,a3
                    subq.b   #1,d5
                    bne.s    lbC002372
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW0020CC,a0
                    move.w   d0,(a0)
                    move.w   d1,2(a0)
                    subq.w   #1,2(a0)
                    bsr      lbC001FE6
                    add.w    #1,lbW00240C
                    cmp.w    #3,lbW00240C
                    bne      lbC0023CE
                    clr.w    lbW00240C
                    bsr      lbC000BF2
lbC0023CE:          not.w    lbW00240A
                    beq.s    lbC0023DC
                    jsr      lbC001F96
lbC0023DC:          movem.l  (sp)+,d0-d7/a0-a6
lbC0023E0:          add.l    $10(a1),d0
                    tst.b    (a0)
                    bmi      lbC0023FA
                    bne      lbC002224
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    $14(a1),d1
                    bra      lbC002224

lbC0023FA:          lea      lbW0020CC,a0
                    add.w    #12,(a0)
                    bsr      lbC001FE6
                    rts

lbW00240A:          dc.w     0
lbW00240C:          dc.w     0
lbL00240E:          dcb.l    $20,0
lbL00248E:          dc.l     bitplanes,$2800,4,$24,8,12,$50,$3F0
                    dc.l     font_pic
                    dc.l     ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ>1234567890.!?: ',0
                    dc.b     'A'
lbW0024E2:          dc.w     0,12
                    dc.b     '        INTEX MAPSYSTEM V2.0          ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     '  YOU ARE LOCATED AT CURSORS POSITION!'
                    dc.b     $FF
lbW002558:          dc.w     0,$30
                    dc.b     'INTEX NETWORK CONNECT: CODE ABF01DCC61',0
                    dc.b     'CONNECTING.....................'
                    dc.b     $FF,$41
lbW0025A4:          dc.w     0,$54
                    dc.b     'INTEX NETWORK SYSTEM V10.1',0
                    dc.b     '2.5G RAM:         OK',0
                    dc.b     'EXTERNAL DEVICE:  OK',0
                    dc.b     'SYSTEM V1.32 CS:  OK',0
                    dc.b     'VIDEODISPLAY:     CCC2.A2',0
                    dc.b     'TEXTUPDATE ACCCELERATOR INSTALLED.'
                    dc.b     $FF,$61
lbW002640:          dc.w     0,$A8
                    dc.b     'EXECUTING DOS 6.0',0
                    dc.b     'SYSTEM DOWNLOADING NETWORKDATA..... OK',0
                    dc.b     'INTEX EXECUTED!'
                    dc.b     $FF,0
lbW00268E:          dc.w     0,$40
                    dc.b     '  DISCONNECTING..............'
                    dc.b     $FF
lbW0026B0:          dc.w     0,$3E
                    dc.b     '     CREDITS DEBITED.',$ff,0,0
                    dc.b     0
                    dc.b     '@     CREDITS DEBITED.'
                    dc.b     $FF
lbW0026E4:          dc.w     0,$D3
                    dc.b     '     YOU ALREADY OWN THAT WEAPON.'
                    dc.b     $FF
lbW00270A:          dc.w     0,$D3
                    dc.b     '              INSUFFUCIENT FUNDS.'
                    dc.b     $FF
lbW002730:          dc.w     0,$20
                    dc.b     '            INTEX MAIN MENU             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '         INTEX WEAPON SUPPLIES          ',0
                    dc.b     '          INTEX TOOL SUPPLIES           ',0
                    dc.b     '          INTEX RADAR SERVICE           ',0
                    dc.b     '           MISSION OBJECTIVE            ',0
                    dc.b     '            ENTER HOLOCODE              ',0
                    dc.b     '            GAME STATISTICS             ',0
                    dc.b     '               INFO BASE                ',0
                    dc.b     '          ABORT INTEX NETWORK'
                    dc.b     $FF
lbW0028EC:          dc.w     0,$60
                    dc.b     '            ENTER HOLOCODE              ',0
                    dc.b     '                                        ',0
                    dc.b     '                00000                   ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' UP AND DOWN INCREASES/DECREASES DIGIT  ',0
                    dc.b     '      LEFT AND RIGHT MOVES CURSOR       ',0
                    dc.b     '        PRESS BUTTON WHEN READY         '
                    dc.b     $FF
lbW002A38:          dc.w     0,$18
                    dc.b     '      I N T E X  I N F O  B A S E       ',0
                    dc.b     '                                        ',0
                    dc.b     ' ON LINE HELP AND INFORMATION DATABASE. ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '    INTEX ARE PLEASED TO SUPPLY ALL     ',0
                    dc.b     '   STATION OFFICERS ACCESS TO CURRENT   ',0
                    dc.b     '         ARCHIVED INFORMATION           ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '  CONTAINED DATA FILES DO NOT CONFLICT  ',0
                    dc.b     '  WITH CURRENT HQ SECURITY REGULATIONS  ',0
                    dc.b     '  ALL RECORDS CONSIDERED LOW PRIORITY.  ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  FIRST PAGE...          ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$BB
lbW002CF6:          dc.w     0,$18
                    dc.b     ' INTEX SPACE RESEARCH STATION ISRC 4.   ',0
                    dc.b     '                                        ',0
                    dc.b     ' THIS STATION IS A BASE FOR PREPATORY   ',0
                    dc.b     ' SCIENCE AND SECURITY EXPERIMENTS.      ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' STATION MANNING LEVEL...      175      ',0
                    dc.b     ' STATION DECKS...........        9      ',0
                    dc.b     ' STATION SUB LEVELS......        2      ',0
                    dc.b     ' STATION SECURITY........     HIGH      ',0
                    dc.b     ' CURRENT STATUS..........  UNKNOWN      ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$BB
lbW002FB4:          dc.w     0,$18
                    dc.b     ' INTEX TRANSPORTATION HOLO CODES..      ',0
                    dc.b     '                                        ',0
                    dc.b     ' AT LEAST FIVE HOLO CODES EXIST THAT    ',0
                    dc.b     ' WILL TRANSPORT A TEAM OF TWO OFFICERS  ',0
                    dc.b     ' TO A SPECIFIC DECK OF THE STATION      ',0
                    dc.b     ' WITHIN AN INSTANT. THESE WERE PART OF  ',0
                    dc.b     ' THE HOLOGENICS PROGRAM BEING DEVELOPED ',0
                    dc.b     ' BY RESEARCHERS ON THIS SPACE STATION.  ',0
                    dc.b     ' ONCE YOU KNOW THE HOLO CODES, YOU      ',0
                    dc.b     ' CAN ENTER THEM AT THE MAIN MENU OF     ',0
                    dc.b     ' ANY INTEX TERMINAL AND THEN EXIT..     ',0
                    dc.b     ' WHEREBY YOU WILL BE QUICKLY            ',0
                    dc.b     ' TRANSPORTED TO YOUR DESTINATION.       ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$20
lbW003272:          dc.w     0,$18
                    dc.b     ' STATION FACILITIES INVENTORY..         ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' A SECTION NOW FOLLOWS EXPLAINING SOME  ',0
                    dc.b     ' OF THE VARIOUS FACILITIES FOUND IN     ',0
                    dc.b     ' THIS MODEL OF SPACE RESEARCH STATION.  ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$20
lbW003530:          dc.w     0,$18
                    dc.b     ' SLIDE DOOR.                            ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY....... REQUIRES PASS KEY      ',0
                    dc.b     '                 CAN BE SHOT OPEN       ',0
                    dc.b     '                                        ',0
                    dc.b     ' SLIDE DOORS LITTER THE ENTIRE STATION  ',0
                    dc.b     ' AND A LONG LINE MAY GUARD THE ENTRANCE ',0
                    dc.b     ' TO A HIGH SECURITY ZONE. ALTHOUGH THEY ',0
                    dc.b     ' CAN BE BLASTED OPEN, USING A LARGE     ',0
                    dc.b     ' AMOUNT OF AMMO, THEY ARE BEST OPENED   ',0
                    dc.b     ' USING A PASS KEY, ESPECIALLY IF YOU    ',0
                    dc.b     ' ARE IN A HURRY.                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$73
lbW0037EE:          dc.w     0,$18
                    dc.b     ' FIRE DOOR.                             ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY....... ONCE SHUT, STAYS SHUT. ',0
                    dc.b     '                 SHOOT GREEN SWITCHES   ',0
                    dc.b     '                 TO CLOSE FIRE DOOR.    ',0
                    dc.b     '                                        ',0
                    dc.b     ' FIRE DOORS BLOCK STATION TRAFFIC ON    ',0
                    dc.b     ' A GIVEN DECK. FIRST DEVISED AS A       ',0
                    dc.b     ' SAFETY AID, FIRE DOORS SOON BECAME     ',0
                    dc.b     ' MORE OF A BURDEN DUE TO THEIR RATHER   ',0
                    dc.b     ' AWKWARD OPERATION. MANY TEAMS OF       ',0
                    dc.b     ' OFFICERS HAVE BECOME SEPERATED AT      ',0
                    dc.b     ' FIRE DOORS AND INTEX ADVISE CAUTION.   ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$6D
lbW003AAC:          dc.w     0,$18
                    dc.b     ' LASER DOOR.                            ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY....... ALLOWS PASSAGE IN ONE  ',0
                    dc.b     '                 DIRECTION ONLY.        ',0
                    dc.b     '                                        ',0
                    dc.b     ' LASER DOORS ARE LOCATED IN AREAS WHERE ',0
                    dc.b     ' SECURITY DICTATED THAT PASSAGE SHOULD  ',0
                    dc.b     ' ONLY BE ALLOWED IN CERTAIN DIRECTIONS. ',0
                    dc.b     '                                        ',0
                    dc.b     ' ATTEMPTING TO MOVE THROUGH THE DOOR    ',0
                    dc.b     ' IN THE WRONG DIRECTION RESULTS IN A    ',0
                    dc.b     ' LASER CHARGE TO YOUR SPINE. VERY NASTY ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$69
lbW003D6A:          dc.w     0,$18
                    dc.b     ' AIR SHAFTS, DUCTS AND VENTS.           ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY....... VERY LOW               ',0
                    dc.b     '                                        ',0
                    dc.b     ' THE STATION IS LITTERED WITH VARIOUS   ',0
                    dc.b     ' DUCTS AND VENTS WHICH ARE USUALLY USED ',0
                    dc.b     ' FOR THE DUMPING OF STATION WASTE INTO  ',0
                    dc.b     ' DEEP SPACE. BECAUSE OF THIS, WE THINK  ',0
                    dc.b     ' THAT THERE IS NO NEED TO WARN YOU THAT ',0
                    dc.b     ' TRYING TO TRAVEL THROUGH ONE IS INDEED ',0
                    dc.b     ' ILL ADVISED..                          ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$64
lbW004028:          dc.w     0,$18
                    dc.b     ' REFUGE IRIS.                           ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY........ VERY LOW              ',0
                    dc.b     '                                        ',0
                    dc.b     ' LIKE THE VENTS AND SHAFTS, THE REFUGE  ',0
                    dc.b     ' IRIS IS ANOTHER PORTHOLE INTO DEEP     ',0
                    dc.b     ' SPACE WHERE BYPRODUCTS AND WASTE IS    ',0
                    dc.b     ' REGULARLY FED.                         ',0
                    dc.b     '                                        ',0
                    dc.b     ' AVOID ENTERING ANY OPEN IRISES, UNLESS ',0
                    dc.b     ' OF COURSE, YOU WANT A SHORT LIFE.      ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      ÿm'
lbW0042E6:          dc.w     0,$18
                    dc.b     ' ACID VAT.                              ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY........ NOMINAL               ',0
                    dc.b     '                                        ',0
                    dc.b     ' THE SUB FLOOR ACID VATS CONTAIN HIGH   ',0
                    dc.b     ' POWER CYBERPHORIC ACID AND WILL DO     ',0
                    dc.b     ' LARGE AMOUNTS OF DAMAGE TO STANDARD    ',0
                    dc.b     ' ISSUE FEDERATION OUTFITS. AVOID.       ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$20
lbW0045A4:          dc.w     0,$18
                    dc.b     ' REMOTE LOCATION SCANNER.               ',0
                    dc.b     '                                        ',0
                    dc.b     ' THIS HANDY TOOL CAN BE BOUGHT VIA THE  ',0
                    dc.b     ' TOOLS OPTION AT INTEX TERMINAL AND     ',0
                    dc.b     ' SENT VIA A MATTER TRANSLOCATOR UNIT.   ',0
                    dc.b     '                                        ',0
                    dc.b     ' HIGHLY USEFUL, THIS HAND MAP GIVES AN  ',0
                    dc.b     ' OVERVIEW OF THE CURRENT STATION LEVEL  ',0
                    dc.b     ' PROVIDING IT LOCKS ONTO A NEARBY       ',0
                    dc.b     ' INTEX CONSOLE.                         ',0
                    dc.b     ' ALTHOUGH NEVER STANDARD ISSUE, IT IS   ',0
                    dc.b     ' THE NORM FOR ALL OFFICERS ON THIS BASE ',0
                    dc.b     ' TO CARRY SUCH A DEVICE.                ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$20
lbW004862:          dc.w     0,$18
                    dc.b     ' ESCAPE SHUTTLE BAY.                    ',0
                    dc.b     '                                        ',0
                    dc.b     ' LOCATION....... U N K N O W N          ',0
                    dc.b     '                                        ',0
                    dc.b     ' AN ESCAPE SHUTTLE LIES IN WAIT FOR     ',0
                    dc.b     ' UP TO TWO HIGH RANKING OFFICIALS. ITS  ',0
                    dc.b     ' LOCATION HAS BEEN KEPT A CLOSE GUARDED ',0
                    dc.b     ' SECRET AS MANY OF THE CREW HAVE TRIED  ',0
                    dc.b     ' TO ESCAPE THE STATION IN RECENT YEARS, ',0
                    dc.b     ' WHICH IS STRANGE CONSIDERING THAT THE  ',0
                    dc.b     ' PLACE IS FAR FROM A PRISON OR SPECIAL  ',0
                    dc.b     ' UNIT.                                  ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$65
lbW004B20:          dc.w     0,$18
                    dc.b     ' CENTRAL CORE REACTOR.                  ',0
                    dc.b     '                                        ',0
                    dc.b     ' THE KEY TO THE BURNING POWER OF THE    ',0
                    dc.b     ' WHOLE CENTRE, THE CORE PROVIDES ALL    ',0
                    dc.b     ' THE ENERGY REQUIRED FOR THE BASE TO    ',0
                    dc.b     ' OPERATE. IT IS SURROUNDED BY HIGH      ',0
                    dc.b     ' SECURITY AND LOCATED DEEP IN THE HEART ',0
                    dc.b     ' OF THE STATION.                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' DESTRUCTION OF THE CENTRAL CORE WOULD  ',0
                    dc.b     ' RESULT IN SOMEWHAT OF A MELTDOWN, ONE  ',0
                    dc.b     ' MEAN EXPLOSION AND A RATHER LARGE BANG ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$20
lbW004DDE:          dc.w     0,$18
                    dc.b     ' CORE ENERGY REACTORS.                  ',0
                    dc.b     '                                        ',0
                    dc.b     ' THE POWER DECK SUPPLIES AUXILLARY      ',0
                    dc.b     ' POWER GENERATED BY FOUR SOLAR ENERGY   ',0
                    dc.b     ' REACTORS LINKED TO EXTERNAL POWER      ',0
                    dc.b     ' RADIATION EMINATING FROM THE NEARBY    ',0
                    dc.b     ' GAS GIANT GIANOR.                      ',0
                    dc.b     '                                        ',0
                    dc.b     ' THESE REACTORS PROVIDE THE BACK UP     ',0
                    dc.b     ' POWER FOR STATION SUB SYSTEMS.         ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$52
lbW00509C:          dc.w     0,$18
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '           D A T A   E N D S            ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$30
lbW00535A:          dc.w     0,$18
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '       I N T E X  S O F T W A R E       ',0
                    dc.b     '                                        ',0
                    dc.b     '       SYSTEM SOFTWARE RELEASE 12       ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '         SOFTWARE FOR SOFTHEADS         ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$BB
lbW005618:          dc.w     0,$18
                    dc.b     '         SYSTEM SOFTWARE CREDITS        ',0
                    dc.b     '                                        ',0
                    dc.b     ' CODE........  ANDREAS TADIC            ',0
                    dc.b     '               PETER TULEBY             ',0
                    dc.b     '               STEFAN BOBERG            ',0
                    dc.b     ' VISUALS.....  RICO HOLMES              ',0
                    dc.b     ' AUDIO.......  ALLISTER BRIMBLE         ',0
                    dc.b     ' VOCALS......  LYNETTE READE            ',0
                    dc.b     ' MAPPING.....  RICO HOLMES, MARTYN BROWN',0
                    dc.b     ' STORYBOARD..  MARTYN BROWN             ',0
                    dc.b     ' PRODUCER....  MARTYN BROWN             ',0
                    dc.b     ' TESTING.....  ANDY, CRAIG, MICK, KEITH ',0
                    dc.b     '               FRAZZE, KATRINA, TEAM17  ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$BB
lbW0058D6:          dc.w     0,$18
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '          D A T A  R E A L L Y          ',0
                    dc.b     '                                        ',0
                    dc.b     '             D O E S  E N D             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$BB
lbW005B94:          dc.w     0,$18
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '         C O M I N G   S O O N          ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '    W I N D O W S  F O R  I N T E X     ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                  32    ',0
                    dc.b     '     A L I E N  B R E E D  2   C D      ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      LAST PAGE...           ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     $FF,$64
lbW005E52:          dc.w     0,$18
                    dc.b     '         INTEX WEAPON SUPPLIES          ',0
                    dc.b     '                                        ',0
                    dc.b     '   WEAPON SUPPLIES REQUEST:             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' PURCHASE?            YOUR CREDIT LIMIT ',0
                    dc.b     '                        IS: '
lbL006154:          dcb.l    8,0
                    dc.l     -1
lbL006178:          dc.l     lbW006190
                    dc.l     lbW0063D2
                    dc.l     lbW006614
                    dc.l     lbW006856
                    dc.l     lbW006A98
                    dc.l     lbW006CDA
lbW006190:          dc.w     0,$54
                    dc.b     '        BROADHURST DJ TWINFIRE 3LG      ',0
                    dc.b     '               RAPID FIRE               ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 10000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     $FF
lbW0063D2:          dc.w     0,$54
                    dc.b     '             DALTON ARC FLAME           ',0
                    dc.b     '                RAPID FIRE              ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 24000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     $FF
lbW006614:          dc.w     0,$54
                    dc.b     '           ROBINSON PLASMA GUN          ',0
                    dc.b     '               PUMP ACTION              ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 35000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     $FF
lbW006856:          dc.w     0,$54
                    dc.b     '           RYXX FIREBOLT MK22           ',0
                    dc.b     '              FLAMETHROWER              ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 48000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     $FF
lbW006A98:          dc.w     0,$54
                    dc.b     '            STIRLING MULTIMATIC         ',0
                    dc.b     '               TRIPLE BARREL            ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 60000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     $FF
lbW006CDA:          dc.w     0,$54
                    dc.b     '          HIGH IMPACT ASTRO LAZER       ',0
                    dc.b     '                  LAZER                 ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 75000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     $FF

copperlist_blank:   dc.w    $100,$200
                    dc.w    $180,0
                    dc.w    $96,$20
                    dc.w    $FFFF,$FFFE

copperlist_main:    dc.w    $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0
                    dc.w    $14A,0,$128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0
                    dc.w    $158,0,$15A,0,$130,0,$132,0,$160,0,$162,0,$134,0
                    dc.w    $136,0,$168,0,$16A,0,$138,0,$13A,0,$170,0,$172,0
                    dc.w    $13C,0,$13E,0,$178,0,$17A,0,$180,0
                    dc.w    $100,$5200
                    dc.w    $8E
lbW006FB6:          dc.w    $2C81,$90
lbW006FBA:          dc.w    $2CC1
                    dc.w    $92,$38,$94,$D0
                    dc.w    $108,0,$10A,0
                    dc.w    $104,$24
                    dc.w    $102,0
lbW006FD4:          dc.w    $96,$8020
                    dc.w    $180
copper_palette:     dc.w    0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0,$190,0,$192,0,$194
                    dc.w    0,$196,0,$198,0,$19A,0,$19C,0,$19E
lbW007016:          dc.w    0,$1A0,$555,$1A2,$565,$1A4,$575,$1A6,$585,$1A8
                    dc.w    $595,$1AA,$5A5,$1AC,$5B5,$1AE,$5C5,$1B0,$5D5,$1B2
                    dc.w    $5E5,$1B4,$5F5,$1B6,$5F5,$1B8,$5F5,$1BA,$5F5,$1BC
                    dc.w    $FFF,$1BE
lbW007056:          dc.w    0
lbW007058:          dc.w    $E0,0,$E2,0,$E4,0,$E6,0,$E8,0,$EA,0,$EC,0,$EE,0
                    dc.w    $F0,0,$F2,0,$F4,0,$F6,0
                    dc.w    $3001,$FF00,$120,0,$122,0
                    dc.w    $140,0,$142,0,$124,0,$126,0,$148,0,$14A,0,$128,0
                    dc.w    $12A,0,$150,0,$152,0,$12C,0,$12E,0,$158,0,$15A,0
                    dc.w    $130,0,$132,0,$160,0,$162,0,$134,0,$136,0,$168,0
                    dc.w    $16A,0,$138,0,$13A,0,$170,0,$172,0
lbW0070FC:          dc.w    $13C,0,$13E,0,$178,0,$17A,0
lbW00710C:          dc.w    $FFFF,$FFFE
                    dc.w    $2C01,$FF00,$19E,$D0
                    dc.w    $5C01,$FF00,$19E,$2F2
                    dc.w    $7401,$FF00,$19E,$6F6
                    dc.w    $8A01,$FF00,$19E,$4F4
                    dc.w    $9601,$FF00,$19E,$1F1
                    dc.w    $9A01,$FF00,$19E
lbW00713E:          dc.w    0
                    dc.w    $FF01,$FF00,$19E,$2F2
                    dc.w    $FFFF,$FFFE

lbL007156:          dc.l     0
lbL00715A:          dc.l     0
lbL00715E:          dc.l     0
lbL007162:          dc.l     0
lbL007166:          dc.l     0
lbL00716A:          dc.l     0
lbL00716E:          dc.l     0
lbL007172:          dc.l     0
lbL007176:          dc.l     0
owned_weapons:      dc.l     0
lbL00717E:          dc.l     0
lbL007182:          dc.l     1
;lbW007186:          dc.w     0
lbL007188:          dc.l     0
cur_credits:        dc.l     0
; credits
; aliens killed
; shots fired
; (not used)
; doors opened
; ammo packs
; currently used weapon
lbL007190:          dc.l    2000000,130,1500,0,100,10
player_health:      dc.l    2
                    dc.l    7
                    dc.l    $2B67

lbW0071B4:          dc.w     1,$34,3
                    dc.l     lbW0071BE
lbW0071BE:          dc.w     $12,$35,3,0,0
lbW0071C8:          dc.w     1,13,3,0,0
lbW0071D2:          dc.w     1,13,3
                    dc.l     lbW0071DC
lbW0071DC:          dc.w     $15,$18,3,0,0
lbW0071E6:          dc.w     1,13,3
                    dc.l     lbW0071F0
lbW0071F0:          dc.w     $15,$1B,3,0,0
lbW0071FA:          dc.w     1,13,3
                    dc.l     lbW007204
lbW007204:          dc.w     $15,$17,3,0,0
lbW00720E:          dc.w     1,13,3
                    dc.l     lbW007218
lbW007218:          dc.w     $15,$49,3,0,0
lbL007222:          dcb.b    2560,0
font_pic:           incbin  "intex/gfx/font_16x504x6.raw"
background_pic:     incbin  "intex/gfx/bkgnd_320x256x4.raw"
weapons_pic:        incbin  "intex/gfx/weapons_264x40x4.raw"

bitplanes:          dcb.b    3280,0
lbL01DDD2:          dcb.b    1040,0
lbL01E1E2:          dcb.b    410,0
lbL01E37C:          dcb.b    4390,0
lbL01F4A2:          dcb.b    31840,0
lbL027102:          dcb.b    20480,0

                    end
