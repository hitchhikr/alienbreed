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

                    section  briefingstart,code_c

start:              move.l   #copperlist_blank,$dff080
                    move.l   a1,sound_routine
                    move.l   a0,text_to_display
                    bsr      change_palette
                    bsr      set_bps
                    bsr      display_picture
                    bsr      set_bps
                    move.l   text_to_display,a0
                    lea      font_struct,a1
                    bsr      display_text
                    bsr      wait_sync
                    lea      copper_palette,a0               ; return this to the main program
                    lea      copperlist_main,a1
                    move.w   #$C000,$dff09a
                    rts

set_bps:            lea      bitplanes,a0
                    move.l   a0,d0
                    lea      bitplanes_ptr,a0
                    move.l   #6-1,d1
.loop:              move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #40*256,d0
                    subq.w   #1,d1
                    bne.s    .loop
                    rts

display_picture:    bsr      set_bps
                    move.l   #copperlist_main,$dff080
                    lea      background_pic,a0
                    lea      bitplanes,a1
                    moveq    #8,d1
.copy_picture:      move.l   a0,a2
                    move.l   a1,a3
                    add.l    #40,a0
                    add.l    #40,a1
                    moveq    #32,d0
.copy_lines:        bsr      blit_picture_line
                    add.l    #(8*40),a2
                    add.l    #(8*40),a3
                    subq.l   #1,d0
                    bne.s    .copy_lines
                    bsr      wait_sync
                    bsr      wait_sync
                    bsr      wait_sync
                    bsr      wait_sync
                    subq.l   #1,d1
                    bne.s    .copy_picture
                    rts

wait_blitter:       
                    WAIT_BLIT
                    rts

blit_picture_line:  bsr      wait_blitter
                    move.w   #$8400,$dff096
                    move.l   #-1,$dff044
                    move.l   #$9F00000,$dff040
                    clr.l    $dff064
                    move.l   #5,d7
                    move.l   a2,a4
                    move.l   a3,a5
.loop:              move.l   a4,$dff050
                    move.l   a5,$dff054
                    move.w   #(1*64)+20,$dff058
                    bsr      wait_blitter
                    add.l    #(256*40),a4
                    add.l    #(256*40),a5
                    subq.w   #1,d7
                    bne.s    .loop
                    move.w   #$400,$dff096
                    rts

change_palette:     move.l   #copperlist_blank,$dff080
                    bsr      set_palette
                    move.l   #copperlist_main,$dff080
                    rts

wait_sync:          cmp.b    #255,$dff006
                    bne.s    wait_sync
.wait:              cmp.b    #44,$dff006
                    bne.s    .wait
                    rts

display_text:       lea      $dff000,a6
                    clr.l    d0
                    clr.l    d1
                    move.w   (a0)+,d0
                    move.w   (a0)+,d1
                    move.l   d0,d7
next_letter:        move.l   (a1),a2
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
                    beq      space_letter
                    move.l   36(a1),a3
search_letter:      cmp.b    (a3)+,d2
                    beq.s    display_letter
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.s    search_letter
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
                    bsr      pause
                    addq.w   #1,wait_play_sound
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

pause:              move.l   d0,-(sp)
                    move.l   #3000,d0
.loop:              subq.l   #1,d0
                    bne.s    .loop
                    move.l   (sp)+,d0
                    rts

wait_play_sound:    dcb.w    2,0

play_sound:         movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #48,d0
                    move.l   #0,d2
                    move.l   sound_routine,a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

font_struct:        dc.l     bitplanes,10240,5,36,8,12,80,1008
                    dc.l     font_pic
                    dc.l     ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ,1234567890.!?: ',0
                    even

set_palette:        move.l   #32,d0
                    lea      background_pic+(40*256*5),a0
                    lea      copper_palette+2,a1
.loop:              move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.w   #1,d0
                    bne.s    .loop
                    rts

copperlist_main:    dc.w     $100,$5200
                    dc.w     $8E,$2C81,$90,$2CC1
                    dc.w     $92,$38,$94,$D0
                    dc.w     $108,0,$10A,0
                    dc.w     $104,0,$102,0
copper_palette:     dc.w     $180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
                    dc.w     $190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
                    dc.w     $1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
                    dc.w     $1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0
bitplanes_ptr:      dc.w     $E0,0,$E2,0
                    dc.w     $E4,0,$E6,0
                    dc.w     $E8,0,$EA,0
                    dc.w     $EC,0,$EE,0
                    dc.w     $F0,0,$F2,0
                    dc.w     $F4,0,$F6,0
                    dc.w     $2001,$FF00
                    dc.w     $96,$20
                    dc.w     $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0,$14A,0
                    dc.w     $128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0,$158,0,$15A,0
                    dc.w     $130,0,$132,0,$160,0,$162,0,$134,0,$136,0,$168,0,$16A,0
                    dc.w     $138,0,$13A,0,$170,0,$172,0,$13C,0,$13E,0,$178,0,$17A,0
                    dc.w     $FFFF,$FFFE

copperlist_blank:   dc.w     $100,$200
                    dc.w     $180,0
                    dc.w     $96,$20
                    dc.w     $FFFF,$FFFE

text_to_display:    dc.l     0
sound_routine:      dc.l     0
bitplanes:          dcb.b    5*256*40,0

                    incdir   "src/briefingstart/gfx/"
background_pic:     incbin   "bkgnd_320x256x5.raw"
font_pic:           incbin   "font_16x504x6.raw"

                    end
