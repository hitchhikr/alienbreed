WAIT_BLIT           MACRO
wait\@:             btst     #14,$dff002
                    bne.s    wait\@
                    ENDM

                    section  briefingcore,code_c
start:
                    move.l   #copperlist_blank,$dff080
                    move.l   a1,sound_routine
                    move.l   a0,cur_text
                    cmp.l    #2,d0
                    bne      only_1_player
                    move.l   #6272,d0
                    add.l    d0,ptr_sprite_1_pic
                    add.l    d0,ptr_sprite_5_pic
                    add.l    d0,ptr_sprite_2_pic
                    add.l    d0,ptr_sprite_6_pic
                    add.l    d0,ptr_sprite_3_pic
                    add.l    d0,ptr_sprite_7_pic
                    add.l    d0,ptr_sprite_4_pic
                    add.l    d0,ptr_sprites_pic
only_1_player:      bsr      set_copperlist
                    lea      color_palette,a0
                    lea      background_pic+(40*256*5),a1
                    move.l   #32,d0
                    bsr      lbC0005B6
                    move.l   sound_routine,a0
                    move.l   #41,d0
                    move.l   #0,d2
                    jsr      (a0)
.loop:              bsr      wait_sync
                    bsr      fade_palette
                    addq.w   #3,sprite_1_2_pos
                    addq.w   #3,sprite_3_4_pos
                    addq.w   #3,sprite_5_6_pos
                    addq.w   #3,sprite_7_8_pos
                    lea      sprite_1_2_struct,a0
                    bsr      move_sprites
                    lea      sprite_3_4_struct,a0
                    bsr      move_sprites
                    lea      sprite_5_6_struct,a0
                    bsr      move_sprites
                    lea      sprite_7_8_struct,a0
                    bsr      move_sprites
                    btst     #6,$bfe001
                    beq      .loop_end
                    btst     #7,$bfe001
                    beq      .loop_end
                    cmp.w    #264,sprite_1_2_pos
                    blt      .loop
.loop_end:          move.w   #400,sprite_1_2_struct
                    move.w   #400,sprite_3_4_struct
                    move.w   #400,sprite_5_6_struct
                    move.w   #400,sprite_7_8_struct
                    lea      sprite_1_2_struct,a0
                    bsr      move_sprites
                    lea      sprite_3_4_struct,a0
                    bsr      move_sprites
                    lea      sprite_5_6_struct,a0
                    bsr      move_sprites
                    lea      sprite_7_8_struct,a0
                    bsr      move_sprites
                    move.l   sound_routine,a0
                    move.l   #42,d0
                    move.l   #0,d2
                    jsr      (a0)
                    move.l   cur_text,a0
                    lea      font_struct,a1
                    bsr      display_text
                    lea      color_palette,a0
                    lea      copperlist_main,a1
                    move.w   #$C000,$dff09a
                    rts

set_bps:            lea      background_pic,a0
                    move.l   a0,d0
                    lea      bitplanes,a0
                    move.l   #5,d1
.loop:              move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #$2800,d0
                    subq.w   #1,d1
                    bne.s    .loop
                    rts

set_copperlist:     move.l   #copperlist_blank,$dff080
                    lea      sprite_1_2_struct,a0
                    bsr      set_sprite_bp
                    lea      sprite_3_4_struct,a0
                    bsr      set_sprite_bp
                    lea      sprite_5_6_struct,a0
                    bsr      set_sprite_bp
                    lea      sprite_7_8_struct,a0
                    bsr      set_sprite_bp
                    bsr      set_bps
                    move.l   #copperlist_main,$dff080
                    rts

wait_sync:          cmp.b    #255,$dff006
                    bne.s    wait_sync
.wait:              cmp.b    #44,$dff006
                    bne.s    .wait
                    rts

set_sprite_bp:      tst.l    16(a0)
                    bne.s    lbC000244
                    move.l   12(a0),d0
lbC00022C:          move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

lbC000244:          move.l   16(a0),a1
                    move.l   a1,20(a0)
                    move.w   6(a1),24(a0)
                    move.l   (a1),d0
                    bra      lbC00022C

move_sprites:       move.l   8(a0),a1
                    tst.l    16(a0)
                    bne      lbC0002FA
lbC000264:          and.w    #128,14(a1)
                    move.w   0(a0),d0
                    add.w    #128,d0
                    btst     #0,d0
                    beq.s    lbC00027E
                    or.w     #1,14(a1)
lbC00027E:          lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    cmp.w    #240,d0
                    bmi.s    lbC000292
                    move.w   #300,d0
lbC000292:          add.w    #44,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #256,d1
                    bmi.s    lbC0002AC
                    sub.w    #255,d1
                    or.b     #2,15(a1)
lbC0002AC:          move.b   d1,14(a1)
                    cmp.w    #256,d0
                    bmi.s    lbC0002C0
                    sub.w    #255,d0
                    or.b     #4,15(a1)
lbC0002C0:          move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.s    lbC0002F8
                    move.w   10(a1),26(a1)
                    move.w   14(a1),30(a1)
                    move.w   2(a1),d0
                    swap     d0
                    move.w   6(a1),d0
                    move.w   4(a0),d1
                    ext.l    d1
                    add.l    d1,d1
                    add.l    d1,d1
                    addq.l   #8,d1
                    add.l    d1,d0
                    move.w   d0,22(a1)
                    swap     d0
                    move.w   d0,18(a1)
lbC0002F8:          rts

lbC0002FA:          subq.w   #1,24(a0)
                    bpl      lbC000264
                    addq.l   #8,20(a0)
lbC000306:          move.l   20(a0),a2
                    move.l   (a2),d0
                    bmi.s    lbC000324
                    move.w   6(a2),24(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      lbC000264

lbC000324:          move.l   16(a0),20(a0)
                    bra.s    lbC000306

sprite_1_2_struct:  dc.w     27
sprite_1_2_pos:     dc.w     $FFE0,96,128
                    dc.l     sprites_1_2_bps
                    dc.l     sprite_1_pic
                    dc.l     ptr_sprite_1_pic
                    dcb.w    4,0
sprite_3_4_struct:  dc.w     43
sprite_3_4_pos:     dc.w     $FFE0,96,128
                    dc.l     sprites_3_4_bps
                    dc.l     sprite_1_pic
                    dc.l     ptr_sprite_2_pic
                    dcb.w    4,0
sprite_5_6_struct:  dc.w     59
sprite_5_6_pos:     dc.w     $FFE0,96,128
                    dc.l     sprites_5_6_bps
                    dc.l     sprite_1_pic
                    dc.l     ptr_sprite_3_pic
                    dcb.w    4,0
sprite_7_8_struct:  dc.w     75
sprite_7_8_pos:     dc.w     $FFE0,96,128
                    dc.l     sprites_7_8_bps
                    dc.l     sprite_1_pic
                    dc.l     ptr_sprite_4_pic
                    dcb.w    4,0

ptr_sprite_1_pic:   dc.l    sprite_1_pic,0
ptr_sprite_5_pic:   dc.l    sprite_5_pic,0
                    dc.l    -1
ptr_sprite_2_pic:   dc.l    sprite_2_pic,0
ptr_sprite_6_pic:   dc.l    sprite_6_pic,0
                    dc.l    -1
ptr_sprite_3_pic:   dc.l    sprite_3_pic,0
ptr_sprite_7_pic:   dc.l    sprite_7_pic,0
                    dc.l    -1
ptr_sprite_4_pic:   dc.l    sprite_4_pic,0
ptr_sprites_pic:    dc.l    sprites_pic,0
                    dc.l    -1

lbC0005B6:          move.w   #2,lbW000902
                    lea      lbL000A36,a4
                    move.l   #48,d2
.clear:             clr.l    (a4)+
                    subq.l   #1,d2
                    bne      .clear
                    move.l   d0,d7
                    move.l   a1,a2
                    clr.l    d6
                    lea      lbL000976,a3
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
                    move.w   d0,lbW00090A
                    move.l   a0,lbL000910
                    move.l   a1,lbL00090C
                    clr.w    done_fade
                    rts

fade_palette:       cmp.w    #2,lbW000902
                    bne      return
                    tst.w    done_fade
                    bne      return
                    add.w    #1,lbW000906
                    move.w   lbW000906,d0
                    cmp.w    lbW000904,d0
                    bmi      return
                    clr.w    lbW000906
                    move.l   lbL000910,a0
                    move.l   lbL00090C,a1
                    clr.l    d0
                    move.w   lbW00090A,d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      lbL000976,a2
                    lea      lbL000A36,a3
                    move.l   d6,d7
                    move.l   d0,d1
.loop:              addq.l   #4,a0
                    addq.l   #2,a1
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F00,d2
                    and.w    #$F00,d3
                    cmp.w    d2,d3
                    beq      .fade_red
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
.fade_red:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq      .fade_green
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
.fade_green:        add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F,d2
                    and.w    #$F,d3
                    cmp.w    d2,d3
                    beq      .fade_blue
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
.fade_blue:         add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      .loop
                    cmp.l    d6,d7
                    bne      lbC000742
                    move.w   #1,done_fade
                    clr.w    lbW000902
lbC000742:          rts

lbW000902:          dc.w     0
lbW000904:          dc.w     1
lbW000906:          dc.w     0
done_fade:          dc.w     0
lbW00090A:          dc.w     0
lbL00090C:          dc.l     0
lbL000910:          dc.l     0
lbL000914:          dcb.l    24,0
lbL000976:          dcb.l    48,0
lbL000A36:          dcb.l    48,0

display_text:       lea      $dff000,a6
                    clr.l    d0
                    clr.l    d1
                    move.w   (a0)+,d0
                    move.w   (a0)+,d1
                    move.l   d0,d7
next_letter:        move.l   0(a1),a2
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
                    move.l   36(a1),a3
.loop:              cmp.b    (a3)+,d2
                    beq.s    display_letter
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.s    .loop
                    bra      return

display_letter:     move.l   32(a1),a3
                    add.l    d4,a3
                    WAIT_BLIT
                    move.l   #$1000000,$40(a6)
                    move.l   #letter_buffer,$54(a6)
                    move.w   #2,$66(a6)
                    move.w   #(16*64)+1,$58(a6)
                    WAIT_BLIT
                    move.l   8(a1),d2
                    move.l   28(a1),d5
                    move.l   #letter_buffer,d4
                    move.l   #-1,$44(a6)
                    move.l   #$dfc0000,$40(a6)
                    move.l   24(a1),d6
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
                    move.l   #$ffff0000,$44(a6)
                    move.w   d3,$dff042
                    or.w     #$fe2,d3
                    move.w   d3,$40(a6)
                    clr.w    $62(a6)
                    move.w   26(a1),$64(a6)
                    move.w   14(a1),$66(a6)
                    move.w   14(a1),$60(a6)
                    move.l   8(a1),d5
                    move.l   4(a1),d2
                    move.l   28(a1),d3
                    move.l   #letter_buffer,d4
                    move.w   22(a1),d6
                    lsl.w    #6,d6
                    add.w    #2,d6
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
                    bsr      pause
                    add.w    #1,wait_play_sound
                    cmp.w    #9,wait_play_sound
                    bne      space_letter
                    clr.w    wait_play_sound
                    bsr      play_sound
space_letter:       add.l    16(a1),d0
                    addq.l   #1,d0
                    tst.b    (a0)
                    bmi      return
                    bne      next_letter
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    20(a1),d1
                    bra      next_letter

return:             rts

letter_buffer:      dcb.l    32,0
wait_play_sound:    dcb.w    2,0

pause:              move.l   d0,-(sp)
                    move.l   #3000,d0
.loop:              subq.l   #1,d0
                    bne.s    .loop
                    move.l   (sp)+,d0
                    rts

play_sound:         movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #48,d0
                    move.l   #2,d2
                    move.l   sound_routine,a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

font_struct:        dc.l     background_pic,10240,5,36,8,12,80,1008
                    dc.l     font_pic
                    dc.l     ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ,1234567890.!?: ',0
                    even

copperlist_main:    dc.w    $96,$8020
                    dc.w    $501,$FF00
                    dc.w    $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0
                    dc.w    $14A,0,$128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0
                    dc.w    $158,0,$15A,0,$130,0,$132,0,$160,0,$162,0,$134,0
                    dc.w    $136,0,$168,0,$16A,0,$138,0,$13A,0,$170,0,$172,0
                    dc.w    $13C,0,$13E,0,$178,0,$17A,0
                    dc.w    $100,$5200
                    dc.w    $8E,$2C81,$90,$2CC1
                    dc.w    $92,$38,$94,$D0
                    dc.w    $108,0,$10A,0
                    dc.w    $104,$24,$102,0
color_palette:      dc.w    $180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
                    dc.w    $190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
                    dc.w    $1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
                    dc.w    $1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0
bitplanes:          dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $E8,0,$EA,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F0,0,$F2,0
                    dc.w    $F4,0,$F6,0
                    dc.w    $1A01,$FF00
sprites_1_2_bps:    dc.w    $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0,$14A,0
sprites_3_4_bps:    dc.w    $128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0,$158,0,$15A,0
sprites_5_6_bps:    dc.w    $130,0,$132,0,$160,0,$162,0,$134,0,$136,0,$168,0,$16A,0
sprites_7_8_bps:    dc.w    $138,0,$13A,0,$170,0,$172,0,$13C,0,$13E,0,$178,0,$17A,0
                    dc.w    $FFFF,$FFFE

copperlist_blank:   dc.w    $100,$200
                    dc.w    $180,0
                    dc.w    $96,$20
                    dc.w    $FFFF,$FFFE

sound_routine:      dc.l     0
cur_text:           dc.l     0

sprite_1_pic:       incbin  "briefingcore/gfx/sprite1.raw"
sprite_2_pic:       incbin  "briefingcore/gfx/sprite2.raw"
sprite_3_pic:       incbin  "briefingcore/gfx/sprite3.raw"
sprite_4_pic:       incbin  "briefingcore/gfx/sprite4.raw"
sprite_5_pic:       incbin  "briefingcore/gfx/sprite5.raw"
sprite_6_pic:       incbin  "briefingcore/gfx/sprite6.raw"
sprite_7_pic:       incbin  "briefingcore/gfx/sprite7.raw"
sprites_pic:        incbin  "briefingcore/gfx/sprites.raw"
background_pic:     incbin  "briefingcore/gfx/bkgnd_320x256x5.raw"
font_pic:           incbin  "briefingcore/gfx/font_16x504x6.raw"

                    end
