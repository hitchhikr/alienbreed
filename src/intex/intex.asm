; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------
; Note: all prices are multiplied by 50

; -----------------------------------------------------

                    include  "common.inc"

; -----------------------------------------------------

WAIT_BLIT           MACRO
wait\@:             btst     #DMAB_BLITTER,CUSTOM+DMACONR
                    bne.b    wait\@
                    ENDM

; -----------------------------------------------------

                    section  intex,code_c

start:              move.l   d0,lbL00715E
                    move.l   d1,lbL007162
                    move.l   d2,owned_weapons
                    move.l   a0,player_struct
                    move.l   a0,cur_credits
                    move.l   a1,gameport_register
                    move.l   a2,key_pressed
                    move.l   a3,briefing_text
                    move.l   a4,cur_map_top
                    move.l   a5,sound_routine
                    move.l   a6,schedule_sample_to_play
                    bsr      lbC0017A6
                    bsr      lbC001BA6
                    bsr      lbC0011BA
                    lea      lbW0071B4(pc),a6
                    move.l   schedule_sample_to_play(pc),a5
                    jsr      (a5)
lbC0000AC:          bsr      lbC0019CC
                    lea      text_main_menu(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    bsr      lbC0015DA
lbC0000C4:          move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #$100,d0
                    bne.b    lbC0000FE
                    tst.l    lbL007188
                    beq.b    lbC0000FE
                    subq.l   #1,lbL007188
                    bsr      lbC0015DA
                    bsr      lbC001F7E
lbC0000FE:          cmp.w    #1,d0
                    bne.b    lbC000120
                    cmp.l    #7,lbL007188
                    beq.b    lbC000120
                    addq.l   #1,lbL007188
                    bsr      lbC0015DA
                    bsr      lbC001F7E
lbC000120:          bsr      lbC001F96
                    moveq    #CIAB_GAMEPORT1,d0
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    lbC000140
                    moveq    #CIAB_GAMEPORT0,d0
lbC000140:          btst     d0,CIAA
                    bne      lbC0000C4
                    bsr      lbC000BD4
                    cmp.l    #4,lbL007188
                    beq      enter_holocode
lbC00015E:          cmp.l    #7,lbL007188
                    beq      lbC0001E4
                    tst.l    lbL007188
                    bne.b    lbC000190
                    move.l   #$00980000,lbW00710C
                    bsr      lbC00159E
                    move.l   #$FFFFFFFE,lbW00710C
lbC000190:          cmp.l    #1,lbL007188
                    bne.b    lbC0001A0
                    bsr      scr_tools_supplies
lbC0001A0:          cmp.l    #2,lbL007188
                    bne.b    lbC0001B0
                    bsr      lbC001392
lbC0001B0:          cmp.l    #3,lbL007188
                    bne.b    lbC0001C0
                    bsr      lbC001146
lbC0001C0:          cmp.l    #5,lbL007188
                    bne.b    lbC0001D0
                    bsr      lbC000518
lbC0001D0:          cmp.l    #6,lbL007188
                    bne.b    lbC0001E0
                    bsr      lbC0003CC
lbC0001E0:          bra      lbC0000AC

lbC0001E4:          bsr      lbC0019CC
                    lea      text_disconnecting(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    move.l   #1,d0
                    bsr      lbC001364
                    move.l   #6,d0
                    bsr      lbC0012BA
                    move.l   #copperlist_blank,CUSTOM+COP1LCH
                    bsr      lbC001BCA
                    move.l   #copperlist_blank,CUSTOM+COP1LCH
                    lea      cur_holocode(pc),a0
                    move.l   lbL007190(pc),d2
                    move.l   owned_weapons(pc),d0
                    move.l   purchased_supplies(pc),d1
                    rts

lbC0003B6:          cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    lbC0003B6
lbC0003C0:          cmp.b    #0,CUSTOM+VHPOSR
                    bne.b    lbC0003C0
                    rts

lbC0003CC:          btst     #CIAB_GAMEPORT0,CIAA
                    beq      lbC0003CC
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      lbC0003CC
                    bsr      lbC0003B6
                    bsr      lbC0003B6
                    bsr      lbC0003B6
                    bsr      lbC0003B6
                    clr.l    lbL007188
                    move.l   #$960020,lbW006FD4
                    move.l   #lbL0004C8,lbL0004C4
lbC000416:          bsr      lbC0019CC
                    move.l   lbL0004C4(pc),a0
                    move.l   (a0),a0
                    lea      font_struct(pc),a1
                    move.w   #1,lbW0012B8
                    clr.w    lbW0012B6
                    bsr      display_text
                    clr.w    lbW0012B8
                    move.w   lbW0012B6(pc),d7
                    clr.w    lbW0012B6
                    tst.w    d7
                    bne      lbC0004B8
lbC000452:          btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    lbC0004B8
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    lbC0004B8
                    move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #3,d0
                    beq.b    lbC00047E
                    cmp.w    #$300,d0
                    bne.b    lbC000452
lbC00047E:          cmp.w    #3,d0
                    bne.b    lbC000498
                    move.l   lbL0004C4(pc),a0
                    tst.l    4(a0)
                    beq      lbC000452
                    addq.l   #4,lbL0004C4
lbC000498:          cmp.w    #$300,d0
                    bne.b    lbC0004B4
                    move.l   lbL0004C4(pc),a0
                    cmp.l    #lbL0004C8,a0
                    beq      lbC000452
                    subq.l   #4,lbL0004C4
lbC0004B4:          bra      lbC000416

lbC0004B8:          move.l   #$968020,lbW006FD4
                    rts

lbL0004C4:          dc.l     lbL0004C8
lbL0004C8:          dc.l     text_infos_page_1
                    dc.l     text_infos_page_2
                    dc.l     text_infos_page_3
                    dc.l     text_infos_page_4
                    dc.l     text_infos_page_5
                    dc.l     text_infos_page_6
                    dc.l     text_infos_page_7
                    dc.l     text_infos_page_8
                    dc.l     text_infos_page_9
                    dc.l     text_infos_page_10
                    dc.l     text_infos_page_11
                    dc.l     text_infos_page_12
                    dc.l     text_infos_page_13
                    dc.l     text_infos_page_14
                    dc.l     text_infos_page_15
                    dc.l     text_infos_page_16
                    dc.l     text_infos_page_17
                    dc.l     text_infos_page_18
                    dc.l     text_infos_page_19
                    dc.l     0

lbC000518:          bsr      lbC0019CC
                    move.l   owned_weapons(pc),d0
                    move.l   #2,d1
                    move.l   #6,d2
                    lea      NO_MSG(pc),a0
lbC000534:          btst     d1,d0
                    beq.b    lbC00054A
                    move.b   #'Y',(a0)
                    move.b   #'E',1(a0)
                    move.b   #'S',2(a0)
                    bra.b    lbC00055A

lbC00054A:          move.b   #' ',(a0)
                    move.b   #'N',1(a0)
                    move.b   #'O',2(a0)
lbC00055A:          addq.w   #1,d1
                    add.l    #41,a0
                    subq.w   #1,d2
                    bne.b    lbC000534
                    move.l   player_struct(pc),a0
                    move.l   INTEX_ALIENS_KILLED(a0),d0
                    move.l   d0,number_to_display
                    bsr      lbC001E3E
                    lea      lbL001CFE(pc),a0
                    lea      text_aliens_killed(pc),a1
                    bsr      lbC000A8E
                    move.l   player_struct(pc),a0
                    move.l   INTEX_SHOTS_FIRED(a0),d0
                    move.l   d0,number_to_display
                    bsr      lbC001E3E
                    lea      lbL001CFE(pc),a0
                    lea      text_bullets_fired(pc),a1
                    bsr      lbC000A8E
                    move.l   player_struct(pc),a0
                    move.l   INTEX_CUR_CREDITS(a0),d0
                    divu     #50,d0
                    move.l   d0,INTEX_UNUSED(a0)
                    move.l   d0,number_to_display
                    bsr      lbC001E3E
                    lea      lbL001CFE(pc),a0
                    lea      text_credits_owned,a1
                    bsr      lbC000A8E
                    move.l   player_struct(pc),a0
                    move.l   INTEX_DOORS_OPENED(a0),d0
                    move.l   d0,number_to_display
                    bsr      lbC001E3E
                    lea      lbL001CFE(pc),a0
                    lea      text_doors_opened(pc),a1
                    bsr      lbC000A8E
                    move.l   player_struct(pc),a0
                    move.l   INTEX_AMMO_PACKS(a0),d0
                    move.l   d0,number_to_display
                    bsr      lbC001E3E
                    lea      lbL001CFE(pc),a0
                    lea      text_ammopacks_owned(pc),a1
                    bsr      lbC000A8E
                    move.l   player_struct(pc),a0
                    move.l   INTEX_HEALTH(a0),d0
                    lea      text_health_levels(pc),a0
                    lea      text_energy_left(pc),a1
                    cmp.w    #21,d0
                    bls.b    lbC00064E
                    add.l    #8,a0
                    cmp.w    #42,d0
                    bls.b    lbC00064E
                    add.l    #8,a0
lbC00064E:          move.l   #8,d0
lbC000654:          move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    lbC000654
                    move.l   player_struct(pc),a0
                    move.l   INTEX_CUR_WEAPON(a0),d0
                    lea      text_current_weapon(pc),a1
                    lea      table_text_owned_weapons(pc),a0
lbC000670:          cmp.l    #-1,(a0)
                    beq.b    lbC000684
                    cmp.l    (a0),d0
                    beq      lbC000684
                    addq.l   #8,a0
                    bra      lbC000670

lbC000684:          add.l    #4,a0
                    move.l   (a0),a0
                    moveq    #14,d0
lbC000692:          move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    lbC000692
                    lea      text_statistics(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    move.l   #$960020,lbW006FD4
                    bsr      lbC001190
                    move.l   #$968020,lbW006FD4
                    rts

text_health_levels: dc.b     'LOW     AVERAGE GOOD    '
table_text_owned_weapons:
                    dc.l     1,MACHINEGUN_MSG
                    dc.l     2,TWINFIRE_MSG
                    dc.l     3,FLAMEARC_MSG
                    dc.l     4,PLASMAGUN_MSG
                    dc.l     5,FLAMETHROWER_MSG
                    dc.l     6,SIDEWINDERS_MSG
                    dc.l     7,LAZER_MSG
                    dc.l     -1,MACHINEGUN_MSG
MACHINEGUN_MSG:     dc.b     'MACHINE GUN   '
TWINFIRE_MSG:       dc.b     'TWIN FIRE     '
FLAMEARC_MSG:       dc.b     'FLAME ARC     '
PLASMAGUN_MSG:      dc.b     'PLASMA GUN    '
FLAMETHROWER_MSG:   dc.b     'FLAME THROWER '
SIDEWINDERS_MSG:    dc.b     'SIDEWINDERS   '
LAZER_MSG:          dc.b     'LAZER         '
                    even
text_statistics:    dc.w     0,16
                    dc.b     '           INTEX STATISTICS             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '     ALIENS KILLED:  '
text_aliens_killed: dc.b     '                   ',0
                    dc.b     '       SHOTS FIRED:  '
text_bullets_fired: dc.b     '       BULLETS     ',0
                    dc.b     '      CREDIT LIMIT:  '
text_credits_owned: dc.b     '       CR          ',0
                    dc.b     '      DOORS OPENED:  '
text_doors_opened:  dc.b     '                   ',0
                    dc.b     '        AMMO PACKS:  '
text_ammopacks_owned:
                    dc.b     '       CLIP        ',0
                    dc.b     '      ENERGY STATE:  '
text_energy_left:   dc.b     '                   ',0
                    dc.b     '    CURRENT WEAPON:  '
text_current_weapon:
                    dc.b     '                   ',0
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
                    dc.b     -1
                    even

lbC000A8E:          move.l   #6,d0
                    tst.b    (a0)
                    beq      lbC000AA8
lbC000A9A:          tst.b    (a0)
                    beq      lbC000AA8
                    move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    lbC000A9A
                    rts

lbC000AA8:          move.b   #' ',(a1)+
                    subq.w   #1,d0
                    bpl.b    lbC000AA8
                    rts

text_holocode:      dc.w     128,120
cur_holocode:       dc.b     '00000'
                    dc.b     -1
                    even
cur_holocode_position:
                    dc.w     0

enter_holocode:     bsr      lbC0019CC
                    lea      text_enter_holocode(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    bsr      lbC000BB4
lbC000AD8:          move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    move.w   cur_holocode_position(pc),d1
                    lea      cur_holocode(pc),a1
                    cmp.w    #$100,d0
                    bne.b    lbC000B12
                    move.b   0(a1,d1.w),d2
                    cmp.b    #'9',d2
                    bne.b    lbC000B02
                    move.b   #'/',0(a1,d1.w)
lbC000B02:          addq.b   #1,0(a1,d1.w)
                    bsr      lbC000B98
                    bsr      lbC001F7E
                    bra.b    lbC000B70

lbC000B12:          cmp.w    #1,d0
                    bne.b    lbC000B38
                    move.b   0(a1,d1.w),d2
                    cmp.b    #$30,d2
                    bne.b    lbC000B28
                    move.b   #':',0(a1,d1.w)
lbC000B28:          subq.b   #1,0(a1,d1.w)
                    bsr      lbC000B98
                    bsr      lbC001F7E
                    bra.b    lbC000B70

lbC000B38:          cmp.w    #$300,d0
                    bne.b    lbC000B54
                    tst.w    d1
                    beq.b    lbC000B70
                    subq.w   #1,cur_holocode_position
                    bsr      lbC000BB4
                    bsr      lbC001F7E
                    bra.b    lbC000B70

lbC000B54:          cmp.w    #3,d0
                    bne.b    lbC000B70
                    cmp.w    #4,d1
                    beq.b    lbC000B70
                    addq.w   #1,cur_holocode_position
                    bsr      lbC000BB4
                    bsr      lbC001F7E
lbC000B70:          bsr      lbC001F96
                    moveq    #CIAB_GAMEPORT1,d0
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    lbC000B8A
                    moveq    #CIAB_GAMEPORT0,d0
lbC000B8A:          btst     d0,CIAA
                    bne      lbC000AD8
                    bra      lbC00015E

lbC000B98:          bsr      lbC001960
                    lea      text_holocode(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    ; no rts

lbC000BB4:          lea      lbW0020CC(pc),a0
                    move.w   cur_holocode_position(pc),d0
                    lsl.w    #3,d0
                    add.w    #$80,d0
                    move.w   d0,(a0)
                    move.w   #$84,2(a0)
                    bra      lbC001FE6

lbC000BD4:          movem.l  d0-d7/a0-a6,-(sp)
                    moveq    #14,d0
                    moveq    #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC000BF2:          movem.l  d0-d7/a0-a6,-(sp)
                    moveq    #48,d0
                    moveq    #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

scr_tools_supplies: bsr      lbC0019CC
                    bsr      lbC001112
                    lea      text_tool_supplies(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    clr.l    lbL000DC4
lbC000C4E:          move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #$100,d0
                    bne.b    lbC000C78
                    tst.l    lbL000DC4
                    beq.b    lbC000C78
                    subq.l   #1,lbL000DC4
                    bsr      lbC0010EE
                    bsr      lbC001F7E
lbC000C78:          cmp.w    #1,d0
                    bne.b    lbC000C9A
                    cmp.l    #5,lbL000DC4
                    beq.b    lbC000C9A
                    addq.l   #1,lbL000DC4
                    bsr      lbC0010EE
                    bsr      lbC001F7E
lbC000C9A:          bsr      lbC0010EE
                    bsr      lbC001F96
                    moveq    #CIAB_GAMEPORT1,d0
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    lbC000CBC
                    moveq    #CIAB_GAMEPORT0,d0
lbC000CBC:          btst     d0,CIAA
                    bne      lbC000C4E
                    bsr      lbC000BD4
                    move.l   lbL000DC4(pc),d0
                    cmp.l    #5,d0
                    beq      lbC00180E
                    move.l   purchased_supplies(pc),d1
                    btst     d0,d1
                    bne      lbC000C4E
                    lea      supplies_prices_list(pc),a0
                    move.l   d0,d1
                    ext.l    d1
                    add.l    d1,d1
                    add.l    d1,d1
                    move.l   (a0,d1.w),d1
                    move.l   cur_credits(pc),a5
                    move.l   (a5),d2
                    cmp.l    d1,d2
                    bge.b    enough_money
                    lea      text_insufficient_funds_2(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    moveq    #1,d0
                    bsr      lbC001364
                    bsr      lbC0018F4
                    bra      lbC000C4E

enough_money:       sub.l    d1,(a5)
                    cmp.w    #2,d0                      ; energy injection
                    bne.b    lbC000D52
                    add.l    #32,player_health
                    cmp.l    #PLAYER_MAX_HEALTH,player_health
                    bmi.b    lbC000D52
                    move.l   #PLAYER_MAX_HEALTH,player_health
lbC000D52:          movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC000DF6
                    movem.l  (sp)+,d0-d7/a0-a6
                    moveq    #0,d1
                    bset     d0,d1
                    or.l     d1,purchased_supplies
                    add.l    d0,d0
                    lea      text_tool_bought(pc),a0
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

lbC000DF6:          move.l   schedule_sample_to_play(pc),a5
                    tst.w    d0
                    bne.b    lbC000E0A
                    lea      lbW0071C8(pc),a6
                    jmp      (a5)

lbC000E0A:          cmp.w    #1,d0
                    bne.b    lbC000E18
                    lea      lbW0071D2(pc),a6
                    jmp      (a5)

lbC000E18:          cmp.w    #2,d0
                    bne.b    lbC000E26
                    lea      lbW00720E(pc),a6
                    jmp      (a5)

lbC000E26:          cmp.w    #3,d0
                    bne.b    lbC000E34
                    lea      lbW0071FA(pc),a6
                    jmp      (a5)

lbC000E34:          cmp.w    #4,d0
                    bne.b    lbC000E42
                    lea      lbW0071E6(pc),a6
                    jmp      (a5)

lbC000E42:          rts

text_tool_supplies: dc.w     0,36
                    dc.b     '          INTEX TOOL SUPPLIES           ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
text_tool_bought:   dc.b     '    REMOTE LOCATION SCANNER  10000 CR   ',0
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
text_tool_credit_limit:
                    dcb.b    8,0
                    dc.b    -1
                    even

lbC0010EE:          lea      lbW0020CC(pc),a0
                    move.l   lbL000DC4(pc),d0
                    mulu     #24,d0
                    add.l    #72,d0
                    move.w   d0,2(a0)
                    move.w   #$10,(a0)
                    bra      lbC001FE6

lbC001112:          move.l   cur_credits(pc),a0
                    move.l   (a0),d0
                    divu     #50,d0
                    move.l   d0,number_to_display
                    bsr      lbC001C14
                    lea      lbL001CFE(pc),a0
                    lea      text_tool_credit_limit(pc),a1
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
                    move.l   briefing_text(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    bra      lbC001190

lbC001164:          moveq    #CIAB_GAMEPORT1,d1
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    lbC00117E
                    moveq    #CIAB_GAMEPORT0,d1
lbC00117E:          moveq    #0,d0
                    btst     d1,CIAA
                    bne.b    lbC00118E
                    move.l   #-1,d0
lbC00118E:          rts

lbC001190:          moveq    #CIAB_GAMEPORT1,d0
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    lbC0011AA
                    moveq    #CIAB_GAMEPORT0,d0
lbC0011AA:          btst     d0,CIAA
                    bne.b    lbC0011AA
                    bra      lbC000BD4

lbC0011BA:          move.b   CIAB+CIATODLOW,d1
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
                    bne.b    lbC00129E
lbC00122A:          move.w   #1,lbW0012B8
                    lea      text_connecting(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    tst.w    lbW0012B6
                    bne.b    lbC00129E
                    bsr      lbC001164
                    tst.l    d0
                    bmi      lbC00129E
                    move.l   #1,d0
                    bsr      lbC001342
                    lea      text_system_status(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    tst.w    lbW0012B6
                    bne.b    lbC00129E
                    bsr      lbC001164
                    tst.l    d0
                    bmi      lbC00129E
                    move.l   #2,d0
                    bsr      lbC001342
                    lea      text_downloading(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
lbC00129E:          clr.w    lbW0012B8
                    clr.w    lbW0012B6
                    move.l   #1,d0
                    bra      lbC0019CC

lbW0012B6:          dc.w     0
lbW0012B8:          dc.w     0

lbC0012BA:          movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #74,d0
                    move.l   #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
lbC0012D6:          btst     #7,CIAA
                    beq.b    lbC001336
                    btst     #6,CIAA
                    beq.b    lbC001336
                    bsr      lbC001F96
                    move.b   CIAB+CIATODLOW,d1
                    ext.w    d1
                    move.b   d1,lbW006FBA
                    neg.w    d1
                    move.b   d1,lbW006FB6
                    subq.l   #1,d0
                    bne.b    lbC0012D6
lbC001308:          move.w   #$2C81,lbW006FB6
                    move.w   #$2CC1,lbW006FBA
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #75,d0
                    move.l   #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC001336:          move.w   #1,lbW0012B6
                    bra      lbC001308

lbC001342:          mulu     #50,d0
                    move.l   d0,d7
lbC001348:          bsr      lbC001164
                    tst.l    d0
                    bmi.b    lbC00135E
                    bsr      lbC001F96
                    subq.l   #1,d7
                    bne.b    lbC001348
                    rts

lbC00135E:          addq.l   #4,sp
                    bra      lbC00129E

lbC001364:          mulu     #50,d0
lbC001368:          btst     #7,CIAA
                    beq.b    lbC001388
                    btst     #6,CIAA
                    beq.b    lbC001388
                    bsr      lbC001F96
                    subq.l   #1,d0
                    bne.b    lbC001368
                    rts

lbC001388:          move.w   #1,lbW0012B6
                    rts

lbC001392:          bsr      lbC0019CC
                    bsr      lbC00141A
                    lea      text_map_system(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    move.l   lbL00715E(pc),d0
                    move.l   lbL007162(pc),d1
                    lsr.l    #3,d0
                    lsr.l    #3,d1
                    add.l    #30,d0
                    add.l    #28,d1
                    move.w   d0,lbW0020CC
                    move.w   d1,lbW0020CE
                    lea      lbW0020CC(pc),a0
                    bsr      lbC001FE6
lbC0013DE:          bsr      lbC001F96
                    btst     #7,CIAA
                    beq.b    lbC0013F8
                    btst     #6,CIAA
                    bne.b    lbC0013DE
lbC0013F8:          lea      lbL027102,a0
                    move.l   #(256*40),d0
                    bsr      lbC001596
                    bra      lbC0019CC

lbL00140E:          dc.l     $F8
lbL001412:          dc.l     $CA
lbL001416:          dc.l     $61D8

lbC00141A:          lea      lbL027102,a5
                    move.l   cur_map_top(pc),a0
                    add.l    lbL001416(pc),a0
                    move.l   lbL00140E(pc),d0
                    move.l   lbL001412(pc),d1
                    move.l   d0,d7
lbC00143A:          move.w   -(a0),d2
                    and.w    #$3F,d2
                    tst.w    d2
                    beq.b    lbC0014AE
                    cmp.w    #3,d2
                    beq      lbC0014BA
                    cmp.w    #1,d2
                    bhi.b    lbC0014AE
                    move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    add.l    #32,d4
                    add.l    #32,d5
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
                    add.l    #33,d4
                    add.l    #32,d5
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
                    bne.b    lbC00143A
                    move.l   d7,d0
                    subq.w   #2,d1
                    bne.b    lbC00143A
                    rts

lbC0014BA:          move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    sub.l    #(256*40*4),a4
                    add.l    #32,d4
                    add.l    #32,d5
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
                    sub.l    #(256*40*4),a4
                    add.l    #33,d4
                    add.l    #32,d5
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
                    bne.b    lbC001596
                    rts

lbC00159E:          bsr      lbC0019CC
                    bsr      lbC001BE0
                    lea      text_weapons(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    bsr      lbC001F6C
lbC0015BA:          bsr      lbC001F96
                    bsr      lbC001EF4
                    tst.l    d0
                    beq.b    lbC0015CA
                    bsr      lbC001F6C
lbC0015CA:          bsr      lbC00162A
                    move.l   key_pressed(pc),a0
                    bra      lbC0015BA

lbC0015D8:          rts

lbC0015DA:          lea      lbW0020CC(pc),a0
                    move.l   lbL007188(pc),d0
                    mulu     #12,d0
                    add.l    #68,d0
                    move.w   d0,2(a0)
                    move.w   #$30,(a0)
                    bra      lbC001FE6

lbC0015FE:          lea      lbW0020CC(pc),a0
                    move.l   lbL007182(pc),d0
                    not.l    d0
                    and.l    #1,d0
                    mulu     #12,d0
                    add.l    #227,d0
                    move.w   d0,2(a0)
                    move.w   #$80,(a0)
                    bra      lbC001FE6

lbC00162A:          move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #1,d0
                    bne.b    lbC001642
                    clr.l    lbL007182
lbC001642:          cmp.w    #$100,d0
                    bne.b    lbC001652
                    move.l   #1,lbL007182
lbC001652:          bsr      lbC0015FE
                    bsr      lbC001164
                    tst.l    d0
                    beq      lbC00180E
                    tst.l    lbL007182
                    bne      lbC001670
                    addq.l   #4,sp
                    bra      lbC0015D8

lbC001670:          move.l   owned_weapons(pc),d1
                    move.l   lbL00716E(pc),d0
                    addq.l   #2,d0
                    moveq    #0,d2
                    bset     d0,d2
                    and.w    d2,d1
                    tst.b    d1
                    bne      lbC001766
                    move.l   lbL00716E(pc),d0
                    add.l    d0,d0
                    add.l    d0,d0
                    lea      lbL00174A(pc),a0
                    move.l   0(a0,d0.l),d0
                    move.l   cur_credits(pc),a0
                    move.l   (a0),d1
                    divu     #50,d1
                    cmp.l    d0,d1
                    bmi      lbC001786
                    move.l   cur_credits(pc),a0
                    move.l   (a0),d1
                    mulu     #50,d0
                    sub.l    d0,d1
                    move.l   d1,(a0)
                    or.l     d2,owned_weapons
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   schedule_sample_to_play(pc),a5
                    lea      lbW0071D2(pc),a6
                    jsr      (a5)
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   purchased_supplies(pc),d0
                    or.l     #2,d0
                    move.l   d0,purchased_supplies
                    move.l   #2,d0
                    lea      text_tool_bought(pc),a0
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
                    lea      text_credits_debited(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    moveq    #1,d0
                    bsr      lbC001364
                    addq.l   #4,sp
                    bra      lbC00159E

lbL00174A:          dc.l     10000
                    dc.l     24000
                    dc.l     35000
                    dc.l     48000
                    dc.l     60000
                    dc.l     75000
                    dc.l     0

lbC001766:          lea      text_already_owned(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    moveq    #2,d0
                    bsr      lbC001364
                    addq.l   #4,sp
                    bra      lbC00159E

lbC001786:          lea      text_insufficient_funds(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    moveq    #2,d0
                    bsr      lbC001364
                    addq.l   #4,sp
                    bra      lbC00159E

lbC0017A6:          move.l   #copperlist_blank,CUSTOM+COP1LCH
                    lea      lbW007058(pc),a0
                    move.l   #bitplanes,d0
                    moveq    #5,d1
lbC0017D2:          move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(256*40),d0
                    addq.l   #8,a0
                    subq.b   #1,d1
                    bne.b    lbC0017D2
                    lea      background_pic+(256*40*4),a0
                    lea      copper_palette(pc),a1
                    moveq    #16,d0
lbC0017FC:          move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #1,d0
                    bne.b    lbC0017FC
                    move.w   #$2D1,lbW007016
                    rts

lbC00180E:          rts

lbC001810:          addq.w   #1,lbW001852
                    cmp.w    #2,lbW001852
                    bmi.b    lbC00180E
                    clr.w    lbW001852
                    move.l   lbL001854(pc),a0
                    tst.w    (a0)
                    bpl.b    lbC00183E
                    lea      lbW001858(pc),a0
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

lbC001888:          move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    WAIT_BLIT
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    lea      background_pic+(82*40),a0
                    lea      lbL01DDD2,a1
                    moveq    #4,d0
lbC0018C0:          move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(138*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    subq.b   #1,d0
                    bne.b    lbC0018C0
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

lbC0018F4:          move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    WAIT_BLIT
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    lea      background_pic+(228*40),a0
                    lea      lbL01F4A2,a1
                    moveq    #4,d0
lbC00192C:          move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(28*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    subq.b   #1,d0
                    bne.b    lbC00192C
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

lbC001960:          move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    WAIT_BLIT
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    lea      background_pic+(108*40),a0
                    lea      lbL01E1E2,a1
                    moveq    #4,d0
lbC001998:          move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(28*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    subq.b   #1,d0
                    bne.b    lbC001998
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

lbC0019CC:          move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    WAIT_BLIT
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    move.l   #background_pic,CUSTOM+BLTAPTH
                    move.l   #bitplanes,CUSTOM+BLTDPTH
                    moveq    #4,d0
lbC001A0C:          move.w   #(256*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    subq.b   #1,d0
                    bne.b    lbC001A0C
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

lbC001A7C:          lea      lbL007222(pc),a0
                    move.l   #2560,d0
lbC001A88:          clr.b    (a0)+
                    subq.w   #1,d0
                    bne.b    lbC001A88
                    lea      lbL001B8E(pc),a0
                    move.l   lbL00716E(pc),d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a0,d0.l),a0
                    lea      lbL01E37C,a1
                    WAIT_BLIT
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #-1,CUSTOM+BLTAFWM
                    move.l   #$DFC0000,CUSTOM+BLTCON0
                    clr.w    CUSTOM+BLTDMOD
                    clr.w    CUSTOM+BLTBMOD
                    move.w   #$14,CUSTOM+BLTAMOD
                    moveq    #4,d0
lbC001ADC:          move.l   a0,CUSTOM+BLTAPTH
                    move.l   #lbL007222,CUSTOM+BLTDPTH
                    move.l   #lbL007222,CUSTOM+BLTBPTH
                    move.w   #(88*64)+10,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(264*40),a0
                    subq.w   #1,d0
                    bne.b    lbC001ADC
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    move.l   #-1,CUSTOM+BLTAFWM
                    move.l   #$FE20000,CUSTOM+BLTCON0
                    move.w   #20,CUSTOM+BLTDMOD
                    move.w   #20,CUSTOM+BLTAMOD
                    move.w   #20,CUSTOM+BLTCMOD
                    clr.w    CUSTOM+BLTBMOD
                    moveq    #4,d0
lbC001B4C:          move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.l   a1,CUSTOM+BLTCPTH
                    move.l   #lbL007222,CUSTOM+BLTBPTH
                    move.w   #(88*64)+10,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(264*40),a0
                    add.l    #(256*40),a1
                    subq.b   #1,d0
                    bne.b    lbC001B4C
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

lbL001B8E:          dc.l     weapons_pic+(176*40)
                    dc.l     weapons_pic
                    dc.l     weapons_pic+20
                    dc.l     weapons_pic+(176*40)+20
                    dc.l     weapons_pic+(88*40)+20
                    dc.l     weapons_pic+(88*40)

lbC001BA6:          move.l   #copperlist_main,CUSTOM+COP1LCH
                    bsr      lbC0019CC
                    lea      lbW0020CC(pc),a0
                    bsr      lbC001FB0
                    lea      lbW0020CC(pc),a0
                    bra      lbC001FE6

lbC001BCA:          lea      lbW0020CC(pc),a0
                    move.w   #-16,(a0)
                    move.w   #-16,2(a0)
                    bra      lbC001FE6

lbC001BE0:          move.l   cur_credits(pc),a0
                    move.l   (a0),d0
                    divu     #50,d0
                    move.l   d0,number_to_display
                    bsr      lbC001C14
                    lea      lbL001CFE(pc),a0
                    lea      text_credit_limit(pc),a1
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    rts

lbC001C14:          lea      lbL001CFE(pc),a2
                    moveq    #32,d7
lbC001C20:          clr.b    (a2)+
                    subq.w   #1,d7
                    bne.b    lbC001C20
                    move.l   number_to_display(pc),d0
                    lea      lbL001CFE(pc),a0
                    lea      decimal_table(pc),a1
                    cmp.l    #$3B9AC9FF,d0
                    bhi.b    lbC001CA2
                    clr.l    lbL001CF6
                    moveq    #'0',d2
lbC001C4E:          tst.l    (a1)
                    beq.b    lbC001CBC
                    move.l   (a1),d1
                    sub.l    d1,d0
                    addq.b   #1,d2
                    tst.l    d0
                    beq.b    lbC001C76
                    bgt.b    lbC001C4E
                    add.l    d1,d0
                    subq.l   #1,d2
lbC001C76:          addq.l   #4,a1
                    tst.b    lbL001CF6
                    bne.b    lbC001C8E
                    cmp.b    #'0',d2
                    beq.b    lbC001C98
lbC001C8E:          move.b   d2,(a0)+
                    move.b   #1,lbL001CF6
lbC001C98:          moveq    #'0',d2
                    bra.b    lbC001C4E

lbC001CA2:          move.l   #'9999',(a0)
                    move.l   #'9999',4(a0)
                    move.b   #'9',8(a0)
                    add.l    #9,a0
lbC001CBC:          move.b   #' ',(a0)+
                    move.b   #'C',(a0)+
                    move.b   #'R',(a0)+
                    move.b   #$FF,(a0)
                    rts

decimal_table:      dc.l     100000000
                    dc.l     10000000
                    dc.l     1000000
                    dc.l     100000
                    dc.l     10000
                    dc.l     1000
                    dc.l     100
                    dc.l     10
                    dc.l     1
                    dc.l     0
lbL001CF6:          dc.l     0
number_to_display:  dc.l     0
lbL001CFE:          dcb.l    80,0

lbC001E3E:          lea      lbL001CFE(pc),a2
                    moveq    #32,d7
lbC001E4A:          clr.b    (a2)+
                    subq.w   #1,d7
                    bne.b    lbC001E4A
                    move.l   number_to_display(pc),d0
                    lea      lbL001CFE(pc),a0
                    lea      decimal_table(pc),a1
                    cmp.l    #$3B9AC9FF,d0
                    bhi.b    lbC001ECC
                    clr.l    lbL001CF6
                    moveq    #'0',d2
lbC001E78:          tst.l    (a1)
                    beq.b    lbC001EE6
                    move.l   (a1),d1
                    sub.l    d1,d0
                    addq.b   #1,d2
                    tst.l    d0
                    beq.b    lbC001EA0
                    bgt.b    lbC001E78
                    add.l    d1,d0
                    subq.l   #1,d2
lbC001EA0:          add.l    #4,a1
                    tst.b    lbL001CF6
                    bne.b    lbC001EB8
                    cmp.b    #'0',d2
                    beq.b    lbC001EC2
lbC001EB8:          move.b   d2,(a0)+
                    move.b   #1,lbL001CF6
lbC001EC2:          moveq    #'0',d2
                    bra.b    lbC001E78

lbC001ECC:          move.l   #'9999',(a0)
                    move.l   #'9999',4(a0)
                    move.b   #'9',8(a0)
                    add.l    #9,a0
lbC001EE6:          tst.b    (a0)
                    beq      lbC00180E
                    move.b   #0,(a0)+
                    bra      lbC001EE6

lbC001EF4:          move.l   gameport_register(pc),a0
                    move.w   (a0),d1
                    moveq    #0,d0
                    and.w    #$303,d1
                    cmp.w    #$300,d1
                    bne.b    lbC001F26
                    move.l   #1,d0
                    subq.l   #1,lbL00716E
                    tst.l    lbL00716E
                    bpl.b    lbC001F26
                    move.l   #5,lbL00716E
lbC001F26:          cmp.w    #3,d1
                    bne.b    lbC001F4A
                    move.l   #1,d0
                    addq.l   #1,lbL00716E
                    cmp.l    #6,lbL00716E
                    bmi.b    lbC001F4A
                    clr.l    lbL00716E
lbC001F4A:          rts

lbC001F4C:          move.l   lbL00716E(pc),d0
                    add.l    d0,d0
                    add.l    d0,d0
                    lea      table_text_weapons(pc),a0
                    move.l   0(a0,d0.l),a0
                    lea      font_struct(pc),a1
                    bra      display_text

lbC001F6C:          bsr      lbC001888
                    bsr      lbC001A7C
                    bsr      lbC001F4C
                    ; no rts

lbC001F7E:          move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    ;tst.w    d0
                    bne.b    lbC001F7E
                    bra      lbC000BD4

lbC001F96:          cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    lbC001F96
lbC001FA0:          cmp.b    #44,CUSTOM+VHPOSR
                    bne.b    lbC001FA0
                    bra      lbC001810

lbC001FB0:          tst.l    16(a0)
                    bne.b    lbC001FD2
                    move.l   12(a0),d0
lbC001FBA:          move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

lbC001FD2:          move.l   16(a0),a1
                    move.l   a1,20(a0)
                    move.w   6(a1),24(a0)
                    move.l   (a1),d0
                    bra.b    lbC001FBA

lbC001FE6:          move.l   8(a0),a1
                    tst.l    16(a0)
                    bne      lbC00207E
lbC001FF2:          and.w    #$80,14(a1)
                    move.w   0(a0),d0
                    add.w    #$80,d0
                    btst     #0,d0
                    beq.b    lbC00200C
                    or.w     #1,14(a1)
lbC00200C:          lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    add.w    #$2C,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #$100,d1
                    bmi.b    lbC002030
                    sub.w    #$FF,d1
                    or.b     #2,15(a1)
lbC002030:          move.b   d1,14(a1)
                    cmp.w    #$100,d0
                    bmi.b    lbC002044
                    sub.w    #$FF,d0
                    or.b     #4,15(a1)
lbC002044:          move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.b    lbC00207C
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
lbC00207C:          rts

lbC00207E:          subq.w   #1,24(a0)
                    bpl      lbC001FF2
                    addq.l   #8,20(a0)
lbC00208A:          move.l   $14(a0),a2
                    move.l   (a2),d0
                    tst.l    d0
                    bmi.b    lbC0020A8
                    move.w   6(a2),24(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      lbC001FF2

lbC0020A8:          move.l   16(a0),20(a0)
                    bra.b    lbC00208A

lbW0020CC:          dc.w     -16
lbW0020CE:          dc.w     -16,11,0
                    dc.l     lbW0070FC
                    dc.l     lbW0020E8
                    dcb.w    6,0
lbW0020E8:          dcb.w    22,-256
                    dcb.w    128,0

display_text:       lea      CUSTOM,a6
                    moveq    #0,d0
                    moveq    #0,d1
                    move.w   (a0)+,d0
                    move.w   (a0)+,d1
                    move.l   d0,d7
lbC002224:          tst.w    lbW0012B8
                    beq.b    lbC002252
                    move.w   #1,lbW0012B6
                    btst     #7,CIAA
                    beq      lbC0023FA
                    btst     #6,CIAA
                    beq      lbC0023FA
                    clr.w    lbW0012B6
lbC002252:          move.l   (a1),a2
                    move.l   d0,d2
                    move.l   d2,d3
                    and.w    #$F,d3
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
                    move.l   36(a1),a3
lbC002284:          cmp.b    (a3)+,d2
                    beq.b    lbC002292
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.b    lbC002284
                    bra      lbC0023E0

lbC002292:          move.l   $20(a1),a3
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
lbC0022FE:          
                    WAIT_BLIT
                    move.l   d6,BLTAPTH(a6)
                    move.l   d4,BLTBPTH(a6)
                    move.l   d4,BLTDPTH(a6)
                    move.w   #(16*64)+1,BLTSIZE(a6)
                    add.l    d5,d6
                    subq.w   #1,d2
                    bne.b    lbC0022FE
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
                    move.l   $1C(a1),d3
                    move.l   #letter_buffer,d4
                    move.w   $16(a1),d6
                    lsl.w    #6,d6
                    addq.w   #2,d6
lbC002372:          
                    WAIT_BLIT
                    move.l   d4,BLTBPTH(a6)
                    move.l   a3,BLTAPTH(a6)
                    move.l   a2,BLTCPTH(a6)
                    move.l   a2,BLTDPTH(a6)
                    move.w   d6,BLTSIZE(a6)
                    add.l    d2,a2
                    add.l    d3,a3
                    subq.b   #1,d5
                    bne.b    lbC002372

                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW0020CC(pc),a0
                    move.w   d0,(a0)
                    move.w   d1,2(a0)
                    subq.w   #1,2(a0)
                    bsr      lbC001FE6
                    addq.w   #1,lbW00240C
                    cmp.w    #3,lbW00240C
                    bne.b    lbC0023CE
                    clr.w    lbW00240C
                    bsr      lbC000BF2
lbC0023CE:          not.w    lbW00240A
                    beq.b    lbC0023DC
                    bsr      lbC001F96
lbC0023DC:          movem.l  (sp)+,d0-d7/a0-a6
lbC0023E0:          
                    add.l    16(a1),d0
                    tst.b    (a0)
                    bmi.b    lbC0023FA
                    bne      lbC002224
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    20(a1),d1
                    bra      lbC002224

lbC0023FA:          lea      lbW0020CC(pc),a0
                    add.w    #12,(a0)
                    bra      lbC001FE6

lbW00240A:          dc.w     0
lbW00240C:          dc.w     0
letter_buffer:      dcb.l    (16*2),0
font_struct:        dc.l     bitplanes,(256*40),4,36,8,12,80,1008,font_pic,ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ>1234567890.!?: ',0
                    even
text_map_system:    dc.w     0,12
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
                    dc.b     -1
                    even
text_connecting:    dc.w     0,48
                    dc.b     'INTEX NETWORK CONNECT: CODE ABF01DCC61',0
                    dc.b     'CONNECTING.....................'
                    dc.b     -1
                    even
text_system_status: dc.w     0,84
                    dc.b     'INTEX NETWORK SYSTEM V10.1',0
                    dc.b     '2.5G RAM:         OK',0
                    dc.b     'EXTERNAL DEVICE:  OK',0
                    dc.b     'SYSTEM V1.32 CS:  OK',0
                    dc.b     'VIDEODISPLAY:     CCC2.A2',0
                    dc.b     'TEXT UPDATE ACCCELERATOR INSTALLED.'
                    dc.b     -1
                    even
text_downloading:   dc.w     0,168
                    dc.b     'EXECUTING DOS 6.0',0
                    dc.b     'SYSTEM DOWNLOADING NETWORK DATA.... OK',0
                    dc.b     'INTEX EXECUTED!'
                    dc.b     -1
                    even
text_disconnecting: dc.w     0,64
                    dc.b     '  DISCONNECTING..............'
                    dc.b     -1
                    even
text_credits_debited:
                    dc.w     0,62
                    dc.b     '     CREDITS DEBITED.'
                    dc.b     -1
                    even
text_already_owned: dc.w     0,211
                    dc.b     '     YOU ALREADY OWN THAT WEAPON.'
                    dc.b     -1
                    even
text_insufficient_funds:
                    dc.w     0,211
                    dc.b     '              INSUFFUCIENT FUNDS.'
                    dc.b     -1
                    even
text_insufficient_funds_2:
                    dc.w     0,232
                    dc.b     '                  INSUFFICIENT FUNDS'
                    dc.b     -1
                    even
text_main_menu:     dc.w     0,32
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
                    dc.b     -1
                    even
text_enter_holocode:
                    dc.w     0,96
                    dc.b     '            ENTER HOLOCODE              ',0
                    dc.b     '                                        ',0
                    dc.b     '                00000                   ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' UP AND DOWN INCREASES/DECREASES DIGIT  ',0
                    dc.b     '      LEFT AND RIGHT MOVES CURSOR       ',0
                    dc.b     '        PRESS BUTTON WHEN READY         '
                    dc.b     -1
                    even
text_infos_page_1:  dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_2:  dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_3:  dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_4:  dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_5:  dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_6:  dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_7:  dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_8:  dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_9:  dc.w     0,24
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
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_10: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_11: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_12: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_13: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_14: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_15: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_16: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_17: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_18: dc.w     0,24
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
                    dc.b     -1
                    even
text_infos_page_19: dc.w     0,24
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
                    dc.b     -1
                    even
text_weapons:       dc.w     0,24
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
text_credit_limit:  dcb.b    8,0
                    dc.b     -1
                    even
table_text_weapons: dc.l     text_weapon_1
                    dc.l     text_weapon_2
                    dc.l     text_weapon_3
                    dc.l     text_weapon_4
                    dc.l     text_weapon_5
                    dc.l     text_weapon_6
text_weapon_1:      dc.w     0,84
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
                    dc.b     -1
                    even
text_weapon_2:      dc.w     0,84
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
                    dc.b     -1
                    even
text_weapon_3:      dc.w     0,84
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
                    dc.b     -1
                    even
text_weapon_4:      dc.w     0,84
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
                    dc.b     -1
                    even
text_weapon_5:      dc.w     0,84
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
                    dc.b     -1
                    even
text_weapon_6:      dc.w     0,84
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
                    dc.b     -1
                    even

; -----------------------------------------------------

copperlist_blank:   dc.w     BPLCON0,$200
                    dc.w     COLOR00,0
                    dc.w     DMACON,DMAF_SPRITE
                    dc.w     $FFFF,$FFFE

copperlist_main:    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
                    dc.w     COLOR00,0
                    dc.w     BPLCON0,$5200
                    dc.w     DIWSTRT
lbW006FB6:          dc.w     $2C81
                    dc.w     DIWSTOP
lbW006FBA:          dc.w     $2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,0,BPL2MOD,0
                    dc.w     BPLCON2,$24
                    dc.w     BPLCON1,0
lbW006FD4:          dc.w     DMACON,DMAF_SETCLR|DMAF_SPRITE
                    dc.w     COLOR00
copper_palette:     dc.w     0
                    dc.w     COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0
                    dc.w     COLOR15
lbW007016:          dc.w     0
                    dc.w     COLOR16,$555,COLOR17,$565,COLOR18,$575,COLOR19,$585,COLOR20,$595,COLOR21,$5A5,COLOR22,$5B5,COLOR23,$5C5
                    dc.w     COLOR24,$5D5,COLOR25,$5E5,COLOR26,$5F5,COLOR27,$5F5,COLOR28,$5F5,COLOR29,$5F5,COLOR30,$FFF
                    dc.w     COLOR31
lbW007056:          dc.w     0
lbW007058:          dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL5PTH,0,BPL5PTL,0
                    dc.w     $3001,$FF00
                    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0
lbW0070FC:          dc.w     SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
lbW00710C:          dc.w     $FFFF,$FFFE
                    dc.w     $2C01,$FF00,COLOR15,$D0
                    dc.w     $5C01,$FF00,COLOR15,$2F2
                    dc.w     $7401,$FF00,COLOR15,$6F6
                    dc.w     $8A01,$FF00,COLOR15,$4F4
                    dc.w     $9601,$FF00,COLOR15,$1F1
                    dc.w     $9A01,$FF00,COLOR15
lbW00713E:          dc.w     0
                    dc.w     $FF01,$FF00,COLOR15,$2F2
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

sound_routine:      dc.l     0
schedule_sample_to_play:
                    dc.l     0
lbL00715E:          dc.l     0
lbL007162:          dc.l     0
briefing_text:      dc.l     0
cur_map_top:        dc.l     0
lbL00716E:          dc.l     0
gameport_register:  dc.l     0
key_pressed:        dc.l     0
owned_weapons:      dc.l     0
player_struct:      dc.l     0
lbL007182:          dc.l     1
lbL007188:          dc.l     0
cur_credits:        dc.l     0
; credits
; aliens killed
; shots fired
; (not used)
; doors opened
; ammo packs
; currently used weapon
lbL007190:          dc.l     2000000,130,1500,0,100,10
player_health:      dc.l     2
                    dc.l     7
                    dc.l     11111

lbW0071B4:          dc.w     1,VOICE_WELCOME_TO,3
                    dc.l     lbW0071BE
lbW0071BE:          dc.w     18,VOICE_INTEX_SYSTEM,3
                    dc.l     0
lbW0071C8:          dc.w     1,13,3
                    dc.l     0
lbW0071D2:          dc.w     1,13,3
                    dc.l     lbW0071DC
lbW0071DC:          dc.w     21,24,3
                    dc.l     0
lbW0071E6:          dc.w     1,13,3
                    dc.l     lbW0071F0
lbW0071F0:          dc.w     21,27,3
                    dc.l     0
lbW0071FA:          dc.w     1,13,3
                    dc.l     lbW007204
lbW007204:          dc.w     21,23,3
                    dc.l     0
lbW00720E:          dc.w     1,13,3
                    dc.l     lbW007218
lbW007218:          dc.w     21,73,3
                    dc.l     0
lbL007222:          dcb.b    2560,0

; -----------------------------------------------------

font_pic:           incbin   "font_16x504x6.raw"
background_pic:     incbin   "bkgnd_320x256x4.raw"
weapons_pic:        incbin   "weapons_264x40x4.raw"

; -----------------------------------------------------

bitplanes:          dcb.b    3280,0
lbL01DDD2:          dcb.b    1040,0
lbL01E1E2:          dcb.b    410,0
lbL01E37C:          dcb.b    4390,0
lbL01F4A2:          dcb.b    31840,0
lbL027102:          dcb.b    20480,0

                    end
