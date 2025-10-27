; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

                    include  "common.inc"

; -----------------------------------------------------

                    section  menu,code_c

start:              move.l   d5,number_players
                    move.l   d7,share_credits
                    move.l   a1,reg_vbr
                    bsr      setup_context
                    bsr      setup_copperlist
                    clr.l    menu_seq_flag
                    lea      copper_palette_stars(pc),a0
                    lea      stars_palette(pc),a1
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_in
                    bsr      wait_vsync_with_done_fade
                    bsr      wait_button_press
                    move.w   #1,move_copyright_line_flag
                    clr.w    break_main_loop_flag
                    move.l   #134,d0
.pause:             move.l   d0,-(sp)
                    move.l   (sp)+,d0
                    subq.l   #1,d0
                    bne.b    .pause
                    bsr      main_loop
                    move.l   share_credits(pc),d1
                    moveq    #0,d4
                    move.l   number_players(pc),d6
                    move.l   return_value(pc),d7
                    bra      restore_lev3irq

reg_vbr:            dc.l     0

wait_button_press:  btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    wait_button_press
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    wait_button_press
                    rts

return_value:       dc.l     0
number_players:     dc.l     0

menu_seq_flag:      dc.l     0
frames_counter:     dc.l     0

handle_menu:        move.l   #1,menu_seq_flag
                    move.w   #1,done_fade
                    bsr      clear_menu_bitplanes
                    bsr      wait_sync2
                    lea      pos_flash_menu_top(pc),a0
                    move.l   #$DF01FF00,(a0)+
                    move.l   #$1980000,(a0)+
                    move.l   #$EF01FF00,(a0)+
                    move.l   #$1980444,(a0)+
                    move.l   #$FFD7FFFE,(a0)+
                    tst.w    return_value
                    bne.b    dont_redisplay_menu
                    bsr      disp_menu
dont_redisplay_menu:
                    move.w   #1,menu_flash_act_flag
                    move.w   #2,pos_in_menu
                    clr.w    d0
                    clr.l    frames_counter
menu_loop:          addq.l   #1,frames_counter
                    cmp.l    #1000,frames_counter
                    bpl      auto_exit_menu
                    move.w   CUSTOM+JOY1DAT,d1
                    and.w    #$303,d1
                    beq.b    .reset_frames_counter
                    clr.l    frames_counter
.reset_frames_counter:
                    move.w   pos_in_menu(pc),d1
                    mulu     #13,d1
                    ext.l    d1
                    add.w    #167,d1
                    lsl.w    #8,d1
                    or.w     #1,d1
                    move.w   d1,pos_flash_menu_top
                    add.w    #12<<8,d1
                    move.w   d1,pos_flash_menu_bot
                    move.w   CUSTOM+JOY1DAT,d1
                    and.w    #$303,d1
                    cmp.w    d1,d0
                    beq.b    .next_menu
                    move.w   #10,slowdown_menu
                    move.w   d1,d0
                    cmp.w    #$100,d0
                    bne.b    .prev_menu
                    tst.w    pos_in_menu
                    beq.b    .prev_menu
                    subq.w   #1,pos_in_menu
.prev_menu:         cmp.w    #1,d0
                    bne.b    .next_menu
                    cmp.w    #2,pos_in_menu
                    beq.b    .next_menu
                    addq.w   #1,pos_in_menu
.next_menu:         bsr      wait_sync2
                    addq.w   #1,slowdown_menu
                    cmp.w    #20,slowdown_menu
                    bne.b    .retrigger_menu
                    clr.w    slowdown_menu
                    clr.w    d0
.retrigger_menu:    tst.l    return_value
                    bne      check_menu_pos
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      check_menu_pos
                    btst     #CIAB_GAMEPORT0,CIAA
                    bne      menu_loop
check_menu_pos:     cmp.w    #2,pos_in_menu
                    beq      menu_start_game
                    cmp.w    #1,pos_in_menu
                    bne.b    change_share_credits
                    move.l   share_credits(pc),d0
                    not.l    d0
                    and.l    #1,d0
                    move.l   d0,share_credits
                    bsr      disp_menu
                    bra      menu_loop
change_share_credits:
                    tst.w    pos_in_menu
                    bne.b    change_number_players
                    move.l   number_players(pc),d0
                    bchg     #0,d0
                    bchg     #1,d0
                    move.l   d0,number_players
                    bsr      disp_menu
change_number_players:
                    bra      menu_loop

menu_start_game:    clr.w    user_exited_flag
                    cmp.w    #2,pos_in_menu
                    beq.b    user_selected_start_game
auto_exit_menu:     move.w   #1,user_exited_flag
user_selected_start_game:
                    clr.l    menu_seq_flag
                    clr.w    menu_flash_act_flag
                    lea      palette_menu(pc),a0
                    lea      palette_black(pc),a1
                    lea      copper_palette_menu(pc),a2
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_to_rgb
                    bsr      wait_vsync_with_done_fade_2
                    lea      pos_flash_menu_top(pc),a0
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    bsr      clear_menu_bitplanes
.wait_button:
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    .wait_button
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    .wait_button
                    clr.w    break_main_loop_flag
                    rts

user_exited_flag:   dc.w     0
pos_in_menu:        dc.w     0
slowdown_menu:      dc.w     0

disp_menu:          move.w   #1,done_fade
                    WAIT_BLIT
                    move.l   #$1000000,CUSTOM+BLTCON0
                    clr.w    CUSTOM+BLTDMOD
                    lea      menu_bitplanes+(94*40),a0
                    move.l   a0,CUSTOM+BLTDPTH
                    move.w   #((146*3)*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    lea      text_menu(pc),a0
                    cmp.l    #1,share_credits
                    bne.b    .dont_share_credits
                    add.l    #124,a0
.dont_share_credits:
                    cmp.l    #2,number_players
                    bne.b    .two_players
                    add.l    #62,a0
.two_players:       lea      font_struct(pc),a1
                    cmp.l    #1,menu_seq_flag
                    beq.b    .use_font_menu
                    lea      font_menu_struct(pc),a1
.use_font_menu:     bsr      display_text
                    cmp.l    #1,menu_seq_flag
                    beq      dont_copy_to_bitplane
                    bsr      wait_sync2
                    lea      bitplanes(pc),a1
                    move.l   #(94*40),d0
                    add.l    d0,a1
                    lea      menu_bitplanes+(94*40),a0
                    WAIT_BLIT
                    move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(146*64)+20,CUSTOM+BLTSIZE
                    add.l    #(146*40),a0
                    add.l    #(240*40),a1
                    WAIT_BLIT
                    move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(146*64)+20,CUSTOM+BLTSIZE
                    add.l    #(146*40),a0
                    add.l    #(240*40),a1
                    WAIT_BLIT
                    move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(146*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
dont_copy_to_bitplane:
                    clr.l    menu_seq_flag
.wait_button:       btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    .wait_button
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    .wait_button
                    move.l   #2,menu_seq_flag
                    rts

text_menu:          dc.w     16,112
                    dc.b     ' ONE PLAYER GAME  ',0
                    dc.b     'SHARE CREDITS  OFF',0
                    dc.b     '    START GAME    '
                    dc.b     -1,-1
                    dc.w     16,112
                    dc.b     ' TWO PLAYER GAME  ',0
                    dc.b     'SHARE CREDITS  OFF',0
                    dc.b     '    START GAME    '
                    dc.b     -1,-1
                    dc.w     16,112
                    dc.b     ' ONE PLAYER GAME  ',0
                    dc.b     'SHARE CREDITS  ON ',0
                    dc.b     '    START GAME    '
                    dc.b     -1,-1
                    dc.w     16,112
                    dc.b     ' TWO PLAYER GAME  ',0
                    dc.b     'SHARE CREDITS  ON ',0
                    dc.b     '    START GAME    '
                    dc.b     -1,-1
                    even

setup_copperlist:   lea      palette_black(pc),a0
                    lea      copper_palette_menu(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    move.l   #$2C01FF00,pos_copyright_line
                    lea      copyright_bps(pc),a0
                    move.l   #copyright_pic,d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(16*40),d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(16*40),d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    lea      copyright_palette,a0
                    lea      copper_copyright_pal(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    lea      empty_bps(pc),a0
                    move.l   #empty_pic,d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    lea      palette_black(pc),a0
                    lea      copper_palette_title(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    lea      palette_black(pc),a0
                    lea      copper_palette_menu(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    clr.w    move_copyright_line_flag
                    move.w   #-40,copper_modulo
                    lea      palette_black(pc),a0
                    lea      copper_palette_stars(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    lea      pos_flash_menu_top(pc),a0
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #$980000,(a0)+
                    move.l   #copperlist_main,CUSTOM+COP1LCH
                    clr.w    copper_modulo
                    lea      copper_palette_title(pc),a0
                    lea      palette_logo(pc),a1
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_in
                    bra      wait_vsync_with_done_fade

main_loop:          clr.w    break_main_loop_flag
                    bsr      handle_menu
                    tst.w    user_exited_flag
                    beq      .exit_menu
                    bsr      disp_credits
                    tst.w    break_main_loop_flag
                    bne      main_loop
                    clr.w    break_main_loop_flag
.exit_menu:         move.w   #1,frames_slowdown
                    clr.w    move_copyright_line_flag
                    lea      copper_palette_title(pc),a0
                    lea      palette_black(pc),a1
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_out
                    bsr      wait_vsync_with_done_fade
                    lea      copper_copyright_pal(pc),a0
                    lea      palette_black(pc),a1
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_out
                    bsr      wait_vsync_with_done_fade
                    lea      copper_palette_menu(pc),a0
                    lea      palette_black(pc),a1
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_out
                    bsr      wait_vsync_with_done_fade
                    lea      copper_palette_stars(pc),a0
                    lea      palette_black,a1
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_out
                    bra      wait_vsync_with_done_fade

stars_palette:      dc.w     $000,$111,$222,$333,$555,$888,$AAA,0

setup_context:      bsr      setup_stars
                    bsr      install_lev3irq
                    bsr      display_title
                    lea      menu_bps(pc),a0
                    move.l   #bitplanes+(90*40),d0
                    bsr      set_menu_bps
                    move.l   #copperlist_blank,CUSTOM+COP1LCH
                    lea      caret_struct(pc),a0
                    bsr      set_caret_bp
                    lea      caret_struct(pc),a0
                    bra      set_random_seed

display_title:      move.l   #title_pic,d0
                    not.w    flag_swap_title
                    beq.b    .second_title
                    add.l    #(89*40),d0
.second_title:      lea      title_bps(pc),a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #(180*40),d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.l   #8,a0
                    add.l    #(180*40),d0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    rts

flag_swap_title:    dc.w     0

set_menu_bps:       moveq    #3,d1
.loop:              move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(240*40),d0
                    addq.l   #8,a0
                    subq.l   #1,d1
                    bne.b    .loop
                    rts

install_lev3irq:    move.l   reg_vbr(pc),a0
                    move.l   $6C(a0),old_lev3irq
                    move.l   #lev3irq,$6C(a0)
                    rts

restore_lev3irq:    move.l   reg_vbr(pc),a0
                    move.l   old_lev3irq,$6C(a0)
                    rts

break_main_loop_flag:
                    dc.w     0

lev3irq:            movem.l  d0-d7/a0-a6,-(sp)
                    btst     #5,CUSTOM+INTREQR+1
                    beq      no_vblank
                    bsr      fade_palette_in
                    bsr      fade_palette_out
                    bsr      fade_palette_to_rgb
                    bsr      menu_flash
                    bsr      display_title
                    lea      caret_struct(pc),a0
                    bsr      disp_caret
                    move.w   #321,caret_struct
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    .button_pressed
                    btst     #CIAB_GAMEPORT1,CIAA
                    bne.b    .button_not_pressed
.button_pressed:    move.w   #1,break_main_loop_flag
.button_not_pressed:
                    tst.w    move_copyright_line_flag
                    beq      .move_copyright_line
                    cmp.l    #$1D01FF00,pos_copyright_line
                    bmi.b    .move_copyright_line
                    sub.l    #$01000000,pos_copyright_line
.move_copyright_line:
                    bsr      display_stars
                    move.l   #200,d0
.wait:              subq.l   #1,d0
                    bne.b    .wait
no_vblank:          movem.l  (sp)+,d0-d7/a0-a6
                    move.l   old_lev3irq(pc),-(sp)
                    rts

old_lev3irq:        dc.l     0

remove_flash_color: move.w   copper_palette_menu+18(pc),copper_flash_menu
                    move.w   copper_palette_menu+18(pc),copper_flash_menu_bot
                    move.l   #colors_flash_table,ptr_colors_flash_table
                    rts

menu_flash:         tst.w    menu_flash_act_flag
                    beq      remove_flash_color
                    addq.w   #1,slowdown_flash
                    cmp.w    #3,slowdown_flash
                    bmi.b    return
                    clr.w    slowdown_flash
                    move.l   ptr_colors_flash_table(pc),a0
                    tst.w    (a0)
                    bpl.b    .reset
                    lea      colors_flash_table(pc),a0
                    move.l   a0,ptr_colors_flash_table
.reset:             addq.l   #2,ptr_colors_flash_table
                    move.w   (a0),copper_flash_menu
return:             rts

menu_flash_act_flag:
                    dc.w     0
ptr_colors_flash_table:
                    dc.l     colors_flash_table
slowdown_flash:     dc.w     0
colors_flash_table: dc.w     $444,$555,$666,$777,$888,$999,$AAA,$AAA,$999,$888,$777,$666,$555,$444,$333,$333,-1
move_copyright_line_flag:
                    dc.w     0
palette_logo:       dc.w     $000,$111,$100,$200,$400,$800,$D00,$F30

wait_vsync_with_done_fade:
                    bsr      wait_sync2
                    tst.w    done_fade
                    beq.b    wait_vsync_with_done_fade
                    rts

wait_vsync_with_done_fade_2:
                    tst.w    done_fade
                    beq.b    wait_vsync_with_done_fade
                    rts

FADE_SPEED          equ      3
                    include  "palette.asm"

                    include  "caret.asm"

caret_struct:       dc.w     -32,-32
                    dc.w     11,0
                    dc.l     sprites_bps
                    dc.l     caret_pic
                    dc.l     0
                    dc.l     0
                    dc.w     0
                    dc.w     0
caret_pic:          dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     %1111111100000000,%0000000000000000
                    dc.w     0,0

palette_menu:       dc.w     $000,$222,$D31,$B11,$444,$333,$222,$F52

palette_menu_red:   dc.w     $000,$822,$A31,$811,$F44,$833,$A22,$852
                    dc.w     $000,$111,$222,$333,$444,$500,$700,$900

; -----------------------------------------------------

copperlist_blank:   dc.w     BPLCON0,$200
                    dc.w     COLOR00,0
                    dc.w     DMACON,DMAF_SPRITE
                    dc.w     $FFFF,$FFFE

copperlist_main:    dc.w     COLOR00,0
                    dc.w     BPLCON0,$6600
                    dc.w     DIWSTRT,$2C81,DIWSTOP,$2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,8,BPL2MOD
copper_modulo:      dc.w     0
                    dc.w     BPLCON2,$64,BPLCON1,0
                    dc.w     $2001,$FF00
                    dc.w     DMACON,DMAF_SETCLR|DMAF_SPRITE
                    dc.w     COLOR17,$FFF
sprites_bps:        dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
copper_palette_stars:
                    dc.w     COLOR00,0,COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
stars_bps:          dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL5PTH,0,BPL5PTL,0
title_bps:          dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
copper_palette_title:
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     $8501,$FF00
menu_bps:           dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
                    dc.w     $8A01,$FF00
copper_palette_menu:
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    ;---
pos_flash_menu_top: dc.w     $8A01,$FF00
                    dc.w     COLOR00
copper_flash_menu:  dc.w     $20
pos_flash_menu_bot: dc.w     $9A01,$FF00
                    dc.w     COLOR00
copper_flash_menu_bot:
                    dc.w     0
                    dc.w     $FFD7,$FFFE
                    ;---
                    dc.w     $FFD7,$FFFE
                    dc.w     BPLCON1,$200
                    dc.w     $1A01,$FF00
empty_bps:          dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
pos_copyright_line: dc.w     0,0
copyright_bps:      dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL6PTH,0,BPL6PTL,0
copper_copyright_pal:
                    dc.w     COLOR08,$000,COLOR09,$222,COLOR10,$444,COLOR11,$555,COLOR12,0,COLOR13,0,COLOR14,0,COLOR15,0
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

display_stars:      bsr      move_stars
                    bsr      set_stars_buffer
                    bsr.b    clear_stars
                    bra.b    do_stars

clear_stars:        move.l   stars_bitplanes_ptr(pc),a0
                    lea      256*48(a0),a1
                    lea      256*48(a1),a2
                    move.l   stars_screen_coords_ptr(pc),a3
                    move.w   stars_nbr(pc),d1
.clear:             move.l   (a3)+,d0
                    clr.b    0(a0,d0.l)
                    clr.b    0(a1,d0.l)
                    clr.b    0(a2,d0.l)
                    dbra     d1,.clear
                    rts

do_stars:           lea      stars_3d_coords,a0
                    lea      (a0),a1
                    lea      stars_pos_x(pc),a2
                    movem.w  (a2)+,d0-d3
                    lea      stars_centers(pc),a3
                    move.l   stars_bitplanes_ptr(pc),a2
                    move.l   stars_screen_coords_ptr(pc),a4
.plots:             movem.w  (a0)+,d4-d6
                    add.w    d0,d4
                    add.w    d1,d5
                    add.w    d2,d6
                    cmp.w    #384,d4
                    blt.b    .max_x
                    sub.w    #768,d4
.max_x:             cmp.w    #-384,d4
                    bgt.b    .min_x
                    add.w    #768,d4
.min_x:             cmp.w    #256,d5
                    blt.b    .max_y
                    sub.w    #512,d5
.max_y:             cmp.w    #-256,d5
                    bgt.b    .min_y
                    add.w    #512,d5
.min_y:             cmp.w    #1024,d6
                    ble.b    .max_z
                    sub.w    #960,d6
.max_z:             cmp.w    #64,d6
                    bgt.b    .min_z
                    add.w    #960,d6
.min_z:             move.w   d4,(a1)+
                    move.w   d5,(a1)+
                    move.w   d6,(a1)+
                    muls     stars_aspect_x(pc),d4
                    muls     stars_aspect_y(pc),d5
                    divs     d6,d4
                    divs     d6,d5
                    add.w    (a3),d4
                    add.w    2(a3),d5
                    bsr.b    plot_star
                    dbra     d3,.plots
no_plot:            rts

plot_star:          tst.w    d4
                    bmi.b    no_plot
                    tst.w    d5
                    bmi.b    no_plot
                    cmp.w    #384,d4
                    bge.b    no_plot
                    cmp.w    #256,d5
                    bge.b    no_plot
                    move.w   d5,d7
                    asl.w    #5,d5
                    asl.w    #4,d7
                    add.w    d7,d5                      ; * 40
                    move.w   d4,d7
                    asr.w    #3,d4                      ; / 8
                    add.w    d4,d5                      ; x + y
                    ext.l    d5
                    lea      (a2,d5.l),a5
                    and.b    #7,d7
                    moveq    #7,d4
                    sub.b    d7,d4
                    asr.w    #7,d6
                    btst     #0,d6
                    bne.b    .plane_1
                    bset     d4,(a5)
.plane_1:           btst     #1,d6
                    bne.b    .plane_2
                    bset     d4,(256*48)(a5)
.plane_2:           btst     #2,d6
                    bne.b    .plane_3
                    bset     d4,(256*2*48)(a5)
.plane_3:           move.l   d5,(a4)+                   ; save the coordinate
                    rts

set_stars_buffer:   lea      stars_swap_buffers(pc),a0
                    not.w    (a0)
                    beq.b    .buffer_2
                    lea      stars_bps_dat2(pc),a0
                    lea      stars_bps(pc),a1
                    moveq    #6-1,d0
.copy_1:            move.l   (a0)+,(a1)+
                    dbra     d0,.copy_1
                    lea      stars_bitplane1,a0
                    move.l   a0,stars_bitplanes_ptr
                    lea      stars_screen_coords1(pc),a0
                    move.l   a0,stars_screen_coords_ptr
                    rts

.buffer_2:          lea      stars_bps_dat1(pc),a0
                    lea      stars_bps(pc),a1
                    moveq    #6-1,d0
.copy_2:            move.l   (a0)+,(a1)+
                    dbra     d0,.copy_2
                    lea      stars_bitplane2,a0
                    move.l   a0,stars_bitplanes_ptr
                    lea      stars_screen_coords2(pc),a0
                    move.l   a0,stars_screen_coords_ptr
                    rts

stars_swap_buffers: dc.w     0

setup_stars:        bsr.b    prepare_stars_bitplanes
                    ; no rts
create_stars_coords:
                    move.l   #$4D373729,d0
                    move.l   d0,d1
                    rol.w    #3,d1
                    swap     d1
                    eor.l    #$5A5AA5A5,d1
                    bsr      set_random_seed
                    lea      stars_3d_coords,a5
                    move.w   #409-1,d5
.create_x:          move.w   #768,d0
                    bsr      rand
                    sub.w    #384,d0
                    move.w   d0,(a5)
                    lea      6(a5),a5
                    dbra     d5,.create_x

                    lea      stars_3d_coords+2,a5
                    move.w   #409-1,d5
.create_y:          move.w   #512,d0
                    bsr      rand
                    sub.w    #256,d0
                    move.w   d0,(a5)
                    lea      6(a5),a5
                    dbra     d5,.create_y
                    
                    lea      stars_3d_coords+4,a5
                    move.w   #409-1,d5
.create_z:          move.w   #1024,d0
                    bsr      rand
                    move.w   d0,(a5)
                    lea      6(a5),a5
                    dbra     d5,.create_z
                    rts

prepare_stars_bitplanes:
                    lea      stars_bitplane1,a0
                    move.w   #(256*48*3)-1,d0
.clear_plane_1:     clr.b    (a0)+
                    dbra     d0,.clear_plane_1
                    lea      stars_bitplane2,a0
                    move.w   #(256*48*3)-1,d0
.clear_plane_2:     clr.b    (a0)+
                    dbra     d0,.clear_plane_2
                    move.l   #stars_bitplane1,d0
                    lea      stars_bps_dat1(pc),a0
                    move.w   #BPL1PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL1PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #BPL3PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL3PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #BPL5PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL5PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.l   #stars_bitplane2,d0
                    lea      stars_bps_dat2(pc),a0
                    move.w   #BPL1PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL1PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #BPL3PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL3PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    add.l    #(256*48),d0
                    move.w   #BPL5PTH,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    move.w   #BPL5PTL,(a0)+
                    swap     d0
                    move.w   d0,(a0)+
                    rts

stars_screen_coords1:
                    dcb.l    200,0
stars_screen_coords2:
                    dcb.l    200,0
stars_bps_dat1:     dcb.l    6,0
stars_bps_dat2:     dcb.l    6,0
stars_bitplanes_ptr:
                    dc.l     stars_bitplane1
stars_screen_coords_ptr:
                    dc.l     stars_screen_coords1
stars_pos_x:        dc.w     0
stars_pos_y:        dc.w     0
stars_pos_z:        dc.w     1
stars_nbr:          dc.w     81-1

stars_centers:      dc.w     144,128
stars_aspect_x:     dc.w     160
stars_aspect_y:     dc.w     127

move_stars:         move.l   stars_direction_x(pc),a0
                    cmp.w    #-32,(a0)
                    bne.b    reset_stars_dir_x
                    move.l   #stars_directions_table,stars_direction_x
                    lea      stars_directions_table(pc),a0
reset_stars_dir_x:  addq.l   #2,stars_direction_x
                    move.w   (a0),stars_pos_x
                    move.l   stars_direction_y(pc),a0
                    cmp.w    #-32,(a0)
                    bne.b    reset_stars_dir_y
                    move.l   #stars_directions_table,stars_direction_y
                    lea      stars_directions_table(pc),a0
reset_stars_dir_y:  addq.l   #2,stars_direction_y
                    move.w   (a0),stars_pos_y
                    move.l   stars_direction_z(pc),a0
                    cmp.w    #-32,(a0)
                    bne.b    reset_stars_dir_z
                    move.l   #stars_directions_table,stars_direction_z
                    lea      stars_directions_table(pc),a0
reset_stars_dir_z:  addq.l   #2,stars_direction_z
                    move.w   (a0),stars_pos_z
                    rts

stars_direction_x:  dc.l     stars_directions_table
stars_direction_y:  dc.l     stars_directions_table+(256*2)
stars_direction_z:  dc.l     stars_directions_table+(384*2)

stars_directions_table:
                    dcb.w    32,0
                    dcb.w    32,1
                    dcb.w    32,2
                    dcb.w    32,3
                    dcb.w    32,4
                    dcb.w    32,5
                    dcb.w    32,6
                    dcb.w    32,7
                    dcb.w    32,8
                    dcb.w    32,7
                    dcb.w    32,6
                    dcb.w    32,5
                    dcb.w    32,4
                    dcb.w    32,3
                    dcb.w    32,2
                    dcb.w    32,1
                    dcb.w    32,0
                    dcb.w    32,-1
                    dcb.w    32,-2
                    dcb.w    32,-3
                    dcb.w    32,-4
                    dcb.w    32,-5
                    dcb.w    32,-6
                    dcb.w    32,-7
                    dcb.w    32,-8
                    dcb.w    32,-7
                    dcb.w    32,-6
                    dcb.w    32,-5
                    dcb.w    32,-4
                    dcb.w    32,-3
                    dcb.w    32,-2
                    dcb.w    32,-1
                    dc.w     -32

display_text:
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      palette_menu(pc),a0
                    lea      copper_palette_menu(pc),a1
                    moveq    #8,d0
                    bsr      set_palette
                    movem.l  (sp)+,d0-d7/a0-a6
                    lea      CUSTOM,a6
                    moveq    #0,d0
                    moveq    #0,d1
                    move.w   (a0)+,d0
                    move.w   (a0)+,d1
                    add.w    #68,d0
                    add.w    #12,d1
                    move.l   d0,d7
next_letter:
                    move.l   (a1),a2
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
                    cmp.b    #' ',d2
                    beq      dont_move_caret
                    move.l   36(a1),a3
search_letter:
                    cmp.b    (a3)+,d2
                    beq.b    display_letter
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.b    search_letter
                    bra      end_of_line
display_letter:
                    move.l   32(a1),a3
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
                    cmp.l    #2,menu_seq_flag
                    beq.b    dont_move_caret
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      caret_struct(pc),a0
                    move.w   d0,(a0)
                    move.w   d1,2(a0)
                    add.w    #16,(a0)
                    addq.w   #1,2(a0)
                    bsr      wait_sync
                    movem.l  (sp)+,d0-d7/a0-a6
dont_move_caret:    add.l    #9,d0
                    tst.b    (a0)
                    bmi.b    end_of_line
                    bne      next_letter
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    #12,d1
                    addq.l   #1,d1
                    bra      next_letter

end_of_line:        rts

letter_buffer:      dcb.l    32,0

wait_sync:          cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    wait_sync
.wait:              cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    .wait
                    rts

font_struct:        dc.l     bitplanes,(240*40),3,36,16,16,80,(16*84),font_pic,ascii_letters
font_menu_struct:   dc.l     menu_bitplanes,(146*40),3,36,16,16,80,(16*84),font_pic,ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ>1234567890.!?: '
                    even

disp_credits:       move.l   text_credits_ptr(pc),a0
                    tst.l    (a0)
                    bne.b    .next
                    lea      text_credits_table(pc),a0
                    cmp.l    #text_credits_table,text_credits_ptr
                    bmi.b    .reset
                    cmp.l    #text_credits1,text_credits_ptr
                    bpl.b    .reset
                    move.l   #-1,return_value                   ; run story_exe
                    move.w   #1,break_main_loop_flag
                    move.l   a0,text_credits_ptr
                    rts

.reset:             move.l   a0,text_credits_ptr
.next:              addq.l   #4,text_credits_ptr
                    move.l   (a0),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    move.l   #350,d0
.wait:              tst.w    break_main_loop_flag
                    bne      .exit_credits
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    .button_pressed
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      .button_pressed
                    bsr      wait_sync2
                    subq.l   #1,d0
                    bne.b    .wait
                    lea      palette_menu(pc),a0
                    lea      palette_menu_red(pc),a1
                    lea      copper_palette_menu(pc),a2
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_to_rgb
                    bsr      wait_vsync_with_done_fade
                    lea      palette_menu_red(pc),a0
                    lea      palette_black(pc),a1
                    lea      copper_palette_menu(pc),a2
                    moveq    #8,d0
                    bsr      prep_fade_speeds_fade_to_rgb
                    bsr      wait_vsync_with_done_fade
                    bsr      clear_menu_bitplanes
                    bra      disp_credits

.exit_credits:      rts

.button_pressed:    move.w   #1,break_main_loop_flag
                    rts

wait_sync2:         cmp.b   #255,CUSTOM+VHPOSR
                    bne.b   wait_sync2
.wait:              cmp.b   #0,CUSTOM+VHPOSR
                    bne.b   .wait
                    rts

clear_menu_bitplanes:
                    lea      bitplanes+(96*40)(pc),a0
                    WAIT_BLIT
                    move.l   #$1000000,CUSTOM+BLTCON0
                    clr.w    CUSTOM+BLTDMOD
                    moveq    #3,d0
blit_clear:         move.l   a0,CUSTOM+BLTDPTH
                    move.w   #(144*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    add.l    #(240*40),a0
                    subq.l   #1,d0
                    bne.b    blit_clear
                    rts

text_credits_ptr:   dc.l    text_credits_table
text_credits_table: dc.l    text_credits1
                    dc.l    text_credits2
                    dc.l    text_credits3
                    dc.l    text_credits4
                    dc.l    text_credits5
                    dc.l    text_credits6
                    dc.l    text_credits7
                    dc.l    text_credits8
                    dc.l    text_credits9
                    dc.l    0

text_credits1:      dc.w     4,136
                    dc.b     '   PROGRAMMED BY:   ',0
                    dc.b     '   ANDREAS TADIC    ',0
                    dc.b     '    PETER TULEBY    '
                    dc.b     -1
                    even
text_credits2:      dc.w     4,136
                    dc.b     'GRAPHICS AND CONCEPT',0
                    dc.b     '         BY:        ',0
                    dc.b     '     RICO HOLMES    '
                    dc.b     -1
                    even
text_credits3:      dc.w     4,136
                    dc.b     ' SOUND AND MUSIC BY:',0
                    dc.b     '  ALLISTER BRIMBLE  '
                    dc.b     -1
                    even
text_credits4:      dc.w     4,136
                    dc.b     'ADDITIONAL CODE AND ',0
                    dc.b     'CD32 PROGRAMMING BY:',0
                    dc.b     '   STEFAN BOBERG    '
                    dc.b     -1
                    even
text_credits5:      dc.w     2,136
                    dc.b     'SPECIAL EDITION CODING:',0
                    dc.b     '     ANDREAS TADIC     '
                    dc.b     -1
                    even
text_credits6:      dc.w     4,136
                    dc.b     'SPEECH COURTESY OF: ',0
                    dc.b     '   LYNETTE READE    '
                    dc.b     -1
                    even
text_credits7:      dc.w     4,136
                    dc.b     '  GAME DESIGNED BY: ',0
                    dc.b     '     RICO HOLMES    ',0
                    dc.b     '     MARTYN BROWN   '
                    dc.b     -1
                    even
text_credits8:      dc.w     4,136
                    dc.b     ' PROJECT MANAGEMENT ',0
                    dc.b     '         BY:        ',0
                    dc.b     '    MARTYN BROWN    '
                    dc.b     -1
                    even
text_credits9:      dc.w     4,136
                    dc.b     ' A TEAM 17 SOFTWARE ',0
                    dc.b     '     PRODUCTION     ',0
                    dc.b     '        1992        '
                    dc.b     -1
                    even

set_random_seed:    add.l    d0,d1
                    movem.l  d0/d1,seed
get_rnd_number:     movem.l  d2/d3,-(sp)
                    movem.l  seed(pc),d0/d1
                    and.b    #$E,d0
                    or.b     #$20,d0
                    move.l   d0,d2
                    move.l   d1,d3
                    add.l    d2,d2
                    addx.l   d3,d3
                    add.l    d2,d0
                    addx.l   d3,d1
                    swap     d3
                    swap     d2
                    move.w   d2,d3
                    clr.w    d2
                    add.l    d2,d0
                    addx.l   d3,d1
                    movem.l  d0/d1,seed
                    move.l   d1,d0
                    movem.l  (sp)+,d2/d3
                    rts

rand:               addq.w   #1,d0
                    move.w   d0,d2
                    beq.b    .nop
                    bsr.b    get_rnd_number
                    clr.w    d0
                    swap     d0
                    divu     d2,d0
                    clr.w    d0
                    swap     d0
.nop:               rts

seed:               dcb.l    2,0
share_credits:      dc.l     0
palette_black:      dcb.w    32,0

; -----------------------------------------------------

font_pic:           incbin   "font_16x672.lo3"

bitplanes:          dcb.b    (240*40*3),0
stars_bitplane1:    dcb.b    (256*48*3),0
stars_bitplane2:    dcb.b    (256*48*3),0

copyright_pic:      incbin   "copyright_320x16.lo3"

copyright_palette:  dc.w     $000,$620,$720,$830,$940,$A40,$B50,$C60
empty_pic:          dcb.b    1280,0
stars_3d_coords:    dcb.w    120,0
menu_bitplanes:     dcb.b    (146*40*3)+(94*40),0

title_pic:          incbin   "title_320x180.lo3"

                    end
