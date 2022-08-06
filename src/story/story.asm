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

                    section  story,code_c

start:              bsr      lbC000060
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
exit:               move.l   #copperlist_blank,$dff080
                    move.l   exit_flag,d0
                    rts

lbC000060:          lea      planet_bps,a0
                    move.l   #planet_pic,d0
                    move.l   #4,d1
                    move.l   #(256*40),d2
                    bsr      set_bps
                    lea      text_bps,a0
                    move.l   #text_bitplane1,d0
                    move.l   #2,d1
                    move.l   #(256*40),d2
                    bsr      set_bps
                    move.l   #copperlist_planet,$dff080
                    rts

pause:              btst     #7,$bfe001
                    beq      lbC0000CA
                    bsr      wait_frame_joystick
                    subq.w   #1,d0
                    bne.s    pause
                    rts

lbC0000CA:          move.w   #1,end_text_flag
                    move.l   #-1,exit_flag
                    rts

wait_frame_joystick:
                    btst     #7,$bfe001
                    beq      lbC0000CA
                    cmp.b    #255,$dff006
                    bne.s    wait_frame_joystick
.wait:              cmp.b    #0,$dff006
                    bne.s    .wait
                    rts

wait_frame:         cmp.b    #255,$dff006
                    bne.s    wait_frame
.wait:              cmp.b    #0,$dff006
                    bne.s    .wait
                    rts

display_title_screen:
                    lea      title_bps,a0
                    move.l   #title_pic,d0
                    move.l   #5,d1
                    move.l   #(256*40),d2
                    bsr      set_bps
                    lea      color_palette_dark,a0
                    lea      colors_down,a1
                    move.l   #32,d0
                    bsr      lbC00089E
                    bsr      wait_frame_joystick
                    move.l   #copperlist_title,$dff080
                    move.w   #4,lbW000BEC
                    move.l   #52,d0
.move:              bsr      wait_frame
                    move.l   d0,-(sp)
                    bsr      lbC00091A
                    move.l   (sp)+,d0
                    subq.b   #4,diwstrt
                    subq.w   #1,d0
                    bne.s    .move
                    move.b   #$2C,diwstrt
                    rts

display_beam_title: move.w   #$8020,$dff096
                    lea      lbW000EFA,a0
                    bsr      lbC000DDE
                    lea      lbW000EFA,a0
                    bsr      lbC000E14
                    lea      lbW001336,a0
                    lea      color_palette_light,a1
                    move.l   #32,d0
                    bsr      set_palette
                    clr.l    d0
                    clr.l    d1
                    move.l   #$2D01FF00,pos_copper_dark_pal
                    lea      lbW000EFA,a0
lbC0001CC:          movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW000EFA,a0
                    add.w    #48,(a0)
                    cmp.w    #320,(a0)
                    bmi.s    lbC0001E2
                    clr.w    (a0)
lbC0001E2:          add.w    d1,(a0)
                    cmp.w    #243,d0
                    bne.s    lbC0001EE
                    move.w   #244,d0
lbC0001EE:          move.w   d0,2(a0)
                    bsr      lbC000E14
                    movem.l  (sp)+,d0-d7/a0-a6
                    addq.w   #1,d1
                    cmp.w    #32,d1
                    bne.s    lbC000204
                    clr.w    d1
lbC000204:          bsr      wait_frame_joystick
                    add.l    #$1000000,pos_copper_beam_line
                    add.l    #$1000000,pos_copper_dark_pal
                    cmp.l    #$1FF00,pos_copper_beam_line
                    bne.s    lbC000232
                    move.l   #$FFE1FFFE,copper_pal_line
lbC000232:          addq.w   #1,d0
                    cmp.w    #$FF,d0
                    bne.s    lbC0001CC
                    lea      lbW000EFA,a0
                    move.w   #336,(a0)
                    bsr      lbC000E14
                    move.l   #300,d0
                    bsr      pause
                    tst.l    exit_flag
                    beq.s    lbC000260
                    addq.l   #4,sp
                    bra      exit

lbC000260:          move.w   #2,lbW000BEC
                    lea      lbW001336,a0
                    lea      colors_up,a1
                    lea      color_palette_light,a2
                    move.l   #32,d0
                    bsr      lbC000706
                    bsr      lbC0002AA
                    lea      colors_up,a0
                    lea      lbL0013F6,a1
                    lea      color_palette_light,a2
                    move.l   #32,d0
                    bsr      lbC000706
                    bsr      lbC0002AA
                    rts

lbC0002AA:          btst     #7,$bfe001
                    beq.s    lbC0002D0
                    btst     #6,$bfe001
                    beq.s    lbC0002D0
                    bsr      wait_frame_joystick
                    bsr      lbC0007B8
                    tst.w    lbW000BF0
                    beq.s    lbC0002AA
                    rts

lbC0002D0:          move.w   #1,end_text_flag
                    move.l   #-1,exit_flag
                    move.w   #1,lbW000BF0
                    rts

set_palette:        move.w   (a0)+,2(a1)
                    addq.l   #4,a1
                    subq.w   #1,d0
                    bne.s    set_palette
                    rts

set_bps:            move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    d2,d0
                    addq.l   #8,a0
                    subq.w   #1,d1
                    bne.s    set_bps
                    rts

scroll_blit_text:   not.w    scroll_slown_down
                    beq.s    scroll_text
                    bsr      wait_blitter
                    move.w   #$8400,$dff096
                    clr.l    $dff064
                    move.l   #text_bitplane1+40,$dff050
                    move.l   #text_bitplane1,$dff054
                    move.l   #-1,$dff044
                    move.l   #$9F00000,$dff040
                    move.w   #(255*64)+20,$dff058
                    bsr      wait_blitter
                    move.l   #text_bitplane2+40,$dff050
                    move.l   #text_bitplane2,$dff054
                    move.w   #(255*64)+20,$dff058
                    bsr      wait_blitter
                    move.w   #$400,$dff096
                    rts

wait_blitter:       
                    WAIT_BLIT
                    rts

scroll_text:        addq.w   #1,lbW00045C
                    cmp.w    #6,lbW00045C
                    beq      lbC000446
                    cmp.w    #12,lbW00045C
                    bmi      return
                    clr.w    lbW00045C
                    addq.w   #1,pause_scroll
                    cmp.w    #18,pause_scroll
                    bmi.s    lbC0003D6
                    clr.w    pause_scroll
                    move.l   #500,d0
                    bsr      pause
lbC0003D6:          move.l   text_ptr,a0
                    move.l   #17,d0
                    lea      lbL01D372,a1
lbC0003E8:          move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    lbC0003E8
                    move.l   text_ptr,a0
                    add.l    #17,a0
                    move.l   #18,d0
                    lea      lbL01D38A,a1
lbC000406:          move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    lbC000406
                    add.l    #35,text_ptr
                    move.l   text_ptr,a0
                    tst.b    (a0)
                    bpl      reset_text
                    move.l   #text_story,text_ptr
                    move.w   #1,end_text_flag
reset_text:         lea      lbL01D36E,a0
                    lea      font_struct,a1
                    bsr      display_text
                    rts

lbC000446:          lea      lbL01D386,a0
                    lea      font_struct,a1
                    bsr      display_text
                    rts

pause_scroll:       dc.w     0
scroll_slown_down:  dc.w     0
lbW00045C:          dc.w     0

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
                    add.l    16(a1),d0
                    tst.b    (a0)
                    bmi      return
                    bne      next_letter
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    20(a1),d1
                    bra      next_letter

return:             rts

letter_buffer:      dcb.l    32,0
font_struct:        dc.l     text_bitplane1,10240,2,36,9,11,80,924
                    dc.l     font_pic
                    dc.l     ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ,1234567890.!?: ',0
                    even

fade_out_planet:    lea      color_palette_planet,a0
                    lea      colors_planet,a1
                    move.l   #32,d0
                    bsr      lbC000A2C
lbC0006B2:          bsr      wait_frame_joystick
                    bsr      lbC000AF8
                    tst.w    lbW000BF0
                    beq      lbC0006B2
                    rts

fade_in_planet:     lea      color_palette_planet,a0
                    lea      colors_planet,a1
                    move.l   #32,d0
                    bsr      lbC00089E
lbC0006DC:          bsr      wait_frame_joystick
                    bsr      lbC00091A
                    tst.w    lbW000BF0
                    beq      lbC0006DC
                    rts

lbC000706:          movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #1,lbW000BEA
                    move.w   d0,lbW000BF2
                    move.l   a1,lbL000BF4
                    move.l   a2,lbL000BF8
                    move.l   a0,a2
                    lea      lbL000BFC,a3
                    move.w   lbW000BF2,d0
lbC000732:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bmi.s    lbC000748
                    bhi.s    lbC00074E
                    clr.b    (a3)+
                    bra.s    lbC000752

lbC000748:          move.b   #-1,(a3)+
                    bra.s    lbC000752

lbC00074E:          move.b   #1,(a3)+
lbC000752:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bmi.s    lbC000768
                    bhi.s    lbC00076E
                    clr.b    (a3)+
                    bra.s    lbC000772

lbC000768:          move.b   #-1,(a3)+
                    bra.s    lbC000772

lbC00076E:          move.b   #1,(a3)+
lbC000772:          move.w   (a2)+,d1
                    move.w   (a1)+,d2
                    and.w    #15,d1
                    and.w    #15,d2
                    cmp.w    d1,d2
                    bmi.s    lbC000788
                    bhi.s    lbC00078E
                    clr.b    (a3)+
                    bra.s    lbC000792

lbC000788:          move.b   #-1,(a3)+
                    bra.s    lbC000792

lbC00078E:          move.b   #1,(a3)+
lbC000792:          subq.b   #1,d0
                    bne.s    lbC000732
                    move.l   lbL000BF8,a2
                    move.w   lbW000BF2,d0
                    addq.l   #2,a2
lbC0007A4:          move.w   (a0)+,(a2)
                    addq.l   #4,a2
                    subq.b   #1,d0
                    bne.s    lbC0007A4
                    clr.w    lbW000BF0
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC0007B8:          cmp.w    #1,lbW000BEA
                    bne      lbC000C5C
                    tst.w    lbW000BF0
                    bne      lbC000C5C
                    clr.l    d7
                    add.w    #1,lbW000BEE
                    move.w   lbW000BEE,d0
                    cmp.w    lbW000BEC,d0
                    bmi      lbC000C5C
                    clr.w    lbW000BEE
                    move.w   lbW000BF2,d0
                    move.l   lbL000BF8,a0
                    move.l   lbL000BF4,a1
                    lea      lbL000BFC,a3
                    addq.l   #2,a0
lbC000808:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bne.s    lbC00081E
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC00082C

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
                    bne.s    lbC000842
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC000850

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
                    bne.s    lbC000866
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC000870

lbC000866:          move.b   (a3)+,d3
                    add.b    d3,d1
                    and.w    #$FF0,(a0)
                    or.w     d1,(a0)
lbC000870:          addq.l   #4,a0
                    subq.b   #1,d0
                    bne.s    lbC000808
                    divu     #3,d7
                    cmp.w    lbW000BF2,d7
                    bne.s    lbC000890
                    move.w   #1,lbW000BF0
                    clr.w    lbW000BEA
lbC000890:          rts

                    addq.l   #2,a1
lbC000894:          move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #2,d0
                    bne.s    lbC000894
                    rts

lbC00089E:          move.w   #2,lbW000BEA
                    lea      lbL000D1E,a4
                    move.l   #48,d2
lbC0008B2:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC0008B2
                    move.l   d0,d7
                    move.l   a1,a2
                    clr.l    d6
                    lea      lbL000C5E,a3
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
                    bne      lbC000C5C
                    tst.w    lbW000BF0
                    bne      lbC000C5C
                    add.w    #1,lbW000BEE
                    move.w   lbW000BEE,d0
                    cmp.w    lbW000BEC,d0
                    bmi      lbC000C5C
                    clr.w    lbW000BEE
                    move.l   lbL000BF8,a0
                    move.l   lbL000BF4,a1
                    clr.l    d0
                    move.w   lbW000BF2,d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      lbL000C5E,a2
                    lea      lbL000D1E,a3
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
                    bne      lbC000A2A
                    move.w   #1,lbW000BF0
                    clr.w    lbW000BEA
lbC000A2A:          rts

lbC000A2C:          move.w   #3,lbW000BEA
                    lea      lbL000D1E,a4
                    move.l   #48,d2
lbC000A40:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC000A40
                    move.l   d0,d7
                    move.l   a0,a2
                    add.l    #2,a2
                    clr.l    d6
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
                    lea      lbL000D1E,a3
                    move.l   a0,a2
                    add.l    #2,a2
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
                    add.l    #4,a2
                    sub.l    #1,d4
                    bne      lbC000AA4
                    lea      lbL000C5E,a2
                    lea      lbL000D1E,a3
                    move.l   d1,d4
                    sub.l    #2,a0
                    move.w   d0,lbW000BF2
                    move.l   a0,lbL000BF8
                    clr.w    lbW000BF0
                    rts

lbC000AF8:          cmp.w    #3,lbW000BEA
                    bne      lbC000C5C
                    tst.w    lbW000BF0
                    bne      lbC000C5C
                    add.w    #1,lbW000BEE
                    move.w   lbW000BEE,d0
                    cmp.w    lbW000BEC,d0
                    bmi      lbC000C5C
                    clr.w    lbW000BEE
                    clr.l    d0
                    move.w   lbW000BF2,d0
                    move.l   lbL000BF8,a0
                    move.l   d0,d1
                    clr.l    d7
                    lea      lbL000C5E,a2
                    lea      lbL000D1E,a3
lbC000B4A:          addq.l   #4,a0
                    move.w   (a0),d2
                    and.w    #$F00,d2
                    tst.w    d2
                    beq      lbC000B6A
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000B6A:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F0,d2
                    tst.w    d2
                    beq      lbC000B96
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000B96:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F,d2
                    tst.w    d2
                    beq      lbC000BC2
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.l    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000BC2:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC000B4A
                    tst.l    d7
                    bne      lbC000BE8
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

lbC000C5C:          rts

lbL000C5E:          dcb.l    48,0
lbL000D1E:          dcb.l    48,0

lbC000DDE:          tst.l    $10(a0)
                    bne.s    lbC000E00
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
                    beq.s    lbC000E3A
                    or.w     #1,14(a1)
lbC000E3A:          lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    add.w    #$2C,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #$FF,d1
                    bmi.s    lbC000E5E
                    sub.w    #$FF,d1
                    or.b     #2,15(a1)
lbC000E5E:          move.b   d1,14(a1)
                    cmp.w    #$FF,d0
                    bmi.s    lbC000E72
                    sub.w    #$FF,d0
                    or.b     #4,15(a1)
lbC000E72:          move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.s    lbC000EAA
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
                    bmi.s    lbC000ED6
                    move.w   6(a2),24(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      lbC000E20

lbC000ED6:          move.l   16(a0),20(a0)
                    bra.s    lbC000EB8

lbW000EFA:          dc.w     336,150,1,0
                    dc.l     lbW001062
                    dc.l     lbL000F16
                    dcb.w    6,0
lbL000F16:          dc.l     -1,0,0

copperlist_title:   dc.w    $100,$5200
                    dc.w    $8E
diwstrt:            dc.w    $FF81,$90,$2CC1
                    dc.w    $92,$38,$94,$D0
                    dc.w    $108,0,$10A,0
                    dc.w    $104,$24,$102,0
title_bps:          dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $E8,0,$EA,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F0,0,$F2,0
color_palette_light:
                    dc.w    $180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0
                    dc.w    $18E,0,$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0
                    dc.w    $19C,0,$19E,0,$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0
                    dc.w    $1AA,0,$1AC,0,$1AE,0,$1B0,0,$1B2,0,$1B4,0,$1B6,0
                    dc.w    $1B8,0,$1BA,0,$1BC,0,$1BE,0
                    dc.w    $2001,$FF00
                    dc.w    $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0,$14A,0
                    dc.w    $128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0,$158,0,$15A,0
                    dc.w    $130,0,$132,0,$160,0,$162,0,$134,0,$136,0,$168,0,$16A,0
                    dc.w    $138,0,$13A,0,$170,0,$172,0
lbW001062:          dc.w    $13C,0,$13E,0,$178,0,$17A,0
copper_pal_line:    dc.w    $2C01,$FF00
pos_copper_beam_line:
                    dc.w    $2C01,$FF00
                    dc.w    $182,$FFF,$182,$FFF,$184,$FFF,$186,$FFF,$188,$FFF,$18A,$FFF,$18C,$FFF,$18E,$FFF
                    dc.w    $190,$FFF,$192,$FFF,$194,$FFF,$196,$FFF,$198,$FFF,$19A,$FFF,$19C,$FFF,$19E,$FFF
                    dc.w    $1A0,$FFF,$1A2,$FFF,$1A4,$FFF,$1A6,$FFF,$1A8,$FFF,$1AA,$FFF,$1AC,$FFF,$1AE,$FFF
                    dc.w    $1B0,$FFF,$1B2,$FFF,$1B4,$FFF,$1B6,$FFF,$1B8,$FFF,$1BA,$FFF,$1BC,$FFF,$1BE,$FFF
pos_copper_dark_pal:
                    dc.w    $2C01,$FF00
color_palette_dark: dc.w    $180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0
                    dc.w    $18E,0,$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0
                    dc.w    $19C,0,$19E,0,$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0
                    dc.w    $1AA,0,$1AC,0,$1AE,0,$1B0,0,$1B2,0,$1B4,0,$1B6,0
                    dc.w    $1B8,0,$1BA,0,$1BC,0,$1BE,0
                    dc.w    $FFFF,$FFFE

copperlist_blank:   dc.w    $100,$200,$96,$20,$180,0,$FFFF,$FFFE

copperlist_planet:  dc.w    $100,$6200,$8E,$3481,$90,$1FC1,$92,$38,$94,$D0
                    dc.w    $108,0,$10A,0,$104,0,$102,0,$2001,$FF00,$120,0
                    dc.w    $122,0,$140,0,$142,0,$124,0,$126,0,$148,0,$14A,0
                    dc.w    $128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0,$158,0
                    dc.w    $15A,0,$130,0,$132,0,$160,0,$162,0,$134,0,$136,0
                    dc.w    $168,0,$16A,0,$138,0,$13A,0,$170,0,$172,0,$13C,0
                    dc.w    $13E,0,$178,0,$17A,0
color_palette_planet:
                    dc.w    $180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0
                    dc.w    $18E,0,$190,0,$192,0,$194,0,$196,0,$198,0,$19A,0
                    dc.w    $19C,0,$19E,0,$1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0
                    dc.w    $1AA,0,$1AC,0,$1AE,0,$1B0,0,$1B2,0,$1B4,0,$1B6,0
                    dc.w    $1B8,0,$1BA,0,$1BC,0,$1BE,0
planet_bps:         dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $E8,0,$EA,0
                    dc.w    $EC,0,$EE,0
text_bps:           dc.w    $F0,0,$F2,0
                    dc.w    $F4,0,$F6,0
                    dc.w    $FFFF,$FFFE

exit_flag:          dc.l    0
end_text_flag:      dc.w    0

colors_planet:      dc.w    $000,$FFF,$222,$222,$222,$222,$222,$222,$322,$422
                    dc.w    $522,$622,$722,$822,$922,$B32,$FFF,$FFF,$FFF,$FFF
                    dc.w    $FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF
                    dc.w    $FFF,$FFF

lbW001336:          dc.w    $000,$990,$221,$332,$443,$554,$665,$776,$887,$998
                    dc.w    $AA9,$BBA,$CCB,$DDD,$EEE,$FFF,$000,$111,$222,$333
                    dc.w    $444,$555,$666,$777,$888,$999,$AAA,$BBB,$CCC,$DDD
                    dc.w    $EEE,$FFF

colors_down:        dc.w    $000,$770,$000,$110,$221,$332,$443,$554,$665,$776,$887
                    dc.w    $998,$AA9,$BBB,$CCC,$DDD,$000,$000,$000,$111,$222,$333
                    dc.w    $444,$555,$666,$777,$888,$999,$AAA,$BBB,$CCC,$DDD

colors_up:          dc.w    $D00,$F90,$F21,$F32,$F43,$F54,$F65,$F76,$F87,$F98
                    dc.w    $FA9,$FBA,$FCB,$FDD,$FEE,$FFF,$D00,$E11,$F22,$F33
                    dc.w    $F44,$F55,$F66,$F77,$F88,$F99,$FAA,$FBB,$FCC,$FDD
                    dc.w    $FEE,$FFF

lbL0013F6:          dcb.w   32,0

                    incdir  "src/story/gfx/"
font_pic:           incbin  "font_16x462x2.raw"

text_bitplane1:     dcb.b   10240,0

text_bitplane2:     dcb.b   10240,0

planet_pic:         incbin  "planet_320x256x4.raw"
title_pic:          incbin  "title_320x256x5.raw"

lbL01D36E:          dc.w    3,244
lbL01D372:          dcb.l   5,-1
lbL01D386:          dc.w    156,238
lbL01D38A:          dcb.l   5,-1

text_ptr:           dc.l    text_story
text_story:         dc.b    'THE YEAR IS 2191 AND THE GALAXY    '
                    dc.b    'STANDS ON THE BRINK OF WAR, ONLY   '
                    dc.b    'THE INTER PLANETARY CORPS MAINTAIN '
                    dc.b    'THE UNEASY PEACE. IPC MEMBERS      '
                    dc.b    'JOHNSON AND STONE WERE HEADING FOR '
                    dc.b    'FEDERATION HQ AFTER SIX MONTHS ON  '
                    dc.b    'ROUTINE PATROL AROUND THE INTEX    '
                    dc.b    'NETWORK. NOTHING HAD HAPPENED AND  '
                    dc.b    'NOTHING EVER DID IN THIS GOD       '
                    dc.B    'FORSAKEN PLACE.. THEY WERE GLAD TO '
                    dc.b    'BE GOING HOME.                     '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    'THEN CAME THE ORDERS TO CHECK OUT A'
                    dc.b    'DISTANT SPACE RESEARCH CENTRE WHICH'
                    dc.b    'HAD FAILED TO TRANSMIT ON ANY OF   '
                    dc.b    'THE FEDERATION WAVEBANDS. ISRC4 WAS'
                    dc.b    'SITUATED NEAR THE RED GIANT GIANOR '
                    dc.b    'AND WAS THE LAST PLACE THEY WANTED '
                    dc.b    'TO GO... LITTLE DID THEY KNOW WHAT '
                    dc.b    'LAY AHEAD... THEY WERE HEADING     '
                    dc.b    'STRAIGHT INTO THE MIDST OF AN ALIEN'
                    dc.b    'BREED.                             '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    '                                   '
                    dc.b    -1
                    even

                    end
