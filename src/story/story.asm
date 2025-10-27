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
                    bsr      prep_fade_speeds_fade_in
                    bsr      wait_frame_joystick
                    move.l   #copperlist_title,CUSTOM+COP1LCH
                    move.w   #4,frames_slowdown
                    moveq    #52,d0
.move:              bsr      wait_frame
                    move.l   d0,-(sp)
                    bsr      fade_palette_in
                    move.l   (sp)+,d0
                    subq.b   #4,copper_diwstrt
                    subq.w   #1,d0
                    bne.b    .move
                    move.b   #$2C,copper_diwstrt
                    rts

display_beam_title: move.w   #$8020,CUSTOM+DMACON
                    lea      sprite_struct(pc),a0
                    bsr      set_sprite_bp
                    lea      sprite_struct(pc),a0
                    bsr      disp_sprite
                    lea      colors_up(pc),a0
                    lea      color_palette_light(pc),a1
                    moveq    #32,d0
                    bsr      set_palette
                    moveq    #0,d0
                    moveq    #0,d1
                    move.l   #$2D01FF00,pos_copper_dark_pal
                    lea      sprite_struct(pc),a0
move_beam:          movem.l  d0-d7/a0-a6,-(sp)
                    lea      sprite_struct(pc),a0
                    add.w    #48,(a0)
                    cmp.w    #320,(a0)
                    bmi.b    .reset_x
                    clr.w    (a0)
.reset_x:           add.w    d1,(a0)
                    cmp.w    #243,d0
                    bne.b    .max_y
                    move.w   #244,d0
.max_y:             move.w   d0,2(a0)
                    bsr      disp_sprite
                    movem.l  (sp)+,d0-d7/a0-a6
                    addq.w   #1,d1
                    cmp.w    #32,d1
                    bne.b    .reset_x_speed
                    clr.w    d1
.reset_x_speed:     bsr      wait_frame_joystick
                    add.l    #$01000000,pos_copper_beam_line
                    add.l    #$01000000,pos_copper_dark_pal
                    cmp.l    #$0001FF00,pos_copper_beam_line
                    bne.b    reached_pal
                    move.l   #$FFE1FFFE,copper_pal_line
reached_pal:        addq.w   #1,d0
                    cmp.w    #$FF,d0
                    bne.b    move_beam
                    lea      sprite_struct(pc),a0
                    move.w   #336,(a0)
                    bsr      disp_sprite
                    move.l   #300,d0
                    bsr      wait_x_frames
                    tst.l    exit_flag
                    beq.b    fade_out_pic
                    addq.l   #4,sp
                    bra      exit

fade_out_pic:       move.w   #2,frames_slowdown
                    lea      colors_up(pc),a0
                    lea      colors_red(pc),a1
                    lea      color_palette_light(pc),a2
                    moveq    #32,d0
                    bsr      prep_fade_speeds_fade_to_rgb
                    bsr      go_fade_to_red
                    lea      colors_red(pc),a0
                    lea      palette_black,a1
                    lea      color_palette_light(pc),a2
                    moveq    #32,d0
                    bsr      prep_fade_speeds_fade_to_rgb
                    ; no rts

go_fade_to_red:     btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    .interrupted
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    .interrupted
                    bsr      wait_frame_joystick
                    bsr      fade_palette_to_rgb
                    tst.w    done_fade
                    beq.b    go_fade_to_red
                    rts

.interrupted:       move.w   #1,end_text_flag
                    move.l   #-1,exit_flag
                    move.w   #1,done_fade
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
                    beq      scroll_text
                    WAIT_BLIT
                    move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
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
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

scroll_text:        addq.w   #1,split_scroll_counter
                    cmp.w    #6,split_scroll_counter
                    beq      disp_scroll_text_2
                    cmp.w    #12,split_scroll_counter
                    bmi      return
                    clr.w    split_scroll_counter
                    addq.w   #1,pause_scroll_counter
                    cmp.w    #18,pause_scroll_counter
                    bmi.b    mid_scroll_pause
                    clr.w    pause_scroll_counter
                    move.l   #500,d0
                    bsr      wait_x_frames
mid_scroll_pause:   move.l   text_ptr,a0
                    moveq    #17,d0
                    lea      scroll_text_block_1,a1
.copy_block_1:      move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    .copy_block_1
                    move.l   text_ptr,a0
                    add.l    #17,a0
                    moveq    #18,d0
                    lea      scroll_text_block_2,a1
.copy_block_2:      move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    .copy_block_2
                    add.l    #35,text_ptr
                    move.l   text_ptr,a0
                    tst.b    (a0)
                    bpl.b    reset_text
                    move.l   #text_story,text_ptr
                    move.w   #1,end_text_flag
reset_text:         lea      scroll_text_1,a0
                    lea      font_struct(pc),a1
                    bra.b    display_text

disp_scroll_text_2: lea      scroll_text_2,a0
                    lea      font_struct(pc),a1
                    bra.b    display_text

pause_scroll_counter:
                    dc.w     0
scroll_slown_down:  dc.w     0
split_scroll_counter:
                    dc.w     0

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
                    or.w     #$FE2,d3
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
font_struct:        dc.l     text_bitplane1,(256*40),2,36,9,11,80,924,font_pic,ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ,1234567890.!?: ',0
                    even

fade_out_planet:    lea      color_palette_planet(pc),a0
                    lea      colors_planet(pc),a1
                    moveq    #32,d0
                    bsr      prep_fade_speeds_fade_out
.loop:              bsr      wait_frame_joystick
                    bsr      fade_palette_out
                    tst.w    done_fade
                    beq      .loop
                    rts

fade_in_planet:     lea      color_palette_planet(pc),a0
                    lea      colors_planet(pc),a1
                    moveq    #32,d0
                    bsr      prep_fade_speeds_fade_in
.loop:              bsr      wait_frame_joystick
                    bsr      fade_palette_in
                    tst.w    done_fade
                    beq      .loop
                    rts

FADE_SPEED          equ      2
                    include  "palette.asm"
                    include  "sprite.asm"

; -----------------------------------------------------

sprite_struct:      dc.w     336,150,1,0
                    dc.l     sprite_bp
                    dc.l     sprite_data
                    dc.l     0
                    dc.l     0
                    dc.w     0
                    dc.w     0
sprite_data:        dc.w     %1111111111111111,%1111111111111111
                    dc.w     0,0

exit_flag:          dc.l     0
end_text_flag:      dc.w     0

colors_planet:      dc.w     $000,$FFF,$222,$222,$222,$222,$222,$222
                    dc.w     $322,$422,$522,$622,$722,$822,$922,$B32
                    dc.w     $FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF
                    dc.w     $FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF

colors_up:          dc.w     $000,$990,$221,$332,$443,$554,$665,$776
                    dc.w     $887,$998,$AA9,$BBA,$CCB,$DDD,$EEE,$FFF
                    dc.w     $000,$111,$222,$333,$444,$555,$666,$777
                    dc.w     $888,$999,$AAA,$BBB,$CCC,$DDD,$EEE,$FFF

colors_down:        dc.w     $000,$770,$000,$110,$221,$332,$443,$554
                    dc.w     $665,$776,$887,$998,$AA9,$BBB,$CCC,$DDD
                    dc.w     $000,$000,$000,$111,$222,$333,$444,$555
                    dc.w     $666,$777,$888,$999,$AAA,$BBB,$CCC,$DDD

colors_red:         dc.w     $D00,$F90,$F21,$F32,$F43,$F54,$F65,$F76
                    dc.w     $F87,$F98,$FA9,$FBA,$FCB,$FDD,$FEE,$FFF
                    dc.w     $D00,$E11,$F22,$F33,$F44,$F55,$F66,$F77
                    dc.w     $F88,$F99,$FAA,$FBB,$FCC,$FDD,$FEE,$FFF

palette_black:      dcb.w    32,0

; -----------------------------------------------------

copperlist_title:   dc.w     BPLCON0,$5200
                    dc.w     DIWSTRT
copper_diwstrt:     dc.w     $FF81,DIWSTOP,$2CC1
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

scroll_text_1:      dc.w     3,244
scroll_text_block_1:
                    dcb.b    20,-1
scroll_text_2:      dc.w     156,238
scroll_text_block_2:
                    dcb.b    20,-1

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
