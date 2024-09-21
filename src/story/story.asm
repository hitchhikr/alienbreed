; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

                    include  "common.inc"

; -----------------------------------------------------

                    section  story,code_c

start:              bsr      set_planet_pic
                    bsr      fade_in_planet
main_loop:          bsr      wait_frame_joystick
                    bsr      scroll_blit_text
                    tst.w    end_text_flag
                    beq      main_loop
                    bsr      fade_out_planet
                    tst.w    exit_flag
                    bne      exit
                    bsr      display_title_screen
                    bsr      display_beam_title
exit:               move.l   #copperlist_blank,CUSTOM+COP1LCH
                    move.l   exit_flag(pc),d0
                    rts

set_planet_pic:     lea      planet_bps(pc),a0
                    move.l   #planet_pic,d0
                    moveq    #4,d1
                    move.l   #(256*40),d2
                    bsr      set_bps
                    lea      text_bps(pc),a0
                    move.l   #text_bitplane1,d0
                    moveq    #2,d1
                    move.l   #(256*40),d2
                    bsr      set_bps
                    move.l   #copperlist_planet,CUSTOM+COP1LCH
                    rts

wait_x_frames:      btst     #CIAB_GAMEPORT1,CIAA
                    beq      bail_out
                    bsr      wait_frame_joystick
                    subq.w   #1,d0
                    bne.b    wait_x_frames
                    rts

bail_out:           move.w   #1,end_text_flag
                    move.l   #-1,exit_flag
                    rts

wait_frame_joystick:
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      bail_out
                    cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    wait_frame_joystick
.wait:              cmp.b    #0,CUSTOM+VHPOSR
                    bne.b    .wait
                    rts

wait_frame:         cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    wait_frame
.wait:              cmp.b    #0,CUSTOM+VHPOSR
                    bne.b    .wait
                    rts

display_title_screen:
                    lea      title_bps(pc),a0
                    move.l   #title_pic,d0
                    moveq    #5,d1
                    move.l   #(256*40),d2
                    bsr      set_bps
                    lea      color_palette_dark(pc),a0
                    lea      colors_down(pc),a1
                    moveq    #32,d0
                    bsr      lbC00089E
                    bsr      wait_frame_joystick
                    move.l   #copperlist_title,CUSTOM+COP1LCH
                    move.w   #4,lbW000BEC
                    moveq    #52,d0
.move:              bsr      wait_frame
                    move.l   d0,-(sp)
                    bsr      lbC00091A
                    move.l   (sp)+,d0
                    subq.b   #4,diwstrt
                    subq.w   #1,d0
                    bne.b    .move
                    move.b   #$2C,diwstrt
                    rts

display_beam_title: move.w   #$8020,CUSTOM+DMACON
                    lea      lbW000EFA(pc),a0
                    bsr      set_sprite_bp
                    lea      lbW000EFA(pc),a0
                    bsr      lbC000E14
                    lea      lbW001336(pc),a0
                    lea      color_palette_light(pc),a1
                    moveq    #32,d0
                    bsr      set_palette
                    moveq    #0,d0
                    moveq    #0,d1
                    move.l   #$2D01FF00,pos_copper_dark_pal
                    lea      lbW000EFA(pc),a0
move_beam:          movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW000EFA(pc),a0
                    add.w    #48,(a0)
                    cmp.w    #320,(a0)
                    bmi.b    lbC0001E2
                    clr.w    (a0)
lbC0001E2:          add.w    d1,(a0)
                    cmp.w    #243,d0
                    bne.b    lbC0001EE
                    move.w   #244,d0
lbC0001EE:          move.w   d0,2(a0)
                    bsr      lbC000E14
                    movem.l  (sp)+,d0-d7/a0-a6
                    addq.w   #1,d1
                    cmp.w    #32,d1
                    bne.b    lbC000204
                    clr.w    d1
lbC000204:          bsr      wait_frame_joystick
                    add.l    #$1000000,pos_copper_beam_line
                    add.l    #$1000000,pos_copper_dark_pal
                    cmp.l    #$1FF00,pos_copper_beam_line
                    bne.b    reached_pal
                    move.l   #$FFE1FFFE,copper_pal_line
reached_pal:        addq.w   #1,d0
                    cmp.w    #$FF,d0
                    bne.b    move_beam
                    lea      lbW000EFA(pc),a0
                    move.w   #336,(a0)
                    bsr      lbC000E14
                    move.l   #300,d0
                    bsr      wait_x_frames
                    tst.l    exit_flag
                    beq.b    lbC000260
                    addq.l   #4,sp
                    bra      exit

lbC000260:          move.w   #2,lbW000BEC
                    lea      lbW001336(pc),a0
                    lea      colors_up(pc),a1
                    lea      color_palette_light(pc),a2
                    moveq    #32,d0
                    bsr      lbC000706
                    bsr      lbC0002AA
                    lea      colors_up(pc),a0
                    lea      lbL0013F6,a1
                    lea      color_palette_light(pc),a2
                    moveq    #32,d0
                    bsr      lbC000706
                    ; no rts

lbC0002AA:          btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    lbC0002D0
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    lbC0002D0
                    bsr      wait_frame_joystick
                    bsr      lbC0007B8
                    tst.w    lbW000BF0
                    beq.b    lbC0002AA
                    rts

lbC0002D0:          move.w   #1,end_text_flag
                    move.l   #-1,exit_flag
                    move.w   #1,lbW000BF0
                    rts

set_palette:        move.w   (a0)+,2(a1)
                    addq.l   #4,a1
                    subq.w   #1,d0
                    bne.b    set_palette
                    rts

set_bps:            move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    d2,d0
                    addq.l   #8,a0
                    subq.w   #1,d1
                    bne.b    set_bps
                    rts

scroll_blit_text:   not.w    scroll_slown_down
                    beq     scroll_text
                    WAIT_BLIT
                    move.w   #$8400,CUSTOM+DMACON
                    clr.l    CUSTOM+BLTAMOD
                    move.l   #text_bitplane1+40,CUSTOM+BLTAPTH
                    move.l   #text_bitplane1,CUSTOM+BLTDPTH
                    move.l   #-1,CUSTOM+BLTAFWM
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.w   #(255*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    move.l   #text_bitplane2+40,CUSTOM+BLTAPTH
                    move.l   #text_bitplane2,CUSTOM+BLTDPTH
                    move.w   #(255*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    move.w   #$400,CUSTOM+DMACON
                    rts

scroll_text:        addq.w   #1,lbW00045C
                    cmp.w    #6,lbW00045C
                    beq      lbC000446
                    cmp.w    #12,lbW00045C
                    bmi      return
                    clr.w    lbW00045C
                    addq.w   #1,pause_scroll
                    cmp.w    #18,pause_scroll
                    bmi.b    lbC0003D6
                    clr.w    pause_scroll
                    move.l   #500,d0
                    bsr      wait_x_frames
lbC0003D6:          move.l   text_ptr,a0
                    moveq    #17,d0
                    lea      lbL01D372,a1
lbC0003E8:          move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    lbC0003E8
                    move.l   text_ptr,a0
                    add.l    #17,a0
                    moveq    #18,d0
                    lea      lbL01D38A,a1
lbC000406:          move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    lbC000406
                    add.l    #35,text_ptr
                    move.l   text_ptr,a0
                    tst.b    (a0)
                    bpl.b    reset_text
                    move.l   #text_story,text_ptr
                    move.w   #1,end_text_flag
reset_text:         lea      lbL01D36E,a0
                    lea      font_struct(pc),a1
                    bra.b    display_text

lbC000446:          lea      lbL01D386,a0
                    lea      font_struct(pc),a1
                    bra.b    display_text

pause_scroll:       dc.w     0
scroll_slown_down:  dc.w     0
lbW00045C:          dc.w     0

display_text:       lea      CUSTOM,a6
                    moveq    #0,d0
                    moveq    #0,d1
                    move.w   (a0)+,d0
                    move.w   (a0)+,d1
                    move.l   d0,d7
next_letter:        move.l   0(a1),a2
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
                    moveq    #0,d4
                    move.b   (a0)+,d2
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
                    move.l   #$DFC0000,BLTCON0(a6)
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
                    move.l   #$FFFF0000,BLTAFWM(a6)
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
                    add.w    #2,d6
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
                    add.l    16(a1),d0
                    tst.b    (a0)
                    bmi.b    return
                    bne      next_letter
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    20(a1),d1
                    bra      next_letter

return:             rts

letter_buffer:      dcb.l    32,0
font_struct:        dc.l     text_bitplane1,(256*40),2,36,9,11,80,924
                    dc.l     font_pic
                    dc.l     ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ,1234567890.!?: ',0
                    even

fade_out_planet:    lea      color_palette_planet(pc),a0
                    lea      colors_planet(pc),a1
                    moveq    #32,d0
                    bsr      lbC000A2C
lbC0006B2:          bsr      wait_frame_joystick
                    bsr      lbC000AF8
                    tst.w    lbW000BF0
                    beq.b    lbC0006B2
                    rts

fade_in_planet:     lea      color_palette_planet(pc),a0
                    lea      colors_planet(pc),a1
                    moveq    #32,d0
                    bsr      lbC00089E
lbC0006DC:          bsr      wait_frame_joystick
                    bsr      lbC00091A
                    tst.w    lbW000BF0
                    beq.b    lbC0006DC
                    rts

lbC000706:          movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #1,lbW000BEA
                    move.w   d0,lbW000BF2
                    move.l   a1,lbL000BF4
                    move.l   a2,lbL000BF8
                    move.l   a0,a2
                    lea      lbL000BFC(pc),a3
                    move.w   lbW000BF2(pc),d0
lbC000732:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bmi.b    lbC000748
                    bhi.b    lbC00074E
                    clr.b    (a3)+
                    bra.b    lbC000752

lbC000748:          move.b   #-1,(a3)+
                    bra.b    lbC000752

lbC00074E:          move.b   #1,(a3)+
lbC000752:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bmi.b    lbC000768
                    bhi.b    lbC00076E
                    clr.b    (a3)+
                    bra.b    lbC000772

lbC000768:          move.b   #-1,(a3)+
                    bra.b    lbC000772

lbC00076E:          move.b   #1,(a3)+
lbC000772:          move.w   (a2)+,d1
                    move.w   (a1)+,d2
                    and.w    #15,d1
                    and.w    #15,d2
                    cmp.w    d1,d2
                    bmi.b    lbC000788
                    bhi.b    lbC00078E
                    clr.b    (a3)+
                    bra.b    lbC000792

lbC000788:          move.b   #-1,(a3)+
                    bra.b    lbC000792

lbC00078E:          move.b   #1,(a3)+
lbC000792:          subq.b   #1,d0
                    bne.b    lbC000732
                    move.l   lbL000BF8(pc),a2
                    move.w   lbW000BF2(pc),d0
                    addq.l   #2,a2
lbC0007A4:          move.w   (a0)+,(a2)
                    addq.l   #4,a2
                    subq.b   #1,d0
                    bne.b    lbC0007A4
                    clr.w    lbW000BF0
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC0007B8:          cmp.w    #1,lbW000BEA
                    bne      return_2
                    tst.w    lbW000BF0
                    bne      return_2
                    moveq    #0,d7
                    add.w    #1,lbW000BEE
                    move.w   lbW000BEE(pc),d0
                    cmp.w    lbW000BEC(pc),d0
                    bmi      return_2
                    clr.w    lbW000BEE
                    move.w   lbW000BF2(pc),d0
                    move.l   lbL000BF8(pc),a0
                    move.l   lbL000BF4(pc),a1
                    lea      lbL000BFC(pc),a3
                    addq.l   #2,a0
lbC000808:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bne.b    lbC00081E
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    lbC00082C

lbC00081E:          move.b   (a3)+,d3
                    lsr.w    #8,d1
                    add.b    d3,d1
                    lsl.w    #8,d1
                    and.w    #$FF,(a0)
                    or.w     d1,(a0)
lbC00082C:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bne.b    lbC000842
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    lbC000850

lbC000842:          move.b   (a3)+,d3
                    lsr.w    #4,d1
                    add.b    d3,d1
                    lsl.w    #4,d1
                    and.w    #$F0F,(a0)
                    or.w     d1,(a0)
lbC000850:          move.w   (a0),d1
                    move.w   (a1)+,d2
                    and.w    #$F,d1
                    and.w    #$F,d2
                    cmp.w    d1,d2
                    bne.b    lbC000866
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    lbC000870

lbC000866:          move.b   (a3)+,d3
                    add.b    d3,d1
                    and.w    #$FF0,(a0)
                    or.w     d1,(a0)
lbC000870:          addq.l   #4,a0
                    subq.b   #1,d0
                    bne.b    lbC000808
                    divu     #3,d7
                    cmp.w    lbW000BF2(pc),d7
                    bne.b    lbC000890
                    move.w   #1,lbW000BF0
                    clr.w    lbW000BEA
lbC000890:          rts

                    addq.l   #2,a1
lbC000894:          move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #2,d0
                    bne.b    lbC000894
                    rts

lbC00089E:          move.w   #2,lbW000BEA
                    lea      lbL000D1E(pc),a4
                    moveq    #48,d2
lbC0008B2:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC0008B2
                    move.l   d0,d7
                    move.l   a1,a2
                    moveq    #0,d6
                    lea      lbL000C5E(pc),a3
lbC0008C6:          move.w   (a2),d6
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
                    bne      lbC0008C6
                    move.l   d1,d4
                    subq.l   #2,a0
                    subq.l   #2,a1
                    move.w   d0,lbW000BF2
                    move.l   a0,lbL000BF8
                    move.l   a1,lbL000BF4
                    clr.w    lbW000BF0
                    rts

lbC00091A:          cmp.w    #2,lbW000BEA
                    bne      return_2
                    tst.w    lbW000BF0
                    bne      return_2
                    add.w    #1,lbW000BEE
                    move.w   lbW000BEE(pc),d0
                    cmp.w    lbW000BEC(pc),d0
                    bmi      return_2
                    clr.w    lbW000BEE
                    move.l   lbL000BF8(pc),a0
                    move.l   lbL000BF4(pc),a1
                    moveq    #0,d0
                    move.w   lbW000BF2(pc),d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      lbL000C5E(pc),a2
                    lea      lbL000D1E(pc),a3
                    move.l   d6,d7
                    move.l   d0,d1
lbC000978:          addq.l   #4,a0
                    addq.l   #2,a1
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F00,d2
                    and.w    #$F00,d3
                    cmp.w    d2,d3
                    beq      lbC0009A0
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC0009A0:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq      lbC0009D2
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC0009D2:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #15,d2
                    and.w    #15,d3
                    cmp.w    d2,d3
                    beq      lbC000A04
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC000A04:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC000978
                    cmp.l    d6,d7
                    bne.b    lbC000A2A
                    move.w   #1,lbW000BF0
                    clr.w    lbW000BEA
lbC000A2A:          rts

lbC000A2C:          move.w   #3,lbW000BEA
                    lea      lbL000D1E(pc),a4
                    moveq    #48,d2
lbC000A40:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC000A40
                    move.l   d0,d7
                    move.l   a0,a2
                    addq.l   #2,a2
                    moveq    #0,d6
                    lea      lbL000C5E,a3
lbC000A5A:          move.w   (a2),d6
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
                    bne      lbC000A5A
                    lea      lbL000D1E(pc),a3
                    move.l   a0,a2
                    addq.l   #2,a2
                    move.l   d0,d4
lbC000AA4:          move.w   (a2),d7
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
                    addq.l   #4,a2
                    subq.l   #1,d4
                    bne      lbC000AA4
                    lea      lbL000C5E(pc),a2
                    lea      lbL000D1E(pc),a3
                    move.l   d1,d4
                    subq.l   #2,a0
                    move.w   d0,lbW000BF2
                    move.l   a0,lbL000BF8
                    clr.w    lbW000BF0
                    rts

lbC000AF8:          cmp.w    #3,lbW000BEA
                    bne      return_2
                    tst.w    lbW000BF0
                    bne      return_2
                    addq.w   #1,lbW000BEE
                    move.w   lbW000BEE(pc),d0
                    cmp.w    lbW000BEC(pc),d0
                    bmi      return_2
                    clr.w    lbW000BEE
                    moveq    #0,d0
                    move.w   lbW000BF2(pc),d0
                    move.l   lbL000BF8(pc),a0
                    move.l   d0,d1
                    moveq    #0,d7
                    lea      lbL000C5E(pc),a2
                    lea      lbL000D1E(pc),a3
lbC000B4A:          addq.l   #4,a0
                    move.w   (a0),d2
                    and.w    #$F00,d2
                    beq.b    lbC000B6A
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000B6A:          addq.l   #2,a2
                    addq.l   #2,a3
                    move.w   (a0),d2
                    and.w    #$F0,d2
                    beq.b    lbC000B96
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000B96:          addq.l   #2,a2
                    addq.l   #2,a3
                    move.w   (a0),d2
                    and.w    #$F,d2
                    beq.b    lbC000BC2
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.l    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000BC2:          addq.l   #2,a2
                    addq.l   #2,a3
                    subq.w   #1,d1
                    bne.b    lbC000B4A
                    tst.l    d7
                    bne.b    lbC000BE8
                    move.w   #1,lbW000BF0
                    clr.w    lbW000BEA
lbC000BE8:          rts

lbW000BEA:          dc.w     0
lbW000BEC:          dc.w     2
lbW000BEE:          dc.w     0
lbW000BF0:          dc.w     0
lbW000BF2:          dc.w     0
lbL000BF4:          dc.l     0
lbL000BF8:          dc.l     0
lbL000BFC:          dcb.l    24,0

return_2:           rts

lbL000C5E:          dcb.l    48,0
lbL000D1E:          dcb.l    48,0

set_sprite_bp:      tst.l    16(a0)
                    bne.b    lbC000E00
                    move.l   12(a0),d0
lbC000DE8:          move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

lbC000E00:          move.l   16(a0),a1
                    move.l   a1,20(a0)
                    move.w   6(a1),24(a0)
                    move.l   (a1),d0
                    bra      lbC000DE8

lbC000E14:          move.l   8(a0),a1
                    tst.l    16(a0)
                    bne      lbC000EAC
lbC000E20:          and.w    #$80,14(a1)
                    move.w   0(a0),d0
                    add.w    #$80,d0
                    btst     #0,d0
                    beq.b    lbC000E3A
                    or.w     #1,14(a1)
lbC000E3A:          lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    add.w    #$2C,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #$FF,d1
                    bmi.b    lbC000E5E
                    sub.w    #$FF,d1
                    or.b     #2,15(a1)
lbC000E5E:          move.b   d1,14(a1)
                    cmp.w    #$FF,d0
                    bmi.b    lbC000E72
                    sub.w    #$FF,d0
                    or.b     #4,15(a1)
lbC000E72:          move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.b    lbC000EAA
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
lbC000EAA:          rts

lbC000EAC:          subq.w   #1,24(a0)
                    bpl      lbC000E20
                    addq.l   #8,20(a0)
lbC000EB8:          move.l   20(a0),a2
                    move.l   (a2),d0
                    tst.l    d0
                    bmi.b    lbC000ED6
                    move.w   6(a2),24(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      lbC000E20

lbC000ED6:          move.l   16(a0),20(a0)
                    bra.b    lbC000EB8

lbW000EFA:          dc.w     336,150,1,0
                    dc.l     sprite_bp
                    dc.l     sprite_data
                    dcb.w    6,0
sprite_data:        dc.l     -1,0,0

exit_flag:          dc.l     0
end_text_flag:      dc.w     0

colors_planet:      dc.w     $000,$FFF,$222,$222,$222,$222,$222,$222
                    dc.w     $322,$422,$522,$622,$722,$822,$922,$B32
                    dc.w     $FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF
                    dc.w     $FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF

lbW001336:          dc.w     $000,$990,$221,$332,$443,$554,$665,$776
                    dc.w     $887,$998,$AA9,$BBA,$CCB,$DDD,$EEE,$FFF
                    dc.w     $000,$111,$222,$333,$444,$555,$666,$777
                    dc.w     $888,$999,$AAA,$BBB,$CCC,$DDD,$EEE,$FFF

colors_down:        dc.w     $000,$770,$000,$110,$221,$332,$443,$554
                    dc.w     $665,$776,$887,$998,$AA9,$BBB,$CCC,$DDD
                    dc.w     $000,$000,$000,$111,$222,$333,$444,$555
                    dc.w     $666,$777,$888,$999,$AAA,$BBB,$CCC,$DDD

colors_up:          dc.w     $D00,$F90,$F21,$F32,$F43,$F54,$F65,$F76
                    dc.w     $F87,$F98,$FA9,$FBA,$FCB,$FDD,$FEE,$FFF
                    dc.w     $D00,$E11,$F22,$F33,$F44,$F55,$F66,$F77
                    dc.w     $F88,$F99,$FAA,$FBB,$FCC,$FDD,$FEE,$FFF

lbL0013F6:          dcb.w    32,0

; -----------------------------------------------------

copperlist_title:   dc.w     BPLCON0,$5200
                    dc.w     DIWSTRT
diwstrt:            dc.w     $FF81,DIWSTOP,$2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,0,BPL2MOD,0
                    dc.w     BPLCON2,$24,BPLCON1,0
title_bps:          dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL5PTH,0,BPL5PTL,0
color_palette_light:
                    dc.w     COLOR00,0,COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     COLOR16,0,COLOR17,0,COLOR18,0,COLOR19,0,COLOR20,0,COLOR21,0,COLOR22,0,COLOR23,0
                    dc.w     COLOR24,0,COLOR25,0,COLOR26,0,COLOR27,0,COLOR28,0,COLOR29,0,COLOR30,0,COLOR31,0
                    dc.w     $2001,$FF00
                    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0
sprite_bp:          dc.w     SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
copper_pal_line:    dc.w     $2C01,$FF00
pos_copper_beam_line:
                    dc.w     $2C01,$FF00
                    dc.w     COLOR01,$FFF,COLOR01,$FFF,COLOR02,$FFF,COLOR03,$FFF,COLOR04,$FFF,COLOR05,$FFF,COLOR06,$FFF,COLOR07,$FFF
                    dc.w     COLOR08,$FFF,COLOR09,$FFF,COLOR10,$FFF,COLOR11,$FFF,COLOR12,$FFF,COLOR13,$FFF,COLOR14,$FFF,COLOR15,$FFF
                    dc.w     COLOR16,$FFF,COLOR17,$FFF,COLOR18,$FFF,COLOR19,$FFF,COLOR20,$FFF,COLOR21,$FFF,COLOR22,$FFF,COLOR23,$FFF
                    dc.w     COLOR24,$FFF,COLOR25,$FFF,COLOR26,$FFF,COLOR27,$FFF,COLOR28,$FFF,COLOR29,$FFF,COLOR30,$FFF,COLOR31,$FFF
pos_copper_dark_pal:
                    dc.w     $2C01,$FF00
color_palette_dark: 
                    dc.w     COLOR00,0,COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     COLOR16,0,COLOR17,0,COLOR18,0,COLOR19,0,COLOR20,0,COLOR21,0,COLOR22,0,COLOR23,0
                    dc.w     COLOR24,0,COLOR25,0,COLOR26,0,COLOR27,0,COLOR28,0,COLOR29,0,COLOR30,0,COLOR31,0
                    dc.w     $FFFF,$FFFE

copperlist_blank:   dc.w     BPLCON0,$200
                    dc.w     DMACON,DMAF_SPRITE
                    dc.w     COLOR00,0
                    dc.w     $FFFF,$FFFE

copperlist_planet:  dc.w     BPLCON0,$6200
                    dc.w     DIWSTRT,$3481,DIWSTOP,$1FC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,0,BPL2MOD,0
                    dc.w     BPLCON2,0,BPLCON1,0
                    dc.w     $2001,$FF00
                    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
color_palette_planet:
                    dc.w     COLOR00,0,COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     COLOR16,0,COLOR17,0,COLOR18,0,COLOR19,0,COLOR20,0,COLOR21,0,COLOR22,0,COLOR23,0
                    dc.w     COLOR24,0,COLOR25,0,COLOR26,0,COLOR27,0,COLOR28,0,COLOR29,0,COLOR30,0,COLOR31,0
planet_bps:         dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
text_bps:           dc.w     BPL5PTH,0,BPL5PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

font_pic:           incbin   "font_16x462.lo2"

text_bitplane1:     dcb.b    (256*40),0

text_bitplane2:     dcb.b    (256*40),0

planet_pic:         incbin   "planet_320x256.lo4"
title_pic:          incbin   "title_320x256.lo5"

lbL01D36E:          dc.w     3,244
lbL01D372:          dcb.l    5,-1
lbL01D386:          dc.w     156,238
lbL01D38A:          dcb.l    5,-1

; -----------------------------------------------------

text_ptr:           dc.l     text_story
text_story:         dc.b     'THE YEAR IS 2191 AND THE GALAXY    '
                    dc.b     'STANDS ON THE BRINK OF WAR, ONLY   '
                    dc.b     'THE INTER PLANETARY CORPS MAINTAIN '
                    dc.b     'THE UNEASY PEACE. IPC MEMBERS      '
                    dc.b     'JOHNSON AND STONE WERE HEADING FOR '
                    dc.b     'FEDERATION HQ AFTER SIX MONTHS ON  '
                    dc.b     'ROUTINE PATROL AROUND THE INTEX    '
                    dc.b     'NETWORK. NOTHING HAD HAPPENED AND  '
                    dc.b     'NOTHING EVER DID IN THIS GOD       '
                    dc.B     'FORSAKEN PLACE.. THEY WERE GLAD TO '
                    dc.b     'BE GOING HOME.                     '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     'THEN CAME THE ORDERS TO CHECK OUT A'
                    dc.b     'DISTANT SPACE RESEARCH CENTRE WHICH'
                    dc.b     'HAD FAILED TO TRANSMIT ON ANY OF   '
                    dc.b     'THE FEDERATION WAVEBANDS. ISRC4 WAS'
                    dc.b     'SITUATED NEAR THE RED GIANT GIANOR '
                    dc.b     'AND WAS THE LAST PLACE THEY WANTED '
                    dc.b     'TO GO... LITTLE DID THEY KNOW WHAT '
                    dc.b     'LAY AHEAD... THEY WERE HEADING     '
                    dc.b     'STRAIGHT INTO THE MIDST OF AN ALIEN'
                    dc.b     'BREED.                             '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     '                                   '
                    dc.b     -1
                    even

                    end
