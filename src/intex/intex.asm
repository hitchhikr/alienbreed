; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------
; Note: all prices are multiplied by 50

; -----------------------------------------------------

                    include  "common.inc"

; -----------------------------------------------------

                    section  intex,code_c

start:              move.l   d0,player_pos_x
                    move.l   d1,player_pos_y
                    move.l   d2,owned_weapons
                    move.l   a0,player_struct
                    move.l   a0,cur_credits
                    move.l   a1,gameport_register
                    move.l   a2,key_pressed
                    move.l   a3,briefing_text
                    move.l   a4,cur_map_top
                    move.l   a5,sound_routine
                    move.l   a6,schedule_sample_to_play
                    bsr      set_bitplanes_and_palette
                    bsr      set_gfx_context
                    bsr      display_intex_startup_seq
                    lea      welcome_sample_struct(pc),a6
                    move.l   schedule_sample_to_play(pc),a5
                    jsr      (a5)
main_loop:          bsr      copy_bkgnd_pic
                    lea      text_main_menu(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    bsr      disp_caret_in_menu
.wait_user_input:   move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #$100,d0
                    bne.b    .going_up
                    tst.l    menu_choice
                    beq.b    .going_up
                    subq.l   #1,menu_choice
                    bsr      disp_caret_in_menu
                    bsr      wait_input_release
.going_up:          cmp.w    #1,d0
                    bne.b    .going_down
                    cmp.l    #7,menu_choice
                    beq.b    .going_down
                    addq.l   #1,menu_choice
                    bsr      disp_caret_in_menu
                    bsr      wait_input_release
.going_down:        bsr      flash_caret
                    moveq    #CIAB_GAMEPORT1,d0
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    .game_port_1
                    moveq    #CIAB_GAMEPORT0,d0
.game_port_1:       btst     d0,CIAA
                    bne      .wait_user_input
                    bsr      play_sample_caret_move
                    cmp.l    #4,menu_choice
                    beq      enter_holocode
return_from_holocode:
                    cmp.l    #7,menu_choice
                    beq      scr_disconnecting
                    tst.l    menu_choice
                    bne.b    go_scr_weapons
                    move.l   #$00980000,copper_scr_weapon_block
                    bsr      scr_weapons
                    move.l   #$FFFFFFFE,copper_scr_weapon_block
go_scr_weapons:     cmp.l    #1,menu_choice
                    bne.b    go_scr_tool_supplies
                    bsr      scr_tool_supplies
go_scr_tool_supplies: 
                    cmp.l    #2,menu_choice
                    bne.b    go_scr_map
                    bsr      scr_map
go_scr_map:         cmp.l    #3,menu_choice
                    bne.b    go_scr_briefing
                    bsr      scr_briefing
go_scr_briefing:    cmp.l    #5,menu_choice
                    bne.b    go_scr_stats
                    bsr      scr_stats
go_scr_stats:       cmp.l    #6,menu_choice
                    bne.b    go_scr_infos
                    bsr      scr_infos
go_scr_infos:       bra      main_loop

scr_disconnecting:  bsr      copy_bkgnd_pic
                    lea      text_disconnecting(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    move.l   #1,d0
                    bsr      wait_timed_frames
                    move.l   #6,d0
                    bsr      mess_up_screen
                    move.l   #copperlist_blank,CUSTOM+COP1LCH
                    bsr      remove_caret
                    move.l   #copperlist_blank,CUSTOM+COP1LCH
                    lea      cur_holocode(pc),a0
                    move.l   owned_weapons(pc),d0
                    move.l   purchased_supplies(pc),d1
                    rts

wait_vblank:        cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    wait_vblank
.wait:              cmp.b    #0,CUSTOM+VHPOSR
                    bne.b    .wait
                    rts

scr_infos:          btst     #CIAB_GAMEPORT0,CIAA
                    beq      scr_infos
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      scr_infos
                    bsr      wait_vblank
                    bsr      wait_vblank
                    bsr      wait_vblank
                    bsr      wait_vblank
                    clr.l    menu_choice
                    ; remove the caret sprite
                    move.l   #$960020,sprites_dmacon
                    move.l   #text_info_table,ptr_text_info_table
loop_infos:         bsr      copy_bkgnd_pic
                    move.l   ptr_text_info_table(pc),a0
                    move.l   (a0),a0
                    lea      font_struct(pc),a1
                    move.w   #1,interruptible_by_used_flag
                    clr.w    interrupted_by_user_flag
                    bsr      display_text
                    clr.w    interruptible_by_used_flag
                    move.w   interrupted_by_user_flag(pc),d7
                    clr.w    interrupted_by_user_flag
                    tst.w    d7
                    bne      exit_infos
.wait_user_input:   btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    exit_infos
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq.b    exit_infos
                    move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #3,d0
                    beq.b    .got_user_input
                    cmp.w    #$300,d0
                    bne.b    .wait_user_input
.got_user_input:    cmp.w    #3,d0
                    bne.b    .next_page
                    move.l   ptr_text_info_table(pc),a0
                    tst.l    4(a0)
                    beq      .wait_user_input
                    addq.l   #4,ptr_text_info_table
.next_page:         cmp.w    #$300,d0
                    bne.b    .prev_page
                    move.l   ptr_text_info_table(pc),a0
                    cmp.l    #text_info_table,a0
                    beq      .wait_user_input
                    subq.l   #4,ptr_text_info_table
.prev_page:         bra      loop_infos

exit_infos:         ; display caret sprite
                    move.l   #$968020,sprites_dmacon
                    rts

ptr_text_info_table:
                    dc.l     text_info_table
text_info_table:    dc.l     text_infos_page_1
                    dc.l     text_infos_page_2
                    dc.l     text_infos_page_3
                    dc.l     text_infos_page_4
                    dc.l     text_infos_page_5
                    dc.l     text_infos_page_6
                    dc.l     text_infos_page_7
                    dc.l     text_infos_page_8
                    dc.l     text_infos_page_9
                    dc.l     text_infos_page_10
                    dc.l     text_infos_page_11
                    dc.l     text_infos_page_12
                    dc.l     text_infos_page_13
                    dc.l     text_infos_page_14
                    dc.l     text_infos_page_15
                    dc.l     text_infos_page_16
                    dc.l     text_infos_page_17
                    dc.l     text_infos_page_18
                    dc.l     text_infos_page_19
                    dc.l     0

scr_stats:          bsr      copy_bkgnd_pic
                    move.l   owned_weapons(pc),d0
                    move.l   #2,d1
                    move.l   #6,d2
                    lea      NO_MSG(pc),a0
.next_weapon:       btst     d1,d0
                    beq.b    .weapon_not_owned
                    move.b   #'Y',(a0)
                    move.b   #'E',1(a0)
                    move.b   #'S',2(a0)
                    bra.b    .weapon_owned

.weapon_not_owned:  move.b   #' ',(a0)
                    move.b   #'N',1(a0)
                    move.b   #'O',2(a0)
.weapon_owned:      addq.w   #1,d1
                    add.l    #41,a0
                    subq.w   #1,d2
                    bne.b    .next_weapon
                    move.l   player_struct(pc),a0
                    move.l   INTEX_ALIENS_KILLED(a0),d0
                    move.l   d0,number_to_display
                    bsr      construct_number_ascii
                    lea      number_ascii_block(pc),a0
                    lea      text_aliens_killed(pc),a1
                    bsr      copy_stat_number
                    move.l   player_struct(pc),a0
                    move.l   INTEX_SHOTS_FIRED(a0),d0
                    move.l   d0,number_to_display
                    bsr      construct_number_ascii
                    lea      number_ascii_block(pc),a0
                    lea      text_bullets_fired(pc),a1
                    bsr      copy_stat_number
                    move.l   player_struct(pc),a0
                    move.l   INTEX_CUR_CREDITS(a0),d0
                    divu     #50,d0
                    move.l   d0,INTEX_UNUSED(a0)
                    move.l   d0,number_to_display
                    bsr      construct_number_ascii
                    lea      number_ascii_block(pc),a0
                    lea      text_credits_owned,a1
                    bsr      copy_stat_number
                    move.l   player_struct(pc),a0
                    move.l   INTEX_DOORS_OPENED(a0),d0
                    move.l   d0,number_to_display
                    bsr      construct_number_ascii
                    lea      number_ascii_block(pc),a0
                    lea      text_doors_opened(pc),a1
                    bsr      copy_stat_number
                    move.l   player_struct(pc),a0
                    move.l   INTEX_AMMO_PACKS(a0),d0
                    move.l   d0,number_to_display
                    bsr      construct_number_ascii
                    lea      number_ascii_block(pc),a0
                    lea      text_ammopacks_owned(pc),a1
                    bsr      copy_stat_number
                    move.l   player_struct(pc),a0
                    move.l   INTEX_HEALTH(a0),d0
                    lea      text_health_levels(pc),a0
                    lea      text_energy_left(pc),a1
                    cmp.w    #21,d0
                    bls.b    .sel_health_text
                    addq.l   #8,a0
                    cmp.w    #42,d0
                    bls.b    .sel_health_text
                    addq.l   #8,a0
.sel_health_text:   move.l   #8,d0
.copy_health_text:  move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    .copy_health_text
                    move.l   player_struct(pc),a0
                    move.l   INTEX_CUR_WEAPON(a0),d0
                    lea      text_current_weapon(pc),a1
                    lea      table_text_owned_weapons(pc),a0
.sel_weapon_entry:  cmp.l    #-1,(a0)
                    beq.b    .done
                    cmp.l    (a0),d0
                    beq      .done
                    addq.l   #8,a0
                    bra      .sel_weapon_entry
.done:              addq.l   #4,a0
                    move.l   (a0),a0
                    moveq    #14,d0
.copy_weapon_text:  move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    .copy_weapon_text
                    lea      text_statistics(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    move.l   #$960020,sprites_dmacon
                    bsr      wait_joy_button
                    move.l   #$968020,sprites_dmacon
                    rts

text_health_levels: dc.b     'LOW     AVERAGE GOOD    '
table_text_owned_weapons:
                    dc.l     1,MACHINEGUN_MSG
                    dc.l     2,TWINFIRE_MSG
                    dc.l     3,FLAMEARC_MSG
                    dc.l     4,PLASMAGUN_MSG
                    dc.l     5,FLAMETHROWER_MSG
                    dc.l     6,SIDEWINDERS_MSG
                    dc.l     7,LAZER_MSG
                    dc.l     -1,MACHINEGUN_MSG
MACHINEGUN_MSG:     dc.b     'MACHINE GUN   '
TWINFIRE_MSG:       dc.b     'TWIN FIRE     '
FLAMEARC_MSG:       dc.b     'FLAME ARC     '
PLASMAGUN_MSG:      dc.b     'PLASMA GUN    '
FLAMETHROWER_MSG:   dc.b     'FLAME THROWER '
SIDEWINDERS_MSG:    dc.b     'SIDEWINDERS   '
LAZER_MSG:          dc.b     'LAZER         '
                    even
text_statistics:    dc.w     0,16
                    dc.b     '           INTEX STATISTICS             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '     ALIENS KILLED:  '
text_aliens_killed: dc.b     '                   ',0
                    dc.b     '       SHOTS FIRED:  '
text_bullets_fired: dc.b     '       BULLETS     ',0
                    dc.b     '      CREDIT LIMIT:  '
text_credits_owned: dc.b     '       CR          ',0
                    dc.b     '      DOORS OPENED:  '
text_doors_opened:  dc.b     '                   ',0
                    dc.b     '        AMMO PACKS:  '
text_ammopacks_owned:
                    dc.b     '       CLIP        ',0
                    dc.b     '      ENERGY STATE:  '
text_energy_left:   dc.b     '                   ',0
                    dc.b     '    CURRENT WEAPON:  '
text_current_weapon:
                    dc.b     '                   ',0
                    dc.b     ' WEAPONS AVAILABLE:                     ',0
                    dc.b     '                                        ',0
                    dc.b     '       MACHINE GUN.....     YES         ',0
                    dc.b     '       TWIN FIRE.......     '
NO_MSG:             dc.b     ' NO         ',0
                    dc.b     '       FLAME ARC.......      NO         ',0
                    dc.b     '       PLASMA GUN......      NO         ',0
                    dc.b     '       FLAME THROWER...      NO         ',0
                    dc.b     '       SIDEWINDERS.....      NO         ',0
                    dc.b     '       LAZER...........      NO         '
                    dc.b     -1
                    even

copy_stat_number:   move.l   #6,d0
                    tst.b    (a0)
                    beq      .pad_text
.loop:              tst.b    (a0)
                    beq      .pad_text
                    move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.b    .loop
                    rts

.pad_text:          move.b   #' ',(a1)+
                    subq.w   #1,d0
                    bpl.b    .pad_text
                    rts

text_holocode:      dc.w     128,120
cur_holocode:       dc.b     '00000'
                    dc.b     -1
                    even
cur_holocode_position:
                    dc.w     0

enter_holocode:     bsr      copy_bkgnd_pic
                    lea      text_enter_holocode(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    bsr      disp_caret_holocode
.loop:              move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    move.w   cur_holocode_position(pc),d1
                    lea      cur_holocode(pc),a1
                    cmp.w    #$100,d0
                    bne.b    .increase_digit
                    move.b   0(a1,d1.w),d2
                    cmp.b    #'9',d2
                    bne.b    .max_digit
                    move.b   #'0'-1,0(a1,d1.w)
.max_digit:         addq.b   #1,0(a1,d1.w)
                    bsr      disp_holocode
                    bsr      wait_input_release
                    bra.b    .wait_user_input

.increase_digit:    cmp.w    #1,d0
                    bne.b    .decrease_digit
                    move.b   0(a1,d1.w),d2
                    cmp.b    #'0',d2
                    bne.b    .min_digit
                    move.b   #'9'+1,0(a1,d1.w)
.min_digit:         subq.b   #1,0(a1,d1.w)
                    bsr      disp_holocode
                    bsr      wait_input_release
                    bra.b    .wait_user_input

.decrease_digit:    cmp.w    #$300,d0
                    bne.b    .prev_holocode_pos
                    tst.w    d1
                    beq.b    .wait_user_input
                    subq.w   #1,cur_holocode_position
                    bsr      disp_caret_holocode
                    bsr      wait_input_release
                    bra.b    .wait_user_input

.prev_holocode_pos: cmp.w    #3,d0
                    bne.b    .wait_user_input
                    cmp.w    #4,d1
                    beq.b    .wait_user_input
                    addq.w   #1,cur_holocode_position
                    bsr      disp_caret_holocode
                    bsr      wait_input_release
.wait_user_input:   bsr      flash_caret
                    moveq    #CIAB_GAMEPORT1,d0
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    .port_2
                    moveq    #CIAB_GAMEPORT0,d0
.port_2:            btst     d0,CIAA
                    bne      .loop
                    bra      return_from_holocode

disp_holocode:      bsr      clear_holocode_back
                    lea      text_holocode(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    ; no rts

disp_caret_holocode:
                    lea      caret_struct(pc),a0
                    move.w   cur_holocode_position(pc),d0
                    lsl.w    #3,d0
                    add.w    #128,d0
                    move.w   d0,(a0)
                    move.w   #132,2(a0)
                    bra      disp_caret

play_sample_caret_move:
                    movem.l  d0-d7/a0-a6,-(sp)
                    moveq    #14,d0
                    moveq    #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

play_sample_disp_char:
                    movem.l  d0-d7/a0-a6,-(sp)
                    moveq    #48,d0
                    moveq    #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

scr_tool_supplies:  bsr      copy_bkgnd_pic
                    bsr      get_credit_limit
                    lea      text_tool_supplies(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    clr.l    supplies_caret_pos
.loop:              move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #$100,d0
                    bne.b    .prev_supply
                    tst.l    supplies_caret_pos
                    beq.b    .prev_supply
                    subq.l   #1,supplies_caret_pos
                    bsr      disp_caret_in_tool_supplies
                    bsr      wait_input_release
.prev_supply:       cmp.w    #1,d0
                    bne.b    .next_supply
                    cmp.l    #5,supplies_caret_pos
                    beq.b    .next_supply
                    addq.l   #1,supplies_caret_pos
                    bsr      disp_caret_in_tool_supplies
                    bsr      wait_input_release
.next_supply:       bsr      disp_caret_in_tool_supplies
                    bsr      flash_caret
                    moveq    #CIAB_GAMEPORT1,d0
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    .port_2
                    moveq    #CIAB_GAMEPORT0,d0
.port_2:            btst     d0,CIAA
                    bne      .loop
                    bsr      play_sample_caret_move
                    move.l   supplies_caret_pos(pc),d0
                    cmp.l    #5,d0
                    beq      return
                    move.l   purchased_supplies(pc),d1
                    btst     d0,d1
                    bne      .loop
                    lea      supplies_prices_list(pc),a0
                    move.l   d0,d1
                    ext.l    d1
                    add.l    d1,d1
                    add.l    d1,d1
                    move.l   (a0,d1.w),d1
                    move.l   cur_credits(pc),a5
                    move.l   (a5),d2
                    cmp.l    d1,d2
                    bge.b    enough_money
                    lea      text_insufficient_funds_2(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    moveq    #1,d0
                    bsr      wait_timed_frames
                    bsr      clear_insufficient_funds_back
                    bra      .loop

enough_money:       sub.l    d1,(a5)
                    cmp.w    #2,d0                      ; energy injection
                    bne.b    add_player_health
                    add.l    #32,player_health
                    cmp.l    #PLAYER_MAX_HEALTH,player_health
                    bmi.b    add_player_health
                    move.l   #PLAYER_MAX_HEALTH,player_health
add_player_health:  movem.l  d0-d7/a0-a6,-(sp)
                    bsr      play_sample_supply_purchased
                    movem.l  (sp)+,d0-d7/a0-a6
                    moveq    #0,d1
                    bset     d0,d1
                    or.l     d1,purchased_supplies
                    add.l    d0,d0
                    lea      text_tool_bought(pc),a0
                    mulu     #41,d0
                    add.l    #29,d0
                    add.l    d0,a0
                    move.b   #' ',(a0)+
                    move.b   #'B',(a0)+
                    move.b   #'O',(a0)+
                    move.b   #'U',(a0)+
                    move.b   #'G',(a0)+
                    move.b   #'H',(a0)+
                    move.b   #'T',(a0)+
                    move.b   #'.',(a0)+
                    bra      scr_tool_supplies

supplies_prices_list:
                    dc.l     500000
                    dc.l     100000
                    dc.l     250000
                    dc.l     250000
                    dc.l     1500000
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
supplies_caret_pos: dc.l     0
purchased_supplies: dc.l     0

play_sample_supply_purchased:
                    move.l   schedule_sample_to_play(pc),a5
                    tst.w    d0
                    bne.b    lbC000E0A
                    lea      lbW0071C8(pc),a6
                    jmp      (a5)

lbC000E0A:          cmp.w    #1,d0
                    bne.b    lbC000E18
                    lea      lbW0071D2(pc),a6
                    jmp      (a5)

lbC000E18:          cmp.w    #2,d0
                    bne.b    lbC000E26
                    lea      lbW00720E(pc),a6
                    jmp      (a5)

lbC000E26:          cmp.w    #3,d0
                    bne.b    lbC000E34
                    lea      lbW0071FA(pc),a6
                    jmp      (a5)

lbC000E34:          cmp.w    #4,d0
                    bne.b    lbC000E42
                    lea      lbW0071E6(pc),a6
                    jmp      (a5)

lbC000E42:          rts

text_tool_supplies: dc.w     0,36
                    dc.b     '          INTEX TOOL SUPPLIES           ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
text_tool_bought:   dc.b     '    REMOTE LOCATION SCANNER  10000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '    AMMO CHARGE               2000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '    HIGH ENERGY INJECTION     5000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '    KEY PACK                  5000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '    ADDITIONAL LIFE          30000 CR   ',0
                    dc.b     '                                        ',0
                    dc.b     '                  EXIT                  ',0
                    dc.b     '                                       ',0
                    dc.b     '             CREDIT LIMIT: '
text_tool_credit_limit:
                    dcb.b    8,0
                    dc.b    -1
                    even

disp_caret_in_tool_supplies:
                    lea      caret_struct(pc),a0
                    move.l   supplies_caret_pos(pc),d0
                    mulu     #24,d0
                    add.l    #72,d0
                    move.w   d0,2(a0)
                    move.w   #16,(a0)
                    bra      disp_caret

get_credit_limit:   move.l   cur_credits(pc),a0
                    move.l   (a0),d0
                    divu     #50,d0
                    move.l   d0,number_to_display
                    bsr      construct_credit_limit_ascii
                    lea      number_ascii_block(pc),a0
                    lea      text_tool_credit_limit(pc),a1
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    rts

scr_briefing:       bsr      copy_bkgnd_pic
                    move.l   briefing_text(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    move.l   #$960020,sprites_dmacon
                    bsr      wait_joy_button
                    move.l   #$968020,sprites_dmacon
                    rts

peek_joy_button:    moveq    #CIAB_GAMEPORT1,d1
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    .port_2
                    moveq    #CIAB_GAMEPORT0,d1
.port_2:            moveq    #0,d0
                    btst     d1,CIAA
                    bne.b    .not_pressed
                    move.l   #-1,d0
.not_pressed:       rts

wait_joy_button:    moveq    #CIAB_GAMEPORT1,d0
                    move.l   gameport_register(pc),a0
                    cmp.l    #CUSTOM+JOY0DAT,a0
                    bne.b    .loop
                    moveq    #CIAB_GAMEPORT0,d0
.loop:              btst     d0,CIAA
                    bne.b    .loop
                    bra      play_sample_caret_move

display_intex_startup_seq:
                    move.b   CIAB+CIATODLOW,d1
                    cmp.b    #$7F,d1
                    bpl      .no_mess_up
                    moveq    #10,d0
                    bsr      mess_up_screen
                    tst.w    interrupted_by_user_flag
                    bne      startup_seq_interrupted
                    moveq    #1,d0
                    bsr      wait_timed_frames
                    tst.w    interrupted_by_user_flag
                    bne      startup_seq_interrupted
                    moveq    #25,d0
                    bsr      mess_up_screen
                    tst.w    interrupted_by_user_flag
                    bne      startup_seq_interrupted
                    moveq    #1,d0
                    bsr      wait_timed_frames
                    tst.w    interrupted_by_user_flag
                    bne      startup_seq_interrupted
                    moveq    #6,d0
                    bsr      mess_up_screen
                    tst.w    interrupted_by_user_flag
                    bne.b    startup_seq_interrupted
.no_mess_up:        move.w   #1,interruptible_by_used_flag
                    lea      text_connecting(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    tst.w    interrupted_by_user_flag
                    bne.b    startup_seq_interrupted
                    bsr      peek_joy_button
                    tst.l    d0
                    bmi      startup_seq_interrupted
                    moveq    #1,d0
                    bsr      wait_timed_frames_startup
                    lea      text_system_status(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    tst.w    interrupted_by_user_flag
                    bne.b    startup_seq_interrupted
                    bsr      peek_joy_button
                    tst.l    d0
                    bmi      startup_seq_interrupted
                    moveq    #2,d0
                    bsr      wait_timed_frames_startup
                    lea      text_downloading(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
startup_seq_interrupted:
                    clr.w    interruptible_by_used_flag
                    clr.w    interrupted_by_user_flag
                    move.l   #1,d0
                    bra      copy_bkgnd_pic

interrupted_by_user_flag:
                    dc.w     0
interruptible_by_used_flag:
                    dc.w     0

mess_up_screen:     movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #74,d0
                    move.l   #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
.loop:              btst     #7,CIAA
                    beq.b    .button_pressed
                    btst     #6,CIAA
                    beq.b    .button_pressed
                    bsr      flash_caret
                    move.b   CIAB+CIATODLOW,d1
                    ext.w    d1
                    move.b   d1,copper_diwstop
                    neg.w    d1
                    move.b   d1,copper_diwstrt
                    subq.l   #1,d0
                    bne.b    .loop
.abort:             move.w   #$2C81,copper_diwstrt
                    move.w   #$2CC1,copper_diwstop
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #75,d0
                    move.l   #0,d2
                    move.l   sound_routine(pc),a0
                    jsr      (a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

.button_pressed:    move.w   #1,interrupted_by_user_flag
                    bra      .abort

wait_timed_frames_startup:
                    mulu     #50,d0
                    move.l   d0,d7
.loop:              bsr      peek_joy_button
                    tst.l    d0
                    bmi.b    .pressed
                    bsr      flash_caret
                    subq.l   #1,d7
                    bne.b    .loop
                    rts

.pressed:           addq.l   #4,sp
                    bra      startup_seq_interrupted

wait_timed_frames:  mulu     #50,d0
.loop:              btst     #7,CIAA
                    beq.b    .interrupted_by_user
                    btst     #6,CIAA
                    beq.b    .interrupted_by_user
                    bsr      flash_caret
                    subq.l   #1,d0
                    bne.b    .loop
                    rts

.interrupted_by_user:
                    move.w   #1,interrupted_by_user_flag
                    rts

scr_map:            bsr      copy_bkgnd_pic
                    bsr      plot_map
                    lea      text_map_system(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    move.l   player_pos_x(pc),d0
                    move.l   player_pos_y(pc),d1
                    lsr.l    #3,d0
                    lsr.l    #3,d1
                    add.l    #29,d0
                    add.l    #24,d1
                    move.w   d0,caret_struct
                    move.w   d1,caret_position_y
                    lea      caret_struct(pc),a0
                    bsr      disp_caret
.loop:              bsr      flash_caret
                    btst     #7,CIAA
                    beq.b    .interrupted_by_user
                    btst     #6,CIAA
                    bne.b    .loop
.interrupted_by_user:
                    lea      map_plane,a0
                    move.l   #(256*40),d0
                    bsr      clear_map_plane
                    bra      copy_bkgnd_pic

cur_map_x:          dc.l     248
cur_map_y:          dc.l     202
cur_map_offset:     dc.l     25048

plot_map:           lea      map_plane,a5
                    move.l   cur_map_top(pc),a0
                    add.l    cur_map_offset(pc),a0
                    move.l   cur_map_x(pc),d0
                    move.l   cur_map_y(pc),d1
                    move.l   d0,d7
.loop:              move.w   -(a0),d2
                    and.w    #$3F,d2
                    beq.b    .no_plot
                    cmp.w    #3,d2
                    beq      .plot_door
                    cmp.w    #1,d2
                    bhi.b    .no_plot
                    move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    add.l    #32,d4
                    add.l    #28,d5
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    bset     d2,0(a4,d5.w)
                    bset     d2,40(a4,d5.w)
                    move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    add.l    #33,d4
                    add.l    #28,d5
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    bset     d2,0(a4,d5.w)
                    bset     d2,40(a4,d5.w)
.no_plot:           subq.w   #2,d0
                    bne.b    .loop
                    move.l   d7,d0
                    subq.w   #2,d1
                    bne.b    .loop
                    rts

.plot_door:         move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    sub.l    #(256*40*4),a4
                    add.l    #32,d4
                    add.l    #28,d5
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    sub.l    #(256*40*4),a4
                    add.l    #33,d4
                    add.l    #28,d5
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    add.l    #(256*40),a4
                    bclr     d2,0(a4,d5.w)
                    bclr     d2,40(a4,d5.w)
                    bra      .no_plot

clear_map_plane:    clr.b    (a0)+
                    subq.l   #1,d0
                    bne.b    clear_map_plane
                    rts

scr_weapons:        bsr      copy_bkgnd_pic
                    bsr      display_credit_limit
                    lea      text_weapons(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    bsr      disp_weapon
.loop:              bsr      flash_caret
                    bsr      user_change_weapon
                    tst.l    d0
                    beq.b    .weapon_changed
                    bsr      disp_weapon
.weapon_changed:    bsr      user_select_buy_weapon
                    move.l   key_pressed(pc),a0
                    bra      .loop

disp_caret_in_menu: lea      caret_struct(pc),a0
                    move.l   menu_choice(pc),d0
                    mulu     #12,d0
                    add.l    #68,d0
                    move.w   d0,2(a0)
                    move.w   #48,(a0)
                    bra      disp_caret

disp_caret_in_weapons:
                    lea      caret_struct(pc),a0
                    move.l   buy_weapon_yes_no(pc),d0
                    not.l    d0
                    and.l    #1,d0
                    mulu     #12,d0
                    add.l    #227,d0
                    move.w   d0,2(a0)
                    move.w   #128,(a0)
                    bra      disp_caret

user_select_buy_weapon:
                    move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    cmp.w    #1,d0
                    bne.b    .going_down
                    clr.l    buy_weapon_yes_no
.going_down:        cmp.w    #$100,d0
                    bne.b    .going_up
                    move.l   #1,buy_weapon_yes_no
.going_up:          bsr      disp_caret_in_weapons
                    bsr      peek_joy_button
                    tst.l    d0
                    beq      return
                    tst.l    buy_weapon_yes_no
                    bne      user_buying_weapon
                    addq.l   #4,sp
                    rts

user_buying_weapon: move.l   owned_weapons(pc),d1
                    move.l   current_weapon(pc),d0
                    addq.l   #2,d0
                    moveq    #0,d2
                    bset     d0,d2
                    and.w    d2,d1
                    tst.b    d1
                    bne      disp_already_owned_text
                    move.l   current_weapon(pc),d0
                    add.l    d0,d0
                    add.l    d0,d0
                    lea      weapons_prices_list(pc),a0
                    move.l   0(a0,d0.l),d0
                    move.l   cur_credits(pc),a0
                    move.l   (a0),d1
                    divu     #50,d1
                    cmp.l    d0,d1
                    bmi      disp_insufficient_funds_text
                    move.l   cur_credits(pc),a0
                    move.l   (a0),d1
                    mulu     #50,d0
                    sub.l    d0,d1
                    move.l   d1,(a0)
                    or.l     d2,owned_weapons
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   schedule_sample_to_play(pc),a5
                    lea      lbW0071D2(pc),a6
                    jsr      (a5)
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   purchased_supplies(pc),d0
                    or.l     #2,d0
                    move.l   d0,purchased_supplies
                    move.l   #2,d0
                    lea      text_tool_bought(pc),a0
                    mulu     #41,d0
                    add.l    #29,d0
                    add.l    d0,a0
                    move.b   #' ',(a0)+
                    move.b   #'B',(a0)+
                    move.b   #'O',(a0)+
                    move.b   #'U',(a0)+
                    move.b   #'G',(a0)+
                    move.b   #'H',(a0)+
                    move.b   #'T',(a0)+
                    move.b   #'.',(a0)+
                    bsr      copy_bkgnd_pic
                    lea      text_credits_debited(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    moveq    #1,d0
                    bsr      wait_timed_frames
                    addq.l   #4,sp
                    bra      scr_weapons

weapons_prices_list:
                    dc.l     10000
                    dc.l     24000
                    dc.l     35000
                    dc.l     48000
                    dc.l     60000
                    dc.l     75000
                    dc.l     0

disp_already_owned_text:
                    lea      text_already_owned(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    moveq    #2,d0
                    bsr      wait_timed_frames
                    addq.l   #4,sp
                    bra      scr_weapons

disp_insufficient_funds_text:
                    lea      text_insufficient_funds(pc),a0
                    lea      font_struct(pc),a1
                    bsr      display_text
                    moveq    #2,d0
                    bsr      wait_timed_frames
                    addq.l   #4,sp
                    bra      scr_weapons

set_bitplanes_and_palette:
                    move.l   #copperlist_blank,CUSTOM+COP1LCH
                    lea      copper_bitplanes(pc),a0
                    move.l   #bitplanes,d0
                    moveq    #5,d1
.set_bps:           move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(256*40),d0
                    addq.l   #8,a0
                    subq.b   #1,d1
                    bne.b    .set_bps
                    lea      background_pic+(256*40*4),a0
                    lea      copper_palette(pc),a1
                    moveq    #16,d0
.copy_palette:      move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #1,d0
                    bne.b    .copy_palette
                    move.w   #$2D1,copper_color_15
                    rts

return:             rts

change_caret_color: addq.w   #1,slowdown_caret_flash
                    cmp.w    #2,slowdown_caret_flash
                    bmi.b    return
                    clr.w    slowdown_caret_flash
                    move.l   ptr_caret_color_table(pc),a0
                    tst.w    (a0)
                    bpl.b    .reset
                    lea      caret_color_table(pc),a0
                    move.l   a0,ptr_caret_color_table
.reset:             addq.l   #2,ptr_caret_color_table
                    move.w   (a0),copper_caret_color
                    move.w   (a0),copper_caret_color_weapon_cost
                    rts

slowdown_caret_flash:
                    dc.w     0
ptr_caret_color_table:
                    dc.l     caret_color_table
caret_color_table:  dc.w     $040,$050,$060,$070,$080,$090,$0A0,$0B0,$0C0,$0D0,$0E0,$0F0
                    dc.w     $0E0,$0D0,$0C0,$0B0,$0A0,$090,$080,$070,$060,$050,$040
                    dc.w     -1

clear_weapon_back:  move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    WAIT_BLIT
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    lea      background_pic+(82*40),a0
                    lea      bitplanes+(82*40),a1
                    moveq    #4,d0
loop_clear_weapon:  move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(138*64)+20,CUSTOM+BLTSIZE
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    WAIT_BLIT
                    subq.b   #1,d0
                    bne.b    loop_clear_weapon
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

clear_insufficient_funds_back:
                    move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    WAIT_BLIT
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    lea      background_pic+(228*40),a0
                    lea      bitplanes+(228*40),a1
                    moveq    #4,d0
loop_clear_funds:   move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(28*64)+20,CUSTOM+BLTSIZE
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    WAIT_BLIT
                    subq.b   #1,d0
                    bne.b    loop_clear_funds
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

clear_holocode_back:
                    move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    WAIT_BLIT
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    lea      background_pic+(108*40),a0
                    lea      bitplanes+(108*40),a1
                    moveq    #4,d0
loop_clear_holo:    move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.w   #(28*64)+20,CUSTOM+BLTSIZE
                    add.l    #(256*40),a0
                    add.l    #(256*40),a1
                    WAIT_BLIT
                    subq.b   #1,d0
                    bne.b    loop_clear_holo
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

copy_bkgnd_pic:     move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    WAIT_BLIT
                    move.l   #$9F00000,CUSTOM+BLTCON0
                    move.l   #-1,CUSTOM+BLTAFWM
                    clr.l    CUSTOM+BLTAMOD
                    move.l   #background_pic,CUSTOM+BLTAPTH
                    move.l   #bitplanes,CUSTOM+BLTDPTH
                    moveq    #4,d0
loop_copy:          move.w   #(256*64)+20,CUSTOM+BLTSIZE
                    WAIT_BLIT
                    subq.b   #1,d0
                    bne.b    loop_copy
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

disp_weapon_pic:    lea      weapon_mask_pic(pc),a0
                    move.l   #(128*20),d0
.clear_dest:        clr.b    (a0)+
                    subq.w   #1,d0
                    bne.b    .clear_dest
                    lea      weapons_pic_table(pc),a0
                    move.l   current_weapon(pc),d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a0,d0.l),a0
                    lea      bitplanes+(116*40)+10,a1
                    WAIT_BLIT
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #-1,CUSTOM+BLTAFWM
                    move.l   #$DFC0000,CUSTOM+BLTCON0
                    clr.w    CUSTOM+BLTDMOD
                    clr.w    CUSTOM+BLTBMOD
                    move.w   #20,CUSTOM+BLTAMOD
                    moveq    #4,d0
loop_clear_w:       move.l   a0,CUSTOM+BLTAPTH
                    move.l   #weapon_mask_pic,CUSTOM+BLTDPTH
                    move.l   #weapon_mask_pic,CUSTOM+BLTBPTH
                    move.w   #(88*64)+10,CUSTOM+BLTSIZE
                    add.l    #(264*40),a0
                    WAIT_BLIT
                    subq.w   #1,d0
                    bne.b    loop_clear_w
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.w   #DMAF_SETCLR|DMAF_BLITHOG,CUSTOM+DMACON
                    move.l   #-1,CUSTOM+BLTAFWM
                    move.l   #$FE20000,CUSTOM+BLTCON0
                    move.w   #20,CUSTOM+BLTDMOD
                    move.w   #20,CUSTOM+BLTAMOD
                    move.w   #20,CUSTOM+BLTCMOD
                    clr.w    CUSTOM+BLTBMOD
                    moveq    #4,d0
loop_disp_w:        move.l   a0,CUSTOM+BLTAPTH
                    move.l   a1,CUSTOM+BLTDPTH
                    move.l   a1,CUSTOM+BLTCPTH
                    move.l   #weapon_mask_pic,CUSTOM+BLTBPTH
                    move.w   #(88*64)+10,CUSTOM+BLTSIZE
                    add.l    #(264*40),a0
                    add.l    #(256*40),a1
                    WAIT_BLIT
                    subq.b   #1,d0
                    bne.b    loop_disp_w
                    move.w   #DMAF_BLITHOG,CUSTOM+DMACON
                    rts

weapons_pic_table:  dc.l     weapons_pic+(176*40)
                    dc.l     weapons_pic
                    dc.l     weapons_pic+20
                    dc.l     weapons_pic+(176*40)+20
                    dc.l     weapons_pic+(88*40)+20
                    dc.l     weapons_pic+(88*40)

set_gfx_context:    move.l   #copperlist_main,CUSTOM+COP1LCH
                    bsr      copy_bkgnd_pic
                    lea      caret_struct(pc),a0
                    bsr      set_sprite_bp
                    lea      caret_struct(pc),a0
                    bra      disp_caret

remove_caret:       lea      caret_struct(pc),a0
                    move.w   #-16,(a0)
                    move.w   #-16,2(a0)
                    bra      disp_caret

display_credit_limit:
                    move.l   cur_credits(pc),a0
                    move.l   (a0),d0
                    divu     #50,d0
                    move.l   d0,number_to_display
                    bsr      construct_credit_limit_ascii
                    lea      number_ascii_block(pc),a0
                    lea      text_credit_limit(pc),a1
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    rts

construct_credit_limit_ascii:
                    lea      number_ascii_block(pc),a2
                    moveq    #32,d7
.clear_loop:        clr.b    (a2)+
                    subq.w   #1,d7
                    bne.b    .clear_loop
                    lea      number_ascii_block(pc),a0
                    move.l   number_to_display(pc),d0
                    bne.b    .zero_credits
                    move.b   #'0',(a0)+
                    bra.b    credit_footer
.zero_credits:      lea      decimal_table(pc),a1
                    cmp.l    #999999999,d0
                    bhi.b    max_credit
                    clr.l    leading_zeroes_flag
                    moveq    #'0',d2
.loop:              tst.l    (a1)
                    beq.b    credit_footer
                    move.l   (a1),d1
                    addq.b   #1,d2
                    sub.l    d1,d0
                    beq.b    .got_digit
                    bgt.b    .loop
                    add.l    d1,d0
                    subq.l   #1,d2
.got_digit:         addq.l   #4,a1
                    tst.b    leading_zeroes_flag
                    bne.b    .store_char
                    cmp.b    #'0',d2
                    beq.b    .dont_store_char
.store_char:        move.b   d2,(a0)+
                    move.b   #1,leading_zeroes_flag
.dont_store_char:   moveq    #'0',d2
                    bra.b    .loop

max_credit:         move.l   #'9999',(a0)
                    move.l   #'9999',4(a0)
                    move.b   #'9',8(a0)
                    add.l    #9,a0
credit_footer:      move.b   #' ',(a0)+
                    move.b   #'C',(a0)+
                    move.b   #'R',(a0)+
                    move.b   #-1,(a0)
                    rts

decimal_table:      dc.l     100000000
                    dc.l     10000000
                    dc.l     1000000
                    dc.l     100000
                    dc.l     10000
                    dc.l     1000
                    dc.l     100
                    dc.l     10
                    dc.l     1
                    dc.l     0
leading_zeroes_flag:
                    dc.l     0
number_to_display:  dc.l     0
number_ascii_block: dcb.l    80,0

construct_number_ascii:
                    lea      number_ascii_block(pc),a2
                    moveq    #32,d7
.clear_loop:        clr.b    (a2)+
                    subq.w   #1,d7
                    bne.b    .clear_loop
                    lea      number_ascii_block(pc),a0
                    move.l   number_to_display(pc),d0
                    bne.b    .zero
                    move.b   #'0',(a0)+
                    bra.b    pad_text
.zero:              lea      decimal_table(pc),a1
                    cmp.l    #999999999,d0
                    bhi.b    max_number
                    clr.l    leading_zeroes_flag
                    moveq    #'0',d2
.loop:              tst.l    (a1)
                    beq.b    pad_text
                    move.l   (a1),d1
                    addq.b   #1,d2
                    sub.l    d1,d0
                    beq.b    .got_digit
                    bgt.b    .loop
                    add.l    d1,d0
                    subq.l   #1,d2
.got_digit:         add.l    #4,a1
                    tst.b    leading_zeroes_flag
                    bne.b    .store_char
                    cmp.b    #'0',d2
                    beq.b    .dont_store_char
.store_char:        move.b   d2,(a0)+
                    move.b   #1,leading_zeroes_flag
.dont_store_char:   moveq    #'0',d2
                    bra.b    .loop

max_number:         move.l   #'9999',(a0)
                    move.l   #'9999',4(a0)
                    move.b   #'9',8(a0)
                    add.l    #9,a0
pad_text:           tst.b    (a0)
                    beq      return
                    move.b   #0,(a0)+
                    bra      pad_text

user_change_weapon: move.l   gameport_register(pc),a0
                    move.w   (a0),d1
                    moveq    #0,d0
                    and.w    #$303,d1
                    cmp.w    #$300,d1
                    bne.b    .prev_weapon
                    move.l   #1,d0
                    subq.l   #1,current_weapon
                    tst.l    current_weapon
                    bpl.b    .prev_weapon
                    move.l   #5,current_weapon
.prev_weapon:       cmp.w    #3,d1
                    bne.b    .next_weapon
                    move.l   #1,d0
                    addq.l   #1,current_weapon
                    cmp.l    #6,current_weapon
                    bmi.b    .next_weapon
                    clr.l    current_weapon
.next_weapon:       rts

disp_weapon_name:   move.l   current_weapon(pc),d0
                    add.l    d0,d0
                    add.l    d0,d0
                    lea      table_text_weapons(pc),a0
                    move.l   0(a0,d0.l),a0
                    lea      font_struct(pc),a1
                    bra      display_text

disp_weapon:        bsr      clear_weapon_back
                    bsr      disp_weapon_pic
                    bsr      disp_weapon_name
                    ; no rts

wait_input_release: move.l   gameport_register(pc),a0
                    move.w   (a0),d0
                    and.w    #$303,d0
                    bne.b    wait_input_release
                    bra      play_sample_caret_move

flash_caret:        cmp.b    #255,CUSTOM+VHPOSR
                    bne.b    flash_caret
.wait:              cmp.b    #44,CUSTOM+VHPOSR
                    bne.b    .wait
                    bra      change_caret_color

set_sprite_bp:      tst.l    16(a0)
                    bne.b    .set_sprite_ptr
                    move.l   12(a0),d0
.set_spr_copper_dat:
                    move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

.set_sprite_ptr:    move.l   16(a0),a1
                    move.l   a1,20(a0)
                    move.w   6(a1),24(a0)
                    move.l   (a1),d0
                    bra.b    .set_spr_copper_dat

disp_caret:         move.l   8(a0),a1
                    tst.l    16(a0)
                    bne      .animate
.set_spr_pos:       and.w    #$80,14(a1)
                    move.w   (a0),d0
                    add.w    #$80,d0
                    btst     #0,d0
                    beq.b    .upper_x_pos_bit
                    or.w     #1,14(a1)
.upper_x_pos_bit:   lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    add.w    #44,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #256,d1
                    bmi.b    .pal_bottom
                    sub.w    #255,d1
                    or.b     #2,15(a1)
.pal_bottom:        move.b   d1,14(a1)
                    cmp.w    #256,d0
                    bmi.b    .pal_top
                    sub.w    #255,d0
                    or.b     #4,15(a1)
.pal_top:           move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.b    .done
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
.done:              rts

.animate:           subq.w   #1,24(a0)
                    bpl      .set_spr_pos
                    addq.l   #8,20(a0)
.set_sprite_copper: move.l   20(a0),a2
                    move.l   (a2),d0
                    bmi.b    .reset_anim
                    move.w   6(a2),24(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      .set_spr_pos

.reset_anim:        move.l   16(a0),20(a0)
                    bra.b    .set_sprite_copper

caret_struct:       dc.w     -16
caret_position_y:   dc.w     -16
                    dc.w     11
                    dc.w     0
                    dc.l     copper_caret_sprite
                    dc.l     caret_pic
                    dc.l     0
                    dc.l     0
                    dc.w     0
                    dc.w     0
caret_pic:          dcb.w    22,%1111111100000000
                    dcb.w    128,0

display_text:       lea      CUSTOM,a6
                    moveq    #0,d0
                    moveq    #0,d1
                    move.w   (a0)+,d0
                    move.w   (a0)+,d1
                    move.l   d0,d7
loop_text:          tst.w    interruptible_by_used_flag
                    beq.b    .not_interruptible
                    move.w   #1,interrupted_by_user_flag
                    btst     #7,CIAA
                    beq      end_of_line
                    btst     #6,CIAA
                    beq      end_of_line
                    clr.w    interrupted_by_user_flag
.not_interruptible: move.l   (a1),a2
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
                    beq      skip_char
                    move.l   36(a1),a3
.search_char:       cmp.b    (a3)+,d2
                    beq.b    .found_char
                    addq.l   #2,d4
                    tst.b    (a3)
                    bne.b    .search_char
                    bra      skip_char
.found_char:        move.l   32(a1),a3
                    add.l    d4,a3
                    WAIT_BLIT
                    move.l   #$1000000,BLTCON0(a6)
                    move.l   #letter_buffer,BLTDPTH(a6)
                    move.w   #2,BLTDMOD(a6)
                    move.w   #(16*64)+1,BLTSIZE(a6)
                    move.l   8(a1),d2
                    move.l   28(a1),d5
                    move.l   #letter_buffer,d4
                    WAIT_BLIT
                    move.l   #-1,BLTAFWM(a6)
                    move.l   #$DFC0000,BLTCON0(a6)
                    move.l   24(a1),d6
                    addq.w   #2,d6
                    move.w   d6,BLTAMOD(a6)
                    move.w   #2,BLTDMOD(a6)
                    move.w   #2,BLTBMOD(a6)
                    move.l   a3,d6
copy_letter_to_buffer:
                    WAIT_BLIT
                    move.l   d6,BLTAPTH(a6)
                    move.l   d4,BLTBPTH(a6)
                    move.l   d4,BLTDPTH(a6)
                    move.w   #(16*64)+1,BLTSIZE(a6)
                    add.l    d5,d6
                    subq.w   #1,d2
                    bne.b    copy_letter_to_buffer
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
copy_text_to_screen:
                    WAIT_BLIT
                    move.l   d4,BLTBPTH(a6)
                    move.l   a3,BLTAPTH(a6)
                    move.l   a2,BLTCPTH(a6)
                    move.l   a2,BLTDPTH(a6)
                    move.w   d6,BLTSIZE(a6)
                    add.l    d2,a2
                    add.l    d3,a3
                    subq.b   #1,d5
                    bne.b    copy_text_to_screen
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      caret_struct(pc),a0
                    move.w   d0,(a0)
                    move.w   d1,2(a0)
                    subq.w   #1,2(a0)
                    bsr      disp_caret
                    addq.w   #1,slowdown_play_sample
                    cmp.w    #3,slowdown_play_sample
                    bne.b    .dont_play_sample
                    clr.w    slowdown_play_sample
                    bsr      play_sample_disp_char
.dont_play_sample:  not.w    slowdown_flash_caret
                    beq.b    .dont_flash_caret
                    bsr      flash_caret
.dont_flash_caret:  movem.l  (sp)+,d0-d7/a0-a6
skip_char:          add.l    16(a1),d0
                    tst.b    (a0)
                    bmi.b    end_of_line
                    bne      loop_text
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    20(a1),d1
                    bra      loop_text

end_of_line:        lea      caret_struct(pc),a0
                    add.w    #12,(a0)
                    bra      disp_caret

; -----------------------------------------------------

slowdown_flash_caret:
                    dc.w     0
slowdown_play_sample:
                    dc.w     0
letter_buffer:      dcb.l    (16*2),0
font_struct:        dc.l     bitplanes,(256*40),4,36,8,12,80,(16*63),font_pic,ascii_letters
ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ>1234567890.!?: ',0
                    even
text_map_system:    dc.w     0,12
                    dc.b     '        INTEX MAPSYSTEM V2.0          ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     ' ',0
                    dc.b     '  YOU ARE LOCATED AT CURSORS POSITION!'
                    dc.b     -1
                    even
text_connecting:    dc.w     0,48
                    dc.b     'INTEX NETWORK CONNECT: CODE ABF01DCC61',0
                    dc.b     'CONNECTING.....................'
                    dc.b     -1
                    even
text_system_status: dc.w     0,84
                    dc.b     'INTEX NETWORK SYSTEM V10.1',0
                    dc.b     '2.5G RAM:         OK',0
                    dc.b     'EXTERNAL DEVICE:  OK',0
                    dc.b     'SYSTEM V1.32 CS:  OK',0
                    dc.b     'VIDEODISPLAY:     CCC2.A2',0
                    dc.b     'TEXT UPDATE ACCCELERATOR INSTALLED.'
                    dc.b     -1
                    even
text_downloading:   dc.w     0,168
                    dc.b     'EXECUTING DOS 6.0',0
                    dc.b     'SYSTEM DOWNLOADING NETWORK DATA.... OK',0
                    dc.b     'INTEX EXECUTED!'
                    dc.b     -1
                    even
text_disconnecting: dc.w     0,64
                    dc.b     '  DISCONNECTING..............'
                    dc.b     -1
                    even
text_credits_debited:
                    dc.w     0,62
                    dc.b     '     CREDITS DEBITED.'
                    dc.b     -1
                    even
text_already_owned: dc.w     0,211
                    dc.b     '     YOU ALREADY OWN THAT WEAPON.'
                    dc.b     -1
                    even
text_insufficient_funds:
                    dc.w     0,211
                    dc.b     '              INSUFFUCIENT FUNDS.'
                    dc.b     -1
                    even
text_insufficient_funds_2:
                    dc.w     0,232
                    dc.b     '                  INSUFFICIENT FUNDS'
                    dc.b     -1
                    even
text_main_menu:     dc.w     0,32
                    dc.b     '            INTEX MAIN MENU             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '         INTEX WEAPON SUPPLIES          ',0
                    dc.b     '          INTEX TOOL SUPPLIES           ',0
                    dc.b     '          INTEX RADAR SERVICE           ',0
                    dc.b     '           MISSION OBJECTIVE            ',0
                    dc.b     '            ENTER HOLOCODE              ',0
                    dc.b     '            GAME STATISTICS             ',0
                    dc.b     '               INFO BASE                ',0
                    dc.b     '          ABORT INTEX NETWORK'
                    dc.b     -1
                    even
text_enter_holocode:
                    dc.w     0,96
                    dc.b     '            ENTER HOLOCODE              ',0
                    dc.b     '                                        ',0
                    dc.b     '                00000                   ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' UP AND DOWN INCREASES/DECREASES DIGIT  ',0
                    dc.b     '      LEFT AND RIGHT MOVES CURSOR       ',0
                    dc.b     '        PRESS BUTTON WHEN READY         '
                    dc.b     -1
                    even
text_infos_page_1:  dc.w     0,24
                    dc.b     '      I N T E X  I N F O  B A S E       ',0
                    dc.b     '                                        ',0
                    dc.b     ' ON LINE HELP AND INFORMATION DATABASE. ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '    INTEX ARE PLEASED TO SUPPLY ALL     ',0
                    dc.b     '   STATION OFFICERS ACCESS TO CURRENT   ',0
                    dc.b     '         ARCHIVED INFORMATION           ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '  CONTAINED DATA FILES DO NOT CONFLICT  ',0
                    dc.b     '  WITH CURRENT HQ SECURITY REGULATIONS  ',0
                    dc.b     '  ALL RECORDS CONSIDERED LOW PRIORITY.  ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  FIRST PAGE...          ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_2:  dc.w     0,24
                    dc.b     ' INTEX SPACE RESEARCH STATION ISRC 4.   ',0
                    dc.b     '                                        ',0
                    dc.b     ' THIS STATION IS A BASE FOR PREPATORY   ',0
                    dc.b     ' SCIENCE AND SECURITY EXPERIMENTS.      ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' STATION MANNING LEVEL...      175      ',0
                    dc.b     ' STATION DECKS...........        9      ',0
                    dc.b     ' STATION SUB LEVELS......        2      ',0
                    dc.b     ' STATION SECURITY........     HIGH      ',0
                    dc.b     ' CURRENT STATUS..........  UNKNOWN      ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_3:  dc.w     0,24
                    dc.b     ' INTEX TRANSPORTATION HOLO CODES..      ',0
                    dc.b     '                                        ',0
                    dc.b     ' AT LEAST FIVE HOLO CODES EXIST THAT    ',0
                    dc.b     ' WILL TRANSPORT A TEAM OF TWO OFFICERS  ',0
                    dc.b     ' TO A SPECIFIC DECK OF THE STATION      ',0
                    dc.b     ' WITHIN AN INSTANT. THESE WERE PART OF  ',0
                    dc.b     ' THE HOLOGENICS PROGRAM BEING DEVELOPED ',0
                    dc.b     ' BY RESEARCHERS ON THIS SPACE STATION.  ',0
                    dc.b     ' ONCE YOU KNOW THE HOLO CODES, YOU      ',0
                    dc.b     ' CAN ENTER THEM AT THE MAIN MENU OF     ',0
                    dc.b     ' ANY INTEX TERMINAL AND THEN EXIT..     ',0
                    dc.b     ' WHEREBY YOU WILL BE QUICKLY            ',0
                    dc.b     ' TRANSPORTED TO YOUR DESTINATION.       ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_4:  dc.w     0,24
                    dc.b     ' STATION FACILITIES INVENTORY..         ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' A SECTION NOW FOLLOWS EXPLAINING SOME  ',0
                    dc.b     ' OF THE VARIOUS FACILITIES FOUND IN     ',0
                    dc.b     ' THIS MODEL OF SPACE RESEARCH STATION.  ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_5:  dc.w     0,24
                    dc.b     ' SLIDE DOOR.                            ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY....... REQUIRES PASS KEY      ',0
                    dc.b     '                 CAN BE SHOT OPEN       ',0
                    dc.b     '                                        ',0
                    dc.b     ' SLIDE DOORS LITTER THE ENTIRE STATION  ',0
                    dc.b     ' AND A LONG LINE MAY GUARD THE ENTRANCE ',0
                    dc.b     ' TO A HIGH SECURITY ZONE. ALTHOUGH THEY ',0
                    dc.b     ' CAN BE BLASTED OPEN, USING A LARGE     ',0
                    dc.b     ' AMOUNT OF AMMO, THEY ARE BEST OPENED   ',0
                    dc.b     ' USING A PASS KEY, ESPECIALLY IF YOU    ',0
                    dc.b     ' ARE IN A HURRY.                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_6:  dc.w     0,24
                    dc.b     ' FIRE DOOR.                             ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY....... ONCE SHUT, STAYS SHUT. ',0
                    dc.b     '                 SHOOT GREEN SWITCHES   ',0
                    dc.b     '                 TO CLOSE FIRE DOOR.    ',0
                    dc.b     '                                        ',0
                    dc.b     ' FIRE DOORS BLOCK STATION TRAFFIC ON    ',0
                    dc.b     ' A GIVEN DECK. FIRST DEVISED AS A       ',0
                    dc.b     ' SAFETY AID, FIRE DOORS SOON BECAME     ',0
                    dc.b     ' MORE OF A BURDEN DUE TO THEIR RATHER   ',0
                    dc.b     ' AWKWARD OPERATION. MANY TEAMS OF       ',0
                    dc.b     ' OFFICERS HAVE BECOME SEPERATED AT      ',0
                    dc.b     ' FIRE DOORS AND INTEX ADVISE CAUTION.   ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_7:  dc.w     0,24
                    dc.b     ' LASER DOOR.                            ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY....... ALLOWS PASSAGE IN ONE  ',0
                    dc.b     '                 DIRECTION ONLY.        ',0
                    dc.b     '                                        ',0
                    dc.b     ' LASER DOORS ARE LOCATED IN AREAS WHERE ',0
                    dc.b     ' SECURITY DICTATED THAT PASSAGE SHOULD  ',0
                    dc.b     ' ONLY BE ALLOWED IN CERTAIN DIRECTIONS. ',0
                    dc.b     '                                        ',0
                    dc.b     ' ATTEMPTING TO MOVE THROUGH THE DOOR    ',0
                    dc.b     ' IN THE WRONG DIRECTION RESULTS IN A    ',0
                    dc.b     ' LASER CHARGE TO YOUR SPINE. VERY NASTY ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_8:  dc.w     0,24
                    dc.b     ' AIR SHAFTS, DUCTS AND VENTS.           ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY....... VERY LOW               ',0
                    dc.b     '                                        ',0
                    dc.b     ' THE STATION IS LITTERED WITH VARIOUS   ',0
                    dc.b     ' DUCTS AND VENTS WHICH ARE USUALLY USED ',0
                    dc.b     ' FOR THE DUMPING OF STATION WASTE INTO  ',0
                    dc.b     ' DEEP SPACE. BECAUSE OF THIS, WE THINK  ',0
                    dc.b     ' THAT THERE IS NO NEED TO WARN YOU THAT ',0
                    dc.b     ' TRYING TO TRAVEL THROUGH ONE IS INDEED ',0
                    dc.b     ' ILL ADVISED..                          ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_9:  dc.w     0,24
                    dc.b     ' REFUGE IRIS.                           ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY........ VERY LOW              ',0
                    dc.b     '                                        ',0
                    dc.b     ' LIKE THE VENTS AND SHAFTS, THE REFUGE  ',0
                    dc.b     ' IRIS IS ANOTHER PORTHOLE INTO DEEP     ',0
                    dc.b     ' SPACE WHERE BYPRODUCTS AND WASTE IS    ',0
                    dc.b     ' REGULARLY FED.                         ',0
                    dc.b     '                                        ',0
                    dc.b     ' AVOID ENTERING ANY OPEN IRISES, UNLESS ',0
                    dc.b     ' OF COURSE, YOU WANT A SHORT LIFE.      ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_10: dc.w     0,24
                    dc.b     ' ACID VAT.                              ',0
                    dc.b     '                                        ',0
                    dc.b     ' SECURITY........ NOMINAL               ',0
                    dc.b     '                                        ',0
                    dc.b     ' THE SUB FLOOR ACID VATS CONTAIN HIGH   ',0
                    dc.b     ' POWER CYBERPHORIC ACID AND WILL DO     ',0
                    dc.b     ' LARGE AMOUNTS OF DAMAGE TO STANDARD    ',0
                    dc.b     ' ISSUE FEDERATION OUTFITS. AVOID.       ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_11: dc.w     0,24
                    dc.b     ' REMOTE LOCATION SCANNER.               ',0
                    dc.b     '                                        ',0
                    dc.b     ' THIS HANDY TOOL CAN BE BOUGHT VIA THE  ',0
                    dc.b     ' TOOLS OPTION AT INTEX TERMINAL AND     ',0
                    dc.b     ' SENT VIA A MATTER TRANSLOCATOR UNIT.   ',0
                    dc.b     '                                        ',0
                    dc.b     ' HIGHLY USEFUL, THIS HAND MAP GIVES AN  ',0
                    dc.b     ' OVERVIEW OF THE CURRENT STATION LEVEL  ',0
                    dc.b     ' PROVIDING IT LOCKS ONTO A NEARBY       ',0
                    dc.b     ' INTEX CONSOLE.                         ',0
                    dc.b     ' ALTHOUGH NEVER STANDARD ISSUE, IT IS   ',0
                    dc.b     ' THE NORM FOR ALL OFFICERS ON THIS BASE ',0
                    dc.b     ' TO CARRY SUCH A DEVICE.                ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_12: dc.w     0,24
                    dc.b     ' ESCAPE SHUTTLE BAY.                    ',0
                    dc.b     '                                        ',0
                    dc.b     ' LOCATION....... U N K N O W N          ',0
                    dc.b     '                                        ',0
                    dc.b     ' AN ESCAPE SHUTTLE LIES IN WAIT FOR     ',0
                    dc.b     ' UP TO TWO HIGH RANKING OFFICIALS. ITS  ',0
                    dc.b     ' LOCATION HAS BEEN KEPT A CLOSE GUARDED ',0
                    dc.b     ' SECRET AS MANY OF THE CREW HAVE TRIED  ',0
                    dc.b     ' TO ESCAPE THE STATION IN RECENT YEARS, ',0
                    dc.b     ' WHICH IS STRANGE CONSIDERING THAT THE  ',0
                    dc.b     ' PLACE IS FAR FROM A PRISON OR SPECIAL  ',0
                    dc.b     ' UNIT.                                  ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_13: dc.w     0,24
                    dc.b     ' CENTRAL CORE REACTOR.                  ',0
                    dc.b     '                                        ',0
                    dc.b     ' THE KEY TO THE BURNING POWER OF THE    ',0
                    dc.b     ' WHOLE CENTRE, THE CORE PROVIDES ALL    ',0
                    dc.b     ' THE ENERGY REQUIRED FOR THE BASE TO    ',0
                    dc.b     ' OPERATE. IT IS SURROUNDED BY HIGH      ',0
                    dc.b     ' SECURITY AND LOCATED DEEP IN THE HEART ',0
                    dc.b     ' OF THE STATION.                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' DESTRUCTION OF THE CENTRAL CORE WOULD  ',0
                    dc.b     ' RESULT IN SOMEWHAT OF A MELTDOWN, ONE  ',0
                    dc.b     ' MEAN EXPLOSION AND A RATHER LARGE BANG ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_14: dc.w     0,24
                    dc.b     ' CORE ENERGY REACTORS.                  ',0
                    dc.b     '                                        ',0
                    dc.b     ' THE POWER DECK SUPPLIES AUXILLARY      ',0
                    dc.b     ' POWER GENERATED BY FOUR SOLAR ENERGY   ',0
                    dc.b     ' REACTORS LINKED TO EXTERNAL POWER      ',0
                    dc.b     ' RADIATION EMINATING FROM THE NEARBY    ',0
                    dc.b     ' GAS GIANT GIANOR.                      ',0
                    dc.b     '                                        ',0
                    dc.b     ' THESE REACTORS PROVIDE THE BACK UP     ',0
                    dc.b     ' POWER FOR STATION SUB SYSTEMS.         ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_15: dc.w     0,24
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '           D A T A   E N D S            ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_16: dc.w     0,24
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '       I N T E X  S O F T W A R E       ',0
                    dc.b     '                                        ',0
                    dc.b     '       SYSTEM SOFTWARE RELEASE 12       ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '         SOFTWARE FOR SOFTHEADS         ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_17: dc.w     0,24
                    dc.b     '         SYSTEM SOFTWARE CREDITS        ',0
                    dc.b     '                                        ',0
                    dc.b     ' CODE........  ANDREAS TADIC            ',0
                    dc.b     '               PETER TULEBY             ',0
                    dc.b     '               STEFAN BOBERG            ',0
                    dc.b     ' VISUALS.....  RICO HOLMES              ',0
                    dc.b     ' AUDIO.......  ALLISTER BRIMBLE         ',0
                    dc.b     ' VOCALS......  LYNETTE READE            ',0
                    dc.b     ' MAPPING.....  RICO HOLMES, MARTYN BROWN',0
                    dc.b     ' STORYBOARD..  MARTYN BROWN             ',0
                    dc.b     ' PRODUCER....  MARTYN BROWN             ',0
                    dc.b     ' TESTING.....  ANDY, CRAIG, MICK, KEITH ',0
                    dc.b     '               FRAZZE, KATRINA, TEAM17  ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_18: dc.w     0,24
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '          D A T A  R E A L L Y          ',0
                    dc.b     '                                        ',0
                    dc.b     '             D O E S  E N D             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      MOVE JOYSTICK RIGHT.   ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_infos_page_19: dc.w     0,24
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '         C O M I N G   S O O N          ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '    W I N D O W S  F O R  I N T E X     ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                  32    ',0
                    dc.b     '     A L I E N  B R E E D  2   C D      ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' NEXT PAGE:      LAST PAGE...           ',0
                    dc.b     ' PREVIOUS PAGE:  MOVE JOYSTICK LEFT.    ',0
                    dc.b     ' MAIN MENU:      PRESS FIREBUTTON.      '
                    dc.b     -1
                    even
text_weapons:       dc.w     0,24
                    dc.b     '         INTEX WEAPON SUPPLIES          ',0
                    dc.b     '                                        ',0
                    dc.b     '   WEAPON SUPPLIES REQUEST:             ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     ' PURCHASE?            YOUR CREDIT LIMIT ',0
                    dc.b     '                        IS: '
text_credit_limit:  dcb.b    8,0
                    dc.b     -1
                    even
table_text_weapons: dc.l     text_weapon_1
                    dc.l     text_weapon_2
                    dc.l     text_weapon_3
                    dc.l     text_weapon_4
                    dc.l     text_weapon_5
                    dc.l     text_weapon_6
text_weapon_1:      dc.w     0,84
                    dc.b     '        BROADHURST DJ TWINFIRE 3LG      ',0
                    dc.b     '               RAPID FIRE               ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 10000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     -1
                    even
text_weapon_2:      dc.w     0,84
                    dc.b     '             DALTON ARC FLAME           ',0
                    dc.b     '                RAPID FIRE              ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 24000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     -1
                    even
text_weapon_3:      dc.w     0,84
                    dc.b     '           ROBINSON PLASMA GUN          ',0
                    dc.b     '               PUMP ACTION              ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 35000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     -1
                    even
text_weapon_4:      dc.w     0,84
                    dc.b     '           RYXX FIREBOLT MK22           ',0
                    dc.b     '              FLAMETHROWER              ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 48000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     -1
                    even
text_weapon_5:      dc.w     0,84
                    dc.b     '            STIRLING MULTIMATIC         ',0
                    dc.b     '               TRIPLE BARREL            ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 60000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     -1
                    even
text_weapon_6:      dc.w     0,84
                    dc.b     '          HIGH IMPACT ASTRO LAZER       ',0
                    dc.b     '                  LAZER                 ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                         COST: 75000 CR ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '                                        ',0
                    dc.b     '             YES                        ',0
                    dc.b     '             NO                         '
                    dc.b     -1
                    even

; -----------------------------------------------------

copperlist_blank:   dc.w     BPLCON0,$200
                    dc.w     COLOR00,0
                    dc.w     DMACON,DMAF_SPRITE
                    dc.w     $FFFF,$FFFE

copperlist_main:    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
                    dc.w     COLOR00,0
                    dc.w     BPLCON0,$5200
                    dc.w     DIWSTRT
copper_diwstrt:     dc.w     $2C81
                    dc.w     DIWSTOP
copper_diwstop:     dc.w     $2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,0,BPL2MOD,0
                    dc.w     BPLCON2,$24
                    dc.w     BPLCON1,0
sprites_dmacon:     dc.w     DMACON,DMAF_SETCLR|DMAF_SPRITE
                    dc.w     COLOR00
copper_palette:     dc.w     0
                    dc.w     COLOR01,0,COLOR02,0,COLOR03,0,COLOR04,0,COLOR05,0,COLOR06,0,COLOR07,0
                    dc.w     COLOR08,0,COLOR09,0,COLOR10,0,COLOR11,0,COLOR12,0,COLOR13,0,COLOR14,0
                    dc.w     COLOR15
copper_color_15:    dc.w     0
                    dc.w     COLOR16,$555,COLOR17,$565,COLOR18,$575,COLOR19,$585,COLOR20,$595,COLOR21,$5A5,COLOR22,$5B5,COLOR23,$5C5
                    dc.w     COLOR24,$5D5,COLOR25,$5E5,COLOR26,$5F5,COLOR27,$5F5,COLOR28,$5F5,COLOR29,$5F5,COLOR30,$FFF
                    dc.w     COLOR31
copper_caret_color:
                    dc.w     0
copper_bitplanes:   dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL5PTH,0,BPL5PTL,0
                    dc.w     $3001,$FF00
                    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0
copper_caret_sprite:
                    dc.w     SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
                    ; used in the weapon buy screen
copper_scr_weapon_block:
                    dc.w     $FFFF,$FFFE
                    dc.w     $2C01,$FF00,COLOR15,$0D0
                    dc.w     $5C01,$FF00,COLOR15,$2F2
                    dc.w     $7401,$FF00,COLOR15,$6F6
                    dc.w     $8A01,$FF00,COLOR15,$4F4
                    dc.w     $9601,$FF00,COLOR15,$1F1
                    dc.w     $9A01,$FF00,COLOR15
copper_caret_color_weapon_cost:
                    dc.w     0
                    dc.w     $FF01,$FF00,COLOR15,$2F2
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

sound_routine:      dc.l     0
schedule_sample_to_play:
                    dc.l     0
player_pos_x:       dc.l     0
player_pos_y:       dc.l     0
briefing_text:      dc.l     0
cur_map_top:        dc.l     0
current_weapon:     dc.l     0
gameport_register:  dc.l     0
key_pressed:        dc.l     0
owned_weapons:      dc.l     0
; credits
; aliens killed
; shots fired
; (not used)
; doors opened
; ammo packs
; currently used weapon
player_struct:      dc.l     0
cur_credits:        dc.l     0
buy_weapon_yes_no:  dc.l     1
menu_choice:        dc.l     0
player_health:      dc.l     2

welcome_sample_struct:
                    dc.w     1,VOICE_WELCOME_TO,3
                    dc.l     welcome_sample_struct_2
welcome_sample_struct_2:
                    dc.w     18,VOICE_INTEX_SYSTEM,3
                    dc.l     0
lbW0071C8:          dc.w     1,13,3
                    dc.l     0
lbW0071D2:          dc.w     1,13,3
                    dc.l     lbW0071DC
lbW0071DC:          dc.w     21,24,3
                    dc.l     0
lbW0071E6:          dc.w     1,13,3
                    dc.l     lbW0071F0
lbW0071F0:          dc.w     21,27,3
                    dc.l     0
lbW0071FA:          dc.w     1,13,3
                    dc.l     lbW007204
lbW007204:          dc.w     21,23,3
                    dc.l     0
lbW00720E:          dc.w     1,13,3
                    dc.l     lbW007218
lbW007218:          dc.w     21,73,3
                    dc.l     0
weapon_mask_pic:    dcb.b    (128*20),0

; -----------------------------------------------------

font_pic:           incbin   "font_16x504.lo6"
background_pic:     incbin   "bkgnd_320x256.lo4"
weapons_pic:        incbin   "weapons_264x40.lo4"

; -----------------------------------------------------

bitplanes:          dcb.b    (256*40*4),0
map_plane:          dcb.b    (256*40),0

                    end
