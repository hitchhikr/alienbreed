; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

                    include  "common.inc"

; -----------------------------------------------------

                    section  briefingcore,code_c

start:              move.l   #copperlist_blank,CUSTOM+COP1LCH
                    move.l   a1,sound_routine
                    move.l   a0,cur_text
                    cmp.l    #2,d0
                    bne.b    only_1_player
                    move.l   #(784*8),d0
                    add.l    d0,ptr_sprite_1_pic
                    add.l    d0,ptr_sprite_5_pic
                    add.l    d0,ptr_sprite_2_pic
                    add.l    d0,ptr_sprite_6_pic
                    add.l    d0,ptr_sprite_3_pic
                    add.l    d0,ptr_sprite_7_pic
                    add.l    d0,ptr_sprite_4_pic
                    add.l    d0,ptr_sprites_pic
only_1_player:      bsr      set_copperlist
                    lea      copper_palette(pc),a0
                    lea      background_pic+(40*256*5),a1
                    moveq    #32,d0
                    bsr      prep_fade_speeds
                    move.l   sound_routine(pc),a0
                    moveq    #41,d0
                    moveq    #0,d2
                    jsr      (a0)
.loop:              bsr      wait_sync
                    bsr      fade_palette
                    addq.w   #3,sprite_1_2_pos_y
                    addq.w   #3,sprite_3_4_pos_y
                    addq.w   #3,sprite_5_6_pos_y
                    addq.w   #3,sprite_7_8_pos_y
                    lea      sprite_1_2_struct(pc),a0
                    bsr      move_sprites
                    lea      sprite_3_4_struct(pc),a0
                    bsr      move_sprites
                    lea      sprite_5_6_struct(pc),a0
                    bsr      move_sprites
                    lea      sprite_7_8_struct(pc),a0
                    bsr      move_sprites
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq      .loop_end
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      .loop_end
                    cmp.w    #264,sprite_1_2_pos_y
                    blt      .loop
.loop_end:          move.w   #400,sprite_1_2_struct
                    move.w   #400,sprite_3_4_struct
                    move.w   #400,sprite_5_6_struct
                    move.w   #400,sprite_7_8_struct
                    lea      sprite_1_2_struct(pc),a0
                    bsr      move_sprites
                    lea      sprite_3_4_struct(pc),a0
                    bsr      move_sprites
                    lea      sprite_5_6_struct(pc),a0
                    bsr      move_sprites
                    lea      sprite_7_8_struct(pc),a0
                    bsr      move_sprites
                    move.l   sound_routine(pc),a0
                    moveq    #42,d0
                    moveq    #0,d2
                    jsr      (a0)
                    move.l   cur_text(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    lea      copper_palette(pc),a0
                    lea      copperlist_main(pc),a1
                    move.w   #INTF_SETCLR|INTF_INTEN,CUSTOM+INTENA
                    rts

set_bps:            lea      background_pic(pc),a0
                    move.l   a0,d0
                    lea      bitplanes(pc),a0
                    moveq    #5,d1
.loop:              move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #(256*40),d0
                    subq.w   #1,d1
                    bne.b    .loop
                    rts

set_copperlist:     move.l   #copperlist_blank,CUSTOM+COP1LCH
                    lea      sprite_1_2_struct(pc),a0
                    bsr      set_sprite_bp
                    lea      sprite_3_4_struct(pc),a0
                    bsr      set_sprite_bp
                    lea      sprite_5_6_struct(pc),a0
                    bsr      set_sprite_bp
                    lea      sprite_7_8_struct(pc),a0
                    bsr      set_sprite_bp
                    bsr      set_bps
                    move.l   #copperlist_main,CUSTOM+COP1LCH
                    rts

wait_sync:          cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    wait_sync
.wait:              cmp.b    #44,CUSTOM+VHPOSR
                    bne.b    .wait
                    rts

set_sprite_bp:      tst.l    16(a0)
                    bne.b    .set_sprite_ptr
                    move.l   12(a0),d0                          ; pic
.set_spr_copper_dat:
                    move.l   8(a0),a1                           ; bps
                    move.w   6(a0),d1                           ; properties
                    or.w     d1,14(a1)                          ; SPRxCTL
                    move.w   d0,6(a1)                           ; SPRxPTL
                    swap     d0
                    move.w   d0,2(a1)                           ; SPRxPTH
                    rts

.set_sprite_ptr:    move.l   16(a0),a1
                    move.l   a1,20(a0)
                    move.w   6(a1),24(a0)
                    move.l   (a1),d0
                    bra      .set_spr_copper_dat

move_sprites:       move.l   8(a0),a1                           ; copper
                    tst.l    16(a0)
                    bne      .animate
.set_spr_pos:       and.w    #$80,14(a1)
                    move.w   (a0),d0                            ; x coord
                    add.w    #$80,d0
                    btst     #0,d0
                    beq      .upper_x_pos_bit
                    or.w     #1,14(a1)
.upper_x_pos_bit:   lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0                           ; y coord
                    cmp.w    #240,d0
                    bmi      .max_y
                    move.w   #300,d0
.max_y:             add.w    #44,d0
                    move.w   d0,d1
                    add.w    4(a0),d1                           ; y size
                    cmp.w    #256,d1
                    bmi      .pal_bottom
                    sub.w    #255,d1
                    or.b     #2,15(a1)
.pal_bottom:        move.b   d1,14(a1)
                    cmp.w    #256,d0
                    bmi      .pal_top
                    sub.w    #255,d0
                    or.b     #4,15(a1)
.pal_top:           move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq      .done
                    move.w   10(a1),26(a1)                      ; copy pos & ctl
                    move.w   14(a1),30(a1)
                    move.w   2(a1),d0
                    swap     d0
                    move.w   6(a1),d0
                    move.w   4(a0),d1                           ; y size
                    ext.l    d1
                    add.l    d1,d1
                    add.l    d1,d1
                    addq.l   #8,d1
                    add.l    d1,d0
                    move.w   d0,22(a1)
                    swap     d0
                    move.w   d0,18(a1)
.done:              rts

.animate:           subq.w   #1,24(a0)
                    bpl      .set_spr_pos
                    addq.l   #8,20(a0)
.set_sprite_copper: move.l   20(a0),a2
                    move.l   (a2),d0
                    bmi      .reset_anim                        ; dword is -1
                    move.w   6(a2),24(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      .set_spr_pos

.reset_anim:        move.l   16(a0),20(a0)
                    bra      .set_sprite_copper

prep_fade_speeds:   lea      cur_rgb_block(pc),a4
                    moveq    #48,d2
.clear:             clr.l    (a4)+
                    subq.l   #1,d2
                    bne      .clear
                    move.l   d0,d7
                    move.l   a1,a2
                    moveq    #0,d6
                    lea      rgb_speeds_block(pc),a3
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
                    move.w   d0,colors_amount
                    move.l   a0,ptr_copper_palette
                    move.l   a1,ptr_source_palette
                    clr.w    done_fade
done_fade_palette:
                    rts

fade_palette:       tst.w    done_fade
                    bne      done_fade_palette
                    addq.w   #1,cur_frame_counter
                    move.w   cur_frame_counter(pc),d0
                    cmp.w    frames_slowdown(pc),d0
                    bmi      done_fade_palette
                    clr.w    cur_frame_counter
                    move.l   ptr_copper_palette(pc),a0
                    move.l   ptr_source_palette(pc),a1
                    moveq    #0,d0
                    move.w   colors_amount(pc),d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      rgb_speeds_block(pc),a2
                    lea      cur_rgb_block(pc),a3
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
.fade_red:          addq.l   #2,a2
                    addq.l   #2,a3
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
.fade_green:        addq.l   #2,a2
                    addq.l   #2,a3
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
.fade_blue:         addq.l   #2,a2
                    addq.l   #2,a3
                    subq.w   #1,d1
                    bne      .loop
                    cmp.l    d6,d7
                    bne      .fade_end
                    move.w   #1,done_fade
.fade_end:          rts

                    include  "typewriter.asm"

play_sound:         movem.l  d0-d7/a0-a6,-(sp)
                    moveq    #48,d0
                    moveq    #2,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

; -----------------------------------------------------

sprite_1_2_struct:  dc.w     27                                 ; 0
sprite_1_2_pos_y:   dc.w     -32                                ; 2
                    dc.w     96                                 ; 4
                    dc.w     128                                ; 6
                    dc.l     sprites_1_2_bps                    ; 8
                    dc.l     sprite_1_pic                       ; 12
                    dc.l     ptr_sprite_1_pic                   ; 16
                    dc.l     0                                  ; 20
                    dc.w     0                                  ; 24
                    dc.w     0                                  ; 26
sprite_3_4_struct:  dc.w     43
sprite_3_4_pos_y:   dc.w     -32,96,128
                    dc.l     sprites_3_4_bps
                    dc.l     sprite_1_pic
                    dc.l     ptr_sprite_2_pic
                    dc.l     0
                    dc.w     0
                    dc.w     0
sprite_5_6_struct:  dc.w     59
sprite_5_6_pos_y:   dc.w     -32,96,128
                    dc.l     sprites_5_6_bps
                    dc.l     sprite_1_pic
                    dc.l     ptr_sprite_3_pic
                    dc.l     0
                    dc.w     0
                    dc.w     0
sprite_7_8_struct:  dc.w     75
sprite_7_8_pos_y:   dc.w     -32,96,128
                    dc.l     sprites_7_8_bps
                    dc.l     sprite_1_pic
                    dc.l     ptr_sprite_4_pic
                    dc.l     0
                    dc.w     0
                    dc.w     0

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

frames_slowdown:    dc.w     1
cur_frame_counter:  dc.w     0
done_fade:          dc.w     0
colors_amount:      dc.w     0
ptr_source_palette: dc.l     0
ptr_copper_palette: dc.l     0
rgb_speeds_block:   dcb.w    (32*3),0
cur_rgb_block:      dcb.w    (32*3),0
font_struct:        dc.l     background_pic,(256*40),5,36,8,12,80,(16*63),font_pic,ascii_letters
sound_routine:      dc.l     0
cur_text:           dc.l     0

; -----------------------------------------------------

copperlist_main:    dc.w     DMACON,DMAF_SETCLR|DMAF_SPRITE
                    dc.w     $501,$FF00
                    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
                    dc.w     BPLCON0,$5200
                    dc.w     DIWSTRT,$2C81,DIWSTOP,$2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,0,BPL2MOD,0
                    dc.w     BPLCON2,$24,BPLCON1,0
copper_palette:     dc.w     COLOR00,0,COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     COLOR16,0,COLOR17,0,COLOR18,0,COLOR19,0,COLOR20,0,COLOR21,0,COLOR22,0,COLOR23,0
                    dc.w     COLOR24,0,COLOR25,0,COLOR26,0,COLOR27,0,COLOR28,0,COLOR29,0,COLOR30,0,COLOR31,0
bitplanes:          dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL5PTH,0,BPL5PTL,0
                    dc.w     $1A01,$FF00
sprites_1_2_bps:    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
sprites_3_4_bps:    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
sprites_5_6_bps:    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
sprites_7_8_bps:    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
                    dc.w     $FFFF,$FFFE

copperlist_blank:   dc.w     BPLCON0,$200
                    dc.w     COLOR00,0
                    dc.w     DMACON,DMAF_SPRITE
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

sprite_1_pic:       incbin   "sprite1.raw"
sprite_2_pic:       incbin   "sprite2.raw"
sprite_3_pic:       incbin   "sprite3.raw"
sprite_4_pic:       incbin   "sprite4.raw"
sprite_5_pic:       incbin   "sprite5.raw"
sprite_6_pic:       incbin   "sprite6.raw"
sprite_7_pic:       incbin   "sprite7.raw"
sprites_pic:        incbin   "sprites.raw"
background_pic:     incbin   "bkgnd_320x256.lo5"
font_pic:           incbin   "font_16x504.lo6"

                    end
