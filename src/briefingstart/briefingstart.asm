; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

                    include  "common.inc"

; -----------------------------------------------------

WAIT_BLIT           MACRO
wait\@:             btst     #DMAB_BLITTER,DMACONR(a6)
                    bne.b    wait\@
                    ENDM

; -----------------------------------------------------

                    section  briefingstart,code_c

start:              lea      CUSTOM,a6
                    move.l   #copperlist_blank,COP1LCH(a6)
                    move.l   a1,sound_routine
                    move.l   a0,text_to_display
                    bsr      change_palette
                    bsr      set_bps
                    bsr      display_picture
                    bsr      set_bps
                    move.l   text_to_display(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    bsr      wait_sync
                    lea      copper_palette(pc),a0               ; return this to the main program
                    lea      copperlist_main(pc),a1
                    move.w   #INTF_SETCLR|INTF_INTEN,INTENA(a6)
                    rts

set_bps:            lea      bitplanes(pc),a0
                    move.l   a0,d0
                    lea      bitplanes_ptr(pc),a0
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

display_picture:    bsr      set_bps
                    move.l   #copperlist_main,COP1LCH(a6)
                    lea      background_pic,a0
                    lea      bitplanes(pc),a1
                    moveq    #8,d1
.copy_picture:      move.l   a0,a2
                    move.l   a1,a3
                    add.l    #40,a0
                    add.l    #40,a1
                    moveq    #32,d0
.copy_lines:        bsr.b    blit_picture_line
                    add.l    #(8*40),a2
                    add.l    #(8*40),a3
                    subq.l   #1,d0
                    bne.b    .copy_lines
                    bsr.b    wait_sync
                    bsr.b    wait_sync
                    bsr.b    wait_sync
                    bsr.b    wait_sync
                    subq.l   #1,d1
                    bne.b    .copy_picture
                    rts

blit_picture_line:  
                    WAIT_BLIT
                    move.w   #DMAF_BLITHOG|DMAF_SETCLR,DMACON(a6)
                    move.l   #-1,BLTAFWM(a6)
                    move.l   #$9F00000,BLTCON0(a6)
                    clr.l    BLTAMOD(a6)
                    move.l   #5,d7
                    move.l   a2,a4
                    move.l   a3,a5
blit_pictures_lines:
                    move.l   a4,BLTAPTH(a6)
                    move.l   a5,BLTDPTH(a6)
                    move.w   #(1*64)+20,BLTSIZE(a6)
                    WAIT_BLIT
                    add.l    #(256*40),a4
                    add.l    #(256*40),a5
                    subq.w   #1,d7
                    bne.b    blit_pictures_lines
                    move.w   #DMAF_BLITHOG,DMACON(a6)
                    rts

change_palette:     move.l   #copperlist_blank,COP1LCH(a6)
                    bsr      set_palette
                    move.l   #copperlist_main,COP1LCH(a6)
                    rts

wait_sync:          cmp.b    #255,VHPOSR(a6)
                    bne.b    wait_sync
.wait:              cmp.b    #44,VHPOSR(a6)
                    bne.b    .wait
                    rts

display_text:       moveq    #0,d0
                    moveq    #0,d1
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
                    move.l   #$dfc0000,BLTCON0(a6)
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
                    move.l   #$ffff0000,BLTAFWM(a6)
                    move.w   d3,BLTCON1(a6)
                    or.w     #$fe2,d3
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
                    bsr      pause
                    addq.w   #1,wait_play_sound
                    cmp.w    #9,wait_play_sound
                    bne.b    space_letter
                    clr.w    wait_play_sound
                    bsr      play_sound
space_letter:       add.l    16(a1),d0
                    addq.l   #1,d0
                    tst.b    (a0)
                    bmi.b    return
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
                    bne.b    .loop
                    move.l   (sp)+,d0
                    rts

wait_play_sound:    dcb.w    2,0

play_sound:         movem.l  d0-d7/a0-a6,-(sp)
                    moveq    #48,d0
                    moveq    #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

set_palette:        moveq    #32,d0
                    lea      background_pic+(40*256*5),a0
                    lea      copper_palette+2(pc),a1
.loop:              move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.w   #1,d0
                    bne.b    .loop
                    rts

; -----------------------------------------------------

font_struct:        dc.l     bitplanes,(256*40),5,36,8,12,80,1008
                    dc.l     font_pic
                    dc.l     ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ,1234567890.!?: ',0
                    even

text_to_display:    dc.l     0
sound_routine:      dc.l     0

; -----------------------------------------------------

copperlist_main:    dc.w     BPLCON0,$5200
                    dc.w     DIWSTRT,$2C81,DIWSTOP,$2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,0,BPL2MOD,0
                    dc.w     BPLCON2,0,BPLCON1,0
copper_palette:     dc.w     COLOR00,0,COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     COLOR16,0,COLOR17,0,COLOR18,0,COLOR19,0,COLOR20,0,COLOR21,0,COLOR22,0,COLOR23,0
                    dc.w     COLOR24,0,COLOR25,0,COLOR26,0,COLOR27,0,COLOR28,0,COLOR29,0,COLOR30,0,COLOR31,0
bitplanes_ptr:      dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL5PTH,0,BPL5PTL,0
                    dc.w     $2001,$FF00
                    dc.w     DMACON,DMAF_SPRITE
                    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
                    dc.w     $FFFF,$FFFE

copperlist_blank:   dc.w     BPLCON0,$200
                    dc.w     COLOR00,0
                    dc.w     DMACON,DMAF_SPRITE
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

bitplanes:          dcb.b    256*40*5,0

; -----------------------------------------------------

background_pic:     incbin   "bkgnd_320x256x5.raw"
font_pic:           incbin   "font_16x504x6.raw"

                    end
