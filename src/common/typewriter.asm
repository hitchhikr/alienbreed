; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

display_text:       lea      CUSTOM,a6
                    moveq    #0,d0
                    moveq    #0,d1
                    move.w   (a0)+,d0                               ; x
                    move.w   (a0)+,d1                               ; y
                    move.l   d0,d7
next_letter:        move.l   (a1),a2                                ; dest
                    move.l   d0,d2
                    move.l   d2,d3
                    and.w    #$F,d3
                    swap     d3
                    lsr.l    #4,d3
                    and.w    #$F000,d3
                    lsr.l    #3,d2
                    add.l    d2,a2
                    move.l   TEXT_DEST_WIDTH(a1),d2
                    addq.l   #4,d2
                    mulu     d1,d2
                    add.l    d2,a2
                    moveq    #0,d4
                    move.b   (a0)+,d2
                    cmp.b    #' ',d2
                    beq      space_letter
                    move.l   TEXT_ASCII_LETTERS(a1),a3
search_letter:      cmp.b    (a3)+,d2
                    beq.b    display_letter
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.b    search_letter
                    bra      done_text

display_letter:     move.l   TEXT_FONT_PIC(a1),a3
                    add.l    d4,a3
                    WAIT_BLIT
                    move.l   #$1000000,BLTCON0(a6)
                    move.l   #letter_buffer,BLTDPTH(a6)
                    move.w   #2,BLTDMOD(a6)
                    move.w   #(16*64)+1,BLTSIZE(a6)
                    WAIT_BLIT
                    move.l   TEXT_DEST_BPS(a1),d2
                    move.l   TEXT_FONT_BP_SIZE(a1),d5
                    move.l   #letter_buffer,d4
                    move.l   #-1,BLTAFWM(a6)
                    move.l   #$DFC0000,BLTCON0(a6)
                    move.l   TEXT_FONT_MODULO(a1),d6
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
                    move.w   TEXT_FONT_MODULO+2(a1),BLTAMOD(a6)
                    move.w   TEXT_DEST_WIDTH+2(a1),BLTDMOD(a6)
                    move.w   TEXT_DEST_WIDTH+2(a1),BLTCMOD(a6)
                    move.l   TEXT_DEST_BPS(a1),d5
                    move.l   TEXT_DEST_BP_SIZE(a1),d2
                    move.l   TEXT_FONT_BP_SIZE(a1),d3
                    move.l   #letter_buffer,d4
                    move.w   TEXT_LETTER_HEIGHT+2(a1),d6
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
space_letter:       add.l    TEXT_LETTER_WIDTH(a1),d0
                    addq.l   #1,d0
                    tst.b    (a0)
                    bmi.b    done_text
                    bne      next_letter
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    TEXT_LETTER_HEIGHT(a1),d1
                    bra      next_letter

done_text:          rts

letter_buffer:      dcb.l    (16*2),0
wait_play_sound:    dc.w     0
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ,1234567890.!?: ',0
                    even

pause:              move.l   d0,-(sp)
                    move.l   #3000,d0
.loop:              subq.l   #1,d0
                    bne.b    .loop
                    move.l   (sp)+,d0
                    rts
