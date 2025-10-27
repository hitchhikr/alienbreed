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
                    move.l   a0,text_to_display
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
                    bsr      prep_fade_speeds_fade_in
                    move.l   sound_routine(pc),a0
                    moveq    #SAMPLE_DESCENT,d0
                    moveq    #0,d2
                    jsr      (a0)
.loop:              bsr      wait_sync
                    bsr      fade_palette_in
                    addq.w   #3,sprite_1_2_pos_y
                    addq.w   #3,sprite_3_4_pos_y
                    addq.w   #3,sprite_5_6_pos_y
                    addq.w   #3,sprite_7_8_pos_y
                    lea      sprite_1_2_struct(pc),a0
                    bsr      disp_sprite
                    lea      sprite_3_4_struct(pc),a0
                    bsr      disp_sprite
                    lea      sprite_5_6_struct(pc),a0
                    bsr      disp_sprite
                    lea      sprite_7_8_struct(pc),a0
                    bsr      disp_sprite
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
                    bsr      disp_sprite
                    lea      sprite_3_4_struct(pc),a0
                    bsr      disp_sprite
                    lea      sprite_5_6_struct(pc),a0
                    bsr      disp_sprite
                    lea      sprite_7_8_struct(pc),a0
                    bsr      disp_sprite
                    move.l   sound_routine(pc),a0
                    moveq    #SAMPLE_DESCENT_END,d0
                    moveq    #0,d2
                    jsr      (a0)
                    move.l   text_to_display(pc),a0
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
return:             rts

                    include  "sprite.asm"
FADE_SPEED          equ      1
                    include  "palette.asm"
                    include  "typewriter.asm"

play_sound:         movem.l  d0-d7/a0-a6,-(sp)
                    moveq    #SAMPLE_TYPE_WRITER,d0
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

font_struct:        dc.l     background_pic,(256*40),5,36,8,12,80,(16*63),font_pic,ascii_letters
sound_routine:      dc.l     0
text_to_display:    dc.l     0

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
