; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------
; LxMA are the maps.
; LxAN are the animated tiles (320x144x5).
; LxBO are the bobs (320x384x5).
; LxBM are the background tiles (16x16x5x480 (480 tiles, that is)).

                    mc68000

; Activate the mega cheat
DEBUG               equ     1

lbW05F7A8           equ     cur_map_datas+612
map_reactor_up      equ     cur_map_datas+2598
lbW060644           equ     cur_map_datas+4352
lbW06188C           equ     cur_map_datas+9032
lbW0619E8           equ     cur_map_datas+9380
lbW061AFC           equ     cur_map_datas+9656
lbW061D6C           equ     cur_map_datas+10280
lbW061FDC           equ     cur_map_datas+10904
map_reactor_left    equ     cur_map_datas+10928
lbW06224C           equ     cur_map_datas+11528
lbW062296           equ     cur_map_datas+11602
lbW062366           equ     cur_map_datas+11810
lbW062368           equ     cur_map_datas+11812
map_reactor_right   equ     cur_map_datas+11872
lbW062460           equ     cur_map_datas+12060
lbW06258C           equ     cur_map_datas+12360
lbW0627FC           equ     cur_map_datas+12984
lbW062872           equ     cur_map_datas+13102
lbW062D52           equ     cur_map_datas+14350
lbW063124           equ     cur_map_datas+15328
lbW063804           equ     cur_map_datas+17088
lbW063806           equ     cur_map_datas+17090
lbW063CCE           equ     cur_map_datas+18314
lbW063DB8           equ     cur_map_datas+18548
lbL063DC6           equ     cur_map_datas+18562
lbW064204           equ     cur_map_datas+19648
map_reactor_down    equ     cur_map_datas+20698

; exec
_LVOSuperState      equ     -150
_LVOUserState       equ     -156
_LVOAddIntServer    equ     -168
_LVORemIntServer    equ     -174
_LVOOldOpenLibrary  equ     -408
_LVOCloseLibrary    equ     -414
_LVOOpenLibrary     equ     -552
_LVOCacheClearU     equ     -636
_LVOCacheControl    equ     -648

; dos
_LVOOpen            equ     -30
_LVOClose           equ     -36
_LVORead            equ     -42

; gfx
_LVOLoadView        equ     -222
_LVOWaitTOF         equ     -270

KEY_P               equ     $19
KEY_M               equ     $37
KEY_SPACE           equ     $40
KEY_RETURN          equ     $44
KEY_ESC             equ     $45
KEY_UP              equ     $4c
KEY_DOWN            equ     $4d
KEY_RIGHT           equ     $4e
KEY_LEFT            equ     $4f
KEY_LEFT_ALT        equ     $64
KEY_RIGHT_ALT       equ     $65

PLAYER_CUR_WEAPON   equ     $100
PLAYER_POS_X        equ     $12c
PLAYER_POS_Y        equ     $12e
PLAYER_ALIVE        equ     $13c
PLAYER_CUR_SPRITE   equ     $140
PLAYER_HEALTH       equ     $150
PLAYER_LIVES        equ     $154
PLAYER_AMMOPACKS    equ     $158
PLAYER_AMMUNITIONS  equ     $15C
PLAYER_KEYS         equ     $160
PLAYER_CREDITS      equ     $164
PLAYER_EXTRA_SPD_X  equ     $178
PLAYER_EXTRA_SPD_Y  equ     $17a
PLAYER_OWNEDWEAPONS equ     $192
PLAYER_OLD_POS_X    equ     $1ac
PLAYER_OLD_POS_Y    equ     $1b0
PLAYER_SHOTS        equ     $1b4
PLAYER_SCORE        equ     $1b8

WEAPON_MACHINEGUN   equ     1
WEAPON_TWINFIRE     equ     2
WEAPON_FLAMEARC     equ     3
WEAPON_PLASMAGUN    equ     4
WEAPON_FLAMETHROWER equ     5
WEAPON_SIDEWINDERS  equ     6
WEAPON_LAZER        equ     7
WEAPON_MAX          equ     8

SUPPLY_MAP_OVERVIEW equ     1
SUPPLY_AMMO_CHARGE  equ     2
SUPPLY_NRG_INJECT   equ     4
SUPPLY_KEY_PACK     equ     8
SUPPLY_EXTRA_LIFE   equ     16

SAMPLE_KEY          equ     22
SAMPLE_AMMO         equ     24
SAMPLE_1UP          equ     27
SAMPLE_1STAID_CREDS equ     30
SAMPLE_ACID_POOL    equ     34

ALIEN_SPEED         equ     $0a
ALIEN_POS_X         equ     $1e
ALIEN_POS_Y         equ     $20
ALIEN_STRENGTH      equ     $3c

WAIT_BLIT           MACRO
wait\@:             btst     #14,$dff002
                    bne.s    wait\@
                    ENDM
WAIT_BLIT2          MACRO
wait\@:             btst     #14,2(a6)
                    bne.s    wait\@
                    ENDM

                    section  start,code

start:              bra      begin

user_input:         movem.l  d1-d6,-(sp)
                    tst.w    d0
                    bne.s    .port2
                    moveq    #6,d3
                    moveq    #10,d4
                    move.w   #$F600,d5
                    bra.s    .port1
.port2:             moveq    #7,d3
                    moveq    #14,d4
                    move.w   #$6F00,d5
.port1:             moveq    #0,d0
                    moveq    #0,d6
                    btst     d3,$bfe001
                    bne.s    .fire1
                    bset     #6,d6
.fire1:             btst     d4,$dff016
                    bne.s    .fire2
                    bset     #7,d6
.fire2:             bset     d3,$bfe201
                    bclr     d3,$bfe001
                    move.w   d5,$dff034
                    moveq    #7,d1
                    bra.s    .in
.loop:              tst.b    $bfe001
                    tst.b    $bfe001
                    tst.b    $bfe001
.in:                tst.b    $bfe001
                    tst.b    $bfe001
                    tst.b    $bfe001
                    tst.b    $bfe001
                    tst.b    $bfe001
                    move.w   $dff016,d2
                    bset     d3,$bfe001
                    bclr     d3,$bfe001
                    btst     d4,d2
                    bne.s    .next
                    bset     d1,d0
.next:              dbra     d1,.loop
                    bclr     d3,$bfe201
                    move.w   #-1,$dff034
                    cmp.b    #$FF,d0
                    bne.s    .none
                    moveq    #0,d0
.none:              and.w    #$FF3F,d0
                    or.w     d6,d0
                    movem.l  (sp)+,d1-d6
                    rts

player_2_input:     dc.b     0
player_1_input:     dc.b     0
player_2_old_input: dc.b     0
player_1_old_input: dc.b     0
lbW0001E2:          dc.w     5

some_variable:      dc.w     0

wait:               tst.w    some_variable
                    beq.s    wait
                    rts

error_flash:        move.w   d0,$dff180
                    bra.s    error_flash

disable_cache:      movem.l  d0/d1/a0/a1/a6,-(sp)
                    move.l   4.w,a6
                    move.w   296(a6),d0
                    btst     #3,d0
                    beq.s    .proc_68020
                    move.l   #0,d0
                    move.l   #$100,d1
                    jsr      _LVOCacheControl(a6)
.proc_68020:        movem.l  (sp)+,d0/d1/a0/a1/a6
                    rts

obtain_vbr_register:
                    bsr      get_vbr
                    move.l   d0,reg_vbr
                    rts

get_vbr:            move.l   4.w,a6
                    moveq    #0,d0
                    move.w   296(a6),d0
                    beq.s    .proc_with_vbr
                    jsr      _LVOSuperState(a6)
                    dc.w     $4E7A
                    dc.w     $1801
                    jsr      _LVOUserState(a6)
                    move.l   d1,d0
.proc_with_vbr:     rts

reg_vbr:            dc.l     0

load_graphics_lib:  lea      graphicsname(pc),a1
                    lea      GFXBase(pc),a2
                    bsr      open_library
                    move.l   GFXBase(pc),a6
                    sub.l    a1,a1
                    jsr      _LVOLoadView(a6)
                    sub.l    a1,a1
                    jsr      _LVOLoadView(a6)
                    jsr      _LVOWaitTOF(a6)
                    jsr      _LVOWaitTOF(a6)
                    jsr      _LVOWaitTOF(a6)
                    jsr      _LVOWaitTOF(a6)
                    rts

GFXBase:            dc.l     0
graphicsname:       dc.b     'graphics.library',0
                    even

open_library:       moveq    #0,d0
                    move.l   4.w,a6
                    jsr      _LVOOpenLibrary(a6)
                    move.l   d0,(a2)
                    beq.s    err_open_library
                    rts

err_open_library:   move.l   #$f,$dff180
                    bra.s    err_open_library

install_sound_interrupt:
                    move.l   4.w,a6
                    lea      lev5_interrupt,a1
                    moveq    #5,d0
                    jsr      _LVOAddIntServer(a6)
                    rts

lev5_interrupt:     dcb.l    2,0
                    dc.w     708
                    dc.l     interruptname
                    dcb.w    2,0
                    dc.l     lev5irq
interruptname:      dc.b     'VBInterrupt',0
                    even

lev5irq:            movem.l  d0-d7/a0-a6,-(sp)
                    jsr      lbC024142
                    jsr      bpmusic
                    jsr      lbC022C34
                    movem.l  (sp)+,d0-d7/a0-a6
                    moveq    #0,d0
                    rts

lbW0003A2:          dc.w     1
music_enabled:      dc.w     0
lbW0004B2:          dc.w     0
lbW0004B4:          dc.w     0
frame_flipflop:     dc.w     0
old_intreq:         dc.w     0
lbW0004BA:          dc.w     0
lbW0004BC:          dc.w     0
old_lev3irq:        dc.l     0
lbW0004C2:          dc.w     0
lbW0004C4:          dc.w     0
run_intex_ptr:      dc.l     0
lbW0004D0:          dc.w     0
player_using_intex: dc.l     0
lbW0004D6:          dc.w     8
lbW0004D8:          dc.w     0,1,0
audio_dmacon:       dc.w     0
lbW0004E0:          dc.w     0
lbW0004E2:          dc.w     0
lbW0004E4:          dc.w     0
lbW0004E6:          dc.w     0
map_overview_on:    dc.w     0
lbW0004EA:          dc.w     0
select_speed_boss:  dc.w     0
lbW0004EE:          dc.w     0
share_credits:      dc.w     0
input_enabled:      dc.w     0
done_holocode_jump: dc.w     0

; structure passed to the intex exe
cur_credits:        dc.l     0
aliens_killed:      dc.l     0
intex_shots_fired:  dc.l     0
                    dc.l     0              ; unused
doors_opened:       dc.l     0

intex_ammopacks:    dc.l     0
intex_health:       dc.l     0
intex_cur_weapon:   dc.l     0
lbL000518:          dc.l     10000

lbL00051C:          dc.l     0
lbL000520:          dcb.l    10,0
cur_map_top_ptr:    dc.l     cur_map_top

cur_palette_ptr:    dc.l     0
lbL000554:          dc.l     lbW01945E
lbL000558:          dc.l     lbW01C52A
cur_briefing_text:  dc.l     text_briefing_level_2
number_players:     dc.l     1
lbL000572:          dc.l     -1
flag_end_level:     dcb.w    2,0
lbW00057A:          dcb.w    2,0
flag_jump_to_gameover:
                    dc.l     0
flag_destruct_level:
                    dc.l     0
lbL000586:          dc.l     0
elapsed_seconds:    dc.l     0
frames_counter:     dcb.w    2,0
infinite_keys:      dc.w     0
pass_thru_walls:    dc.w     DEBUG
lbW0005AA:          dc.w     0
rnd_number:         dc.w     0
global_aliens_extra_strength:
                    dc.w     0

begin:              bsr      obtain_vbr_register
                    bsr      disable_cache
                    bsr      load_graphics_lib
                    bsr      install_sound_interrupt
                    jsr      disable_interrupts
                    jsr      set_blank_copper
                    jsr      install_lev4irq
                    jsr      kill_system
                    jsr      init_main_copperlist
                    jsr      init_tables
                    jsr      set_main_copperlist
                    jsr      convert_input_table_to_keycodes
                    move.w   #1,input_enabled
loop_wongame:       jsr      start_main_tune
loop_from_gameover: jsr      run_menu
                    clr.w    done_holocode_jump

                    ; level 1
                    clr.l    cur_level
                    jsr      lbC0026A4
                    clr.w    global_aliens_extra_strength
                    jsr      set_players_startup_weapons
                    jsr      reset_game_variables

                    move.w   #0,global_aliens_extra_strength
                    jsr      display_briefing_1
                    jsr      init_level_1
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; level 2
level_2:            move.l   #level_2,cur_level
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #0,global_aliens_extra_strength
                    jsr      display_briefing_2
                    jsr      init_level_2
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; level 3
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #0,global_aliens_extra_strength
                    jsr      display_briefing_3
                    jsr      init_level_3
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    clr.w    lbW002AC0
                    clr.l    lbL00E756
                    move.w   #0,lbW002AC2
                    jsr      jump_to_level

                    ; level 4
level_4:            move.l   #level_4,cur_level
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #0,global_aliens_extra_strength
                    jsr      display_briefing_4
                    jsr      init_level_4
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; level 5
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #0,global_aliens_extra_strength
                    jsr      display_briefing_5
                    jsr      init_level_5
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; level 6
level_6:            move.l   #level_6,cur_level
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #0,global_aliens_extra_strength
                    jsr      display_briefing_6
                    jsr      init_level_6
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; level 7
level_7:            jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #0,global_aliens_extra_strength
                    jsr      display_briefing_7
                    jsr      init_level_7
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    clr.w    boss_nbr
                    jsr      jump_to_level

                    ; level 8
level_8:            move.l   #level_8,cur_level
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #0,global_aliens_extra_strength
                    jsr      display_briefing_8
                    jsr      init_level_8
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    clr.w    boss_nbr
                    jsr      jump_to_level

                    ; level 9
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #5,global_aliens_extra_strength
                    jsr      display_briefing_9
                    jsr      init_level_9
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; level 10
level_10:           move.l   #level_10,cur_level
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #10,global_aliens_extra_strength
                    jsr      display_briefing_10
                    jsr      init_level_10
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; level 11
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #15,global_aliens_extra_strength
                    jsr      display_briefing_11
                    jsr      init_level_11
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; level 12
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    move.w   #20,global_aliens_extra_strength
                    jsr      display_briefing_12
                    jsr      init_level_12
                    jsr      hold_briefing_screen
                    jsr      lbC01208A
                    jsr      set_destruction_timer
                    jsr      lbC0100C0
                    jsr      init_level_variables
                    jsr      lbC006B94
                    jsr      lbC00A61C
                    jsr      lbC003878
                    jsr      game_level_loop
                    jsr      jump_to_level

                    ; won the game
                    jsr      lbC00DC62
                    jsr      lbC00EEDC
                    jsr      lbC00F58E
                    jsr      lbC00F51C
                    jsr      run_end
                    jmp      loop_wongame

void:               rts

run_end:            jsr      stop_sound
                    jsr      lbC023210
                    jsr      lbC023D72
                    jsr      wait_raster
                    jsr      wait_raster
                    move.l   #copper_blank,$dff080
                    jsr      start_main_tune
                    lea      exe_end,a0
                    lea      temp_buffer,a1
                    jsr      load_exe
                    jsr      temp_buffer
                    move.l   #copper_blank,$dff080
                    rts

game_level_loop:    jsr      destruction_sequence
                    move.w   #1,lbW0004C2
                    clr.w    lbW0004BA
lbC000E0E:          tst.w    lbW0004BA
                    beq.s    lbC000E0E
                    jsr      lbC003EFC
                    jsr      lbC00ACE4
                    jsr      lbC00A6C2
                    jsr      lbC0097D4
                    jsr      lbC0097F6
                    cmp.b    #7,timer_digit_lo
                    bne.s    lbC000E56
                    subq.w   #1,lbW002E04
                    bne.s    lbC000E56
                    move.w   #1,lbW0004D8
                    move.w   #1,self_destruct_initiated
lbC000E56:          tst.w    lbW002AC2
                    beq.s    lbC000E8C
                    cmp.w    #3,lbW002AC0
                    bmi.s    lbC000E8C
                    move.w   #1,lbW0004D8
                    move.w   #1,self_destruct_initiated
                    move.w   #0,lbW002AC2
                    clr.l    lbL00E756
                    clr.w    lbW002AC0
lbC000E8C:          jsr      lbC00AB0C
                    jsr      lbC00AA44
                    jsr      lbC00E8F0
                    jsr      lbC011860
                    jsr      lbC002FC0
                    jsr      check_players_invincibility
                    jsr      lbC00D17E
                    jsr      print_more_6_keys_sign
                    jsr      lbC006C7A
                    move.w   #1,lbW0004B2
                    tst.w    flag_jump_to_gameover+2
                    bne      trigger_game_over

                    tst.w    flag_end_level
                    bne      lbC0010B2
                    tst.w    map_overview_on
                    beq.s    lbC000F12
                    btst     #7,player_2_input
                    bne.s    lbC000F0C
                    btst     #7,player_1_input
                    bne.s    lbC000F0C
                    cmp.b    #KEY_M,key_pressed
                    bne      lbC000F12
lbC000F0C:          jmp      display_map_overview

lbC000F12:          cmp.b    #KEY_P,key_pressed
                    beq.s    key_pause
                    btst     #4,player_2_input
                    bne.s    lbC000F30
                    btst     #4,player_1_input
                    beq.s    lbC000F3E
lbC000F30:          subq.w   #1,lbW0001E2
                    bne.s    lbC000F46

key_pause:          jmp      display_pause

lbC000F3E:          move.w   #10,lbW0001E2
lbC000F46:          
                    tst.w    music_enabled
                    beq.s    lbC000F7A
                    btst     #7,$bfe001
                    beq      trigger_game_over
                    btst     #6,$bfe001
                    beq      trigger_game_over
lbC000F7A:          cmp.b    #KEY_ESC,key_pressed
                    beq      trigger_game_over
                    cmp.b    #KEY_LEFT_ALT,key_pressed
                    beq      player_1_next_weapon
                    move.b   player_1_old_input,d0
                    move.b   player_1_input,player_1_old_input
                    btst     #5,d0
                    bne.s    lbC001036
                    btst     #5,player_1_input
                    bne      player_1_next_weapon
lbC001036:          cmp.b    #KEY_RIGHT_ALT,key_pressed
                    beq      player_2_next_weapon
                    move.b   player_2_old_input,d0
                    move.b   player_2_input,player_2_old_input
                    btst     #5,d0
                    bne.s    lbC001064
                    btst     #5,player_2_input
                    bne      player_2_next_weapon

lbC001064:          bra      game_level_loop

trigger_game_over:  move.l   #1,flag_jump_to_gameover
                    clr.w    lbW0004C2
                    rts

lbC0010B2:          clr.w    lbW0004C2
                    rts

set_player_cur_weapon:
                    clr.l    d1
                    move.l   PLAYER_CUR_WEAPON(a0),d0
lbC001162:          cmp.w    #WEAPON_MAX,d0
                    bpl.s    lbC00117E
                    addq.w   #1,d0
                    move.w   PLAYER_OWNEDWEAPONS(a0),d1
                    btst     d0,d1
                    bne      void
                    add.l    #14,(a1)
                    bra      lbC001162
lbC00117E:          clr.l    (a1)
                    rts

set_players_startup_weapons:
                    lea      weapons_attr_table(pc),a1
                    lea      player_1_dats,a0
                    bsr      lbC00126A
                    lea      weapons_attr_table(pc),a1
                    lea      player_2_dats,a0
                    bsr      lbC00126A
                    move.l   #14,player_1_tbl_weapon_pos
                    move.l   #14,player_2_tbl_weapon_pos
                    rts

player_1_next_weapon:
                    lea      player_1_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bmi      game_level_loop
                    lea      player_1_tbl_weapon_pos,a1
                    bsr      set_player_cur_weapon
                    lea      weapons_attr_table(pc),a1
                    add.l    player_1_tbl_weapon_pos,a1
                    add.l    #14,player_1_tbl_weapon_pos
                    tst.w    (a1)
                    bpl.s    lbC00123C
                    lea      weapons_attr_table,a1
                    move.l   #14,player_1_tbl_weapon_pos
                    bra.s    lbC00123C

player_2_next_weapon:
                    lea      player_2_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bmi      game_level_loop
                    lea      player_2_tbl_weapon_pos,a1
                    bsr      set_player_cur_weapon
                    lea      weapons_attr_table,a1
                    add.l    player_2_tbl_weapon_pos,a1
                    add.l    #14,player_2_tbl_weapon_pos
                    tst.w    (a1)
                    bpl.s    lbC00123C
                    lea      weapons_attr_table,a1
                    move.l   #14,player_2_tbl_weapon_pos
                    ;bra      lbC00123C

lbC00123C:          move.w   0(a1),$102(a0)
                    move.w   2(a1),$FE(a0)
                    move.w   4(a1),$106(a0)
                    move.w   6(a1),$10A(a0)
                    move.w   8(a1),$10E(a0)
                    move.w   10(a1),$180(a0)
                    move.w   12(a1),$18E(a0)
                    bra      game_level_loop

lbC00126A:          move.w   0(a1),$102(a0)
                    move.w   2(a1),$FE(a0)
                    move.w   4(a1),$106(a0)
                    move.w   6(a1),$10A(a0)
                    move.w   8(a1),$10E(a0)
                    move.w   10(a1),$180(a0)
                    move.w   12(a1),$18E(a0)
                    rts

player_1_select_weapon:
                    lea      player_1_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bmi      void
                    lea      player_1_tbl_weapon_pos,a1
                    bsr      set_player_cur_weapon
                    lea      weapons_attr_table(pc),a1
                    add.l    player_1_tbl_weapon_pos,a1
                    add.l    #14,player_1_tbl_weapon_pos
                    tst.w    (a1)
                    bpl.s    lbC00126A
                    lea      weapons_attr_table,a1
                    move.l   #14,player_1_tbl_weapon_pos
                    bra.s    lbC00126A

player_2_select_weapon:
                    lea      player_2_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bmi      void
                    lea      player_2_tbl_weapon_pos,a1
                    bsr      set_player_cur_weapon
                    lea      weapons_attr_table,a1
                    add.l    player_2_tbl_weapon_pos,a1
                    add.l    #14,player_2_tbl_weapon_pos
                    tst.w    (a1)
                    bpl      lbC00126A
                    lea      weapons_attr_table,a1
                    move.l   #14,player_2_tbl_weapon_pos
                    bra      lbC00126A

player_1_tbl_weapon_pos:
                    dc.l    14
player_2_tbl_weapon_pos:
                    dc.l    14

; 7 entries for 7 weapons

; looks like some offset to another weapons behaviour table
; speed of the projectile
; repetition frequency
; amount of damage
; ????
; ????
; ????
weapons_attr_table: dc.w    01,16,03,09,00,37,04
                    dc.w    02,16,08,13,00,04,03
                    dc.w    03,12,09,19,00,02,02
                    dc.w    04,14,08,12,01,00,01
                    dc.w    05,08,03,12,01,06,01
                    dc.w    06,16,08,32,00,04,01
                    dc.w    07,08,08,18,01,03,01
                    dc.w    -1
                    dc.w    -1

reset_game_variables:
                    clr.w    reactor_up_done
                    clr.w    reactor_left_done
                    clr.w    reactor_down_done
                    clr.w    reactor_right_done
                    move.w   #0,exit_unlocked
                    clr.w    boss_nbr
                    lea      lbL00D29A,a0
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    lea      lbL00D2AA,a0
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.w    lbW002AC0
                    move.w   #0,lbW002AC2
                    clr.l    lbL00E756
                    clr.l    cur_credits
                    clr.l    aliens_killed
                    clr.l    intex_shots_fired
                    clr.l    doors_opened
                    clr.l    intex_ammopacks
                    clr.l    intex_health
                    clr.l    intex_cur_weapon
                    rts

print_more_6_keys_sign:
                    lea      player_1_dats,a0
                    lea      top_owned_keys_gfx,a1
                    cmp.w    #6,PLAYER_KEYS(a0)
                    bhi.s    .more_player_1
                    move.b   #0,38(a1)
                    move.b   #0,76(a1)
                    move.b   #0,114(a1)
                    move.b   #0,152(a1)
                    move.b   #0,190(a1)
                    bra.s    .player_2

.more_player_1:     move.b   #%00100000,38(a1)
                    move.b   #%00100000,76(a1)
                    move.b   #%11111000,114(a1)
                    move.b   #%00100000,152(a1)
                    move.b   #%00100000,190(a1)

.player_2:          lea      player_2_dats,a0
                    lea      bottom_owned_keys_gfx,a1
                    cmp.w    #6,PLAYER_KEYS(a0)
                    bhi.s    .more_player_2
                    move.b   #0,38(a1)
                    move.b   #0,76(a1)
                    move.b   #0,114(a1)
                    move.b   #0,152(a1)
                    move.b   #0,190(a1)
                    bra.s    .done

.more_player_2:     move.b   #%00100000,38(a1)
                    move.b   #%00100000,76(a1)
                    move.b   #%11111000,114(a1)
                    move.b   #%00100000,152(a1)
                    move.b   #%00100000,190(a1)
.done:              rts

lev3irq:            movem.l  d0-d7/a0-a6,-(sp)
                    btst     #4,$dff01f
                    bne      copper_int
                    btst     #5,$dff01f
                    beq      vblank_int
                    st       lbB022C32
                    not.w    frame_flipflop
                    beq.s    lbC0014E8
                    move.w   #-1,lbW0004B4
lbC0014E8:          moveq    #1,d0
                    jsr      user_input
                    move.b   d0,player_1_input
                    moveq    #0,d0
                    jsr      user_input
                    move.b   d0,player_2_input
                    tst.w    lbW0004D0
                    bne      lbC001518
                    cmp.w    #1,lbW0004BC
                    bne.s    lbC00152C
lbC001518:          jsr      keyboard_handler
                    jsr      lbC00B6D4

lbC00152C:          tst.w    lbW0004C2
                    beq      lbC001596
                    lea      player_1_dats,a0
                    jsr      lbC007B4C
                    lea      player_2_dats,a0
                    jsr      lbC007B4C
                    lea      player_1_dats,a0
                    jsr      lbC006E96
                    lea      player_2_dats,a0
                    jsr      lbC006E96
                    jsr      lbC007A12
                    clr.w    lbW003644
                    jsr      lbC003646
                    jsr      lbC0039B8
                    lea      lbW01227C,a0
                    jsr      lbC0111FA
                    lea      lbW0122B8,a0
                    jsr      lbC0111FA
lbC001596:          addq.w   #1,frames_counter
                    cmp.w    #50,frames_counter
                    bne.s    count_elapsed_seconds
                    clr.w    frames_counter
                    addq.l   #1,elapsed_seconds
count_elapsed_seconds:
                    jsr      palette_fade
                    jsr      lbC01097E
                    jsr      lbC010BAC
                    jsr      lbC024142
                    jsr      bpmusic
                   
                    jsr      lbC022C34
                    tst.w    lbW023E9C
                    beq.s    lbC0015F2
                    subq.w   #1,lbW023E9C
lbC0015F2:          tst.w    lbW0003A2
                    bne.s    lbC00160A
                    tst.w    frame_flipflop
                    beq.b    lbC00160A
                    jsr      lbC00EE2E
lbC00160A:          addq.w   #1,lbW0004BC
                    cmp.w    #2,lbW0004BC
                    bmi.s    lbC001640
                    clr.w    lbW0004BC
                    move.w   #1,lbW0004BA
                    tst.w    music_enabled
                    bne.s    lbC00163E
                    jsr      lbC023D20
lbC00163E:          bra.s    lbC001650

lbC001640:          move.w   #256,d0
                    jsr      rand
                    move.w   d0,rnd_number
lbC001650:          move.w   #$20,$dff09c
vblank_int:         movem.l  (sp)+,d0-d7/a0-a6
                    rte

copper_int:         bsr      lbC00167C
                    jsr      scroll_map
                    jsr      lbC005990
                    move.w   #$10,$dff09c
                    movem.l  (sp)+,d0-d7/a0-a6
                    rte

lbC00167C:          tst.w    frame_flipflop
                    beq      void
                    move.w   #1,frame_bkgnd_flag
                    tst.w    lbW0113B8
                    bpl      void
                    move.w   #2,frame_bkgnd_flag
                    rts

init_tables:        bsr      lbC0016C8
                    bsr      lbC0021DA
                    bsr      lbC00239E
                    bsr      lbC0025B0
                    rts

lbC0016C8:          lea      bkgnd_tiles_block_table,a0
                    move.l   #700,d1
                    move.l   #bkgnd_tiles_block,d0
.loop:              move.l   d0,(a0)+
                    add.l    #160,d0
                    subq.w   #1,d1
                    bne      .loop
                    rts

bkgnd_tiles_block_table:
                    dcb.l    700,0

lbC0021DA:          lea      map_lines_table,a0
                    move.l   #cur_map_top,d0
                    sub.l    #248,d0
.loop:              tst.l    (a0)
                    bmi      void
                    move.l   d0,(a0)+
                    add.l    #248,d0
                    bra      .loop

map_lines_table:    dcb.l    103,0
                    dc.l     -1

lbC00239E:          lea      lbL0023D4,a0
                    move.l   #temp_buffer,d0
.loop:              tst.l    (a0)
                    bmi      void
                    move.l   d0,(a0)+
                    add.l    #672,d0
                    move.l   #temp_buffer,d1
                    add.l    #12096,d1
                    cmp.l    d1,d0
                    bne.s    .loop
                    move.l   #temp_buffer,d0
                    bra.s    .loop

                    dc.l     lbL0E5AE0

lbL0023D4:          dcb.l    102,0
                    dc.l     -1
lbL002570:          dc.l     0,42,84,126,168,210,252,294,336,378,420
                    dc.l     462,504,546,588,630

lbC0025B0:          lea      lbL0025D2,a0
                    clr.l    d0
.loop:              tst.w    (a0)
                    bmi      void
                    move.w   d0,(a0)+
                    add.w    #16,d0
                    cmp.w    #288,d0
                    bne.s    .loop
                    clr.w    d0
                    bra.s    .loop

                    btst     d0,d0
                    btst     d0,(a0)
lbL0025D2:          dcb.w    103,0
                    dc.w     -1

lbC0026A4:          clr.l    flag_jump_to_gameover
                    clr.l    lbL000586
                    clr.l    flag_destruct_level
                    clr.l    elapsed_seconds
                    lea      lbW09A250,a0
                    bsr      lbC005A9A
                    lea      lbW09A2C4,a0
                    bsr      lbC005A9A
                    bsr      lbC0026D6
                    rts

lbC0026D6:          move.l   #lbL00E9C2,lbL005D40
                    move.l   #lbL00E9C2,lbL005D44
                    move.l   #lbL00E9D2,lbL0064E0
                    move.l   #lbL00E9D2,lbL0064E4
                    jsr      lbC00FA4C
                    lea      player_1_dats,a0
                    jsr      init_player_dats
                    lea      player_2_dats,a0
                    jsr      init_player_dats
                    cmp.w    #2,number_players+2
                    beq      void
                    move.w   #-1,PLAYER_ALIVE(a0)           ; kill the 2nd player in single player game
                    rts

init_player_dats:   clr.l    PLAYER_SHOTS(a0)
                    ifne DEBUG
                    move.w   #$ff,PLAYER_OWNEDWEAPONS(a0)
                    else
                    move.w   #%10,PLAYER_OWNEDWEAPONS(a0)
                    endif
                    move.w   #4,$18E(a0)
                    clr.w    $18A(a0)
                    move.w   #37,$180(a0)
                    move.l   #16,$FC(a0)
                    move.l   #3,$104(a0)
                    move.l   #WEAPON_MACHINEGUN,PLAYER_CUR_WEAPON(a0)
                    move.w   #1,PLAYER_ALIVE(a0)
                    move.w   #3,PLAYER_CUR_SPRITE(a0)
                    move.w   #64,PLAYER_HEALTH(a0)
                    move.w   #4,PLAYER_LIVES(a0)
                    move.w   #2,PLAYER_AMMOPACKS(a0)
                    move.w   #32,PLAYER_AMMUNITIONS(a0)
                    move.w   #0,PLAYER_KEYS(a0)
                    clr.w    $170(a0)
                    clr.w    $116(a0)
                    clr.w    $124(a0)
                    clr.w    $11C(a0)
                    clr.w    $118(a0)
                    clr.w    $174(a0)
                    clr.w    $1A4(a0)
                    clr.w    $1A8(a0)
                    move.w   PLAYER_POS_X(a0),PLAYER_OLD_POS_X(a0)
                    move.w   PLAYER_POS_Y(a0),PLAYER_OLD_POS_Y(a0)
                    rts

init_level_1:       move.w   #1,exit_unlocked
                    clr.w    select_speed_boss
                    move.w   #20,lbW0005AA
                    move.l   #-256,lbL000572
                    move.b   #6,timer_digit_hi
                    move.b   #0,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW018D4A,lbL000554
                    move.l   #lbW01BECA,lbL000558
                    jsr      lbC00EE8A
                    jsr      load_level_1
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_2:       move.w   #0,exit_unlocked
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #0,lbL000572
                    move.b   #6,timer_digit_hi
                    move.b   #0,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW01945E,lbL000554
                    move.l   #lbW01C52A,lbL000558
                    jsr      lbC00EE8A
                    jsr      load_level_2
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_3:       clr.w    lbW002AC0
                    move.w   #1,lbW002AC2
                    clr.l    lbL00E756
                    clr.w    lbW0004EE
                    move.w   #0,exit_unlocked
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #512,lbL000572
                    move.b   #4,timer_digit_hi
                    move.b   #0,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW01A1A2,lbL000554
                    move.l   #lbW01D21A,lbL000558
                    clr.w    lbW0004E6
                    move.l   #500,lbL01FDAA
                    jsr      lbC00EE8A
                    jsr      load_level_3
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_4:       move.w   #1,exit_unlocked
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #768,lbL000572
                    move.b   #9,timer_digit_hi
                    move.b   #0,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW019A8E,lbL000554
                    move.l   #lbW01D8BA,lbL000558
                    jsr      lbC00EE8A
                    jsr      load_level_4
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_5:       move.w   #0,exit_unlocked
                    move.w   #1,boss_nbr
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #768,lbL000572
                    move.b   #9,timer_digit_hi
                    move.b   #0,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW019A8E,lbL000554
                    move.l   #lbW01D8BA,lbL000558
                    jsr      lbC00EE8A
                    jsr      load_level_5
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_6:       move.w   #1,exit_unlocked                   ; that was silly man
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #512,lbL000572
                    move.b   #0,timer_digit_hi                  ; triggered by the evil 1up
                    move.b   #2,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW01A1A2,lbL000554
                    move.l   #lbW01D21A,lbL000558
                    jsr      lbC00EE8A
                    clr.l    lbL004BE4
                    clr.l    lbL004BE8
                    clr.l    lbL004BEC
                    clr.l    lbL004BF0
                    clr.l    lbL004BF4
                    clr.l    lbL004BF8
                    clr.l    lbL004BFC
                    clr.l    lbL004C00
                    jsr      lbC004DB4
                    jsr      load_level_6
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_7:       move.w   #0,exit_unlocked
                    move.w   #2,boss_nbr
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #256,lbL000572
                    move.b   #9,timer_digit_hi
                    move.b   #9,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW019A8E,lbL000554
                    move.l   #lbW01D21A,lbL000558
                    jsr      lbC00EE8A
                    clr.l    lbL004BE4
                    clr.l    lbL004BE8
                    clr.l    lbL004BEC
                    clr.l    lbL004BF0
                    clr.l    lbL004BF4
                    clr.l    lbL004BF8
                    clr.l    lbL004BFC
                    clr.l    lbL004C00
                    jsr      lbC004DB4
                    jsr      load_level_7
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_8:       move.w   #1,exit_unlocked
                    move.w   #2,boss_nbr                           ; not used i think
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #256,lbL000572
                    move.b   #6,timer_digit_hi
                    move.b   #0,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW019A8E,lbL000554
                    move.l   #lbW01D21A,lbL000558
                    jsr      lbC00EE8A
                    jsr      load_level_8
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_9:       move.w   #1,exit_unlocked
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #256,lbL000572
                    move.w   #300,lbW002E04
                    move.b   #7,timer_digit_hi
                    move.b   #7,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW019A8E,lbL000554
                    move.l   #lbW01CB8A,lbL000558
                    jsr      lbC00EE8A
                    jsr      load_level_9
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_10:      move.w   #0,exit_unlocked
                    move.w   #4,boss_nbr
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    clr.w    lbW0004EE
                    move.l   #0,lbL000572
                    move.b   #8,timer_digit_hi
                    move.b   #0,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW01945E,lbL000554
                    move.l   #lbW01C52A,lbL000558
                    jsr      lbC00EE8A
                    jsr      load_level_10
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_11:      move.w   #1,exit_unlocked
                    clr.w    select_speed_boss
                    move.w   #20,lbW0005AA
                    move.l   #0,lbL000572
                    move.b   #6,timer_digit_hi
                    move.b   #0,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW01945E,lbL000554
                    move.l   #lbW01C52A,lbL000558
                    jsr      lbC00EE8A
                    jsr      load_level_11
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

init_level_12:      move.w   #DEBUG,map_overview_on
                    move.w   #3,boss_nbr
                    clr.w    lbW0004EE
                    move.w   #0,exit_unlocked
                    clr.w    select_speed_boss
                    clr.w    lbW0004EA
                    move.w   #20,lbW0005AA
                    move.l   #1024,lbL000572
                    move.b   #1,timer_digit_hi
                    move.b   #4,timer_digit_lo
                    move.l   #level_palette1,cur_palette_ptr
                    move.l   #lbW01A922,lbL000554
                    move.l   #lbW01E1FA,lbL000558
                    clr.w    lbW0004E6
                    move.l   #500,lbL01FDAA
                    jsr      lbC00EE8A
                    jsr      load_level_12
                    jsr      search_starting_position
                    jsr      set_players_starting_pos
                    rts

lbW002AC0:          dc.w     0
lbW002AC2:          dc.w     0

lbW002E04:          dc.w     0

lbC002FC0:          tst.l    run_intex_ptr
                    beq      void
                    move.l   run_intex_ptr,a0
                    clr.l    run_intex_ptr
                    jmp      (a0)

timer_digit_hi:     dc.b     6
timer_digit_lo:     dc.b     0
cur_timer_digit_hi: dc.b     0
cur_timer_digit_lo: dc.b     0
self_destruct_initiated:
                    dc.w     0
lbW002FDE:          dc.w     0
lbW002FE0:          dc.w     0

set_destruction_timer:
                    clr.w    self_destruct_initiated
                    clr.w    lbW002FDE
                    move.b   timer_digit_hi,d0
                    move.b   timer_digit_lo,d1
                    move.b   d0,cur_timer_digit_hi
                    move.b   d1,cur_timer_digit_lo
                    bra      lbC00313E

destruction_sequence:
                    tst.w    self_destruct_initiated
                    beq      void
                    tst.w    lbW002FDE
                    bne      lbC0030AA
                    lea      lbW0122F0,a0
                    move.w   #6,(a0)
                    jsr      lbC0111C4
                    lea      lbW0122F0,a0
                    jsr      lbC011272
                    lea      lbW01230C,a0
                    move.w   #$17,(a0)
                    jsr      lbC0111C4
                    lea      lbW01230C,a0
                    jsr      lbC011272
                    move.l   cur_palette_ptr,a0
                    lea.l    level_palette2,a1
                    move.l   a1,cur_palette_ptr
                    lea      copper_main_palette,a2
                    move.l   #32,d0
                    move.w   #4,lbW010CDE
                    move.w   #1,lbW002FDE
                    jsr      compute_palette_fading_directions
                    move.w   #1,lbW00057A
                    move.l   #lbW02316A,lbL023200
                    clr.w    lbW023204

lbC0030AA:          addq.w   #1,lbW002FE0
                    cmp.w    #25,lbW002FE0
                    bne      void
                    clr.w    lbW002FE0
                    move.w   #14,sample_to_play
                    jsr      trigger_sample
                    cmp.b    #1,cur_timer_digit_hi
                    bne.s    lbC0030F4
                    cmp.b    #0,cur_timer_digit_lo
                    bne.s    lbC0030F4
                    move.l   #lbW0231A6,lbL023200
                    clr.w    lbW023204
lbC0030F4:          subq.b   #1,cur_timer_digit_lo
                    cmp.b    #255,cur_timer_digit_lo
                    bne.s    lbC00313E
                    subq.b   #1,cur_timer_digit_hi
                    move.b   #9,cur_timer_digit_lo
                    cmp.b    #255,cur_timer_digit_hi
                    bne.s    lbC00313E
                    clr.b    cur_timer_digit_hi
                    clr.b    cur_timer_digit_lo
                    move.l   #1,flag_jump_to_gameover
                    move.l   #1,flag_destruct_level
                    rts

lbC00313E:          lea      timer_digits_table,a0
                    clr.w    d2
                    move.b   cur_timer_digit_hi,d2
                    add.w    d2,d2
                    add.w    d2,d2
                    move.l   0(a0,d2.w),d0
                    move.b   cur_timer_digit_lo,d2
                    add.w    d2,d2
                    add.w    d2,d2
                    move.l   0(a0,d2.w),d1
                    jmp      lbC011370

timer_digits_table: dc.l     timer_digit_0
                    dc.l     timer_digit_1
                    dc.l     timer_digit_2
                    dc.l     timer_digit_3
                    dc.l     timer_digit_4
                    dc.l     timer_digit_5
                    dc.l     timer_digit_6
                    dc.l     timer_digit_7
                    dc.l     timer_digit_8
                    dc.l     timer_digit_9

sleep_frames:       movem.l  d0-d2,-(sp)
                    move.l   number_frames_to_wait,d0
                    jsr      wait_frame
                    movem.l  (sp)+,d0-d2
                    rts

number_frames_to_wait:
                    dc.l     0

wait_frame:         move.l   $dff004,d1
                    asr.l    #8,d1
                    and.l    #$1FF,d1
                    cmp.l    #300,d1
                    bne      wait_frame
.wait:              move.l   $dff004,d1
                    asr.l    #8,d1
                    and.l    #$1FF,d1
                    cmp.l    #300,d1
                    beq      .wait
                    subq.w   #1,d0
                    bne      wait_frame
                    rts

calc_time:          lea      global_time,a0
                    clr.b    (a0)
                    clr.b    1(a0)
                    clr.b    3(a0)
                    clr.b    4(a0)
                    clr.b    6(a0)
                    clr.b    7(a0)
                    move.l   elapsed_seconds,d0
                    clr.b    lbB0034F2
                    clr.b    lbB0034F3
                    clr.b    lbB0034F4
                    cmp.l    #356400,d0
                    bpl      lbC0034C8
                    move.l   d0,d1
                    divu     #3600,d1
                    and.w    #$FFFF,d1
                    tst.w    d1
                    beq      lbC003424
                    move.b   d1,lbB0034F2
                    mulu     #3600,d1
                    sub.l    d1,d0
lbC003424:          move.l   d0,d1
                    divu     #60,d1
                    and.w    #$FFFF,d1
                    tst.w    d1
                    beq      lbC003440
                    move.b   d1,lbB0034F3
                    mulu     #60,d1
                    sub.l    d1,d0
lbC003440:          move.b   d0,lbB0034F4
                    
                    lea      global_time_decimal_table,a0
                    move.l   #0,d0
                    move.l   #0,d1
                    move.l   #10,d2
lbC00345E:          move.b   d0,(a0)+
                    move.b   d1,(a0)+
                    addq.w   #1,d1
                    cmp.b    #10,d1
                    bne.s    lbC00345E
                    addq.w   #1,d0
                    clr.b    d1
                    subq.w   #1,d2
                    bne      lbC00345E
                    
                    lea      global_time,a0
                    clr.l    d0
                    move.b   lbB0034F2,d0
                    add.w    d0,d0
                    lea      global_time_decimal_table,a1
                    move.b   0(a1,d0.l),(a0)
                    move.b   1(a1,d0.l),1(a0)
                    move.b   lbB0034F3,d0
                    add.w    d0,d0
                    lea      global_time_decimal_table,a1
                    move.b   0(a1,d0.l),3(a0)
                    move.b   1(a1,d0.l),4(a0)
                    move.b   lbB0034F4,d0
                    add.w    d0,d0
                    lea      global_time_decimal_table,a1
                    move.b   0(a1,d0.l),6(a0)
                    move.b   1(a1,d0.l),7(a0)
lbC0034C8:          lea      global_time,a0
                    add.b    #'0',(a0)
                    add.b    #'0',1(a0)
                    add.b    #'0',3(a0)
                    add.b    #'0',4(a0)
                    add.b    #'0',6(a0)
                    add.b    #'0',7(a0)
                    rts

lbB0034F2:          dc.b     0
lbB0034F3:          dc.b     0
lbB0034F4:          dcb.b    2,0
global_time_decimal_table:
                    dcb.l    50,0
text_time:          dc.w     100,212
                    dc.b     'TIME '
global_time:        dc.b     0,0,58,0,0,58,0,0,$FF

map_pos_y:          dc.b     0,0
lbW0035D2:          dc.w     16
map_pos_x:          dc.b     0,0
lbW0035D6:          dc.w     0
lbL0035D8:          dc.l     0
lbL0035DC:          dc.l     0
lbL0035E0:          dc.l     0

set_players_starting_pos: 
                    move.w   start_pos_x,d0
                    move.w   start_pos_y,d1
                    move.w   #16,d2                     ; relative position of the 2nd player
                    move.w   #16,d3
                    lea      player_1_dats,a0
                    lea      player_2_dats,a1
                    move.l   16(a0),a2
                    move.l   16(a1),a3
                    move.w   d0,-4(a2)
                    move.w   d1,-2(a2)
                    move.w   d0,PLAYER_POS_X(a0)
                    move.w   d1,PLAYER_POS_Y(a0)
                    add.w    d0,d2
                    add.w    d1,d3
                    move.w   d2,-4(a3)
                    move.w   d3,-2(a3)
                    move.w   d2,PLAYER_POS_X(a1)
                    move.w   d3,PLAYER_POS_Y(a1)
                    move.w   #1,lbW003644
                    jsr      lbC003646
                    move.w   d0,lbW0035D6
                    move.w   d1,lbW0035D2
                    rts

lbW003644:          dc.w     0

lbC003646:          tst.w    lbL000586
                    bne      void
                    lea      player_1_dats,a0
                    lea      player_2_dats,a1
                    move.w   PLAYER_POS_X(a0),d0
                    move.w   PLAYER_POS_Y(a0),d1
                    move.w   PLAYER_POS_X(a1),d2
                    move.w   PLAYER_POS_Y(a1),d3
                    tst.w    PLAYER_ALIVE(a0)
                    bpl.s    lbC0036BC
                    move.w   d2,d0
                    move.w   d3,d1
                    bra.s    lbC0036F4

lbC0036BC:          tst.w    PLAYER_ALIVE(a1)
                    bpl.s    lbC0036C4
                    bra.s    lbC0036F4

lbC0036C4:          cmp.w    d0,d2
                    bpl      lbC0036D6
                    sub.w    d2,d0
                    lsr.w    #1,d0
                    add.w    d0,d2
                    move.w   d2,d0
                    bra      lbC0036DC

lbC0036D6:          sub.w    d0,d2
                    lsr.w    #1,d2
                    add.w    d2,d0
lbC0036DC:          cmp.w    d1,d3
                    bpl      lbC0036EE
                    sub.w    d3,d1
                    lsr.w    #1,d1
                    add.w    d1,d3
                    move.w   d3,d1
                    bra      lbC0036F4

lbC0036EE:          sub.w    d1,d3
                    lsr.w    #1,d3
                    add.w    d3,d1
lbC0036F4:          sub.w    #$80,d0
                    sub.w    #$78,d1
                    tst.w    lbW003644
                    bne      void
                    move.w   lbW0035D6,d2
                    sub.w    d2,d0
                    move.w   d0,d2
                    tst.w    d0
                    bpl      lbC003718
                    neg.w    d2
lbC003718:          move.w   d2,d4
                    cmp.w    #2,d4
                    bmi.s    lbC003724
                    move.w   #2,d4
lbC003724:          move.w   d4,lbW0039B4
                    tst.w    d0
                    bmi      lbC00375A
                    beq      lbC00377C
                    bset     #1,lbB0039B2
                    bclr     #2,lbB0039B2
                    cmp.w    #$660,lbW0035D6
                    bpl      lbC00377C
                    add.w    d4,lbW0035D6
                    bra      lbC00377C

lbC00375A:          bset     #2,lbB0039B2
                    bclr     #1,lbB0039B2
                    cmp.w    #16,lbW0035D6
                    bmi      lbC00377C
                    sub.w    d4,lbW0035D6
lbC00377C:          move.w   lbW0035D2,d2
                    sub.w    d2,d1
                    move.w   d1,d2
                    tst.w    d1
                    bpl      lbC00378E
                    neg.w    d2
lbC00378E:          move.w   d2,d4
                    cmp.w    #2,d4
                    bmi      lbC00379C
                    move.w   #2,d4
lbC00379C:          move.w   d4,lbW0039B4+2
                    tst.w    d1
                    bmi      lbC0037D0
                    beq      void
                    bset     #3,lbB0039B2
                    bclr     #4,lbB0039B2
                    cmp.w    #1344,lbW0035D2
                    bpl      void
                    add.w    d4,lbW0035D2
                    rts

lbC0037D0:          bset     #4,lbB0039B2
                    bclr     #3,lbB0039B2
                    cmp.w    #20,lbW0035D2
                    bmi      void
                    sub.w    d4,lbW0035D2
                    rts

copy_map_datas:     move.l   #(end_map_datas-cur_map_datas),d0
                    lea      cur_map_datas,a0
                    jsr      clear_array_long
                    lea      aliens_sprites_block,a0
                    lea      cur_map_datas,a1
                    move.l   #96,d0
.copy_column:       move.l   #120,d1
.copy_line:         move.w   (a0)+,(a1)+
                    subq.w   #1,d1
                    bne.s    .copy_line
                    addq.l   #8,a1                  ; 248 bytes / line
                    subq.w   #1,d0
                    bne.s    .copy_column
                    rts

lbC003832:          clr.w    lbW0039A4
                    clr.l    lbL0039A6
                    clr.l    lbL0039AA
                    clr.l    lbL0039AE
                    clr.w    lbB0039B2
                    clr.l    lbW0039B4
                    lea      lbW003E92,a0
                    clr.w    (a0)+
                    clr.w    (a0)+
                    clr.w    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    lea      lbW003EA0,a0
                    clr.w    (a0)+
                    clr.w    (a0)+
                    clr.w    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    rts

lbC003878:          jsr      lbC003832
                    jsr      lbC00412C
                    bsr.w    lbC003954
                    lea      player_1_dats,a0
                    jsr      lbC006E96
                    lea      player_2_dats,a0
                    jsr      lbC006E96
                    jsr      lbC007A12
                    lea      lbW01227C,a0
                    jsr      lbC0111FA
                    lea      lbW0122B8,a0
                    jsr      lbC0111FA
                    jsr      lbC005990
                    jsr      scroll_map
                    lea      lbW02276A,a0
                    move.l   cur_palette_ptr,a1
                    lea      copper_main_palette,a2
                    move.l   #32,d0
                    move.w   #2,lbW010CDE
                    jsr      compute_palette_fading_directions
                    jsr      set_bitplanes_nbr
                    jsr      lbC010F22
                    jsr      wait
                    clr.w    lbW023126
                    rts

lbC003954:          move.l   #-1,lbL0035D8
                    move.l   #18,lbL0035E0
                    move.l   #21,lbL0039A6
                    clr.l    lbL0039AA
                    lea      lbW003E92(pc),a0
                    clr.w    0(a0)
                    lea      lbW003EA0(pc),a0
                    clr.w    0(a0)
lbC003988:          bsr      display_tiles
                    bsr      lbC003EFC
                    add.l    #1,lbL0035D8
                    subq.l   #1,lbL0035E0
                    bne.s    lbC003988
                    rts

lbW0039A4:          dc.w     0
lbL0039A6:          dc.l     0
lbL0039AA:          dc.l     0
lbL0039AE:          dc.l     0
lbB0039B2:          dc.b     0
                    even
lbW0039B4:          dc.w     0
                    dc.w     0

lbC0039B8:          not.b    lbW0039A4
                    bne      lbC0039DA
                    move.b   lbB0039B2,d0
                    btst     #1,d0
                    bne      lbC003A42
                    btst     #2,d0
                    bne      lbC003A6A
                    rts

lbC0039DA:          move.b   lbB0039B2,d0
                    btst     #3,d0
                    bne      lbC003A1A
                    btst     #4,d0
                    bne      lbC0039F2
                    rts

lbC0039F2:          move.l   lbL003A96,a0
                    tst.l    (a0)
                    bpl      lbC003A0E
                    move.l   #lbL003AB6,lbL003A96
                    move.l   lbL003A96,a0
lbC003A0E:          move.l   (a0),a0
                    jsr      (a0)
                    addq.l   #4,lbL003A96
                    rts

lbC003A1A:          move.l   lbL003A92,a0
                    tst.l    (a0)
                    bpl      lbC003A36
                    move.l   #lbL003AA2,lbL003A92
                    move.l   lbL003A92,a0
lbC003A36:          move.l   (a0),a0
                    jsr      (a0)
                    addq.l   #4,lbL003A92
                    rts

lbC003A42:          move.l   lbL003A9A,a0
                    tst.l    (a0)
                    bpl      lbC003A5E
                    move.l   #lbL003ACA,lbL003A9A
                    move.l   lbL003A9A,a0
lbC003A5E:          move.l   (a0),a0
                    jsr      (a0)
                    addq.l   #4,lbL003A9A
                    rts

lbC003A6A:          move.l   lbL003A9E,a0
                    tst.l    (a0)
                    bpl      lbC003A86
                    move.l   #lbL003ADE,lbL003A9E
                    move.l   lbL003A9E,a0
lbC003A86:          move.l   (a0),a0
                    jsr      (a0)
                    addq.l   #4,lbL003A9E
                    rts

lbL003A92:          dc.l     lbL003AA2
lbL003A96:          dc.l     lbL003AB6
lbL003A9A:          dc.l     lbL003ACA
lbL003A9E:          dc.l     lbL003ADE
lbL003AA2:          dc.l     lbC003BDA
                    dc.l     lbC003C14
                    dc.l     lbC003C4E
                    dc.l     lbC003C88,-1
lbL003AB6:          dc.l     lbC003AF2
                    dc.l     lbC003B2C
                    dc.l     lbC003B66
                    dc.l     lbC003BA0,-1
lbL003ACA:          dc.l     lbC003CC2
                    dc.l     lbC003CFC
                    dc.l     lbC003D36
                    dc.l     lbC003D70,-1
lbL003ADE:          dc.l     lbC003DAA
                    dc.l     lbC003DE4
                    dc.l     lbC003E1E
                    dc.l     lbC003E58,-1

lbC003AF2:          move.l   #-1,lbL0035D8
                    move.l   #0,lbL0039AA
                    move.l   #6,lbL0039A6
                    bsr      display_tiles
                    move.l   #lbW0041D8,lbL00411C
                    move.l   #7,lbL004120
                    bra      lbC004176

lbC003B2C:          move.l   #-1,lbL0035D8
                    move.l   #5,lbL0039AA
                    move.l   #6,lbL0039A6
                    bsr      display_tiles
                    move.l   #lbW0041E4,lbL00411C
                    move.l   #7,lbL004120
                    bra      lbC004176

lbC003B66:          move.l   #-1,lbL0035D8
                    move.l   #10,lbL0039AA
                    move.l   #6,lbL0039A6
                    bsr      display_tiles
                    move.l   #lbW0041F0,lbL00411C
                    move.l   #7,lbL004120
                    bra      lbC004176

lbC003BA0:          move.l   #-1,lbL0035D8
                    move.l   #15,lbL0039AA
                    move.l   #6,lbL0039A6
                    bsr      display_tiles
                    move.l   #lbW0041FC,lbL00411C
                    move.l   #6,lbL004120
                    bra      lbC004176

lbC003BDA:          move.l   #16,lbL0035D8
                    move.l   #0,lbL0039AA
                    move.l   #6,lbL0039A6
                    bsr      display_tiles
                    move.l   #lbW00422E,lbL00411C
                    move.l   #7,lbL004120
                    bra      lbC004176

lbC003C14:          move.l   #16,lbL0035D8
                    move.l   #5,lbL0039AA
                    move.l   #6,lbL0039A6
                    bsr      display_tiles
                    move.l   #lbW00423A,lbL00411C
                    move.l   #7,lbL004120
                    bra      lbC004176

lbC003C4E:          move.l   #16,lbL0035D8
                    move.l   #10,lbL0039AA
                    move.l   #6,lbL0039A6
                    bsr      display_tiles
                    move.l   #lbW004246,lbL00411C
                    move.l   #7,lbL004120
                    bra      lbC004176

lbC003C88:          move.l   #15,lbL0039AA
                    move.l   #6,lbL0039A6
                    move.l   #$10,lbL0035D8
                    bsr      display_tiles
                    move.l   #lbW004252,lbL00411C
                    move.l   #6,lbL004120
                    bra      lbC004176

lbC003CC2:          move.l   #20,lbL0035DC
                    move.l   #0,lbL0039AE
                    move.l   #6,lbL0039A6
                    bsr      lbC005620
                    move.l   #lbW004206,lbL00411C
                    move.l   #6,lbL004120
                    bra      lbC004176

lbC003CFC:          move.l   #20,lbL0035DC
                    move.l   #5,lbL0039AE
                    move.l   #6,lbL0039A6
                    bsr      lbC005620
                    move.l   #lbW004210,lbL00411C
                    move.l   #6,lbL004120
                    bra      lbC004176

lbC003D36:          move.l   #20,lbL0035DC
                    move.l   #10,lbL0039AE
                    move.l   #6,lbL0039A6
                    bsr      lbC005620
                    move.l   #lbW00421A,lbL00411C
                    move.l   #6,lbL004120
                    bra      lbC004176

lbC003D70:          move.l   #20,lbL0035DC
                    move.l   #12,lbL0039AE
                    move.l   #6,lbL0039A6
                    bsr      lbC005620
                    move.l   #lbW004224,lbL00411C
                    move.l   #5,lbL004120
                    bra      lbC004176

lbC003DAA:          move.l   #0,lbL0035DC
                    move.l   #0,lbL0039AE
                    move.l   #6,lbL0039A6
                    bsr      lbC005620
                    move.l   #lbW00425C,lbL00411C
                    move.l   #6,lbL004120
                    bra      lbC004176

lbC003DE4:          move.l   #0,lbL0035DC
                    move.l   #5,lbL0039AE
                    move.l   #6,lbL0039A6
                    bsr      lbC005620
                    move.l   #lbW004266,lbL00411C
                    move.l   #6,lbL004120
                    bra      lbC004176

lbC003E1E:          move.l   #0,lbL0035DC
                    move.l   #10,lbL0039AE
                    move.l   #6,lbL0039A6
                    bsr      lbC005620
                    move.l   #lbW004270,lbL00411C
                    move.l   #6,lbL004120
                    bra      lbC004176

lbC003E58:          move.l   #0,lbL0035DC
                    move.l   #12,lbL0039AE
                    move.l   #6,lbL0039A6
                    bsr      lbC005620
                    move.l   #lbW00427A,lbL00411C
                    move.l   #5,lbL004120
                    bra      lbC004176

lbW003E92:          dcb.w    7,0
lbW003EA0:          dcb.w    7,0

lbC003EAE:          movem.l  a4,-(sp)
                    lea      lbW003E92(pc),a4
                    tst.w    0(a4)
                    beq.s    lbC003ED8
                    lea      lbW003EA0(pc),a4
                    bra      lbC003ED8

lbC003EC4:          movem.l  a4,-(sp)
                    lea      lbW003E92(pc),a4
                    tst.w    0(a4)
                    beq.s    lbC003EDE
                    lea      lbW003EA0(pc),a4
                    bra.s    lbC003EDE

lbC003ED8:          clr.w    2(a4)
                    bra.s    lbC003EE8

lbC003EDE:          move.w   #1,2(a4)
                    move.l   d0,6(a4)
lbC003EE8:          move.w   #1,0(a4)
                    move.w   d3,4(a4)
                    move.l   a1,10(a4)
                    movem.l  (sp)+,a4
                    rts

lbC003EFC:          lea      $dff000,a6
                    lea      lbW003E92(pc),a0
                    bsr.s    lbC003F0C
                    lea      lbW003EA0(pc),a0
lbC003F0C:          tst.w    0(a0)
                    beq      void
                    clr.w    0(a0)
                    tst.w    2(a0)
                    bne      lbC003F68
                    WAIT_BLIT2
                    move.w   4(a0),d0
                    move.w   #21,d1
                    sub.w    d0,d1
                    add.w    d1,d1
                    or.w     #$400,d0
                    move.w   d1,$64(a6)
                    move.w   d1,$66(a6)
                    move.l   #$9f00000,$40(a6)
                    move.l   #-1,$44(a6)
                    move.l   10(a0),a1
                    move.l   a1,a2
                    move.l   a1,a3
                    sub.l    #123480,a2
                    sub.l    #61740,a3
                    bra      lbC003FE6

lbC003F68:          
                    WAIT_BLIT2
                    move.w   #40,$64(a6)
                    move.w   #40,$66(a6)
                    move.l   #$9f00000,$40(a6)
                    move.l   #-1,$44(a6)
                    move.l   10(a0),a1
                    move.w   4(a0),d0
                    lsl.w    #4,d0
                    move.l   a1,d1
                    move.l   #lbL1040D4,d2
                    sub.l    d1,d2
                    divu     #42,d2
                    and.w    #$FFF0,d2
                    move.w   d2,d3
                    sub.w    d0,d2
                    bpl.s    lbC003FC4
                    move.w   d3,d0
                    bsr.s    lbC003FC4
                    neg.w    d2
                    move.w   d2,d0
                    lea      lbL101098,a1
                    add.l    6(a0),a1
                    bra      lbC003FC4

lbC003FC4:          
                    WAIT_BLIT2
                    lsl.w    #6,d0
                    or.w     #1,d0
                    move.l   a1,a2
                    move.l   a1,a3
                    sub.l    #123480,a2
                    sub.l    #61740,a3
                    bra      lbC003FE6

lbC003FE6:          move.w   #$8400,$dff096
                    move.l   a1,$50(a6)
                    move.l   a2,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    move.l   a1,$50(a6)
                    move.l   a3,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    add.l    #$303C,a1
                    add.l    #$303C,a2
                    add.l    #$303C,a3
                    move.l   a1,$50(a6)
                    move.l   a2,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    move.l   a1,$50(a6)
                    move.l   a3,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    add.l    #$303C,a1
                    add.l    #$303C,a2
                    add.l    #$303C,a3
                    move.l   a1,$50(a6)
                    move.l   a2,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    move.l   a1,$50(a6)
                    move.l   a3,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    add.l    #$303C,a1
                    add.l    #$303C,a2
                    add.l    #$303C,a3
                    move.l   a1,$50(a6)
                    move.l   a2,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    move.l   a1,$50(a6)
                    move.l   a3,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    add.l    #$303C,a1
                    add.l    #$303C,a2
                    add.l    #$303C,a3
                    move.l   a1,$50(a6)
                    move.l   a2,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    move.l   a1,$50(a6)
                    move.l   a3,$54(a6)
                    move.w   d0,$58(a6)
                    WAIT_BLIT
                    move.w   #$400,$dff096
                    rts

lbL00411C:          dc.l     0
lbL004120:          dc.l     0
lbL004124:          dc.l     0
lbB004128:          dcb.b    2,0
lbW00412A:          dc.w     0

lbC00412C:          clr.l    lbL004124
lbC004132:          move.l   map_pos_x,d0
                    move.l   map_pos_y,d1
                    add.l    lbL004124,d1
                    move.l   #lbW0041D8,lbL00411C
                    move.l   #23,lbL004120
                    bsr      lbC004182
                    add.l    #16,lbL004124
                    cmp.l    #320,lbL004124
                    bne      lbC004132
                    rts

lbC004176:          move.l   map_pos_x,d0
                    move.l   map_pos_y,d1
lbC004182:          lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    lea      map_lines_table+4,a6
                    move.l   0(a6,d1.l),a6
                    add.l    d0,a6
                    sub.l    #2,a6
                    move.l   a6,lbB004128
                    lea      lbC004384,a4
                    move.l   lbL00411C,a5
                    clr.l    d6
                    move.l   lbL004120,d7
lbC0041B8:          move.w   (a5)+,d6
                    move.l   a6,a3
                    add.w    d6,a3
                    move.w   (a3),d6
                    and.w    #$3F,d6
                    add.w    d6,d6
                    add.w    d6,d6
                    add.l    lbL000572,d6
                    jsr      0(a4,d6.w)
                    subq.w   #1,d7
                    bne.s    lbC0041B8
                    rts

lbW0041D8:          dc.w     $FD12,$FD14,$FD16,$FD18,$FD1A,$FD1C
lbW0041E4:          dc.w     $FD1E,$FD20,$FD22,$FD24,$FD26,$FD28
lbW0041F0:          dc.w     $FD2A,$FD2C,$FD2E,$FD30,$FD32,$FD34
lbW0041FC:          dc.w     $FD36,$FD38,$FD3A,$FD3C,$FD3E
lbW004206:          dc.w     $FD3E,$FE36,$FF2E,$26,$11E
lbW004210:          dc.w     $216,$30E,$406,$4FE,$5F6
lbW00421A:          dc.w     $6EE,$7E6,$8DE,$9D6,$ACE
lbW004224:          dc.w     $BC6,$CBE,$DB6,$EAE,$FA6
lbW00422E:          dc.w     $FA6,$FA4,$FA2,$FA0,$F9E,$F9C
lbW00423A:          dc.w     $F9A,$F98,$F96,$F94,$F92,$F90
lbW004246:          dc.w     $F8E,$F8C,$F8A,$F88,$F86,$F84
lbW004252:          dc.w     $F82,$F80,$F7E,$F7C,$F7A
lbW00425C:          dc.w     $F7A,$E82,$D8A,$C92,$B9A
lbW004266:          dc.w     $AA2,$9AA,$8B2,$7BA,$6C2
lbW004270:          dc.w     $5CA,$4D2,$3DA,$2E2,$1EA
lbW00427A:          dc.w     $F2,$FFFA,$FF02,$FE0A,$FD12

                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004884
                    bra.w    lbC004896
                    bra.w    lbC0048A8
                    bra.w    lbC0048BA
                    bra.w    lbC0048CC
                    bra.w    lbC0048DE
                    bra.w    lbC0048F0
                    bra.w    lbC004902
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004914
                    bra.w    lbC0049D6
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
lbC004384:          bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004928
                    bra.w    lbC00493A
                    bra.w    lbC00494E
                    bra.w    lbC004962
                    bra.w    lbC004964
                    bra.w    lbC004976
                    bra.w    lbC004988
                    bra.w    lbC00499A
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC0049C2
                    bra.w    lbC0049D6
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC0049EA
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004A38
                    bra.w    lbC004A74
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004A04
                    bra.w    lbC004A0E
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004A18
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004A86
                    bra.w    none
                    bra.w    lbC004A9C
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004E34
                    bra.w    lbC004ED6
                    bra.w    lbC004F22
                    bra.w    lbC004F6E
                    bra.w    lbC004FBA
                    bra.w    lbC004AB2
                    bra.w    lbW005006
                    bra.w    lbW00505E
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbW0050B6
                    bra.w    lbW00510E
                    bra.w    none
                    bra.w    none
                    bra.w    lbC0053A2
                    bra.w    lbC0053AC
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004E84
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC0053B6
                    bra.w    lbC0053CA
                    bra.w    lbC0053DC
                    bra.w    lbC0053F0
                    bra.w    lbC005404
                    bra.w    lbC005404
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004A04
                    bra.w    lbC004A0E
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004A18
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC005416
                    bra.w    none
                    bra.w    lbC00542E
                    bra.w    lbC005440
                    bra.w    lbC005452
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004A04
                    bra.w    lbC004A0E
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    lbC004A28
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none
                    bra.w    none

lbC004884:          bsr      lbC00AE2E
                    lea      lbW01EB12,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC004896:          bsr      lbC00AE2E
                    lea      lbW01EB2E,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0048A8:          bsr      lbC00AE2E
                    lea      lbW01EB4A,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0048BA:          bsr      lbC00AE2E
                    lea      lbW01EB66,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0048CC:          bsr      lbC00AE2E
                    lea      lbW01EB82,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0048DE:          bsr      lbC00AE2E
                    lea      lbW01EB9E,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0048F0:          bsr      lbC00AE2E
                    lea      lbL01EC12,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC004902:          bsr      lbC00AE2E
                    lea      lbL01EBBA,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC004914:          lea      lbW0091D4,a1
                    bra      lbC00A718

lbC004928:          bsr      lbC00AE2E
                    lea      lbL01EC36,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC00493A:          addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL01ECBA,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC00494E:          addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL01ECF6,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC004962:          rts

lbC004964:          bsr      lbC00AE2E
                    lea      lbL01EC8E,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC004976:          bsr      lbC00AE2E
                    lea      lbL01EC62,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC004988:          bsr      lbC00AE2E
                    lea      lbL02013E,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC00499A:          bsr      lbC00AE2E
                    lea      lbL020276,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL02021A,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0049C2:          tst.w    music_enabled
                    bne      void
                    lea      lbW008F54,a1
                    bra      lbC00A718

lbC0049D6:          tst.w    music_enabled
                    bne      void
                    lea      lbW008FD4,a1
                    bra      lbC00A718

lbC0049EA:          tst.w    music_enabled
                    bne      void
                    move.l   #lbW008F94,lbL00D226
                    jmp      lbC00D22A

lbC004A04:          lea      lbW009054,a1
                    bra      lbC00A718

lbC004A0E:          lea      lbW0090D4,a1
                    bra      lbC00A718

lbC004A18:          move.l   #lbW009094,lbL00D226
                    jmp      lbC00D22A

lbC004A28:          move.l   #lbW009414,lbL00D226
                    jmp      lbC00D22A

lbC004A38:          cmp.w    #2,boss_nbr
                    beq      lbC004A86
                    add.l    #2,a3
                    bsr      lbC00AE2E
                    lea      lbL0202D2,a1
                    bsr      lbC00AF10
                    bsr      lbC00AED8
                    add.l    #496,a3
                    bsr      lbC00AE2E
                    lea      lbL02038E,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC004A74:          bsr      lbC00AE2E
                    lea      lbL020466,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC004A86:          addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL02080E,a1
                    bsr      lbC00AF10
                    bsr      lbC00AED8
                    rts

lbC004A9C:          addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL02082A,a1
                    bsr      lbC00AF10
                    bsr      lbC00AED8
                    rts

lbC004AB2:          move.l   lbL004BE4,d0
                    beq.s    lbC004B14
                    move.l   d0,a1
                    move.l   8(a1),a1
                    cmp.l    #lbL004D50,a1
                    bne      lbC004B14
                    move.l   lbL004BE8,d0
                    beq.s    lbC004B14
                    move.l   d0,a1
                    move.l   8(a1),a1
                    cmp.l    #lbL004CE4,a1
                    bne      lbC004B14
                    move.l   lbL004BEC,d0
                    beq.s    lbC004B14
                    move.l   d0,a1
                    move.l   8(a1),a1
                    cmp.l    #lbL004C78,a1
                    bne      lbC004B14
                    move.l   lbL004BF0,d0
                    beq.s    lbC004B14
                    move.l   d0,a1
                    move.l   8(a1),a1
                    cmp.l    #lbL004C0C,a1
                    bne      lbC004B14
                    rts

lbC004B14:          bsr.s    lbC004B1A
                    bra      lbC004B8A

lbC004B1A:          move.l   lbW012388,d0
                    lea      lbW063124,a3
                    bsr      lbC00AE2E
                    move.l   a0,lbL004BE4
                    move.l   a3,lbL004BF4
                    bsr      lbC00AED8
                    add.l    #248,a3
                    bsr      lbC00AE2E
                    move.l   a0,lbL004BE8
                    move.l   a3,lbL004BF8
                    bsr      lbC00AED8
                    add.l    #248,a3
                    bsr      lbC00AE2E
                    move.l   a0,lbL004BEC
                    move.l   a3,lbL004BFC
                    bsr      lbC00AED8
                    add.l    #248,a3
                    bsr      lbC00AE2E
                    move.l   a0,lbL004BF0
                    move.l   a3,lbL004C00
                    bsr      lbC00AED8
                    rts

lbC004B8A:          move.l   lbL004BE4,a0
                    lea      lbL004D50,a1
                    move.l   lbL004BF4,a3
                    bsr      lbC00AF10
                    move.l   lbL004BE8,a0
                    lea      lbL004CE4,a1
                    move.l   lbL004BF8,a3
                    bsr      lbC00AF10
                    move.l   lbL004BEC,a0
                    lea      lbL004C78,a1
                    move.l   lbL004BFC,a3
                    bsr      lbC00AF10
                    move.l   lbL004BF0,a0
                    lea      lbL004C0C,a1
                    move.l   lbL004C00,a3
                    bsr      lbC00AF10
                    rts

lbL004BE4:          dc.l     0
lbL004BE8:          dc.l     0
lbL004BEC:          dc.l     0
lbL004BF0:          dc.l     0
lbL004BF4:          dc.l     0
lbL004BF8:          dc.l     0
lbL004BFC:          dc.l     0
lbL004C00:          dc.l     0,2,$40006
lbL004C0C:          dc.l     lbL016EBA,1
                    dc.l     lbL016EEA,1
                    dc.l     lbL016F1A,1
                    dc.l     lbL016F4A,1
                    dc.l     lbL016F7A,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016FDA,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016F7A,1
                    dc.l     lbL016F4A,1
                    dc.l     lbL016F1A,1
                    dc.l     lbL016EEA,1,-1,2,$40006
lbL004C78:          dc.l     lbL016EEA,1
                    dc.l     lbL016F1A,1
                    dc.l     lbL016F4A,1
                    dc.l     lbL016F7A,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016FDA,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016F7A,1
                    dc.l     lbL016F4A,1
                    dc.l     lbL016F1A,1
                    dc.l     lbL016EEA,1
                    dc.l     lbL016EBA,1,-1,2,$40006
lbL004CE4:          dc.l     lbL016F1A,1
                    dc.l     lbL016F4A,1
                    dc.l     lbL016F7A,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016FDA,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016F7A,1
                    dc.l     lbL016F4A,1
                    dc.l     lbL016F1A,1
                    dc.l     lbL016EEA,1
                    dc.l     lbL016EBA,1
                    dc.l     lbL016EEA,1,-1,2,$40006
lbL004D50:          dc.l     lbL016F4A,1
                    dc.l     lbL016F7A,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016FDA,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016F7A,1
                    dc.l     lbL016F4A,1
                    dc.l     lbL016F1A,1
                    dc.l     lbL016EEA,1
                    dc.l     lbL016EBA,1
                    dc.l     lbL016EEA,1
                    dc.l     lbL016F1A,1,-1

lbC004DB4:          clr.l    lbL004F1A
                    clr.l    lbL004F66
                    clr.l    lbL004FB2
                    clr.l    lbL004FFE
                    clr.l    lbL004F1E
                    clr.l    lbL004F6A
                    clr.l    lbL004FB6
                    clr.l    lbL005002
                    clr.l    lbL004E7C
                    clr.l    lbL004E80
                    clr.l    lbL004ECE
                    clr.l    lbL004ED2
                    clr.l    lbL005106
                    clr.l    lbL00510A
                    clr.l    lbL00515E
                    clr.l    lbL005162
                    clr.l    lbL005056
                    clr.l    lbL00505A
                    clr.l    lbL0050AE
                    clr.l    lbL0050B2
                    clr.l    lbL005166
                    rts

lbC004E34:          move.l   lbL004ECE,a0
                    cmp.l    #0,a0
                    bne.s    lbC004E46
                    bsr      lbC00AE2E
lbC004E46:          move.l   a0,lbL004E7C
                    move.l   a3,lbL004E80
                    and.w    #$FFC0,(a3)
                    or.w     #$18,(a3)
                    lea      lbL020846,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC004E6C:          and.w    #$FFC0,(a3)
                    lea      lbL020702,a2
                    jmp      patch_tiles

lbL004E7C:          dc.l     0
lbL004E80:          dc.l     0

lbC004E84:          rts

lbC004E86:          move.l   lbL004E7C,a0
                    cmp.l    #0,a0
                    bne.s    lbC004E98
                    bsr      lbC00AE2E
lbC004E98:          move.l   a0,lbL004ECE
                    move.l   a3,lbL004ED2
                    and.w    #$FFC0,(a3)
                    or.w     #$35,(a3)
                    lea      lbL020862,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC004EBE:          and.w    #$FFC0,(a3)
                    lea      lbL02072E,a2
                    jmp      patch_tiles

lbL004ECE:          dc.l     0
lbL004ED2:          dc.l     0

lbC004ED6:          move.l   lbL004FB2,a0
                    cmp.l    #0,a0
                    bne.s    lbC004EE8
                    bsr      lbC00AE2E
lbC004EE8:          move.l   a0,lbL004F1A
                    move.l   a3,lbL004F1E
                    move.w   #$3199,(a3)
                    lea      lbL0205FA,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC004F0A:          move.w   #$3180,(a3)
                    lea      lbL020696,a2
                    jmp      patch_tiles

lbL004F1A:          dc.l     0
lbL004F1E:          dc.l     0

lbC004F22:          move.l   lbL004FFE,a0
                    cmp.l    #0,a0
                    bne.s    lbC004F34
                    bsr      lbC00AE2E
lbC004F34:          move.l   a0,lbL004F66
                    move.l   a3,lbL004F6A
                    move.w   #$369A,(a3)
                    lea      lbL020616,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC004F56:          move.w   #$3680,(a3)
                    lea      lbL0206BA,a2
                    jmp      patch_tiles

lbL004F66:          dc.l     0
lbL004F6A:          dc.l     0

lbC004F6E:          move.l   lbL004F1A,a0
                    cmp.l    #0,a0
                    bne.s    lbC004F80
                    bsr      lbC00AE2E
lbC004F80:          move.l   a0,lbL004FB2
                    move.l   a3,lbL004FB6
                    move.w   #$3B9B,(a3)
                    lea      lbL020632,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC004FA2:          move.w   #$3B80,(a3)
                    lea      lbL0206DE,a2
                    jmp      patch_tiles

lbL004FB2:          dc.l     0
lbL004FB6:          dc.l     0

lbC004FBA:          move.l   lbL004F66,a0
                    cmp.l    #0,a0
                    bne.s    lbC004FCC
                    bsr      lbC00AE2E
lbC004FCC:          move.l   a0,lbL004FFE
                    move.l   a3,lbL005002
                    move.w   #$2C9C,(a3)
                    lea      lbL0205DE,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC004FEE:          move.w   #$2C80,(a3)
                    lea      lbL020672,a2
                    jmp      patch_tiles

lbL004FFE:          dc.l     0
lbL005002:          dc.l     0
lbW005006:          dc.w     21643

lbC005008:          move.l   lbL005106,a0
                    cmp.l    #0,a0
                    bne.s    lbC00501A
                    bsr      lbC00AE2E
lbC00501A:          move.l   a0,lbL005056
                    lea      lbL0205BA,a1
                    move.l   a3,lbL0050B2
                    and.w    #$FFC0,-2(a3)
                    or.w     #$1E,-2(a3)
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC005044:          and.w    #$FFC0,-2(a3)
                    lea      lbL020786,a2
                    jmp      patch_tiles

lbL005056:          dc.l     0
lbL00505A:          dc.l     0
lbW00505E:          dc.w     21643

lbC005060:          move.l   lbL00515E,a0
                    cmp.l    #0,a0
                    bne.s    lbC005072
                    bsr      lbC00AE2E
lbC005072:          lea      lbL0205BA,a1
                    move.l   a0,lbL0050AE
                    move.l   a3,lbL0050B2
                    and.w    #$FFC0,-2(a3)
                    or.w     #$1F,-2(a3)
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC00509C:          and.w    #$FFC0,-2(a3)
                    lea      lbL020786,a2
                    jmp      patch_tiles

lbL0050AE:          dc.l     0
lbL0050B2:          dc.l     0
lbW0050B6:          dc.w     21643

lbC0050B8:          move.l   lbL005056,a0
                    cmp.l    #0,a0
                    bne.s    lbC0050CA
                    bsr      lbC00AE2E
lbC0050CA:          lea      lbL020596,a1
                    move.l   a0,lbL005106
                    move.l   a3,lbL005162
                    and.w    #$FFC0,-2(a3)
                    or.w     #$24,-2(a3)
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC0050F4:          and.w    #$FFC0,-2(a3)
                    lea      lbL02075A,a2
                    jmp      patch_tiles

lbL005106:          dc.l     0
lbL00510A:          dc.l     0
lbW00510E:          dc.w     21643

lbC005110:          move.l   lbL0050AE,a0
                    cmp.l    #0,a0
                    bne.s    lbC005122
                    bsr      lbC00AE2E
lbC005122:          lea      lbL020596,a1
                    move.l   a0,lbL00515E
                    move.l   a3,lbL005162
                    and.w    #$FFC0,-2(a3)
                    or.w     #$25,-2(a3)
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    rts

lbC00514C:          and.w    #$FFC0,-2(a3)
                    lea      lbL02075A,a2
                    jmp      patch_tiles

lbL00515E:          dc.l     0
lbL005162:          dc.l     0
lbL005166:          dc.l     0

lbC00516A:          tst.w    lbL005166
                    bne      void
                    move.w   #100,lbL005166
                    movem.l  a3,-(sp)
                    sub.l    #990,a3
                    jsr      lbC004EBE
                    sub.l    #246,a3
                    jsr      lbC004E34
                    movem.l  (sp)+,a3
                    movem.l  a3,-(sp)
                    bsr      lbC004F0A
                    sub.l    #1976,a3
                    bsr      lbC004F56
                    add.l    #242,a3
                    bsr      lbC005044
                    add.l    #1488,a3
                    bsr      lbC00509C
                    movem.l  (sp)+,a3
                    movem.l  a3,-(sp)
                    sub.l    #500,a3
                    bsr      lbC004F6E
                    sub.l    #976,a3
                    bsr      lbC004FBA
                    add.l    #234,a3
                    bsr      lbC0050B8
                    add.l    #12,a3
                    bsr      lbC005110
                    movem.l  (sp)+,a3
                    rts

lbC0051F8:          tst.w    lbL005166
                    bne      void
                    move.w   #100,lbL005166
                    movem.l  a3,-(sp)
                    add.l    #986,a3
                    jsr      lbC004EBE
                    sub.l    #246,a3
                    jsr      lbC004E34
                    movem.l  (sp)+,a3
                    movem.l  a3,-(sp)
                    bsr      lbC004F56
                    add.l    #1976,a3
                    bsr      lbC004F0A
                    sub.l    #246,a3
                    bsr      lbC00509C
                    sub.l    #1488,a3
                    bsr      lbC005044
                    movem.l  (sp)+,a3
                    movem.l  a3,-(sp)
                    add.l    #500,a3
                    bsr      lbC004FBA
                    add.l    #976,a3
                    bsr      lbC004F6E
                    sub.l    #742,a3
                    bsr      lbC0050B8
                    add.l    #12,a3
                    bsr      lbC005110
                    movem.l  (sp)+,a3
                    rts

lbC005286:          tst.w    lbL005166
                    bne      void
                    move.w   #100,lbL005166
                    movem.l  a3,-(sp)
                    sub.l    #736,a3
                    jsr      lbC004E6C
                    add.l    #246,a3
                    jsr      lbC004E86
                    movem.l  (sp)+,a3
                    movem.l  a3,-(sp)
                    bsr      lbC004FA2
                    sub.l    #976,a3
                    bsr      lbC004FEE
                    add.l    #246,a3
                    bsr      lbC00514C
                    sub.l    #12,a3
                    bsr      lbC0050F4
                    movem.l  (sp)+,a3
                    movem.l  a3,-(sp)
                    add.l    #500,a3
                    bsr      lbC004ED6
                    sub.l    #1976,a3
                    bsr      lbC004F22
                    add.l    #242,a3
                    bsr      lbC005008
                    add.l    #1488,a3
                    bsr      lbC005060
                    movem.l  (sp)+,a3
                    rts

lbC005314:          tst.w    lbL005166
                    bne      void
                    move.w   #100,lbL005166
                    movem.l  a3,-(sp)
                    add.l    #240,a3
                    jsr      lbC004E6C
                    add.l    #246,a3
                    jsr      lbC004E86
                    movem.l  (sp)+,a3
                    movem.l  a3,-(sp)
                    bsr      lbC004FEE
                    add.l    #976,a3
                    bsr      lbC004FA2
                    sub.l    #742,a3
                    bsr      lbC0050F4
                    add.l    #12,a3
                    bsr      lbC00514C
                    movem.l  (sp)+,a3
                    movem.l  a3,-(sp)
                    sub.l    #500,a3
                    bsr      lbC004F22
                    add.l    #1976,a3
                    bsr      lbC004ED6
                    sub.l    #246,a3
                    bsr      lbC005060
                    sub.l    #1488,a3
                    bsr      lbC005008
                    movem.l  (sp)+,a3
                    rts

lbC0053A2:          lea      lbW0091D4,a1
                    bra      lbC00A718

lbC0053AC:          lea      lbW0091D4,a1
                    bra      lbC00A718

lbC0053B6:          addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL02098A,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0053CA:          bsr      lbC00AE2E
                    lea      lbL0209B6,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0053DC:          addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL0208C6,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC0053F0:          addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL020942,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC005404:          bsr      lbC00AE2E
                    lea      lbL02095E,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC005416:          add.l    #$F8,a3
                    bsr      lbC00AE2E
                    lea      lbL020BAA,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC00542E:          bsr      lbC00AE2E
                    lea      lbL020C3A,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC005440:          bsr      lbC00AE2E
                    lea      lbL020C86,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

lbC005452:          bsr      lbC00AE2E
                    lea      lbL020CD2,a1
                    bsr      lbC00AF10
                    bra      lbC00AED8

none:               rts

display_tiles:      move.l   map_pos_x,d0
                    move.l   map_pos_y,d1
                    lsr.l    #4,d0
                    add.l    lbL0039AA,d0
                    add.w    d0,d0
                    lsr.w    #4,d1
                    add.l    lbL0035D8,d1
                    add.w    d1,d1
                    add.w    d1,d1
                    lea      lbL0023D4,a6
                    move.l   (a6,d1.l),a1
                    add.l    d0,a1
                    add.l    #123480,a1
                    lea      map_lines_table+4,a2
                    move.l   0(a2,d1.l),a2
                    add.l    d0,a2
                    subq.l   #2,a2
                    lea      bkgnd_tiles_block_table,a3
                    move.l   #294*42,d1
                    move.l   #-49390,d2
                    move.l   lbL0039A6,d3
                    clr.l    d4
                    jsr      lbC003EAE
.loop:              move.w   (a2)+,d4
                    and.w    #$FFC0,d4
                    asr.w    #4,d4
                    move.l   (a3,d4.l),a0
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d1,a1
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d1,a1
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d1,a1
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d1,a1
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d2,a1
                    subq.b   #1,d3
                    bne      .loop
                    rts

lbC005620:          move.l   map_pos_x,d0
                    move.l   map_pos_y,d1
                    lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.l    lbL0039AE,d1
                    add.l    lbL0035DC,d0
                    sub.l    #1,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    lea      map_lines_table+4,a2
                    move.l   0(a2,d1.l),a2
                    add.l    d0,a2
                    sub.l    #2,a2
                    lea      bkgnd_tiles_block_table,a3
                    lea      lbL0023D4,a4
                    add.l    d1,a4
                    move.l   d0,d0
                    move.l   #248,d1
                    move.l   #12348,d2
                    move.l   lbL0039A6,d3
                    move.l   (a4),a1
                    add.l    #123480,a1
                    add.l    d0,a1
                    jsr      lbC003EC4
                    clr.l    d4
.loop:              move.l   (a4)+,a1
                    add.l    #123480,a1
                    add.l    d0,a1
                    move.w   (a2),d4
                    add.l    d1,a2
                    and.w    #$FFC0,d4
                    lsr.w    #4,d4
                    move.l   0(a3,d4.l),a0
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d2,a1
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d2,a1
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d2,a1
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    add.l    d2,a1
                    move.w   (a0)+,(a1)
                    move.w   (a0)+,42(a1)
                    move.w   (a0)+,84(a1)
                    move.w   (a0)+,126(a1)
                    move.w   (a0)+,168(a1)
                    move.w   (a0)+,210(a1)
                    move.w   (a0)+,252(a1)
                    move.w   (a0)+,294(a1)
                    move.w   (a0)+,336(a1)
                    move.w   (a0)+,378(a1)
                    move.w   (a0)+,420(a1)
                    move.w   (a0)+,462(a1)
                    move.w   (a0)+,504(a1)
                    move.w   (a0)+,546(a1)
                    move.w   (a0)+,588(a1)
                    move.w   (a0)+,630(a1)
                    subq.b   #1,d3
                    bne      .loop
                    rts

scroll_map:         move.l   map_pos_x,d0
                    move.l   map_pos_y,d1
                    bra.s    do_scroll_map

frame_bkgnd_flag:   dc.w     0

do_scroll_map:      add.w    #15,d0
                    addq.l   #4,d1
                    move.l   d0,d2
                    move.l   d1,d3
                    lsr.w    #4,d0
                    add.w    d0,d0
                    lsr.w    #4,d1
                    add.w    d1,d1
                    add.w    d1,d1
                    and.w    #$f,d3
                    add.w    d3,d3
                    add.w    d3,d3
                    not.w    d2
                    and.w    #$f,d2
                    move.w   d2,d7
                    lsl.w    #4,d7
                    or.w     d7,d2                  ; $x > $xx
                    move.b   d2,bplcon1+1
                    lea      lbL0023D4,a6
                    move.l   0(a6,d1.l),d4
                    lea      lbL002570,a6
                    add.l    0(a6,d3.l),d4
                    add.l    d0,d4
                    move.l   #temp_buffer,d5
                    add.l    d0,d5
                    lsr.w    #1,d1
                    lea      lbL0025D2,a6
                    move.w   #$127,d6
                    sub.w    0(a6,d1.l),d6
                    lsr.w    #2,d3
                    sub.w    d3,d6
                    cmp.w    #$F7,d6
                    bmi.s    lbC00586C
                    move.w   #$F7,d6
lbC00586C:          cmp.w    #$D4,d6
                    bmi.s    lbC005890
                    move.l   #$2401ff00,lbW09A308
                    move.w   #$ffdf,lbW09A294
                    sub.w    #$D4,d6
                    move.b   d6,lbW09A298
                    bra.s    lbC0058AC

lbC005890:          move.l   #$ffdffffe,lbW09A308
                    add.w    #$2C,d6
                    move.w   #$0001,lbW09A294
                    move.b   d6,lbW09A298
lbC0058AC:          cmp.l    #$ffd7fffe,lbW09A298
                    bne      lbC0058C4
                    move.l   #$2401ff00,lbW09A308
lbC0058C4:          cmp.w    #1,frame_bkgnd_flag
                    beq      lbC0058DC
                    add.l    #61740,d4
                    add.l    #61740,d5

lbC0058DC:          move.l   #12348,d7
                    move.w   d4,scroll_bp1+6
                    swap     d4
                    move.w   d4,scroll_bp1+2
                    swap     d4
                    add.l    d7,d4
                    move.w   d4,scroll_bp2+6
                    swap     d4
                    move.w   d4,scroll_bp2+2
                    swap     d4
                    add.l    d7,d4
                    move.w   d4,scroll_bp3+6
                    swap     d4
                    move.w   d4,scroll_bp3+2
                    swap     d4
                    add.l    d7,d4
                    move.w   d4,scroll_bp4+6
                    swap     d4
                    move.w   d4,scroll_bp4+2
                    swap     d4
                    add.l    d7,d4
                    move.w   d4,scroll_bp5+6
                    swap     d4
                    move.w   d4,scroll_bp5+2

                    move.w   d5,lbW09A29E+6
                    swap     d5
                    move.w   d5,lbW09A29E+2
                    swap     d5
                    add.l    d7,d5
                    move.w   d5,lbW09A2A6+6
                    swap     d5
                    move.w   d5,lbW09A2A6+2
                    swap     d5
                    add.l    d7,d5
                    move.w   d5,lbW09A2AE+6
                    swap     d5
                    move.w   d5,lbW09A2AE+2
                    swap     d5
                    add.l    d7,d5
                    move.w   d5,lbW09A2B6+6
                    swap     d5
                    move.w   d5,lbW09A2B6+2
                    swap     d5
                    add.l    d7,d5
                    move.w   d5,lbW09A2BE+6
                    swap     d5
                    move.w   d5,lbW09A2BE+2
                    rts

lbC005990:          lea      player_1_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bmi      lbC005A76
                    lea      player_2_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bmi      lbC005A52
                    move.b   lbW005BD6,d0
                    move.b   lbW005C16,d1
                    ext.l    d0
                    ext.l    d1
                    cmp.w    d1,d0
                    bmi      lbC0059D0
                    lea      lbW005BCC,a2
                    lea      lbW005C0C,a3
                    bra.s    lbC0059DE

lbC0059D0:          move.l   d1,d0
                    lea      lbW005C0C,a2
                    lea      lbW005BCC,a3
lbC0059DE:          sub.w    #2,d0
                    cmp.b    #$FF,lbW09A294
                    beq      lbC0059FA
                    move.b   lbW09A298,d1
                    ext.l    d1
                    cmp.w    d1,d0
                    bpl.s    lbC005A26
lbC0059FA:          lea      lbW09A2C4,a0
                    bsr      lbC005A9A
                    lea      lbW09A250,a0
                    bsr      lbC005B00
                    move.l   a2,a0
                    lea      lbW09A254,a1
                    bsr      lbC005B6A
                    move.l   a3,a0
                    lea      sprite_5_6_bps,a1
                    bra      lbC005B6A

lbC005A26:          lea      lbW09A250,a0
                    bsr      lbC005A9A
                    lea      lbW09A2C4,a0
                    bsr      lbC005B00
                    move.l   a2,a0
                    lea      lbW09A2C8,a1
                    bsr      lbC005B6A
                    move.l   a3,a0
                    lea      sprite_5_6_bps,a1
                    bra      lbC005B6A

lbC005A52:          lea      lbW09A250,a0
                    bsr      lbC005A9A
                    lea      lbW09A2C4,a0
                    bsr      lbC005A9A
                    lea      lbW005BCC,a0
                    lea      sprite_5_6_bps,a1
                    bra      lbC005B6A

lbC005A76:          lea      lbW09A250,a0
                    bsr      lbC005A9A
                    lea      lbW09A2C4,a0
                    bsr      lbC005A9A
                    lea      lbW005C0C,a0
                    lea      sprite_5_6_bps,a1
                    bra      lbC005B6A

lbC005A9A:          move.w   #$98,(a0)
                    move.w   #$98,4(a0)
                    move.w   #$98,8(a0)
                    move.w   #$98,12(a0)
                    move.w   #$98,16(a0)
                    move.w   #$98,20(a0)
                    move.w   #$98,24(a0)
                    move.w   #$98,28(a0)
                    move.w   #$98,32(a0)
                    move.w   #$98,36(a0)
                    move.w   #$98,40(a0)
                    move.w   #$98,44(a0)
                    move.w   #$98,48(a0)
                    move.w   #$98,52(a0)
                    move.w   #$98,56(a0)
                    move.w   #$98,60(a0)
                    move.w   #$98,64(a0)
                    rts

lbC005B00:          move.b   d0,(a0)
                    move.b   #1,1(a0)
                    move.w   #$120,4(a0)
                    move.w   #$122,8(a0)
                    move.w   #$140,12(a0)
                    move.w   #$142,16(a0)
                    move.w   #$124,20(a0)
                    move.w   #$126,24(a0)
                    move.w   #$148,28(a0)
                    move.w   #$14A,32(a0)
                    move.w   #$128,36(a0)
                    move.w   #$12A,40(a0)
                    move.w   #$150,44(a0)
                    move.w   #$152,48(a0)
                    move.w   #$12C,52(a0)
                    move.w   #$12E,56(a0)
                    move.w   #$158,60(a0)
                    move.w   #$15A,64(a0)
                    rts

lbC005B6A:          move.w   2(a0),2(a1)
                    move.w   6(a0),6(a1)
                    move.w   10(a0),10(a1)
                    move.w   14(a0),14(a1)
                    move.w   18(a0),18(a1)
                    move.w   22(a0),22(a1)
                    move.w   26(a0),26(a1)
                    move.w   30(a0),30(a1)
                    move.w   34(a0),34(a1)
                    move.w   38(a0),38(a1)
                    move.w   42(a0),42(a1)
                    move.w   46(a0),46(a1)
                    move.w   50(a0),50(a1)
                    move.w   54(a0),54(a1)
                    move.w   58(a0),58(a1)
                    move.w   62(a0),62(a1)
                    rts

lbW005BCC:          dc.w     $120,0,$122,0,$140
lbW005BD6:          dc.w     0,$142,0,$124,0,$126,0,$148,0,$14A,0
lbW005BEC:          dc.w     $128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0,$158,0
                    dc.w     $15A,0
lbW005C0C:          dc.w     $130,0,$132,0,$160
lbW005C16:          dc.w     0,$162,0,$134,0,$136,0,$168,0,$16A,0
lbW005C2C:          dc.w     $138,0,$13A,0,$170,0,$172,0,$13C,0,$13E,0,$178,0
                    dc.w     $17A,0

player_1_dats:      dc.l    $dff00c
                    dc.l    7
                    dc.l    lbL006FEE
                    dc.l    lbL006B8C
                    dc.l    lbW01227C
                    dc.l    lbL013942
                    dc.l    lbL013952
                    dc.l    lbL013962
                    dc.l    lbL013972
                    dc.l    lbL013982
                    dc.l    lbL013992
                    dc.l    lbL0139A2
                    dc.l    lbL0139B2
                    dc.l    lbL0139C2
                    dc.l    lbL0139EA
                    dc.l    lbL013A12
                    dc.l    lbL013A3A
                    dc.l    lbL013A62
                    dc.l    lbL013A8A
                    dc.l    lbL013AB2
                    dc.l    lbL013ADA
                    dc.l    lbL013B02
                    dc.l    lbL013B1A
                    dc.l    lbL013B32
                    dc.l    lbL013B4A
                    dc.l    lbL013B62
                    dc.l    lbL013B7A
                    dc.l    lbL013B92
                    dc.l    lbL013BAA
                    dc.l    lbL013BC2
                    dc.l    lbL013C0A
                    dc.l    lbL013C52
                    dc.l    lbL013C9A
                    dc.l    lbL013CE2
                    dc.l    lbL013D2A
                    dc.l    lbL013D72
                    dc.l    lbL013DBA
                    dc.l    lbL013E02
                    dc.l    lbL013E2A
                    dc.l    lbL013E52
                    dc.l    lbL013E7A
                    dc.l    lbL013EA2
                    dc.l    lbL013ECA
                    dc.l    lbL013EF2
                    dc.l    lbL013F1A
                    dc.l    lbL013F42
                    dc.l    lbL013F5A
                    dc.l    lbL013F72
                    dc.l    lbL013F8A
                    dc.l    lbL013FA2
                    dc.l    lbL013FBA
                    dc.l    lbL013FD2
                    dc.l    lbL013FEA
                    dc.l    lbL014002
                    dc.l    lbL01401A
                    dc.l    lbL014032
                    dc.l    lbL01404A
                    dc.l    lbL014062
                    dc.l    lbL01407A
                    dc.l    lbL014092
                    dc.l    lbL0140AA               ; $f0
lbL005D40:          dc.l    lbL00E9C2
lbL005D44:          dc.l    lbL00E9C2               ; $f8
                    dc.l    $10                     ; $fc
player_1_cur_weapon:
                    dc.l    1                       ; $100
                    dc.l    3                       ; $104
lbL005D54:          dc.l    9                       ; $108 maybe the strengh of the player (if used)
                    dc.l    0                       ; $10c
                    dc.l    0                       ; $110
                    dc.l    0                       ; $114
lbW005D64:          dcb.w   6,0                     ; $118
lbW005D70:          dcb.w   4,0                     ; $124
player_1_pos_x:     dc.w    0                       ; $12c
player_1_pos_y:     dcb.w   7,0                     ; $12e
player_1_alive:     dcb.w   10,0                    ; $13c
player_1_health:    dcb.w   2,0                     ; $150
player_1_lives:     dc.l    0                       ; $154
player_1_ammopacks: dc.w    0                       ; $158
                    dc.w    0                       ; $15a
player_1_ammos:     dc.w    0                       ; $15c
                    dc.w    0                       ; $15e
player_1_keys:      dc.l    0                       ; $160
player_1_credits:   dc.l    0                       ; $164
                    dc.l    0                       ; $168
                    dc.l    0                       ; $16c
                    dc.l    0                       ; $170
lbW005DC0:          dc.w    0                       ; $174
                    dc.w    0                       ; $176
player_1_extra_spd_x:
                    dc.w    0                       ; $178
player_1_extra_spd_y:
                    dc.w    0                       ; $17a
                    dc.l    0                       ; $17c
                    dc.w    0                       ; $180
                    dc.w    0                       ; $182
                    dc.w    0                       ; $184
                    dc.w    0                       ; $186
                    dc.w    0                       ; $188
                    dc.w    0                       ; $18a
                    dc.w    0                       ; $18c
                    dc.w    0                       ; $18e
                    dc.w    0                       ; $190
player_1_ownweapons:
                    dc.w    0                       ; $192
                    dc.w    0                       ; $194
                    dc.w    0                       ; $196
                    dc.w    0                       ; $198
                    dc.w    0                       ; $19a
                    dc.w    0                       ; $19c
                    dc.w    0                       ; $19e
                    dc.w    0                       ; $1a0
                    dc.w    0                       ; $1a2
                    dc.w    0                       ; $1a4
                    dc.w    0                       ; $1a6
                    dc.w    0                       ; $1a8
                    dc.w    0                       ; $1aa
player_1_old_pos_x: dc.w    0                       ; $1ac
                    dc.w    0                       ; $1ae
player_1_old_pos_y: dc.w    0                       ; $1b0
                    dc.w    0                       ; $1b2
player_1_shots:     dc.l    0                       ; $1b4
player_1_score:     dcb.l   378,0                   ; $1b8

player_2_dats:      dc.l    $dff00a
                    dc.l    6
                    dc.l    lbL006FEE
                    dc.l    lbL006B90
                    dc.l    lbW0122B8
                    dc.l    lbL0140C2
                    dc.l    lbL0140D2
                    dc.l    lbL0140E2
                    dc.l    lbL0140F2
                    dc.l    lbL014102
                    dc.l    lbL014112
                    dc.l    lbL014122
                    dc.l    lbL014132
                    dc.l    lbL014142
                    dc.l    lbL01416A
                    dc.l    lbL014192
                    dc.l    lbL0141BA
                    dc.l    lbL0141E2
                    dc.l    lbL01420A
                    dc.l    lbL014232
                    dc.l    lbL01425A
                    dc.l    lbL014282
                    dc.l    lbL01429A
                    dc.l    lbL0142B2
                    dc.l    lbL0142CA
                    dc.l    lbL0142E2
                    dc.l    lbL0142FA
                    dc.l    lbL014312
                    dc.l    lbL01432A
                    dc.l    lbL014342
                    dc.l    lbL01435A
                    dc.l    lbL014372
                    dc.l    lbL01438A
                    dc.l    lbL0143A2
                    dc.l    lbL0143BA
                    dc.l    lbL0143D2
                    dc.l    lbL0143EA
                    dc.l    lbL014402
                    dc.l    lbL01442A
                    dc.l    lbL014452
                    dc.l    lbL01447A
                    dc.l    lbL0144A2
                    dc.l    lbL0144CA
                    dc.l    lbL0144F2
                    dc.l    lbL01451A
                    dc.l    lbL014542
                    dc.l    lbL014556
                    dc.l    lbL01456A
                    dc.l    lbL01457E
                    dc.l    lbL014592
                    dc.l    lbL0145A6
                    dc.l    lbL0145BA
                    dc.l    lbL0145CE
                    dc.l    lbL0145E2
                    dc.l    lbL0145FA
                    dc.l    lbL014612
                    dc.l    lbL01462A
                    dc.l    lbL014642
                    dc.l    lbL01465A
                    dc.l    lbL014672
                    dc.l    lbL01468A
lbL0064E0:          dc.l    lbL00E9D2
lbL0064E4:          dc.l    lbL00E9D2
                    dc.l    16                      ; $fc
player_2_cur_weapon:
                    dc.l    1                       ; $100
                    dc.l    3                       ; $104
lbL0064F4:          dc.l    9                       ; $108
                    dc.l    0                       ; $10c
                    dc.l    0                       ; $110
                    dc.l    0                       ; $114
lbW006504:          dcb.w   6,0                     ; $118
lbW006510:          dcb.w   4,0                     ; $124
player_2_pos_x:     dc.w    0                       ; $12c
player_2_pos_y:     dcb.w   7,0                     ; $12e
player_2_alive:     dcb.w   10,0                    ; $13c
player_2_health:    dcb.w   2,0                     ; $150
player_2_lives:     dc.l    0                       ; $154
player_2_ammopacks: dc.w    0                       ; $158
                    dc.w    0                       ; $15a
player_2_ammos:     dc.w    0                       ; $15c
                    dc.w    0                       ; $15e
player_2_keys:      dc.l    0                       ; $160
player_2_credits:   dc.l    0                       ; $164
                    dc.l    0                       ; $168
                    dc.l    0                       ; $16c
                    dc.l    0                       ; $170
lbW006560:          dc.w    0                       ; $174
                    dc.w    0                       ; $176
player_2_extra_spd_x:
                    dc.w    0                       ; $178
player_2_extra_spd_y:
                    dc.w    0                       ; $17a
                    dc.l    0                       ; $17c
                    dc.w    0                       ; $180
                    dc.w    0                       ; $182
                    dc.w    0                       ; $184
                    dc.w    0                       ; $186
                    dc.w    0                       ; $188
                    dc.w    0                       ; $18a
                    dc.w    0                       ; $18c
                    dc.w    0                       ; $18e
                    dc.w    0                       ; $190
player_2_ownweapons:
                    dc.w    0                       ; $192
                    dc.w    0                       ; $194
                    dc.w    0                       ; $196
                    dc.w    0                       ; $198
                    dc.w    0                       ; $19a
                    dc.w    0                       ; $19c
                    dc.w    0                       ; $19e
                    dc.w    0                       ; $1a0
                    dc.w    0                       ; $1a2
                    dc.w    0                       ; $1a4
                    dc.w    0                       ; $1a6
                    dc.w    0                       ; $1a8
                    dc.w    0                       ; $1aa
player_2_old_pos_x: dc.w    0                       ; $1ac
                    dc.w    0                       ; $1ae
player_2_old_pos_y: dc.w    0                       ; $1b0
                    dc.w    0                       ; $1b2
player_2_shots:     dc.l    0                       ; $1b4
player_2_score:     dcb.l   378,0                   ; $1b8

lbL006B8C:          dc.l     0
lbL006B90:          dc.l     0

lbC006B94:          lea      player_1_dats,a0
                    jsr      lbC006C08
                    lea      player_2_dats,a0
                    jsr      lbC006C08
                    cmp.l    #2,number_players
                    beq      lbC006BD0
                    lea      player_1_dats,a0
                    bsr      lbC006BE4
                    lea      player_2_dats,a0
                    bra      lbC006BF6

lbC006BD0:          lea      player_1_dats,a0
                    bsr      lbC006BE4
                    lea      player_2_dats,a0
                    bra      lbC006BE4

lbC006BE4:          move.l   $10(a0),a1
                    move.w   PLAYER_POS_X(a0),-4(a1)
                    move.w   PLAYER_POS_Y(a0),-2(a1)
                    rts

lbC006BF6:          move.l   $10(a0),a1
                    move.w   #2984,PLAYER_POS_X(a0)
                    move.w   PLAYER_POS_X(a0),-4(a1)
                    rts

lbC006C08:          clr.w    $112(a0)
                    clr.w    $114(a0)
                    clr.w    $118(a0)
                    clr.w    $174(a0)
                    clr.w    PLAYER_EXTRA_SPD_X(a0)
                    clr.w    PLAYER_EXTRA_SPD_Y(a0)
                    clr.l    $17C(a0)
                    move.w   #3,PLAYER_CUR_SPRITE(a0)
                    rts

lbC006C28:          jsr      lbC006C5E
                    lea      player_1_dats,a6
                    tst.w    PLAYER_ALIVE(a6)
                    bpl      void
                    lea      player_2_dats,a6
                    tst.w    PLAYER_ALIVE(a6)
                    bpl      void
                    move.l   #1,flag_jump_to_gameover
                    move.w   #1,lbL000586
                    rts

lbC006C5E:          clr.w    $118(a0)
                    move.w   #-1,PLAYER_ALIVE(a0)
                    move.w   #$BA8,PLAYER_POS_X(a0)
                    move.l   $10(a0),a6
                    move.w   PLAYER_POS_X(a0),-4(a6)
                    rts

lbC006C7A:          cmp.w    #1,player_1_health
                    bpl.s    lbC006C9E
                    cmp.w    #1,lbW005D64
                    bpl      lbC006C9E
                    move.w   #200,lbW005D64
                    clr.w    lbW005D70
lbC006C9E:          cmp.w    #1,player_2_health
                    bpl.s    lbC006CC0
                    cmp.w    #1,lbW006504
                    bpl.s    lbC006CC0
                    move.w   #$C8,lbW006504
                    clr.w    lbW006510
lbC006CC0:          lea      player_1_dats,a0
                    bsr      lbC006CD0
                    lea      player_2_dats,a0
lbC006CD0:          tst.w    PLAYER_HEALTH(a0)
                    beq      lbC006D30
                    cmp.w    #$1C,PLAYER_HEALTH(a0)
                    bpl.s    lbC006D30
                    tst.w    $1A8(a0)
                    bne      void
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbL02312E,a6
                    move.w   #$3C,lbW02314E
                    move.w   #$41,lbW02313A
                    cmp.l    #player_1_dats,a0
                    beq      lbC006D14
                    move.w   #$42,lbW02313A
lbC006D14:          jsr      lbC02325A
                    tst.w    lbW02328A
                    beq      lbC006D2A
                    move.w   #1,$1A8(a0)
lbC006D2A:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC006D30:          clr.w    $1A8(a0)
                    rts

lbW006D36:          dc.w     0
lbW006D38:          dc.w     0
lbW006D3A:          dc.w     0

lbC006D3C:          clr.w    lbW006D3A
                    tst.w    d0
                    bne      void
                    move.w   6(a0),d2
                    btst     d2,$bfe001
                    beq      void
                    cmp.w    #-1,player_2_alive
                    beq      lbC006D6C
                    cmp.l    #player_2_dats,a0
                    bne      void
lbC006D6C:          move.w   #1,lbW006D3A
                    move.w   lbW006D36,d0
                    cmp.b    #KEY_LEFT,key_released
                    bne.s    lbC006D94
                    bclr     #3,d0
                    clr.b    key_released
                    clr.b    key_pressed
lbC006D94:          cmp.b    #KEY_RIGHT,key_released
                    bne      lbC006DB0
                    bclr     #2,d0
                    clr.b    key_released
                    clr.b    key_pressed
lbC006DB0:          cmp.b    #KEY_UP,key_released
                    bne      lbC006DCC
                    bclr     #1,d0
                    clr.b    key_released
                    clr.b    key_pressed
lbC006DCC:          cmp.b    #KEY_DOWN,key_released
                    bne      lbC006DE8
                    bclr     #0,d0
                    clr.b    key_released
                    clr.b    key_pressed
lbC006DE8:          cmp.b    #KEY_RETURN,key_released
                    bne      lbC006E06
                    clr.w    lbW006D38
                    clr.b    key_released
                    clr.b    key_pressed
lbC006E06:          cmp.b    #KEY_LEFT,key_pressed
                    bne.s    lbC006E18
                    bset     #3,d0
                    bclr     #2,d0
lbC006E18:          cmp.b    #KEY_RIGHT,key_pressed
                    bne.s    lbC006E2A
                    bset     #2,d0
                    bclr     #3,d0
lbC006E2A:          cmp.b    #KEY_UP,key_pressed
                    bne.s    lbC006E3C
                    bset     #1,d0
                    bclr     #0,d0
lbC006E3C:          cmp.b    #KEY_DOWN,key_pressed
                    bne.s    lbC006E4E
                    bset     #0,d0
                    bclr     #1,d0
lbC006E4E:          cmp.b    #KEY_RETURN,key_pressed
                    bne.s    lbC006E60
                    move.w   #1,lbW006D38
lbC006E60:          move.w   d0,lbW006D36
                    lsl.w    #1,d0
                    beq      void
                    lea      lbL006E76(pc),a6
                    move.w   0(a6,d0.w),d0
                    rts

lbL006E76:          dc.w     0,5,1,0,3,4,2,0,7,6,8,0,0,0,0,0

lbC006E96:          tst.w    PLAYER_ALIVE(a0)
                    bmi      void
                    tst.w    $118(a0)
                    beq.s    lbC006EB0
                    subq.w   #1,$118(a0)
                    move.w   #36,d0
                    bra      lbC006F64

lbC006EB0:          move.l   0(a0),a6
                    move.w   (a6),d0
                    move.w   d0,d1
                    and.w    #3,d0
                    and.w    #$300,d1
                    lsr.w    #4,d1
                    or.w     d1,d0
                    lea      joystick_directions(pc),a6
                    move.b   0(a6,d0.w),d0
                    tst.w    music_enabled
                    beq.s    lbC006EE2
                    clr.w    d0
lbC006EE2:          jsr      lbC006D3C
                    cmp.w    #9,d0
                    bmi      lbC006EF4
                    move.w   #0,d0
lbC006EF4:          tst.w    d0
                    beq.s    lbC006F18
                    not.w    $120(a0)
                    beq.s    lbC006F18
                    move.w   d0,d2
                    move.w   PLAYER_CUR_SPRITE(a0),d1
                    lea      lbB00A24F,a6
                    lsl.w    #3,d0
                    add.w    d1,d0
                    move.b   0(a6,d0.w),d0
                    move.w   d0,PLAYER_CUR_SPRITE(a0)
                    move.w   d2,d0
lbC006F18:          tst.w    $112(a0)
                    beq.s    lbC006F24
                    add.w    #$1B,d0
                    bra.s    lbC006F64

lbC006F24:          tst.w    $124(a0)
                    beq      lbC006F38
                    subq.w   #1,$124(a0)
                    add.w    #$12,d0
                    bra      lbC006F64

lbC006F38:          tst.w    lbW006D3A
                    beq      lbC006F54
                    tst.w    lbW006D38
                    beq      lbC006F64
                    add.w    #9,d0
                    bra      lbC006F64

lbC006F54:          move.w   6(a0),d1
                    btst     d1,$bfe001
                    bne.s    lbC006F64
                    add.w    #9,d0
lbC006F64:          move.w   d0,$128(a0)
                    bra      lbC006FD0

joystick_directions:
                    dc.b     0,5,4,3,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,2,0,0,0,0,0
                    dc.b     0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,6

lbC006FD0:          move.w   $128(a0),d0
                    ext.l    d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   8(a0),a6
                    move.l   0(a6,d0.l),a6
                    clr.l    lbB006FEA
                    jmp      (a6)

lbB006FEA:          dcb.b    2,0
lbW006FEC:          dc.w     0
lbL006FEE:          dc.l     lbC007082
                    dc.l     lbC0070A6
                    dc.l     lbC0070DC
                    dc.l     lbC007102
                    dc.l     lbC007138
                    dc.l     lbC00715E
                    dc.l     lbC007194
                    dc.l     lbC0071BA
                    dc.l     lbC0071F0
                    dc.l     lbC00727A
                    dc.l     lbC0072AA
                    dc.l     lbC0072EC
                    dc.l     lbC00731E
                    dc.l     lbC007360
                    dc.l     lbC007392
                    dc.l     lbC0073D4
                    dc.l     lbC007406
                    dc.l     lbC007448
                    dc.l     lbC00747A
                    dc.l     lbC0074A2
                    dc.l     lbC0074DC
                    dc.l     lbC007506
                    dc.l     lbC007540
                    dc.l     lbC00756A
                    dc.l     lbC0075A4
                    dc.l     lbC0075CE
                    dc.l     lbC007608
                    dc.l     lbC007658
                    dc.l     lbC007680
                    dc.l     lbC0076A6
                    dc.l     lbC0076D0
                    dc.l     lbC0076F6
                    dc.l     lbC007720
                    dc.l     lbC007746
                    dc.l     lbC007770
                    dc.l     lbC007796
                    dc.l     lbC0077DC

lbC007082:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $14(a0,d0.l),a6
                    jsr      lbC011346
                    jsr      lbC0078AC
                    bra      lbC00E08A

lbC0070A6:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $34(a0,d0.l),a6
                    jsr      lbC011346
                    bsr      lbC00799A
                    bsr      lbC007216
                    tst.w    lbW006FEC
                    bne      lbC00E08A
                    jsr      lbC0078F0
                    bra      lbC00E08A

lbC0070DC:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $34(a0,d0.l),a6
                    jsr      lbC011346
                    bsr      lbC00799A
                    bsr      lbC007926
                    bra      lbC00E08A

lbC007102:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $34(a0,d0.l),a6
                    jsr      lbC011346
                    bsr      lbC007926
                    bsr      lbC007248
                    tst.w    lbB006FEA
                    bne      lbC00E08A
                    jsr      lbC0078B6
                    bra      lbC00E08A

lbC007138:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $34(a0,d0.l),a6
                    jsr      lbC011346
                    bsr      lbC007926
                    bsr      lbC0079D6
                    bra      lbC00E08A

lbC00715E:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $34(a0,d0.l),a6
                    jsr      lbC011346
                    bsr      lbC0079D6
                    bsr      lbC007216
                    tst.w    lbW006FEC
                    bne      lbC00E08A
                    jsr      lbC0078F0
                    bra      lbC00E08A

lbC007194:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $34(a0,d0.l),a6
                    jsr      lbC011346
                    bsr      lbC0079D6
                    bsr      lbC007962
                    bra      lbC00E08A

lbC0071BA:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $34(a0,d0.l),a6
                    jsr      lbC011346
                    bsr      lbC007962
                    bsr      lbC007248
                    tst.w    lbB006FEA
                    bne      lbC00E08A
                    jsr      lbC0078B6
                    bra      lbC00E08A

lbC0071F0:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $34(a0,d0.l),a6
                    jsr      lbC011346
                    bsr      lbC007962
                    bsr      lbC00799A
                    bra      lbC00E08A

lbC007216:          tst.w    $196(a0)
                    bne      lbC007228
                    tst.w    $198(a0)
                    bne      lbC007238
                    rts

lbC007228:          tst.w    $198(a0)
                    bne      lbC00E08A
                    jsr      lbC007926
                    rts

lbC007238:          tst.w    $196(a0)
                    bne      lbC00E08A
                    jsr      lbC007962
                    rts

lbC007248:          tst.w    $19A(a0)
                    bne      lbC00725A
                    tst.w    $19C(a0)
                    bne      lbC00726A
                    rts

lbC00725A:          tst.w    $19C(a0)
                    bne      lbC00E08A
                    jsr      lbC00799A
                    rts

lbC00726A:          tst.w    $19A(a0)
                    bne      lbC00E08A
                    jsr      lbC0079D6
                    rts

lbC00727A:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $54(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC00729A
                    move.l   $14(a0,d0.l),a6
lbC00729A:          jsr      lbC011346
                    jsr      lbC0078AC
                    bra      lbC00E0C8

lbC0072AA:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $74(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC0072CA
                    move.l   $34(a0,d0.l),a6
lbC0072CA:          jsr      lbC011346
                    bsr      lbC00799A
                    bsr      lbC007216
                    tst.w    lbW006FEC
                    bne      lbC00E0C8
                    jsr      lbC0078F0
                    bra      lbC00E0C8

lbC0072EC:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $74(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC00730C
                    move.l   $34(a0,d0.l),a6
lbC00730C:          jsr      lbC011346
                    bsr      lbC00799A
                    bsr      lbC007926
                    bra      lbC00E0C8

lbC00731E:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $74(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC00733E
                    move.l   $34(a0,d0.l),a6
lbC00733E:          jsr      lbC011346
                    bsr      lbC007926
                    bsr      lbC007248
                    tst.w    lbB006FEA
                    bne      lbC00E0C8
                    jsr      lbC0078B6
                    bra      lbC00E0C8

lbC007360:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $74(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC007380
                    move.l   $34(a0,d0.l),a6
lbC007380:          jsr      lbC011346
                    bsr      lbC007926
                    bsr      lbC0079D6
                    bra      lbC00E0C8

lbC007392:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $74(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC0073B2
                    move.l   $34(a0,d0.l),a6
lbC0073B2:          jsr      lbC011346
                    bsr      lbC0079D6
                    bsr      lbC007216
                    tst.w    lbW006FEC
                    bne      lbC00E0C8
                    jsr      lbC0078F0
                    bra      lbC00E0C8

lbC0073D4:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $74(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC0073F4
                    move.l   $34(a0,d0.l),a6
lbC0073F4:          jsr      lbC011346
                    bsr      lbC0079D6
                    bsr      lbC007962
                    bra      lbC00E0C8

lbC007406:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $74(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC007426
                    move.l   $34(a0,d0.l),a6
lbC007426:          jsr      lbC011346
                    bsr      lbC007962
                    bsr      lbC007248
                    tst.w    lbB006FEA
                    bne      lbC00E0C8
                    jsr      lbC0078B6
                    bra      lbC00E0C8

lbC007448:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   $74(a0,d0.l),a6
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC007468
                    move.l   $34(a0,d0.l),a6
lbC007468:          jsr      lbC011346
                    bsr      lbC007962
                    bsr      lbC00799A
                    bra      lbC00E0C8

lbC00747A:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    jsr      lbC0078AC
                    bra      lbC007632

lbC0074A2:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    bsr      lbC00799A
                    bsr      lbC007216
                    tst.w    lbW006FEC
                    bne      lbC007632
                    jsr      lbC0078F0
                    bra      lbC007632

lbC0074DC:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    bsr      lbC00799A
                    bsr      lbC007926
                    bra      lbC007632

lbC007506:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    bsr      lbC007926
                    bsr      lbC007248
                    tst.w    lbB006FEA
                    bne      lbC007632
                    jsr      lbC0078B6
                    bra      lbC007632

lbC007540:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    bsr      lbC007926
                    bsr      lbC0079D6
                    bra      lbC007632

lbC00756A:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    bsr      lbC0079D6
                    bsr      lbC007216
                    tst.w    lbW006FEC
                    bne      lbC007632
                    jsr      lbC0078F0
                    bra      lbC007632

lbC0075A4:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    bsr      lbC0079D6
                    bsr      lbC007962
                    bra      lbC007632

lbC0075CE:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    bsr      lbC007962
                    bsr      lbC007248
                    tst.w    lbB006FEA
                    bne      lbC007632
                    jsr      lbC0078B6
                    bra      lbC007632

lbC007608:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $94(a6),a6
                    jsr      lbC011346
                    bsr      lbC007962
                    bsr      lbC00799A
                    bra      lbC007632

lbC007632:          tst.w    $186(a0)
                    bne.s    lbC007650
                    move.w   #33,sample_to_play
                    jsr      trigger_sample
                    move.w   #10,$186(a0)
                    bra      lbC00E08A

lbC007650:          subq.w   #1,$186(a0)
                    bra      lbC00E08A

lbC007658:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    jsr      lbC0078AC
                    bra      lbC0077C0

lbC007680:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    bsr      lbC00799A
                    bra      lbC0077C0

lbC0076A6:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    bsr      lbC00799A
                    bsr      lbC007926
                    bra      lbC0077C0

lbC0076D0:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    bsr      lbC007926
                    bra      lbC0077C0

lbC0076F6:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    bsr      lbC007926
                    bsr      lbC0079D6
                    bra      lbC0077C0

lbC007720:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    bsr      lbC0079D6
                    bra      lbC0077C0

lbC007746:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    bsr      lbC0079D6
                    bsr      lbC007962
                    bra      lbC0077C0

lbC007770:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    bsr      lbC007962
                    bra      lbC0077C0

lbC007796:          move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.l    d0,a6
                    move.l   $D4(a6),a6
                    jsr      lbC011346
                    bsr      lbC007962
                    bsr      lbC00799A
                    bra      lbC0077C0

lbC0077C0:          move.w   #64,PLAYER_HEALTH(a0)
                    tst.w    $114(a0)
                    beq.s    lbC0077D4
                    subq.w   #1,$114(a0)
                    bra      lbC00E08A

lbC0077D4:          clr.w    $112(a0)
                    bra      lbC00E08A

lbC0077DC:          cmp.w    #199,$118(a0)
                    bne.s    lbC0077F2
                    move.w   #73,sample_to_play
                    jsr      trigger_sample
lbC0077F2:          jsr      lbC0078AC
                    move.w   $118(a0),d0
                    cmp.w    #140,d0
                    bpl.s    lbC00780C
                    cmp.w    #130,d0
                    bpl.s    lbC007854
                    bra      lbC00788E

lbC00780C:          addq.w   #1,$11C(a0)
                    cmp.w    #3,$11C(a0)
                    bmi      lbC00E08A
                    clr.w    $11C(a0)
                    move.l   $10(a0),a5
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    ext.l    d0
                    subq.w   #1,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    move.l   a0,a6
                    add.w    d0,a6
                    move.l   $B4(a6),a6
                    jsr      lbC011346
                    move.w   PLAYER_CUR_SPRITE(a0),d0
                    addq.w   #1,d0
                    cmp.w    #8,d0
                    bmi.s    lbC00784C
                    move.w   #1,d0
lbC00784C:          move.w   d0,PLAYER_CUR_SPRITE(a0)
                    bra      lbC00E08A

lbC007854:          cmp.w    #$8B,d0
                    bne.s    lbC00787A
                    subq.w   #1,PLAYER_LIVES(a0)
                    tst.w    PLAYER_LIVES(a0)
                    bne.s    lbC00787A
                    move.l   $10(a0),a5
                    lea      lbL0146A2,a6
                    jsr      lbC011346
                    jmp      lbC006C28

lbC00787A:          move.l   $10(a0),a5
                    lea      lbL0146A2,a6
                    jsr      lbC011346
                    bra      lbC00E08A

lbC00788E:          move.w   #$40,PLAYER_HEALTH(a0)
                    clr.w    $124(a0)
                    move.w   #1,$112(a0)
                    move.w   #$32,$114(a0)
                    clr.w    $118(a0)
                    bra      lbC00E08A

lbC0078AC:          bsr      lbC0078B6
                    bsr      lbC0078F0
                    rts

lbC0078B6:          move.w   lbW0035D2,d0
                    add.w    #$14,d0
                    cmp.w    PLAYER_POS_Y(a0),d0
                    bpl      void
                    move.w   lbW0035D2,d0
                    add.w    #$DA,d0
                    cmp.w    PLAYER_POS_Y(a0),d0
                    bmi      void
                    move.w   PLAYER_EXTRA_SPD_Y(a0),d0
                    move.l   $10(a0),a6
                    add.w    d0,-2(a6)
                    move.w   #1,lbB006FEA
                    rts

lbC0078F0:          move.w   lbW0035D6,d0
                    add.w    #$100,d0
                    cmp.w    PLAYER_POS_X(a0),d0
                    bmi      void
                    move.w   lbW0035D6,d0
                    cmp.w    PLAYER_POS_X(a0),d0
                    bpl      void
                    move.w   PLAYER_EXTRA_SPD_X(a0),d0
                    move.l   $10(a0),a6
                    add.w    d0,-4(a6)
                    move.w   #1,lbW006FEC
                    rts

lbC007926:          tst.w    $116(a0)
                    bne      void
                    move.w   lbW0035D6,d0
                    add.w    #$100,d0
                    cmp.w    PLAYER_POS_X(a0),d0
                    bmi      void
                    move.w   $134(a0),d0
                    beq.s    lbC00794A
                    add.w    PLAYER_EXTRA_SPD_X(a0),d0
lbC00794A:          move.l   $10(a0),a6
                    add.w    d0,-4(a6)
                    move.w   #1,$144(a0)
                    move.w   #1,lbW006FEC
                    rts

lbC007962:          tst.w    $116(a0)
                    bne      void
                    move.w   lbW0035D6,d0
                    cmp.w    PLAYER_POS_X(a0),d0
                    bpl      void
                    move.w   $134(a0),d0
                    beq.s    lbC007982
                    sub.w    PLAYER_EXTRA_SPD_X(a0),d0
lbC007982:          move.l   $10(a0),a6
                    sub.w    d0,-4(a6)
                    move.w   #$100,$144(a0)
                    move.w   #1,lbW006FEC
                    rts

lbC00799A:          tst.w    $116(a0)
                    bne      void
                    move.w   lbW0035D2,d0
                    add.w    #$14,d0
                    cmp.w    PLAYER_POS_Y(a0),d0
                    bpl      void
                    move.w   $138(a0),d0
                    beq.s    lbC0079BE
                    sub.w    PLAYER_EXTRA_SPD_Y(a0),d0
lbC0079BE:          move.l   $10(a0),a6
                    sub.w    d0,-2(a6)
                    move.w   #$100,$146(a0)
                    move.w   #1,lbB006FEA
                    rts

lbC0079D6:          tst.w    $116(a0)
                    bne      void
                    move.w   lbW0035D2,d0
                    add.w    #$DA,d0
                    cmp.w    PLAYER_POS_Y(a0),d0
                    bmi      void
                    move.w   $138(a0),d0
                    beq.s    lbC0079FA
                    add.w    PLAYER_EXTRA_SPD_Y(a0),d0
lbC0079FA:          move.l   $10(a0),a6
                    add.w    d0,-2(a6)
                    move.w   #$10,$146(a0)
                    move.w   #1,lbB006FEA
                    rts

lbC007A12:          jsr      lbC007A20
                    rts

lbC007A20:          lea      player_1_dats,a1
                    lea      player_2_dats,a2
                    move.l   $10(a1),a3
                    move.l   $10(a2),a4
                    tst.w    PLAYER_ALIVE(a1)
                    bmi      lbC007AA4
                    tst.w    PLAYER_ALIVE(a2)
                    bmi.s    lbC007A98
                    move.w   -4(a3),d0
                    move.w   -2(a3),d1
                    addq.w   #8,d0
                    addq.w   #8,d1
                    move.w   d0,d2
                    move.w   d1,d3
                    add.w    #16,d2
                    add.w    #16,d3
                    move.w   -4(a4),d4
                    move.w   -2(a4),d5
                    addq.w   #8,d4
                    addq.w   #8,d5
                    move.w   d4,d6
                    move.w   d5,d7
                    add.w    #16,d6
                    add.w    #16,d7
                    cmp.w    d0,d6
                    bmi.s    lbC007A98
                    cmp.w    d1,d7
                    bmi.s    lbC007A98
                    cmp.w    d4,d2
                    bmi.s    lbC007A98
                    cmp.w    d5,d3
                    bmi.s    lbC007A98
                    move.w   PLAYER_POS_X(a1),-4(a3)
                    move.w   PLAYER_POS_Y(a1),-2(a3)
                    bra.s    lbC007AA4

lbC007A98:          move.w   -4(a3),PLAYER_POS_X(a1)
                    move.w   -2(a3),PLAYER_POS_Y(a1)
lbC007AA4:          tst.w    PLAYER_ALIVE(a2)
                    bmi      void
                    tst.w    PLAYER_ALIVE(a1)
                    bmi.s    lbC007B08
                    move.w   -4(a4),d0
                    move.w   -2(a4),d1
                    addq.w   #8,d0
                    addq.w   #8,d1
                    move.w   d0,d2
                    move.w   d1,d3
                    add.w    #16,d2
                    add.w    #16,d3
                    move.w   -4(a3),d4
                    move.w   -2(a3),d5
                    addq.w   #8,d4
                    addq.w   #8,d5
                    move.w   d4,d6
                    move.w   d5,d7
                    add.w    #16,d6
                    add.w    #16,d7
                    cmp.w    d0,d6
                    bmi.s    lbC007B08
                    cmp.w    d1,d7
                    bmi.s    lbC007B08
                    cmp.w    d4,d2
                    bmi.s    lbC007B08
                    cmp.w    d5,d3
                    bmi.s    lbC007B08
                    move.w   PLAYER_POS_X(a2),-4(a4)
                    move.w   PLAYER_POS_Y(a2),-2(a4)
                    rts

lbC007B08:          move.w   -4(a4),PLAYER_POS_X(a2)
                    move.w   -2(a4),PLAYER_POS_Y(a2)
                    rts

lbW007B16:          dc.w     -4,-4,-4,-6,4,16
lbW007B22:          dc.w     30,30,30,-6,4,16
lbW007B2E:          dc.w     0,10,22,-10,-10,-10
lbW007B3A:          dc.w     0,10,22,20,20,20
lbW007B46:          dc.w     0
lbW007B48:          dc.w     0
lbW007B4A:          dc.w     0

lbC007B4C:          tst.w    PLAYER_ALIVE(a0)
                    bmi      void
                    clr.w    $174(a0)
                    clr.w    PLAYER_EXTRA_SPD_X(a0)
                    clr.w    PLAYER_EXTRA_SPD_Y(a0)
                    not.w    $148(a0)
                    bne.s    lbC007B7E
                    move.w   #2,$134(a0)
                    clr.l    $19A(a0)
                    tst.b    $144(a0)
                    bne.s    lbC007B78
                    lea      lbW007B22(pc),a4
                    bra.s    lbC007B98

lbC007B78:          lea      lbW007B16(pc),a4
                    bra.s    lbC007B98

lbC007B7E:          move.w   #2,$138(a0)
                    clr.l    $196(a0)
                    tst.b    $146(a0)
                    bne.s    lbC007B94
                    lea      lbW007B3A(pc),a4
                    bra.s    lbC007B98

lbC007B94:          lea      lbW007B2E(pc),a4
lbC007B98:          clr.l    d0
                    clr.l    d1
                    lea      tiles_action_table(pc),a5
                    lea      map_lines_table+4(pc),a6
                    clr.w    lbW007B46
                    clr.w    lbW007B48
                    move.w   #1,lbW007B4A
                    move.w   PLAYER_POS_X(a0),d0
                    move.w   PLAYER_POS_Y(a0),d1
                    move.w   d0,d6
                    move.w   d1,d7
                    add.w    0(a4),d0
                    add.w    6(a4),d1
                    lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    move.l   0(a6,d1.w),a3
                    add.w    d0,a3                  ; tile in a3
                    move.w   (a3),d0
                    and.w    #$3F,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    jsr      0(a5,d0.w)
                    move.w   #3,lbW007B4A
                    move.w   d6,d0
                    move.w   d7,d1
                    add.w    4(a4),d0
                    add.w    10(a4),d1
                    lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    move.l   0(a6,d1.w),a3
                    add.w    d0,a3
                    move.w   (a3),d0
                    and.w    #$3F,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    jsr      0(a5,d0.w)
                    move.w   #1,lbW007B48
                    move.w   d6,d0
                    move.w   d7,d1
                    add.w    2(a4),d0
                    add.w    8(a4),d1
                    lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    move.l   0(a6,d1.w),a3
                    add.w    d0,a3
                    move.w   (a3),d0
                    and.w    #$3F,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    jsr      0(a5,d0.w)
                    clr.w    lbW007B48
                    move.w   #1,lbW007B46
                    move.w   d6,d0
                    move.w   d7,d1
                    add.w    #10,d0
                    add.w    #6,d1
                    lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    move.l   0(a6,d1.w),a3
                    add.w    d0,a3
                    move.w   (a3),d0
                    and.w    #$3F,d0
                    movem.l  d0/a0,-(sp)
                    add.w    d0,d0
                    add.w    d0,d0
                    jsr      0(a5,d0.w)
                    movem.l  (sp)+,d0/a0
                    move.w   d0,$170(a0)
                    rts

tiles_action_table: bra.w    tile_not_used
                    bra.w    tile_wall
                    bra.w    tile_exit
                    bra.w    tile_door
                    bra.w    tile_key
                    bra.w    tile_first_aid                         ; 0x05
                    bra.w    tile_ammo
                    bra.w    tile_1up
                    bra.w    tile_not_used
                    bra.w    tile_not_used
                    bra.w    tile_facehuggers_hatch                 ; 0x0a
                    bra.w    tile_add_100_credits
                    bra.w    tile_add_1000_credits
                    bra.w    tile_not_used
                    bra.w    tile_one_way_up
                    bra.w    tile_one_way_right
                    bra.w    tile_one_way_down                      ; 0x10
                    bra.w    tile_one_way_left
                    bra.w    tile_not_used
                    bra.w    tile_not_used
                    bra.w    tile_deadly_hole
                    bra.w    tile_start_destruction                 ; 0x15
                    bra.w    tile_acid_pool
                    bra.w    tile_intex_terminal
                    bra.w    tile_not_used
                    bra.w    tile_not_used
                    bra.w    tile_not_used                          ; 0x1a
                    bra.w    lbC00853E
                    bra.w    tile_not_used
                    bra.w    tile_wall
                    bra.w    tile_not_used
                    bra.w    lbC007D98
                    bra.w    tile_hard_climb_down                   ; 0x20
                    bra.w    tile_hard_climb_up
                    bra.w    tile_not_used
                    bra.w    tile_hard_climb_right
                    bra.w    tile_not_used
                    bra.w    tile_not_used                          ; 0x25
                    bra.w    tile_one_deadly_way_right
                    bra.w    tile_climb_left
                    bra.w    tile_not_used
                    bra.w    tile_not_used
                    bra.w    tile_wall                              ; 0x2a (used for the 4 reactors)
                    bra.w    tile_wall
                    bra.w    tile_wall
                    bra.w    tile_wall
                    bra.w    tile_one_deadly_way_left
                    bra.w    tile_climb_right
                    bra.w    tile_unknown5                          ; 0x30
                    bra.w    tile_unknown6
                    bra.w    tile_unknown7
                    bra.w    tile_force_fields_sequence
                    bra.w    tile_not_used
                    bra.w    tile_not_used                          ; 0x35
                    bra.w    tile_not_used
                    bra.w    tile_climb_up
                    bra.w    tile_one_way_up_right
                    bra.w    tile_one_way_down_right
                    bra.w    tile_one_way_down_left                 ; 0x3a
                    bra.w    tile_one_way_up_left
                    bra.w    tile_not_used
                    bra.w    tile_boss_trigger
                    bra.w    tile_not_used
                    bra.w    tile_climb_down

tile_not_used:      rts

lbC007D98:          cmp.l    #$300,lbL000572
                    bne      void
                    tst.w    lbW007B46
                    beq      void
                    lea      lbL0209E2,a2
                    jmp      patch_tiles

tile_wall:          tst.w    pass_thru_walls
                    bne      void
                    tst.w    $148(a0)
                    bne      lbC007E02
                    clr.w    $134(a0)
                    cmp.w    #1,lbW007B48
                    beq.s    lbC007DF2
                    cmp.w    #1,lbW007B4A
                    beq.s    lbC007DF2
                    cmp.w    #3,lbW007B4A
                    beq.s    lbC007DFA
                    rts

lbC007DF2:          move.w   #1,$19C(a0)
                    rts

lbC007DFA:          move.w   #1,$19A(a0)
                    rts

lbC007E02:          clr.w    $138(a0)
                    cmp.w    #1,lbW007B48
                    beq.s    lbC007E26
                    cmp.w    #1,lbW007B4A
                    beq.s    lbC007E26
                    cmp.w    #3,lbW007B4A
                    beq.s    lbC007E2E
                    rts

lbC007E26:          move.w   #1,$196(a0)
                    rts

lbC007E2E:          move.w   #1,$198(a0)
                    rts

lbC007E36:          movem.w  d6/d7,-(sp)
                    move.w   PLAYER_OLD_POS_X(a0),d6
                    move.w   PLAYER_OLD_POS_Y(a0),d7
                    sub.w    PLAYER_POS_X(a0),d6
                    bpl.s    lbC007E4A
                    neg.w    d6
lbC007E4A:          cmp.w    #$20,d6
                    bpl.s    lbC007E62
                    sub.w    PLAYER_POS_Y(a0),d7
                    bpl.s    lbC007E58
                    neg.w    d7
lbC007E58:          cmp.w    #$20,d7
                    bpl.s    lbC007E62
                    bra      lbC007E70

lbC007E62:          move.w   #SAMPLE_ACID_POOL,sample_to_play
                    jsr      trigger_sample
lbC007E70:          movem.w  (sp)+,d6/d7
                    move.w   PLAYER_POS_X(a0),PLAYER_OLD_POS_X(a0)
                    move.w   PLAYER_POS_Y(a0),PLAYER_OLD_POS_Y(a0)
                    rts

exit_unlocked:      dc.w     0

tile_exit:          tst.w    lbW007B46
                    beq      void
                    move.w   #1,$174(a0)
                    tst.w    exit_unlocked
                    bne.s    lbC007EA6
                    tst.w    lbW00057A
                    beq      void
lbC007EA6:          cmp.l    #player_1_dats,a0
                    beq.s    lbC007EC4
                    cmp.w    #-1,player_1_alive
                    beq.s    lbC007EDA
                    cmp.w    #1,lbW005DC0
                    beq.s    lbC007EDA
                    rts

lbC007EC4:          cmp.w    #-1,player_2_alive
                    beq.s    lbC007EDA
                    cmp.w    #1,lbW006560
                    beq.s    lbC007EDA
                    rts

lbC007EDA:          move.w   #1,flag_end_level
                    rts

tile_door:          tst.w    lbW007B48
                    beq      void
                    tst.w    pass_thru_walls
                    bne.s    lbC007F38
                    tst.w    infinite_keys
                    bne.s    lbC007F38
                    tst.w    PLAYER_KEYS(a0)
                    bhi.s    lbC007F3E
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbL02312E,a6
                    move.w   #$3F,lbW02314E
                    move.w   #$41,lbW02313A
                    cmp.l    #player_1_dats,a0
                    beq      lbC007F30
                    move.w   #$42,lbW02313A
lbC007F30:          movem.l  (sp)+,d0-d7/a0-a6
                    bra      tile_wall

lbC007F38:          move.w   #0,PLAYER_KEYS(a0)
lbC007F3E:          movem.l  d6/d7/a4-a6,-(sp)
                    bsr.s    lbC007F62
                    tst.w    lbW007F60
                    beq.s    lbC007F5A
                    move.w   #23,sample_to_play
                    jsr      trigger_sample
lbC007F5A:          movem.l  (sp)+,d6/d7/a4-a6
                    rts

lbW007F60:          dc.w     0

lbC007F62:          clr.w    lbW007F60
                    move.l   lbL008040,a4
                    cmp.l    a4,a3
                    beq      void
                    sub.l    #$F8,a4
                    cmp.l    a4,a3
                    beq      void
                    add.l    #$1F0,a4
                    cmp.l    a4,a3
                    beq      void
                    sub.l    #$F8,a4
                    subq.l   #2,a4
                    cmp.l    a4,a3
                    beq      void
                    addq.l   #4,a4
                    cmp.l    a4,a3
                    beq      void
                    move.w   #1,lbW007F60
                    move.l   a3,lbL008040
                    addq.l   #1,doors_opened
                    subq.w   #1,PLAYER_KEYS(a0)
                    move.w   2(a3),d0
                    and.w    #$3F,d0
                    cmp.w    #3,d0
                    bne.s    lbC007FD8
                    move.l   #lbL020CFE,a2
                    and.w    #$FFC0,(a3)
                    jmp      patch_tiles

lbC007FD8:          move.w   -2(a3),d0
                    and.w    #$3F,d0
                    cmp.w    #3,d0
                    bne.s    lbC007FFC
                    move.l   #lbL020CFE,a2
                    sub.l    #2,a3
                    and.w    #$FFC0,(a3)
                    jmp      patch_tiles

lbC007FFC:          move.w   $F8(a3),d0
                    and.w    #$3F,d0
                    cmp.w    #3,d0
                    bne.s    lbC00801A
                    move.l   #lbL020D32,a2
                    and.w    #$FFC0,(a3)
                    jmp      patch_tiles

lbC00801A:          move.w   -$F8(a3),d0
                    and.w    #$3F,d0
                    cmp.w    #3,d0
                    bne      void
                    sub.l    #$F8,a3
                    move.l   #lbL020D32,a2
                    and.w    #$FFC0,(a3)
                    jmp      patch_tiles

lbL008040:          dc.l     0

tile_key:           movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC00D144
                    move.l   #lbL020EFE,a2
                    jsr      patch_tiles                      ; possibly changing the tile's gfx
                    tst.w    lbW00AD50
                    beq      lbC008078
                    and.w    #$FFC0,(a3)                    ; change the property of the tile to "floor"
                    move.w   #SAMPLE_KEY,sample_to_play
                    jsr      trigger_sample
                    addq.w   #1,PLAYER_KEYS(a0)
lbC008078:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

tile_first_aid:     movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC00D144
                    move.w   PLAYER_HEALTH(a0),d0
                    cmp.w    #64,d0
                    bpl      lbC0080A0
                    add.w    #20,d0
                    cmp.w    #$41,d0
                    bmi.s    lbC0080A0
                    move.w   #64,d0
lbC0080A0:          move.w   d0,PLAYER_HEALTH(a0)
                    move.l   #lbL020ED2,a2
                    jsr      patch_tiles
                    tst.w    lbW00AD50
                    beq      lbC0080CC
                    and.w    #$FFC0,(a3)
                    move.w   #SAMPLE_1STAID_CREDS,sample_to_play
                    jsr      trigger_sample
lbC0080CC:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

tile_ammo:          movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC00D144
                    move.w   #32,PLAYER_AMMUNITIONS(a0)
                    addq.w   #1,PLAYER_AMMOPACKS(a0)
                    cmp.w    #4,PLAYER_AMMOPACKS(a0)
                    bmi.s    lbC0080F2
                    move.w   #4,PLAYER_AMMOPACKS(a0)
lbC0080F2:          move.l   #lbL020F2A,a2
                    jsr      patch_tiles
                    tst.w    lbW00AD50
                    beq      lbC00811A
                    and.w    #$FFC0,(a3)
                    move.w   #SAMPLE_AMMO,sample_to_play
                    jsr      trigger_sample
lbC00811A:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

tile_1up:           movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC00D144
                    move.l   #lbL020EA6,a2
                    jsr      patch_tiles
                    tst.w    lbW00AD50
                    beq      lbC008154
                    and.w    #$FFC0,(a3)
                    addq.w   #1,PLAYER_LIVES(a0)
                    move.w   #SAMPLE_1UP,sample_to_play
                    jsr      trigger_sample
lbC008154:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

tile_add_100_credits:
                    movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC00D144
                    add.l    #5000,PLAYER_CREDITS(a0)
                    move.l   #lbL020F56,a2
                    jsr      patch_tiles
                    tst.w    lbW00AD50
                    beq      lbC008192
                    and.w    #$FFC0,(a3)
                    move.w   #SAMPLE_1STAID_CREDS,sample_to_play
                    jsr      trigger_sample
lbC008192:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

tile_add_1000_credits:
                    movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC00D144
                    add.l    #50000,PLAYER_CREDITS(a0)
                    move.l   #lbL020F82,a2
                    jsr      patch_tiles
                    tst.w    lbW00AD50
                    beq      lbC0081D0
                    and.w    #$FFC0,(a3)
                    move.w   #SAMPLE_1STAID_CREDS,sample_to_play
                    jsr      trigger_sample
lbC0081D0:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

tile_facehuggers_hatch:
                    tst.w    music_enabled
                    bne      void
                    tst.w    lbW007B46
                    beq      void
                    move.l   lbL000572,d0
                    cmp.w    #0,d0
                    beq      lbC0082C0
                    cmp.w    #$100,d0
                    beq      lbC0082CE
                    cmp.w    #$400,d0
                    beq      lbC008302
                    rts

lbC0082C0:          move.l   #lbW008F94,lbL00D226
                    bra      lbC0082D8

lbC0082CE:          move.l   #lbW009094,lbL00D226
lbC0082D8:          move.l   a0,-(sp)
                    lea      lbL00D29A,a0
                    jsr      lbC00D22A
                    move.l   (sp)+,a0
                    move.w   #36,sample_to_play
                    jsr      trigger_sample
                    lea      lbL0200F2,a2
                    jmp      patch_tiles

lbC008302:          move.l   #lbW009414,lbL00D226
                    move.l   a0,-(sp)
                    lea      lbL00D29A,a0
                    jsr      lbC00D22A
                    move.l   (sp)+,a0
                    move.w   #36,sample_to_play
                    jsr      trigger_sample
                    lea      lbL020BF6,a2
                    jmp      patch_tiles

tile_one_way_up:    tst.w    pass_thru_walls
                    bne      return
                    tst.w    lbW007B46
                    beq      void
                    move.w   #-2,PLAYER_EXTRA_SPD_Y(a0)
                    bsr      lbC008B5C
                    rts

tile_one_way_right: tst.w    pass_thru_walls
                    bne      return
                    tst.w    lbW007B46
                    beq      void
                    move.w   #2,PLAYER_EXTRA_SPD_X(a0)
                    bsr      lbC008B5C
                    rts

tile_hard_climb_right:
                    tst.w    $118(a0)
                    beq      tile_wall
                    move.w   #2,PLAYER_EXTRA_SPD_X(a0)
                    rts

tile_one_way_down:  tst.w    pass_thru_walls
                    bne      return
                    tst.w    lbW007B46
                    beq      void
                    move.w   #2,PLAYER_EXTRA_SPD_Y(a0)
                    bsr      lbC008B5C
                    rts

tile_one_way_left:  tst.w    pass_thru_walls
                    bne      return
                    tst.w    lbW007B46
                    beq      void
                    move.w   #-2,PLAYER_EXTRA_SPD_X(a0)
                    bsr      lbC008B5C
                    rts

tile_deadly_hole:   tst.w    $112(a0)
                    bne      void
                    tst.w    lbW007B46
                    beq      void
                    clr.w    PLAYER_HEALTH(a0)
                    rts

lbC0083DE:          move.w   #1,self_destruct_initiated
                    move.w   #1,lbW0004D8
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbL0201EE,a2
                    jsr      patch_tiles
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

tile_start_destruction:
                    cmp.b    #2,timer_digit_lo
                    beq      lbC0083DE
                    cmp.w    #4,boss_nbr
                    beq.s    lbC008424
                    tst.w    lbW0004EA
                    bne      void
lbC008424:          move.w   #1,lbW0004D8
                    move.w   #1,self_destruct_initiated
                    move.l   #$7D00,lbL01FDAA
                    and.w    #$FFC0,lbW062366
                    and.w    #$FFC0,lbW062368
                    and.w    #$FFC0,lbW062460
                    bra      tile_wall

tile_acid_pool:     tst.w    $112(a0)
                    bne      void
                    tst.w    lbW007B46
                    beq      void
                    cmp.w    #1,PLAYER_HEALTH(a0)
                    bmi      void
                    subq.w   #1,PLAYER_HEALTH(a0)
                    subq.w   #1,lbW0084C4
                    bpl      void
                    move.w   #$19,lbW0084C4
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #SAMPLE_ACID_POOL,sample_to_play
                    jsr      trigger_sample
                    movem.l  (sp)+,d0-d7/a0-a6
                    cmp.l    #$400,lbL000572
                    beq      void
                    move.l   #35,d0
                    move.l   #0,d2
                    jsr      trigger_sample_select_channel
                    rts

lbW0084C4:          dc.w     0

tile_intex_terminal:
                    cmp.b    #KEY_SPACE,key_pressed
                    beq      lbC00851E
                    btst     #7,player_2_input
                    bne      lbC00851E
                    btst     #7,player_1_input
                    bne      lbC00851E
                    cmp.b    #KEY_SPACE,key_pressed
                    bne      void
lbC00851E:          clr.w    lbW00853C
                    move.l   a0,player_using_intex
                    move.l   #run_intex,run_intex_ptr
                    clr.b    key_pressed
                    rts

lbW00853C:          dc.w     0

lbC00853E:          tst.w    lbW007B46
                    beq      void
                    tst.w    lbW0004E6
                    bne      void
                    tst.l    lbL000572
                    bne      void
                    move.w   #1,lbW0004E6
                    lea      lbW062296,a3
                    move.l   a3,-(sp)
                    bsr      lbC00AE2E
                    lea      lbL01ED32,a1
                    move.l   (sp)+,a3
                    addq.l   #2,a3
                    move.l   a3,-(sp)
                    bsr      lbC00AE2E
                    lea      lbL01F076,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    move.l   (sp)+,a3
                    addq.l   #2,a3
                    move.l   a3,-(sp)
                    bsr      lbC00AE2E
                    lea      lbL01F3C2,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    move.l   (sp)+,a3
                    addq.l   #2,a3
                    move.l   a3,-(sp)
                    bsr      lbC00AE2E
                    lea      lbL01F70E,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    move.l   (sp)+,a3
                    addq.l   #2,a3
                    move.l   a3,-(sp)
                    bsr      lbC00AE2E
                    lea      lbL01FA5A,a1
                    bsr      lbC00AF10
                    jsr      lbC00AED8
                    move.l   (sp)+,a3
                    addq.l   #2,a3
                    bsr      lbC00AE2E
                    lea      lbL01FDA6,a1
                    bsr      lbC00AF10
                    jmp      lbC00AED8

tile_one_deadly_way_right:
                    tst.w    lbW007B46
                    beq      lbC008614
                    move.w   #2,PLAYER_EXTRA_SPD_X(a0)
lbC008614:          tst.w    $148(a0)
                    bne      void
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW023156,a6
                    move.w   #5,d0
                    jsr      lbC02325A
                    movem.l  (sp)+,d0-d7/a0-a6
                    cmp.l    #lbW007B22,a4
                    beq      void
                    clr.w    PLAYER_HEALTH(a0)
                    rts

tile_one_deadly_way_left:
                    tst.w    lbW007B46
                    beq      lbC008654
                    move.w   #-2,PLAYER_EXTRA_SPD_X(a0)
lbC008654:          tst.w    $148(a0)
                    bne      void
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW023156,a6
                    move.w   #5,d0
                    jsr      lbC02325A
                    movem.l  (sp)+,d0-d7/a0-a6
                    cmp.l    #lbW007B16,a4
                    beq      void
                    clr.w    PLAYER_HEALTH(a0)
                    rts

tile_boss_trigger:  tst.w    lbW0004D8
                    bne      void
                    tst.w    lbW0004EA
                    bne      void
                    move.w   #1,select_speed_boss
                    movem.l  d0-d7/a0-a6,-(sp)
                    clr.w    lbW0004C4
                    lea      bosstune,a0
                    lea      bpsong,a1
                    move.w   #(14564/2)-1,d0
lbC0086BA:          move.w   (a0)+,(a1)+
                    dbra     d0,lbC0086BA
                    clr.w    bpchannel1_status
                    clr.w    bpchannel2_status
                    clr.w    bpchannel3_status
                    clr.w    bpchannel4_status
                    jsr      start_music
                    move.w   #61,sample_to_play
                    jsr      trigger_sample
                    cmp.w    #1,boss_nbr
                    beq      boss_nbr_1
                    cmp.w    #2,boss_nbr
                    beq      boss_nbr_2
                    cmp.w    #3,boss_nbr
                    beq      boss_nbr_3
                    cmp.w    #4,boss_nbr
                    beq      boss_nbr_4
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

boss_nbr:           dc.w     1

boss_nbr_4:         tst.w    lbW0004D8
                    bne      lbC00885C
                    tst.w    lbW0004EE
                    bne      lbC00885C
                    move.w   #1,lbW0004EE
                    bsr      lbC00D2BA
                    lea      lbW008C9C,a0
                    move.l   #lbW0256B4,$48(a0)
                    move.l   #lbW0256B4,$44(a0)
                    lea      lbW009014,a1
                    lea      lbW06188C,a3
                    jsr      patch_boss_door
                    lea      lbW008CF6,a0
                    move.l   #lbW0256D8,$48(a0)
                    move.l   #lbW0256B4,$44(a0)
                    lea      lbW009014,a1
                    lea      lbW061AFC,a3
                    jsr      patch_boss_door
                    lea      lbW008D50,a0
                    move.l   #lbW0256FC,$48(a0)
                    move.l   #lbW0256B4,$44(a0)
                    lea      lbW009014,a1
                    lea      lbW061D6C,a3
                    jsr      patch_boss_door
                    lea      lbW008DAA,a0
                    move.l   #lbW025720,$48(a0)
                    move.l   #lbW0256B4,$44(a0)
                    lea      lbW009014,a1
                    lea      lbW061FDC,a3
                    jsr      patch_boss_door
                    lea      lbW008E04,a0
                    move.l   #lbW025744,$48(a0)
                    move.l   #lbW0256B4,$44(a0)
                    lea      lbW009014,a1
                    lea      lbW06224C,a3
                    jsr      patch_boss_door
                    lea      lbW008E5E,a0
                    move.l   #lbW025768,$48(a0)
                    move.l   #lbW0256B4,$44(a0)
                    lea      lbW009014,a1
                    lea      lbW06258C,a3
                    jsr      patch_boss_door
                    lea      lbW008EB8,a0
                    move.l   #lbW02578C,$48(a0)
                    move.l   #lbW0256B4,$44(a0)
                    lea      lbW009014,a1
                    lea      lbW0627FC,a3
                    jsr      patch_boss_door
lbC00885C:          move.w   #1,lbW0004EA
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

boss_nbr_1:         tst.w    lbW0004D8
                    bne      lbC0088F0
                    lea      lbW008C9C,a0
                    cmp.l    #lbW009114,$1A(a0)
                    beq      lbC0088F0
                    bsr      lbC00D2BA
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbL020196,a2
                    lea      lbW062D52,a3
                    bsr      patch_tiles
                    movem.l  (sp)+,d0-d7/a0-a6
                    lea      lbW008C9C,a0
                    lea      lbW009114,a1
                    lea      lbW0619E8,a3
                    jsr      patch_boss_door
                    clr.w    lbW009C62
                    lea      lbW008CF6,a0
                    lea      lbW009154,a1
                    lea      lbW064204,a3
                    jsr      patch_boss_door
                    lea      lbW008D50,a0
                    lea      lbW009194,a1
                    lea      lbW064204,a3
                    jsr      patch_boss_door
lbC0088F0:          move.w   #1,lbW0004EA
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

boss_nbr_2:         tst.w    lbW0004D8
                    bne      lbC008974
                    lea      lbW008C9C,a0
                    cmp.l    #lbW009254,$1A(a0)
                    beq      lbC008974
                    bsr      lbC00D2BA
                    movem.l  d0-d7/a0-a6,-(sp)
                    
                    movem.l  (sp)+,d0-d7/a0-a6
                    lea      lbW008C9C,a0
                    lea      lbW009254,a1
                    lea      lbW05F7A8,a3
                    jsr      patch_boss_door
                    clr.w    lbW009C62
                    lea      lbW008CF6,a0
                    lea      lbW009294,a1
                    lea      lbW063DB8,a3
                    jsr      patch_boss_door
                    lea      lbW008D50,a0
                    lea      lbW0092D4,a1
                    lea      lbW063DB8,a3
                    jsr      patch_boss_door
lbC008974:          move.w   #1,lbW0004EA
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

boss_nbr_3:         tst.w    lbW0004D8
                    bne      lbC008AE0
                    lea      lbW008C9C,a0
                    cmp.l    #lbW009254,$1A(a0)
                    beq      lbC008AE0
                    bsr      lbC00D2BA
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW063CCE,a3
                    lea      lbL020B2E,a2
                    bsr      patch_tiles
                    lea      lbL063DC6,a3
                    lea      lbL020B2E,a2
                    bsr      patch_tiles
                    movem.l  (sp)+,d0-d7/a0-a6
                    lea      lbW008C9C,a0
                    lea      lbW009314,a1
                    lea      lbW062872,a3
                    jsr      patch_boss_door
                    clr.w    lbW009C62
                    lea      lbW008CF6,a0
                    lea      lbW009354,a1
                    lea      lbW062872,a3
                    jsr      patch_boss_door
                    lea      lbW008D50,a0
                    lea      lbW009394,a1
                    lea      lbW062872,a3
                    jsr      patch_boss_door
lbC008AE0:          move.w   #1,lbW0004EA
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

tile_climb_left:    tst.w    lbW007B46
                    beq      return
                    move.w   #1,PLAYER_EXTRA_SPD_X(a0)
                    rts

tile_climb_right:   tst.w    lbW007B46
                    beq      return
                    move.w   #-1,PLAYER_EXTRA_SPD_X(a0)
                    rts

tile_climb_up:      tst.w    lbW007B46
                    beq      return
                    move.w   #1,PLAYER_EXTRA_SPD_Y(a0)
                    rts

tile_climb_down:    tst.w    lbW007B46
                    beq      return
                    move.w   #-1,PLAYER_EXTRA_SPD_Y(a0)
                    rts

tile_one_way_up_right:
                    tst.w    pass_thru_walls
                    bne      return
                    tst.w    lbW007B46
                    beq      return
                    move.w   #2,PLAYER_EXTRA_SPD_X(a0)
                    move.w   #-2,PLAYER_EXTRA_SPD_Y(a0)
                    bsr      lbC008B5C
                    rts

lbC008B5C:          bra      lbC007E36

tile_one_way_down_right:
                    tst.w    pass_thru_walls
                    bne      return
                    tst.w    lbW007B46
                    beq      return
                    move.w   #2,PLAYER_EXTRA_SPD_X(a0)
                    move.w   #2,PLAYER_EXTRA_SPD_Y(a0)
                    bsr      lbC008B5C
                    rts

tile_one_way_down_left:
                    tst.w    pass_thru_walls
                    bne      return
                    tst.w    lbW007B46
                    beq      return
                    move.w   #-2,PLAYER_EXTRA_SPD_X(a0)
                    move.w   #2,PLAYER_EXTRA_SPD_Y(a0)
                    bsr      lbC008B5C
                    rts

tile_one_way_up_left:
                    tst.w    pass_thru_walls
                    bne      return
                    tst.w    lbW007B46
                    beq      return
                    move.w   #-2,PLAYER_EXTRA_SPD_X(a0)
                    move.w   #-2,PLAYER_EXTRA_SPD_Y(a0)
                    bsr      lbC008B5C
                    rts

tile_hard_climb_down:
                    tst.w    lbW007B46
                    beq      return
                    move.w   #-2,PLAYER_EXTRA_SPD_Y(a0)
                    rts

tile_hard_climb_up: tst.w    lbW007B46
                    beq      return
                    move.w   #2,PLAYER_EXTRA_SPD_Y(a0)
                    rts

tile_unknown5:      move.w   d0,-(sp)
                    move.w   2(a3),d0
                    and.w    #$3F,d0
                    cmp.w    #$30,d0
                    beq.s    lbC008C18
                    move.w   -2(a3),d0
                    and.w    #$3F,d0
                    cmp.w    #$30,d0
                    beq.s    lbC008C18
                    move.w   (sp)+,d0
                    bra.s    lbC008C56

lbC008C18:          move.w   (sp)+,d0
                    move.w   #1,lbW008C9A
                    bra      lbC008C8A

tile_unknown6:      move.w   d0,-(sp)
                    move.w   2(a3),d0
                    and.w    #$3F,d0
                    cmp.w    #$31,d0
                    beq.s    lbC008C48
                    move.w   -2(a3),d0
                    and.w    #$3F,d0
                    cmp.w    #$31,d0
                    beq.s    lbC008C48
                    move.w   (sp)+,d0
                    bra.s    lbC008C60

lbC008C48:          move.w   (sp)+,d0
                    move.w   #2,lbW008C9A
                    bra      lbC008C8A

lbC008C56:          move.w   #3,lbW008C9A
                    bra.s    lbC008C8A

lbC008C60:          move.w   #4,lbW008C9A
                    bra.s    lbC008C8A

tile_unknown7:      move.w   #5,lbW008C9A
                    bra.s    lbC008C8A

tile_force_fields_sequence:
                    move.w   #6,lbW008C9A

lbC008C8A:          movem.l  d0-d7/a0-a6,-(sp)
                    jsr      lbC022D1E
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbW008C9A:          dc.w     0

lbW008C9C:          dc.l     cur_alien1_dats
                    dc.w     $798,$64,$FFFF,1,0,0,8
                    dc.l     lbW012B44                  ; 18
                    dc.l     lbW012B40                  ; 22
                    dc.l     lbW008F14                  ; 26
                    dc.w     $104,$37A,0,0,0,0,0,0,0,1
lbL008CCE:          dcb.l    10,0                       ; 48

lbW008CF6:          dc.l     cur_alien2_dats
                    dc.w     $798,$84,$FFFF,2,0,0,8
                    dc.l     lbW012C60
                    dc.l     lbW012C5C
                    dc.l     lbW008F14
                    dc.w     $12C,$37A,0,0,0,0,0,0,0,0,0,0,0
lbL008D2E:          dcb.l    8,0
                    dc.w     0

lbW008D50:          dc.l     cur_alien3_dats
                    dc.w     $798,$A4,$FFFF,2,0,0,8
                    dc.l     lbW012D7C
                    dc.l     lbW012D78
                    dc.l     lbW008F14
                    dc.w     $B4,$320,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    8,0

lbW008DAA:          dc.l     cur_alien4_dats
                    dc.w     $798,$C4,$FFFF,1,0,0,8
                    dc.l     lbW012E98
                    dc.l     lbW012E94
                    dc.l     lbW008F14
                    dc.w     $DC,$320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    8,0

lbW008E04:          dc.l     cur_alien5_dats
                    dc.w     $798,$E4,$FFFF,1,0,0,8
                    dc.l     lbW012FB4
                    dc.l     lbW012FB0
                    dc.l     lbW008F14
                    dc.w     $104,$320,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    8,0

lbW008E5E:          dc.l     cur_alien6_dats
                    dc.w     $798,$104,$FFFF,1,0,0,8
                    dc.l     lbW0130D0
                    dc.l     lbW0130CC
                    dc.l     lbW008F14
                    dc.w     $12C,$320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    8,0

lbW008EB8:          dc.l     cur_alien7_dats
                    dc.w     $798,$124,$FFFF,1,0,0,8
                    dc.l     lbW0131EC
                    dc.l     lbW0131E8
                    dc.l     lbW008F14
                    dc.w     $154,$320,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    8,0
                    dc.w     $FFFF

lbW008F14:          dc.l     lbC00987E
                    dcb.w    2,0
                    dcb.w    2,$20
                    dc.l     lbL0094FC
                    dc.l     lbW00A2CA
                    dc.l     lbW00A2D6
                    dc.l     lbW00A2E2
                    dc.l     lbW00A2EE
                    dc.w     2,10,1,0,5,$14,0,0,12,4,0,0,10,$13,9,$13
lbW008F54:          dc.l     lbC00987E
                    dc.w     10,10,$14,$14
                    dc.l     lbL009494
                    dc.l     lbW00A2CA
                    dc.l     lbW00A2D6
                    dc.l     lbW00A2E2
                    dc.l     lbW00A2EE
                    dc.w     3,$14,4,0,5,$14,0,0,12,4,0,0,10,$14,9,$13
lbW008F94:          dc.l     lbC00987E
                    dc.w     10,10,$14,$14
                    dc.l     lbL009494
                    dc.l     lbW00A2CA
                    dc.l     lbW00A2D6
                    dc.l     lbW00A2E2
                    dc.l     lbW00A2EE
                    dc.w     2,$14,4,0,5,$14,$14,$14,4,$10
                    dc.l     lbL01B6F6
                    dc.w     10,$14,9,$13
lbW008FD4:          dc.l     lbC00987E
                    dc.w     4,4,8,8
                    dc.l     lbL0094FC
                    dc.l     lbW00A29A
                    dc.l     lbW00A2A6
                    dc.l     lbW00A2B2
                    dc.l     lbW00A2BE
                    dc.w     2,5,3,0,5,$14,0,0,12,4,0,0,10,$13,9,$13
lbW009014:          dc.l     lbC009AFC
                    dc.w     0,4,12,8
                    dc.l     lbL009564
                    dc.w     0,0,0,0,0,0,0,0,0,$40,$18,1,$28,$14,0,0,12,4,0,0
                    dc.w     10,9,9,9

lbW009054:          dc.l     lbC00987E
                    dc.w     10,10,$14,$14
                    dc.l     lbL009634
                    dc.l     lbW00A2CA
                    dc.l     lbW00A2D6
                    dc.l     lbW00A2E2
                    dc.l     lbW00A2EE
                    dc.w     2,$1E,7,0,5,$14,0,0,12,4,0,0,10,$14,9,$13
lbW009094:          dc.l     lbC00987E
                    dc.w     10,10,$14,$14
                    dc.l     lbL009634
                    dc.l     lbW00A2CA
                    dc.l     lbW00A2D6
                    dc.l     lbW00A2E2
                    dc.l     lbW00A2EE
                    dc.w     2,$1E,7,0,5,$14,$14,$14,$FFF8,6
                    dc.l     lbL01BC0A
                    dc.w     10,$14,9,$13
lbW0090D4:          dc.l     lbC00987E
                    dc.w     4,4,8,8
                    dc.l     lbL00969C
                    dc.l     lbW00A29A
                    dc.l     lbW00A2A6
                    dc.l     lbW00A2B2
                    dc.l     lbW00A2BE
                    dc.w     3,8,3,0,5,$14,0,0,12,4,0,0,10,$15,9,$13
lbW009114:          dc.l     lbC009CE2
                    dc.w     $26,$60,12,$18
                    dc.l     lbL0095CC
                    dc.l     lbW00A2FA
                    dc.l     lbW00A306
                    dc.l     lbW00A312
                    dc.l     lbW00A31E
                    dc.w     4,$100,2,1,5,$28,$32,$10,12,4
                    dc.l     lbW013890
                    dc.w     10,11,9,$13
lbW009154:          dc.l     lbC009C68
                    dc.w     $24,0,$10,$18,0,0,0,0,0,0,0,0,0,0,4,$100,10,1,5
                    dc.w     $28,$32,$10,12,4
                    dc.l     lbW013890
                    dc.w     10,11,9,$13
lbW009194:          dc.l     lbC009C68
                    dc.w     8,$24,$40,$33,0,0,0,0,0,0,0,0,0,0,4,$100,10,1,5
                    dc.w     $28,$32,$10,12,4
                    dc.l     lbW013890
                    dc.w     10,11,9,$13
lbW0091D4:          dc.l     lbC00987E
                    dc.w     10,10,$14,$14
                    dc.l     lbL009704
                    dc.l     lbW00A2CA
                    dc.l     lbW00A2D6
                    dc.l     lbW00A2E2
                    dc.l     lbW00A2EE
                    dc.w     2,$23,8,0,5,$14,0,0,12,4,0,0,10,$14,9,$13
                    dc.l     lbC00987E
                    dc.w     10,10,$14,$14
                    dc.l     lbL00976C
                    dc.l     lbW00A2CA
                    dc.l     lbW00A2D6
                    dc.l     lbW00A2E2
                    dc.l     lbW00A2EE
                    dc.w     2,$14,5,0,5,$14,0,0,12,4,0,0,10,$14,9,$13
lbW009254:          dc.l     lbC009CE2
                    dc.w     $26,$60,12,$18
                    dc.l     lbL0095CC
                    dc.l     lbW00A2FA
                    dc.l     lbW00A306
                    dc.l     lbW00A312
                    dc.l     lbW00A31E
                    dc.w     4,$100,2,1,5,$FFF6,$32,10,12,4
                    dc.l     lbW013890
                    dc.w     10,$13,9,$13
lbW009294:          dc.l     lbC009C68
                    dc.w     $24,0,$10,$18,0,0,0,0,0,0,0,0,0,0,4,$200,10,1,5
                    dc.w     $FFF6,$32,10,12,4
                    dc.l     lbW013890
                    dc.w     10,11,9,$13
lbW0092D4:          dc.l     lbC009C68
                    dc.w     8,$24,$40,$33,0,0,0,0,0,0,0,0,0,0,4,$100,10,1,5
                    dc.w     $FFF6,$32,10,12,4
                    dc.l     lbW013890
                    dc.w     10,11,9,$13
lbW009314:          dc.l     lbC009CE2
                    dc.w     $26,$60,12,$18
                    dc.l     lbL0095CC
                    dc.l     lbW00A2FA
                    dc.l     lbW00A306
                    dc.l     lbW00A312
                    dc.l     lbW00A31E
                    dc.w     4,$140,2,1,5,10,$32,10,12,4
                    dc.l     lbW013890
                    dc.w     10,11,9,$13
lbW009354:          dc.l     lbC009C68
                    dc.w     $24,0,$10,$18,0,0,0,0,0,0,0,0,0,0,5,$140,3,1,5
                    dc.w     $FFF6,$32,10,12,4
                    dc.l     lbW013890
                    dc.w     10,11,9,$13
lbW009394:          dc.l     lbC009C68
                    dc.w     8,$24,$40,$33,0,0,0,0,0,0,0,0,0,0,5,$140,3,1,5
                    dc.w     $FFF6,$32,10,12,4
                    dc.l     lbW013890
                    dc.w     10,11,9,$13
                    dc.l     lbC00987E
                    dc.w     10,10,$14,$14
                    dc.l     lbL009494
                    dc.l     lbW00A2CA
                    dc.l     lbW00A2D6
                    dc.l     lbW00A2E2
                    dc.l     lbW00A2EE
                    dc.w     2,$23,9,0,5,$14,0,0,12,4,0,0,10,$14,9,$13
lbW009414:          dc.l     lbC00987E
                    dc.w     4,4,8,8
                    dc.l     lbL00969C
                    dc.l     lbW00A29A
                    dc.l     lbW00A2A6
                    dc.l     lbW00A2B2
                    dc.l     lbW00A2BE
                    dc.w     4,8,5,0,5,$14,$14,0,0,8
                    dc.l     lbL01BC0A
                    dc.w     10,$15,9,$13
                    dc.l     lbC00987E
                    dc.w     4,4,8,8
                    dc.l     lbL0094FC
                    dc.l     lbW00A29A
                    dc.l     lbW00A2A6
                    dc.l     lbW00A2B2
                    dc.l     lbW00A2BE
                    dc.w     2,15,5,0,5,$14,0,0,12,4,0,0,10,$15,9,$13
lbL009494:          dc.l     lbL01B036
                    dc.l     lbL01B036
                    dc.l     lbL01B05A
                    dc.l     lbL01B07E
                    dc.l     lbL01B0A2
                    dc.l     lbL01B0C6
                    dc.l     lbL01B0EA
                    dc.l     lbL01B10E
                    dc.l     lbL01B132
                    dc.l     lbL01B156
                    dc.l     lbL01B172
                    dc.l     lbL01B18E
                    dc.l     lbL01B1AA
                    dc.l     lbL01B1C6
                    dc.l     lbL01B1E2
                    dc.l     lbL01B1FE
                    dc.l     lbL01B21A
                    dc.l     lbL01B236
                    dc.l     lbL01B242
                    dc.l     lbL01B24E
                    dc.l     lbL01B25A
                    dc.l     lbL01B266
                    dc.l     lbL01B272
                    dc.l     lbL01B27E
                    dc.l     lbL01B28A
                    dc.l     lbL018C2E
lbL0094FC:          dc.l     lbL01B296
                    dc.l     lbL01B296
                    dc.l     lbL01B2BA
                    dc.l     lbL01B2DE
                    dc.l     lbL01B302
                    dc.l     lbL01B326
                    dc.l     lbL01B34A
                    dc.l     lbL01B36E
                    dc.l     lbL01B392
                    dc.l     lbL01B3B6
                    dc.l     lbL01B3D2
                    dc.l     lbL01B3EE
                    dc.l     lbL01B40A
                    dc.l     lbL01B426
                    dc.l     lbL01B442
                    dc.l     lbL01B45E
                    dc.l     lbL01B47A
                    dc.l     lbL01B496
                    dc.l     lbL01B4A2
                    dc.l     lbL01B4AE
                    dc.l     lbL01B4BA
                    dc.l     lbL01B4C6
                    dc.l     lbL01B4D2
                    dc.l     lbL01B4DE
                    dc.l     lbL01B4EA
                    dc.l     lbL018CBA
lbL009564:          dc.l     0
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
                    dc.l     lbL018C2E
lbL0095CC:          dc.l     lbL01BBE2
                    dc.l     lbL01BBE2
                    dc.l     lbL01BBE2
                    dc.l     lbL01BBE2
                    dc.l     lbL01BBE2
                    dc.l     lbL01BBE2
                    dc.l     lbL01BBE2
                    dc.l     lbL01BBE2
                    dc.l     lbL01BBE2
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL01BBFE
                    dc.l     lbL018C2E
lbL009634:          dc.l     lbL01B722
                    dc.l     lbL01B722
                    dc.l     lbL01B746
                    dc.l     lbL01B76A
                    dc.l     lbL01B78E
                    dc.l     lbL01B7B2
                    dc.l     lbL01B7D6
                    dc.l     lbL01B7FA
                    dc.l     lbL01B81E
                    dc.l     lbL01B842
                    dc.l     lbL01B85E
                    dc.l     lbL01B87A
                    dc.l     lbL01B896
                    dc.l     lbL01B8B2
                    dc.l     lbL01B8CE
                    dc.l     lbL01B8EA
                    dc.l     lbL01B906
                    dc.l     lbL01B922
                    dc.l     lbL01B92E
                    dc.l     lbL01B93A
                    dc.l     lbL01B946
                    dc.l     lbL01B952
                    dc.l     lbL01B95E
                    dc.l     lbL01B96A
                    dc.l     lbL01B976
                    dc.l     lbL018C2E
lbL00969C:          dc.l     lbL01B982
                    dc.l     lbL01B982
                    dc.l     lbL01B9A6
                    dc.l     lbL01B9CA
                    dc.l     lbL01B9EE
                    dc.l     lbL01BA12
                    dc.l     lbL01BA36
                    dc.l     lbL01BA5A
                    dc.l     lbL01BA7E
                    dc.l     lbL01BAA2
                    dc.l     lbL01BABE
                    dc.l     lbL01BADA
                    dc.l     lbL01BAF6
                    dc.l     lbL01BB12
                    dc.l     lbL01BB2E
                    dc.l     lbL01BB4A
                    dc.l     lbL01BB66
                    dc.l     lbL01BB82
                    dc.l     lbL01BB8E
                    dc.l     lbL01BB9A
                    dc.l     lbL01BBA6
                    dc.l     lbL01BBB2
                    dc.l     lbL01BBBE
                    dc.l     lbL01BBCA
                    dc.l     lbL01BBD6
                    dc.l     lbL018CBA
lbL009704:          dc.l     lbL01BC36
                    dc.l     lbL01BC36
                    dc.l     lbL01BC5A
                    dc.l     lbL01BC7E
                    dc.l     lbL01BCA2
                    dc.l     lbL01BCC6
                    dc.l     lbL01BCEA
                    dc.l     lbL01BD0E
                    dc.l     lbL01BD32
                    dc.l     lbL01BD56
                    dc.l     lbL01BD72
                    dc.l     lbL01BD8E
                    dc.l     lbL01BDAA
                    dc.l     lbL01BDC6
                    dc.l     lbL01BDE2
                    dc.l     lbL01BDFE
                    dc.l     lbL01BE1A
                    dc.l     lbL01BE36
                    dc.l     lbL01BE42
                    dc.l     lbL01BE4E
                    dc.l     lbL01BE5A
                    dc.l     lbL01BE66
                    dc.l     lbL01BE72
                    dc.l     lbL01BE7E
                    dc.l     lbL01BE8A
                    dc.l     lbL018C2E
lbL00976C:          dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BEA2
                    dc.l     lbL01BEA2
                    dc.l     lbL01BEA2
                    dc.l     lbL01BEA2
                    dc.l     lbL01BEA2
                    dc.l     lbL01BEA2
                    dc.l     lbL01BEA2
                    dc.l     lbL01BEA2
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL01BE96
                    dc.l     lbL018C2E

lbC0097D4:          move.l   #700,d0
                    jsr      rand
                    move.w   d0,lbW0097E8
                    rts

lbW0097E8:          dc.w     0
lbL0097EA:          dcb.w    4,0

lbW0097F2:          dc.w     20
lbW0097F4:          dc.w     0

lbC0097F6:          subq.w   #1,lbW0097F4
                    bpl      lbC00984A
                    move.w   lbW0097F2,lbW0097F4
                    move.w   player_1_pos_x,d0
                    move.w   player_1_pos_y,d1
                    tst.w    player_1_alive
                    bpl.s    lbC009826
                    move.w   #$BA8,d0
                    move.w   #$BA8,d1
lbC009826:          move.w   player_2_pos_x,d2
                    move.w   player_2_pos_y,d3
                    tst.w    player_2_alive
                    bpl.s    lbC009842
                    move.w   #$BA8,d2
                    move.w   #$BA8,d3
lbC009842:          lea      lbW0097F2(pc),a6
                    movem.w  d0-d3,-(a6)
lbC00984A:          lea      lbW008C9C(pc),a0
                    bsr.s    lbC009872
                    lea      lbW008CF6(pc),a0
                    bsr.s    lbC009872
                    lea      lbW008D50(pc),a0
                    bsr.s    lbC009872
                    lea      lbW008DAA(pc),a0
                    bsr.s    lbC009872
                    lea      lbW008E04(pc),a0
                    bsr.s    lbC009872
                    lea      lbW008E5E(pc),a0
                    bsr.s    lbC009872
                    lea      lbW008EB8(pc),a0
lbC009872:          move.l   $40(a0),a6
                    jmp      (a6)

lbC00987C:          rts

lbC00987E:          tst.w    8(a0)
                    bmi      return
                    move.l   $1A(a0),a1
                    move.l   0(a0),a2
                    clr.l    $22(a0)
                    clr.l    $26(a0)
                    tst.w    $38(a0)
                    bne      lbC00A5CC
                    tst.w    $34(a0)
                    bne      lbC00A582
                    tst.w    $4C(a0)
                    bne      lbC00A568
                    jsr      check_aliens_collisions

                    move.w   ALIEN_POS_X(a0),d4
                    move.w   ALIEN_POS_Y(a0),d5
                    move.w   d4,d6
                    move.w   d5,d7
                    movem.w  d6/d7,-(sp)
                    
                    ; go into the direction of the nearest player
                    lea      lbL0097EA(pc),a6
                    movem.w  (a6)+,d0-d3
                    sub.w    d0,d4
                    bpl.s    lbC0098D2
                    neg.w    d4
lbC0098D2:          sub.w    d1,d5
                    bpl.s    lbC0098D8
                    neg.w    d5
lbC0098D8:          sub.w    d2,d6
                    bpl.s    lbC0098DE
                    neg.w    d6
lbC0098DE:          sub.w    d3,d7
                    bpl.s    lbC0098E4
                    neg.w    d7
lbC0098E4:          add.w    d5,d4
                    add.w    d7,d6
                    cmp.w    d4,d6
                    bmi.s    lbC0098F2
                    move.w   d0,d4
                    move.w   d1,d5
                    bra.s    lbC0098F6

lbC0098F2:          move.w   d2,d4
                    move.w   d3,d5

lbC0098F6:          add.w    #8,d4
                    add.w    #8,d5
                    movem.w  (sp)+,d6/d7
                    clr.w    d0
                    move.w   12(a0),d1
                    tst.w    $4E(a0)
                    beq.s    lbC009912
                    subq.w   #1,$4E(a0)
lbC009912:          tst.w    $4E(a0)
                    beq.s    lbC00991C
                    subq.w   #1,$4E(a0)
lbC00991C:          sub.w    d6,d4
                    bmi      lbC00994E
                    tst.w    d4
                    bpl.w    lbC009928
                    neg.w    d4
lbC009928:          tst.w    $4E(a0)
                    bne      lbC009956
                    cmp.w    #4,d4
                    bmi      lbC009966
lbC009938:          move.w   #1,$2A(a0)
                    tst.w    d1
                    beq      lbC009966
                    add.w    d1,d6
                    move.w   #4,d0
                    bra      lbC009966

lbC00994E:          tst.w    $4E(a0)
                    bne      lbC009938
lbC009956:          move.w   #$100,$2A(a0)
                    tst.w    d1
                    beq.s    lbC009966
                    sub.w    d1,d6
                    move.w   #8,d0
lbC009966:          jsr      lbC00A96C
                    move.w   14(a0),d1
                    sub.w    d7,d5
                    bmi.s    lbC00999A
                    tst.w    d5
                    bpl.s    lbC00997A
                    neg.w    d5
lbC00997A:          tst.w    $50(a0)
                    bne      lbC0099A2
                    cmp.w    #4,d5
                    bmi.s    lbC0099B4
lbC009988:          move.w   #$10,$2C(a0)
                    tst.w    d1
                    beq.s    lbC0099B4
                    add.w    d1,d7
                    or.w     #1,d0
                    bra.s    lbC0099B4

lbC00999A:          tst.w    $50(a0)
                    bne      lbC009988
lbC0099A2:          move.w   #$100,$2C(a0)
                    tst.w    d1
                    beq      lbC0099B4
                    sub.w    d1,d7
                    or.w     #2,d0
lbC0099B4:          jsr      lbC00A9D6
                    not.w    $30(a0)
                    beq      lbC009A98
                    add.w    d0,d0
                    beq.s    lbC009A16
                    move.l   12(a1),a5
                    lea      lbB00A228(pc),a6
                    move.w   0(a6,d0.w),d0
                    tst.w    $3E(a0)
                    beq.s    lbC0099E8
                    clr.w    $3E(a0)
                    move.w   d0,$10(a0)
                    add.w    d0,d0
                    add.w    d0,d0
                    bra      lbC009A74

lbC0099E8:          move.w   d6,d1
                    swap     d1
                    move.w   d7,d1
                    cmp.l    $1E(a0),d1
                    bne.s    lbC0099FA
                    add.l    #$40,a5
lbC0099FA:          move.w   $10(a0),d1
                    lea      lbB00A24F(pc),a6
                    lsl.w    #3,d0
                    add.w    d1,d0
                    move.b   0(a6,d0.w),d0
                    move.w   d0,$10(a0)
                    add.w    d0,d0
                    add.w    d0,d0
                    bra      lbC009A74

lbC009A16:          addq.w   #1,$58(a0)
                    cmp.w    #$19,$58(a0)
                    bmi.s    lbC009A60
                    clr.w    $58(a0)
                    cmp.w    #0,$52(a0)
                    beq      lbC009A4A
                    tst.w    $4E(a0)
                    beq      lbC009A40
                    clr.w    $4E(a0)
                    bra      lbC009A60

lbC009A40:          move.w   #$32,$4E(a0)
                    bra      lbC009A60

lbC009A4A:          tst.w    $50(a0)
                    beq      lbC009A5A
                    clr.w    $50(a0)
                    bra      lbC009A60

lbC009A5A:          move.w   #$32,$50(a0)
lbC009A60:          move.l   12(a1),a5
                    add.w    #$40,a5
                    move.w   $10(a0),d0
                    add.w    d0,d0
                    add.w    d0,d0
                    bra      lbC009A74

lbC009A74:          tst.w    $32(a0)
                    beq.s    lbC009A86
                    clr.w    $32(a0)
                    move.l   12(a1),a5
                    add.w    #$20,a5
lbC009A86:          move.l   0(a5,d0.w),a6
                    move.l   $12(a0),a5
                    cmp.l    8(a5),a6
                    beq.s    lbC009A98
                    move.l   a6,$28(a5)
lbC009A98:          swap     d6
                    move.w   d7,d6
                    move.l   d6,$1E(a0)
                    move.l   $16(a0),a6
                    move.l   d6,(a6)
                    add.l    4(a1),d6
                    move.l   d6,(a2)
                    add.l    8(a1),d6
                    move.l   d6,4(a2)
                    tst.l    $22(a0)
                    beq.s    lbC009AFA
                    move.l   $26(a0),a6
                    cmp.l    #0,a6
                    beq.s    lbC009AFA
                    move.w   10(a6),d0
                    tst.w    10(a6)
                    beq.s    lbC009AE4
                    move.w   10(a0),10(a6)
                    cmp.w    #3,10(a6)
                    bmi.s    lbC009AE4
                    move.w   #3,10(a6)
lbC009AE4:          tst.w    10(a0)
                    beq.s    lbC009AFA
                    cmp.w    #3,10(a0)
                    bmi.s    lbC009AFA
                    move.w   #3,d0
                    move.w   d0,10(a0)
lbC009AFA:          rts

lbC009AFC:          tst.w    8(a0)
                    bmi      return
                    move.l   $1A(a0),a1
                    move.l   0(a0),a2
                    move.l   $48(a0),a6
                    tst.w    (a6)
                    bpl.s    lbC009B1C
                    move.l   $44(a0),a6
                    move.l   a6,$48(a0)
lbC009B1C:          addq.l   #4,$48(a0)
                    move.w   (a6),ALIEN_POS_X(a0)
                    move.w   2(a6),ALIEN_POS_Y(a0)
                    move.w   (a6),d0
                    move.w   2(a6),d1
                    move.w   #$4B,d2
                    move.w   #$4B,d3
                    bsr      lbC009BC4
                    lsl.w    #4,d1
                    lea      lbL01B4F6,a6
                    add.w    d1,a6
                    tst.w    $34(a0)
                    beq.s    lbC009B66
                    move.w   #1,$10(a0)
                    jsr      lbC00A582
                    cmp.w    #$FFFF,8(a0)
                    beq      return
                    bra      lbC009B98

lbC009B66:          tst.w    $38(a0)
                    beq.s    lbC009B80
                    jsr      lbC00A5CC
                    cmp.w    #$FFFF,8(a0)
                    beq      return
                    bra      lbC009B98

lbC009B80:          tst.w    $32(a0)
                    beq.s    lbC009B90
                    add.l    #$100,a6
                    clr.w    $32(a0)
lbC009B90:          move.l   $12(a0),a5
                    move.l   a6,$28(a5)
lbC009B98:          add.w    #$67E,ALIEN_POS_X(a0)
                    add.w    #$2DB,ALIEN_POS_Y(a0)
                    move.l   $16(a0),a6
                    move.w   ALIEN_POS_X(a0),d6
                    swap     d6
                    move.w   ALIEN_POS_Y(a0),d6
                    move.l   d6,(a6)
                    add.l    4(a1),d6
                    move.l   d6,(a2)
                    add.l    8(a1),d6
                    move.l   d6,4(a2)
                    rts

lbC009BC4:          move.w   #$F0,d4
                    move.w   d4,d5
                    sub.w    d1,d4
                    sub.w    d3,d5
                    exg      d3,d5
                    exg      d1,d4
                    sub.w    d1,d3
                    sub.w    d0,d2
                    beq.s    lbC009BFC
                    tst.w    d3
                    bpl.s    lbC009BEE
                    tst.w    d2
                    bpl.s    lbC009BE8
                    moveq    #3,d0
                    neg.w    d3
                    neg.w    d2
                    bra.s    lbC009C06

lbC009BE8:          moveq    #4,d0
                    neg.w    d3
                    bra.s    lbC009C06

lbC009BEE:          tst.w    d2
                    bpl.s    lbC009BF8
                    moveq    #2,d0
                    neg.w    d2
                    bra.s    lbC009C06

lbC009BF8:          moveq    #1,d0
                    bra.s    lbC009C06

lbC009BFC:          moveq    #0,d1
                    tst.w    d3
                    bpl.s    lbC009C04
                    addq.b   #8,d1
lbC009C04:          rts

lbC009C06:          mulu     #$C0,d3
                    divu     d2,d3
                    moveq    #0,d1
                    cmp.w    #$3C5,d3
                    bge.s    lbC009C2E
                    addq.l   #1,d1
                    cmp.w    #$11F,d3
                    bge.s    lbC009C2E
                    addq.l   #1,d1
                    cmp.w    #$80,d3
                    bge.s    lbC009C2E
                    addq.l   #1,d1
                    cmp.w    #$26,d3
                    bge.s    lbC009C2E
                    addq.l   #1,d1
lbC009C2E:          tst.b    d0
                    bne.s    lbC009C34
                    rts

lbC009C34:          cmp.b    #1,d0
                    beq.s    lbC009C60
                    cmp.b    #2,d0
                    beq.s    lbC009C52
                    cmp.b    #3,d0
                    beq.s    lbC009C4E
                    moveq    #8,d0
                    sub.b    d1,d0
                    exg      d0,d1
                    rts

lbC009C4E:          addq.b   #8,d1
                    rts

lbC009C52:          tst.w    d1
                    bne.s    lbC009C58
                    rts

lbC009C58:          move.b   #$10,d0
                    sub.b    d1,d0
                    exg      d1,d0
lbC009C60:          rts

lbW009C62:          dc.w     0
lbL009C64:          dc.l     0

lbC009C68:          tst.w    8(a0)
                    bmi      return
                    tst.w    $32(a0)
                    beq      lbC009C84
                    move.w   #1,lbL008CCE
                    clr.w    $32(a0)
lbC009C84:          tst.w    $34(a0)
                    beq.s    lbC009C9E
                    clr.w    $34(a0)
                    move.w   #1,lbL009C64
                    move.w   #10,lbW009C62
lbC009C9E:          move.l   $1A(a0),a1
                    move.l   0(a0),a2
                    clr.l    $22(a0)
                    clr.l    $26(a0)
                    lea      lbW008C9C,a6
                    move.w   ALIEN_POS_X(a6),d6
                    move.w   ALIEN_POS_Y(a6),d7
                    swap     d6
                    move.w   d7,d6
                    move.l   d6,ALIEN_POS_X(a0)
                    add.l    4(a1),d6
                    move.l   d6,(a2)
                    add.l    8(a1),d6
                    move.l   d6,4(a2)
                    move.l   $16(a0),a6
                    move.l   #$CCC0CCC,(a6)
                    rts

lbW009CDE:          dc.w     0
lbW009CE0:          dc.w     0

lbC009CE2:          tst.w    lbL008D2E
                    beq      lbC009CF2
                    move.w   #1,$38(a0)
lbC009CF2:          tst.w    $38(a0)
                    beq.s    lbC009D0A
                    cmp.w    #1,boss_nbr                        ; trigger self destruct
                    bne.s    lbC009D0A                          ; after having killed boss #1
                    move.w   #1,self_destruct_initiated
lbC009D0A:          tst.w    8(a0)
                    bmi      return
                    move.l   $1A(a0),a1
                    move.l   0(a0),a2
                    clr.l    $22(a0)
                    clr.l    $26(a0)
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #300,d0
                    jsr      rand
                    tst.w    lbW009C62
                    bne.s    lbC009D50
                    cmp.w    #2,d0
                    bpl.s    lbC009D50
                    move.w   #1,lbL009C64
                    move.w   #40,lbW009C62
lbC009D50:          cmp.w    #6,d0
                    bpl.s    lbC009D6C
                    move.w   #0,lbW009CE0
                    cmp.w    #3,d0
                    bmi.s    lbC009D6C
                    move.w   #1,lbW009CE0
lbC009D6C:          movem.l  (sp)+,d0-d7/a0-a6
                    tst.w    lbW009C62
                    beq.s    lbC009D80
                    subq.w   #1,lbW009C62
                    bra.s    lbC009DA0

lbC009D80:          clr.w    lbL009C64
                    tst.w    lbW005D64
                    bne.s    lbC009D98
                    tst.w    lbW006504
                    bne.s    lbC009D98
                    bra.s    lbC009DA0

lbC009D98:          move.w   #1,lbL009C64
lbC009DA0:          cmp.l    #$400,lbL000572
                    bne.s    lbC009DCE
                    move.l   cur_palette_ptr,a5
                    move.w   32(a5),lbW099FBA
                    tst.w    50(a0)
                    beq.s    lbC009E1A
                    clr.w    50(a0)
                    move.w   #$FFF,lbW099FBA
                    bra.s    lbC009DEE

lbC009DCE:          move.l   cur_palette_ptr,a5
                    move.w   2(a5),lbW09A212
                    tst.w    50(a0)
                    beq.s    lbC009E1A
                    clr.w    50(a0)
                    move.w   #$FFF,lbW09A212
lbC009DEE:          addq.w   #1,lbW009CDE
                    cmp.w    #6,lbW009CDE
                    bne.s    lbC009E1A
                    clr.w    lbW009CDE
                    move.w   #55,d0
                    add.w    lbW009CE0,d0
                    move.w   d0,sample_to_play
                    jsr      trigger_sample

                    ; the following code only applies to the bosses
lbC009E1A:          tst.w    $38(a0)
                    bne      lbC009F62
                    jsr      check_aliens_collisions
                    move.w   ALIEN_POS_X(a0),d4
                    move.w   ALIEN_POS_Y(a0),d5
                    move.w   d4,d6
                    move.w   d5,d7
                    movem.w  d6/d7,-(sp)

                    lea      lbL0097EA(pc),a6
                    movem.w  (a6)+,d0-d3
                    sub.w    d0,d4
                    bpl.s    lbC009E46
                    neg.w    d4
lbC009E46:          sub.w    d1,d5
                    bpl.s    lbC009E4C
                    neg.w    d5
lbC009E4C:          sub.w    d2,d6
                    bpl.s    lbC009E52
                    neg.w    d6
lbC009E52:          sub.w    d3,d7
                    bpl.s    lbC009E58
                    neg.w    d7
lbC009E58:          add.w    d5,d4
                    add.w    d7,d6
                    cmp.w    d4,d6
                    bmi.s    lbC009E66
                    move.w   d0,d4
                    move.w   d1,d5
                    bra.s    lbC009E6A

lbC009E66:          move.w   d2,d4
                    move.w   d3,d5
lbC009E6A:          movem.w  (sp)+,d6/d7
                    sub.w    #$18,d4
                    sub.w    #$68,d5
                    clr.w    d0
                    move.w   12(a0),d1
                    sub.w    d6,d4
                    bmi.s    lbC009EA8
                    tst.w    lbL009C64
                    bne      lbC009EB2
lbC009E8A:          tst.w    d4
                    bpl.s    lbC009E90
                    neg.w    d4
lbC009E90:          cmp.w    #4,d4
                    bmi.s    lbC009EC2
                    move.w   #1,$2A(a0)
                    tst.w    d1
                    beq.s    lbC009EC2
                    add.w    d1,d6
                    move.w   #4,d0
                    bra.s    lbC009EC2

lbC009EA8:          tst.w    lbL009C64
                    bne      lbC009E8A
lbC009EB2:          move.w   #$100,$2A(a0)
                    tst.w    d1
                    beq.s    lbC009EC2
                    sub.w    d1,d6
                    move.w   #8,d0
lbC009EC2:          move.w   14(a0),d1
                    sub.w    d7,d5
                    bmi.s    lbC009EF2
                    tst.w    lbL009C64
                    bne      lbC009EFC
lbC009ED4:          tst.w    d5
                    bpl.s    lbC009EDA
                    neg.w    d5
lbC009EDA:          cmp.w    #4,d5
                    bmi.s    lbC009F0E
                    move.w   #$10,$2C(a0)
                    tst.w    d1
                    beq.s    lbC009F0E
                    add.w    d1,d7
                    or.w     #1,d0
                    bra.s    lbC009F0E

lbC009EF2:          tst.w    lbL009C64
                    bne      lbC009ED4
lbC009EFC:          move.w   #$100,$2C(a0)
                    tst.w    d1
                    beq      lbC009F0E
                    sub.w    d1,d7
                    or.w     #2,d0
lbC009F0E:          swap     d6
                    move.w   d7,d6
                    move.l   d6,ALIEN_POS_X(a0)
                    move.l   $16(a0),a6
                    move.l   d6,(a6)
                    add.l    4(a1),d6
                    move.l   d6,(a2)
                    add.l    8(a1),d6
                    move.l   d6,4(a2)
                    not.w    $30(a0)
                    beq      lbC009F60
                    lea      lbL01BBE2,a6
                    tst.w    d0
                    bne.s    lbC009F42
                    lea      lbL01BBFE,a6
lbC009F42:          tst.w    $34(a0)
                    beq.s    lbC009F52
                    clr.w    $34(a0)
                    lea      lbL01BBE2,a6
lbC009F52:          move.l   $12(a0),a5
                    cmp.l    8(a5),a6
                    beq.s    lbC009F60
                    move.l   a6,$28(a5)
lbC009F60:          rts

lbC009F62:          tst.w    lbW0004D8
                    bne      lbC00A5CC
                    clr.w    lbW0004EA
                    move.w   #1,lbW0004D8
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbW008CF6,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    lea      lbW008D50,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    lea      lbW008C9C,a0
                    sub.w    #8,ALIEN_POS_X(a0)
                    move.w   ALIEN_POS_X(a0),d0
                    move.w   ALIEN_POS_Y(a0),d1
                    move.l   $12(a0),a0
                    add.w    #$20,-4(a0)
                    sub.w    #$10,d0
                    add.w    #$1E,d1
                    lea      lbW008CF6,a0
                    add.w    #$20,d0
                    add.w    #0,d1
                    bsr      lbC00A212
                    lea      lbW008D50,a0
                    add.w    #$1C,d0
                    add.w    #0,d1
                    bsr      lbC00A212
                    lea      lbW008DAA,a0
                    sub.w    #$20,d0
                    add.w    #$1C,d1
                    bsr      lbC00A212
                    lea      lbW008E04,a0
                    add.w    #$28,d0
                    add.w    #4,d1
                    bsr      lbC00A212
                    lea      lbW008E5E,a0
                    sub.w    #$20,d0
                    add.w    #$20,d1
                    bsr      lbC00A212
                    lea      lbW008EB8,a0
                    add.w    #$12,d0
                    add.w    #0,d1
                    bsr      lbC00A212
                    cmp.w    #1,boss_nbr
                    beq.s    lbC00A056
                    cmp.w    #3,boss_nbr
                    beq      lbC00A1BA
                    cmp.w    #2,boss_nbr
                    beq      lbC00A0EE
                    movem.l  (sp)+,d0-d7/a0-a6
                    bra      lbC00A5CC

lbC00A056:          lea      lbL0201C2,a2
                    lea      lbW062D52,a3
                    bsr      patch_tiles
                    movem.l  (sp)+,d0-d7/a0-a6
                    bra      lbC00A5CC

lbC00A0EE:          lea      lbL02087E,a2
                    lea      lbW060644,a3
                    bsr      patch_tiles
                    move.w   #1,lbW0004D8
                    move.w   #1,self_destruct_initiated
                    movem.l  (sp)+,d0-d7/a0-a6
                    bra      lbC00A5CC

lbC00A1BA:          lea      lbL020B52,a2
                    lea      lbW063804,a3
                    bsr      patch_tiles
                    lea      lbL020B86,a2
                    lea      lbW063806,a3
                    bsr      patch_tiles
                    lea      lbL020B0A,a2
                    lea      lbW063CCE,a3
                    bsr      patch_tiles
                    lea      lbL020B0A,a2
                    lea      lbL063DC6,a3
                    bsr      patch_tiles
                    move.w   #1,lbW0004D8
                    move.w   #1,self_destruct_initiated
                    movem.l  (sp)+,d0-d7/a0-a6
                    bra      lbC00A5CC

lbC00A212:          move.l   $12(a0),a1
                    move.w   d0,-4(a1)
                    move.w   d1,-2(a1)
                    move.l   #lbL018C2E,$28(a1)
                    rts

lbB00A228:          dc.b    0,0,0
                    dc.b    5,0,1,0,0,0,3,0,4,0,2,0,0,0,7,0,6,0,8,0,0,0,0,0,0
                    dc.b    0,0,0,0,0,0,0,0,0,0,0

lbB00A24F:          dc.b    0,0,0,0,0,0,0,0,0
                    dc.b    1,1
                    dc.b    2,3,6,7,8,1,2,2,2,3,4,7,8,1,2,3,3,3,4,5,8,1,2,3,4
                    dc.b    4,4
                    dc.b    5,6,1,2,3,4,5,5,5,6,7,8,3,4,5,6,6,6,7,8,1,4,5,6,7
                    dc.b    7,7
                    dc.b    8,1,2,5,6,7,8,8

lbW00A29A:          dcb.w    3,-4
                    dc.w     -10,-5,1
lbW00A2A6:          dcb.w    3,$10
                    dc.w     -10,-5,1
lbW00A2B2:          dc.w     0,5,11,-13,-13,-13
lbW00A2BE:          dc.w     0,5,11,5,5,5
lbW00A2CA:          dcb.w    3,-4
                    dc.w     -6,4,$10
lbW00A2D6:          dcb.w    3,$1E
                    dc.w     -6,4,$10
lbW00A2E2:          dc.w     0,10,$16,-10,-10,-10
lbW00A2EE:          dc.w     0,10,$16,$14,$14,$14
lbW00A2FA:          dcb.w    4,-6
                    dc.w     4,$10
lbW00A306:          dcb.w    3,$64
                    dc.w     -6,4,$10
lbW00A312:          dc.w     4,$32,$5A,-10,-10,-10
lbW00A31E:          dc.w     4,$32,$5A,$70,$70,$70

check_aliens_collisions:
                    not.w    $2E(a0)
                    bne.s    lbC00A348
                    move.w   10(a0),12(a0)
                    tst.b    $2A(a0)
                    bne.s    lbC00A342
                    move.l   $14(a1),a4
                    bra.s    lbC00A360

lbC00A342:          move.l   $10(a1),a4
                    bra.s    lbC00A360

lbC00A348:          move.w   10(a0),14(a0)
                    tst.b    $2C(a0)
                    bne.s    lbC00A35C
                    move.l   $1C(a1),a4
                    bra      lbC00A360

lbC00A35C:          move.l   $18(a1),a4
lbC00A360:          clr.l    d0
                    clr.l    d1
                    lea      aliens_collisions_table(pc),a5
                    lea      map_lines_table+4,a6
                    move.w   ALIEN_POS_X(a0),d0
                    move.w   ALIEN_POS_Y(a0),d1
                    move.w   d0,d6
                    move.w   d1,d7
                    add.w    0(a4),d0
                    add.w    6(a4),d1
                    lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    move.l   0(a6,d1.w),a3
                    move.w   0(a3,d0.w),d0
                    and.w    #$3F,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    jsr      0(a5,d0.w)
                    move.w   d6,d0
                    move.w   d7,d1
                    add.w    4(a4),d0
                    add.w    10(a4),d1
                    lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    move.l   0(a6,d1.w),a3
                    move.w   0(a3,d0.w),d0
                    and.w    #$3F,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    jsr      0(a5,d0.w)
                    move.w   d6,d0
                    move.w   d7,d1
                    add.w    2(a4),d0
                    add.w    8(a4),d1
                    lsr.w    #4,d0
                    lsr.w    #4,d1
                    add.w    d0,d0
                    add.w    d1,d1
                    add.w    d1,d1
                    move.l   0(a6,d1.w),a3
                    add.w    d0,a3
                    move.w   (a3),d0
                    and.w    #$3F,d0
                    add.w    d0,d0
                    add.w    d0,d0
                    jmp      0(a5,d0.w)

aliens_collisions_table:
                    bra.w    aliens_no_collision
                    bra.w    aliens_collision_stop
                    bra.w    aliens_no_collision
                    bra.w    aliens_collision_door
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision                    ; 0x05
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision                    ; 0x0a
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_collision_stop
                    bra.w    aliens_collision_stop
                    bra.w    aliens_collision_stop
                    bra.w    aliens_collision_stop                  ; 0x10
                    bra.w    aliens_collision_stop
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision                    ; 0x15
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision                    ; 0x1a
                    bra.w    aliens_no_collision
                    bra.w    aliens_collision_stop
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision                    ; 0x20
                    bra.w    aliens_no_collision
                    bra.w    lbC00A560                              ; not used in any levels
                    bra.w    aliens_collision_stop
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision                    ; 0x25
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_collision_stop                  ; 0x2a
                    bra.w    aliens_collision_stop
                    bra.w    aliens_collision_stop
                    bra.w    aliens_collision_stop
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision                    ; 0x30
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision                    ; 0x35
                    bra.w    last_boss_random_stop
                    bra.w    aliens_no_collision
                    bra.w    aliens_collision_stop
                    bra.w    aliens_collision_stop
                    bra.w    aliens_collision_stop                  ; 0x3a
                    bra.w    aliens_collision_stop
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision
                    bra.w    aliens_no_collision

aliens_no_collision:
                    rts

last_boss_random_stop:
                    cmp.l    #lbW00A31E,a4
                    bne      return
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #200,d0
                    bsr      rand
                    cmp.w    #75,d0
                    bmi.s    lbC00A528
                    jsr      aliens_collision_stop
lbC00A528:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

aliens_collision_stop:
                    tst.w    $2E(a0)
                    bne      lbC00A546
                    clr.w    12(a0)
                    move.w   #0,$52(a0)
                    clr.w    12(a0)
                    rts

lbC00A546:          clr.w    14(a0)
                    move.w   #1,$52(a0)
                    clr.w    14(a0)
                    rts

aliens_collision_door:
                    bra.s    aliens_collision_stop

lbC00A560:          move.w   #1,$34(a0)
                    rts

lbC00A568:          subq.w   #1,$4C(a0)
                    move.l   $34(a1),a6
                    move.l   $12(a0),a5
                    cmp.l    8(a5),a6
                    beq      return
                    move.l   a6,$28(a5)
                    rts

lbC00A582:          move.w   $28(a1),d0
                    cmp.w    $36(a0),d0
                    beq.s    alien_dies_touching_player
                    subq.w   #1,$36(a0)
                    tst.w    $36(a0)
                    bmi      lbC00A63A
                    rts

alien_dies_touching_player:
                    subq.w   #1,$36(a0)
                    move.w   $10(a0),d0
                    add.w    d0,d0
                    add.w    d0,d0
                    add.w    #32,d0
                    move.l   12(a1),a6
                    move.l   $12(a0),a5
                    move.l   0(a6,d0.w),$28(a5)
                    addq.l   #1,aliens_killed
                    move.w   $3A(a1),sample_to_play         ; alien shit sound
                    jmp      trigger_sample

lbC00A5CC:          cmp.w    #13,$3A(a0)
                    beq.s    alien_dies
                    subq.w   #1,$3A(a0)
                    tst.w    $3A(a0)
                    bmi      lbC00A63A
                    rts

alien_dies:         subq.w   #1,$3A(a0)
                    move.w   #100,d0
                    move.l   12(a1),a6
                    move.l   $12(a0),a5
                    move.l   0(a6,d0.w),$28(a5)
                    addq.l   #1,aliens_killed
                    move.w   $3A(a1),sample_to_play         ; explo
                    jsr      trigger_sample
                    move.w   $38(a1),sample_to_play         ; alien shit sound
                    jmp      trigger_sample

lbC00A61C:          lea      lbW008C9C,a0
lbC00A622:          move.l   $1A(a0),a1
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    add.l    #$5A,a0
                    tst.w    (a0)
                    bpl.s    lbC00A622
                    rts

lbC00A63A:          clr.w    lbW0004EA
                    move.w   #-1,8(a0)
                    move.w   4(a0),d0
                    move.w   6(a0),d1
                    move.w   d0,ALIEN_POS_X(a0)
                    move.w   d1,ALIEN_POS_Y(a0)
                    move.l   $16(a0),a6
                    move.w   d0,(a6)
                    move.w   d1,2(a6)
                    move.w   d0,(a2)
                    move.w   d1,2(a2)
                    add.w    #32,d0
                    add.w    #32,d1
                    move.w   d0,4(a2)
                    move.w   d1,6(a2)
                    clr.w    $32(a0)
                    clr.w    12(a0)
                    clr.w    14(a0)
                    clr.w    $34(a0)
                    clr.w    $38(a0)
                    move.w   #13,$3A(a0)
                    move.l   #lbC00987C,$40(a0)         ;;
                    move.l   #lbW008F14,$1A(a0)
                    rts

lbL00A6A2:          dc.l     0
lbL00A6A6:          dc.l     0
lbB00A6AA:          dcb.b    2,0
lbW00A6AC:          dc.w     0

lbC00A6AE:          clr.l    lbL00A6A2
                    clr.l    lbL00A6A6
                    clr.l    lbB00A6AA
                    rts

lbC00A6C2:          tst.w    lbL005166
                    beq.s    lbC00A6D0
                    subq.w   #1,lbL005166
lbC00A6D0:          addq.w   #1,lbL00A6A6
                    cmp.w    #$10,lbL00A6A6
                    bmi      return
                    clr.w    lbL00A6A6
                    move.w   lbW00412A,d0
                    cmp.w    lbW00A6AC,d0
                    bne.s    lbC00A700
                    move.w   #1,lbL00A6A2
                    rts

lbC00A700:          move.w   lbW00412A,lbW00A6AC
                    clr.w    lbL00A6A2
                    rts

play_alien_spawning_sample:
                    dc.w     0

lbC00A718:          clr.w    play_alien_spawning_sample
                    tst.w    lbW0004B2
                    beq      lbC00A8D0
                    tst.w    lbL00A6A2
                    beq.s    lbC00A74C
                    move.w   lbW0005AA,d0
                    move.w   rnd_number,d1
                    cmp.w    d0,d1
                    bpl      return
lbC00A74C:          move.w   lbW0035D6,d0
                    move.w   d0,d1
                    sub.w    #$42,d0
                    add.w    #$132,d1
                    move.w   lbW0035D2,d2
                    move.w   d2,d3
                    sub.w    #$42,d2
                    add.w    #$102,d3
                    lea      lbW008C9C,a0
lbC00A772:          tst.w    (a0)
                    bmi      return
                    move.w   ALIEN_POS_X(a0),d4
                    move.w   ALIEN_POS_Y(a0),d5
                    add.w    #$5A,a0
                    cmp.w    d4,d0
                    bpl.s    lbC00A794
                    cmp.w    d1,d4
                    bpl.s    lbC00A794
                    cmp.w    d5,d2
                    bpl.s    lbC00A794
                    cmp.w    d3,d5
                    bmi.s    lbC00A772
lbC00A794:          sub.w    #$5A,a0

patch_boss_door:    tst.w    lbW0004EA
                    bne      return
                    move.w   $2A(a1),lbW0097F2
                    move.l   cur_map_top_ptr,d0
                    move.l   a3,d1
                    sub.l    d0,d1
                    divu     #248,d1
                    move.l   d1,d0
                    swap     d0
                    lsl.w    #3,d0
                    lsl.w    #4,d1
                    add.w    $30(a1),d0
                    add.w    $32(a1),d1
                    movem.w  d0/d1,-(sp)
                    add.w    4(a1),d0
                    add.w    6(a1),d1
                    move.w   d0,d2
                    move.w   d1,d3
                    add.w    8(a1),d2
                    add.w    10(a1),d3
                    lea      cur_alien1_dats,a2
                    movem.w  d6/d7,-(sp)
lbC00A7EA:          movem.w  (a2)+,d4-d7
                    addq.w   #4,a2
                    tst.w    d4
                    bmi.s    do_alien_spawn
                    cmp.w    d1,d7
                    bmi.s    lbC00A7EA
                    cmp.w    d5,d3
                    bmi.s    lbC00A7EA
                    cmp.w    d0,d6
                    bmi.s    lbC00A7EA
                    cmp.w    d4,d2
                    bmi.s    lbC00A7EA
                    movem.w  (sp)+,d6/d7
                    bra      lbC00A8CA

do_alien_spawn:     movem.w  (sp)+,d6/d7
                    clr.w    8(a0)
                    move.l   0(a0),a2
                    move.w   d0,(a2)
                    move.w   d1,2(a2)
                    move.w   d2,4(a2)
                    move.w   d3,6(a2)
                    move.l   a1,$1A(a0)
                    tst.w    select_speed_boss
                    beq.s    set_alien_random_speed
                    move.w   $20(a1),ALIEN_SPEED(a0)             ; max speed (boss speed ?)
                    bra.s    lbC00A872

set_alien_random_speed:
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.w   $20(a1),d0
                    ext.l    d0
                    jsr      get_alien_rnd_speed
                    move.w   cur_aliens_speed,ALIEN_SPEED(a0)    ; random speed
                    movem.l  (sp)+,d0-d7/a0-a6

lbC00A872:          move.w   $22(a1),ALIEN_STRENGTH(a0)
                    move.w   d0,-(sp)
                    move.w   global_aliens_extra_strength,d0
                    add.w    d0,ALIEN_STRENGTH(a0)
                    move.w   (sp)+,d0
                    move.l   (a1),$40(a0)                       ;;
                    movem.w  (sp)+,d0/d1
                    move.w   #1,$3E(a0)
                    move.w   d0,ALIEN_POS_X(a0)
                    move.w   d1,ALIEN_POS_Y(a0)
                    move.l   $12(a0),a2
                    move.l   ALIEN_POS_X(a0),-4(a2)
                    move.w   $28(a1),$36(a0)
                    clr.l    $4E(a0)
                    clr.w    $54(a0)
                    clr.w    $58(a0)
                    move.w   $2E(a1),$4C(a0)
                    move.w   #1,play_alien_spawning_sample
                    rts

lbC00A8CA:          movem.w  (sp)+,d0/d1
                    rts

lbC00A8D0:          rts

cur_alien1_dats:    dcb.w    4,0
                    dc.l     lbW008C9C
cur_alien2_dats:    dcb.w    4,0
                    dc.l     lbW008CF6
cur_alien3_dats:    dcb.w    4,0
                    dc.l     lbW008D50
cur_alien4_dats:    dcb.w    4,0
                    dc.l     lbW008DAA
cur_alien5_dats:    dcb.w    4,0
                    dc.l     lbW008E04
cur_alien6_dats:    dcb.w    4,0
                    dc.l     lbW008E5E
cur_alien7_dats:    dcb.w    4,0
                    dc.l     lbW008EB8

                    dc.w     $FFFF

lbC00A96C:          movem.w  d0/d5-d7,-(sp)
                    move.w   d6,d1
                    swap     d1
                    move.w   d7,d1
                    add.l    4(a1),d1
                    move.l   d1,d3
                    add.l    8(a1),d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
                    lea      cur_alien1_dats(pc),a6
                    move.l   0(a0),a5
                    add.w    #12,a5
lbC00A994:          movem.w  (a6)+,d4-d7
                    addq.w   #4,a6
                    tst.w    d4
                    bmi.s    lbC00A9D0
                    cmp.l    a6,a5
                    beq.s    lbC00A994
                    cmp.w    d0,d6
                    bmi.s    lbC00A994
                    cmp.w    d4,d2
                    bmi.s    lbC00A994
                    cmp.w    d1,d7
                    bmi.s    lbC00A994
                    cmp.w    d5,d3
                    bmi.s    lbC00A994
                    movem.w  (sp)+,d0/d5-d7
                    move.w   (a2),d6
                    sub.w    4(a1),d6
                    subq.w   #4,a6
                    move.l   (a6),a6
                    move.l   a6,$26(a0)
                    move.w   #1,$22(a0)
                    and.w    #3,d0
                    rts

lbC00A9D0:          movem.w  (sp)+,d0/d5-d7
                    rts

lbC00A9D6:          movem.w  d0/d6/d7,-(sp)
                    move.w   d6,d1
                    swap     d1
                    move.w   d7,d1
                    add.l    4(a1),d1
                    move.l   d1,d3
                    add.l    8(a1),d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
                    lea      cur_alien1_dats(pc),a6
                    move.l   0(a0),a5
                    add.l    #12,a5
lbC00AA00:          movem.w  (a6)+,d4-d7
                    addq.w   #4,a6
                    tst.w    d4
                    bmi.s    lbC00AA3E
                    cmp.l    a6,a5
                    beq.s    lbC00AA00
                    cmp.w    d1,d7
                    bmi.s    lbC00AA00
                    cmp.w    d5,d3
                    bmi.s    lbC00AA00
                    cmp.w    d0,d6
                    bmi.s    lbC00AA00
                    cmp.w    d4,d2
                    bmi.s    lbC00AA00
                    movem.w  (sp)+,d0/d6/d7
                    move.w   2(a2),d7
                    sub.w    6(a1),d7
                    subq.w   #4,a6
                    move.l   (a6),a6
                    move.l   a6,$26(a0)
                    move.w   #1,$24(a0)
                    and.w    #12,d0
                    rts

lbC00AA3E:          movem.w  (sp)+,d0/d6/d7
                    rts

lbC00AA44:          lea      player_1_dats,a1
                    move.l   PLAYER_POS_X(a1),d1
                    add.l    #$80008,d1
                    move.l   d1,d3
                    add.l    #$100010,d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
                    bsr.s    lbC00AA86
                    lea      player_2_dats,a1
                    move.l   PLAYER_POS_X(a1),d1
                    add.l    #$80008,d1
                    move.l   d1,d3
                    add.l    #$100010,d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
lbC00AA86:          clr.w    $116(a1)
                    lea      cur_alien1_dats,a6
lbC00AA90:          movem.w  (a6)+,d4-d7
                    addq.w   #4,a6
                    tst.w    d4
                    bmi      return
                    cmp.w    d1,d7
                    bmi.s    lbC00AA90
                    cmp.w    d5,d3
                    bmi.s    lbC00AA90
                    cmp.w    d0,d6
                    bmi.s    lbC00AA90
                    cmp.w    d4,d2
                    bmi.s    lbC00AA90
                    subq.w   #4,a6
                    move.l   (a6),a0
                    move.l   $1A(a0),a2
                    tst.w    $38(a0)
                    bne.s    lbC00AADC
                    tst.w    $34(a0)
                    bne.s    lbC00AAD0
                    add.l    #1500,PLAYER_CREDITS(a1)
                    add.l    #100,PLAYER_SCORE(a1)
lbC00AAD0:          move.w   #5,$124(a1)
                    move.w   #1,$116(a1)
lbC00AADC:          tst.w    $34(a0)
                    bne.s    lbC00AB04
                    tst.w    $38(a0)
                    bne.s    lbC00AB04
                    tst.w    PLAYER_HEALTH(a1)
                    beq.s    lbC00AB04
                    move.w   $24(a2),d5
                    add.w    d5,d5
                    sub.w    d5,PLAYER_HEALTH(a1)
                    cmp.w    #1,PLAYER_HEALTH(a1)
                    bpl.s    lbC00AB04
                    clr.w    PLAYER_HEALTH(a1)
lbC00AB04:          move.w   #1,$34(a0)
                    rts

lbC00AB0C:          lea      lbW00E940,a1
                    move.l   0(a1),d1
                    add.l    #$40004,d1
                    move.l   d1,d3
                    add.l    #$A000A,d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
                    bsr      lbC00ABB8
                    lea      lbW00E95A,a1
                    move.l   0(a1),d1
                    add.l    #$40004,d1
                    move.l   d1,d3
                    add.l    #$A000A,d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
                    bsr      lbC00ABB8
                    lea      lbW00E974,a1
                    move.l   0(a1),d1
                    add.l    #$40004,d1
                    move.l   d1,d3
                    add.l    #$A000A,d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
                    bsr.s    lbC00ABB8
                    lea      lbW00E98E,a1
                    move.l   0(a1),d1
                    add.l    #$40004,d1
                    move.l   d1,d3
                    add.l    #$A000A,d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
                    bsr.s    lbC00ABB8
                    lea      lbW00E9A8,a1
                    move.l   0(a1),d1
                    add.l    #$40004,d1
                    move.l   d1,d3
                    add.l    #$A000A,d3
                    move.l   d1,d0
                    swap     d0
                    move.l   d3,d2
                    swap     d2
lbC00ABB8:          lea      cur_alien1_dats,a6
lbC00ABBE:          movem.w  (a6)+,d4-d7
                    addq.w   #4,a6
                    tst.w    d4
                    bmi      return
                    cmp.w    d1,d7
                    bmi.s    lbC00ABBE
                    cmp.w    d5,d3
                    bmi.s    lbC00ABBE
                    cmp.w    d0,d6
                    bmi.s    lbC00ABBE
                    cmp.w    d4,d2
                    bmi.s    lbC00ABBE
                    subq.w   #4,a6
                    move.l   (a6),a0
                    move.w   #1,$32(a0)
                    move.w   $10(a1),d0
                    sub.w    d0,ALIEN_STRENGTH(a0)
                    tst.w    ALIEN_STRENGTH(a0)
                    bpl.s    lbC00AC14
                    move.l   $14(a1),a6
                    tst.w    $38(a0)
                    bne      lbC00AC0E
                    add.l    #1500,PLAYER_CREDITS(a6)
                    add.l    #100,PLAYER_SCORE(a6)
lbC00AC0E:          move.w   #1,$38(a0)
lbC00AC14:          move.l   $1A(a0),a6
                    cmp.w    #1,$26(a6)
                    beq.s    lbC00AC26
                    tst.w    $12(a1)
                    bne.s    lbC00AC38
lbC00AC26:          move.w   #$7D00,0(a1)
                    move.l   8(a1),a6
                    move.l   #lbL018CBA,$28(a6)
lbC00AC38:          rts

lbL00AC3E:          dcb.l    2,0
lbL00AC46:          dc.l     0
lbL00AC4A:          dcb.l    3,0
lbL00AC56:          dcb.l    3,0
lbL00AC62:          dcb.l    3,0
lbL00AC6E:          dcb.l    3,0
lbL00AC7A:          dcb.l    3,0
lbL00AC86:          dcb.l    3,0
lbL00AC92:          dcb.l    3,0
lbB00AC9E:          dcb.b    2,0
lbW00ACA0:          dc.w     0
lbL00ACA2:          dc.l     lbL00AC3E
                    dc.l     lbL00AC4A
                    dc.l     lbL00AC56
                    dc.l     lbL00AC62
                    dc.l     lbL00AC6E
                    dc.l     lbL00AC7A
                    dc.l     lbL00AC86
                    dc.l     lbL00AC92

lbC00ACC2:          clr.l    lbB00AC9E
                    clr.w    lbW00ACE2
                    lea      lbL00AC3E,a6
                    move.l   #$60,d0
lbC00ACDA:          clr.b    (a6)+
                    subq.l   #1,d0
                    bne.s    lbC00ACDA
                    rts

lbW00ACE2:          dc.w     0

lbC00ACE4:          tst.w    lbW00ACE2
                    bne      return
                    tst.w    lbW00ACA0
                    beq      return
                    lea      lbL00ACA2,a0
                    move.l   (a0),a1
                    move.l   4(a0),(a0)
                    move.l   8(a0),4(a0)
                    move.l   12(a0),8(a0)
                    move.l   $10(a0),12(a0)
                    move.l   $14(a0),$10(a0)
                    move.l   $18(a0),$14(a0)
                    move.l   $1C(a0),$18(a0)
                    move.l   a1,$1C(a0)
                    subq.w   #4,lbW00ACA0
                    lea      lbW012A28,a0
                    move.l   0(a1),-4(a0)
                    move.l   8(a1),a3
                    clr.l    8(a1)
                    move.l   4(a1),a1
                    jmp      lbC00AF00

lbW00AD50:          dc.w     0

patch_tiles:        clr.w    lbW00AD50
                    cmp.l    lbW012A6A,a3
                    beq      return
                    lea      lbL00AC46,a1
                    move.l   #32,d7
lbC00AD6E:          cmp.l    (a1),a3
                    beq      return
                    add.l    #12,a1
                    subq.w   #4,d7
                    bpl.s    lbC00AD6E
                    lea      lbL00ACA2,a1
                    add.l    lbB00AC9E,a1
                    move.l   (a1),a1
                    cmp.w    #$20,lbW00ACA0
                    beq      return
                    addq.w   #4,lbW00ACA0
                    move.l   cur_map_top_ptr,d0
                    move.l   a3,d1
                    sub.l    d0,d1
                    divu     #248,d1
                    move.l   d1,d0
                    swap     d0
                    lsl.w    #3,d0
                    lsl.w    #4,d1
                    add.w    #16,d0
                    add.w    #16,d1
                    move.l   a2,4(a1)
                    move.l   a3,8(a1)
                    move.w   d0,0(a1)
                    move.w   d1,2(a1)
                    move.w   #1,lbW00AD50
                    rts

lbC00ADD6:          lea      lbL012380,a0
                    jsr      lbC00AE20
                    lea      lbW01249C,a0
                    jsr      lbC00AE20
                    lea      lbW0125B8,a0
                    jsr      lbC00AE20
                    lea      lbW0126D4,a0
                    jsr      lbC00AE20
                    lea      lbW0127F0,a0
                    jsr      lbC00AE20
                    lea      lbW01290C,a0
                    jsr      lbC00AE20
                    rts

lbC00AE20:          move.w   #2984,-4(a0)
                    move.w   #30000,-2(a0)
                    rts

lbC00AE2E:          cmp.l    lbW0123C2,a3
                    beq      lbC00AEB6
                    cmp.l    lbW0124DE,a3
                    beq      lbC00AEB6
                    cmp.l    lbW0125FA,a3
                    beq      lbC00AEB6
                    cmp.l    lbW012716,a3
                    beq      lbC00AEB6
                    cmp.l    lbW012832,a3
                    beq.s    lbC00AEB6
                    cmp.l    lbW01294E,a3
                    beq.s    lbC00AEB6
                    move.l   map_pos_x,d0
                    move.l   d0,d2
                    sub.w    #$40,d0
                    add.w    #$170,d2
                    move.l   map_pos_y,d1
                    move.l   d1,d3
                    sub.w    #$40,d1
                    add.w    #$130,d3
                    lea      lbL012380,a0
                    bsr.s    lbC00AEBA
                    lea      lbW01249C,a0
                    bsr.s    lbC00AEBA
                    lea      lbW0125B8,a0
                    bsr.s    lbC00AEBA
                    lea      lbW0126D4,a0
                    bsr.s    lbC00AEBA
                    lea      lbW0127F0,a0
                    bsr.s    lbC00AEBA
                    lea      lbW01290C,a0
                    bsr.s    lbC00AEBA
lbC00AEB6:          addq.l   #4,sp
                    rts

lbC00AEBA:          move.w   -4(a0),d4
                    move.w   -2(a0),d5
                    cmp.w    d0,d4
                    bmi.s    lbC00AED4
                    cmp.w    d2,d4
                    bpl.s    lbC00AED4
                    cmp.w    d1,d5
                    bmi.s    lbC00AED4
                    cmp.w    d3,d5
                    bpl.s    lbC00AED4
                    rts

lbC00AED4:          addq.l   #4,sp
                    rts

lbC00AED8:          move.l   cur_map_top_ptr,a1
                    move.l   a3,d1
                    sub.l    a1,d1
                    divu     #$F8,d1
                    move.l   d1,d0
                    swap     d0
                    lsl.w    #3,d0
                    lsl.w    #4,d1
                    add.w    #$10,d0
                    add.w    #$10,d1
                    move.w   d0,-4(a0)
                    move.w   d1,-2(a0)
                    rts

lbC00AF00:          move.w   #1,lbW00ACE2
                    move.l   #1,d0
                    bra.s    lbC00AF20

lbC00AF10:          cmp.l    #0,a0
                    beq      return
                    clr.l    d0
                    bra      lbC00AF20

lbC00AF20:          move.l   a3,$42(a0)
                    move.w   d0,$30(a0)
                    move.l   a1,$28(a0)
                    move.l   a4,-(sp)
                    move.l   #lbL00051C,a4
                    move.w   -8(a1),d0
                    cmp.w    #$FFFF,d0
                    beq.s    lbC00AF42
                    move.l   a3,a4
                    add.w    d0,a4
lbC00AF42:          move.l   a4,$32(a0)
                    move.l   #lbL00051C,a4
                    move.w   -6(a1),d0
                    cmp.w    #$FFFF,d0
                    beq.s    lbC00AF5A
                    move.l   a3,a4
                    add.w    d0,a4
lbC00AF5A:          move.l   a4,$36(a0)
                    move.l   #lbL00051C,a4
                    move.w   -4(a1),d0
                    cmp.w    #$FFFF,d0
                    beq.s    lbC00AF72
                    move.l   a3,a4
                    add.w    d0,a4
lbC00AF72:          move.l   a4,$3A(a0)
                    move.l   #lbL00051C,a4
                    move.w   -2(a1),d0
                    cmp.w    #$FFFF,d0
                    beq.s    lbC00AF8A
                    move.l   a3,a4
                    add.w    d0,a4
lbC00AF8A:          move.l   a4,$3E(a0)
                    move.l   (sp)+,a4
                    rts

lev1_dats:          dc.l    'L0MA',aliens_sprites_block
                    dc.l    'L0AN',bkgnd_anim_block
                    dc.l    'L0BO',aliens_sprites_block
                    
lev2_dats:          dc.l    'L1MA',aliens_sprites_block
                    dc.l    'L1AN',bkgnd_anim_block
                    dc.l    'L1BO',aliens_sprites_block

lev3_dats:          dc.l    'L2MA',aliens_sprites_block
                    dc.l    'L3AN',bkgnd_anim_block
                    dc.l    'L3BO',aliens_sprites_block
                    
lev4_dats:          dc.l    'L3MA',aliens_sprites_block
                    dc.l    'L4AN',bkgnd_anim_block
                    dc.l    'L4BO',aliens_sprites_block

lev5_dats:          dc.l    'L4MA',aliens_sprites_block
                    dc.l    'L4AN',bkgnd_anim_block
                    dc.l    'L4BO',aliens_sprites_block
                    
lev6_dats:          dc.l    'L5MA',aliens_sprites_block
                    dc.l    'L3AN',bkgnd_anim_block
                    dc.l    'L3BO',aliens_sprites_block

lev7_dats:          dc.l    'L6MA',aliens_sprites_block
                    dc.l    'L3AN',bkgnd_anim_block
                    dc.l    'L2BO',aliens_sprites_block
                    
lev8_dats:          dc.l    'L7MA',aliens_sprites_block
                    dc.l    'L3AN',bkgnd_anim_block
                    dc.l    'L2BO',aliens_sprites_block

lev9_dats:          dc.l    'L8MA',aliens_sprites_block
                    dc.l    'L2AN',bkgnd_anim_block
                    dc.l    'L2BO',aliens_sprites_block
                    
lev10_dats:         dc.l    'L9MA',aliens_sprites_block
                    dc.l    'L1AN',bkgnd_anim_block
                    dc.l    'L1BO',aliens_sprites_block
                    
lev11_dats:         dc.l    'LAMA',aliens_sprites_block
                    dc.l    'L1AN',bkgnd_anim_block
                    dc.l    'L2BO',aliens_sprites_block
                    
lev12_dats:         dc.l    'LBMA',aliens_sprites_block
                    dc.l    'L5AN',bkgnd_anim_block
                    dc.l    'L5BO',aliens_sprites_block
                    
load_level_1:       lea      lev1_dats(pc),a2
                    bra      load_level

load_level_2:       lea      lev2_dats(pc),a2
                    bra      load_level

load_level_3:       lea      lev3_dats(pc),a2
                    bra      load_level

load_level_4:       lea      lev4_dats(pc),a2
                    bra      load_level

load_level_5:       lea      lev5_dats(pc),a2
                    bra      load_level

load_level_6:       lea      lev6_dats(pc),a2
                    bra      load_level

load_level_7:       lea      lev7_dats(pc),a2
                    bra      load_level

load_level_8:       lea      lev8_dats(pc),a2
                    bra      load_level

load_level_9:       lea      lev9_dats(pc),a2
                    bra      load_level

load_level_10:      lea      lev10_dats(pc),a2
                    bra      load_level

load_level_11:      lea      lev11_dats(pc),a2
                    bra      load_level

load_level_12:      lea      lev12_dats(pc),a2
                    bra      load_level

load_level:         bsr      load_map_file
                    jsr      copy_map_datas
                    bsr      load_map_sprites           ; load animated tiles
                    bsr      load_map_bkgnd_tiles       ; load background tiles
                    bsr      load_map_sprites           ; load sprites
                    rts

load_map_bkgnd_tiles:
                    move.l   tilespic_filename,file_name    ; filename coming from the map file
                    lea      file_name(pc),a0
                    lea      bkgnd_tiles_block,a1
                    bsr      load_file
                    rts

load_map_sprites:   move.l   (a2)+,file_name
                    lea      file_name(pc),a0
                    move.l   (a2)+,a1
                    bsr      load_file
                    rts

load_map_file:      move.l   (a2)+,file_name
                    lea      file_name(pc),a0
                    lea      temp_map_buffer,a1
                    bsr      load_file
                    lea      temp_map_buffer,a0
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      temp_map_buffer,a0
                    bsr      retrieve_bkgnd_tiles_filename
                    lea      temp_map_buffer,a0
                    bsr      get_map_palettes
                    lea      temp_map_buffer,a0
                    lea      temp_map_buffer,a1
                    bsr      get_map_datas
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   (a2)+,a1
                    move.l   #23040,d0
move_map_datas:     move.b   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    move_map_datas
                    rts

file_name:          dc.b     "    ", 0
                    even
exe_intex:          dc.b     "intex", 0
                    even
exe_menu:           dc.b     "menu", 0
                    even
exe_end:            dc.b     "end", 0
                    even
exe_gameover:       dc.b     "gameover", 0
                    even
exe_story:          dc.b     "story", 0
                    even
exe_briefingcore:   dc.b     "briefingcore", 0
                    even
exe_briefingstart:  dc.b     "briefingstart", 0
                    even
pic_mapbkgnd:       dc.b     "mapbkgnd_320x256x4.raw", 0
                    even
soundmon_level:     dc.b     "level.soundmon", 0
                    even
soundmon_boss:      dc.b     "boss.soundmon", 0
                    even
soundmon_title:     dc.b     "title.soundmon", 0
                    even

get_map_datas:      move.l   a0,a1
                    move.l   #2048,d0
search_BODY_chunk:  cmp.l    #'BODY',(a0)+
                    beq.s    copy_BODY_chunk
                    subq.w   #1,d0
                    bne.s    search_BODY_chunk
                    move.l   #-1,d0
                    rts

copy_BODY_chunk:    move.l   (a0)+,d0
                    lsr.l    #2,d0
.copy_loop:         move.l   (a0)+,(a1)+
                    subq.l   #1,d0
                    bne.s    .copy_loop
                    rts

search_starting_position: 
                    move.l   #(end_map_datas-cur_map_datas)/2,d0
                    lea      cur_map_datas,a0
                    clr.l    d2
                    clr.l    d3
search_starting_pos_loop:
                    move.w   (a0)+,d1
                    and.w    #$3F,d1
                    cmp.w    #$35,d1
                    beq.s    lbC00B58A
                    add.w    #16,d2
                    cmp.w    #124*16,d2
                    bne.s    starting_pos_next_line
                    add.w    #16,d3
                    clr.w    d2
starting_pos_next_line:
                    subq.l   #1,d0
                    bne.s    search_starting_pos_loop
                    move.w   #1280,start_pos_x
                    move.w   #320,start_pos_y
                    rts

lbC00B58A:          add.w    #4,d2
                    add.w    #58,d3
                    tst.w    d2
                    bpl.s    lbC00B598
                    clr.w    d2
lbC00B598:          tst.w    d3
                    bpl.s    lbC00B59E
                    clr.w    d3
lbC00B59E:          ext.l    d2
                    ext.l    d3
                    move.w   d2,start_pos_x
                    move.w   d3,start_pos_y
                    rts

start_pos_x:        dc.w     0
start_pos_y:        dc.w     0

retrieve_bkgnd_tiles_filename:
                    lea      temp_map_buffer+189,a0
                    lea      tilespic_filename(pc),a1
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    move.b   (a0)+,(a1)+
                    rts

tilespic_filename:  dc.l     '    '

get_map_palettes:   lea      temp_map_buffer,a0
                    move.l   #$80,d0
Search_PALA_Chunk:  cmp.l    #'PALA',(a0)+
                    beq.s    copy_PALA_chunk
                    subq.w   #1,d0
                    bne.s    Search_PALA_Chunk
                    rts

copy_PALA_chunk:    add.l    #68,a0
                    move.l   #32,d0
                    lea      level_palette1,a1
.copy_loop:         move.w   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    .copy_loop
                    lea      temp_map_buffer,a0
                    move.l   #128,d0
search_PALB_chunk:  cmp.l    #'PALB',(a0)+
                    beq.s    copy_PALB_chunk
                    subq.w   #1,d0
                    bne.s    search_PALB_chunk
                    rts

copy_PALB_chunk:    add.l    #68,a0
                    move.l   #$20,d0
                    lea      level_palette2,a1
.copy:              move.w   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    .copy
                    rts

cur_holocode:       dc.l     0

lbC00B6B2:          move.l   a0,cur_holocode
                    move.l   a0,a1
                    lea      current_keysequence,a2
lbC00B6C0:          move.b   (a1)+,d0
                    bsr      get_ascii_keycode
                    move.b   d0,(a2)+
                    tst.b    (a1)
                    bpl.s    lbC00B6C0
                    bra      search_keysequence

lbL00B6D0:          dc.l     0

lbC00B6D4:          tst.w    input_enabled
                    beq      return
                    tst.w    lbW0004D0
                    beq      return
                    subq.l   #1,lbL00B6D0
                    tst.l    lbL00B6D0
                    bpl      return
                    tst.b    key_pressed
                    beq      return
                    move.l   #2,lbL00B6D0
                    move.b   key_pressed,d0
                    move.l   keysequence_ptr,a0            ; store the key value in the sequences buffer
                    move.b   d0,(a0)
                    addq.l   #1,keysequence_ptr

search_keysequence: lea      input_table,a0
                    clr.l    d5
lbC00B728:          move.l   (a0),a1
                    lea      current_keysequence,a2
                    clr.l    d4
lbC00B732:          move.b   (a2)+,d1
                    cmp.b    (a1)+,d1
                    bne      search_next_key_sequence
                    tst.b    (a1)
                    bmi      run_keysequence_routine
                    addq.w   #1,d4
                    cmp.w    d4,d5
                    bhi.s    lbC00B732
                    move.w   d4,d5
                    bra      lbC00B732

search_next_key_sequence:
                    addq.l   #8,a0
                    tst.l    (a0)
                    bpl      lbC00B728
                    lea      current_keysequence,a0
                    tst.b    0(a0,d5.w)
                    beq      return
                    bra      reset_keysequence

run_keysequence_routine:
                    bsr      reset_keysequence
                    move.l   4(a0),a1
                    jsr      (a1)
                    move.l   #36,d0
                    move.l   #0,d2
                    jsr      trigger_sample_select_channel
                    rts

reset_keysequence:  move.l   #current_keysequence,keysequence_ptr
                    move.l   #64,d7
                    lea      current_keysequence,a6
lbC00B7AA:          clr.w    (a6)+
                    subq.w   #1,d7
                    bne.s    lbC00B7AA
                    rts

keysequence_ptr:    dc.l     current_keysequence
current_keysequence:
                    dcb.l    32,0

input_table:        dc.l     holocode_level_2,enter_level_2_holocode
                    dc.l     holocode_level_4,enter_level_4_holocode
                    dc.l     holocode_level_6,enter_level_6_holocode
                    dc.l     holocode_level_8,enter_level_8_holocode
                    dc.l     holocode_level_10,enter_level_10_holocode
                    dc.l     -1
                    dc.l     -1

holocode_level_2:   dc.b     '55955'
                    dc.b     -1
holocode_level_4:   dc.b     '48361'
                    dc.b     -1
holocode_level_6:   dc.b     '63556'
                    dc.b     -1
holocode_level_8:   dc.b     '86723'
                    dc.b     -1
holocode_level_10:  dc.b     '25194'
                    dc.b     -1

convert_input_table_to_keycodes: 
                    lea      input_table,a0
lbC00C004:          move.l   (a0),a1
lbC00C006:          move.b   (a1),d0
                    bsr      get_ascii_keycode
                    move.b   d0,(a1)
                    addq.l   #1,a1
                    tst.b    (a1)
                    bpl.s    lbC00C006
                    addq.l   #8,a0
                    tst.l    (a0)
                    bpl.s    lbC00C004
                    rts

get_ascii_keycode:  lea      keycode_ascii_letters,a5
                    lea      ascii_keycodes_table,a6
lbC00C028:          cmp.b    (a5)+,d0
                    beq      lbC00C03E
                    tst.b    (a5)
                    beq      lbC00C03E
                    add.l    #1,a6
                    bra      lbC00C028

lbC00C03E:          move.b   (a6),d0
                    rts

keycode_ascii_letters:
                    dc.b     ' ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
                    dc.b     -1
ascii_keycodes_table:
                    dc.b     $40,$20,$35,$33,$22,$12,$23,$24,$25,$17,$26,$27
                    dc.b     $28,$37,$36,$18,$19,$10,$13,$21,$14,$16,$34,$11
                    dc.b     $32,$15,$31,1,2,3,4,5,6,7,8,9,10,$FF
cur_level:          dc.l     0

enter_level_2_holocode:
                    tst.w    done_holocode_jump
                    bne      return
                    cmp.l    #level_2,cur_level
                    beq      return
                    move.w   #1,done_holocode_jump
                    move.w   #1,flag_end_level
                    move.l   #level_2,level_to_go
                    move.l   #500000,player_1_credits
                    move.l   #500000,player_2_credits
                    rts

enter_level_4_holocode:
                    tst.w    done_holocode_jump
                    bne      return
                    cmp.l    #level_4,cur_level
                    beq      return
                    move.w   #1,done_holocode_jump
                    move.w   #1,flag_end_level
                    move.l   #level_4,level_to_go
                    move.l   #1000000,player_1_credits
                    move.l   #1000000,player_2_credits
                    rts

enter_level_6_holocode:
                    tst.w    done_holocode_jump
                    bne      return
                    cmp.l    #level_6,cur_level
                    beq      return
                    move.w   #1,done_holocode_jump
                    move.w   #1,flag_end_level
                    move.l   #level_6,level_to_go
                    move.l   #1500000,player_1_credits
                    move.l   #1500000,player_2_credits
                    rts

enter_level_8_holocode:
                    tst.w    done_holocode_jump
                    bne      return
                    cmp.l    #level_8,cur_level
                    beq      return
                    move.w   #1,done_holocode_jump
                    move.w   #1,flag_end_level
                    move.l   #level_8,level_to_go
                    move.l   #2000000,player_1_credits
                    move.l   #2000000,player_2_credits
                    rts

enter_level_10_holocode:
                    tst.w    done_holocode_jump
                    bne      return
                    cmp.l    #level_10,cur_level
                    beq      return
                    move.w   #1,done_holocode_jump
                    move.w   #1,flag_end_level
                    move.l   #level_10,level_to_go
                    move.l   #2500000,player_1_credits
                    move.l   #2500000,player_2_credits
                    rts

level_to_go:        dc.l     0

player_1_invincible:
                    dc.w     DEBUG
player_2_invincible:
                    dc.w     DEBUG

jump_to_level:      tst.l    level_to_go
                    beq      return
                    addq.l   #4,sp
                    move.l   level_to_go,a0
                    clr.l    level_to_go
                    jmp      (a0)

check_players_invincibility:
                    tst.w    player_1_invincible
                    beq      player_1_not_invincible
                    move.w   #64,player_1_health
player_1_not_invincible:
                    tst.w    player_2_invincible
                    beq      player_2_not_invincible
                    move.w   #64,player_2_health
player_2_not_invincible:
                    rts

lbW00CEE2:          dc.w     $32

display_pause:      clr.w    lbW0004C2
                    clr.b    key_pressed
                    move.w   #10,lbW0001E2
                    move.w   #$32,lbW00CEE2
lbC00CF00:          btst     #4,player_2_input
                    bne.s    lbC00CF00
                    btst     #4,player_1_input
                    bne.s    lbC00CF00
                    lea      top_bar_gfx,a0
                    lea      player_1_status_bar,a1
                    move.l   #608,d0
                    jsr      copy_byte_array
                    lea      bottom_bar_gfx,a0
                    lea      player_2_status_bar,a1
                    move.l   #608,d0
                    jsr      copy_byte_array
                    lea      top_bar_gfx,a0
                    lea      bottom_bar_gfx,a0
                    move.l   #304,d0
lbC00CF56:          move.b   #$FF,(a0)+
                    move.b   #$FF,(a1)+
                    subq.w   #1,d0
                    bne.s    lbC00CF56
lbC00CF62:          lea      lbL099B34,a0
                    move.l   #304,d0
                    jsr      clear_array_byte
                    lea      lbL099D94,a0
                    move.l   #304,d0
                    jsr      clear_array_byte
                    move.l   #$19,d0
lbC00CF8C:          btst     #4,player_2_input
                    bne      remove_pause
                    btst     #4,player_1_input
                    bne      remove_pause
                    cmp.b    #KEY_P,key_pressed
                    beq      remove_pause
                    cmp.b    #$FF,$dff006
                    bne.s    lbC00CF8C
lbC00CFBA:          cmp.b    #$FE,$dff006
                    bne.s    lbC00CFBA
                    btst     #5,player_2_input
                    bne.s    lbC00CFDA
                    btst     #5,player_1_input
                    beq      lbC00CFE8
lbC00CFDA:          subq.w   #1,lbW00CEE2
                    bne.s    lbC00CFE8
                    jmp      trigger_game_over

lbC00CFE8:          subq.w   #1,d0
                    bne.s    lbC00CF8C
                    lea      game_paused_pic,a0
                    lea      lbB099B40,a1
                    lea      lbL099DA0,a2
                    move.l   #7,d0
lbC00D004:          move.l   (a0),(a1)
                    move.l   (a0)+,(a2)
                    move.l   (a0),4(a1)
                    move.l   (a0)+,4(a2)
                    move.l   (a0),8(a1)
                    move.l   (a0)+,8(a2)
                    add.l    #38,a1
                    add.l    #38,a2
                    subq.w   #1,d0
                    bne.s    lbC00D004
                    move.l   #$19,d0
lbC00D02E:          btst     #4,player_2_input
                    bne.s    remove_pause
                    btst     #4,player_1_input
                    bne.s    remove_pause
                    cmp.b    #KEY_P,key_pressed
                    beq      remove_pause
                    cmp.b    #$FF,$dff006
                    bne.s    lbC00D02E
lbC00D058:          cmp.b    #$FE,$dff006
                    bne.s    lbC00D058
                    btst     #5,player_2_input
                    beq.s    lbC00D084
                    btst     #5,player_1_input
                    beq.s    lbC00D084
                    subq.w   #1,lbW00CEE2
                    bne.s    lbC00D084
                    jmp      trigger_game_over

lbC00D084:          subq.w   #1,d0
                    bne.s    lbC00D02E
                    bra      lbC00CF62

remove_pause:       clr.b    key_pressed
lbC00D092:          btst     #4,player_2_input
                    bne.s    lbC00D092
                    btst     #4,player_1_input
                    bne.s    lbC00D092
                    lea      top_bar_gfx,a1
                    lea      player_1_status_bar,a0
                    move.l   #608,d0
                    jsr      copy_byte_array
                    lea      bottom_bar_gfx,a1
                    lea      player_2_status_bar,a0
                    move.l   #608,d0
                    jsr      copy_byte_array
                    move.w   #1,lbW0004C2
                    jmp      game_level_loop

                    incdir   "src/main/gfx/"
game_paused_pic:    incbin   "game_paused_96x7x1.raw"

lbC00D144:          move.l   a0,-(sp)
                    lea      lbW012A28,a0
                    clr.w    $1A(a0)
                    move.l   (sp)+,a0
                    rts

lbC00D154:          tst.w    player_2_alive
                    bpl      lbC00D168
                    move.l   #lbL00E9DE,lbL005D44
lbC00D168:          tst.w    player_1_alive
                    bpl      lbC00D17C
                    move.l   #lbL00E9DE,lbL0064E4
lbC00D17C:          rts

lbC00D17E:          move.w   lbW0035D6,d0
                    sub.w    #$50,d0
                    move.w   d0,d1
                    add.w    #$1E0,d1
                    move.w   lbW0035D2,d2
                    sub.w    #$50,d2
                    move.w   d2,d3
                    add.w    #$1A0,d3
                    lea      lbL00D29A,a0
                    bsr      lbC00D1B4
                    lea      lbL00D2AA,a0
                    bsr      lbC00D1B4
                    rts

lbC00D1B4:          tst.l    0(a0)
                    beq      return
                    move.w   4(a0),d4
                    cmp.w    d0,d4
                    bmi      lbC00D220
                    cmp.w    d1,d4
                    bpl      lbC00D220
                    move.w   6(a0),d4
                    cmp.w    d2,d4
                    bmi      lbC00D220
                    cmp.w    d3,d4
                    bpl      lbC00D220
                    subq.w   #1,8(a0)
                    bpl      return
                    move.l   12(a0),a1
                    move.w   $2C(a1),8(a0)
                    move.l   0(a0),a3
                    movem.l  d0-d3,-(sp)
                    jsr      lbC00A718
                    tst.w    play_alien_spawning_sample
                    beq.s    lbC00D21A
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #36,sample_to_play
                    jsr      trigger_sample
                    movem.l  (sp)+,d0-d7/a0-a6
lbC00D21A:          movem.l  (sp)+,d0-d3
                    rts

lbC00D220:          clr.l    0(a0)
                    rts

lbL00D226:          dc.l     0

lbC00D22A:          movem.l  d0-d7/a0-a6,-(sp)
                    bsr.s    lbC00D236
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC00D236:          lea      lbL00D29A(pc),a0
                    tst.l    0(a0)
                    beq.s    lbC00D24C
                    lea      lbL00D2AA(pc),a0
                    tst.l    0(a0)
                    bne      return
lbC00D24C:          cmp.l    lbL00D29A,a3
                    beq      return
                    cmp.l    lbL00D2AA,a3
                    beq      return
                    move.l   a3,0(a0)
                    move.l   a3,d1
                    sub.l    #cur_map_top,d1
                    divu     #248,d1
                    move.l   d1,d0
                    swap     d0
                    lsl.w    #3,d0
                    lsl.w    #4,d1
                    move.l   lbL00D226,a3
                    move.l   a3,12(a0)
                    add.w    $30(a3),d0
                    add.w    $32(a3),d1
                    move.w   d0,4(a0)
                    move.w   d1,6(a0)
                    move.w   #$14,8(a0)
                    rts

lbL00D29A:          dcb.l    2,0
                    dc.l     50,0
lbL00D2AA:          dcb.l    2,0
                    dc.l     50,0

lbC00D2BA:          lea      lbW008C9C,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    lea      lbW008CF6,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    lea      lbW008D50,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    lea      lbW008DAA,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    lea      lbW008E04,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    lea      lbW008E5E,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    lea      lbW008EB8,a0
                    move.l   0(a0),a2
                    bsr      lbC00A63A
                    rts

display_map_overview:
                    clr.w    lbW0004C2
                    move.w   #1,lbW0004D0
                    move.w   #1,lbW010CDE
                    lea      copper_main_palette,a0
                    move.l   #lbL0226EA,a1
                    jsr      lbC0108DA
                    move.l   #$20,d0
                    jsr      lbC010AA4
                    jsr      wait
                    lea      lbL0FE76C,a0
                    move.l   #$2800,d0
                    jsr      clear_array_long
                    bsr      set_map_overview_bps
                    bsr      load_map_overview
                    bsr      wait_raster
                    move.l   #copperlist_overmap,$dff080
                    lea      overmap_palette,a0
                    bsr      wait_raster
                    lea      lbL02266A,a1
                    move.l   #32,d0
                    jsr      lbC010906
                    lea      text_scanning,a0
                    lea      lbL00FA24,a1
                    jsr      display_text
                    move.b   $bfd800,d1
                    cmp.b    #$7F,d1
                    bpl      lbC00D3CA
                    bsr      get_map_overview_player_pos
lbC00D3CA:          jsr      wait
                    tst.w    self_destruct_initiated
                    bne      exit_map_overview
                    cmp.l    #1024,lbL000572
                    beq      exit_map_overview
                    lea      lbL0FCD7C,a0
                    move.l   #1280,d0
                    jsr      clear_array_long
                    bsr      plot_map_overview_data

.loop:              jsr      wait_raster
                    bsr      display_elapsed_time
                    
                    btst     #6,player_2_input
                    bne.s    lbC00D430
                    btst     #6,player_1_input
                    bne.s    lbC00D430
                    cmp.b    #KEY_M,key_pressed
                    bne.s    .loop

lbC00D426:          cmp.b    #KEY_M,key_pressed
                    beq.s    lbC00D426

lbC00D430:          btst     #6,player_2_input
                    bne.s    lbC00D430
                    btst     #6,player_1_input
                    bne.s    lbC00D430

exit_map_overview:  bsr      wait_raster
                    lea      overmap_palette,a0
                    lea      lbL02266A,a1
                    move.l   #32,d0
                    jsr      lbC010AA4
                    jsr      wait
                    jsr      lbC003954
                    bsr      wait_raster
                    move.l   #copperlist_main,$dff080
                    lea      copper_main_palette,a0
                    move.l   cur_palette_ptr,a1
                    move.l   #32,d0
                    jsr      lbC010906
                    jsr      lbC00D67A
                    clr.w    lbW0004D0
                    move.w   #1,lbW0004C2
                    jmp      game_level_loop

display_elapsed_time:
                    bsr      lbC00D4D4
                    jsr      calc_time
                    lea      text_time,a0
                    lea      lbL00FA24,a1
                    jsr      display_text
                    rts

lbC00D4D4:          jsr      wait_blitter
                    move.l   #$1000000,$dff040
                    clr.w    $dff066
                    move.l   #lbL0FE08C,$dff054
                    move.w   #(12*64)+20,$dff058
                    bsr      wait_blitter
                    rts

plot_map_overview_data:
                    lea      map_overview_planes,a5
                    lea      end_map_datas,a0
                    move.l   #248,d0
                    move.l   #202,d1
                    move.l   d0,d7
.loop:              clr.l    d6
                    move.w   -(a0),d2
                    and.w    #$3F,d2
                    cmp.w    #3,d2
                    bne.s    .door
                    move.l   #(256*40),d6   ; different plane for doors
.door:              tst.w    d2
                    beq.s    .no_block
                    cmp.w    #3,d2
                    beq.s    .wall
                    cmp.w    #1,d2
                    bne.s    .no_block
.wall:              move.l   d0,d4          ; four dots per tile
                    move.l   d1,d5
                    move.l   a5,a4
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    add.l    d6,a4
                    bset     d2,0(a4,d5.w)
                    bset     d2,40(a4,d5.w)
                    move.l   d0,d4
                    move.l   d1,d5
                    move.l   a5,a4
                    addq.w   #1,d4
                    mulu     #40,d5
                    add.l    d5,a4
                    move.w   d4,d5
                    lsr.w    #3,d5
                    and.w    #7,d4
                    move.w   #7,d2
                    sub.w    d4,d2
                    add.l    d6,a4
                    bset     d2,0(a4,d5.w)
                    bset     d2,40(a4,d5.w)
.no_block:          subq.w   #2,d0
                    bne.s    .loop
                    move.l   d7,d0
                    subq.w   #2,d1
                    bne.s    .loop
                    bsr      print_players_pos_on_map
                    rts

text_scanning:      dc.w     100
                    dc.w     100
                    dc.b     'SCANNING...'
                    dc.b     -1
                    even

get_map_overview_player_pos:
                    lea      player_1_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bpl.s    lbC00D5C0
                    lea      player_2_dats,a0
lbC00D5C0:          move.w   start_pos_x,d0
                    move.w   start_pos_y,d1
                    move.w   PLAYER_POS_X(a0),d2
                    move.w   PLAYER_POS_Y(a0),d3
                    sub.w    d0,d2
                    tst.w    d2
                    bpl.s    lbC00D5DC
                    neg.w    d2
lbC00D5DC:          sub.w    d1,d3
                    tst.w    d3
                    bpl.s    lbC00D5E4
                    neg.w    d3
lbC00D5E4:          cmp.w    d2,d3
                    bpl.s    lbC00D5EA
                    move.w   d2,d3
lbC00D5EA:          ext.l    d3
                    lsr.l    #4,d3
                    cmp.w    #150,d3
                    bmi.s    lbC00D5F8
                    move.w   #150,d3
lbC00D5F8:          tst.l    d3
                    beq      return
                    move.l   d3,d0
                    move.l   d0,lbL000520
                    bsr      display_map_overview_interference
                    rts

display_map_overview_interference:
                    move.l   d0,-(sp)
                    move.l   #74,d0
                    move.l   #0,d2
                    jsr      trigger_sample_select_channel
                    move.l   (sp)+,d0
.loop:              bsr      wait_line_44
                    move.b   $bfd800,d1
                    ext.w    d1
                    move.b   d1,diwstop_overmap
                    neg.w    d1
                    move.b   d1,diwstrt_overmap
                    subq.l   #1,d0
                    bne.s    .loop
                    move.w   #$2B8E,diwstrt_overmap
                    move.w   #$2DB3,diwstop_overmap
                    move.l   #75,d0
                    move.l   #0,d2
                    jsr      trigger_sample_select_channel
                    rts

wait_line_44:       cmp.b    #255,$dff006
                    bne.s    wait_line_44
.wait:              cmp.b    #44,$dff006
                    bne.s    .wait
                    rts

lbC00D67A:          rts

print_players_pos_on_map:
                    bsr      get_players_position
                    lea      text_player_1,a0
                    move.w   player_1_pos_x_map,d0
                    move.w   player_1_pos_y_map,d1
                    bsr      print_player_pos_on_map
                    lea      text_player_2,a0
                    move.w   player_2_pos_x_map,d0
                    move.w   player_2_pos_y_map,d1
                    bsr      print_player_pos_on_map
                    rts

print_player_pos_on_map:
                    tst.w    d0
                    beq      return
                    add.w    #18,d0
                    sub.w    #16,d1
                    move.w   d0,(a0)
                    move.w   d1,2(a0)
                    lea      on_map_font_struct,a1
                    jmp      display_text

text_player_1:      dc.w     0,0
                    dc.b     '1'
                    dc.b     -1
                    even
text_player_2:      dc.w     0,0
                    dc.b     '2'
                    dc.b     -1
                    even

on_map_font_struct: dc.l    lbL0FE744
                    dc.l    10240
                    dc.l    1
                    dc.l    36
                    dc.l    9
                    dc.l    12
                    dc.l    80
                    dc.l    1008
                    dc.l    font_pic
                    dc.l    ascii_letters

get_players_position:
                    lea      player_1_dats,a0
                    clr.l    d0
                    clr.l    d1
                    cmp.w    #-1,PLAYER_ALIVE(a0)
                    beq.s    .p1_not_alive
                    move.w   PLAYER_POS_X(a0),d0
                    move.w   PLAYER_POS_Y(a0),d1
                    lsr.w    #3,d0
                    lsr.w    #3,d1
                    add.w    #24,d0
                    add.w    #20,d1
.p1_not_alive:      move.w   d0,player_1_pos_x_map
                    move.w   d1,player_1_pos_y_map
                    lea      player_2_dats,a0
                    clr.l    d0
                    clr.l    d1
                    cmp.w    #-1,PLAYER_ALIVE(a0)
                    beq.s    .p2_not_alive
                    move.w   PLAYER_POS_X(a0),d0
                    move.w   PLAYER_POS_Y(a0),d1
                    lsr.w    #3,d0
                    lsr.w    #3,d1
                    add.w    #24,d0
                    add.w    #20,d1
.p2_not_alive:      move.w   d0,player_2_pos_x_map
                    move.w   d1,player_2_pos_y_map
                    rts

player_1_pos_x_map: dc.w     0
player_1_pos_y_map: dc.w     0
player_2_pos_x_map: dc.w     0
player_2_pos_y_map: dc.w     0

set_map_overview_bps:
                    move.l   #(256*40),d0
                    move.l   #6,d1
                    lea      map_overview_background_pic,a0
                    lea      overmap_bps,a1
                    bsr      set_bps
                    move.l   #304,d0
                    move.l   #2,d1
                    lea      top_bar_gfx,a0
                    lea      overmap_top_bar_bps,a1
                    bsr      set_bps
                    move.l   #304,d0
                    move.l   #2,d1
                    lea      bottom_bar_gfx,a0
                    lea      overmap_bottom_bar_bps,a1
                    bsr      set_bps
                    rts

load_map_overview:  lea      map_overview_background_pic,a0
                    move.l   #720,d0
                    jsr      clear_array_long
                    lea      pic_mapbkgnd,a0
                    lea      map_overview_background_pic,a1
                    jsr      load_file
                    lea      lbL0FBF6C,a0                           ; retrieve the palette
                    lea      lbL02266A,a1
                    move.l   #16,d0
.copy_palette:      move.w   (a0)+,(a1)+
                    subq.l   #1,d0
                    bne.s    .copy_palette
                    lea      map_overview_overlay_palette,a0        ; overlay palette
                    move.l   #16,d0
.copy_overlay_palette:
                    move.w   (a0)+,(a1)+
                    subq.w   #1,d0
                    bne.s    .copy_overlay_palette
                    lea      overmap_palette+2,a0
                    move.l   #32,d0
.clear_palette:     clr.w    (a0)
                    addq.l   #4,a0
                    subq.w   #1,d0
                    bne.s    .clear_palette
                    lea      lbL0FBF6C,a0
                    move.l   #(256*40),d0
                    jsr      clear_array_long
                    rts

map_overview_overlay_palette:
                    dc.w     $346,$457,$556,$568,$866,$679,$976,$B76,$78A,$C86
                    dc.w     $D96,$FD6,$FFB,$89B,$9AC,$ABD

lbC00D8E2:          clr.l    run_intex_ptr
                    rts

run_intex:          tst.w    self_destruct_initiated
                    bne      lbC00D8E2
                    jsr      lbC023210
                    clr.w    lbW0004C2
                    move.w   #1,lbW0004D0
                    move.w   #13,sample_to_play
                    jsr      trigger_sample
                    lea      copper_main_palette,a0
                    lea      lbL0226EA,a1
                    jsr      lbC0108DA
                    move.l   #$20,d0
                    move.w   #1,lbW010CDE
                    jsr      lbC010AA4
                    jsr      wait
                    move.l   #copper_blank,$dff080
                    lea      exe_intex,a0
                    lea      temp_buffer,a1
                    jsr      load_exe
                    move.l   player_using_intex,a0
                    move.l   PLAYER_SHOTS(a0),intex_shots_fired
                    move.w   PLAYER_AMMOPACKS(a0),intex_ammopacks+2
                    move.w   PLAYER_HEALTH(a0),intex_health+2
                    move.l   PLAYER_CUR_WEAPON(a0),intex_cur_weapon
                    move.l   PLAYER_SCORE(a0),lbL000518
                    clr.l    d0
                    clr.l    d1
                    move.w   PLAYER_POS_X(a0),d0
                    move.w   PLAYER_POS_Y(a0),d1
                    add.w    #$20,d0
                    add.w    #$10,d1
                    move.l   0(a0),a1
                    clr.l    d2
                    move.w   PLAYER_OWNEDWEAPONS(a0),d2
                    move.w   d2,lbW00DC04
                    lea      key_pressed,a2
                    move.l   cur_briefing_text,a3
                    lea      cur_map_top,a4
                    lea      trigger_sample_select_channel,a5
                    lea      lbC02325A,a6
                    move.l   PLAYER_CREDITS(a0),d7
                    tst.w    share_credits
                    beq.s    lbC00DA06
                    cmp.l    #1,number_players
                    beq.s    lbC00DA06
                    move.l   player_1_credits,d7
                    add.l    player_2_credits,d7
lbC00DA06:          lea      cur_credits,a0
                    ifne DEBUG
                    move.l   #1000000000,d7
                    endif
                    move.l   d7,(a0)
                    lea      cur_credits,a0
                    jsr      temp_buffer                            ; run the prog
                    move.l   #copper_blank,$dff080
                    movem.l  d0-d7/a0-a6,-(sp)
                    bsr      lbC00B6B2
                    movem.l  (sp)+,d0-d7/a0-a6
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbL1101C4,a0
                    move.l   #15360,d0
                    bsr      clear_array_long
                    lea      aliens_sprites_block,a0
                    lea      lbL1101C4,a1
                    move.l   #5,d0
                    move.l   #320,d1
                    move.l   #384,d2
                    bsr      lbC01176E
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   player_using_intex,a0
                    tst.l    level_to_go
                    bne.s    lbC00DABA
                    tst.w    share_credits
                    beq.s    lbC00DAB2
                    cmp.l    #1,number_players
                    beq.s    lbC00DAB2
                    move.l   cur_credits,d7
                    lsr.l    #1,d7
                    move.l   d7,player_1_credits
                    move.l   d7,player_2_credits
                    bra.s    lbC00DABA

lbC00DAB2:          move.l   cur_credits,PLAYER_CREDITS(a0)
lbC00DABA:          move.w   d1,d2
                    tst.w    d1
                    beq      lbC00DB44
                    move.w   d2,d1
                    and.w    #SUPPLY_MAP_OVERVIEW,d1
                    cmp.w    #SUPPLY_MAP_OVERVIEW,d1
                    bne.s    lbC00DAD6                      ; did the player purchase the map service ?
                    move.w   #1,map_overview_on
lbC00DAD6:          move.w   d2,d1
                    and.w    #SUPPLY_AMMO_CHARGE,d1
                    cmp.w    #SUPPLY_AMMO_CHARGE,d1
                    bne.s    lbC00DAFA
                    move.w   #32,PLAYER_AMMUNITIONS(a0)
                    addq.w   #2,PLAYER_AMMOPACKS(a0)
                    cmp.w    #4,PLAYER_AMMOPACKS(a0)
                    bmi.s    lbC00DAFA
                    move.w   #4,PLAYER_AMMOPACKS(a0)
lbC00DAFA:          move.w   d2,d1
                    and.w    #SUPPLY_NRG_INJECT,d1
                    cmp.w    #SUPPLY_NRG_INJECT,d1
                    bne.s    lbC00DB24
                    move.w   PLAYER_HEALTH(a0),d3
                    cmp.w    #$40,d3
                    bpl      lbC00DB20
                    add.w    #$14,d3
                    cmp.w    #$41,d3
                    bmi.s    lbC00DB20
                    move.w   #$40,d3
lbC00DB20:          move.w   d3,PLAYER_HEALTH(a0)
lbC00DB24:          move.w   d2,d1
                    and.w    #SUPPLY_KEY_PACK,d1
                    cmp.w    #SUPPLY_KEY_PACK,d1
                    bne.s    lbC00DB34
                    addq.w   #6,PLAYER_KEYS(a0)
lbC00DB34:          move.w   d2,d1
                    and.w    #SUPPLY_EXTRA_LIFE,d1
                    cmp.w    #SUPPLY_EXTRA_LIFE,d1
                    bne.s    lbC00DB44
                    addq.w   #1,PLAYER_LIVES(a0)
lbC00DB44:          move.w   d0,PLAYER_OWNEDWEAPONS(a0)
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.w   lbW00DC04,d1
                    cmp.w    d0,d1
                    beq.s    lbC00DB8E
                    move.l   player_using_intex,a0
                    not.w    d1
                    and.w    d1,d0
                    or.w     #2,d0
                    move.w   PLAYER_OWNEDWEAPONS(a0),-(sp)
                    move.w   d0,PLAYER_OWNEDWEAPONS(a0)
                    movem.l  d0-d7/a0-a6,-(sp)
                    cmp.l    #player_1_dats,a0
                    bne.s    lbC00DB80
                    jsr      player_1_select_weapon
                    bra.s    lbC00DB86

lbC00DB80:          jsr      player_2_select_weapon
lbC00DB86:          movem.l  (sp)+,d0-d7/a0-a6
                    move.w   (sp)+,PLAYER_OWNEDWEAPONS(a0)
lbC00DB8E:          movem.l  (sp)+,d0-d7/a0-a6
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #40,d0
                    move.l   #3,d2
                    jsr      trigger_sample_select_channel
                    movem.l  (sp)+,d0-d7/a0-a6
                    jsr      lbC003954
                    lea      copper_main_palette,a0
                    move.l   cur_palette_ptr,a1
                    move.l   #32,d0
                    move.w   #1,lbW010CDE
                    bsr      lbC010906
                    bsr      wait_raster
                    move.l   #copperlist_main,$dff080
                    jsr      wait
                    jsr      lbC023210
                    clr.w    lbW0004D0
                    move.w   #1,lbW0004C2
                    rts

lbW00DC04:          dc.w     0

set_main_copperlist:
                    move.w   #$81C0,$dff096
                    move.l   #copperlist_main,$dff080
                    move.l   #copper_blank,$dff084
                    rts

lbC00DC62:          tst.l    flag_destruct_level
                    beq      return
                    jmp      do_level_destruction

lbW00DC72:          dc.w     0
lbW00DC74:          dc.w     0

do_level_destruction:
                    clr.w    lbW0004C2
                    clr.w    lbW00DC72
                    clr.w    lbW00DC74
                    bsr      lbC00DF6A
                    move.w   #16,lbW00DF30
                    clr.w    lbW00DF2E
                    clr.l    lbL00DF52
                    move.l   #16,d0
                    move.l   #1,d1
                    bsr      lbC00DDB8
                    move.l   #14,d0
                    move.l   #2,d1
                    bsr      lbC00DDB8
                    move.l   #12,d0
                    move.l   #3,d1
                    move.l   cur_palette_ptr,a0
                    lea      lbW02276A,a1
                    lea      copper_main_palette,a2
                    move.w   #4,lbW010CDE
                    move.l   #32,d0
                    jsr      compute_palette_fading_directions
                    bsr      lbC00DDB8
                    move.l   #10,d0
                    move.l   #4,d1
                    bsr      lbC00DDB8

                    jsr      wait

                    move.w   #$20,sprites_dma
                    lea      lbW02276A,a0
                    lea.l    level_palette2,a1
                    lea      copper_main_palette,a2
                    move.w   #2,lbW010CDE
                    move.l   #32,d0
                    jsr      compute_palette_fading_directions
                    lea      lbL0226EA,a0
                    jsr      lbC0108DA
                    move.l   #$40,d0
                    jsr      clear_array_byte
                    move.w   #$96,d0
                    move.w   #1,lbW00DF2E
                    move.l   #lbW013308,lbL00DF52
lbC00DD6A:          move.w   d0,-(sp)
                    bsr      lbC00DE18
                    move.w   (sp)+,d0
                    subq.w   #1,d0
                    bpl.s    lbC00DD6A
                    lea.l    level_palette2,a0
                    lea      lbL0226EA,a1
                    jsr      lbC0108DA
                    lea      copper_main_palette,a2
                    move.w   #3,lbW010CDE
                    move.l   #32,d0
                    jsr      compute_palette_fading_directions

lbC00DDA2:          bsr      lbC00DE18
                    tst.w    some_variable
                    beq.s    lbC00DDA2

                    move.w   #$8020,sprites_dma
                    rts

lbC00DDB8:          cmp.w    #1,lbW00DC72
                    beq.s    lbC00DDE2
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #lbW0231BA,lbL023200
                    clr.w    lbW023204
                    move.w   #1,lbW00DC72
                    movem.l  (sp)+,d0-d7/a0-a6
lbC00DDE2:          add.l    d1,map_pos_x
                    add.l    d1,map_pos_y
                    movem.l  d0/d1,-(sp)
                    bsr      lbC00DE18
                    movem.l  (sp)+,d0/d1
                    sub.l    d1,map_pos_x
                    sub.l    d1,map_pos_y
                    movem.l  d0/d1,-(sp)
                    bsr      lbC00DE18
                    movem.l  (sp)+,d0/d1
                    subq.l   #1,d0
                    bne.s    lbC00DDB8
                    rts

lbC00DE18:          cmp.b    #$FF,$dff006
                    bne.s    lbC00DE18
lbC00DE22:          cmp.b    #$2C,$dff006
                    bne.s    lbC00DE22
                    jsr      lbC00DE46
                    jsr      scroll_map
                    jsr      lbC011860
                    jsr      lbC00167C
                    rts

lbC00DE46:          subq.w   #1,lbW00DF30
                    bne      return
                    move.w   #10,lbW00DF30
                    move.l   lbL00DF32,a0
                    tst.l    (a0)
                    bne.s    lbC00DE6E
                    lea      lbL00DF36,a0
                    move.l   a0,lbL00DF32
lbC00DE6E:          addq.l   #4,lbL00DF32
                    move.l   (a0),a1
                    move.l   #lbL018C2E,$28(a1)
                    tst.w    lbW00DF2E
                    beq      return
                    move.w   #1,lbW00DF30
                    move.w   #256,d0
                    move.l   a1,-(sp)
                    bsr      rand
                    move.l   (sp)+,a1
                    add.w    lbW0035D6,d0
                    move.w   d0,-4(a1)
                    move.w   #$E0,d0
                    move.l   a1,-(sp)
                    bsr      rand
                    move.l   (sp)+,a1
                    add.w    lbW0035D2,d0
                    move.w   d0,-2(a1)
                    addq.w   #1,lbW00DC74
                    cmp.w    #4,lbW00DC74
                    bne      return
                    clr.w    lbW00DC74
                    movem.l  d0-d7/a0-a6,-(sp)

                    move.l   #2,d0
                    jsr      rand
                    clr.l    lbL023200
                    cmp.w    #0,d0
                    beq      lbC00DEFE
                    cmp.w    #1,d0
                    beq.s    lbC00DF0A
                    cmp.w    #2,d0
                    beq.s    lbC00DF16
lbC00DEFE:          move.w   #10,sample_to_play
                    bra      lbC00DF22

lbC00DF0A:          move.w   #10,sample_to_play
                    bra      lbC00DF22

lbC00DF16:          move.w   #11,sample_to_play
                    bra      lbC00DF22

lbC00DF22:          jsr      trigger_sample
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbW00DF2E:          dc.w     0
lbW00DF30:          dc.w     $10
lbL00DF32:          dc.l     lbL00DF36
lbL00DF36:          dc.l     lbW012B44
                    dc.l     lbW012C60
                    dc.l     lbW012D7C
                    dc.l     lbW012E98
                    dc.l     lbW012FB4
                    dc.l     lbW0130D0
                    dc.l     lbW0131EC
lbL00DF52:          dc.l     0
                    dc.l     lbW013424
                    dc.l     lbW013540
                    dc.l     lbW01365C
                    dc.l     lbW013778
                    dc.l     0

lbC00DF6A:          lea      lbL00DF82,a0
                    lea      lbW013890,a1
lbC00DF76:          move.l   (a0)+,a2
                    move.l   a1,$28(a2)
                    tst.l    (a0)
                    bne.s    lbC00DF76
                    rts

lbL00DF82:          dc.l     lbW013308
                    dc.l     lbW013424
                    dc.l     lbW013540
                    dc.l     lbW01365C
                    dc.l     lbW013778
                    dc.l     lbL012380
                    dc.l     lbW01249C
                    dc.l     lbW0125B8
                    dc.l     lbW0126D4
                    dc.l     lbW0127F0
                    dc.l     lbW01290C
                    dc.l     lbW012A28
                    dc.l     0

lbC00DFEE:          move.l   #$4B00,d0
lbC00DFF4:          clr.l    (a0)+
                    subq.l   #1,d0
                    bne.s    lbC00DFF4
                    rts

get_rnd_number:     movem.l  d2/d3,-(sp)
                    movem.l  (random_seed),d0/d1
                    and.b    #14,d0
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
                    movem.l  d0/d1,random_seed
                    move.l   d1,d0
                    movem.l  (sp)+,d2/d3
                    rts

rand:               addq.w   #1,d0
                    move.w   d0,d2
                    beq.s    lbC00E062
                    bsr.s    get_rnd_number
                    clr.w    d0
                    swap     d0
                    divu     d2,d0
                    clr.w    d0
                    swap     d0
lbC00E062:          rts

random_seed:        dcb.l    2,0

get_alien_rnd_speed:
                    jsr      rand
                    addq.w   #1,d0
                    move.w   d0,cur_aliens_speed
                    rts

cur_aliens_speed:   dc.w     0

lbC00E08A:          cmp.w    #$8000,$168(a0)
                    beq.s    lbC00E096
                    subq.w   #1,$168(a0)
lbC00E096:          rts

lbC00E098:          subq.w   #1,lbW0004E4
                    bpl      return
                    clr.w    PLAYER_AMMUNITIONS(a0)
                    move.w   #4,lbW0004E4
                    move.w   #$2F,d0
                    move.w   #1,d2
                    tst.w    lbW00057A
                    bne.s    lbC00E0C2
                    move.w   #2,d2
lbC00E0C2:          jmp      trigger_sample_select_channel

lbC00E0C8:          subq.w   #1,$168(a0)
                    tst.w    $168(a0)
                    bpl      return
                    cmp.w    #1,PLAYER_AMMOPACKS(a0)
                    bpl.s    lbC00E136
                    tst.w    $1A4(a0)
                    bne.s    lbC00E13A
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      lbL02312E,a6
                    move.w   #$3B,lbW02314E
                    move.w   #$41,lbW02313A
                    cmp.l    #player_1_dats,a0
                    beq      lbC00E118
                    move.w   #$42,lbW02313A
lbC00E118:          jsr      lbC02325A
                    tst.w    lbW02328A
                    beq      lbC00E12E
                    move.w   #1,$1A4(a0)
lbC00E12E:          movem.l  (sp)+,d0-d7/a0-a6
                    bra      lbC00E13A

lbC00E136:          clr.w    $1A4(a0)
lbC00E13A:          cmp.w    #2,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC00E14A
                    tst.w    PLAYER_AMMOPACKS(a0)
                    beq      lbC00E098
lbC00E14A:          addq.l   #1,PLAYER_SHOTS(a0)
                    subq.w   #1,$18A(a0)
                    bpl.s    lbC00E178
                    move.w   $18E(a0),$18A(a0)
                    subq.w   #1,PLAYER_AMMUNITIONS(a0)
                    cmp.w    #1,PLAYER_AMMUNITIONS(a0)
                    bpl.s    lbC00E178
                    tst.w    PLAYER_AMMOPACKS(a0)
                    beq      lbC00E098
                    subq.w   #1,PLAYER_AMMOPACKS(a0)
                    move.w   #32,PLAYER_AMMUNITIONS(a0)
lbC00E178:          clr.l    d0
                    move.w   $180(a0),d0
                    move.w   #1,d2
                    tst.w    lbW00057A
                    bne.s    lbC00E18E
                    move.w   #2,d2
lbC00E18E:          jsr      trigger_sample_select_channel
                    move.w   $106(a0),$168(a0)
                    move.l   $F4(a0),a2
                    tst.l    (a2)
                    bne.s    lbC00E1AA
                    move.l   $F8(a0),a2
                    move.l   a2,$F4(a0)
lbC00E1AA:          addq.l   #4,$F4(a0)
                    move.l   (a2),a3
                    lea      lbW00E9F6,a2
                    move.w   PLAYER_CUR_SPRITE(a0),d2
                    add.w    d2,d2
                    add.w    d2,d2
                    move.w   0(a2,d2.w),d4
                    move.w   2(a2,d2.w),d5
                    move.l   $FC(a0),d1
                    tst.l    lbW0039B4
                    beq.s    lbC00E1DC
                    cmp.w    #5,$102(a0)
                    bne.s    lbC00E1DC
                    addq.l   #4,d1
lbC00E1DC:          move.w   d4,d6
                    move.w   d5,d7
                    mulu     d1,d4
                    mulu     d1,d5
                    cmp.w    #3,$102(a0)
                    beq.s    lbC00E200
                    add.w    d6,d6
                    add.w    d7,d7
                    cmp.w    #4,$102(a0)
                    beq.s    lbC00E200
                    cmp.w    #6,$102(a0)
                    bne.s    lbC00E21E
lbC00E200:          lea      lbL00EAA6(pc),a1
                    addq.w   #1,(a1)
                    cmp.w    #1,(a1)
                    beq.s    lbC00E21E
                    cmp.w    #3,(a1)
                    beq.s    lbC00E218
                    add.w    d7,d4
                    sub.w    d6,d5
                    bra.s    lbC00E21E

lbC00E218:          sub.w    d7,d4
                    add.w    d6,d5
                    clr.w    (a1)
lbC00E21E:          move.w   d4,4(a3)
                    move.w   d5,6(a3)
                    move.w   $10A(a0),$10(a3)
                    move.w   $10E(a0),$12(a3)
                    move.l   a0,$14(a3)
                    lea      lbL00EAAA(pc),a2
                    move.w   $102(a0),d3
                    add.w    d3,d3
                    add.w    d3,d3
                    move.l   0(a2,d3.w),a2
                    move.l   0(a2,d2.w),a4
                    move.l   8(a3),a1
                    move.l   a4,$28(a1)
                    lea      lbW00EA3E(pc),a2
                    cmp.w    #2,$102(a0)
                    bpl.s    lbC00E264
                    add.l    #$20,a2
lbC00E264:          move.l   $10(a0),a4
                    move.l   -4(a4),d1
                    move.l   0(a2,d2.w),d2
                    add.w    d2,d1
                    swap     d2
                    swap     d1
                    add.w    d2,d1
                    swap     d1
                    move.l   d1,0(a3)
                    move.l   d1,0(a1)
                    move.w   PLAYER_CUR_SPRITE(a0),12(a3)
                    rts

calc_shot_impact:   move.w   d2,d1
                    swap     d2
                    lea      lbW00EA82,a4
                    move.w   12(a3),d0
                    add.w    d0,d0
                    add.w    d0,d0
                    add.w    0(a4,d0.w),d2
                    add.w    2(a4,d0.w),d1
                    lsr.w    #4,d2
                    lsr.w    #4,d1
                    add.w    d2,d2
                    add.w    d1,d1
                    add.w    d1,d1
                    lea      map_lines_table+4,a5
                    move.l   0(a5,d1.w),a5
                    add.w    d2,a5
                    move.w   (a5),d2
                    and.l    #$3F,d2
                    add.w    d2,d2
                    add.w    d2,d2
                    lea      weapons_special_impact_table(pc),a6
                    jmp      0(a6,d2.w)

                    rts                             ; dunno, maybe there's a negative offset ?

weapons_special_impact_table:
                    bra.w    impact_none                            ; 0x00
                    bra.w    impact_on_wall
                    bra.w    impact_none
                    bra.w    impact_on_door
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x05
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    patch_fire_door_left_btn
                    bra.w    patch_fire_door_right_btn
                    bra.w    impact_none                            ; 0x0a
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x10
                    bra.w    impact_none
                    bra.w    patch_fire_door_left_btn_alarm
                    bra.w    patch_fire_door_right_btn_alarm
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x15
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    lbC00E83E
                    bra.w    lbC00E864                              ; 0x1a
                    bra.w    lbC00E88A
                    bra.w    lbC00E8B0
                    bra.w    impact_on_wall
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x20
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_on_wall
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x25
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    patch_reactor_up                       ; 0x2a
                    bra.w    patch_reactor_left
                    bra.w    patch_reactor_down
                    bra.w    patch_reactor_right
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x30
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x35
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x3a
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none
                    bra.w    impact_none                            ; 0x3f

impact_none:        rts

patch_reactor_up:   addq.w   #1,reactor_up_done
                    cmp.w    #6,reactor_up_done
                    bmi      impact_on_wall
                    beq.s    .not_done
                    tst.w    reactor_up_done
                    bne      impact_on_wall
.not_done:          move.l   #map_reactor_up,reactor_to_patch
                    bra      check_reactors

patch_reactor_left: addq.w   #1,reactor_left_done
                    cmp.w    #6,reactor_left_done
                    bmi      impact_on_wall
                    beq.s    .not_done
                    tst.w    reactor_left_done
                    bne      impact_on_wall
.not_done:          move.l   #map_reactor_left,reactor_to_patch
                    bra      check_reactors

patch_reactor_down: addq.w   #1,reactor_down_done
                    cmp.w    #6,reactor_down_done
                    bmi      impact_on_wall
                    beq.s    .not_done
                    tst.w    reactor_down_done
                    bne      impact_on_wall
.not_done:          move.l   #map_reactor_down,reactor_to_patch
                    bra      check_reactors

patch_reactor_right:
                    addq.w   #1,reactor_right_done
                    cmp.w    #6,reactor_right_done
                    bmi      impact_on_wall
                    beq.s    .not_done
                    tst.w    reactor_right_done
                    bne      impact_on_wall
.not_done:          move.l   #map_reactor_right,reactor_to_patch
                    bra      check_reactors

check_reactors:     tst.w    reactor_up_done
                    beq.s    patch_reactor
                    tst.w    reactor_left_done
                    beq.s    patch_reactor
                    tst.w    reactor_down_done
                    beq.s    patch_reactor
                    tst.w    reactor_right_done
                    beq.s    patch_reactor
                    move.w   #1,lbW0004D8
                    move.w   #1,self_destruct_initiated

patch_reactor:      movem.l  d0-d7/a0-a6,-(sp)
                    move.l   reactor_to_patch,a3
                    lea      patch_dat_reactors,a2
                    jsr      patch_tiles
                    move.w   #11,sample_to_play
                    jsr      trigger_sample
                    movem.l  (sp)+,d0-d7/a0-a6
                    bra      impact_on_wall

reactor_to_patch:   dc.l     0
reactor_up_done:    dc.w     0
reactor_left_done:  dc.w     0
reactor_down_done:  dc.w     0
reactor_right_done: dc.w     0
lbW00E4EA:          dc.w     0
lbL00E4EC:          dc.l     0
lbW00E4F0:          dc.w     0

impact_on_door:     movem.l  d0-d7/a0-a6,-(sp)
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #4,sample_to_play
                    jsr      trigger_sample
                    movem.l  (sp)+,d0-d7/a0-a6
                    cmp.l    lbL00E4EC,a5
                    beq.s    lbC00E520
                    move.l   a5,lbL00E4EC
                    clr.w    lbW00E4EA

lbC00E520:          move.w   $10(a3),d0
                    add.w    d0,lbW00E4EA
                    addq.w   #1,lbW00E4F0
                    cmp.w    #1,lbW00E4F0
                    bmi.s    lbC00E556
                    clr.w    lbW00E4F0
                    move.l   $14(a3),a4
                    sub.w    #1,PLAYER_AMMUNITIONS(a4)
                    cmp.w    #1,PLAYER_AMMUNITIONS(a4)
                    bpl.s    lbC00E556
                    clr.w    PLAYER_AMMUNITIONS(a4)
lbC00E556:          cmp.w    #300,lbW00E4EA
                    bmi.s    lbC00E576
                    clr.w    lbW00E4EA
                    move.l   $14(a3),a0
                    addq.w   #1,PLAYER_KEYS(a0)
                    move.l   a5,a3
                    jsr      lbC007F3E
lbC00E576:          movem.l  (sp)+,d0-d7/a0-a6

impact_on_wall:     move.l   8(a3),a1
                    cmp.l    #lbL00EC36,8(a1)
                    beq.s    lbC00E5A0
                    cmp.l    #lbL00EDCE,8(a1)
                    bmi      lbC00E6A8
                    cmp.l    #lbL00EE22,8(a1)
                    bhi      lbC00E6A8
lbC00E5A0:          addq.w   #1,$18(a3)
                    cmp.l    #lbL00EC36,8(a1)
                    bne.s    lbC00E5BA
                    cmp.w    #2,$18(a3)
                    bpl      lbC00E6A8
                    bra.s    lbC00E5C4

lbC00E5BA:          cmp.w    #6,$18(a3)
                    bpl      lbC00E6A8
lbC00E5C4:          tst.w    4(a3)
                    bmi.s    lbC00E5FE
                    tst.w    lbW00057A
                    bne.s    lbC00E5E8
                    movem.l  d0/d2,-(sp)
                    move.w   #46,d0
                    move.w   #1,d2
                    jsr      trigger_sample_select_channel
                    movem.l  (sp)+,d0/d2
lbC00E5E8:          move.l   a5,a4
                    move.w   -2(a4),d4
                    and.w    #$3F,d4
                    cmp.w    #1,d4
                    bne.s    lbC00E612
                    neg.w    6(a3)
                    bra.s    lbC00E612

lbC00E5FE:          move.l   a5,a4
                    move.w   2(a4),d4
                    and.w    #$3F,d4
                    cmp.w    #1,d4
                    bne.s    lbC00E612
                    neg.w    6(a3)
lbC00E612:          tst.w    6(a3)
                    bmi.s    lbC00E632
                    move.l   a5,a4
                    add.l    #$F8,a4
                    move.w   (a4),d4
                    and.w    #$3F,d4
                    cmp.w    #1,d4
                    bne.s    lbC00E64A
                    neg.w    4(a3)
                    bra.s    lbC00E64A

lbC00E632:          move.l   a5,a4
                    sub.l    #$F8,a4
                    move.w   (a4),d4
                    and.w    #$3F,d4
                    cmp.w    #1,d4
                    bne.s    lbC00E64A
                    neg.w    4(a3)
lbC00E64A:          neg.w    lbW0004D6
                    tst.w    4(a3)
                    bne.s    lbC00E65E
                    move.w   lbW0004D6,4(a3)
lbC00E65E:          tst.w    6(a3)
                    bne.s    lbC00E66C
                    move.w   lbW0004D6,6(a3)
lbC00E66C:          cmp.l    #lbL00EC36,8(a1)
                    beq      return
                    move.l   4(a3),d0
                    lea      lbW00EA1E,a2
                    lea      lbL00EDAA,a4
                    clr.w    d1
lbC00E68A:          addq.w   #4,a4
                    addq.w   #1,d1
                    cmp.w    #8,d1
                    beq.s    lbC00E698
                    cmp.l    (a2)+,d0
                    bne.s    lbC00E68A
lbC00E698:          move.l   8(a3),a2
                    move.l   (a4),$28(a2)
                    move.w   #1,12(a3)
                    rts

lbC00E6A8:          clr.w    $18(a3)
                    move.w   #$7D00,0(a3)
                    move.l   8(a3),a4
                    move.w   #$7D00,0(a4)
                    move.l   #lbL018CBA,$28(a4)
                    rts

patch_fire_door_left_btn:
                    move.w   #23,sample_to_play
                    jsr      trigger_sample
                    move.l   a5,a3
                    lea      lbL020D92,a2
                    bsr      patch_tiles
                    add.l    #6,a3
                    lea      lbL020E3A,a2
                    bsr      patch_tiles
                    sub.l    #2,a3
                    lea      lbL020DE2,a2
                    jsr      patch_tiles
                    add.l    #4,a3
                    lea      lbL020DBE,a2
                    bra      patch_tiles

patch_fire_door_right_btn:
                    move.l   a5,a3
                    move.w   #23,sample_to_play
                    jsr      trigger_sample
                    lea      lbL020D92,a2
                    bsr      patch_tiles
                    subq.l   #2,a3
                    lea      lbL020E3A,a2
                    bsr      patch_tiles
                    subq.l   #2,a3
                    lea      lbL020DE2,a2
                    jsr      patch_tiles
                    sub.l    #4,a3
                    lea      lbL020DBE,a2
                    bra      patch_tiles

lbL00E756:          dc.l     0

patch_fire_door_left_btn_alarm:
                    move.w   #23,sample_to_play
                    jsr      trigger_sample
                    cmp.l    lbL00E756,a5
                    beq.s    lbC00E784
                    tst.w    lbW002AC2
                    beq.s    lbC00E784
                    addq.w   #1,lbW002AC0
                    move.l   a5,lbL00E756
lbC00E784:          move.l   a5,a3
                    lea      lbL020D92,a2
                    bsr      patch_tiles
                    add.l    #6,a3
                    lea      lbL020E5E,a2
                    bsr      patch_tiles
                    sub.l    #2,a3
                    lea      lbL020E0E,a2
                    jsr      patch_tiles
                    add.l    #4,a3
                    lea      lbL020DBE,a2
                    bra      patch_tiles

patch_fire_door_right_btn_alarm:
                    move.l   a5,a3
                    move.w   #23,sample_to_play
                    jsr      trigger_sample
                    cmp.l    lbL00E756,a5
                    beq.s    lbC00E7EE
                    tst.w    lbW002AC2
                    beq.s    lbC00E7EE
                    addq.w   #1,lbW002AC0
                    move.l   a5,lbL00E756
lbC00E7EE:          lea      lbL020D92,a2
                    bsr      patch_tiles
                    subq.l   #2,a3
                    lea      lbL020E5E,a2
                    bsr      patch_tiles
                    subq.l   #2,a3
                    lea      lbL020E0E,a2
                    jsr      patch_tiles
                    sub.l    #4,a3
                    lea      lbL020DBE,a2
                    bra      patch_tiles

lbC00E83E:          cmp.l    #$200,lbL000572
                    bne      return
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   a5,a3
                    jsr      lbC00516A
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   a5,a3
                    jmp      lbC00516A

lbC00E864:          cmp.l    #$200,lbL000572
                    bne      return
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   a5,a3
                    jsr      lbC0051F8
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   a5,a3
                    jmp      lbC0051F8

lbC00E88A:          cmp.l    #$200,lbL000572
                    bne      return
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   a5,a3
                    jsr      lbC005286
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   a5,a3
                    jmp      lbC005286

lbC00E8B0:          cmp.l    #$200,lbL000572
                    bne      return
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   a5,a3
                    jsr      lbC005314
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   a5,a3
                    jmp      lbC005314

lbC00E8D8:          lea      lbL00E928(pc),a0
lbC00E8DC:          move.l   (a0)+,a1
                    move.w   #$7D00,0(a1)
                    move.w   #$7D00,2(a1)
                    tst.l    (a0)
                    bne.s    lbC00E8DC
                    rts

lbC00E8F0:          lea      lbL00E928(pc),a2
lbC00E8F4:          move.l   (a2)+,a3
                    cmp.w    #$7D00,0(a3)
                    beq.s    lbC00E922
                    move.l   0(a3),d2
                    add.w    6(a3),d2
                    swap     d2
                    add.w    4(a3),d2
                    swap     d2
                    move.l   d2,0(a3)
                    move.l   8(a3),a4
                    move.l   d2,-4(a4)
                    move.l   a2,-(sp)
                    bsr      calc_shot_impact
                    move.l   (sp)+,a2
lbC00E922:          tst.l    (a2)
                    bne.s    lbC00E8F4
                    rts

lbL00E928:          dc.l     lbW00E940
                    dc.l     lbW00E95A
                    dc.l     lbW00E974
                    dc.l     lbW00E98E
                    dc.l     lbW00E9A8,0
lbW00E940:          dcb.w    2,$7D00
                    dcb.w    2,8
                    dc.l     lbW013308
                    dc.w     1,0,0,0
                    dc.l     player_1_dats
lbW00E958:          dc.w     0
lbW00E95A:          dcb.w    2,$7D00
                    dcb.w    2,8
                    dc.l     lbW013424
                    dc.w     1,0,0,0
                    dc.l     player_1_dats
lbW00E972:          dc.w     0
lbW00E974:          dcb.w    2,$7D00
                    dcb.w    2,8
                    dc.l     lbW013540
                    dc.w     1,0,0,0
                    dc.l     player_1_dats
lbW00E98C:          dc.w     0
lbW00E98E:          dcb.w    2,$7D00
                    dcb.w    2,8
                    dc.l     lbW01365C
                    dc.w     1,0,0,0
                    dc.l     player_1_dats
lbW00E9A6:          dc.w     0
lbW00E9A8:          dcb.w    2,$7D00
                    dcb.w    2,8
                    dc.l     lbW013778
                    dc.w     1,0,0,0
                    dc.l     player_1_dats
lbW00E9C0:          dc.w     0
lbL00E9C2:          dc.l     lbW00E940
                    dc.l     lbW00E95A
                    dc.l     lbW00E974,0
lbL00E9D2:          dc.l     lbW00E98E
                    dc.l     lbW00E9A8,0
lbL00E9DE:          dc.l     lbW00E940
                    dc.l     lbW00E95A
                    dc.l     lbW00E974
                    dc.l     lbW00E98E
                    dc.l     lbW00E9A8,0
lbW00E9F6:          dcb.w    3,0
                    dc.w     $FFFF,1,$FFFF,1,0,1,1,0,1,$FFFF,1,$FFFF,0,$FFFF
                    dc.w     $FFFF,0,0
lbW00EA1E:          dc.w     0,$FFF8,8,$FFF8,8,0,8,8,0,8,$FFF8,8,$FFF8,0,$FFF8
                    dc.w     $FFF8
lbW00EA3E:          dcb.w    2,0
                    dc.w     8,0,12,6,$10,12,12,12,8,14,6,10,4,8,6,6,10,8,2,14
                    dc.w     8,10,2,4,6,7,12,2,10,6,14,13
lbW00EA82:          dcb.w    2,0
                    dc.w     6,$FFFA,6,$FFF6,10,$FFFA,6,4,6,2,$FFFE,$FFFA
                    dc.w     $FFFE,$FFFA,$FFFE,$FFF6
lbL00EAA6:          dc.l     0
lbL00EAAA:          dc.l     lbL00EDAA
                    dc.l     lbL00EACA
                    dc.l     lbL00EB8E
                    dc.l     lbL00EC12
                    dc.l     lbL00ECFE
                    dc.l     lbL00ED82
                    dc.l     lbL00EC7A
                    dc.l     lbL00EDAA
lbL00EACA:          dc.l     lbL00EAEE
                    dc.l     lbL00EAEE
                    dc.l     lbL00EB02
                    dc.l     lbL00EB16
                    dc.l     lbL00EB2A
                    dc.l     lbL00EB3E
                    dc.l     lbL00EB52
                    dc.l     lbL00EB66
                    dc.l     lbL00EB7A
lbL00EAEE:          dc.l     lbL017FCE,0
                    dc.l     lbW01389C,$7D00,-1
lbL00EB02:          dc.l     lbL017FFE,0
                    dc.l     lbW01389C,$7D00,-1
lbL00EB16:          dc.l     lbL01802E,0
                    dc.l     lbW01389C,$7D00,-1
lbL00EB2A:          dc.l     lbL01805E,0
                    dc.l     lbW01389C,$7D00,-1
lbL00EB3E:          dc.l     lbL01808E,0
                    dc.l     lbW01389C,$7D00,-1
lbL00EB52:          dc.l     lbL0180BE,0
                    dc.l     lbW01389C,$7D00,-1
lbL00EB66:          dc.l     lbL0180EE,0
                    dc.l     lbW01389C,$7D00,-1
lbL00EB7A:          dc.l     lbL01811E,0
                    dc.l     lbW01389C,$7D00,-1
lbL00EB8E:          dc.l     lbL00EBB2
                    dc.l     lbL00EBB2
                    dc.l     lbL00EBBE
                    dc.l     lbL00EBCA
                    dc.l     lbL00EBD6
                    dc.l     lbL00EBE2
                    dc.l     lbL00EBEE
                    dc.l     lbL00EBFA
                    dc.l     lbL00EC06
lbL00EBB2:          dc.l     lbL017B4E,$7D00,-1
lbL00EBBE:          dc.l     lbL017B7E,$7D00,-1
lbL00EBCA:          dc.l     lbL017BAE,$7D00,-1
lbL00EBD6:          dc.l     lbL017BDE,$7D00,-1
lbL00EBE2:          dc.l     lbL017C0E,$7D00,-1
lbL00EBEE:          dc.l     lbL017C3E,$7D00,-1
lbL00EBFA:          dc.l     lbL017C6E,$7D00,-1
lbL00EC06:          dc.l     lbL017C9E,$7D00,-1
lbL00EC12:          dc.l     lbL00EC36
                    dc.l     lbL00EC36
                    dc.l     lbL00EC36
                    dc.l     lbL00EC36
                    dc.l     lbL00EC36
                    dc.l     lbL00EC36
                    dc.l     lbL00EC36
                    dc.l     lbL00EC36
                    dc.l     lbL00EC36
lbL00EC36:          dc.l     lbL017E4E,0
                    dc.l     lbL017E7E,0
                    dc.l     lbL017EAE,0
                    dc.l     lbL017EDE,0
                    dc.l     lbL017F0E,0
                    dc.l     lbL017F3E,0
                    dc.l     lbL017F6E,0
                    dc.l     lbL017F9E,0,-1
lbL00EC7A:          dc.l     lbL00EC9E
                    dc.l     lbL00EC9E
                    dc.l     lbL00ECAA
                    dc.l     lbL00ECB6
                    dc.l     lbL00ECC2
                    dc.l     lbL00ECCE
                    dc.l     lbL00ECDA
                    dc.l     lbL00ECE6
                    dc.l     lbL00ECF2
lbL00EC9E:          dc.l     lbL017CCE,$7D00,-1
lbL00ECAA:          dc.l     lbL017CFE,$7D00,-1
lbL00ECB6:          dc.l     lbL017D2E,$7D00,-1
lbL00ECC2:          dc.l     lbL017D5E,$7D00,-1
lbL00ECCE:          dc.l     lbL017D8E,$7D00,-1
lbL00ECDA:          dc.l     lbL017DBE,$7D00,-1
lbL00ECE6:          dc.l     lbL017DEE,$7D00,-1
lbL00ECF2:          dc.l     lbL017E1E,$7D00,-1
lbL00ECFE:          dc.l     lbL00ED22
                    dc.l     lbL00ED22
                    dc.l     lbL00ED2E
                    dc.l     lbL00ED3A
                    dc.l     lbL00ED46
                    dc.l     lbL00ED52
                    dc.l     lbL00ED5E
                    dc.l     lbL00ED6A
                    dc.l     lbL00ED76
lbL00ED22:          dc.l     lbL01814E,$7D00,-1
lbL00ED2E:          dc.l     lbL01817E,$7D00,-1
lbL00ED3A:          dc.l     lbL0181AE,$7D00,-1
lbL00ED46:          dc.l     lbL0181DE,$7D00,-1
lbL00ED52:          dc.l     lbL01820E,$7D00,-1
lbL00ED5E:          dc.l     lbL01823E,$7D00,-1
lbL00ED6A:          dc.l     lbL01826E,$7D00,-1
lbL00ED76:          dc.l     lbL01829E,$7D00,-1
lbL00ED82:          dc.l     lbL018D06
                    dc.l     lbL018D06
                    dc.l     lbL018D06
                    dc.l     lbL018D06
                    dc.l     lbL018D06
                    dc.l     lbL018D06
                    dc.l     lbL018D06
                    dc.l     lbL018D06
                    dc.l     lbL018D06
                    dc.l     lbL018D06
lbL00EDAA:          dc.l     lbL00EDCE
                    dc.l     lbL00EDCE
                    dc.l     lbL00EDDA
                    dc.l     lbL00EDE6
                    dc.l     lbL00EDF2
                    dc.l     lbL00EDFE
                    dc.l     lbL00EE0A
                    dc.l     lbL00EE16
                    dc.l     lbL00EE22
lbL00EDCE:          dc.l     lbL01880E,$7D00,-1
lbL00EDDA:          dc.l     lbL01889E,$7D00,-1
lbL00EDE6:          dc.l     lbL01886E,$7D00,-1
lbL00EDF2:          dc.l     lbL01883E,$7D00,-1
lbL00EDFE:          dc.l     lbL01880E,$7D00,-1
lbL00EE0A:          dc.l     lbL01889E,$7D00,-1
lbL00EE16:          dc.l     lbL01886E,$7D00,-1
lbL00EE22:          dc.l     lbL01883E,$7D00,-1

lbC00EE2E:          movem.l  d0-d7/a0-a6,-(sp)
                    bsr      get_raster_pos
                    move.l   d0,old_raster_pos
                    tst.w    lbW0004C2
                    beq.s    lbC00EE50
                    jsr      lbC00D154
                    jsr      lbC00FB16
lbC00EE50:          bsr      lbC00EE5A
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC00EE5A:          bsr      get_raster_pos
                    move.l   old_raster_pos,d1
                    cmp.w    d0,d1
                    bls.s    lbC00EE6C
                    add.w    #$136,d0
lbC00EE6C:          sub.w    d1,d0
                    cmp.w    #12,d0
                    bmi.s    lbC00EE5A
                    rts

old_raster_pos:     dc.l     0

get_raster_pos:     move.l   $dff004,d0
                    asr.l    #8,d0
                    and.l    #$1FF,d0
                    rts

lbC00EE8A:          move.l   #$7D007D00,lbW013304
                    move.l   #$7D007D00,lbW013420
                    move.l   #$7D007D00,lbW01353C
                    move.l   #$7D007D00,lbW013658
                    move.l   #$7D007D00,lbW013774
                    clr.w    lbW00E958
                    clr.w    lbW00E972
                    clr.w    lbW00E98C
                    clr.w    lbW00E9A6
                    clr.w    lbW00E9C0
                    rts

lbC00EEDC:          tst.l    flag_jump_to_gameover
                    bne.s    lbC00EF2A
                    lea      player_1_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bpl      lbC00EF14
                    lea      player_2_dats,a0
                    tst.w    PLAYER_ALIVE(a0)
                    bpl      lbC00EF14
                    jsr      lbC00F58E
                    jsr      run_gameover
                    addq.l   #4,sp
                    jmp      loop_from_gameover

lbC00EF14:          add.l    #30000,player_1_score
                    add.l    #30000,player_2_score
                    rts

lbC00EF2A:          jsr      lbC00F58E
                    jsr      run_gameover
                    addq.l   #4,sp
                    jsr      lbC00F58E
                    jmp      loop_from_gameover

run_gameover:       jsr      lbC023D72
                    move.w   #15,$dff096
                    jsr      start_main_tune
                    lea      exe_gameover,a0
                    lea      temp_buffer,a1
                    jsr      load_exe
                    jsr      temp_buffer
                    rts

display_briefing_1: move.w   #1,select_briefing
                    jsr      stop_sound
                    lea      leveltune,a0
                    lea      bpsong,a1
                    move.w   #(4304/2)-1,d0
.copy_tune:         move.w   (a0)+,(a1)+
                    dbf      d0,.copy_tune
                    jsr      start_music
                    lea      text_briefing_level_1,a0
                    bra      start_briefing

display_briefing_2: clr.w    select_briefing
                    lea      text_briefing_level_2,a0
                    bra      start_briefing

display_briefing_3: clr.w    select_briefing
                    lea      text_briefing_level_3,a0
                    bra      start_briefing

display_briefing_4: clr.w    select_briefing
                    lea      text_briefing_level_4,a0
                    bra.s    start_briefing

display_briefing_5: clr.w    select_briefing
                    lea      text_briefing_level_5,a0
                    bra.s    start_briefing

display_briefing_6: clr.w    select_briefing
                    lea      text_briefing_level_6,a0
                    bra.s    start_briefing

display_briefing_7: clr.w    select_briefing
                    lea      text_briefing_level_7,a0
                    bra.s    start_briefing

display_briefing_8: clr.w    select_briefing
                    lea      text_briefing_level_8,a0
                    bra.s    start_briefing

display_briefing_9: clr.w    select_briefing
                    lea      text_briefing_level_9,a0
                    bra.s    start_briefing

display_briefing_10:
                    clr.w    select_briefing
                    lea      text_briefing_level_10,a0
                    bra.s    start_briefing

display_briefing_11:
                    clr.w    select_briefing
                    lea      text_briefing_level_11,a0
                    bra      start_briefing

display_briefing_12:
                    clr.w    select_briefing
                    lea      text_briefing_level_12,a0
              ;      bra      start_briefing

start_briefing:     movem.l  d0-d7/a0-a6,-(sp)
                    lea      leveltune,a0
                    lea      bpsong,a1
                    move.w   #(4304/2)-1,d0
.copy_tune:         move.w   (a0)+,(a1)+
                    dbf      d0,.copy_tune
                    jsr      start_music
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.l   a0,cur_briefing_text
                    jsr      lbC023210
                    bsr      set_copper_blank
                    moveq    #2,d0
                    lea      player_1_dats,a1
                    tst.w    PLAYER_ALIVE(a1)
                    bmi.s    run_briefing_single
                    lea      player_2_dats,a1
                    tst.w    PLAYER_ALIVE(a1)
                    bmi.s    run_briefing_single
                    bra.s    run_briefing

run_briefing_single:
                    subq.l   #1,d0                  ; only 1 player made it
run_briefing:       movem.l  d0/a0,-(sp)
                    lea      exe_briefingcore,a0
                    tst.w    select_briefing
                    beq.s    .core
                    lea      exe_briefingstart,a0
.core:
                    lea      temp_buffer,a1
                    jsr      load_exe
                    movem.l  (sp)+,d0/a0
                    lea      trigger_sample_select_channel,a1
                    jsr      temp_buffer
                    move.l   a0,exe_return_palette
                    rts

exe_return_palette: dc.l     0
select_briefing:    dc.w     0

start_main_tune:    tst.w    music_enabled
                    bne.s    lbC00F1AA
                    jsr      stop_sound
                    bsr      load_main_tune
                    jsr      start_music
                    move.b   #8,bpdelay
lbC00F1AA:          rts

load_main_tune:     lea      soundmon_title,a0
                    lea      bpsong,a1
                    jsr      load_file
                    rts

run_menu:           move.w   #1,music_enabled
                    move.w   #DEBUG,map_overview_on
                    clr.w    lbW0004E2
                    lea      exe_menu,a0
                    lea      temp_buffer,a1
                    jsr      load_exe
                    lea      player_1_dats,a0
                    lea      player_2_dats,a0
                    move.l   number_players,d5
                    cmp.w    #1,d5
                    bne.s    lbC00F244
                    moveq    #0,d1
lbC00F244:          clr.l    d7
                    move.w   share_credits,d7
                    move.l   reg_vbr,a1
                    jsr      temp_buffer                    ; run the prog
                    clr.b    key_pressed
                    clr.b    key_released
                    clr.w    lbW006D3A
                    clr.w    lbW006D36
                    clr.w    lbW006D38
                    
                    ; init players credits & scores here
                    movem.l  d0-d7/a0-a6,-(sp)
                    lea      player_1_dats,a0
                    clr.l    PLAYER_CREDITS(a0)
                    clr.l    PLAYER_SCORE(a0)
                    lea      player_2_dats,a0
                    clr.l    PLAYER_CREDITS(a0)
                    clr.l    PLAYER_SCORE(a0)
                    movem.l  (sp)+,d0-d7/a0-a6
                    
                    move.w   d1,share_credits
                    tst.w    d7
                    beq      start_game_selected
                    ; run the story exe when no input
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.l   #copper_blank,$dff080
                    lea      exe_story,a0
                    lea      temp_buffer,a1
                    jsr      load_exe
                    jsr      temp_buffer
                    move.l   #copper_blank,$dff080
                    movem.l  (sp)+,d0-d7/a0-a6
                    bra      run_menu

start_game_selected:
                    clr.w    music_enabled
                    jsr      stop_sound
                    lea      player_1_dats,a0
                    move.l   d2,$16C(a0)
                    clr.l    PLAYER_CREDITS(a0)
                    clr.l    PLAYER_SCORE(a0)
                    lea      player_2_dats,a0
                    move.l   d3,$16C(a0)
                    clr.l    PLAYER_CREDITS(a0)
                    clr.l    PLAYER_SCORE(a0)
                    movem.l  d0-d7/a0-a6,-(sp)
                    cmp.w    #2,d4
                    bpl      lbC00F378
lbC00F378:          movem.l  (sp)+,d0-d7/a0-a6
                    move.l   d6,number_players
                    cmp.w    #2,d4
                    rts

load_exe:           pea      (a1)
                    jsr      load_file
                    move.l   (a7)+,a1
                    lea      (a1),a0
                    move.l   a0,-(sp)
                    jsr      reloc_exe
                    move.l   (sp)+,a0
                    rts

wait_raster:        cmp.b    #255,$dff006
                    bne.s    wait_raster
.wait:              cmp.b    #44,$dff006
                    bne.s    .wait
                    rts

set_copper_blank:   bsr      wait_raster
                    move.l   #copper_blank,$dff080
                    rts

hold_briefing_screen:
                    lea      top_bar_gfx,a0
                    move.l   #$260,d0
                    jsr      clear_array_byte
                    lea      bottom_bar_gfx,a0
                    move.l   #$260,d0
                    jsr      clear_array_byte
                    move.l   exe_return_palette,a0
                    lea      lbL02266A,a1
                    move.l   #32,d0
                    jsr      lbC010F16
                    move.w   #1000,d0
wait_user_input_after_briefing:
                    jsr      wait_raster
                    btst     #7,$bfe001
                    beq.s    lbC00F4A6
                    btst     #6,$bfe001
                    beq.s    lbC00F4A6
                    subq.w   #1,d0
                    bne.s    wait_user_input_after_briefing
lbC00F4A6:          lea      lbL02266A,a0
                    lea      lbW02276A,a1
                    move.l   exe_return_palette,a2
                    move.l   #32,d0
                    move.w   #2,lbW010CDE
                    jsr      compute_palette_fading_directions
                    jsr      wait
lbC00F4D2:          lea      lbW02276A,a0
                    lea      copper_main_palette,a1
                    move.l   #32,d0
                    jsr      copy_palette_to_copper
                    bsr      clear_bitplanes_nbr
                    move.l   #copperlist_main,$dff080
                    move.l   #copper_blank,$dff084
                    move.w   #76,d0
                    move.w   #2,d2
                    jsr      trigger_sample_select_channel
                    rts

lbC00F51C:          jsr      stop_sound
                    move.l   #76,d0
                    move.l   #0,d2
                    jsr      trigger_sample_select_channel
                    move.l   #76,d0
                    move.l   #1,d2
                    jsr      trigger_sample_select_channel
                    move.l   #76,d0
                    move.l   #2,d2
                    jsr      trigger_sample_select_channel
                    move.l   #76,d0
                    move.l   #3,d2
                    jsr      trigger_sample_select_channel
                    lea      leveltune,a0
                    lea      bpsong,a1
                    move.w   #(4304/2)-1,d0
lbC00F57A:          move.w   (a0)+,(a1)+
                    dbf      d0,lbC00F57A
                    jsr      start_music
                    lea      exe_return_palette,a0
                    rts

lbC00F58E:          lea      copper_main_palette,a0
                    lea      lbL0226EA,a1
                    jsr      lbC0108DA
                    move.l   #$20,d0
                    move.w   #1,lbW010CDE
                    jsr      lbC010AA4
                    lea      top_bar_gfx,a0
                    lea      player_1_status_bar,a1
                    move.l   #$260,d0
                    jsr      copy_byte_array
                    lea      bottom_bar_gfx,a0
                    lea      player_2_status_bar,a1
                    move.l   #$260,d0
                    jsr      copy_byte_array
                    lea      top_bar_gfx,a0
                    lea      bottom_bar_gfx,a1
                    move.l   #8,d0
lbC00F5F6:          move.l   a0,a2
                    move.l   #$13,d1
lbC00F5FE:          clr.w    (a2)+
                    subq.l   #1,d1
                    bne.s    lbC00F5FE
                    move.l   a0,a2
                    add.l    #$130,a2
                    move.l   #$13,d1
lbC00F612:          clr.w    (a2)+
                    subq.l   #1,d1
                    bne.s    lbC00F612
                    move.l   a1,a2
                    move.l   #$13,d1
lbC00F620:          clr.w    (a2)+
                    subq.l   #1,d1
                    bne.s    lbC00F620
                    move.l   a1,a2
                    add.l    #$130,a2
                    move.l   #19,d1
lbC00F634:          clr.w    (a2)+
                    subq.l   #1,d1
                    bne.s    lbC00F634
                    jsr      wait_raster
                    jsr      wait_raster
                    add.l    #38,a0
                    add.l    #38,a1
                    subq.l   #1,d0
                    bne.s    lbC00F5F6
                    jsr      wait
                    move.l   #copperlist_main,$dff080
                    move.l   #copper_blank,$dff084
                    rts

clear_bitplanes_nbr:
                    bsr      wait_raster
                    move.w   #$200,bplcon0
                    rts

set_bitplanes_nbr:  bsr      wait_raster
                    move.w   #$5200,bplcon0
                    rts

init_main_copperlist:
                    bset     #1,$bfe001
                    lea      copper_main_palette,a0
                    move.l   #32,d0
                    bsr      clear_copper_palette
                    lea      top_bar_gfx,a0
                    lea      main_top_bar_bps,a1
                    move.l   #304,d0
                    move.l   #2,d1
                    bsr      set_bps
                    lea      bottom_bar_gfx,a0
                    lea      main_bottom_bar_bps,a1
                    move.l   #$130,d0
                    move.l   #2,d1
                    bsr      set_bps
                    jsr      load_level_tunes
                    rts

lbC00F6F0:          movem.l  d0-d7/a0-a6,-(sp)
                    lea      ascii_MSG15,a1
                    bsr.s    lbC00F70A
                    lea      lbB099DB5,a1
                    bsr.s    lbC00F70A
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbC00F70A:          clr.b    0(a1)
                    clr.b    1(a1)
                    clr.b    2(a1)
                    clr.b    3(a1)
                    clr.b    $26(a1)
                    clr.b    $27(a1)
                    clr.b    $28(a1)
                    clr.b    $29(a1)
                    clr.b    $4C(a1)
                    clr.b    $4D(a1)
                    clr.b    $4E(a1)
                    clr.b    $4F(a1)
                    clr.b    $72(a1)
                    clr.b    $73(a1)
                    clr.b    $74(a1)
                    clr.b    $75(a1)
                    clr.b    $98(a1)
                    clr.b    $99(a1)
                    clr.b    $9A(a1)
                    clr.b    $9B(a1)
                    clr.b    $BE(a1)
                    clr.b    $BF(a1)
                    clr.b    $C0(a1)
                    clr.b    $C1(a1)
                    clr.b    $E4(a1)
                    clr.b    $E5(a1)
                    clr.b    $E6(a1)
                    clr.b    $E7(a1)
                    clr.b    $10A(a1)
                    clr.b    $10B(a1)
                    clr.b    $10C(a1)
                    clr.b    $10D(a1)
                    rts

load_level_tunes:   move.w   #$4000,$dff09a
                    lea      soundmon_boss,a0
                    lea      bosstune,a1
                    jsr      load_file
                    lea      soundmon_level,a0
                    lea      leveltune,a1
                    jsr      load_file
                    move.w   #$C000,$dff09a
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
                    bra      return_text

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
space_letter:       add.l    16(a1),d0
                    tst.b    (a0)
                    bmi      return_text
                    bne      next_letter
                    addq.l   #1,a0
                    move.l   d7,d0
                    add.l    20(a1),d1
                    bra      next_letter

return_text:        rts

ascii_letters:      dc.b     'ABCDEFGHIJKLMNOPQRSTUVWXYZ>1234567890.!?: ',0
                    even
lbL00FA24:          dc.l    lbL0FBF6C
                    dc.l    10240
                    dc.l    1               ; 1 bitplane
                    dc.l    36
                    dc.l    9
                    dc.l    12
                    dc.l    80
                    dc.l    1008
                    dc.l    font_pic
                    dc.l    ascii_letters

lbC00FA4C:          move.l   #$40,lbW00FE14
                    move.l   #4,lbW00FE18
                    move.l   #4,lbW00FE1C
                    move.l   #$20,lbW00FE20
                    move.l   #0,lbW00FE24
                    move.l   #$40,lbW00FE50
                    move.l   #4,lbW00FE54
                    move.l   #4,lbW00FE58
                    move.l   #$20,lbW00FE5C
                    move.l   #0,lbW00FE60
                    move.l   #$40,lbL00FE00
                    move.l   #$8E,lbL00FE04
                    move.l   #$C4,lbL00FE08
                    move.l   #$20,lbL00FE0C
                    move.l   #$107,lbL00FE10
                    move.l   #$40,lbL00FE3C
                    move.l   #$8E,lbL00FE40
                    move.l   #$C4,lbL00FE44
                    move.l   #$20,lbL00FE48
                    move.l   #$107,lbL00FE4C
                    rts

lbC00FB16:          lea      player_1_dats,a0
                    move.w   PLAYER_HEALTH(a0),lbW00FE16
                    move.w   PLAYER_LIVES(a0),lbW00FE1A
                    cmp.w    #4,lbW00FE1A
                    bmi.s    lbC00FB3E
                    move.w   #4,lbW00FE1A
lbC00FB3E:          move.w   PLAYER_AMMOPACKS(a0),lbW00FE1E
                    move.w   PLAYER_AMMUNITIONS(a0),lbW00FE22
                    move.w   PLAYER_KEYS(a0),lbW00FE26
                    cmp.w    #6,lbW00FE26
                    bmi.s    lbC00FB68
                    move.w   #6,lbW00FE26
lbC00FB68:          lea      player_2_dats,a0
                    move.w   PLAYER_HEALTH(a0),lbW00FE52
                    move.w   PLAYER_LIVES(a0),lbW00FE56
                    cmp.w    #4,lbW00FE56
                    bmi.s    lbC00FB90
                    move.w   #4,lbW00FE56
lbC00FB90:          move.w   PLAYER_AMMOPACKS(a0),lbW00FE5A
                    move.w   PLAYER_AMMUNITIONS(a0),lbW00FE5E
                    move.w   PLAYER_KEYS(a0),lbW00FE62
                    cmp.w    #6,lbW00FE62
                    bmi.s    lbC00FBBA
                    move.w   #6,lbW00FE62
lbC00FBBA:          clr.w    lbW00FEA8
                    clr.w    lbW00FEAA
lbC00FBC6:          move.l   lbL00FC0E,a0
                    tst.l    (a0)
                    bpl.s    lbC00FBDE
                    move.l   #lbL00FC12,lbL00FC0E
                    lea      lbL00FC12(pc),a0
lbC00FBDE:          addq.l   #8,lbL00FC0E
                    move.l   4(a0),lbL00FEAC
                    move.l   (a0),a0
                    jsr      (a0)
                    add.w    #1,lbW00FEAA
                    cmp.w    #5,lbW00FEAA
                    beq      return
                    tst.w    lbW00FEA8
                    beq.s    lbC00FBC6
                    rts

lbL00FC0E:          dc.l    lbL00FC12
lbL00FC12:          dc.l    lbC00FC68
                    dc.l    lbL099B34
                    dc.l    lbC00FC84
                    dc.l    lbL099B34
                    dc.l    lbC00FCA0
                    dc.l    lbL099B34
                    dc.l    lbC00FCC6
                    dc.l    lbL099B34
                    dc.l    lbC00FCEC
                    dc.l    lbL099B34
                    dc.l    lbC00FD12
                    dc.l    lbL099D94
                    dc.l    lbC00FD2E
                    dc.l    lbL099D94
                    dc.l    lbC00FD48
                    dc.l    lbL099D94
                    dc.l    lbC00FD6C
                    dc.l    lbL099D94
                    dc.l    lbC00FD92
                    dc.l    lbL099D94
                    dc.l    -1

lbC00FC68:          lea      lbL00FDEC,a0
                    move.l   lbW00FE14,(a0)
                    lea      lbL00FE00,a1
                    move.l   #$18,d1
                    bra      lbC00FDB8

lbC00FC84:          lea      lbL00FDF8,a0
                    move.l   lbW00FE20,(a0)
                    lea      lbL00FE0C,a1
                    move.l   #$C8,d1
                    bra      lbC00FDB8

lbC00FCA0:          lea      lbL00FDF4,a0
                    lea      lbL00FE08,a1
                    lea      lbL00FE78,a2
                    move.l   lbW00FE1C,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a2,d0.l),(a0)
                    clr.l    d1
                    bra      lbC00FDB8

lbC00FCC6:          lea      lbL00FDF0,a0
                    lea      lbL00FE04,a1
                    lea      lbL00FE64,a2
                    move.l   lbW00FE18,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a2,d0.l),(a0)
                    clr.l    d1
                    bra      lbC00FDB8

lbC00FCEC:          lea      lbL00FDFC,a0
                    lea      lbL00FE10,a1
                    lea      lbL00FE8C,a2
                    move.l   lbW00FE24,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a2,d0.l),(a0)
                    clr.l    d1
                    bra      lbC00FDB8

lbC00FD12:          lea      lbL00FE28,a0
                    move.l   lbW00FE50,(a0)
                    lea      lbL00FE3C,a1
                    move.l   #$18,d1
                    bra      lbC00FDB8

lbC00FD2E:          lea      lbL00FE34,a0
                    move.l   lbW00FE5C,(a0)
                    lea      lbL00FE48,a1
                    move.l   #$C8,d1
                    bra.s    lbC00FDB8

lbC00FD48:          lea      lbL00FE30,a0
                    lea      lbL00FE44,a1
                    lea      lbL00FE78,a2
                    move.l   lbW00FE58,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a2,d0.l),(a0)
                    clr.l    d1
                    bra.s    lbC00FDB8

lbC00FD6C:          lea      lbL00FE2C,a0
                    lea      lbL00FE40,a1
                    lea      lbL00FE64,a2
                    move.l   lbW00FE54,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a2,d0.l),(a0)
                    clr.l    d1
                    bra      lbC00FDB8

lbC00FD92:          lea      lbL00FE38,a0
                    lea      lbL00FE4C,a1
                    lea      lbL00FE8C,a2
                    move.l   lbW00FE60,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   0(a2,d0.l),(a0)
                    clr.l    d1
                    bra      lbC00FDB8

lbC00FDB8:          move.l   (a0),d0
                    cmp.l    (a1),d0
                    beq      return
                    bmi.s    lbC00FDDA
                    move.w   #1,lbW00FEA8
                    move.l   (a1),d0
                    add.l    d1,d0
                    move.l   a1,-(sp)
                    bsr      lbC00FEEC
                    move.l   (sp)+,a1
                    addq.l   #1,(a1)
                    rts

lbC00FDDA:          move.w   #1,lbW00FEA8
                    subq.l   #1,(a1)
                    move.l   (a1),d0
                    add.l    d1,d0
                    bra      lbC00FEB0

lbL00FDEC:          dc.l     0
lbL00FDF0:          dc.l     0
lbL00FDF4:          dc.l     0
lbL00FDF8:          dc.l     0
lbL00FDFC:          dc.l     0
lbL00FE00:          dc.l     $40
lbL00FE04:          dc.l     $8E
lbL00FE08:          dc.l     $C4
lbL00FE0C:          dc.l     $20
lbL00FE10:          dc.l     $11E
lbW00FE14:          dc.w     0
lbW00FE16:          dc.w     $40
lbW00FE18:          dc.w     0
lbW00FE1A:          dc.w     4
lbW00FE1C:          dc.w     0
lbW00FE1E:          dc.w     4
lbW00FE20:          dc.w     0
lbW00FE22:          dc.w     $20
lbW00FE24:          dc.w     0
lbW00FE26:          dc.w     6
lbL00FE28:          dc.l     0
lbL00FE2C:          dc.l     0
lbL00FE30:          dc.l     0
lbL00FE34:          dc.l     0
lbL00FE38:          dc.l     0
lbL00FE3C:          dc.l     $40
lbL00FE40:          dc.l     $8E
lbL00FE44:          dc.l     $C4
lbL00FE48:          dc.l     $20
lbL00FE4C:          dc.l     $11E
lbW00FE50:          dc.w     0
lbW00FE52:          dc.w     $40
lbW00FE54:          dc.w     0
lbW00FE56:          dc.w     4
lbW00FE58:          dc.w     0
lbW00FE5A:          dc.w     4
lbW00FE5C:          dc.w     0
lbW00FE5E:          dc.w     $20
lbW00FE60:          dc.w     0
lbW00FE62:          dc.w     6
lbL00FE64:          dc.l     $7F,$82,$86,$8A,$8F
lbL00FE78:          dc.l     $B7,$BA,$BD,$C0,$C5
lbL00FE8C:          dc.l     $107,$10A,$10E,$112,$116,$11A,$11F
lbW00FEA8:          dc.w     0
lbW00FEAA:          dc.w     0
lbL00FEAC:          dc.l     0

lbC00FEB0:          move.l   lbL00FEAC,a1
                    move.l   d0,d1
                    lsr.w    #3,d1
                    and.w    #7,d0
                    moveq    #7,d2
                    sub.w    d0,d2
                    move.b   #$FF,d4
                    bclr     d2,d4
                    add.l    d1,a1
                    and.b    d4,0(a1)
                    and.b    d4,$26(a1)
                    and.b    d4,$4C(a1)
                    and.b    d4,$72(a1)
                    and.b    d4,$98(a1)
                    and.b    d4,$BE(a1)
                    and.b    d4,$E4(a1)
                    and.b    d4,$10A(a1)
                    rts

lbC00FEEC:          lea      lbW00FF66(pc),a0
                    move.l   lbL00FEAC,a1
                    tst.b    0(a0,d0.l)
                    beq.s    lbC00FF30
                    move.l   d0,d1
                    lsr.w    #3,d1
                    and.w    #7,d0
                    moveq    #7,d2
                    sub.w    d0,d2
                    clr.b    d4
                    bset     d2,d4
                    add.l    d1,a1
                    or.b     d4,0(a1)
                    or.b     d4,$26(a1)
                    or.b     d4,$4C(a1)
                    or.b     d4,$72(a1)
                    or.b     d4,$98(a1)
                    or.b     d4,$BE(a1)
                    or.b     d4,$E4(a1)
                    or.b     d4,$10A(a1)
                    rts

lbC00FF30:          move.l   d0,d1
                    lsr.w    #3,d1
                    and.w    #7,d0
                    moveq    #7,d2
                    sub.w    d0,d2
                    move.b   #$FF,d4
                    bclr     d2,d4
                    add.l    d1,a1
                    and.b    d4,0(a1)
                    and.b    d4,$26(a1)
                    and.b    d4,$4C(a1)
                    and.b    d4,$72(a1)
                    and.b    d4,$98(a1)
                    and.b    d4,$BE(a1)
                    and.b    d4,$E4(a1)
                    and.b    d4,$10A(a1)
                    rts

lbW00FF66:          dcb.w    12,0
                    dcb.w    32,$B0B
                    dcb.w    20,0
                    dc.w     $B0B,0,$B0B,0,$B0B,0,$B0B,0,0,0,0,0,0,0,0,0,0,0,0
                    dc.w     0,0,0,0,0,0,0,0,0
                    dc.w     $B0B,11,$B00,$B0B,11,$B00,0,0,$B0B,11,11,11,11,11
                    dcb.w    10,11
                    dc.w     $B00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,$B0B,0,$B0B,0
                    dc.w     $B0B,0,$B0B,0,$B0B,0,$B0B,0,0,0,0,0,0,0,0,0,0,0,0
                    dc.w     0,0,0,0,0
                    dc.w     $FFC0

set_bps:            move.l   a0,d2
lbC0100AA:          move.w   d2,6(a1)
                    swap     d2
                    move.w   d2,2(a1)
                    swap     d2
                    addq.l   #8,a1
                    add.l    d0,d2
                    subq.w   #1,d1
                    bne.s    lbC0100AA
                    rts

lbC0100C0:          rts

set_blank_copper:   move.l   #copper_blank,$dff080
                    move.l   #$200,$dff100
                    clr.l    $dff180
                    clr.l    $dff184
return:             rts

kill_system:        move.l   a0,-(sp)
                    move.w   #$4000,$dff09a
                    move.w   $dff01c,old_intreq
                    move.w   #$7FFF,$dff09a
                    move.w   #$8030,$dff09a
                    move.l   reg_vbr,a0
                    move.l   $6C(a0),old_lev3irq
                    move.l   #lev3irq,$6C(a0)
                    move.w   #-1,$dff034
                    move.w   #$C000,$dff09a
                    move.l   (sp)+,a0
                    rts

restore_system:     move.l   a0,-(sp)
                    move.w   #$4000,$dff09a
                    move.l   reg_vbr,a0
                    move.l   old_lev3irq,$6C(a0)
                    move.w   old_intreq,d0
                    or.w     #$8000,d0
                    move.w   d0,$dff09a
                    move.w   #$C000,$dff09a
                    move.w   #$81C0,$dff096
                    movem.l  (sp)+,a0
                    rts

load_file:          jsr      restore_system
                    movem.l  a0/a1,-(sp)
                    move.l   4,a6
                    lea      doslibrary_MSG,a1
                    jsr      _LVOOldOpenLibrary(a6)
                    move.l   d0,DOSBase
                    beq      lbC010398
                    movem.l  (sp)+,a0/a1
                    move.l   a1,-(sp)
                    move.l   d2,-(sp)
                    move.l   a0,d1
                    move.l   #$3ED,d2
                    move.l   DOSBase,a6
                    jsr      _LVOOpen(a6)
                    move.l   (sp)+,d2
                    move.l   d0,file_handle
                    beq.s    err_open_file
                    move.l   (sp)+,a1
                    movem.l  d2/d3,-(sp)
                    move.l   file_handle,d1
                    move.l   a1,d2
                    move.l   #$7D000,d3
                    move.l   DOSBase,a6
                    jsr      _LVORead(a6)
                    movem.l  (sp)+,d2/d3
                    move.l   file_handle,d1
                    move.l   DOSBase,a6
                    jsr      _LVOClose(a6)
                    bra.s    file_loaded

err_open_file:      move.w   #$F0,d0
                    jsr      error_flash
file_loaded:        move.l   4,a6
                    move.l   DOSBase,a1
                    jsr      _LVOCloseLibrary(a6)
                    bra      kill_system

lbC010398:          move.w   #$F00,d0
                    jsr      error_flash
                    bra      kill_system

doslibrary_MSG:     dc.b     'dos.library',0
                    even
DOSBase:            dc.l     0
file_handle:        dc.l     0

lbC010432:          movem.l  d0-d7/a0-a6,-(sp)
                    move.l   d0,d6
                    move.l   d1,d7
                    move.l   a0,a4
                    move.l   a1,a5
                    move.l   a2,a6
                    bsr      lbC0105AE
                    tst.l    d6
                    bne.s    lbC01044E
                    bsr.s    lbC010464
                    move.l   d1,4(sp)
lbC01044E:          move.l   d0,(sp)
                    moveq    #0,d1
                    moveq    #0,d2
                    move.w   #$8000,d3
                    bsr      lbC0106CA
                    movem.l  (sp)+,d0-d7/a0-a6
                    tst.l    d0
                    rts

lbC010464:          bsr      lbC010506
                    bne.s    lbC0104DA
                    move.l   $144(a0),d7
                    move.l   d7,-(sp)
                    lea      $138(a0),a2
                    bsr.s    lbC0104DC
                    bne.s    lbC0104D6
lbC010478:          move.l   d1,d2
                    move.l   d1,d4
                    move.l   a5,a3
                    move.l   d7,d6
                    lsr.l    #8,d6
                    lsr.l    #1,d6
                    bne.s    lbC010488
                    move.l   a6,a3
lbC010488:          bsr.s    lbC0104DC
                    bne.s    lbC0104D6
                    addq.l   #1,d2
                    move.l   d1,d5
                    beq.s    lbC01049A
                    cmp.l    d1,d2
                    bne.s    lbC01049A
                    subq.l   #1,d6
                    bne.s    lbC010488
lbC01049A:          move.l   d4,d1
                    sub.l    d4,d2
                    move.l   a3,a0
                    bsr      lbC0106C8
                    bne.s    lbC0104D6
lbC0104A6:          bsr      lbC010676
                    bne.s    lbC0104D6
                    move.l   12(a0),d0
                    sub.l    d0,d7
                    lea      $18(a0),a0
                    ror.l    #2,d0
                    bra.s    lbC0104BC

lbC0104BA:          move.l   (a0)+,(a5)+
lbC0104BC:          dbra     d0,lbC0104BA
                    clr.w    d0
                    rol.l    #2,d0
                    bra.s    lbC0104C8

lbC0104C6:          move.b   (a0)+,(a5)+
lbC0104C8:          dbra     d0,lbC0104C6
                    subq.l   #1,d2
                    bne.s    lbC0104A6
                    move.l   d5,d1
                    move.l   d7,d0
                    bne.s    lbC010478
lbC0104D6:          move.l   (sp)+,d1
                    tst.l    d0
lbC0104DA:          rts

lbC0104DC:          move.l   d2,-(sp)
                    move.l   a6,a0
                    move.l   8(a0),d0
                    bne.s    lbC0104F6
                    move.l   $1F8(a0),d1
                    beq.s    lbC010500
                    bsr      lbC010672
                    bne.s    lbC010500
                    lea      $138(a0),a2
lbC0104F6:          move.l   -(a2),d1
                    moveq    #1,d0
                    sub.l    d0,8(a0)
                    moveq    #0,d0
lbC010500:          move.l   (sp)+,d2
                    tst.l    d0
                    rts

lbC010506:          move.l   a4,-(sp)
                    move.l   a6,a0
                    bsr      lbC01064A
                    bne      lbC0105A8
lbC010512:          lea      lbW01069A(pc),a1
                    move.w   d1,(a1)
                    move.l   a4,(sp)
                    bsr      lbC0105F6
                    beq      lbC0105A8
                    lsl.w    #2,d0
lbC010524:          lea      lbL01069E(pc),a1
                    move.w   d1,(a1)+
                    move.w   d0,(a1)+
                    move.l   0(a0,d0.w),d1
                    beq.s    lbC010580
                    bsr      lbC010672
                    bne.s    lbC0105A8
                    move.l   #$E1,d0
                    moveq    #2,d2
                    cmp.l    (a0),d2
                    bne.s    lbC0105A8
                    moveq    #2,d2
                    cmp.b    #3,d6
                    beq.s    lbC010552
                    tst.b    (a4)
                    bne.s    lbC010552
                    moveq    #-3,d2
lbC010552:          cmp.l    $1FC(a0),d2
                    bne.s    lbC010576
                    lea      $1B0(a0),a1
                    lea      lbL0106A6(pc),a2
                    moveq    #0,d2
                    move.b   (a1)+,d2
                    subq.b   #1,d2
lbC010566:          move.b   (a1)+,d0
                    bsr.s    lbC0105E2
                    cmp.b    (a2)+,d0
                    dbne     d2,lbC010566
                    bne.s    lbC010576
                    tst.b    (a2)
                    beq.s    lbC010598
lbC010576:          move.w   #$1F0,d0
                    tst.l    0(a0,d0.w)
                    bne.s    lbC010524
lbC010580:          move.l   #$CC,d0
                    cmp.b    #3,d6
                    beq.s    lbC0105A8
                    tst.b    (a4)
                    bne.s    lbC0105A8
                    move.l   #$CD,d0
                    bra.s    lbC0105A8

lbC010598:          tst.b    (a4)
                    bne      lbC010512
                    lea      lbW0106A2(pc),a1
                    move.w   $1F2(a0),(a1)
                    moveq    #0,d0
lbC0105A8:          move.l   (sp)+,a4
                    tst.l    d0
                    rts

lbC0105AE:          move.l   a4,a0
                    bsr.s    lbC0105E0
                    cmp.b    #$44,d0
                    bne.s    lbC0105DE
                    bsr.s    lbC0105E0
                    cmp.b    #$46,d0
                    bne.s    lbC0105DE
                    move.b   (a0)+,d0
                    sub.b    #$30,d0
                    blt.s    lbC0105DE
                    cmp.b    #$33,d0
                    bgt.s    lbC0105DE
                    cmp.b    #$3A,(a0)+
                    bne.s    lbC0105DE
                    lea      lbW0106A4(pc),a0
                    move.b   d0,1(a0)
                    addq.w   #4,a4
lbC0105DE:          rts

lbC0105E0:          move.b   (a0)+,d0
lbC0105E2:          cmp.b    #$61,d0
                    blt.s    lbC0105F2
                    cmp.b    #$7A,d0
                    bgt.s    lbC0105F2
                    and.b    #$DF,d0
lbC0105F2:          tst.b    d0
                    rts

lbC0105F6:          movem.l  d1/a0/a1,-(sp)
                    moveq    #0,d0
                    moveq    #-1,d1
                    move.l   a4,a0
                    lea      lbL0106A6(pc),a1
                    clr.b    (a1)
lbC010606:          addq.l   #1,d1
                    tst.b    (a4)
                    beq.s    lbC010614
                    cmp.b    #$2F,(a4)+
                    bne.s    lbC010606
                    subq.w   #1,a4
lbC010614:          tst.l    d1
                    beq.s    lbC010642
lbC010618:          mulu     #13,d1
                    move.b   (a0)+,d0
                    bsr.s    lbC0105E2
                    move.b   d0,(a1)+
                    add.w    d0,d1
                    and.l    #$7FF,d1
                    cmp.l    a0,a4
                    bne.s    lbC010618
                    cmp.b    #$2F,(a4)
                    bne.s    lbC010636
                    addq.w   #1,a4
lbC010636:          clr.b    (a1)+
                    divu     #$48,d1
                    clr.w    d1
                    swap     d1
                    addq.w   #6,d1
lbC010642:          move.l   d1,d0
                    movem.l  (sp)+,d1/a0/a1
                    rts

lbC01064A:          move.w   #$370,d1
                    bsr.s    lbC010672
                    bne.s    lbC010670
                    move.l   #$E1,d0
                    moveq    #2,d2
                    cmp.l    (a0),d2
                    bne.s    lbC010670
                    moveq    #1,d2
                    cmp.l    $1FC(a0),d2
                    bne.s    lbC010670
                    lea      lbW01069C(pc),a1
                    move.w   $13E(a0),(a1)
                    moveq    #0,d0
lbC010670:          rts

lbC010672:          bsr.s    lbC0106C6
                    bne.s    lbC010680
lbC010676:          bsr.s    lbC010682
                    beq.s    lbC010680
                    move.l   #$195,d0
lbC010680:          rts

lbC010682:          movem.l  d1/a0,-(sp)
                    moveq    #0,d0
                    move.w   #$7F,d1
lbC01068C:          add.l    (a0)+,d0
                    dbf      d1,lbC01068C
                    neg.l    d0
                    movem.l  (sp)+,d1/a0
                    rts

lbW01069A:          dc.w     0
lbW01069C:          dc.w     0
lbL01069E:          dc.l     0
lbW0106A2:          dc.w     0
lbW0106A4:          dc.w     0
lbL0106A6:          dcb.l    8,0

lbC0106C6:          moveq    #1,d2
lbC0106C8:          moveq    #0,d3
lbC0106CA:          move.l   a6,a1
                    move.w   lbW0106A4(pc),d0
clear_copper_palette:
                    clr.w    2(a0)
                    addq.l   #4,a0
                    subq.w   #1,d0
                    bne.s    clear_copper_palette
                    rts

compute_palette_fading_directions:
                    move.w   #$4000,$dff09a
                    movem.l  d0-d7/a0-a6,-(sp)
                    clr.l    d1
                    clr.l    d2
                    clr.l    d3
                    clr.l    d4
                    clr.l    d5
                    clr.l    d6
                    clr.l    d7
                    move.l   #0,a3
                    move.l   #0,a4
                    move.l   #0,a5
                    move.l   #0,a6
                    move.w   #1,lbW010CDC
                    move.w   d0,lbW010CE2
                    move.l   a1,lbL010CE4
                    move.l   a2,lbL010CE8
                    move.l   a0,a2
                    lea      palette_fading_directions,a3
                    move.w   lbW010CE2,d0
lbC010736:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bmi.s    lbC01074C
                    bhi.s    lbC010752
                    clr.b    (a3)+
                    bra.s    lbC010756

lbC01074C:          move.b   #-1,(a3)+
                    bra.s    lbC010756

lbC010752:          move.b   #1,(a3)+
lbC010756:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bmi.s    lbC01076C
                    bhi.s    lbC010772
                    clr.b    (a3)+
                    bra.s    lbC010776

lbC01076C:          move.b   #-1,(a3)+
                    bra.s    lbC010776

lbC010772:          move.b   #1,(a3)+
lbC010776:          move.w   (a2)+,d1
                    move.w   (a1)+,d2
                    and.w    #$F,d1
                    and.w    #$F,d2
                    cmp.w    d1,d2
                    bmi.s    lbC01078C
                    bhi.s    lbC010792
                    clr.b    (a3)+
                    bra.s    lbC010796

lbC01078C:          move.b   #-1,(a3)+
                    bra.s    lbC010796

lbC010792:          move.b   #1,(a3)+
lbC010796:          subq.b   #1,d0
                    bne.s    lbC010736

                    move.l   lbL010CE8,a2
                    move.w   lbW010CE2,d0
                    addq.l   #2,a2
lbC0107A8:          move.w   (a0)+,(a2)
                    addq.l   #4,a2
                    subq.b   #1,d0
                    bne.s    lbC0107A8
                    clr.w    some_variable
                    movem.l  (sp)+,d0-d7/a0-a6
                    move.w   #$C000,$dff09a
                    rts

palette_fade:       cmp.w    #1,lbW010CDC
                    bne      return3
                    tst.w    some_variable
                    bne      return3
                    add.w    #1,lbW010CE0
                    moveq    #0,d0
                    moveq    #0,d1
                    moveq    #0,d2
                    moveq    #0,d3
                    moveq    #0,d4
                    moveq    #0,d5
                    moveq    #0,d6
                    moveq    #0,d7
                    move.l   #0,a0
                    move.l   #0,a1
                    move.l   #0,a2
                    move.l   #0,a3
                    move.l   #0,a4
                    move.l   #0,a5
                    move.l   #0,a6
                    move.w   lbW010CE0,d0
                    cmp.w    lbW010CDE,d0
                    bmi      return3
                    clr.w    lbW010CE0
                    move.w   lbW010CE2,d0
                    move.l   lbL010CE8,a0
                    move.l   lbL010CE4,a1
                    lea      palette_fading_directions,a3
                    addq.l   #2,a0
lbC01084C:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bne.s    lbC010862
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC010870

lbC010862:          move.b   (a3)+,d3
                    lsr.w    #8,d1
                    add.b    d3,d1
                    lsl.w    #8,d1
                    and.w    #$FF,(a0)
                    or.w     d1,(a0)
lbC010870:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bne.s    lbC010886
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC010894

lbC010886:          move.b   (a3)+,d3
                    lsr.w    #4,d1
                    add.b    d3,d1
                    lsl.w    #4,d1
                    and.w    #$F0F,(a0)
                    or.w     d1,(a0)
lbC010894:          move.w   (a0),d1
                    move.w   (a1)+,d2
                    and.w    #$f,d1
                    and.w    #$f,d2
                    cmp.w    d1,d2
                    bne.s    lbC0108AA
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.s    lbC0108B4

lbC0108AA:          move.b   (a3)+,d3
                    add.b    d3,d1
                    and.w    #$FF0,(a0)
                    or.w     d1,(a0)
lbC0108B4:          addq.l   #4,a0
                    subq.b   #1,d0
                    bne.s    lbC01084C
                    divu     #3,d7
                    cmp.w    lbW010CE2,d7
                    bne.s    lbC0108D4
                    move.w   #1,some_variable
                    clr.w    lbW010CDC
lbC0108D4:          bsr      lbC010ECE
                    rts

lbC0108DA:          movem.l  d0/a0,-(sp)
                    move.l   #32,d0
                    lea      lbL0226EA,a0
lbC0108EA:          clr.w    (a0)+
                    subq.w   #1,d0
                    bne.s    lbC0108EA
                    movem.l  (sp)+,d0/a0
                    rts

copy_palette_to_copper:
                    addq.l   #2,a1
lbC0108F8:          move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #2,d0
                    bne.s    lbC0108F8
                    bsr      lbC010ECE
                    rts

lbC010906:          move.w   #2,lbW010CDC
                    lea      lbL010E0E,a4
                    moveq    #$30,d2
lbC010916:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC010916
                    move.l   d0,d7
                    move.l   a1,a2
                    clr.l    d6
                    lea      lbL010D4E,a3
lbC01092A:          move.w   (a2),d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    move.w   (a2),d6
                    lsl.w    #4,d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    move.w   (a2)+,d6
                    lsl.w    #8,d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    subq.w   #1,d7
                    bne      lbC01092A
                    move.l   d1,d4
                    subq.l   #2,a0
                    subq.l   #2,a1
                    move.w   d0,lbW010CE2
                    move.l   a0,lbL010CE8
                    move.l   a1,lbL010CE4
                    clr.w    some_variable
                    rts

lbC01097E:          cmp.w    #2,lbW010CDC
                    bne      return3
                    tst.w    some_variable
                    bne      return3
                    add.w    #1,lbW010CE0
                    moveq    #0,d0
                    moveq    #0,d1
                    moveq    #0,d2
                    moveq    #0,d3
                    moveq    #0,d4
                    moveq    #0,d5
                    moveq    #0,d6
                    moveq    #0,d7
                    move.w   lbW010CE0,d0
                    cmp.w    lbW010CDE,d0
                    bmi      return3
                    clr.w    lbW010CE0
                    move.l   lbL010CE8,a0
                    move.l   lbL010CE4,a1
                    clr.l    d0
                    move.w   lbW010CE2,d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      lbL010D4E,a2
                    lea      lbL010E0E,a3
                    move.l   d6,d7
                    move.l   d0,d1
lbC0109EC:          addq.l   #4,a0
                    addq.l   #2,a1
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F00,d2
                    and.w    #$F00,d3
                    cmp.w    d2,d3
                    beq      lbC010A14
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC010A14:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq      lbC010A46
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC010A46:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #15,d2
                    and.w    #15,d3
                    cmp.w    d2,d3
                    beq      lbC010A78
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC010A78:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC0109EC
                    cmp.l    d6,d7
                    bne      lbC010A9E
                    move.w   #1,some_variable
                    clr.w    lbW010CDC
lbC010A9E:          bsr      lbC010ECE
                    rts

lbC010AA4:          clr.l    d1
                    clr.l    d2
                    clr.l    d3
                    clr.l    d4
                    clr.l    d5
                    clr.l    d6
                    clr.l    d7
                    move.l   #0,a2
                    move.l   #0,a3
                    move.l   #0,a4
                    move.l   #0,a5
                    move.l   #0,a6
                    move.w   #$4000,$dff09a
                    move.w   #3,lbW010CDC
                    lea      lbL010E0E,a4
                    move.l   #$30,d2
lbC010AEC:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC010AEC
                    move.l   d0,d7
                    move.l   a0,a2
                    add.l    #2,a2
                    clr.l    d6
                    lea      lbL010D4E,a3
lbC010B06:          move.w   (a2),d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    move.w   (a2),d6
                    lsl.w    #4,d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    move.w   (a2),d6
                    add.l    #4,a2
                    lsl.w    #8,d6
                    and.w    #$F00,d6
                    divu     #15,d6
                    ext.l    d6
                    move.w   d6,(a3)+
                    subq.w   #1,d7
                    bne      lbC010B06
                    lea      lbL010E0E,a3
                    move.l   a0,a2
                    add.l    #2,a2
                    move.l   d0,d4
lbC010B50:          move.w   (a2),d7
                    and.w    #$F00,d7
                    move.w   d7,(a3)+
                    move.w   (a2),d7
                    and.w    #$F0,d7
                    lsl.w    #4,d7
                    move.w   d7,(a3)+
                    move.w   (a2),d7
                    and.w    #15,d7
                    lsl.w    #8,d7
                    move.w   d7,(a3)+
                    add.l    #4,a2
                    sub.l    #1,d4
                    bne      lbC010B50
                    lea      lbL010D4E,a2
                    lea      lbL010E0E,a3
                    move.l   d1,d4
                    sub.l    #2,a0
                    move.w   d0,lbW010CE2
                    move.l   a0,lbL010CE8
                    clr.w    some_variable
                    move.w   #$C000,$dff09a
                    rts

lbC010BAC:          cmp.w    #3,lbW010CDC
                    bne      return3
                    tst.w    some_variable
                    bne      return3
                    add.w    #1,lbW010CE0
                    moveq    #0,d0
                    moveq    #0,d1
                    moveq    #0,d2
                    moveq    #0,d3
                    moveq    #0,d4
                    moveq    #0,d5
                    moveq    #0,d6
                    moveq    #0,d7
                    move.l   #0,a0
                    move.l   #0,a1
                    move.l   #0,a2
                    move.l   #0,a3
                    move.l   #0,a4
                    move.l   #0,a5
                    move.l   #0,a6
                    move.w   lbW010CE0,d0
                    cmp.w    lbW010CDE,d0
                    bmi      return3
                    clr.w    lbW010CE0
                    clr.l    d0
                    move.w   lbW010CE2,d0
                    move.l   lbL010CE8,a0
                    move.l   d0,d1
                    clr.l    d7
                    lea      lbL010D4E,a2
                    lea      lbL010E0E,a3
lbC010C38:          addq.l   #4,a0
                    move.w   (a0),d2
                    and.w    #$F00,d2
                    tst.w    d2
                    beq      lbC010C58
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC010C58:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F0,d2
                    tst.w    d2
                    beq      lbC010C84
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC010C84:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #15,d2
                    tst.w    d2
                    beq      lbC010CB0
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.l    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC010CB0:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC010C38
                    tst.l    d7
                    bne      lbC010CD6
                    move.w   #1,some_variable
                    clr.w    lbW010CDC
lbC010CD6:          bsr      lbC010ECE
                    rts

lbW010CDC:          dc.w     0
lbW010CDE:          dc.w     2
lbW010CE0:          dc.w     0
lbW010CE2:          dc.w     0
lbL010CE4:          dc.l     0
lbL010CE8:          dc.l     0
palette_fading_directions:
                    dcb.l    24,0

return3:            rts

lbL010D4E:          dcb.l    48,0
lbL010E0E:          dcb.l    48,0

lbC010ECE:          lea      copper_main_palette,a0
                    lea      lbW09A20C,a1
                    move.l   (a0)+,(a1)+
                    move.l   (a0)+,(a1)+
                    move.l   (a0)+,(a1)+
                    move.l   (a0)+,(a1)+
                    move.l   copper_main_palette,lbW099EE8
                    rts

clear_array_byte:   move.l   d1,-(sp)
                    moveq    #0,d1
lbC00F9C4:          move.b   d1,(a0)+
                    subq.l   #1,d0
                    bne.s    lbC00F9C4
                    move.l   (sp)+,d1
                    rts

clear_array_long:   lsr.l    #2,d0
lbC010EFC:          clr.l    (a0)+
                    subq.l   #1,d0
                    bne.s    lbC010EFC
                    rts

copy_byte_array:    move.b   (a0)+,(a1)+
                    subq.l   #1,d0
                    bne.s    copy_byte_array
                    rts

lbC010F16:          move.w   2(a0),(a1)+
                    addq.l   #4,a0
                    subq.w   #1,d0
                    bne.s    lbC010F16
                    rts

lbC010F22:          lea      player_1_status_pic,a0
                    lea      top_bar_gfx,a1
                    lea      player_1_status_pic+37,a2
                    lea      lbB099A29,a3
                    move.l   #player_2_status_pic,d0
                    move.l   #bottom_bar_gfx,d1
                    move.l   #player_2_status_pic+37,d2
                    move.l   #lbB099C89,d3
                    move.l   #$13,d7
                    tst.w    lbW0004E2
                    beq.s    lbC010F96
                    lea      player_1_status_bar,a0
                    lea      top_bar_gfx,a1
                    lea      lbB099569,a2
                    lea      lbB099A29,a3
                    move.l   #player_2_status_bar,d0
                    move.l   #bottom_bar_gfx,d1
                    move.l   #lbB0997C9,d2
                    move.l   #lbB099C89,d3
                    move.l   #$13,d7
lbC010F96:          move.l   #2,number_frames_to_wait
                    jsr      sleep_frames
                    move.b   0(a0),0(a1)
                    move.b   $26(a0),$26(a1)
                    move.b   $4C(a0),$4C(a1)
                    move.b   $72(a0),$72(a1)
                    move.b   $98(a0),$98(a1)
                    move.b   $BE(a0),$BE(a1)
                    move.b   $E4(a0),$E4(a1)
                    move.b   $10A(a0),$10A(a1)
                    add.l    #304,a0
                    add.l    #304,a1
                    move.b   0(a0),0(a1)
                    move.b   $26(a0),$26(a1)
                    move.b   $4C(a0),$4C(a1)
                    move.b   $72(a0),$72(a1)
                    move.b   $98(a0),$98(a1)
                    move.b   $BE(a0),$BE(a1)
                    move.b   $E4(a0),$E4(a1)
                    move.b   $10A(a0),$10A(a1)
                    sub.l    #304,a0
                    sub.l    #304,a1
                    move.b   0(a2),0(a3)
                    move.b   $26(a2),$26(a3)
                    move.b   $4C(a2),$4C(a3)
                    move.b   $72(a2),$72(a3)
                    move.b   $98(a2),$98(a3)
                    move.b   $BE(a2),$BE(a3)
                    move.b   $E4(a2),$E4(a3)
                    move.b   $10A(a2),$10A(a3)
                    add.l    #304,a2
                    add.l    #304,a3
                    move.b   0(a2),0(a3)
                    move.b   $26(a2),$26(a3)
                    move.b   $4C(a2),$4C(a3)
                    move.b   $72(a2),$72(a3)
                    move.b   $98(a2),$98(a3)
                    move.b   $BE(a2),$BE(a3)
                    move.b   $E4(a2),$E4(a3)
                    move.b   $10A(a2),$10A(a3)
                    sub.l    #304,a2
                    sub.l    #304,a3
                    exg      d0,a0
                    exg      d1,a1
                    exg      d2,a2
                    exg      d3,a3
                    move.b   0(a0),0(a1)
                    move.b   $26(a0),$26(a1)
                    move.b   $4C(a0),$4C(a1)
                    move.b   $72(a0),$72(a1)
                    move.b   $98(a0),$98(a1)
                    move.b   $BE(a0),$BE(a1)
                    move.b   $E4(a0),$E4(a1)
                    move.b   $10A(a0),$10A(a1)
                    add.l    #304,a0
                    add.l    #304,a1
                    move.b   0(a0),0(a1)
                    move.b   $26(a0),$26(a1)
                    move.b   $4C(a0),$4C(a1)
                    move.b   $72(a0),$72(a1)
                    move.b   $98(a0),$98(a1)
                    move.b   $BE(a0),$BE(a1)
                    move.b   $E4(a0),$E4(a1)
                    move.b   $10A(a0),$10A(a1)
                    sub.l    #304,a0
                    sub.l    #304,a1
                    move.b   0(a2),0(a3)
                    move.b   $26(a2),$26(a3)
                    move.b   $4C(a2),$4C(a3)
                    move.b   $72(a2),$72(a3)
                    move.b   $98(a2),$98(a3)
                    move.b   $BE(a2),$BE(a3)
                    move.b   $E4(a2),$E4(a3)
                    move.b   $10A(a2),$10A(a3)
                    add.l    #304,a2
                    add.l    #304,a3
                    move.b   0(a2),0(a3)
                    move.b   $26(a2),$26(a3)
                    move.b   $4C(a2),$4C(a3)
                    move.b   $72(a2),$72(a3)
                    move.b   $98(a2),$98(a3)
                    move.b   $BE(a2),$BE(a3)
                    move.b   $E4(a2),$E4(a3)
                    move.b   $10A(a2),$10A(a3)
                    sub.l    #304,a2
                    sub.l    #304,a3
                    exg      d0,a0
                    exg      d1,a1
                    exg      d2,a2
                    exg      d3,a3
                    addq.l   #2,a0
                    addq.l   #2,a1
                    subq.l   #2,a2
                    subq.l   #2,a3
                    addq.l   #2,d0
                    addq.l   #2,d1
                    subq.l   #2,d2
                    subq.l   #2,d3
                    tst.w    lbW0004E2
                    bne.s    lbC0111B4
                    jsr      lbC00F6F0
lbC0111B4:          subq.l   #1,d7
                    bne      lbC010F96
                    move.w   #1,lbW0004E2
                    rts

lbC0111C4:          tst.l    $10(a0)
                    bne.s    lbC0111E6
                    move.l   12(a0),d0
lbC0111CE:          move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

lbC0111E6:          move.l   $10(a0),a1
                    move.l   a1,$14(a0)
                    move.w   6(a1),$18(a0)
                    move.l   (a1),d0
                    bra      lbC0111CE

lbC0111FA:          move.w   -4(a0),d0
                    sub.w    lbW0035D6,d0
                    cmp.w    #$FFE0,d0
                    bpl.s    lbC01120E
                    move.w   #320,d0
lbC01120E:          cmp.w    #320,d0
                    bmi.s    lbC011218
                    move.w   #320,d0
lbC011218:          move.w   d0,(a0)
                    move.w   -2(a0),d0
                    sub.w    lbW0035D2,d0
                    cmp.w    #$FFF0,d0
                    bpl.s    lbC01122E
                    move.w   #256,d0
lbC01122E:          cmp.w    #598,d0
                    bmi.s    lbC011238
                    move.w   #598,d0
lbC011238:          move.w   d0,2(a0)
                    move.l   a0,-(sp)
                    bsr      lbC011272
                    move.l   (sp)+,a0
                    move.l   8(a0),a1
                    move.w   2(a1),d0
                    swap     d0
                    move.w   6(a1),d0
                    add.l    #272,d0
                    move.w   d0,$26(a1)
                    swap     d0
                    move.w   d0,$22(a1)
                    move.l   (a0),$1C(a0)
                    add.w    #$10,$1C(a0)
                    add.l    #$1C,a0

lbC011272:          move.l   8(a0),a1
                    tst.l    $10(a0)
                    bne      lbC011314
lbC01127E:          and.w    #$80,14(a1)
                    move.w   0(a0),d0
                    add.w    #$8F,d0
                    btst     #0,d0
                    beq.s    lbC011298
                    or.w     #1,14(a1)
lbC011298:          lsr.w    #1,d0
                    move.b   d0,11(a1)
                    move.w   2(a0),d0
                    cmp.w    #$F4,d0
                    bne.s    lbC0112AC
                    move.w   #$F5,d0
lbC0112AC:          add.w    #$23,d0
                    move.w   d0,d1
                    add.w    4(a0),d1
                    cmp.w    #$100,d1
                    bmi.s    lbC0112C6
                    sub.w    #$100,d1
                    or.b     #2,15(a1)
lbC0112C6:          move.b   d1,14(a1)
                    cmp.w    #$100,d0
                    bmi.s    lbC0112DA
                    sub.w    #$100,d0
                    or.b     #4,15(a1)
lbC0112DA:          move.b   d0,10(a1)
                    tst.w    6(a0)
                    beq.s    lbC011312
                    move.w   10(a1),$1A(a1)
                    move.w   14(a1),$1E(a1)
                    move.w   2(a1),d0
                    swap     d0
                    move.w   6(a1),d0
                    move.w   4(a0),d1
                    ext.l    d1
                    add.l    d1,d1
                    add.l    d1,d1
                    addq.l   #8,d1
                    add.l    d1,d0
                    move.w   d0,$16(a1)
                    swap     d0
                    move.w   d0,$12(a1)
lbC011312:          rts

lbC011314:          subq.w   #1,$18(a0)
                    bpl      lbC01127E
                    addq.l   #8,$14(a0)
lbC011320:          move.l   $14(a0),a2
                    move.l   (a2),d0
                    tst.l    d0
                    bmi.s    lbC01133E
                    move.w   6(a2),$18(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      lbC01127E

lbC01133E:          move.l   $10(a0),$14(a0)
                    bra.s    lbC011320

lbC011346:          cmp.l    $10(a5),a6
                    beq.s    lbC011358
                    move.l   a6,$10(a5)
                    move.l   a6,$14(a5)
                    clr.w    $18(a5)
lbC011358:          rts

lbC011370:          lea      sprite_1_2_bps,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    move.w   d0,22(a0)
                    swap     d0
                    move.w   d0,18(a0)
                    lea      sprite_3_4_bps,a0
                    move.w   d1,6(a0)
                    swap     d1
                    move.w   d1,2(a0)
                    swap     d1
                    move.w   d1,22(a0)
                    swap     d1
                    move.w   d1,18(a0)
                    rts

lbW0113AA:          dc.w     0
lbW0113AC:          dc.w     $130
lbL0113AE:          dc.l     0
lbW0113B2:          dcb.w    3,0
lbW0113B8:          dcb.w    2,0
lbL0113BC:          dcb.l    63,0
                    dcb.l    63,0
                    dcb.l    21,0

lbC011622:          move.l   (a0),a5
                    move.w   (a1)+,(a5)
                    move.w   (a1)+,2(a5)
                    move.w   (a1)+,d2
                    add.w    #16,d2
                    move.w   d2,4(a5)
                    move.w   (a1)+,6(a5)
                    move.w   (a1)+,8(a5)
                    move.w   (a1)+,10(a5)
                    move.l   a2,$10(a5)                 ; picture used for the sprites
                    move.l   a3,12(a5)                  ; some dest buffer
                    move.w   d0,$14(a5)                 ; width
                    move.l   d1,$16(a5)                 ; plane size
                    addq.l   #8,a0
                    tst.l    (a0)                       ; loop until -1
                    bpl.s    lbC011622
                    rts

lbC01165A:          move.l   (a0),a5
                    move.w   (a1)+,(a5)
                    move.w   (a1)+,2(a5)
                    move.w   (a1)+,4(a5)
                    move.w   (a1)+,6(a5)
                    move.w   (a1)+,$28(a5)
                    move.w   (a1)+,$2A(a5)
                    move.w   (a1)+,$2C(a5)
                    move.w   (a1)+,$2E(a5)
                    move.l   a2,$10(a5)
                    move.w   d0,$14(a5)
                    move.l   d1,$16(a5)
                    addq.l   #8,a0
                    tst.l    (a0)
                    bpl.s    lbC01165A
                    rts

lbC011690:          clr.w    lbW0113B8
                    lea      lbL0113BC(pc),a1
                    clr.l    d3
                    move.w   #294,d2
lbC0116A0:          move.w   d3,(a1)+
                    add.w    d0,d3
                    subq.w   #1,d2
                    bne.s    lbC0116A0
                    addq.l   #4,a0
                    move.l   a0,-(sp)
lbC0116AC:          move.l   (a0),a1
                    clr.w    $14(a1)
                    move.l   8(a1),a2
                    move.l   a2,$16(a1)
                    move.w   6(a2),$1A(a1)
                    move.l   a1,a2
                    move.l   a1,a3
                    move.l   #70,d7
                    add.l    d7,a2
                    move.l   a2,a4
                    lsr.w    #1,d7
lbC0116D0:          move.w   (a3)+,(a2)+
                    subq.w   #1,d7
                    bne.s    lbC0116D0
                    move.l   8(a1),a2
                    move.w   6(a2),$1A(a1)
                    addq.l   #4,a0
                    tst.l    (a0)
                    bne.s    lbC0116AC
                    move.l   (sp)+,a0
lbC0116E8:          move.l   (a0)+,a1
                    move.l   a1,a2
                    add.l    #140,a2
                    move.l   #70,d0
lbC0116F8:          move.w   (a1)+,(a2)+
                    subq.w   #1,d0
                    bne.s    lbC0116F8
                    tst.l    (a0)
                    bne.s    lbC0116E8
                    rts

lbC011704:          bsr      lbC011710
                    addq.l   #8,a2
                    tst.l    (a2)
                    bpl.s    lbC011704
                    rts

lbC011710:          move.l   (a2),a3
                    move.l   d0,d2
                    lea      $dff000,a6
                    clr.l    d7
                    move.w   4(a3),d7
                    lsr.w    #3,d7
                    move.w   d7,d6
                    sub.w    d7,d2
                    move.w   d2,$22(a3)
                    move.w   $14(a3),d7
                    sub.w    d6,d7
                    move.w   d7,$20(a3)
                    move.w   d6,d7
                    lsr.w    #1,d6
                    move.w   6(a3),d5
                    lsl.w    #6,d5
                    add.w    d6,d5
                    move.w   d5,$1A(a3)
                    move.w   $14(a3),d6
                    move.w   2(a3),d7
                    ext.l    d7
                    mulu     d6,d7
                    move.w   0(a3),d6
                    lsr.w    #3,d6
                    ext.l    d6
                    add.l    d6,d7
                    move.l   d7,d6
                    add.l    12(a3),d6
                    move.l   d6,$24(a3)
                    add.l    $10(a3),d7
                    move.l   d7,$1C(a3)
                    rts

lbC01176E:          
                    WAIT_BLIT
                    lea      $dff000,a6
                    move.w   #$8400,$96(a6)
                    move.l   #-1,$44(a6)
                    move.l   #$dfc0000,$40(a6)
                    move.l   d1,d3
                    lsr.w    #3,d3
                    mulu     d2,d3
                    lsl.w    #6,d2
                    lsr.w    #4,d1
                    add.w    d1,d2
                    clr.l    $62(a6)
                    clr.w    $66(a6)
lbC0117A8:          move.l   a0,$50(a6)
                    move.l   a1,$4C(a6)
                    move.l   a1,$54(a6)
                    move.w   d2,$58(a6)
                    WAIT_BLIT
                    add.l    d3,a0
                    subq.b   #1,d0
                    bne.s    lbC0117A8
                    move.w   #$400,$96(a6)
                    rts

wait_blitter:       
                    WAIT_BLIT
                    rts

lbC0117DC:          clr.l    d1
                    move.w   lbW0035D2,d1
                    add.l    #-12,d1
                    move.l   d1,d3
                    lsr.w    #4,d1
                    add.w    d1,d1
                    add.w    d1,d1
                    and.w    #15,d3
                    add.w    d3,d3
                    add.w    d3,d3
                    lsr.w    #1,d1
                    lea      lbL0025D2,a6
                    move.w   0(a6,d1.w),d6
                    lsr.w    #2,d3
                    add.w    d3,d6
                    clr.l    d0
                    move.w   lbW0035D6,d0
                    add.w    #15,d0
                    move.l   d0,d5
                    lsr.w    #4,d0
                    add.w    d0,d0
                    not.w    d5
                    and.w    #15,d5
                    move.w   d5,d7
                    lsl.w    #4,d7
                    or.w     d7,d5
                    and.w    #15,d5
                    move.w   #15,d7
                    sub.w    d5,d7
                    move.w   lbW0035D6,d2
                    move.w   lbW0035D2,d3
lbC01183E:          move.l   (a0)+,a1
                    move.w   -4(a1),d0
                    sub.w    d2,d0
                    move.w   d0,0(a1)
                    move.w   -2(a1),d0
                    sub.w    d3,d0
                    move.w   d0,2(a1)
                    add.w    d6,2(a1)
                    add.w    d7,(a1)
                    tst.l    (a0)
                    bne.s    lbC01183E
                    rts

lbC011860:          clr.l    d1
                    clr.l    d3
                    clr.l    d6
                    move.w   lbW0035D2,d1
                    add.l    #-12,d1
                    move.l   d1,d3
                    lsr.w    #4,d1
                    add.w    d1,d1
                    and.w    #15,d3
                    lea      lbL0025D2,a6
                    move.w   #288,d6
                    sub.w    0(a6,d1.w),d6
                    sub.w    d3,d6
                    move.w   #288,d0
                    sub.w    d6,d0
                    move.w   d0,lbW0113AA
                    move.w   #288,lbW0113AC
                    move.w   #288,d1
                    sub.w    d0,d1
                    move.w   #288,d0
                    sub.w    d1,d0
                    and.w    #$FFF0,d0
                    move.w   d0,-(sp)
                    lea      lbL01232C,a0
                    bsr      lbC0117DC
                    lea      lbL012328,a0
                    move.l   #$303C,d3
                    clr.w    lbW0113B2
                    move.l   #temp_buffer,d0
                    move.l   #map_overview_background_pic,d1
                    move.l   #$303C,d3
                    bsr      lbC011936
                    clr.w    lbW0113AA
                    move.w   (sp)+,lbW0113AC
                    sub.w    #$10,lbW0113AC
                    tst.w    lbW0113AC
                    bpl.s    lbC011906
                    clr.w    lbW0113AC
lbC011906:          lea      lbL01232C,a0
lbC01190C:          move.l   (a0)+,a4
                    add.l    d2,a4
                    move.l   (a4),$8C(a4)
                    sub.w    #$120,$8E(a4)
                    tst.l    (a0)
                    bne.s    lbC01190C
                    move.w   #$FFFF,lbW0113B2
                    add.l    #$8C,d2
                    lea      lbL012328,a0
                    bra      lbC011962

lbC011936:          clr.l    d2
                    move.w   lbW0035D6,d2
                    add.w    #15,d2
                    lsr.w    #4,d2
                    add.w    d2,d2
                    move.l   d2,lbL0113AE
                    add.l    d2,d0
                    add.l    d2,d1
                    clr.l    d2
                    not.w    lbW0113B8
                    beq.s    lbC011962
                    exg      d0,d1
                    move.l   #$46,d2
lbC011962:          
                    WAIT_BLIT
                    lea      lbL0113BC(pc),a5
                    lea      $dff000,a6
                    move.w   #$8400,$96(a6)
                    move.l   #-1,$44(a6)
                    move.l   #$9F00000,$40(a6)
                    addq.l   #4,a0
                    tst.w    lbW0113B2
                    beq.s    lbC0119A0
lbC011996:          addq.l   #4,a0
                    tst.l    (a0)
                    bne.s    lbC011996
                    bra      lbC011B0E

lbC0119A0:          move.l   (a0)+,a2
                    add.l    d2,a2
                    move.l   $10(a2),d6
                    beq      lbC011A54
                    move.w   $1E(a2),d5
                    move.w   $26(a2),$66(a6)
                    move.w   $26(a2),$64(a6)
                    move.l   $2C(a2),d4
                    move.l   d6,d7
                    add.l    #61740,d7
                    cmp.l    #map_overview_background_pic,d4
                    bpl.s    lbC0119D6
                    add.l    #61740,d7
lbC0119D6:          move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT
                    add.l    d3,d6
                    add.l    d3,d7
                    move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT
                    add.l    d3,d6
                    add.l    d3,d7
                    move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT
                    add.l    d3,d6
                    add.l    d3,d7
                    move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT
                    add.l    d3,d6
                    add.l    d3,d7
                    move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT
lbC011A54:          clr.l    $10(a2)
                    add.l    #$8C,a2
                    move.l   $10(a2),d6
                    beq      lbC011B04
                    move.w   $1E(a2),d5
                    move.w   $26(a2),$66(a6)
                    move.w   $26(a2),$64(a6)
                    move.l   $2C(a2),d4
                    move.l   d6,d7
                    add.l    #61740,d7
                    cmp.l    #map_overview_background_pic,d4
                    bpl.s    lbC011A90
                    add.l    #61740,d7
lbC011A90:          move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,d6
                    add.l    d3,d7
                    move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,d6
                    add.l    d3,d7
                    move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,d6
                    add.l    d3,d7
                    move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,d6
                    add.l    d3,d7
                    move.l   d7,$50(a6)
                    move.l   d6,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
lbC011B04:          clr.l    $10(a2)
                    tst.l    (a0)
                    bne      lbC0119A0
lbC011B0E:          move.w   lbW0113AA,d1
                    cmp.w    lbW0113AC,d1
                    beq      lbC011DF4
                    clr.l    d7
lbC011B20:          clr.l    d6
                    move.l   -(a0),a2
                    move.l   a2,a4
                    move.l   0(a2),$46(a2)
                    tst.w    lbW0113B2
                    beq.s    lbC011B3E
                    add.l    d2,a2
                    move.l   -$76(a2),a3
                    bra      lbC011B98

lbC011B3E:          cmp.l    #lbL018CFA,$16(a2)
                    bne.s    lbC011B4E
                    move.w   #$7D00,-4(a2)
lbC011B4E:          tst.l    $28(a2)
                    beq.s    lbC011B6A
                    move.l   $28(a2),d4
                    clr.l    $28(a2)
                    move.l   d4,8(a2)
                    subq.l   #8,d4
                    move.l   d4,$16(a2)
                    clr.w    $1A(a2)
lbC011B6A:          subq.w   #1,$1A(a2)
                    bpl.s    lbC011B8C
                    addq.l   #8,$16(a2)
                    move.l   $16(a2),a3
                    tst.l    (a3)
                    bpl      lbC011B86
                    move.l   8(a2),a3
                    move.l   a3,$16(a2)
lbC011B86:          move.w   6(a3),$1A(a2)
lbC011B8C:          move.l   $16(a2),$5C(a2)
                    add.l    d2,a2
                    move.l   $16(a2),a3
lbC011B98:          tst.l    4(a2)
                    bmi      lbC011DFE
                    move.l   (a3),a3
                    move.l   d0,$2C(a2)
                    move.l   d0,a1
                    move.l   $1A(a3),$1E(a2)
                    move.l   $1E(a3),$22(a2)
                    move.w   $22(a3),$26(a2)
                    move.w   0(a2),d7
                    move.l   $24(a3),a4
                    clr.l    $10(a2)
                    move.w   d7,d6
                    add.w    4(a3),d6
                    sub.w    #$150,d6
                    bmi.s    lbC011C02
                    cmp.w    #$140,d7
                    bpl      lbC011DEC
                    move.w   4(a3),d5
                    sub.w    d6,d5
                    lsr.w    #4,d5
                    move.w   4(a3),d6
                    lsr.w    #4,d6
                    sub.w    d5,d6
                    add.w    d6,d6
                    add.w    d6,$26(a2)
                    add.w    d6,$24(a2)
                    move.w   $1A(a3),d1
                    and.w    #$FFC0,d1
                    add.w    d5,d1
                    move.w   d1,ALIEN_POS_X(a2)
lbC011C02:          clr.w    d5
                    move.w   d7,d6
                    bpl.s    lbC011C4A
                    move.w   d7,d1
                    add.w    4(a3),d1
                    cmp.w    #$10,d1
                    bmi      lbC011DEC
                    neg.w    d6
                    move.w   d6,d1
                    lsr.w    #4,d6
                    sub.w    d6,ALIEN_POS_X(a2)
                    add.w    d6,d6
                    ext.l    d6
                    add.l    d6,$20(a2)
                    add.l    d6,a4
                    add.w    d6,$26(a2)
                    add.w    d6,$24(a2)
                    move.w   #15,d6
                    and.w    #15,d1
                    sub.w    d1,d6
                    move.w   #$140,d7
                    add.w    d6,d7
                    move.w   #2,d5
                    add.w    #1,d7
lbC011C4A:          lsr.w    #3,d7
                    add.l    d7,a1
                    move.w   2(a2),d7
                    add.w    10(a3),d7
                    move.w   d7,d6
                    add.w    6(a3),d6
                    sub.w    lbW0113AC,d6
                    bmi.s    lbC011C80
                    cmp.w    6(a3),d6
                    bpl      lbC011DEC
                    move.w   ALIEN_POS_X(a2),d1
                    and.w    #$3F,ALIEN_POS_X(a2)
                    lsr.w    #6,d1
                    sub.w    d6,d1
                    lsl.w    #6,d1
                    or.w     d1,ALIEN_POS_X(a2)
lbC011C80:          sub.w    lbW0113AA,d7
                    tst.w    d7
                    bpl.s    lbC011CD0
                    move.w   d7,d6
                    neg.w    d6
                    cmp.w    6(a3),d6
                    bpl      lbC011DEC
                    move.w   d1,d7
                    move.w   ALIEN_POS_X(a2),d1
                    and.w    #$3F,ALIEN_POS_X(a2)
                    lsr.w    #6,d1
                    sub.w    d6,d1
                    lsl.w    #6,d1
                    or.w     d1,ALIEN_POS_X(a2)
                    move.w   $14(a3),d1
                    mulu     d6,d1
                    ext.l    d1
                    add.l    d1,$20(a2)
                    add.l    d1,a4
                    move.w   d7,d1
                    move.w   lbW0113AA,d7
                    ext.l    d7
                    add.w    d7,d7
                    sub.w    d5,d7
                    move.w   0(a5,d7.w),d7
                    add.l    d7,a1
                    bra.s    lbC011CE2

lbC011CD0:          add.w    lbW0113AA,d7
                    ext.l    d7
                    add.w    d7,d7
                    sub.w    d5,d7
                    move.w   0(a5,d7.w),d7
                    add.l    d7,a1
lbC011CE2:          tst.w    (a2)
                    bpl.s    lbC011CF4
                    cmp.w    #1,2(a2)
                    bpl.s    lbC011CF4
                    add.l    #$FFFFFFD6,a1
lbC011CF4:          move.w   ALIEN_POS_X(a2),d5
                    move.w   d5,d6
                    and.w    #$3F,d6
                    tst.w    d6
                    beq      lbC011DEC
                    move.w   d5,d6
                    and.w    #$FFC0,d6
                    tst.w    d6
                    beq      lbC011DEC
                    move.l   a1,$10(a2)
                    move.w   0(a2),d6
                    swap     d6
                    lsr.l    #4,d6
                    move.w   d6,$42(a6)
                    or.w     #$FCA,d6
                    move.w   d6,$40(a6)
                    move.l   #$FFFF0000,$44(a6)
                    move.w   $26(a2),$60(a6)
                    move.w   $26(a2),$66(a6)
                    move.w   $24(a2),$62(a6)
                    move.w   $24(a2),$64(a6)
                    move.l   $20(a2),d1
                    move.l   $16(a3),d4
                    move.l   a1,$48(a6)
                    move.l   a1,$54(a6)
                    move.l   d1,$4C(a6)
                    move.l   a4,$50(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,a1
                    add.l    d4,d1
                    move.l   a1,$48(a6)
                    move.l   a1,$54(a6)
                    move.l   d1,$4C(a6)
                    move.l   a4,$50(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,a1
                    add.l    d4,d1
                    move.l   a1,$48(a6)
                    move.l   a1,$54(a6)
                    move.l   d1,$4C(a6)
                    move.l   a4,$50(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,a1
                    add.l    d4,d1
                    move.l   a1,$48(a6)
                    move.l   a1,$54(a6)
                    move.l   d1,$4C(a6)
                    move.l   a4,$50(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,a1
                    add.l    d4,d1
                    move.l   a1,$48(a6)
                    move.l   a1,$54(a6)
                    move.l   d1,$4C(a6)
                    move.l   a4,$50(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
lbC011DEC:          tst.l    -4(a0)
                    bne      lbC011B20
lbC011DF4:          move.w   #$400,$dff096
                    rts

lbC011DFE:          move.l   d0,a1
                    tst.w    $30(a4)
                    beq.s    lbC011E56
                    tst.w    8(a3)
                    bpl.s    lbC011E3E
                    clr.l    $42(a4)
                    move.l   #lbL00051C,$32(a4)
                    move.l   #lbL00051C,$36(a4)
                    move.l   #lbL00051C,$3A(a4)
                    move.l   #lbL00051C,$3E(a4)
                    move.l   #lbW013890,8(a4)
                    clr.w    lbW00ACE2
lbC011E3E:          cmp.w    #$FFFE,6(a3)
                    bne.s    lbC011E56
                    clr.w    $1A(a4)
                    move.l   #lbL101098,a1
                    add.l    lbL0113AE,a1
lbC011E56:          move.l   (a3),a3
                    move.l   $32(a4),a5
                    move.w   $28(a3),(a5)
                    move.l   $36(a4),a5
                    move.w   $2A(a3),(a5)
                    move.l   $3A(a4),a5
                    move.w   $2C(a3),(a5)
                    move.l   $3E(a4),a5
                    move.w   $2E(a3),(a5)
                    clr.l    d7
                    lea      lbL0113BC(pc),a5
                    and.l    #$FFF0FFF0,(a2)
                    move.l   $1A(a3),ALIEN_POS_X(a2)
                    move.l   ALIEN_POS_X(a3),$22(a2)
                    move.w   $22(a3),$26(a2)
                    move.w   0(a2),d7
                    move.w   d7,d6
                    add.w    4(a3),d6
                    sub.w    #$140,d6
                    bmi.s    lbC011ED6
                    cmp.w    #$130,d7
                    bpl      lbC012078
                    move.w   4(a3),d5
                    sub.w    d6,d5
                    lsr.w    #4,d5
                    move.w   4(a3),d6
                    lsr.w    #4,d6
                    sub.w    d5,d6
                    add.w    d6,d6
                    add.w    d6,$26(a2)
                    add.w    d6,$24(a2)
                    move.w   $1A(a3),d1
                    and.w    #$FFC0,d1
                    add.w    d5,d1
                    move.w   d1,ALIEN_POS_X(a2)
lbC011ED6:          clr.w    d5
                    move.w   d7,d6
                    bpl.s    lbC011F1C
                    move.w   d7,d1
                    add.w    4(a3),d1
                    cmp.w    #$10,d1
                    bmi      lbC012078
                    neg.w    d6
                    move.w   d6,d1
                    lsr.w    #4,d6
                    sub.w    d6,ALIEN_POS_X(a2)
                    add.w    d6,d6
                    ext.l    d6
                    add.l    d6,$20(a2)
                    add.w    d6,$26(a2)
                    add.w    d6,$24(a2)
                    move.w   #15,d6
                    and.w    #15,d1
                    sub.w    d1,d6
                    move.w   #$140,d7
                    add.w    d6,d7
                    move.w   #2,d5
                    add.w    #1,d7
lbC011F1C:          lsr.w    #3,d7
                    add.l    d7,a1
                    move.w   2(a2),d7
                    add.w    10(a3),d7
                    move.w   d7,d6
                    add.w    6(a3),d6
                    sub.w    lbW0113AC,d6
                    bmi.s    lbC011F52
                    cmp.w    6(a3),d6
                    bpl      lbC012078
                    move.w   ALIEN_POS_X(a2),d1
                    and.w    #$3F,ALIEN_POS_X(a2)
                    lsr.w    #6,d1
                    sub.w    d6,d1
                    lsl.w    #6,d1
                    or.w     d1,ALIEN_POS_X(a2)
lbC011F52:          sub.w    lbW0113AA,d7
                    tst.w    d7
                    bpl.s    lbC011FA0
                    move.w   d7,d6
                    neg.w    d6
                    cmp.w    6(a3),d6
                    bpl      lbC012078
                    move.w   d1,d7
                    move.w   ALIEN_POS_X(a2),d1
                    and.w    #$3F,ALIEN_POS_X(a2)
                    lsr.w    #6,d1
                    sub.w    d6,d1
                    lsl.w    #6,d1
                    or.w     d1,ALIEN_POS_X(a2)
                    move.w   $14(a3),d1
                    mulu     d6,d1
                    ext.l    d1
                    add.l    d1,$20(a2)
                    move.w   d7,d1
                    move.w   lbW0113AA,d7
                    ext.l    d7
                    add.w    d7,d7
                    sub.w    d5,d7
                    move.w   0(a5,d7.w),d7
                    add.l    d7,a1
                    bra.s    lbC011FB2

lbC011FA0:          add.w    lbW0113AA,d7
                    ext.l    d7
                    add.w    d7,d7
                    sub.w    d5,d7
                    move.w   0(a5,d7.w),d7
                    add.l    d7,a1
lbC011FB2:          tst.w    (a2)
                    bpl.s    lbC011FC4
                    cmp.w    #1,2(a2)
                    bpl.s    lbC011FC4
                    add.l    #$FFFFFFD6,a1
lbC011FC4:          move.w   ALIEN_POS_X(a2),d5
                    move.w   d5,d6
                    and.w    #$3F,d6
                    tst.w    d6
                    beq      lbC011DEC
                    move.w   d5,d6
                    and.w    #$FFC0,d6
                    tst.w    d6
                    beq      lbC011DEC
                    move.w   $26(a2),$66(a6)
                    move.w   $24(a2),$64(a6)
                    move.l   $20(a2),d1
                    move.l   $16(a3),d4
                    move.l   #$9F00000,$40(a6)
                    move.l   #-1,$44(a6)
                    move.l   d1,$50(a6)
                    move.l   a1,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,a1
                    add.l    d4,d1
                    move.l   d1,$50(a6)
                    move.l   a1,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,a1
                    add.l    d4,d1
                    move.l   d1,$50(a6)
                    move.l   a1,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,a1
                    add.l    d4,d1
                    move.l   d1,$50(a6)
                    move.l   a1,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
                    add.l    d3,a1
                    add.l    d4,d1
                    move.l   d1,$50(a6)
                    move.l   a1,$54(a6)
                    move.w   d5,$58(a6)
                    WAIT_BLIT2
lbC012078:          tst.l    -4(a0)
                    bne      lbC011B20
                    move.w   #$400,$dff096
                    rts

lbC01208A:          clr.w    lbW0113B8
                    
                    lea      lbL0146B2,a0
                    move.l   lbL000554,a1
                    lea      aliens_sprites_block,a2
                    lea      lbL1101C4,a3
                    move.l   #40,d0
                    move.l   #384*40,d1
                    bsr      lbC011622
                    
                    lea      lbL014AB6,a0
                    move.l   lbL000558,a1
                    lea      bkgnd_anim_block,a2
                    move.l   #40,d0
                    move.l   #144*40,d1
                    bsr      lbC01165A
                    
                    lea      lbL01790A,a0
                    lea      lbW0188CE,a1
                    lea      aliens_sprites_block,a2
                    lea      lbL1101C4,a3
                    move.l   #40,d0
                    move.l   #384*40,d1
                    bsr      lbC011622
                    
                    lea      lbW012B44,a1
                    lea      lbL01790A,a2
                    move.l   #42,d0
                    move.l   #5,d1
                    bsr      lbC011704
                    
                    lea      lbW012B44,a1
                    lea      lbW013890,a2
                    move.l   #42,d0
                    move.l   #5,d1
                    bsr      lbC011704
                    
                    lea      lbW012B44,a1
                    lea      lbL014AB6,a2
                    move.l   #42,d0
                    move.l   #5,d1
                    bsr      lbC011704
                    
                    lea      lbW012B44,a1
                    lea      lbL0146B2,a2
                    move.l   #42,d0
                    move.l   #5,d1
                    bsr      lbC011704
                    
                    lea      lbL012328,a0
                    move.l   #42,d0
                    move.l   #5,d1
                    bsr      lbC011690
                    
                    lea      lbL1101C4,a0
                    move.l   #384*40,d0
                    bsr      clear_array_long
                    
                    lea      lbL101098,a0
                    move.l   #$F12C,d0
                    bsr      clear_array_long
                    
                    lea      aliens_sprites_block,a0
                    lea      lbL1101C4,a1
                    move.l   #5,d0
                    move.l   #$140,d1
                    move.l   #$180,d2
                    bsr      lbC01176E
                    
                    lea      lbW0122F0,a0
                    move.w   #$150,(a0)
                    bsr      lbC0111C4
                    lea      lbW0122F0,a0
                    bsr      lbC011272
                    lea      lbW01230C,a0
                    move.w   #$161,(a0)
                    bsr      lbC0111C4
                    lea      lbW01230C,a0
                    bsr      lbC011272
                    move.w   #$8020,$dff096
                    lea      lbW01227C,a0
                    bsr      lbC0111C4
                    lea      lbW012298,a0
                    bsr      lbC0111C4
                    cmp.l    #1,number_players
                    beq.s    lbC012238
                    lea      lbW0122B8,a0
                    bsr      lbC0111C4
                    lea      lbW0122D4,a0
                    bsr      lbC0111C4
                    rts

lbC012238:          lea      sprite_5_6_bps,a0
                    bsr      clear_sprites_bps
                    lea      sprite_7_8_bps,a0
                    bsr      clear_sprites_bps
                    move.w   #$8020,$dff09a
                    rts

clear_sprites_bps:  clr.w    2(a0)
                    clr.w    6(a0)
                    clr.w    10(a0)
                    clr.w    14(a0)
                    clr.w    $12(a0)
                    clr.w    $16(a0)
                    clr.w    $1A(a0)
                    clr.w    $1E(a0)
                    rts

                    dc.w     $290,$290
lbW01227C:          dcb.w    2,$3C
                    dc.w     $20,$80
                    dc.l     lbW005BCC
                    dc.l     player_spr1_pic
                    dc.l     lbL0139C2
                    dcb.w    4,0
lbW012298:          dc.w     $4C,$3C,$20,$80
                    dc.l     lbW005BEC
                    dcb.w    8,0
                    dcb.w    2,$3C
lbW0122B8:          dc.w     $A0,$3C,$20,$80
                    dc.l     lbW005C0C
                    dc.l     player_spr41_pic
                    dc.l     lbL0139C2
                    dcb.w    4,0
lbW0122D4:          dc.w     $A0,$3C,$20,$80
                    dc.l     lbW005C2C
                    dcb.w    8,0
lbW0122F0:          dc.w     6,$18,$20,$80
                    dc.l     sprite_1_2_bps
                    dc.l     lbL098E2C
                    dcb.w    6,0
lbW01230C:          dc.w     $17,$18,$20,$80
                    dc.l     sprite_3_4_bps
                    dc.l     lbL098E2C
                    dcb.w    6,0
lbL012328:          dc.l     0
lbL01232C:          dc.l     lbW013308
                    dc.l     lbW013424
                    dc.l     lbW013540
                    dc.l     lbW01365C
                    dc.l     lbW013778
                    dc.l     lbW012B44
                    dc.l     lbW012C60
                    dc.l     lbW012D7C
                    dc.l     lbW012E98
                    dc.l     lbW012FB4
                    dc.l     lbW0130D0
                    dc.l     lbW0131EC
                    dc.l     lbL012380
                    dc.l     lbW01249C
                    dc.l     lbW0125B8
                    dc.l     lbW0126D4
                    dc.l     lbW0127F0
                    dc.l     lbW01290C
                    dc.l     lbW012A28,0,$7D000080
lbL012380:          dc.l     0,-1

lbW012388:          dc.l     lbL014AB6
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    4,0
lbW0123C2:          dcb.w    $3F,0
                    dcb.w    $2C,0
                    dc.w     $7D00,$80
lbW01249C:          dcb.w    2,0
                    dcb.w    2,$FFFF
                    dc.l     lbL014AB6
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    4,0
lbW0124DE:          dcb.w    $3F,0
                    dcb.w    $2C,0
                    dc.w     $7D00,$80
lbW0125B8:          dcb.w    2,0
                    dcb.w    2,$FFFF
                    dc.l     lbL014AB6
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    4,0
lbW0125FA:          dcb.w    $3F,0
                    dcb.w    $2C,0
                    dc.w     $7D00
                    dc.w     $80
lbW0126D4:          dcb.w    2,0
                    dcb.w    2,$FFFF
                    dc.l     lbL014AB6
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    4,0
lbW012716:          dcb.w    $3F,0
                    dcb.w    $2C,0
                    dc.w     $7D00,$80
lbW0127F0:          dcb.w    2,0
                    dcb.w    2,$FFFF
                    dc.l     lbL014AB6
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    4,0
lbW012832:          dcb.w    $3F,0
                    dcb.w    $2C,0
                    dc.w     $7D00,$80
lbW01290C:          dcb.w    2,0
                    dcb.w    2,$FFFF
                    dc.l     lbL014AB6
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    4,0
lbW01294E:          dcb.w    $3F,0
                    dcb.w    $2C,0
                    dc.w     $7D00,$80
lbW012A28:          dcb.w    2,0
                    dcb.w    2,$FFFF
lbW012A30:          dc.l     lbL014AB6
                    dc.w     $30,$20,0,0,0
lbW012A3E:          dcb.w    $16,0
lbW012A6A:          dcb.w    $3F,0
                    dcb.w    $2C,0
lbW012B40:          dc.w     $4E6,$270
lbW012B44:          dcb.w    2,0
                    dc.l     lbL101098
                    dc.l     lbL01B036
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW012C5C:          dc.w     $514,$22E
lbW012C60:          dc.w     $21,0
                    dc.l     lbL101098
                    dc.l     lbL01B05A
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW012D78:          dc.w     $52E
                    dc.w     $22E
lbW012D7C:          dc.w     $42,0
                    dc.l     lbL101098
                    dc.l     lbL01B07E
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW012E94:          dc.w     $552,$22E
lbW012E98:          dcb.w    2,0
                    dc.l     lbL101098
                    dc.l     lbL01B0A2
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW012FB0:          dc.w     $576,$22E
lbW012FB4:          dc.w     $21,0
                    dc.l     lbL101098
                    dc.l     lbL01B0C6
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW0130CC:          dc.w     $57A,$20A
lbW0130D0:          dc.w     $42,0
                    dc.l     lbL101098
                    dc.l     lbL01B0EA
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW0131E8:          dc.w     $4E6,$254
lbW0131EC:          dcb.w    2,0
                    dc.l     lbL101098
                    dc.l     lbL01B10E
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW013304:          dc.w     $50A,$254
lbW013308:          dc.w     $21,0
                    dc.l     lbL101098
                    dc.l     lbL01790A
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW013420:          dc.w     $50A,$254
lbW013424:          dc.w     $21,0
                    dc.l     lbL101098
                    dc.l     lbL01790A
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW01353C:          dc.w     $50A,$254
lbW013540:          dc.w     $21,0
                    dc.l     lbL101098
                    dc.l     lbL01790A
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW013658:          dc.w     $50A,$254
lbW01365C:          dc.w     $21,0
                    dc.l     lbL101098
                    dc.l     lbL01790A
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW013774:          dc.w     $50A,$254
lbW013778:          dc.w     $21,0
                    dc.l     lbL101098
                    dc.l     lbL01790A
                    dc.w     $30,$20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $3F,0
                    dcb.w    $30,0
lbW013890:          dc.l     lbW01389C
                    dc.w     0,$7D00,$FFFF,$FFFF
lbW01389C:          dcb.w    2,0
                    dc.w     $10,1,$7D00,$7D00
                    dc.l     lbL1101C4
                    dc.l     aliens_sprites_block
                    dc.w     $28,0,$3C00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                    dcb.w    $33,0
lbL013942:          dc.l     player_spr1_pic,2,-1,-1
lbL013952:          dc.l     player_spr2_pic,2,-1,-1
lbL013962:          dc.l     player_spr3_pic,2,-1,-1
lbL013972:          dc.l     player_spr4_pic,2,-1,-1
lbL013982:          dc.l     player_spr5_pic,2,-1,-1
lbL013992:          dc.l     player_spr6_pic,2,-1,-1
lbL0139A2:          dc.l     player_spr7_pic,2,-1,-1
lbL0139B2:          dc.l     player_spr8_pic,2,-1,-1
lbL0139C2:          dc.l     player_spr1_pic,2
                    dc.l     player_spr11_pic,2
                    dc.l     player_spr21_pic,2
                    dc.l     player_spr11_pic,2,-1,-1
lbL0139EA:          dc.l     player_spr2_pic,2
                    dc.l     player_spr12_pic,2
                    dc.l     player_spr22_pic,2
                    dc.l     player_spr12_pic,2,-1,-1
lbL013A12:          dc.l     player_spr3_pic,2
                    dc.l     player_spr13_pic,2
                    dc.l     player_spr23_pic,2
                    dc.l     player_spr13_pic,2,-1,-1
lbL013A3A:          dc.l     player_spr4_pic,2
                    dc.l     player_spr14_pic,2
                    dc.l     player_spr24_pic,2
                    dc.l     player_spr14_pic,2,-1,-1
lbL013A62:          dc.l     player_spr5_pic,2
                    dc.l     player_spr15_pic,2
                    dc.l     player_spr25_pic,2
                    dc.l     player_spr15_pic,2,-1,-1
lbL013A8A:          dc.l     player_spr6_pic,2
                    dc.l     player_spr16_pic,2
                    dc.l     player_spr26_pic,2
                    dc.l     player_spr16_pic,2,-1,-1
lbL013AB2:          dc.l     player_spr7_pic,2
                    dc.l     player_spr17_pic,2
                    dc.l     player_spr27_pic,2
                    dc.l     player_spr17_pic,2,-1,-1
lbL013ADA:          dc.l     player_spr8_pic,2
                    dc.l     player_spr18_pic,2
                    dc.l     player_spr28_pic,2
                    dc.l     player_spr18_pic,2,-1,-1
lbL013B02:          dc.l     player_spr31_pic,1
                    dc.l     player_spr21_pic,1,-1,-1
lbL013B1A:          dc.l     player_spr32_pic,1
                    dc.l     player_spr22_pic,1,-1,-1
lbL013B32:          dc.l     player_spr33_pic,1
                    dc.l     player_spr23_pic,1,-1,-1
lbL013B4A:          dc.l     player_spr34_pic,1
                    dc.l     player_spr24_pic,1,-1,-1
lbL013B62:          dc.l     player_spr35_pic,1
                    dc.l     player_spr25_pic,1,-1,-1
lbL013B7A:          dc.l     player_spr36_pic,1
                    dc.l     player_spr26_pic,1,-1,-1
lbL013B92:          dc.l     player_spr37_pic,1
                    dc.l     player_spr27_pic,1,-1,-1
lbL013BAA:          dc.l     player_spr38_pic,1
                    dc.l     player_spr28_pic,1,-1,-1
lbL013BC2:          dc.l     player_spr31_pic,0
                    dc.l     player_spr1_pic,2
                    dc.l     player_spr31_pic,0
                    dc.l     player_spr11_pic,2
                    dc.l     player_spr31_pic,0
                    dc.l     player_spr21_pic,2
                    dc.l     player_spr31_pic,0
                    dc.l     player_spr11_pic,2,-1,-1
lbL013C0A:          dc.l     player_spr32_pic,0
                    dc.l     player_spr2_pic,2
                    dc.l     player_spr32_pic,0
                    dc.l     player_spr12_pic,2
                    dc.l     player_spr32_pic,0
                    dc.l     player_spr22_pic,2
                    dc.l     player_spr32_pic,0
                    dc.l     player_spr12_pic,2,-1,-1
lbL013C52:          dc.l     player_spr33_pic,0
                    dc.l     player_spr3_pic,2
                    dc.l     player_spr33_pic,0
                    dc.l     player_spr13_pic,2
                    dc.l     player_spr33_pic,0
                    dc.l     player_spr23_pic,2
                    dc.l     player_spr33_pic,0
                    dc.l     player_spr13_pic,2,-1,-1
lbL013C9A:          dc.l     player_spr34_pic,0
                    dc.l     player_spr4_pic,2
                    dc.l     player_spr34_pic,0
                    dc.l     player_spr14_pic,2
                    dc.l     player_spr34_pic,0
                    dc.l     player_spr24_pic,2
                    dc.l     player_spr34_pic,0
                    dc.l     player_spr14_pic,2,-1,-1
lbL013CE2:          dc.l     player_spr35_pic,0
                    dc.l     player_spr5_pic,2
                    dc.l     player_spr35_pic,0
                    dc.l     player_spr15_pic,2
                    dc.l     player_spr35_pic,0
                    dc.l     player_spr25_pic,2
                    dc.l     player_spr35_pic,0
                    dc.l     player_spr15_pic,2,-1,-1
lbL013D2A:          dc.l     player_spr36_pic,0
                    dc.l     player_spr6_pic,2
                    dc.l     player_spr36_pic,0
                    dc.l     player_spr16_pic,2
                    dc.l     player_spr36_pic,0
                    dc.l     player_spr26_pic,2
                    dc.l     player_spr36_pic,0
                    dc.l     player_spr16_pic,2,-1,-1
lbL013D72:          dc.l     player_spr37_pic,0
                    dc.l     player_spr7_pic,2
                    dc.l     player_spr37_pic,0
                    dc.l     player_spr17_pic,2
                    dc.l     player_spr37_pic,0
                    dc.l     player_spr27_pic,2
                    dc.l     player_spr37_pic,0
                    dc.l     player_spr17_pic,2,-1,-1
lbL013DBA:          dc.l     player_spr38_pic,0
                    dc.l     player_spr8_pic,2
                    dc.l     player_spr38_pic,0
                    dc.l     player_spr18_pic,2
                    dc.l     player_spr38_pic,0
                    dc.l     player_spr28_pic,2
                    dc.l     player_spr38_pic,0
                    dc.l     player_spr18_pic,2,-1,-1
lbL013E02:          dc.l     player_spr1_pic,1
                    dc.l     player_spr9_pic,1
                    dc.l     player_spr11_pic,1
                    dc.l     player_spr9_pic,1,-1,-1
lbL013E2A:          dc.l     player_spr2_pic,1
                    dc.l     player_spr10_pic,1
                    dc.l     player_spr12_pic,1
                    dc.l     player_spr10_pic,1,-1,-1
lbL013E52:          dc.l     player_spr3_pic,1
                    dc.l     player_spr19_pic,1
                    dc.l     player_spr13_pic,1
                    dc.l     player_spr19_pic,1,-1,-1
lbL013E7A:          dc.l     player_spr4_pic,1
                    dc.l     player_spr20_pic,1
                    dc.l     player_spr14_pic,1
                    dc.l     player_spr20_pic,1,-1,-1
lbL013EA2:          dc.l     player_spr5_pic,1
                    dc.l     player_spr29_pic,1
                    dc.l     player_spr15_pic,1
                    dc.l     player_spr29_pic,1,-1,-1
lbL013ECA:          dc.l     player_spr6_pic,1
                    dc.l     player_spr30_pic,1
                    dc.l     player_spr16_pic,1
                    dc.l     player_spr30_pic,1,-1,-1
lbL013EF2:          dc.l     player_spr7_pic,1
                    dc.l     player_spr39_pic,1
                    dc.l     player_spr17_pic,1
                    dc.l     player_spr39_pic,1,-1,-1
lbL013F1A:          dc.l     player_spr8_pic,1
                    dc.l     player_spr40_pic,1
                    dc.l     player_spr18_pic,1
                    dc.l     player_spr40_pic,1,-1,-1
lbL013F42:          dc.l     player_spr1_pic,4
                    dc.l     player_spr9_pic,4,-1,-1
lbL013F5A:          dc.l     player_spr2_pic,4
                    dc.l     player_spr10_pic,4,-1,-1
lbL013F72:          dc.l     player_spr3_pic,4
                    dc.l     player_spr19_pic,4,-1,-1
lbL013F8A:          dc.l     player_spr4_pic,4
                    dc.l     player_spr20_pic,4,-1,-1
lbL013FA2:          dc.l     player_spr5_pic,4
                    dc.l     player_spr29_pic,4,-1,-1
lbL013FBA:          dc.l     player_spr6_pic,4
                    dc.l     player_spr30_pic,4,-1,-1
lbL013FD2:          dc.l     player_spr7_pic,4
                    dc.l     player_spr39_pic,4,-1,-1
lbL013FEA:          dc.l     player_spr8_pic,4
                    dc.l     player_spr40_pic,4,-1,-1
lbL014002:          dc.l     lbL098E2C,4
                    dc.l     player_spr1_pic,4,-1,-1
lbL01401A:          dc.l     lbL098E2C,4
                    dc.l     player_spr2_pic,4,-1,-1
lbL014032:          dc.l     lbL098E2C,4
                    dc.l     player_spr3_pic,4,-1,-1
lbL01404A:          dc.l     lbL098E2C,4
                    dc.l     player_spr4_pic,4,-1,-1
lbL014062:          dc.l     lbL098E2C,4
                    dc.l     player_spr5_pic,4,-1,-1
lbL01407A:          dc.l     lbL098E2C,4
                    dc.l     player_spr6_pic,4,-1,-1
lbL014092:          dc.l     lbL098E2C,4
                    dc.l     player_spr7_pic,4,-1,-1
lbL0140AA:          dc.l     lbL098E2C,4
                    dc.l     player_spr8_pic,4,-1,-1
lbL0140C2:          dc.l     player_spr41_pic,2,-1,-1
lbL0140D2:          dc.l     player_spr42_pic,2,-1,-1
lbL0140E2:          dc.l     player_spr43_pic,2,-1,-1
lbL0140F2:          dc.l     player_spr44_pic,2,-1,-1
lbL014102:          dc.l     player_spr45_pic,2,-1,-1
lbL014112:          dc.l     player_spr46_pic,2,-1,-1
lbL014122:          dc.l     player_spr47_pic,2,-1,-1
lbL014132:          dc.l     player_spr48_pic,2,-1,-1
lbL014142:          dc.l     player_spr41_pic,2
                    dc.l     player_spr51_pic,2
                    dc.l     player_spr61_pic,2
                    dc.l     player_spr51_pic,2,-1,-1
lbL01416A:          dc.l     player_spr42_pic,2
                    dc.l     player_spr52_pic,2
                    dc.l     player_spr62_pic,2
                    dc.l     player_spr52_pic,2,-1,-1
lbL014192:          dc.l     player_spr43_pic,2
                    dc.l     player_spr53_pic,2
                    dc.l     player_spr63_pic,2
                    dc.l     player_spr53_pic,2,-1,-1
lbL0141BA:          dc.l     player_spr44_pic,2
                    dc.l     player_spr54_pic,2
                    dc.l     player_spr64_pic,2
                    dc.l     player_spr54_pic,2,-1,-1
lbL0141E2:          dc.l     player_spr45_pic,2
                    dc.l     player_spr55_pic,2
                    dc.l     player_spr65_pic,2
                    dc.l     player_spr55_pic,2,-1,-1
lbL01420A:          dc.l     player_spr46_pic,2
                    dc.l     player_spr56_pic,2
                    dc.l     player_spr66_pic,2
                    dc.l     player_spr56_pic,2,-1,-1
lbL014232:          dc.l     player_spr47_pic,2
                    dc.l     player_spr57_pic,2
                    dc.l     player_spr67_pic,2
                    dc.l     player_spr57_pic,2,-1,-1
lbL01425A:          dc.l     player_spr48_pic,2
                    dc.l     player_spr58_pic,2
                    dc.l     player_spr68_pic,2
                    dc.l     player_spr58_pic,2,-1,-1
lbL014282:          dc.l     player_spr71_pic,1
                    dc.l     player_spr61_pic,1,-1,-1
lbL01429A:          dc.l     player_spr72_pic,1
                    dc.l     player_spr62_pic,1,-1,-1
lbL0142B2:          dc.l     player_spr73_pic,1
                    dc.l     player_spr63_pic,1,-1,-1
lbL0142CA:          dc.l     player_spr74_pic,1
                    dc.l     player_spr64_pic,1,-1,-1
lbL0142E2:          dc.l     player_spr75_pic,1
                    dc.l     player_spr65_pic,1,-1,-1
lbL0142FA:          dc.l     player_spr76_pic,1
                    dc.l     player_spr66_pic,1,-1,-1
lbL014312:          dc.l     player_spr77_pic,1
                    dc.l     player_spr67_pic,1,-1,-1
lbL01432A:          dc.l     player_spr78_pic,1
                    dc.l     player_spr68_pic,1,-1,-1
lbL014342:          dc.l     player_spr61_pic,1
                    dc.l     player_spr71_pic,1,-1,-1
lbL01435A:          dc.l     player_spr62_pic,1
                    dc.l     player_spr72_pic,1,-1,-1
lbL014372:          dc.l     player_spr63_pic,1
                    dc.l     player_spr73_pic,1,-1,-1
lbL01438A:          dc.l     player_spr64_pic,1
                    dc.l     player_spr74_pic,1,-1,-1
lbL0143A2:          dc.l     player_spr65_pic,1
                    dc.l     player_spr75_pic,1,-1,-1
lbL0143BA:          dc.l     player_spr66_pic,1
                    dc.l     player_spr76_pic,1,-1,-1
lbL0143D2:          dc.l     player_spr67_pic,1
                    dc.l     player_spr77_pic,1,-1,-1
lbL0143EA:          dc.l     player_spr68_pic,1
                    dc.l     player_spr78_pic,1,-1,-1
lbL014402:          dc.l     player_spr41_pic,1
                    dc.l     player_spr49_pic,1
                    dc.l     player_spr51_pic,1
                    dc.l     player_spr49_pic,1,-1,-1
lbL01442A:          dc.l     player_spr42_pic,1
                    dc.l     player_spr50_pic,1
                    dc.l     player_spr52_pic,1
                    dc.l     player_spr50_pic,1,-1,-1
lbL014452:          dc.l     player_spr43_pic,1
                    dc.l     player_spr59_pic,1
                    dc.l     player_spr53_pic,1
                    dc.l     player_spr59_pic,1,-1,-1
lbL01447A:          dc.l     player_spr44_pic,1
                    dc.l     player_spr60_pic,1
                    dc.l     player_spr54_pic,1
                    dc.l     player_spr60_pic,1,-1,-1
lbL0144A2:          dc.l     player_spr45_pic,1
                    dc.l     player_spr69_pic,1
                    dc.l     player_spr55_pic,1
                    dc.l     player_spr69_pic,1,-1,-1
lbL0144CA:          dc.l     player_spr46_pic,1
                    dc.l     player_spr70_pic,1
                    dc.l     player_spr56_pic,1
                    dc.l     player_spr70_pic,1,-1,-1
lbL0144F2:          dc.l     player_spr47_pic,1
                    dc.l     player_spr79_pic,1
                    dc.l     player_spr57_pic,1
                    dc.l     player_spr79_pic,1,-1,-1
lbL01451A:          dc.l     player_spr48_pic,1
                    dc.l     player_spr80_pic,1
                    dc.l     player_spr58_pic,1
                    dc.l     player_spr80_pic,1,-1,-1
lbL014542:          dc.l     player_spr41_pic,4
                    dc.l     player_spr49_pic,4,-1
lbL014556:          dc.l     player_spr42_pic,4
                    dc.l     player_spr50_pic,4,-1
lbL01456A:          dc.l     player_spr43_pic,4
                    dc.l     player_spr59_pic,4,-1
lbL01457E:          dc.l     player_spr44_pic,4
                    dc.l     player_spr60_pic,4,-1
lbL014592:          dc.l     player_spr45_pic,4
                    dc.l     player_spr69_pic,4,-1
lbL0145A6:          dc.l     player_spr46_pic,4
                    dc.l     player_spr70_pic,4,-1
lbL0145BA:          dc.l     player_spr47_pic,4
                    dc.l     player_spr79_pic,4,-1
lbL0145CE:          dc.l     player_spr48_pic,4
                    dc.l     player_spr80_pic,4,-1
lbL0145E2:          dc.l     lbL098E2C,4
                    dc.l     player_spr41_pic,4,-1,-1
lbL0145FA:          dc.l     lbL098E2C,4
                    dc.l     player_spr42_pic,4,-1,-1
lbL014612:          dc.l     lbL098E2C,4
                    dc.l     player_spr43_pic,4,-1,-1
lbL01462A:          dc.l     lbL098E2C,4
                    dc.l     player_spr44_pic,4,-1,-1
lbL014642:          dc.l     lbL098E2C,4
                    dc.l     player_spr5_pic,4,-1,-1
lbL01465A:          dc.l     lbL098E2C,4
                    dc.l     player_spr46_pic,4,-1,-1
lbL014672:          dc.l     lbL098E2C,4
                    dc.l     player_spr47_pic,4,-1,-1
lbL01468A:          dc.l     lbL098E2C,4
                    dc.l     player_spr48_pic,4,-1,-1
lbL0146A2:          dc.l     lbL098E2C,$7530,-1,-1

lbL0146B2:          dc.l     lbL014DEA,0
                    dc.l     lbL014E1A,0
                    dc.l     lbL014E4A,0
                    dc.l     lbL014E7A,0
                    dc.l     lbL014EAA,0
                    dc.l     lbL014EDA,0
                    dc.l     lbL014F0A,0
                    dc.l     lbL014F3A,0
                    dc.l     lbL014F6A,0
                    dc.l     lbL014F9A,0
                    dc.l     lbL014FCA,0
                    dc.l     lbL014FFA,0
                    dc.l     lbL01502A,0
                    dc.l     lbL01505A,0
                    dc.l     lbL01508A,0
                    dc.l     lbL0150BA,0
                    dc.l     lbL0150EA,0
                    dc.l     lbL01511A,0
                    dc.l     lbL01514A,0
                    dc.l     lbL01517A,0
                    dc.l     lbL0151AA,0
                    dc.l     lbL0151DA,0
                    dc.l     lbL01520A,0
                    dc.l     lbL01523A,0
                    dc.l     lbL01526A,0
                    dc.l     lbL01529A,0
                    dc.l     lbL0152CA,0
                    dc.l     lbL0152FA,0
                    dc.l     lbL01532A,0
                    dc.l     lbL01535A,0
                    dc.l     lbL01538A,0
                    dc.l     lbL0153BA,0
                    dc.l     lbL0153EA,0
                    dc.l     lbL01541A,0
                    dc.l     lbL01544A,0
                    dc.l     lbL01547A,0
                    dc.l     lbL0154AA,0
                    dc.l     lbL0154DA,0
                    dc.l     lbL01550A,0
                    dc.l     lbL01553A,0
                    dc.l     lbL01556A,0
                    dc.l     lbL01559A,0
                    dc.l     lbL0155CA,0
                    dc.l     lbL0155FA,0
                    dc.l     lbL01562A,0
                    dc.l     lbL01565A,0
                    dc.l     lbL01568A,0
                    dc.l     lbL0156BA,0
                    dc.l     lbL0156EA,0
                    dc.l     lbL01571A,0
                    dc.l     lbL01574A,0
                    dc.l     lbL01577A,0
                    dc.l     lbL0157AA,0
                    dc.l     lbL0157DA,0
                    dc.l     lbL01580A,0
                    dc.l     lbL01583A,0
                    dc.l     lbL01586A,0
                    dc.l     lbL01589A,0
                    dc.l     lbL0158CA,0
                    dc.l     lbL0158FA,0
                    dc.l     lbL01592A,0
                    dc.l     lbL01595A,0
                    dc.l     lbL01598A,0
                    dc.l     lbL0159BA,0
                    dc.l     lbL0159EA,0
                    dc.l     lbL015A1A,0
                    dc.l     lbL015A4A,0
                    dc.l     lbL015A7A,0
                    dc.l     lbL015AAA,0
                    dc.l     lbL015ADA,0
                    dc.l     lbL015B0A,0
                    dc.l     lbL015B3A,0
                    dc.l     lbL015B6A,0
                    dc.l     lbL015B9A,0
                    dc.l     lbL015BCA,0
                    dc.l     lbL015BFA,0
                    dc.l     lbL015C2A,0
                    dc.l     lbL015C5A,0
                    dc.l     lbL015C8A,0
                    dc.l     lbL015CBA,0
                    dc.l     lbL015CEA,0
                    dc.l     lbL015D1A,0
                    dc.l     lbL015D4A,0
                    dc.l     lbL015D7A,0
                    dc.l     lbL015DAA,0
                    dc.l     lbL015DDA,0
                    dc.l     lbL015E0A,0
                    dc.l     lbL015E3A,0
                    dc.l     lbL015E6A,0
                    dc.l     lbL015E9A,0
                    dc.l     lbL015ECA,0
                    dc.l     lbL015EFA,0
                    dc.l     lbL015F2A,0
                    dc.l     lbL015F5A,0
                    dc.l     lbL015F8A,0
                    dc.l     lbL015FBA,0
                    dc.l     lbL015FEA,0
                    dc.l     lbL01601A,0
                    dc.l     lbL01604A,0
                    dc.l     lbL01607A,0
                    dc.l     lbL0160AA,0
                    dc.l     lbL0160DA,0
                    dc.l     lbL01610A,0
                    dc.l     lbL01613A,0
                    dc.l     lbL01616A,0
                    dc.l     lbL01619A,0
                    dc.l     lbL0161CA,0
                    dc.l     lbL0161FA,0
                    dc.l     lbL01622A,0
                    dc.l     lbL01625A,0
                    dc.l     lbL01628A,0
                    dc.l     lbL0162BA,0
                    dc.l     lbL0162EA,0
                    dc.l     lbL01631A,0
                    dc.l     lbL01634A,0
                    dc.l     lbL01637A,0
                    dc.l     lbL0163AA,0
                    dc.l     lbL0163DA,0
                    dc.l     lbL01640A,0
                    dc.l     lbL01643A,0
                    dc.l     lbL01646A,0
                    dc.l     lbL01649A,0
                    dc.l     lbL0164CA,0
                    dc.l     lbL0164FA,0
                    dc.l     lbL01652A,0
                    dc.l     lbL01655A,0
                    dc.l     lbL01658A,0
                    dc.l     lbL0165BA,0
                    dc.l     -1

lbL014AB6:          dc.l     lbL0165EA,0
                    dc.l     lbL01661A,0
                    dc.l     lbL01664A,0
                    dc.l     lbL01667A,0
                    dc.l     lbL0166AA,0
                    dc.l     lbL0166DA,0
                    dc.l     lbL01670A,0
                    dc.l     lbL01673A,0
                    dc.l     lbL01676A,0
                    dc.l     lbL01679A,0
                    dc.l     lbL0167CA,0
                    dc.l     lbL0167FA,0
                    dc.l     lbL01682A,0
                    dc.l     lbL01685A,0
                    dc.l     lbL01688A,0
                    dc.l     lbL0168BA,0
                    dc.l     lbL0168EA,0
                    dc.l     lbL01691A,0
                    dc.l     lbL01694A,0
                    dc.l     lbL01697A,0
                    dc.l     lbL0169AA,0
                    dc.l     lbL0169DA,0
                    dc.l     lbL016A0A,0
                    dc.l     lbL016A3A,0
                    dc.l     lbL016A6A,0
                    dc.l     lbL016A9A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016B5A,0
                    dc.l     lbL016B8A,0
                    dc.l     lbL016BBA,0
                    dc.l     lbL016BEA,0
                    dc.l     lbL016C1A,0
                    dc.l     lbL016C4A,0
                    dc.l     lbL016C7A,0
                    dc.l     lbL016CAA,0
                    dc.l     lbL016CDA,0
                    dc.l     lbL016D0A,0
                    dc.l     lbL016D3A,0
                    dc.l     lbL016D6A,0
                    dc.l     lbL016D9A,0
                    dc.l     lbL016DCA,0
                    dc.l     lbL016DFA,0
                    dc.l     lbL016E2A,0
                    dc.l     lbL016E5A,0
                    dc.l     lbL016E8A,0
                    dc.l     lbL016EBA,0
                    dc.l     lbL016EEA,0
                    dc.l     lbL016F1A,0
                    dc.l     lbL016F4A,0
                    dc.l     lbL016F7A,0
                    dc.l     lbL016FAA,0
                    dc.l     lbL016FDA,0
                    dc.l     lbL01700A,0
                    dc.l     lbL01703A,0
                    dc.l     lbL01706A,0
                    dc.l     lbL01709A,0
                    dc.l     lbL0170CA,0
                    dc.l     lbL0170FA,0
                    dc.l     lbL01712A,0
                    dc.l     lbL01715A,0
                    dc.l     lbL01718A,0
                    dc.l     lbL0171BA,0
                    dc.l     lbL0171EA,0
                    dc.l     lbL01721A,0
                    dc.l     lbL01724A,0
                    dc.l     lbL01727A,0
                    dc.l     lbL0172AA,0
                    dc.l     lbL0172DA,0
                    dc.l     lbL01730A,0
                    dc.l     lbL01733A,0
                    dc.l     lbL01736A,0
                    dc.l     lbL01739A,0
                    dc.l     lbL0173CA,0
                    dc.l     lbL0173FA,0
                    dc.l     lbL01742A,0
                    dc.l     lbL01745A,0
                    dc.l     lbL01748A,0
                    dc.l     lbL0174BA,0
                    dc.l     lbL0174EA,0
                    dc.l     lbL01751A,0
                    dc.l     lbL01754A,0
                    dc.l     lbL01757A,0
                    dc.l     lbL0175AA,0
                    dc.l     lbL0175DA,0
                    dc.l     lbL01760A,0
                    dc.l     lbL01763A,0
                    dc.l     lbL01766A,0
                    dc.l     lbL01769A,0
                    dc.l     lbL0176CA,0
                    dc.l     lbL0176FA,0
                    dc.l     lbL01772A,0
                    dc.l     lbL01775A,0
                    dc.l     lbL01778A,0
                    dc.l     lbL0177BA,0
                    dc.l     lbL0177EA,0
                    dc.l     lbL01781A,0
                    dc.l     lbL01784A,0
                    dc.l     lbL01787A,0
                    dc.l     lbL0178AA,0
                    dc.l     lbL0178DA,0
                    dc.l     -1

lbL014DEA:          dcb.l    12,0
lbL014E1A:          dcb.l    12,0
lbL014E4A:          dcb.l    12,0
lbL014E7A:          dcb.l    12,0
lbL014EAA:          dcb.l    12,0
lbL014EDA:          dcb.l    12,0
lbL014F0A:          dcb.l    12,0
lbL014F3A:          dcb.l    12,0
lbL014F6A:          dcb.l    12,0
lbL014F9A:          dcb.l    12,0
lbL014FCA:          dcb.l    12,0
lbL014FFA:          dcb.l    12,0
lbL01502A:          dcb.l    12,0
lbL01505A:          dcb.l    12,0
lbL01508A:          dcb.l    12,0
lbL0150BA:          dcb.l    12,0
lbL0150EA:          dcb.l    12,0
lbL01511A:          dcb.l    12,0
lbL01514A:          dcb.l    12,0
lbL01517A:          dcb.l    12,0
lbL0151AA:          dcb.l    12,0
lbL0151DA:          dcb.l    12,0
lbL01520A:          dcb.l    12,0
lbL01523A:          dcb.l    12,0
lbL01526A:          dcb.l    12,0
lbL01529A:          dcb.l    12,0
lbL0152CA:          dcb.l    12,0
lbL0152FA:          dcb.l    12,0
lbL01532A:          dcb.l    12,0
lbL01535A:          dcb.l    12,0
lbL01538A:          dcb.l    12,0
lbL0153BA:          dcb.l    12,0
lbL0153EA:          dcb.l    12,0
lbL01541A:          dcb.l    12,0
lbL01544A:          dcb.l    12,0
lbL01547A:          dcb.l    12,0
lbL0154AA:          dcb.l    12,0
lbL0154DA:          dcb.l    12,0
lbL01550A:          dcb.l    12,0
lbL01553A:          dcb.l    12,0
lbL01556A:          dcb.l    12,0
lbL01559A:          dcb.l    12,0
lbL0155CA:          dcb.l    12,0
lbL0155FA:          dcb.l    12,0
lbL01562A:          dcb.l    12,0
lbL01565A:          dcb.l    12,0
lbL01568A:          dcb.l    12,0
lbL0156BA:          dcb.l    12,0
lbL0156EA:          dcb.l    12,0
lbL01571A:          dcb.l    12,0
lbL01574A:          dcb.l    12,0
lbL01577A:          dcb.l    12,0
lbL0157AA:          dcb.l    12,0
lbL0157DA:          dcb.l    12,0
lbL01580A:          dcb.l    12,0
lbL01583A:          dcb.l    12,0
lbL01586A:          dcb.l    12,0
lbL01589A:          dcb.l    12,0
lbL0158CA:          dcb.l    12,0
lbL0158FA:          dcb.l    12,0
lbL01592A:          dcb.l    12,0
lbL01595A:          dcb.l    12,0
lbL01598A:          dcb.l    12,0
lbL0159BA:          dcb.l    12,0
lbL0159EA:          dcb.l    12,0
lbL015A1A:          dcb.l    12,0
lbL015A4A:          dcb.l    12,0
lbL015A7A:          dcb.l    12,0
lbL015AAA:          dcb.l    12,0
lbL015ADA:          dcb.l    12,0
lbL015B0A:          dcb.l    12,0
lbL015B3A:          dcb.l    12,0
lbL015B6A:          dcb.l    12,0
lbL015B9A:          dcb.l    12,0
lbL015BCA:          dcb.l    12,0
lbL015BFA:          dcb.l    12,0
lbL015C2A:          dcb.l    12,0
lbL015C5A:          dcb.l    12,0
lbL015C8A:          dcb.l    12,0
lbL015CBA:          dcb.l    12,0
lbL015CEA:          dcb.l    12,0
lbL015D1A:          dcb.l    12,0
lbL015D4A:          dcb.l    12,0
lbL015D7A:          dcb.l    12,0
lbL015DAA:          dcb.l    12,0
lbL015DDA:          dcb.l    12,0
lbL015E0A:          dcb.l    12,0
lbL015E3A:          dcb.l    12,0
lbL015E6A:          dcb.l    12,0
lbL015E9A:          dcb.l    12,0
lbL015ECA:          dcb.l    12,0
lbL015EFA:          dcb.l    12,0
lbL015F2A:          dcb.l    12,0
lbL015F5A:          dcb.l    12,0
lbL015F8A:          dcb.l    12,0
lbL015FBA:          dcb.l    12,0
lbL015FEA:          dcb.l    12,0
lbL01601A:          dcb.l    12,0
lbL01604A:          dcb.l    12,0
lbL01607A:          dcb.l    12,0
lbL0160AA:          dcb.l    12,0
lbL0160DA:          dcb.l    12,0
lbL01610A:          dcb.l    12,0
lbL01613A:          dcb.l    12,0
lbL01616A:          dcb.l    12,0
lbL01619A:          dcb.l    12,0
lbL0161CA:          dcb.l    12,0
lbL0161FA:          dcb.l    12,0
lbL01622A:          dcb.l    12,0
lbL01625A:          dcb.l    12,0
lbL01628A:          dcb.l    12,0
lbL0162BA:          dcb.l    12,0
lbL0162EA:          dcb.l    12,0
lbL01631A:          dcb.l    12,0
lbL01634A:          dcb.l    12,0
lbL01637A:          dcb.l    12,0
lbL0163AA:          dcb.l    12,0
lbL0163DA:          dcb.l    12,0
lbL01640A:          dcb.l    12,0
lbL01643A:          dcb.l    12,0
lbL01646A:          dcb.l    12,0
lbL01649A:          dcb.l    12,0
lbL0164CA:          dcb.l    12,0
lbL0164FA:          dcb.l    12,0
lbL01652A:          dcb.l    12,0
lbL01655A:          dcb.l    12,0
lbL01658A:          dcb.l    12,0
lbL0165BA:          dcb.l    12,0
lbL0165EA:          dcb.l    12,0
lbL01661A:          dcb.l    12,0
lbL01664A:          dcb.l    12,0
lbL01667A:          dcb.l    12,0
lbL0166AA:          dcb.l    12,0
lbL0166DA:          dcb.l    12,0
lbL01670A:          dcb.l    12,0
lbL01673A:          dcb.l    12,0
lbL01676A:          dcb.l    12,0
lbL01679A:          dcb.l    12,0
lbL0167CA:          dcb.l    12,0
lbL0167FA:          dcb.l    12,0
lbL01682A:          dcb.l    12,0
lbL01685A:          dcb.l    12,0
lbL01688A:          dcb.l    12,0
lbL0168BA:          dcb.l    12,0
lbL0168EA:          dcb.l    12,0
lbL01691A:          dcb.l    12,0
lbL01694A:          dcb.l    12,0
lbL01697A:          dcb.l    12,0
lbL0169AA:          dcb.l    12,0
lbL0169DA:          dcb.l    12,0
lbL016A0A:          dcb.l    12,0
lbL016A3A:          dcb.l    12,0
lbL016A6A:          dcb.l    12,0
lbL016A9A:          dcb.l    12,0
lbL016ACA:          dcb.l    12,0
lbL016AFA:          dcb.l    12,0
lbL016B2A:          dcb.l    12,0
lbL016B5A:          dcb.l    12,0
lbL016B8A:          dcb.l    12,0
lbL016BBA:          dcb.l    12,0
lbL016BEA:          dcb.l    12,0
lbL016C1A:          dcb.l    12,0
lbL016C4A:          dcb.l    12,0
lbL016C7A:          dcb.l    12,0
lbL016CAA:          dcb.l    12,0
lbL016CDA:          dcb.l    12,0
lbL016D0A:          dcb.l    12,0
lbL016D3A:          dcb.l    12,0
lbL016D6A:          dcb.l    12,0
lbL016D9A:          dcb.l    12,0
lbL016DCA:          dcb.l    12,0
lbL016DFA:          dcb.l    12,0
lbL016E2A:          dcb.l    12,0
lbL016E5A:          dcb.l    12,0
lbL016E8A:          dcb.l    12,0
lbL016EBA:          dcb.l    12,0
lbL016EEA:          dcb.l    12,0
lbL016F1A:          dcb.l    12,0
lbL016F4A:          dcb.l    12,0
lbL016F7A:          dcb.l    12,0
lbL016FAA:          dcb.l    12,0
lbL016FDA:          dcb.l    12,0
lbL01700A:          dcb.l    12,0
lbL01703A:          dcb.l    12,0
lbL01706A:          dcb.l    12,0
lbL01709A:          dcb.l    12,0
lbL0170CA:          dcb.l    12,0
lbL0170FA:          dcb.l    12,0
lbL01712A:          dcb.l    12,0
lbL01715A:          dcb.l    12,0
lbL01718A:          dcb.l    12,0
lbL0171BA:          dcb.l    12,0
lbL0171EA:          dcb.l    12,0
lbL01721A:          dcb.l    12,0
lbL01724A:          dcb.l    12,0
lbL01727A:          dcb.l    12,0
lbL0172AA:          dcb.l    12,0
lbL0172DA:          dcb.l    12,0
lbL01730A:          dcb.l    12,0
lbL01733A:          dcb.l    12,0
lbL01736A:          dcb.l    12,0
lbL01739A:          dcb.l    12,0
lbL0173CA:          dcb.l    12,0
lbL0173FA:          dcb.l    12,0
lbL01742A:          dcb.l    12,0
lbL01745A:          dcb.l    12,0
lbL01748A:          dcb.l    12,0
lbL0174BA:          dcb.l    12,0
lbL0174EA:          dcb.l    12,0
lbL01751A:          dcb.l    12,0
lbL01754A:          dcb.l    12,0
lbL01757A:          dcb.l    12,0
lbL0175AA:          dcb.l    12,0
lbL0175DA:          dcb.l    12,0
lbL01760A:          dcb.l    12,0
lbL01763A:          dcb.l    12,0
lbL01766A:          dcb.l    12,0
lbL01769A:          dcb.l    12,0
lbL0176CA:          dcb.l    12,0
lbL0176FA:          dcb.l    12,0
lbL01772A:          dcb.l    12,0
lbL01775A:          dcb.l    12,0
lbL01778A:          dcb.l    12,0
lbL0177BA:          dcb.l    12,0
lbL0177EA:          dcb.l    12,0
lbL01781A:          dcb.l    12,0
lbL01784A:          dcb.l    12,0
lbL01787A:          dcb.l    12,0
lbL0178AA:          dcb.l    12,0
lbL0178DA:          dcb.l    12,0

lbL01790A:          dc.l     lbL017B4E,0
                    dc.l     lbL017B7E,0
                    dc.l     lbL017BAE,0
                    dc.l     lbL017BDE,0
                    dc.l     lbL017C0E,0
                    dc.l     lbL017C3E,0
                    dc.l     lbL017C6E,0
                    dc.l     lbL017C9E,0
                    dc.l     lbL017CCE,0
                    dc.l     lbL017CFE,0
                    dc.l     lbL017D2E,0
                    dc.l     lbL017D5E,0
                    dc.l     lbL017D8E,0
                    dc.l     lbL017DBE,0
                    dc.l     lbL017DEE,0
                    dc.l     lbL017E1E,0
                    dc.l     lbL017E4E,0
                    dc.l     lbL017E7E,0
                    dc.l     lbL017EAE,0
                    dc.l     lbL017EDE,0
                    dc.l     lbL017F0E,0
                    dc.l     lbL017F3E,0
                    dc.l     lbL017F6E,0
                    dc.l     lbL017F9E,0
                    dc.l     lbL017FCE,0
                    dc.l     lbL017FFE,0
                    dc.l     lbL01802E,0
                    dc.l     lbL01805E,0
                    dc.l     lbL01808E,0
                    dc.l     lbL0180BE,0
                    dc.l     lbL0180EE,0
                    dc.l     lbL01811E,0
                    dc.l     lbL01814E,0
                    dc.l     lbL01817E,0
                    dc.l     lbL0181AE,0
                    dc.l     lbL0181DE,0
                    dc.l     lbL01820E,0
                    dc.l     lbL01823E,0
                    dc.l     lbL01826E,0
                    dc.l     lbL01829E,0
                    dc.l     lbL0182CE,0
                    dc.l     lbL0182FE,0
                    dc.l     lbL01832E,0
                    dc.l     lbL01835E,0
                    dc.l     lbL01838E,0
                    dc.l     lbL0183BE,0
                    dc.l     lbL0183EE,0
                    dc.l     lbL01841E,0
                    dc.l     lbL01844E,0
                    dc.l     lbL01847E,0
                    dc.l     lbL0184AE,0
                    dc.l     lbL0184DE,0
                    dc.l     lbL01850E,0
                    dc.l     lbL01853E,0
                    dc.l     lbL01856E,0
                    dc.l     lbL01859E,0
                    dc.l     lbL0185CE,0
                    dc.l     lbL0185FE,0
                    dc.l     lbL01862E,0
                    dc.l     lbL01865E,0
                    dc.l     lbL01868E,0
                    dc.l     lbL0186BE,0
                    dc.l     lbL0186EE,0
                    dc.l     lbL01871E,0
                    dc.l     lbL01874E,0
                    dc.l     lbL01877E,0
                    dc.l     lbL0187AE,0
                    dc.l     lbL0187DE,0
                    dc.l     lbL01880E,0
                    dc.l     lbL01883E,0
                    dc.l     lbL01886E,0
                    dc.l     lbL01889E,0
                    dc.l     -1

lbL017B4E:          dcb.l    12,0
lbL017B7E:          dcb.l    12,0
lbL017BAE:          dcb.l    12,0
lbL017BDE:          dcb.l    12,0
lbL017C0E:          dcb.l    12,0
lbL017C3E:          dcb.l    12,0
lbL017C6E:          dcb.l    12,0
lbL017C9E:          dcb.l    12,0
lbL017CCE:          dcb.l    12,0
lbL017CFE:          dcb.l    12,0
lbL017D2E:          dcb.l    12,0
lbL017D5E:          dcb.l    12,0
lbL017D8E:          dcb.l    12,0
lbL017DBE:          dcb.l    12,0
lbL017DEE:          dcb.l    12,0
lbL017E1E:          dcb.l    12,0
lbL017E4E:          dcb.l    12,0
lbL017E7E:          dcb.l    12,0
lbL017EAE:          dcb.l    12,0
lbL017EDE:          dcb.l    12,0
lbL017F0E:          dcb.l    12,0
lbL017F3E:          dcb.l    12,0
lbL017F6E:          dcb.l    12,0
lbL017F9E:          dcb.l    12,0
lbL017FCE:          dcb.l    12,0
lbL017FFE:          dcb.l    12,0
lbL01802E:          dcb.l    12,0
lbL01805E:          dcb.l    12,0
lbL01808E:          dcb.l    12,0
lbL0180BE:          dcb.l    12,0
lbL0180EE:          dcb.l    12,0
lbL01811E:          dcb.l    12,0
lbL01814E:          dcb.l    12,0
lbL01817E:          dcb.l    12,0
lbL0181AE:          dcb.l    12,0
lbL0181DE:          dcb.l    12,0
lbL01820E:          dcb.l    12,0
lbL01823E:          dcb.l    12,0
lbL01826E:          dcb.l    12,0
lbL01829E:          dcb.l    12,0
lbL0182CE:          dcb.l    12,0
lbL0182FE:          dcb.l    12,0
lbL01832E:          dcb.l    12,0
lbL01835E:          dcb.l    12,0
lbL01838E:          dcb.l    12,0
lbL0183BE:          dcb.l    12,0
lbL0183EE:          dcb.l    12,0
lbL01841E:          dcb.l    12,0
lbL01844E:          dcb.l    12,0
lbL01847E:          dcb.l    12,0
lbL0184AE:          dcb.l    12,0
lbL0184DE:          dcb.l    12,0
lbL01850E:          dcb.l    12,0
lbL01853E:          dcb.l    12,0
lbL01856E:          dcb.l    12,0
lbL01859E:          dcb.l    12,0
lbL0185CE:          dcb.l    12,0
lbL0185FE:          dcb.l    12,0
lbL01862E:          dcb.l    12,0
lbL01865E:          dcb.l    12,0
lbL01868E:          dcb.l    12,0
lbL0186BE:          dcb.l    12,0
lbL0186EE:          dcb.l    12,0
lbL01871E:          dcb.l    12,0
lbL01874E:          dcb.l    12,0
lbL01877E:          dcb.l    12,0
lbL0187AE:          dcb.l    12,0
lbL0187DE:          dcb.l    12,0
lbL01880E:          dcb.l    12,0
lbL01883E:          dcb.l    12,0
lbL01886E:          dcb.l    12,0
lbL01889E:          dcb.l    12,0

lbW0188CE:          dc.w    $C0,$A0,$10,$0E,$00,$00
                    dc.w    $D0,$A0,$10,$0E,$00,$00
                    dc.w    $E0,$A0,$10,$0E,$00,$00
                    dc.w    $F0,$A0,$10,$0E,$00,$00
                    dc.w    $100,$A0,$10,$0E,$00,$00
                    dc.w    $110,$A0,$10,$0E,$00,$00
                    dc.w    $120,$A0,$10,$0E,$00,$00
                    dc.w    $130,$A0,$10,$0E,$00,$00
                    dc.w    $C0,$B0,$10,$0E,$00,$00
                    dc.w    $D0,$B0,$10,$0E,$00,$00
                    dc.w    $E0,$B0,$10,$0E,$00,$00
                    dc.w    $F0,$B0,$10,$0E,$00,$00
                    dc.w    $100,$B0,$10,$0E,$00,$00
                    dc.w    $110,$B0,$10,$0E,$00,$00
                    dc.w    $120,$B0,$10,$0E,$00,$00
                    dc.w    $130,$B0,$10,$0E,$00,$00
                    dc.w    $40,$A0,$10,$0E,$00,$00
                    dc.w    $50,$A0,$10,$0E,$00,$00
                    dc.w    $60,$A0,$10,$0E,$00,$00
                    dc.w    $70,$A0,$10,$0E,$00,$00
                    dc.w    $80,$A0,$10,$0E,$00,$00
                    dc.w    $90,$A0,$10,$0E,$00,$00
                    dc.w    $A0,$A0,$10,$0E,$00,$00
                    dc.w    $B0,$A0,$10,$0E,$00,$00
                    dc.w    $40,$B0,$10,$0E,$00,$00
                    dc.w    $50,$B0,$10,$0E,$00,$00
                    dc.w    $60,$B0,$10,$0E,$00,$00
                    dc.w    $70,$B0,$10,$0E,$00,$00
                    dc.w    $80,$B0,$10,$0E,$00,$00
                    dc.w    $90,$B0,$10,$0E,$00,$00
                    dc.w    $A0,$B0,$10,$0E,$00,$00
                    dc.w    $B0,$B0,$10,$0E,$00,$00
                    dc.w    $00,$A0,$10,$0E,$00,$00
                    dc.w    $10,$A0,$10,$0E,$00,$00
                    dc.w    $20,$A0,$10,$0E,$00,$00
                    dc.w    $30,$A0,$10,$0E,$00,$00
                    dc.w    $00,$B0,$10,$0E,$00,$00
                    dc.w    $10,$B0,$10,$0E,$00,$00
                    dc.w    $20,$B0,$10,$0E,$00,$00
                    dc.w    $30,$B0,$10,$0E,$00,$00
                    dc.w    $00,$C0,$20,$1E,$00,$00
                    dc.w    $20,$C0,$20,$1E,$00,$00
                    dc.w    $40,$C0,$20,$1E,$00,$00
                    dc.w    $60,$C0,$20,$1E,$00,$00
                    dc.w    $80,$C0,$20,$1E,$00,$00
                    dc.w    $A0,$C0,$20,$1E,$00,$00
                    dc.w    $C0,$C0,$20,$1E,$00,$00
                    dc.w    $E0,$C0,$20,$1E,$00,$00
                    dc.w    $100,$C0,$20,$1E,$00,$00
                    dc.w    $120,$C0,$20,$1E,$00,$00
                    dc.w    $00,$E0,$20,$1E,$00,$00
                    dc.w    $20,$E0,$20,$1E,$00,$00
                    dc.w    $40,$E0,$20,$1E,$00,$00
                    dc.w    $60,$E0,$20,$1E,$00,$00
                    dc.w    $80,$E0,$20,$1E,$00,$00
                    dc.w    $A0,$E0,$20,$1E,$00,$00
                    dc.w    $C0,$E0,$10,$0E,$00,$00
                    dc.w    $D0,$E0,$10,$0E,$00,$00
                    dc.w    $E0,$E0,$10,$0E,$00,$00
                    dc.w    $F0,$E0,$10,$0E,$00,$00
                    dc.w    $C0,$F0,$10,$0E,$00,$00
                    dc.w    $D0,$F0,$10,$0E,$00,$00
                    dc.w    $E0,$F0,$10,$0E,$00,$00
                    dc.w    $F0,$F0,$10,$0E,$00,$00
                    dc.w    $100,$E0,$10,$0E,$00,$00
                    dc.w    $110,$E0,$10,$0E,$00,$00
                    dc.w    $120,$E0,$10,$0E,$00,$00
                    dc.w    $130,$E0,$10,$0E,$00,$00
                    dc.w    $100,$F0,$10,$0E,$00,$00
                    dc.w    $110,$F0,$10,$0E,$00,$00
                    dc.w    $120,$F0,$10,$0E,$00,$00
                    dc.w    $130,$F0,$10,$0E,$00,$00

lbL018C2E:          dc.l     lbL0182CE,0
                    dc.l     lbL0182FE,0
                    dc.l     lbL01832E,0
                    dc.l     lbL01835E,0
                    dc.l     lbL01838E,0
                    dc.l     lbL0183BE,0
                    dc.l     lbL0183EE,0
                    dc.l     lbL01841E,0
                    dc.l     lbL01844E,0
                    dc.l     lbL01847E,0
                    dc.l     lbL0184AE,0
                    dc.l     lbL0184DE,0
                    dc.l     lbL01850E,0
                    dc.l     lbL01853E,0
                    dc.l     lbL01856E,0
                    dc.l     lbL01859E,0
                    dc.l     lbW01389C,$7D00
                    dc.l     -1
lbL018CBA:          dc.l     lbL0185CE,0
                    dc.l     lbL0185FE,0
                    dc.l     lbL01862E,0
                    dc.l     lbL01865E,0
                    dc.l     lbL01868E,0
                    dc.l     lbL0186BE,0
                    dc.l     lbL0186EE,0
                    dc.l     lbL01871E,0
lbL018CFA:          dc.l     lbW01389C,$7D00
                    dc.l     -1
lbL018D06:          dc.l     lbL0185CE,1
                    dc.l     lbL0185FE,1
                    dc.l     lbL01862E,1
                    dc.l     lbL01865E,1
                    dc.l     lbL01868E,1
                    dc.l     lbL0186BE,1
                    dc.l     lbL0186EE,1
                    dc.l     lbL01871E,1
                    dc.l     -1

lbW018D4A:          dc.w    $00,$00,$20,$1E,$00,$00
                    dc.w    $00,$20,$20,$1E,$00,$00
                    dc.w    $00,$40,$20,$1E,$00,$00
                    dc.w    $20,$00,$20,$1E,$00,$00
                    dc.w    $20,$20,$20,$1E,$00,$00
                    dc.w    $20,$40,$20,$1E,$00,$00
                    dc.w    $40,$00,$20,$1E,$00,$00
                    dc.w    $40,$20,$20,$1E,$00,$00
                    dc.w    $40,$40,$20,$1E,$00,$00
                    dc.w    $60,$00,$20,$1E,$00,$00
                    dc.w    $60,$20,$20,$1E,$00,$00
                    dc.w    $60,$40,$20,$1E,$00,$00
                    dc.w    $80,$00,$20,$1E,$00,$00
                    dc.w    $80,$20,$20,$1E,$00,$00
                    dc.w    $80,$40,$20,$1E,$00,$00
                    dc.w    $A0,$00,$20,$1E,$00,$00
                    dc.w    $A0,$20,$20,$1E,$00,$00
                    dc.w    $A0,$40,$20,$1E,$00,$00
                    dc.w    $C0,$00,$20,$1E,$00,$00
                    dc.w    $C0,$20,$20,$1E,$00,$00
                    dc.w    $C0,$40,$20,$1E,$00,$00
                    dc.w    $E0,$00,$20,$1E,$00,$00
                    dc.w    $E0,$20,$20,$1E,$00,$00
                    dc.w    $E0,$40,$20,$1E,$00,$00
                    dc.w    $00,$60,$20,$1E,$00,$00
                    dc.W    $00,$80,$20,$1E,$00,$00
                    dc.w    $20,$60,$20,$1E,$00,$00
                    dc.w    $20,$80,$20,$1E,$00,$00
                    dc.w    $40,$60,$20,$1E,$00,$00
                    dc.w    $40,$80,$20,$1E,$00,$00
                    dC.w    $60,$60,$20,$1E,$00,$00
                    dc.w    $60,$80,$20,$1E,$00,$00
                    dc.w    $80,$60,$20,$1E,$00,$00
                    dc.w    $80,$80,$20,$1E,$00,$00
                    dc.w    $A0,$60,$20,$1E,$00,$00
                    dC.w    $A0,$80,$20,$1E,$00,$00
                    dc.w    $C0,$60,$20,$1E,$00,$00
                    dc.w    $C0,$80,$20,$1E,$00,$00
                    dc.w    $E0,$60,$20,$1E,$00,$00
                    dc.w    $E0,$80,$20,$1E,$00,$00
                    dc.w    $100,$00,$10,$10,$00,$00
                    dc.w    $100,$20,$10,$10,$00,$00
                    dc.w    $100,$40,$10,$10,$00,$00
                    dc.w    $110,$00,$10,$10,$00,$00
                    dc.w    $110,$20,$10,$10,$00,$00
                    dc.w    $110,$40,$10,$10,$00,$00
                    dc.w    $120,$00,$10,$10,$00,$00
                    dc.w    $120,$20,$10,$10,$00,$00
                    dc.w    $120,$40,$10,$10,$00,$00
                    dc.w    $130,$00,$10,$10,$00,$00
                    dc.w    $130,$20,$10,$10,$00,$00
                    dc.w    $130,$40,$10,$10,$00,$00
                    dc.w    $100,$10,$10,$10,$00,$00
                    dc.w    $100,$30,$10,$10,$00,$00
                    dc.w    $100,$50,$10,$10,$00,$00
                    dc.w    $110,$10,$10,$10,$00,$00
                    dc.w    $110,$30,$10,$10,$00,$00
                    dc.w    $110,$50,$10,$10,$00,$00
                    dc.w    $120,$10,$10,$10,$00,$00
                    dc.w    $120,$30,$10,$10,$00,$00
                    dc.w    $120,$50,$10,$10,$00,$00
                    dc.w    $130,$10,$10,$10,$00,$00
                    dc.w    $130,$30,$10,$10,$00,$00
                    dc.w    $130,$50,$10,$10,$00,$00
                    dc.w    $100,$60,$10,$10,$00,$00
                    dc.w    $100,$80,$10,$10,$00,$00
                    dc.w    $110,$60,$10,$10,$00,$00
                    dc.w    $110,$80,$10,$10,$00,$00
                    dc.w    $120,$60,$10,$10,$00,$00
                    dc.w    $120,$80,$10,$10,$00,$00
                    dc.w    $130,$60,$10,$10,$00,$00
                    dc.w    $130,$80,$10,$10,$00,$00
                    dc.w    $100,$70,$10,$10,$00,$00
                    dc.w    $100,$90,$10,$10,$00,$00
                    dc.w    $110,$70,$10,$10,$00,$00
                    dc.w    $110,$90,$10,$10,$00,$00
                    dc.w    $120,$70,$10,$10,$00,$00
                    dc.w    $120,$90,$10,$10,$00,$00
                    dc.w    $130,$70,$10,$10,$00,$00
                    dc.w    $130,$90,$10,$10,$00,$00
                    dc.w    $00,$100,$60,$80,$00,$00
                    dc.w    $60,$100,$60,$80,$00,$00
                    dc.w    $C0,$100,$60,$80,$00,$00
                    dc.w    $120,$100,$20,$20,$00,$00
                    dc.w    $120,$120,$20,$20,$00,$00
                    dc.w    $120,$140,$20,$20,$00,$00
                    dc.w    $120,$160,$20,$20,$00,$00
                    dcb.w   384,0

lbW01945E:          dc.w    $00,$00,$20,$1E,$00,$00
                    dc.w    $20,$00,$20,$1E,$00,$00
                    dc.w    $40,$00,$20,$1E,$00,$00
                    dc.w    $60,$00,$20,$1E,$00,$00
                    dc.w    $80,$00,$20,$1E,$00,$00
                    dc.w    $A0,$00,$20,$1E,$00,$00
                    dc.w    $C0,$00,$20,$1E,$00,$00
                    dc.w    $E0,$00,$20,$1E,$00,$00
                    dc.w    $00,$60,$20,$1E,$00,$00
                    dc.w    $00,$80,$20,$1E,$00,$00
                    dc.w    $20,$60,$20,$1E,$00,$00
                    dc.w    $20,$80,$20,$1E,$00,$00
                    dc.w    $40,$60,$20,$1E,$00,$00
                    dc.w    $40,$80,$20,$1E,$00,$00
                    dc.w    $60,$60,$20,$1E,$00,$00
                    dc.w    $60,$80,$20,$1E,$00,$00
                    dc.w    $80,$60,$20,$1E,$00,$00
                    dc.w    $80,$80,$20,$1E,$00,$00
                    dc.w    $A0,$60,$20,$1E,$00,$00
                    dc.w    $A0,$80,$20,$1E,$00,$00
                    dc.w    $C0,$60,$20,$1E,$00,$00
                    dc.w    $C0,$80,$20,$1E,$00,$00
                    dc.w    $E0,$60,$20,$1E,$00,$00
                    dc.w    $E0,$80,$20,$1E,$00,$00
                    dc.w    $100,$00,$10,$10,$00,$00
                    dc.w    $100,$20,$10,$10,$00,$00
                    dc.w    $100,$40,$10,$10,$00,$00
                    dc.w    $110,$00,$10,$10,$00,$00
                    dc.w    $110,$20,$10,$10,$00,$00
                    dc.w    $110,$40,$10,$10,$00,$00
                    dc.w    $120,$00,$10,$10,$00,$00
                    dc.w    $120,$20,$10,$10,$00,$00
                    dc.w    $120,$40,$10,$10,$00,$00
                    dc.w    $130,$00,$10,$10,$00,$00
                    dc.w    $130,$20,$10,$10,$00,$00
                    dc.w    $130,$40,$10,$10,$00,$00
                    dc.w    $100,$10,$10,$10,$00,$00
                    dc.w    $100,$30,$10,$10,$00,$00
                    dc.w    $100,$50,$10,$10,$00,$00
                    dc.w    $110,$10,$10,$10,$00,$00
                    dc.w    $110,$30,$10,$10,$00,$00
                    dc.w    $110,$50,$10,$10,$00,$00
                    dc.w    $120,$10,$10,$10,$00,$00
                    dc.w    $120,$30,$10,$10,$00,$00
                    dc.w    $120,$50,$10,$10,$00,$00
                    dc.w    $130,$10,$10,$10,$00,$00
                    dc.w    $130,$30,$10,$10,$00,$00
                    dc.w    $130,$50,$10,$10,$00,$00
                    dc.w    $100,$60,$10,$10,$00,$00
                    dc.w    $100,$80,$10,$10,$00,$00
                    dc.w    $110,$60,$10,$10,$00,$00
                    dc.w    $110,$80,$10,$10,$00,$00
                    dc.w    $120,$60,$10,$10,$00,$00
                    dc.w    $120,$80,$10,$10,$00,$00
                    dc.w    $130,$60,$10,$10,$00,$00
                    dc.w    $130,$80,$10,$10,$00,$00
                    dc.w    $100,$70,$10,$10,$00,$00
                    dc.w    $100,$90,$10,$10,$00,$00
                    dc.w    $110,$70,$10,$10,$00,$00
                    dc.w    $110,$90,$10,$10,$00,$00
                    dc.w    $120,$70,$10,$10,$00,$00
                    dc.w    $120,$90,$10,$10,$00,$00
                    dc.w    $130,$70,$10,$10,$00,$00
                    dc.w    $130,$90,$10,$10,$00,$00
                    dc.w    $00,$140,$20,$1B,$00,$00
                    dc.w    $20,$140,$20,$1B,$00,$00
                    dc.w    $40,$140,$20,$1B,$00,$00
                    dc.w    $60,$140,$20,$1B,$00,$00
                    dc.w    $80,$140,$20,$1B,$00,$00
                    dc.w    $A0,$140,$20,$1B,$00,$00
                    dc.w    $C0,$140,$20,$1B,$00,$00
                    dc.w    $E0,$140,$20,$1B,$00,$00
                    dc.w    $00,$160,$20,$1B,$00,$00
                    dc.w    $20,$160,$20,$1B,$00,$00
                    dc.w    $40,$160,$20,$1B,$00,$00
                    dc.w    $60,$160,$20,$1B,$00,$00
                    dc.w    $80,$160,$20,$1B,$00,$00
                    dc.w    $A0,$160,$20,$1B,$00,$00
                    dc.w    $C0,$160,$20,$1B,$00,$00
                    dc.w    $E0,$160,$20,$1B,$00,$00
                    dc.w    $00,$100,$20,$1B,$00,$00
                    dc.w    $20,$100,$20,$1B,$00,$00
                    dc.w    $40,$100,$20,$1B,$00,$00
                    dc.w    $60,$100,$20,$1B,$00,$00
                    dc.w    $80,$100,$20,$1B,$00,$00
                    dc.w    $A0,$100,$20,$1B,$00,$00
                    dc.w    $C0,$100,$20,$1B,$00,$00
                    dc.w    $E0,$100,$20,$1B,$00,$00
                    dc.w    $00,$120,$20,$1B,$00,$00
                    dc.w    $20,$120,$20,$1B,$00,$00
                    dc.w    $40,$120,$20,$1B,$00,$00
                    dc.w    $60,$120,$20,$1B,$00,$00
                    dc.w    $80,$120,$20,$1B,$00,$00
                    dc.w    $A0,$120,$20,$1B,$00,$00
                    dc.w    $C0,$120,$20,$1B,$00,$00
                    dc.w    $E0,$120,$20,$1B,$00,$00
                    dc.w    $120,$100,$20,$20,$00,$00
                    dc.w    $120,$120,$20,$20,$00,$00
                    dc.w    $120,$140,$20,$20,$00,$00
                    dc.w    $120,$160,$20,$20,$00,$00
                    dc.w    $00,$00,$20,$1E,$00,$00
                    dc.w    $00,$20,$20,$1E,$00,$00
                    dc.w    $00,$40,$20,$1E,$00,$00
                    dc.w    $20,$00,$20,$1E,$00,$00
                    dc.w    $20,$20,$20,$1E,$00,$00
                    dc.w    $20,$40,$20,$1E,$00,$00
                    dc.w    $40,$00,$20,$1E,$00,$00
                    dc.w    $40,$20,$20,$1E,$00,$00
                    dc.w    $40,$40,$20,$1E,$00,$00
                    dc.w    $60,$00,$20,$1E,$00,$00
                    dc.w    $60,$20,$20,$1E,$00,$00
                    dc.w    $60,$40,$20,$1E,$00,$00
                    dc.w    $80,$00,$20,$1E,$00,$00
                    dc.w    $80,$20,$20,$1E,$00,$00
                    dc.w    $80,$40,$20,$1E,$00,$00
                    dc.w    $A0,$00,$20,$1E,$00,$00
                    dc.w    $A0,$20,$20,$1E,$00,$00
                    dc.w    $A0,$40,$20,$1E,$00,$00
                    dc.w    $C0,$00,$20,$1E,$00,$00
                    dc.w    $C0,$20,$20,$1E,$00,$00
                    dc.w    $C0,$40,$20,$1E,$00,$00
                    dc.w    $E0,$00,$20,$1E,$00,$00
                    dc.w    $E0,$20,$20,$1E,$00,$00
                    dc.w    $E0,$40,$20,$1E,$00,$00
                    dcb.w   48,0

lbW019A8E:          dc.w    $00,$00,$20,$1E,$00,$00
                    dc.w    $00,$20,$20,$1E,$00,$00
                    dc.w    $00,$40,$20,$1E,$00,$00
                    dc.w    $20,$00,$20,$1E,$00,$00
                    dc.w    $20,$20,$20,$1E,$00,$00
                    dc.w    $20,$40,$20,$1E,$00,$00
                    dc.w    $40,$00,$20,$1E,$00,$00
                    dc.w    $40,$20,$20,$1E,$00,$00
                    dc.w    $40,$40,$20,$1E,$00,$00
                    dc.w    $60,$00,$20,$1E,$00,$00
                    dc.w    $60,$20,$20,$1E,$00,$00
                    dc.w    $60,$40,$20,$1E,$00,$00
                    dc.w    $80,$00,$20,$1E,$00,$00
                    dc.w    $80,$20,$20,$1E,$00,$00
                    dc.w    $80,$40,$20,$1E,$00,$00
                    dc.w    $A0,$00,$20,$1E,$00,$00
                    dc.w    $A0,$20,$20,$1E,$00,$00
                    dc.w    $A0,$40,$20,$1E,$00,$00
                    dc.w    $C0,$00,$20,$1E,$00,$00
                    dc.w    $C0,$20,$20,$1E,$00,$00
                    dc.w    $C0,$40,$20,$1E,$00,$00
                    dc.w    $E0,$00,$20,$1E,$00,$00
                    dc.w    $E0,$20,$20,$1E,$00,$00
                    dc.w    $E0,$40,$20,$1E,$00,$00
                    dc.w    $00,$60,$20,$1E,$00,$00
                    dc.w    $00,$80,$20,$1E,$00,$00
                    dc.w    $20,$60,$20,$1E,$00,$00
                    dc.w    $20,$80,$20,$1E,$00,$00
                    dc.w    $40,$60,$20,$1E,$00,$00
                    dc.w    $40,$80,$20,$1E,$00,$00
                    dc.w    $60,$60,$20,$1E,$00,$00
                    dc.w    $60,$80,$20,$1E,$00,$00
                    dc.w    $80,$60,$20,$1E,$00,$00
                    dc.w    $80,$80,$20,$1E,$00,$00
                    dc.w    $A0,$60,$20,$1E,$00,$00
                    dc.w    $A0,$80,$20,$1E,$00,$00
                    dc.w    $C0,$60,$20,$1E,$00,$00
                    dc.w    $C0,$80,$20,$1E,$00,$00
                    dc.w    $E0,$60,$20,$1E,$00,$00
                    dc.w    $E0,$80,$20,$1E,$00,$00
                    dc.w    $100,$00,$10,$10,$00,$00
                    dc.w    $100,$20,$10,$10,$00,$00
                    dc.w    $100,$40,$10,$10,$00,$00
                    dc.w    $110,$00,$10,$10,$00,$00
                    dc.w    $110,$20,$10,$10,$00,$00
                    dc.w    $110,$40,$10,$10,$00,$00
                    dc.w    $120,$00,$10,$10,$00,$00
                    dc.w    $120,$20,$10,$10,$00,$00
                    dc.w    $120,$40,$10,$10,$00,$00
                    dc.w    $130,$00,$10,$10,$00,$00
                    dc.w    $130,$20,$10,$10,$00,$00
                    dc.w    $130,$40,$10,$10,$00,$00
                    dc.w    $100,$10,$10,$10,$00,$00
                    dc.w    $100,$30,$10,$10,$00,$00
                    dc.w    $100,$50,$10,$10,$00,$00
                    dc.w    $110,$10,$10,$10,$00,$00
                    dc.w    $110,$30,$10,$10,$00,$00
                    dc.w    $110,$50,$10,$10,$00,$00
                    dc.w    $120,$10,$10,$10,$00,$00
                    dc.w    $120,$30,$10,$10,$00,$00
                    dc.w    $120,$50,$10,$10,$00,$00
                    dc.w    $130,$10,$10,$10,$00,$00
                    dc.w    $130,$30,$10,$10,$00,$00
                    dc.w    $130,$50,$10,$10,$00,$00
                    dc.w    $100,$60,$10,$10,$00,$00
                    dc.w    $100,$80,$10,$10,$00,$00
                    dc.w    $110,$60,$10,$10,$00,$00
                    dc.w    $110,$80,$10,$10,$00,$00
                    dc.w    $120,$60,$10,$10,$00,$00
                    dc.w    $120,$80,$10,$10,$00,$00
                    dc.w    $130,$60,$10,$10,$00,$00
                    dc.w    $130,$80,$10,$10,$00,$00
                    dc.w    $100,$70,$10,$10,$00,$00
                    dc.w    $100,$90,$10,$10,$00,$00
                    dc.w    $110,$70,$10,$10,$00,$00
                    dc.w    $110,$90,$10,$10,$00,$00
                    dc.w    $120,$70,$10,$10,$00,$00
                    dc.w    $120,$90,$10,$10,$00,$00
                    dc.w    $130,$70,$10,$10,$00,$00
                    dc.w    $130,$90,$10,$10,$00,$00
                    dc.w    $00,$100,$60,$80,$00,$00
                    dc.w    $60,$100,$60,$80,$00,$00
                    dc.w    $C0,$100,$60,$80,$00,$00
                    dc.w    $120,$100,$20,$20,$00,$00
                    dc.w    $120,$120,$20,$20,$00,$00
                    dc.w    $120,$140,$20,$20,$00,$00
                    dc.w    $120,$160,$20,$20,$00,$00
                    dcb.w   384,0

lbW01A1A2:          dc.w    $00,$00,$20,$1E,$00,$00
                    dc.w    $00,$20,$20,$1E,$00,$00
                    dc.w    $00,$40,$20,$1E,$00,$00
                    dc.w    $20,$00,$20,$1E,$00,$00
                    dc.w    $20,$20,$20,$1E,$00,$00
                    dc.w    $20,$40,$20,$1E,$00,$00
                    dc.w    $40,$00,$20,$1E,$00,$00
                    dc.w    $40,$20,$20,$1E,$00,$00
                    dc.w    $40,$40,$20,$1E,$00,$00
                    dc.w    $60,$00,$20,$1E,$00,$00
                    dc.w    $60,$20,$20,$1E,$00,$00
                    dc.w    $60,$40,$20,$1E,$00,$00
                    dc.w    $80,$00,$20,$1E,$00,$00
                    dc.w    $80,$20,$20,$1E,$00,$00
                    dc.w    $80,$40,$20,$1E,$00,$00
                    dc.w    $A0,$00,$20,$1E,$00,$00
                    dc.w    $A0,$20,$20,$1E,$00,$00
                    dc.w    $A0,$40,$20,$1E,$00,$00
                    dc.w    $C0,$00,$20,$1E,$00,$00
                    dc.w    $C0,$20,$20,$1E,$00,$00
                    dc.w    $C0,$40,$20,$1E,$00,$00
                    dc.w    $E0,$00,$20,$1E,$00,$00
                    dc.w    $E0,$20,$20,$1E,$00,$00
                    dc.w    $E0,$40,$20,$1E,$00,$00
                    dc.w    $00,$60,$20,$1E,$00,$00
                    dc.w    $00,$80,$20,$1E,$00,$00
                    dc.w    $20,$60,$20,$1E,$00,$00
                    dc.w    $20,$80,$20,$1E,$00,$00
                    dc.w    $40,$60,$20,$1E,$00,$00
                    dc.w    $40,$80,$20,$1E,$00,$00
                    dc.w    $60,$60,$20,$1E,$00,$00
                    dc.w    $60,$80,$20,$1E,$00,$00
                    dc.w    $80,$60,$20,$1E,$00,$00
                    dc.w    $80,$80,$20,$1E,$00,$00
                    dc.w    $A0,$60,$20,$1E,$00,$00
                    dc.w    $A0,$80,$20,$1E,$00,$00
                    dc.w    $C0,$60,$20,$1E,$00,$00
                    dc.w    $C0,$80,$20,$1E,$00,$00
                    dc.w    $E0,$60,$20,$1E,$00,$00
                    dc.w    $E0,$80,$20,$1E,$00,$00
                    dc.w    $100,$20,$20,$1E,$00,$00
                    dc.w    $100,$40,$20,$1E,$00,$00
                    dc.w    $120,$20,$20,$1E,$00,$00
                    dc.w    $100,$00,$10,$10,$00,$00
                    dcb.w   696,0

lbW01A922:          dc.w    $00,$00,$20,$1E,$00,$00
                    dc.w    $00,$20,$20,$1E,$00,$00
                    dc.w    $00,$40,$20,$1E,$00,$00
                    dc.w    $20,$00,$20,$1E,$00,$00
                    dc.w    $20,$20,$20,$1E,$00,$00
                    dc.w    $20,$40,$20,$1E,$00,$00
                    dc.w    $40,$00,$20,$1E,$00,$00
                    dc.w    $40,$20,$20,$1E,$00,$00
                    dc.w    $40,$40,$20,$1E,$00,$00
                    dc.w    $60,$00,$20,$1E,$00,$00
                    dc.w    $60,$20,$20,$1E,$00,$00
                    dc.w    $60,$40,$20,$1E,$00,$00
                    dc.w    $80,$00,$20,$1E,$00,$00
                    dc.w    $80,$20,$20,$1E,$00,$00
                    dc.w    $80,$40,$20,$1E,$00,$00
                    dc.w    $A0,$00,$20,$1E,$00,$00
                    dc.w    $A0,$20,$20,$1E,$00,$00
                    dc.w    $A0,$40,$20,$1E,$00,$00
                    dc.w    $C0,$00,$20,$1E,$00,$00
                    dc.w    $C0,$20,$20,$1E,$00,$00
                    dc.w    $C0,$40,$20,$1E,$00,$00
                    dc.w    $E0,$00,$20,$1E,$00,$00
                    dc.w    $E0,$20,$20,$1E,$00,$00
                    dc.w    $E0,$40,$20,$1E,$00,$00
                    dc.w    $00,$60,$20,$1E,$00,$00
                    dc.w    $00,$80,$20,$1E,$00,$00
                    dc.w    $20,$60,$20,$1E,$00,$00
                    dc.w    $20,$80,$20,$1E,$00,$00
                    dc.w    $40,$60,$20,$1E,$00,$00
                    dc.w    $40,$80,$20,$1E,$00,$00
                    dc.w    $60,$60,$20,$1E,$00,$00
                    dc.w    $60,$80,$20,$1E,$00,$00
                    dc.w    $80,$60,$20,$1E,$00,$00
                    dc.w    $80,$80,$20,$1E,$00,$00
                    dc.w    $A0,$60,$20,$1E,$00,$00
                    dc.w    $A0,$80,$20,$1E,$00,$00
                    dc.w    $C0,$60,$20,$1E,$00,$00
                    dc.w    $C0,$80,$20,$1E,$00,$00
                    dc.w    $E0,$60,$20,$1E,$00,$00
                    dc.w    $E0,$80,$20,$1E,$00,$00
                    dc.w    $100,$00,$10,$10,$00,$00
                    dc.w    $100,$20,$10,$10,$00,$00
                    dc.w    $100,$40,$10,$10,$00,$00
                    dc.w    $110,$00,$10,$10,$00,$00
                    dc.w    $110,$20,$10,$10,$00,$00
                    dc.w    $110,$40,$10,$10,$00,$00
                    dc.w    $120,$00,$10,$10,$00,$00
                    dc.w    $120,$20,$10,$10,$00,$00
                    dc.w    $120,$40,$10,$10,$00,$00
                    dc.w    $130,$00,$10,$10,$00,$00
                    dc.w    $130,$20,$10,$10,$00,$00
                    dc.w    $130,$40,$10,$10,$00,$00
                    dc.w    $100,$10,$10,$10,$00,$00
                    dc.w    $100,$30,$10,$10,$00,$00
                    dc.w    $100,$50,$10,$10,$00,$00
                    dc.w    $110,$10,$10,$10,$00,$00
                    dc.w    $110,$30,$10,$10,$00,$00
                    dc.w    $110,$50,$10,$10,$00,$00
                    dc.w    $120,$10,$10,$10,$00,$00
                    dc.w    $120,$30,$10,$10,$00,$00
                    dc.w    $120,$50,$10,$10,$00,$00
                    dc.w    $130,$10,$10,$10,$00,$00
                    dc.w    $130,$30,$10,$10,$00,$00
                    dc.w    $130,$50,$10,$10,$00,$00
                    dc.w    $100,$60,$10,$10,$00,$00
                    dc.w    $100,$80,$10,$10,$00,$00
                    dc.w    $110,$60,$10,$10,$00,$00
                    dc.w    $110,$80,$10,$10,$00,$00
                    dc.w    $120,$60,$10,$10,$00,$00
                    dc.w    $120,$80,$10,$10,$00,$00
                    dc.w    $130,$60,$10,$10,$00,$00
                    dc.w    $130,$80,$10,$10,$00,$00
                    dc.w    $100,$70,$10,$10,$00,$00
                    dc.w    $100,$90,$10,$10,$00,$00
                    dc.w    $110,$70,$10,$10,$00,$00
                    dc.w    $110,$90,$10,$10,$00,$00
                    dc.w    $120,$70,$10,$10,$00,$00
                    dc.w    $120,$90,$10,$10,$00,$00
                    dc.w    $130,$70,$10,$10,$00,$00
                    dc.w    $130,$90,$10,$10,$00,$00
                    dc.w    $00,$100,$60,$80,$00,$00
                    dc.w    $60,$100,$60,$80,$00,$00
                    dc.w    $C0,$100,$60,$80,$00,$00
                    dc.w    $120,$100,$10,$10,$00,$00
                    dc.w    $120,$120,$10,$10,$00,$00
                    dc.w    $120,$140,$10,$10,$00,$00
                    dc.w    $120,$160,$10,$10,$00,$00
                    dcb.w   384,0

lbL01B036:          dc.l     lbL0160AA,1
                    dc.l     lbL0160DA,1
                    dc.l     lbL01610A,1
                    dc.l     lbL0160DA,1,-1
lbL01B05A:          dc.l     lbL01613A,1
                    dc.l     lbL01616A,1
                    dc.l     lbL01619A,1
                    dc.l     lbL01616A,1,-1
lbL01B07E:          dc.l     lbL0161CA,1
                    dc.l     lbL0161FA,1
                    dc.l     lbL01622A,1
                    dc.l     lbL0161FA,1,-1
lbL01B0A2:          dc.l     lbL01625A,1
                    dc.l     lbL01628A,1
                    dc.l     lbL0162BA,1
                    dc.l     lbL01628A,1,-1
lbL01B0C6:          dc.l     lbL0162EA,1
                    dc.l     lbL01631A,1
                    dc.l     lbL01634A,1
                    dc.l     lbL01631A,1,-1
lbL01B0EA:          dc.l     lbL01637A,1
                    dc.l     lbL0163AA,1
                    dc.l     lbL0163DA,1
                    dc.l     lbL0163AA,1,-1
lbL01B10E:          dc.l     lbL01640A,1
                    dc.l     lbL01643A,1
                    dc.l     lbL01646A,1
                    dc.l     lbL01643A,1,-1
lbL01B132:          dc.l     lbL01649A,1
                    dc.l     lbL0164CA,1
                    dc.l     lbL0164FA,1
                    dc.l     lbL0164CA,1,-1
lbL01B156:          dc.l     lbL014F6A,1
                    dc.l     lbL014F9A,1
                    dc.l     lbL014F6A,1,-1
lbL01B172:          dc.l     lbL014FCA,1
                    dc.l     lbL014FFA,1
                    dc.l     lbL014FCA,1,-1
lbL01B18E:          dc.l     lbL01502A,1
                    dc.l     lbL01505A,1
                    dc.l     lbL01502A,1,-1
lbL01B1AA:          dc.l     lbL01508A,1
                    dc.l     lbL0150BA,1
                    dc.l     lbL01508A,1,-1
lbL01B1C6:          dc.l     lbL0150EA,1
                    dc.l     lbL01511A,1
                    dc.l     lbL0150EA,1,-1
lbL01B1E2:          dc.l     lbL01514A,1
                    dc.l     lbL01517A,1
                    dc.l     lbL01514A,1,-1
lbL01B1FE:          dc.l     lbL0151AA,1
                    dc.l     lbL0151DA,1
                    dc.l     lbL0151AA,1,-1
lbL01B21A:          dc.l     lbL01520A,1
                    dc.l     lbL01523A,1
                    dc.l     lbL01520A,1,-1
lbL01B236:          dc.l     lbL014DEA,$7D00,-1
lbL01B242:          dc.l     lbL014E1A,$7D00,-1
lbL01B24E:          dc.l     lbL014E4A,$7D00,-1
lbL01B25A:          dc.l     lbL014E7A,$7D00,-1
lbL01B266:          dc.l     lbL014EAA,$7D00,-1
lbL01B272:          dc.l     lbL014EDA,$7D00,-1
lbL01B27E:          dc.l     lbL014F0A,$7D00,-1
lbL01B28A:          dc.l     lbL014F3A,$7D00,-1
lbL01B296:          dc.l     lbL01526A,1
                    dc.l     lbL01529A,1
                    dc.l     lbL0152CA,1
                    dc.l     lbL01529A,1,-1
lbL01B2BA:          dc.l     lbL0152FA,1
                    dc.l     lbL01532A,1
                    dc.l     lbL01535A,1
                    dc.l     lbL01532A,1,-1
lbL01B2DE:          dc.l     lbL01538A,1
                    dc.l     lbL0153BA,1
                    dc.l     lbL0153EA,1
                    dc.l     lbL0153BA,1,-1
lbL01B302:          dc.l     lbL01541A,1
                    dc.l     lbL01544A,1
                    dc.l     lbL01547A,1
                    dc.l     lbL01544A,1,-1
lbL01B326:          dc.l     lbL0154AA,1
                    dc.l     lbL0154DA,1
                    dc.l     lbL01550A,1
                    dc.l     lbL0154DA,1,-1
lbL01B34A:          dc.l     lbL01553A,1
                    dc.l     lbL01556A,1
                    dc.l     lbL01559A,1
                    dc.l     lbL01556A,1,-1
lbL01B36E:          dc.l     lbL0155CA,1
                    dc.l     lbL0155FA,1
                    dc.l     lbL01562A,1
                    dc.l     lbL0155FA,1,-1
lbL01B392:          dc.l     lbL01565A,1
                    dc.l     lbL01568A,1
                    dc.l     lbL0156BA,1
                    dc.l     lbL01568A,1,-1
lbL01B3B6:          dc.l     lbL0156EA,1
                    dc.l     lbL01571A,1
                    dc.l     lbL0156EA,1,-1
lbL01B3D2:          dc.l     lbL01574A,1
                    dc.l     lbL01577A,1
                    dc.l     lbL01574A,1,-1
lbL01B3EE:          dc.l     lbL0157AA,1
                    dc.l     lbL0157DA,1
                    dc.l     lbL0157AA,1,-1
lbL01B40A:          dc.l     lbL01580A,1
                    dc.l     lbL01583A,1
                    dc.l     lbL01580A,1,-1
lbL01B426:          dc.l     lbL01586A,1
                    dc.l     lbL01589A,1
                    dc.l     lbL01586A,1,-1
lbL01B442:          dc.l     lbL0158CA,1
                    dc.l     lbL0158FA,1
                    dc.l     lbL0158CA,1,-1
lbL01B45E:          dc.l     lbL01592A,1
                    dc.l     lbL01595A,1
                    dc.l     lbL01592A,1,-1
lbL01B47A:          dc.l     lbL01598A,1
                    dc.l     lbL0159BA,1
                    dc.l     lbL01598A,1,-1
lbL01B496:          dc.l     lbL01526A,$7D00,-1
lbL01B4A2:          dc.l     lbL0152FA,$7D00,-1
lbL01B4AE:          dc.l     lbL01538A,$7D00,-1
lbL01B4BA:          dc.l     lbL01541A,$7D00,-1
lbL01B4C6:          dc.l     lbL0154AA,$7D00,-1
lbL01B4D2:          dc.l     lbL01553A,$7D00,-1
lbL01B4DE:          dc.l     lbL0155CA,$7D00,-1
lbL01B4EA:          dc.l     lbL01565A,$7D00,-1
lbL01B4F6:          dc.l     lbL0159EA,$7D00,-1,0
                    dc.l     lbL015A1A,$7D00,-1,0
                    dc.l     lbL015A4A,$7D00,-1,0
                    dc.l     lbL015A7A,$7D00,-1,0
                    dc.l     lbL015AAA,$7D00,-1,0
                    dc.l     lbL015ADA,$7D00,-1,0
                    dc.l     lbL015B0A,$7D00,-1,0
                    dc.l     lbL015B3A,$7D00,-1,0
                    dc.l     lbL015B6A,$7D00,-1,0
                    dc.l     lbL015B9A,$7D00,-1,0
                    dc.l     lbL015BCA,$7D00,-1,0
                    dc.l     lbL015C2A,$7D00,-1,0
                    dc.l     lbL015BFA,$7D00,-1,0
                    dc.l     lbL015C5A,$7D00,-1,0
                    dc.l     lbL015C8A,$7D00,-1,0
                    dc.l     lbL015CBA,$7D00,-1,0
                    dc.l     lbL015CEA,$7D00,-1,0
                    dc.l     lbL015D1A,$7D00,-1,0
                    dc.l     lbL015D4A,$7D00,-1,0
                    dc.l     lbL015D7A,$7D00,-1,0
                    dc.l     lbL015DAA,$7D00,-1,0
                    dc.l     lbL015DDA,$7D00,-1,0
                    dc.l     lbL015E0A,$7D00,-1,0
                    dc.l     lbL015E3A,$7D00,-1,0
                    dc.l     lbL015E6A,$7D00,-1,0
                    dc.l     lbL015CBA,$7D00,-1,0
                    dc.l     lbL015ECA,$7D00,-1,0
                    dc.l     lbL015EFA,$7D00,-1,0
                    dc.l     lbL015F2A,$7D00,-1,0
                    dc.l     lbL015F5A,$7D00,-1,0
                    dc.l     lbL015F8A,$7D00,-1,0
                    dc.l     lbL015FBA,$7D00,-1,0
lbL01B6F6:          dc.l     lbL015FEA,1
                    dc.l     lbL01601A,1
                    dc.l     lbL01604A,1
                    dc.l     lbL01607A,1
                    dc.l     lbL014EAA,$7D00,-1
lbL01B722:          dc.l     lbL014DEA,1
                    dc.l     lbL014E1A,1
                    dc.l     lbL014E4A,1
                    dc.l     lbL014E1A,1,-1
lbL01B746:          dc.l     lbL014E7A,1
                    dc.l     lbL014EAA,1
                    dc.l     lbL014EDA,1
                    dc.l     lbL014EAA,1,-1
lbL01B76A:          dc.l     lbL014F0A,1
                    dc.l     lbL014F3A,1
                    dc.l     lbL014F6A,1
                    dc.l     lbL014F3A,1,-1
lbL01B78E:          dc.l     lbL014F9A,1
                    dc.l     lbL014FCA,1
                    dc.l     lbL014FFA,1
                    dc.l     lbL014FCA,1,-1
lbL01B7B2:          dc.l     lbL01502A,1
                    dc.l     lbL01505A,1
                    dc.l     lbL01508A,1
                    dc.l     lbL01505A,1,-1
lbL01B7D6:          dc.l     lbL0150BA,1
                    dc.l     lbL0150EA,1
                    dc.l     lbL01511A,1
                    dc.l     lbL0150EA,1,-1
lbL01B7FA:          dc.l     lbL01514A,1
                    dc.l     lbL01517A,1
                    dc.l     lbL0151AA,1
                    dc.l     lbL01517A,1,-1
lbL01B81E:          dc.l     lbL0151DA,1
                    dc.l     lbL01520A,1
                    dc.l     lbL01523A,1
                    dc.l     lbL01520A,1,-1
lbL01B842:          dc.l     lbL01526A,1
                    dc.l     lbL01529A,1
                    dc.l     lbL01526A,1,-1
lbL01B85E:          dc.l     lbL0152CA,1
                    dc.l     lbL0152FA,1
                    dc.l     lbL0152CA,1,-1
lbL01B87A:          dc.l     lbL01532A,1
                    dc.l     lbL01535A,1
                    dc.l     lbL01532A,1,-1
lbL01B896:          dc.l     lbL01538A,1
                    dc.l     lbL0153BA,1
                    dc.l     lbL01538A,1,-1
lbL01B8B2:          dc.l     lbL0153EA,1
                    dc.l     lbL01541A,1
                    dc.l     lbL0153EA,1,-1
lbL01B8CE:          dc.l     lbL01544A,1
                    dc.l     lbL01547A,1
                    dc.l     lbL01544A,1,-1
lbL01B8EA:          dc.l     lbL0154AA,1
                    dc.l     lbL0154DA,1
                    dc.l     lbL0154AA,1,-1
lbL01B906:          dc.l     lbL01550A,1
                    dc.l     lbL01553A,1
                    dc.l     lbL01550A,1,-1
lbL01B922:          dc.l     lbL014E4A,$7D00,-1
lbL01B92E:          dc.l     lbL014EDA,$7D00,-1
lbL01B93A:          dc.l     lbL014F6A,$7D00,-1
lbL01B946:          dc.l     lbL014FFA,$7D00,-1
lbL01B952:          dc.l     lbL01508A,$7D00,-1
lbL01B95E:          dc.l     lbL01511A,$7D00,-1
lbL01B96A:          dc.l     lbL0151AA,$7D00,-1
lbL01B976:          dc.l     lbL01523A,$7D00,-1
lbL01B982:          dc.l     lbL01556A,1
                    dc.l     lbL01559A,1
                    dc.l     lbL0155CA,1
                    dc.l     lbL01559A,1,-1
lbL01B9A6:          dc.l     lbL0155FA,1
                    dc.l     lbL01562A,1
                    dc.l     lbL01565A,1
                    dc.l     lbL01562A,1,-1
lbL01B9CA:          dc.l     lbL01568A,1
                    dc.l     lbL0156BA,1
                    dc.l     lbL0156EA,1
                    dc.l     lbL0156BA,1,-1
lbL01B9EE:          dc.l     lbL01571A,1
                    dc.l     lbL01574A,1
                    dc.l     lbL01577A,1
                    dc.l     lbL01574A,1,-1
lbL01BA12:          dc.l     lbL0157AA,1
                    dc.l     lbL0157DA,1
                    dc.l     lbL01580A,1
                    dc.l     lbL0157DA,1,-1
lbL01BA36:          dc.l     lbL01583A,1
                    dc.l     lbL01586A,1
                    dc.l     lbL01589A,1
                    dc.l     lbL01586A,1,-1
lbL01BA5A:          dc.l     lbL0158CA,1
                    dc.l     lbL0158FA,1
                    dc.l     lbL01592A,1
                    dc.l     lbL0158FA,1,-1
lbL01BA7E:          dc.l     lbL01595A,1
                    dc.l     lbL01598A,1
                    dc.l     lbL0159BA,1
                    dc.l     lbL01598A,1,-1
lbL01BAA2:          dc.l     lbL0159EA,1
                    dc.l     lbL015A1A,1
                    dc.l     lbL0159EA,1,-1
lbL01BABE:          dc.l     lbL015A4A,1
                    dc.l     lbL015A7A,1
                    dc.l     lbL015A4A,1,-1
lbL01BADA:          dc.l     lbL015AAA,1
                    dc.l     lbL015ADA,1
                    dc.l     lbL015AAA,1,-1
lbL01BAF6:          dc.l     lbL015B0A,1
                    dc.l     lbL015B3A,1
                    dc.l     lbL015B0A,1,-1
lbL01BB12:          dc.l     lbL015B6A,1
                    dc.l     lbL015B9A,1
                    dc.l     lbL015B6A,1,-1
lbL01BB2E:          dc.l     lbL015BCA,1
                    dc.l     lbL015BFA,1
                    dc.l     lbL015BCA,1,-1
lbL01BB4A:          dc.l     lbL015C2A,1
                    dc.l     lbL015C5A,1
                    dc.l     lbL015C2A,1,-1
lbL01BB66:          dc.l     lbL015C8A,1
                    dc.l     lbL015CBA,1
                    dc.l     lbL015C8A,1,-1
lbL01BB82:          dc.l     lbL0155CA,$7D00,-1
lbL01BB8E:          dc.l     lbL01565A,$7D00,-1
lbL01BB9A:          dc.l     lbL0156EA,$7D00,-1
lbL01BBA6:          dc.l     lbL01577A,$7D00,-1
lbL01BBB2:          dc.l     lbL01580A,$7D00,-1
lbL01BBBE:          dc.l     lbL01589A,$7D00,-1
lbL01BBCA:          dc.l     lbL01592A,$7D00,-1
lbL01BBD6:          dc.l     lbL0159BA,$7D00,-1
lbL01BBE2:          dc.l     lbL015CEA,1
                    dc.l     lbL015D1A,1
                    dc.l     lbL015D4A,1,-1
lbL01BBFE:          dc.l     lbL015D1A,$7D00,-1
lbL01BC0A:          dc.l     lbL015D7A,1
                    dc.l     lbL015DAA,1
                    dc.l     lbL015DDA,1
                    dc.l     lbL015E0A,1
                    dc.l     lbL01508A,$7D00,-1
lbL01BC36:          dc.l     lbL014DEA,1
                    dc.l     lbL014E1A,1
                    dc.l     lbL014E4A,1
                    dc.l     lbL014E1A,1,-1
lbL01BC5A:          dc.l     lbL014E7A,1
                    dc.l     lbL014EAA,1
                    dc.l     lbL014EDA,1
                    dc.l     lbL014EAA,1,-1
lbL01BC7E:          dc.l     lbL014F0A,1
                    dc.l     lbL014F3A,1
                    dc.l     lbL014F6A,1
                    dc.l     lbL014F3A,1,-1
lbL01BCA2:          dc.l     lbL014F9A,1
                    dc.l     lbL014FCA,1
                    dc.l     lbL014FFA,1
                    dc.l     lbL014FCA,1,-1
lbL01BCC6:          dc.l     lbL01502A,1
                    dc.l     lbL01505A,1
                    dc.l     lbL01508A,1
                    dc.l     lbL01505A,1,-1
lbL01BCEA:          dc.l     lbL0150BA,1
                    dc.l     lbL0150EA,1
                    dc.l     lbL01511A,1
                    dc.l     lbL0150EA,1,-1
lbL01BD0E:          dc.l     lbL01514A,1
                    dc.l     lbL01517A,1
                    dc.l     lbL0151AA,1
                    dc.l     lbL01517A,1,-1
lbL01BD32:          dc.l     lbL0151DA,1
                    dc.l     lbL01520A,1
                    dc.l     lbL01523A,1
                    dc.l     lbL01520A,1,-1
lbL01BD56:          dc.l     lbL01526A,1
                    dc.l     lbL01529A,1
                    dc.l     lbL01526A,1,-1
lbL01BD72:          dc.l     lbL0152CA,1
                    dc.l     lbL0152FA,1
                    dc.l     lbL0152CA,1,-1
lbL01BD8E:          dc.l     lbL01532A,1
                    dc.l     lbL01535A,1
                    dc.l     lbL01532A,1,-1
lbL01BDAA:          dc.l     lbL01538A,1
                    dc.l     lbL0153BA,1
                    dc.l     lbL01538A,1,-1
lbL01BDC6:          dc.l     lbL0153EA,1
                    dc.l     lbL01541A,1
                    dc.l     lbL0153EA,1,-1
lbL01BDE2:          dc.l     lbL01544A,1
                    dc.l     lbL01547A,1
                    dc.l     lbL01544A,1,-1
lbL01BDFE:          dc.l     lbL0154AA,1
                    dc.l     lbL0154DA,1
                    dc.l     lbL0154AA,1,-1
lbL01BE1A:          dc.l     lbL01550A,1
                    dc.l     lbL01553A,1
                    dc.l     lbL01550A,1,-1
lbL01BE36:          dc.l     lbL014E4A,$7D00,-1
lbL01BE42:          dc.l     lbL014EDA,$7D00,-1
lbL01BE4E:          dc.l     lbL014F6A,$7D00,-1
lbL01BE5A:          dc.l     lbL014FFA,$7D00,-1
lbL01BE66:          dc.l     lbL01508A,$7D00,-1
lbL01BE72:          dc.l     lbL0150BA,$7D00,-1
lbL01BE7E:          dc.l     lbL0151AA,$7D00,-1
lbL01BE8A:          dc.l     lbL01523A,$7D00,-1
lbL01BE96:          dc.l     lbL01556A,$7D00,-1
lbL01BEA2:          dc.l     lbL01559A,1
                    dc.l     lbL0155CA,1
                    dc.l     lbL01559A,1,-1
                    dc.l     lbL0155FA,$7D00,-1

lbW01BECA:          dc.w    $00,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $10,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $20,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $30,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $40,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $50,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $00,$00,$10,$40,$5A2,$5A2,$5A2,$5A2
                    dc.w    $20,$00,$10,$40,$5A3,$5A3,$5A3,$5A3
                    dc.w    $00,$00,$10,$30,$5A2,$5A2,$5A2,$5A2
                    dc.w    $20,$00,$10,$30,$5A3,$5A3,$5A3,$580
                    dc.w    $10,$00,$10,$40,$80,$80,$80,$80
                    dc.w    $10,$00,$10,$30,$80,$80,$80,$00
                    dc.w    $30,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $40,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $30,$10,$10,$10,$563C,$00,$00,$00
                    dc.w    $30,$00,$10,$10,$5F80,$00,$00,$00
                    dc.w    $50,$30,$20,$10,$00,$00,$00,$00
                    dc.w    $50,$20,$20,$10,$00,$00,$00,$00
                    dc.w    $30,$30,$20,$10,$2400,$2440,$00,$00
                    dc.w    $60,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $50,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $40,$00,$10,$20,$1500,$1A00,$00,$00
                    dc.w    $40,$40,$20,$20,$22,$22,$22,$22
                    dc.w    $60,$40,$20,$20,$22,$22,$22,$22
                    dc.w    $80,$40,$20,$20,$22,$22,$22,$22
                    dc.w    $A0,$40,$20,$20,$22,$22,$22,$22
                    dc.w    $C0,$40,$20,$20,$22,$22,$22,$22
                    dc.w    $E0,$40,$20,$20,$22,$22,$22,$22
                    dc.w    $40,$60,$20,$20,$22,$22,$22,$22
                    dc.w    $60,$60,$20,$20,$22,$22,$22,$22
                    dc.w    $80,$60,$20,$20,$22,$22,$22,$22
                    dc.w    $A0,$60,$20,$20,$22,$22,$22,$22
                    dc.w    $C0,$60,$20,$20,$22,$22,$22,$22
                    dc.w    $E0,$60,$20,$20,$22,$22,$22,$22
                    dc.w    $00,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $00,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $20,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $70,$30,$30,$10,$00,$00,$00,$00
                    dc.w    $A0,$30,$30,$10,$00,$00,$00,$00
                    dc.w    $D0,$30,$30,$10,$00,$00,$00,$00
                    dc.w    $70,$00,$20,$10,$00,$00,$00,$00
                    dc.w    $70,$10,$20,$10,$00,$00,$00,$00
                    dc.w    $70,$20,$20,$10,$00,$00,$00,$00
                    dcb.w   472,$10

lbW01C52A:          dc.w    $00,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $10,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $20,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $30,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $40,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $50,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $00,$00,$10,$40,$5A2,$5A2,$5A2,$5A2
                    dc.w    $20,$00,$10,$40,$5A3,$5A3,$5A3,$5A3
                    dc.w    $00,$00,$10,$30,$5A2,$5A2,$5A2,$5A2
                    dc.w    $20,$00,$10,$30,$5A3,$5A3,$5A3,$580
                    dc.w    $10,$00,$10,$40,$80,$80,$80,$80
                    dc.w    $10,$00,$10,$30,$80,$80,$80,$00
                    dc.w    $30,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $40,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $30,$10,$10,$10,$563C,$00,$00,$00
                    dc.w    $30,$00,$10,$10,$5F80,$00,$00,$00
                    dc.w    $50,$30,$20,$10,$00,$00,$00,$00
                    dc.w    $50,$20,$20,$10,$00,$00,$00,$00
                    dc.w    $30,$30,$20,$10,$2400,$2440,$00,$00
                    dc.w    $60,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $50,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $40,$00,$10,$20,$1500,$1A00,$00,$00
                    dc.w    $B0,$00,$10,$10,$00,$00,$00,$00
                    dc.w    $B0,$10,$10,$10,$00,$00,$00,$00
                    dc.w    $B0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $70,$00,$10,$30,$100,$5F80,$5F80,$5F80
                    dc.w    $80,$00,$10,$30,$114,$5F94,$5F94,$5F94
                    dc.w    $90,$00,$10,$30,$114,$5F94,$5F94,$5F94
                    dc.w    $A0,$00,$10,$30,$114,$5F94,$5F94,$5F94
                    dc.w    $100,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $110,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $120,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $130,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $100,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $110,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $120,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $130,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $C0,$00,$20,$20,$4100,$4140,$4600,$4640
                    dc.w    $F0,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $C0,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $E0,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $80,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $A0,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $C0,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $E0,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $00,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $20,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $00,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $70,$30,$30,$10,$00,$00,$00,$00
                    dc.w    $A0,$30,$30,$10,$00,$00,$00,$00
                    dc.w    $D0,$30,$30,$10,$00,$00,$00,$00
                    dc.w    $20,$60,$20,$20,$5EB4,$5EE7,$63AF,$63E7
                    dc.w    $40,$40,$20,$20,$5EB4,$5EE7,$63AF,$63E7
                    dc.w    $40,$60,$20,$20,$5EB4,$5EE7,$63AF,$63E7
                    dc.w    $60,$40,$20,$20,$5EB4,$5EE7,$63AF,$63E7
                    dc.w    $60,$60,$20,$20,$5EB4,$5EE7,$63AF,$63E7
                    dc.w    $80,$60,$20,$20,$5EB4,$5EE7,$63AF,$63E7
                    dcb.w   360,$10

lbW01CB8A:          dc.w    $00,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $10,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $20,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $30,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $40,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $50,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $00,$00,$10,$40,$5A2,$5A2,$5A2,$580
                    dc.w    $20,$00,$10,$40,$5A3,$5A3,$5A3,$5A3
                    dc.w    $00,$00,$10,$30,$5A2,$5A2,$5A2,$580
                    dc.w    $20,$00,$10,$30,$5A3,$5A3,$5A3,$580
                    dc.w    $10,$00,$10,$40,$80,$80,$80,$80
                    dc.w    $10,$00,$10,$30,$80,$80,$80,$0
                    dc.w    $30,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $40,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $30,$10,$10,$10,$563C,$00,$00,$00
                    dc.w    $30,$00,$10,$10,$5F80,$00,$00,$00
                    dc.w    $50,$30,$20,$10,$00,$00,$00,$00
                    dc.w    $50,$20,$20,$10,$00,$00,$00,$00
                    dc.w    $30,$30,$20,$10,$2400,$2440,$00,$00
                    dc.w    $60,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $50,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $40,$00,$10,$20,$1500,$1A00,$00,$00
                    dC.w    $70,$00,$20,$20,$20,$20,$20,$20
                    dc.w    $90,$00,$20,$20,$20,$20,$20,$20
                    dc.w    $B0,$00,$20,$20,$20,$20,$20,$20
                    dc.w    $D0,$00,$20,$20,$20,$20,$20,$20
                    dc.w    $F0,$00,$20,$20,$20,$20,$20,$20
                    dc.w    $110,$00,$20,$20,$20,$20,$20,$20
                    dc.w    $00,$40,$20,$20,$20,$20,$20,$20
                    dc.w    $20,$40,$20,$20,$20,$20,$20,$20
                    dc.w    $40,$40,$20,$20,$20,$20,$20,$20
                    dc.w    $60,$40,$20,$20,$20,$20,$20,$20
                    dc.w    $80,$40,$20,$20,$20,$20,$20,$20
                    dc.w    $A0,$40,$20,$20,$21,$21,$21,$21
                    dc.w    $80,$40,$20,$20,$21,$21,$21,$21
                    dc.w    $60,$40,$20,$20,$21,$21,$21,$21
                    dc.w    $40,$40,$20,$20,$21,$21,$21,$21
                    dc.w    $20,$40,$20,$20,$21,$21,$21,$21
                    dc.w    $00,$40,$20,$20,$21,$21,$21,$21
                    dc.w    $110,$00,$20,$20,$21,$21,$21,$21
                    dc.w    $F0,$00,$20,$20,$21,$21,$21,$21
                    dc.w    $D0,$00,$20,$20,$21,$21,$21,$21
                    dc.w    $B0,$00,$20,$20,$21,$21,$21,$21
                    dc.w    $90,$00,$20,$20,$21,$21,$21,$21
                    dc.w    $70,$20,$20,$20,$20,$20,$20,$20
                    dc.w    $90,$20,$20,$20,$20,$20,$20,$20
                    dc.w    $B0,$20,$20,$20,$20,$20,$20,$20
                    dc.w    $D0,$20,$20,$20,$20,$20,$20,$20
                    dc.w    $F0,$20,$20,$20,$20,$20,$20,$20
                    dc.w    $110,$20,$20,$20,$20,$20,$20,$20
                    dc.w    $00,$60,$20,$20,$20,$20,$20,$20
                    dc.w    $20,$60,$20,$20,$20,$20,$20,$20
                    dc.w    $40,$60,$20,$20,$20,$20,$20,$20
                    dc.w    $60,$60,$20,$20,$20,$20,$20,$20
                    dc.w    $80,$60,$20,$20,$20,$20,$20,$20
                    dc.w    $A0,$60,$20,$20,$21,$21,$21,$21
                    dc.w    $80,$60,$20,$20,$21,$21,$21,$21
                    dc.w    $60,$60,$20,$20,$21,$21,$21,$21
                    dc.w    $40,$60,$20,$20,$21,$21,$21,$21
                    dc.w    $20,$60,$20,$20,$21,$21,$21,$21
                    dc.w    $00,$60,$20,$20,$21,$21,$21,$21
                    dc.w    $110,$20,$20,$20,$21,$21,$21,$21
                    dc.w    $F0,$20,$20,$20,$21,$21,$21,$21
                    dc.w    $D0,$20,$20,$20,$21,$21,$21,$21
                    dc.w    $B0,$20,$20,$20,$21,$21,$21,$21
                    dc.w    $90,$20,$20,$20,$21,$21,$21,$21
                    dc.w    $C0,$40,$30,$10,$00,$00,$00,$00
                    dc.w    $C0,$50,$30,$10,$00,$00,$00,$00
                    dc.w    $C0,$50,$30,$10,$00,$00,$00,$00
                    dc.w    $130,$00,$10,$30,$40,$540,$540,$540
                    dc.w    $130,$30,$10,$30,$80,$5C0,$5C0,$00
                    dc.w    $C0,$70,$30,$10,$1100,$1100,$1100,$00
                    dc.w    $110,$60,$20,$10,$6540,$6580,$00,$00
                    dc.w    $110,$70,$20,$10,$1100,$2180,$00,$00
                    dc.w    $C0,$60,$30,$10,$10C0,$1100,$1100,00
                    dc.w    $F0,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $110,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $F0,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $10,$00,$10,$30,$A7,$A7,$A7,$27
                    dcb.w   208,$10

lbW01D21A:          dc.w    $00,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $10,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $20,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $30,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $40,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $50,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $00,$00,$10,$40,$5A2,$5A2,$5A2,$580
                    dc.w    $20,$00,$10,$40,$5A3,$5A3,$5A3,$5A3
                    dc.w    $00,$00,$10,$30,$5A2,$5A2,$5A2,$580
                    dc.w    $20,$00,$10,$30,$5A3,$5A3,$5A3,$580
                    dc.w    $10,$00,$10,$40,$80,$80,$80,$80
                    dc.w    $10,$00,$10,$30,$80,$80,$80,$00
                    dc.w    $30,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $40,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $30,$10,$10,$10,$563C,$00,$00,$00
                    dc.w    $30,$00,$10,$10,$5F80,$00,$00,$00
                    dc.w    $50,$30,$20,$10,$00,$00,$00,$00
                    dc.w    $50,$20,$20,$10,$00,$00,$00,$00
                    dc.w    $30,$30,$20,$10,$2400,$2440,$00,$00
                    dc.w    $60,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $50,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $40,$00,$10,$20,$1500,$1A00,$00,$00
                    dc.w    $90,$00,$10,$30,$14,$14,$14,$00
                    dc.w    $A0,$00,$10,$30,$14,$14,$14,$00
                    dc.w    $B0,$00,$10,$30,$14,$14,$14,$00
                    dc.w    $C0,$00,$30,$10,$14,$14,$14,$00
                    dc.w    $C0,$10,$30,$10,$14,$14,$14,$00
                    dc.w    $C0,$20,$30,$10,$14,$14,$14,$00
                    dc.w    $60,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $80,$00,$10,$10,$00,$00,$00,$00
                    dc.w    $70,$10,$10,$10,$00,$00,$00,$00
                    dc.w    $80,$10,$10,$10,$00,$00,$00,$00
                    dc.w    $70,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $80,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $70,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $80,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $90,$30,$30,$10,$00,$00,$00,$00
                    dc.w    $90,$40,$30,$10,$00,$00,$00,$00
                    dc.w    $C0,$30,$30,$10,$00,$00,$00,$00
                    dc.w    $C0,$40,$30,$10,$00,$00,$00,$00
                    dc.w    $00,$40,$30,$10,$00,$00,$00,$00
                    dc.w    $30,$40,$30,$10,$00,$00,$00,$00
                    dc.w    $60,$40,$30,$10,$00,$00,$00,$00
                    dc.w    $F0,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $F0,$20,$10,$20,$00,$00,$00,$00
                    dc.w    $F0,$40,$10,$20,$00,$00,$00,$00
                    dc.w    $F0,$60,$10,$20,$00,$00,$00,$00
                    dc.w    $100,$00,$40,$10,$00,$00,$00,$00
                    dc.W    $100,$10,$40,$10,$00,$00,$00,$00
                    dc.w    $100,$20,$40,$10,$00,$00,$00,$00
                    dc.w    $100,$30,$40,$10,$14,$00,$00,$14
                    dc.w    $100,$40,$40,$10,$14,$14,$14,$14
                    dc.w    $100,$50,$40,$10,$14,$14,$14,$14
                    dc.w    $100,$60,$40,$10,$14,$14,$14,$14
                    dc.w    $00,$50,$10,$30,$00,$00,$00,$00
                    dc.w    $10,$50,$10,$30,$00,$00,$00,$00
                    dc.w    $20,$50,$30,$10,$00,$00,$00,$00
                    dc.w    $20,$60,$30,$10,$00,$00,$00,$00
                    dc.w    $50,$50,$10,$30,$15C0,$1600,$1B80,$00
                    dc.w    $60,$50,$30,$10,$15C0,$1600,$1640,$00
                    dc.w    $50,$50,$10,$10,$15C0,$00,$00,$00
                    dc.w    $00,$00,$10,$40,$540,$540,$540,$540
                    dc.w    $10,$00,$10,$40,$80,$80,$80,$80
                    dcb.w   344,$10

lbW01D8BA:          dc.w    $00,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $10,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $20,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $30,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $40,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $50,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $00,$00,$10,$40,$5A2,$5A2,$5A2,$5A2
                    dc.w    $20,$00,$10,$40,$5A3,$5A3,$5A3,$5A3
                    dc.w    $00,$00,$10,$30,$5A2,$5A2,$5A2,$5A2
                    dc.w    $20,$00,$10,$30,$5A3,$5A3,$5A3,$580
                    dc.w    $10,$00,$10,$40,$80,$80,$80,$80
                    dc.w    $10,$00,$10,$30,$80,$80,$80,$00
                    dc.w    $30,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $40,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $30,$10,$10,$10,$563C,$00,$00,$00
                    dc.w    $30,$00,$10,$10,$5F80,$00,$00,$00
                    dc.w    $50,$30,$20,$10,$00,$00,$00,$00
                    dc.w    $50,$20,$20,$10,$00,$00,$00,$00
                    dc.w    $30,$30,$20,$10,$2400,$2440,$00,$00
                    dc.w    $60,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $50,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $40,$00,$10,$20,$1500,$1A00,$00,$00
                    dc.w    $60,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $80,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $A0,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $C0,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $E0,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $100,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $120,$60,$20,$20,$14,$14,$14,$14
                    dc.w    $60,$40,$20,$20,$14,$14,$14,$14
                    dc.w    $A0,$00,$10,$10,$00,$00,$00,$00
                    dc.w    $A0,$10,$10,$10,$00,$00,$00,$00
                    dc.w    $C0,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $100,$40,$20,$10,$2C1,$2C1,$01,$01
                    dc.W    $100,$50,$20,$10,$3100,$3100,$00,$00
                    dc.w    $C0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $D0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $E0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $F0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $100,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $110,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $120,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $130,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $A0,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $B0,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $C0,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $D0,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $E0,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $F0,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $100,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $110,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $120,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $130,$30,$10,$10,$00,$00,$00,$00
                    dc.w    $D0,$00,$10,$10,$00,$00,$00,$00
                    dc.w    $E0,$00,$10,$10,$00,$00,$00,$00
                    dc.w    $F0,$00,$10,$10,$00,$00,$00,$00
                    dc.w    $100,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $110,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $120,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $130,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $80,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $A0,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $C0,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $E0,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $120,$30,$10,$30,$40,$540,$540,$540
                    dc.w    $130,$30,$10,$30,$80,$5C0,$5C0,$00
                    dcb.w   656,$10

lbW01E1FA:          dc.w    $00,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $10,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $20,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $30,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $40,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $50,$80,$10,$10,$00,$00,$00,$00
                    dc.w    $00,$00,$10,$40,$5A2,$5A2,$5A2,$5A2
                    dc.w    $20,$00,$10,$40,$5A3,$5A3,$5A3,$5A3
                    dc.w    $00,$00,$10,$30,$5A2,$5A2,$5A2,$5A2
                    dc.w    $20,$00,$10,$30,$5A3,$5A3,$5A3,$580
                    dc.w    $10,$00,$10,$40,$80,$80,$80,$80
                    dc.w    $10,$00,$10,$30,$80,$80,$80,$00
                    dc.w    $30,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $40,$20,$10,$10,$5B00,$00,$00,$00
                    dc.w    $30,$10,$10,$10,$563C,$00,$00,$00
                    dc.w    $30,$00,$10,$10,$5F80,$00,$00,$00
                    dc.w    $50,$30,$20,$10,$00,$00,$00,$00
                    dc.w    $50,$20,$20,$10,$00,$00,$00,$00
                    dc.w    $30,$30,$20,$10,$2400,$2440,$00,$00
                    dc.w    $60,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $50,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $40,$00,$10,$20,$1500,$1A00,$00,$00
                    dc.w    $70,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $80,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $90,$00,$10,$30,$00,$00,$00,$00
                    dc.w    $A0,$00,$10,$30,$16,$16,$16,$16
                    dc.w    $B0,$00,$10,$30,$16,$16,$16,$16
                    dc.w    $70,$30,$10,$10,$6034,$27,$2F,$27
                    dc.w    $80,$30,$10,$10,$6034,$27,$2F,$27
                    dc.w    $90,$30,$10,$10,$6034,$27,$2F,$27
                    dc.w    $A0,$30,$10,$10,$6034,$27,$2F,$27
                    dc.w    $B0,$30,$10,$10,$6034,$27,$2F,$27
                    dc.w    $C0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $D0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $E0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $F0,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $100,$20,$10,$10,$00,$00,$00,$00
                    dc.w    $C0,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $D0,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $E0,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $F0,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $100,$00,$10,$20,$00,$00,$00,$00
                    dc.w    $00,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $20,$40,$20,$20,$00,$00,$00,$00
                    dc.w    $00,$60,$20,$20,$00,$00,$00,$00
                    dc.w    $120,$30,$10,$30,$40,$540,$540,$540
                    dc.w    $130,$30,$10,$30,$80,$5C0,$5C0,$00
                    dc.w    $110,$10,$30,$10,$5FC0,$5FC0,$5FC0,$00
                    dc.w    $110,$00,$30,$10,$5AC1,$5AC1,$5AC1,$00
                    dcb.w   768,$10
                    
                    dc.w     $FFFF,2,$F8,$FA                    ; ????
lbW01EB12:          dc.l     lbL016A0A
                    dcb.w    2,0
                    dc.l     lbL016A9A
                    dcb.w    2,0
                    dcb.w    3,$FFFF
                    dc.w     2,$F8,$FA
lbW01EB2E:          dc.l     lbL016A3A
                    dcb.w    2,0
                    dc.l     lbL016ACA
                    dcb.w    2,0
                    dcb.w    3,$FFFF
                    dc.w     2,$F8,$FA
lbW01EB4A:          dc.l     lbL016A6A
                    dcb.w    2,0
                    dc.l     lbL016AFA
                    dcb.w    2,0
                    dcb.w    3,$FFFF
                    dc.w     2,$F8,$FA
lbW01EB66:          dc.l     lbL016B2A
                    dcb.w    2,0
                    dc.l     lbL016BBA
                    dcb.w    2,0
                    dcb.w    3,$FFFF
                    dc.w     2,$F8,$FA
lbW01EB82:          dc.l     lbL016B5A
                    dcb.w    2,0
                    dc.l     lbL016BEA
                    dcb.w    2,0
                    dcb.w    3,$FFFF
                    dc.w     2,$F8,$FA
lbW01EB9E:          dc.l     lbL016B8A
                    dcb.w    2,0
                    dc.l     lbL016C1A
                    dcb.w    2,0
                    dcb.w    6,$FFFF
lbL01EBBA:          dc.l     lbL016C4A,$78
                    dc.l     lbL016C7A,3
                    dc.l     lbL016CAA,$50
                    dc.l     lbL016C7A,3,-1,-1,-1
                    dc.l     lbL016CDA,1
                    dc.l     lbL016D0A,1
                    dc.l     lbL016D3A,1
                    dc.l     lbL016D0A,1,-1,-1,-1
lbL01EC12:          dc.l     lbL016D6A,0
                    dc.l     lbL016D9A,0
                    dc.l     lbL016DCA,0,-1,-1,-1
lbL01EC36:          dc.l     lbL016D9A,0
                    dc.l     lbL016DCA,0
                    dc.l     lbL016DFA,0
                    dc.l     lbL016E2A,0,-1,-1,-1
lbL01EC62:          dc.l     lbL016A0A,2
                    dc.l     lbL016A3A,2
                    dc.l     lbL016A6A,2
                    dc.l     lbL016A3A,2,-1,-1,-1
lbL01EC8E:          dc.l     lbL016E5A,$78
                    dc.l     lbL016EBA,3
                    dc.l     lbL016E8A,$50
                    dc.l     lbL016EBA,3,-1,-1,-1
lbL01ECBA:          dc.l     lbL016C1A,0
                    dc.l     lbL016C4A,0
                    dc.l     lbL016C7A,0
                    dc.l     lbL016CAA,0
                    dc.l     lbL016C7A,0
                    dc.l     lbL016C4A,0,-1,-1,-1
lbL01ECF6:          dc.l     lbL016B5A,0
                    dc.l     lbL016B8A,0
                    dc.l     lbL016BBA,0
                    dc.l     lbL016BEA,0
                    dc.l     lbL016BBA,0
                    dc.l     lbL016B8A,0,-1,$F8,$1F0FFFF
lbL01ED32:          dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016A9A,$7D00,-1,$F8,$1F0FFFF
lbL01F076:          dc.l     lbL016A9A,$64
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016A9A,$7D00,-1,$F8,$1F0FFFF
lbL01F3C2:          dc.l     lbL016A9A,$C8
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016A9A,$7D00,-1,$F8,$1F0FFFF
lbL01F70E:          dc.l     lbL016A9A,$12C
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016A9A,$7D00,-1,$F8,$1F0FFFF
lbL01FA5A:          dc.l     lbL016A9A,$190
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016A9A,$7D00,-1,$F8,$1F0FFFF
lbL01FDA6:          dc.l     lbL016A9A
lbL01FDAA:          dc.l     $1F4
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016A9A,$7D00,-1,2,$F800FA
lbL0200F2:          dc.l     lbL016F7A,1
                    dc.l     lbL016FAA,1
                    dc.l     lbL016FDA,1
                    dc.l     lbL01700A,1
                    dc.l     lbL01703A,1
                    dc.l     lbL01706A,-2
                    dc.l     lbL01706A,0
                    dc.l     lbL01706A,0,-1,-1,-1
lbL02013E:          dc.l     lbL016EEA,3
                    dc.l     lbL016F1A,4
                    dc.l     lbL016F4A,2
                    dc.l     lbL016F1A,2,-1,2,$F800FA

patch_dat_reactors: dc.l     lbL016CDA,12
                    dc.l     lbL016CDA,-2
                    dc.l     lbL016CDA,0
                    dc.l     lbL016CDA,0,-1,2,-1

lbL020196:          dc.l     lbL016C1A,12
                    dc.l     lbL016C1A,-2
                    dc.l     lbL016C1A,0
                    dc.l     lbL016C1A,0,-1,2,-1
lbL0201C2:          dc.l     lbL016C4A,12
                    dc.l     lbL016C4A,-2
                    dc.l     lbL016C4A,0
                    dc.l     lbL016C4A,0,-1,-1,-1
lbL0201EE:          dc.l     lbL016B2A,12
                    dc.l     lbL016B2A,-2
                    dc.l     lbL016B2A,0
                    dc.l     lbL016B2A,0,-1,-1,-1

lbL02021A:          dc.l     lbL016CDA,10
                    dc.l     lbL016D0A,2
                    dc.l     lbL016CDA,$32
                    dc.l     lbL016D0A,1
                    dc.l     lbL016CDA,$1E
                    dc.l     lbL016D0A,2
                    dc.l     lbL016CDA,$14
                    dc.l     lbL016D0A,1
                    dc.l     lbL016CDA,$1E
                    dc.l     lbL016D0A,2,-1,-1,-1
lbL020276:          dc.l     lbL016D3A,10
                    dc.l     lbL016D6A,2
                    dc.l     lbL016D3A,$32
                    dc.l     lbL016D6A,1
                    dc.l     lbL016D3A,$1E
                    dc.l     lbL016D6A,2
                    dc.l     lbL016D3A,$14
                    dc.l     lbL016D6A,1
                    dc.l     lbL016D3A,$1E
                    dc.l     lbL016D6A,2,-1,2,$F800FA
lbL0202D2:          dc.l     lbL016A0A,0
                    dc.l     lbL016A3A,0
                    dc.l     lbL016A6A,0
                    dc.l     lbL016A9A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0
                    dc.l     lbL016B2A,0
                    dc.l     lbL016B5A,0
                    dc.l     lbL016B8A,0
                    dc.l     lbL016BBA,0
                    dc.l     lbL016BEA,0
                    dc.l     lbL016C1A,0
                    dc.l     lbL016C4A,0
                    dc.l     lbL016C7A,0
                    dc.l     lbL016CAA,0
                    dc.l     lbL016CDA,0
                    dc.l     lbL016D0A,0
                    dc.l     lbL016D3A,0
                    dc.l     lbL016D6A,0
                    dc.l     lbL016D9A,0
                    dc.l     lbL016DCA,0
                    dc.l     lbL016DFA,0,-1,2,$F800FA
lbL02038E:          dc.l     lbL016E2A,0
                    dc.l     lbL016E5A,0
                    dc.l     lbL016E8A,0
                    dc.l     lbL016EBA,0
                    dc.l     lbL016EEA,0
                    dc.l     lbL016F1A,0
                    dc.l     lbL016F4A,0
                    dc.l     lbL016F7A,0
                    dc.l     lbL016FAA,0
                    dc.l     lbL016FDA,0
                    dc.l     lbL01700A,0
                    dc.l     lbL01703A,0
                    dc.l     lbL01706A,0
                    dc.l     lbL01709A,0
                    dc.l     lbL0170CA,0
                    dc.l     lbL0170FA,0
                    dc.l     lbL01712A,0
                    dc.l     lbL01715A,0
                    dc.l     lbL01718A,0
                    dc.l     lbL0171BA,0
                    dc.l     lbL0171EA,0
                    dc.l     lbL01721A,0,-1
                    dc.l     lbL016C4A,0
                    dc.l     lbL016C7A,0
                    dc.l     lbL016CAA,0,-1,-1,-1
lbL020466:          dc.l     lbL0173FA,$78
                    dc.l     lbL01745A,3
                    dc.l     lbL01742A,$50
                    dc.l     lbL01745A,3,-1,$F8,$1F0FFFF

lbL020596:          dc.l     lbL016A0A,0
                    dc.l     lbL016A3A,0
                    dc.l     lbL016A6A,0,-1,2,$4FFFF
lbL0205BA:          dc.l     lbL016A9A,0
                    dc.l     lbL016ACA,0
                    dc.l     lbL016AFA,0,-1,-1,-1
lbL0205DE:          dc.l     lbL016B2A,0
                    dc.l     lbL016B5A,0,-1,-1,-1
lbL0205FA:          dc.l     lbL016B8A,0
                    dc.l     lbL016BBA,0,-1,-1,-1
lbL020616:          dc.l     lbL016BEA,0
                    dc.l     lbL016C1A,0,-1,-1,-1
lbL020632:          dc.l     lbL016C4A,0
                    dc.l     lbL016C7A,0,-1,$FFFF,-1
lbL02064E:          dc.l     lbL01712A,-2
                    dc.l     lbL01712A,0
                    dc.l     lbL01712A,0,-1,-1,-1
lbL020672:          dc.l     lbL016B2A,-2
                    dc.l     lbL016B2A,1
                    dc.l     lbL016B2A,1,-1,-1,-1
lbL020696:          dc.l     lbL016B8A,-2
                    dc.l     lbL016B8A,1
                    dc.l     lbL016B8A,1,-1,-1,-1
lbL0206BA:          dc.l     lbL016BEA,-2
                    dc.l     lbL016BEA,1
                    dc.l     lbL016BEA,1,-1,-1,-1
lbL0206DE:          dc.l     lbL016C4A,-2
                    dc.l     lbL016C4A,1
                    dc.l     lbL016C4A,1,-1,-1,-1
lbL020702:          dc.l     lbL01703A,1
                    dc.l     lbL01703A,-2
                    dc.l     lbL01703A,1,-1
                    dc.l     lbL01703A,1,-1,-1
lbL02072E:          dc.l     lbL01709A,1
                    dc.l     lbL01709A,-2
                    dc.l     lbL01709A,1,-1
                    dc.l     lbL01709A,1,$F8,$1F0FFFF
lbL02075A:          dc.l     lbL0170CA,1
                    dc.l     lbL0170CA,-2
                    dc.l     lbL0170CA,1,-1
                    dc.l     lbL0170CA,1,2,$4FFFF
lbL020786:          dc.l     lbL0170FA,1
                    dc.l     lbL0170FA,-2
                    dc.l     lbL0170FA,1,-1
                    dc.l     lbL0170FA,1,-1,-1
                    dc.l     lbL016CAA,0
                    dc.l     lbL016CDA,0,-1,-1,-1
                    dc.l     lbL016D0A,0
                    dc.l     lbL016D3A,0,-1,-1,-1
                    dc.l     lbL016D6A,0
                    dc.l     lbL016D9A,0
                    dc.l     lbL016DCA,0,-1,-1,-1
lbL02080E:          dc.l     lbL016DFA,1
                    dc.l     lbL016E2A,1,-1,-1,-1
lbL02082A:          dc.l     lbL016E5A,1
                    dc.l     lbL016E8A,1,-1,-1,-1
lbL020846:          dc.l     lbL01700A,6
                    dc.l     lbL01703A,6,-1,-1,-1
lbL020862:          dc.l     lbL01706A,6
                    dc.l     lbL01709A,6,-1,$F8,$1F002E8
lbL02087E:          dc.l     lbL01715A,-2
                    dc.l     lbL01715A,0
                    dc.l     lbL01715A,0,-1,$F8,$1F002E8
                    dc.l     lbL01718A,-2
                    dc.l     lbL01718A,0
                    dc.l     lbL01718A,0,-1,2,$F800FA
lbL0208C6:          dc.l     lbL016A0A,$4B
                    dc.l     lbL016A3A,1
                    dc.l     lbL016A6A,1
                    dc.l     lbL016A9A,1
                    dc.l     lbL016ACA,1
                    dc.l     lbL016AFA,1
                    dc.l     lbL016B2A,1
                    dc.l     lbL016B5A,$4B
                    dc.l     lbL016B2A,1
                    dc.l     lbL016AFA,1
                    dc.l     lbL016ACA,1
                    dc.l     lbL016A9A,1
                    dc.l     lbL016A6A,1
                    dc.l     lbL016A3A,1,-1,-1,-1
lbL020942:          dc.l     lbL016B8A,0
                    dc.l     lbL016BBA,0,-1,-1,-1
lbL02095E:          dc.l     lbL016FDA,2
                    dc.l     lbL01700A,2
                    dc.l     lbL01703A,2
                    dc.l     lbL01700A,2,-1,-1,-1
lbL02098A:          dc.l     lbL01706A,1
                    dc.l     lbL01709A,1
                    dc.l     lbL0170CA,1
                    dc.l     lbL0170FA,1,-1,-1,-1
lbL0209B6:          dc.l     lbL01712A,0
                    dc.l     lbL01715A,0
                    dc.l     lbL01718A,0
                    dc.l     lbL0171BA,0,-1,-1,-1
lbL0209E2:          dc.l     lbL016C1A,0
                    dc.l     lbL016C4A,0
                    dc.l     lbL016C7A,0
                    dc.l     lbL016CAA,0
                    dc.l     lbL016CDA,0
                    dc.l     lbL016D0A,0
                    dc.l     lbL016D3A,0
                    dc.l     lbL016D6A,0
                    dc.l     lbL016D9A,0
                    dc.l     lbL016DCA,-2
                    dc.l     lbL016DCA,0
                    dc.l     lbL016DCA,0,-1,-1,-1
                    dc.l     lbL016DFA,0
                    dc.l     lbL016E2A,0
                    dc.l     lbL016E5A,0
                    dc.l     lbL016E8A,0
                    dc.l     lbL016EBA,0
                    dc.l     lbL016EEA,0
                    dc.l     lbL016F1A,0
                    dc.l     lbL016F4A,0
                    dc.l     lbL016F7A,0
                    dc.l     lbL016FAA,-2
                    dc.l     lbL016FAA,0
                    dc.l     lbL016FAA,0,-1,$F8,$1F0FFFF

lbL020B0A:          dc.l     lbL016EBA,-2
                    dc.l     lbL016EBA,0
                    dc.l     lbL016EBA,0,-1,2,$4FFFF
lbL020B2E:          dc.l     lbL016EEA,-2
                    dc.l     lbL016EEA,0
                    dc.l     lbL016EEA,0,-1,$F8,$1F0FFFF
lbL020B52:          dc.l     lbL01679A,2
                    dc.l     lbL016E5A,-2
                    dc.l     lbL016E5A,0
                    dc.l     lbL016E5A,0,-1,$F8,$1F0FFFF,$F8,$1F0FFFF
lbL020B86:          dc.l     lbL016E8A,-2
                    dc.l     lbL016E8A,0
                    dc.l     lbL016E8A,0,-1,$F8,$1F0FFFF
lbL020BAA:          dc.l     lbL016A0A,10
                    dc.l     lbL016A3A,1
                    dc.l     lbL016A6A,1
                    dc.l     lbL016A9A,1
                    dc.l     lbL016ACA,5
                    dc.l     lbL016A9A,1
                    dc.l     lbL016A6A,1
                    dc.l     lbL016A3A,1,-1,$FFFF,-1
lbL020BF6:          dc.l     lbL016AFA,1
                    dc.l     lbL016B2A,1
                    dc.l     lbL016B5A,1
                    dc.l     lbL016B8A,1
                    dc.l     lbL016BBA,-2
                    dc.l     lbL016BBA,0
                    dc.l     lbL016BBA,0,-1,-1,-1
lbL020C3A:          dc.l     lbL016BEA,10
                    dc.l     lbL016C1A,0
                    dc.l     lbL016C4A,0
                    dc.l     lbL016C7A,0
                    dc.l     lbL016CAA,5
                    dc.l     lbL016C7A,0
                    dc.l     lbL016C4A,0
                    dc.l     lbL016C1A,0,-1,-1,-1
lbL020C86:          dc.l     lbL016CDA,10
                    dc.l     lbL016D0A,0
                    dc.l     lbL016D3A,0
                    dc.l     lbL016D6A,0
                    dc.l     lbL016D9A,5
                    dc.l     lbL016D6A,0
                    dc.l     lbL016D3A,0
                    dc.l     lbL016D0A,0,-1,-1,-1
lbL020CD2:          dc.l     lbL016DCA,$50
                    dc.l     lbL016DFA,4
                    dc.l     lbL016E2A,$50
                    dc.l     lbL016DFA,4,-1,2,-1
lbL020CFE:          dc.l     lbL0168EA,1
                    dc.l     lbL01691A,1
                    dc.l     lbL01694A,-2
                    dc.l     lbL01694A,0
                    dc.l     lbL01694A,0,-1,$F8,-1
lbL020D32:          dc.l     lbL01697A,1
                    dc.l     lbL0169AA,1
                    dc.l     lbL0169DA,-2
                    dc.l     lbL0169DA,0
                    dc.l     lbL0169DA,0,-1,$FFFF,-1
lbL020D66:          dc.l     lbL01682A,1
                    dc.l     lbL01685A,-2
                    dc.l     lbL01685A,0
                    dc.l     lbL01685A,0,-1,$FFFF,-1
lbL020D92:          dc.l     lbL01682A,0
                    dc.l     lbL01685A,-2
                    dc.l     lbL01685A,0
                    dc.l     lbL01685A,0,-1,$FFFF,-1
lbL020DBE:          dc.l     lbL01688A,-2
                    dc.l     lbL01688A,0
                    dc.l     lbL01688A,0,-1,$F8,$1F002E8
lbL020DE2:          dc.l     lbL01670A,2
                    dc.l     lbL01673A,-2
                    dc.l     lbL01673A,0
                    dc.l     lbL01673A,0,-1,$F8,$1F0FFFF
lbL020E0E:          dc.l     lbL01676A,2
                    dc.l     lbL01679A,-2
                    dc.l     lbL01679A,0
                    dc.l     lbL01679A,0,-1,$F8,$1F002E8
lbL020E3A:          dc.l     lbL0167CA,-2
                    dc.l     lbL0167CA,0
                    dc.l     lbL0167CA,0,-1,$F8,$1F0FFFF
lbL020E5E:          dc.l     lbL0167FA,-2
                    dc.l     lbL0167FA,0
                    dc.l     lbL0167FA,0,-1,$FFFF,-1
lbL020E82:          dc.l     lbL0168BA,-2
                    dc.l     lbL0168BA,0
                    dc.l     lbL0168BA,0,-1,$FFFF,-1
lbL020EA6:          dc.l     lbL0165EA,12
                    dc.l     lbL0168BA,-2
                    dc.l     lbL0168BA,0
                    dc.l     lbL0168BA,0,-1,$FFFF,-1
lbL020ED2:          dc.l     lbL01661A,12
                    dc.l     lbL0168BA,-2
                    dc.l     lbL0168BA,0
                    dc.l     lbL0168BA,0,-1,$FFFF,-1

lbL020EFE:          dc.l     lbL01664A,12
                    dc.l     lbL0168BA,-2
                    dc.l     lbL0168BA,0
                    dc.l     lbL0168BA,0,-1,$FFFF,-1

lbL020F2A:          dc.l     lbL01667A,12
                    dc.l     lbL0168BA,-2
                    dc.l     lbL0168BA,0
                    dc.l     lbL0168BA,0,-1,$FFFF,-1
lbL020F56:          dc.l     lbL0166AA,12
                    dc.l     lbL0168BA,-2
                    dc.l     lbL0168BA,0
                    dc.l     lbL0168BA,0,-1,$FFFF,-1
lbL020F82:          dc.l     lbL0166DA,12
                    dc.l     lbL0168BA,-2
                    dc.l     lbL0168BA,0
                    dc.l     lbL0168BA,0,-1

return2:            rts

disable_interrupts: move.w   #$4000,$dff09a
                    rts

init_level_variables:
                    clr.w    lbW0004D8
                    clr.w    lbW0004B2
                    clr.w    flag_end_level
                    clr.w    lbW00057A
                    jsr      lbC00E8D8
                    jsr      lbC00D2BA
                    lea      lbL00D29A,a0
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    lea      lbL00D2AA,a0
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    clr.l    (a0)+
                    jsr      lbC00ACC2
                    jsr      lbC00ADD6
                    jsr      lbC023210
                    jsr      lbC00A6AE
                    lea      lbL012328,a0
                    add.l    #4,a0
lbC021016:          move.l   (a0),a1
                    clr.l    $42(a1)
                    move.l   #lbL00051C,$32(a1)
                    move.l   #lbL00051C,$36(a1)
                    move.l   #lbL00051C,$3A(a1)
                    move.l   #lbL00051C,$3E(a1)
                    addq.l   #4,a0
                    tst.l    (a0)
                    bne.s    lbC021016
                    rts

keyboard_handler:   tst.w    music_enabled
                    bne      return2
                    move.w   #8,$dff09a
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.b   $bfec01,d0
                    not.b    d0
                    lsr.w    #1,d0
                    bcs.s    lbC021074
                    and.w    #$7F,d0
                    move.b   d0,key_pressed
                    bra      lbC02107E

lbC021074:          and.w    #$7F,d0
                    move.b   d0,key_released
lbC02107E:          moveq    #0,d0
                    move.b   $bfed01,d0
                    btst     #3,d0
                    beq      lbC0210B8
                    move.b   $bfec01,d0
                    or.b     #$40,$bfee01
                    move.b   #$FF,$bfec01
                    and.b    #$BF,$bfee01
lbC0210B8:          movem.l  (sp)+,d0-d7/a0-a6
                    move.w   #8,$dff09c
                    rts

key_pressed:        dc.b    0
key_released:       dc.b    0

text_briefing_level_1:
                    dc.w     8,40
                    dc.b     'SHUTTLE BAY TWO, DECK ONE.      ',0
                    dc.b     ' ',0
                    dc.b     'UPON LEAVING YOUR CRAFT, PERFORM',0
                    dc.b     'A RECCE OF THE IMMEDIATE AREA.  ',0
                    dc.b     '                                ',0
                    dc.b     'LOCATE DECK LIFT THAT LEADS TO  ',0
                    dc.b     'POWER SUB SYSTEM AND PROCEED    ',0
                    dc.b     'FURTHER INTO THE HEART OF THE   ',0
                    dc.b     'STATION. RADAR REPORTS LITTLE   ',0
                    dc.b     'MOVEMENT, BUT SOME NEAR VENTS.  ',0
                    dc.b     '                                ',0
                    dc.b     'CONTROL ADVISES MAXIMUM USE OF  ',0
                    dc.b     'ANY AVAILABLE RESOURCES LEFT BY ',0
                    dc.b     'THE STATIONS PREVIOUS OCCUPANTS.'
                    dc.b     -1
                    even
text_briefing_level_2:
                    dc.w     8,40
                    dc.b     'POWER SUBSYSTEM, DECK TWO.      ',0
                    dc.b     ' ',0
                    dc.b     'INITIAL PRIORITY IS TO NEGATE   ',0
                    dc.b     'POSSIBILITIES OF FURTHER ATTACK ',0
                    dc.b     'BY BLOWING THE TOP TWO DECKS.   ',0
                    dc.b     '                                ',0
                    dc.b     'TAKE OUT THE FOUR POWER DOMES   ',0
                    dc.b     'AND GET OUT OF THERE BEFORE THE ',0
                    dc.b     'BLAST HITS. ONCE UNSTABLE, YOU  ',0
                    dc.b     'HAVE SIXTY SECONDS TO FLEE TO   ',0
                    dc.b     'THE NEXT LEVEL VIA THE DECK LIFT',0
                    dc.b     '                                ',0
                    dc.b     'RADAR INDICATES MOVEMENT        ',0
                    dc.b     'DIRECTLY BELOW CURRENT POSITION.',0
                    dc.b     ' ',0
                    dc.b     'ENTER CODE 55955 TO RESTART HERE'
                    dc.b     -1
                    even

text_briefing_level_3:
                    dc.w     8,40
                    dc.b     'SECURITY ZONE, DECK THREE.      ',0
                    dc.b     ' ',0
                    dc.b     'UNFORTUNATELY THE BLAST FROM THE',0
                    dc.b     'POWER SYSTEM MELTDOWN HAS SPREAD',0
                    dc.b     'INTO THIS LEVEL AND IF IT IS NOT',0
                    dc.b     'STOPPED, THE WHOLE STATION COULD',0
                    dc.b     'BLOW. IMMEDIATE CLOSURE OF ALL  ',0
                    dc.b     'FIRE DOORS REMAINS A PRIORITY   ',0
                    dc.b     '                                ',0
                    dc.b     'ONCE ACHIEVED, RETURN TO THE DECK',0
                    dc.b     'LIFT AND AWAIT INSTRUCTIONS     ',0
                    dc.b     '                                ',0
                    dc.b     'RADAR MALFUNCTIONING.. ERRATIC  ',0
                    dc.b     'READINGS.. ADVISE CAUTION...    '
                    dc.b     -1

text_briefing_level_4:
                    dc.w     8,40
                    dc.b     'OVAL ZONE. DECK FOUR.           ',0
                    dc.b     ' ',0
                    dc.b     'THE THREAT FROM FIRE AND BLAST  ',0
                    dc.b     'HAS RECEDED SOMEWHAT, GIVING YOU',0
                    dc.b     'CHANCE TO GATHER YOUR THOUGHTS..',0
                    dc.b     '                                ',0
                    dc.b     'INFORMATION SUGGESTS THAT THE   ',0
                    dc.b     'NEXT DECK HARBOURS A MASSIVE    ',0
                    dc.b     'ALIEN PRESENCE AND IT IS THERE  ',0
                    dc.b     'THAT YOUR NEXT MISSION AWAITS.. ',0
                    dc.b     'PROCEED WITH ALL SPEED TO THE   ',0
                    dc.b     'ENGINEERING DECK.               ',0
                    dc.b     ' ',0
                    dc.b     'ENTER CODE 48361 TO RESTART HERE'
                    dc.b     -1
                    even
text_briefing_level_5:          
                    dc.w     8,40
                    dc.b     'ENGINEERING ZONE ONE. DECK FIVE.',0
                    dc.b     ' ',0
                    dc.b     'AN EVIL SMELL FILLS THE AIR AS  ',0
                    dc.b     'YOU ARRIVE IN THE FIRST OF A    ',0
                    dc.b     'SERIES OF ENGINEERING DECKS WHICH',0
                    dc.b     'COMPRISE THE MAJOR SECTION OF THE',0
                    dc.b     'WHOLE STATION.                  ',0
                    dc.b     '                                ',0
                    dc.b     'HQ ARE PLEASED TO INFORM YOU THAT',0
                    dc.b     'THERES SOMETHING BIG IN THERE.. ',0
                    dc.b     '                                ',0
                    dc.b     'TERMINATE WHATEVER YOU FIND AND ',0
                    dc.b     'MAKE YOUR WAY DOWN TO DECK SIX..'
                    dc.b     -1
                    even
text_briefing_level_6:          
                    dc.w     8,40
                    dc.b     'ENGINEERING SUB SYSTEM. DECK SIX.',0
                    dc.b     ' ',0
                    dc.b     'THE CREATURE YOU HAVE JUST SLAIN',0
                    dc.b     'IS NOW REPORTED TO BE JUST ONE  ',0
                    dc.b     'OF A NUMBER LOCATED IN THIS     ',0
                    dc.b     'STATION. CONTROL ASSUME THE QUEEN',0
                    dc.b     'ALIEN TO BE LURKING SOMEWHERE    ',0
                    dc.b     'QUIET AND WELL GUARDED, SOMEWHERE',0
                    dc.b     'DEEP IN THE HEART OF THE STATION.',0
                    dc.b     '                                 ',0
                    dc.b     'MAKE YOUR WAY TO DECK SEVEN,     ',0
                    dc.b     'THE ENGINEERING MAIN DECK... ',0
                    dc.b     ' ',0
                    dc.b     'ENTER CODE 63556 TO RESTART HERE'
                    dc.b     -1
                    even
text_briefing_level_7:          
                    dc.w     8,40
                    dc.b     'ENGINEERING. DECK SEVEN.         ',0
                    dc.b     ' ',0
                    dc.b     'ANOTHER LARGE PRESENCE SHOWS     ',0
                    dc.b     'ON SCANNING EQUIPMENT, IT MIGHT  ',0
                    dc.b     'BE THE QUEEN ALIEN.. IF IT IS,   ',0
                    dc.b     'THEN PROCEED WITH CAUTION..      ',0
                    dc.b     '                                 ',0
                    dc.b     'ISOLATE AND TERMINATE ANYTHING   ',0
                    dc.b     'YOU SEE MOVING.. SURVIVORS THIS  ',0
                    dc.b     'DEEP IN THE STATION ARE UNLIKELY.',0
                    dc.b     '                                 ',0
                    dc.b     '                                 ',0
                    dc.b     '                                 '
                    dc.b     -1
                    even
text_briefing_level_8:          
                    dc.w     8,40
                    dc.b     'POWERMECH SYSTEMS. DECK EIGHT.  ',0
                    dc.b     ' ',0
                    dc.b     'THE DECK LIFT TO LOWER LEVELS HAS',0
                    dc.b     'BEEN DAMAGED AND TRAVEL WILL HAVE',0
                    dc.b     'TO BE RESTRICTED TO THE MAZE LIKE',0
                    dc.b     'CONFINES OF THE ENGINEERING DUCTS',0
                    dc.b     '                                ',0
                    dc.b     'FIND DUCT THREE AND QUICKLY MAKE',0
                    dc.b     'YOUR WAY DOWN TO THE CENTRAL CORE',0
                    dc.b     '                                ',0
                    dc.b     'REMOTE LOCATION SCANNER ',0
                    dc.b     'HIGHLY RECOMMENDED.. ',0
                    dc.b     ' ',0
                    dc.b     'ENTER CODE 86723 TO RESTART HERE'
                    dc.b     -1
                    even
text_briefing_level_9:          
                    dc.w     8,40
                    dc.b     'ENGINEERING SYSTEM SHAFT WHICH',0
                    dc.b     'LINKS DECK EIGHT AND REACTOR CORE',0
                    dc.b     ' ',0
                    dc.b     'QUICKLY LOCATE AND USE GRILL LIFT',0
                    dc.b     'THAT WILL TAKE YOU TO THE CENTRAL',0
                    dc.b     'REACTOR CORE. SECURITY SYSTEMS  ',0
                    dc.b     'HAVE BEEN TRIGGERED AND YOU ARE ',0
                    dc.b     'ADVISED TO MOVE QUICKLY.        ',0
                    dc.b     '                                ',0
                    dc.b     'FORTUNATELY THERE SEEMS TO BE NO',0
                    dc.b     'MOVEMENT IN THE SHAFT COMPLEX..',0
                    dc.b     'NOT THAT IT MAKES THE TASK ANY ',0
                    dc.b     'EASIER THOUGH..'
                    dc.b     -1
                    even
text_briefing_level_10:          
                    dc.w     8,40
                    dc.b     'REACTOR CORE. DECK TEN.',0
                    dc.b     ' ',0
                    dc.b     'YOUR PRIORITY IS TO DEACTIVATE',0
                    dc.b     'THE CENTRAL CORE REACTOR IN ZONE',0
                    dc.b     'SIX. THIS WILL PREPARE THE WHOLE',0
                    dc.b     'STATION FOR MELTDOWN AND PROVIDE',0
                    dc.b     'AN ESCAPE IN THE SHUTTLE, A JUST',0
                    dc.b     'VICTORY AGAINST THE RENEGADE ALIEN',0
                    dc.b     'FORCE..',0
                    dc.b     '      ',0
                    dc.b     'MAKE FOR THE SHUTTLE CRAFT LIFT',0
                    dc.b     'WHEN CORE MELTDOWN INITIATED.',0
                    dc.b     ' ',0
                    dc.b     'ENTER CODE 25194 TO RESTART HERE'
                    dc.b     -1
                    even
text_briefing_level_11:          
                    dc.w     8,40
                    dc.b     'LOCATION UNKNOWN.. ',0
                    dc.b     ' ',0
                    dc.b     'A LIFT MALFUNCTION HAS LEFT YOU',0
                    dc.b     'IN NEAR DARKNESS.. BLUE EYES ARE',0
                    dc.b     'COMING AT YOU FROM ALL DIRECTIONS',0
                    dc.b     'AND YOUR ONLY HOPE IS TO MOVE',0
                    dc.b     'QUICKLY AND TRUST YOUR LAZER..',0
                    dc.b     ' ',0
                    dc.b     'ESCAPE FROM THIS LIVING HELL IS',0
                    dc.b     'THE ONLY OPTION. IT LOOKS LIKE',0
                    dc.b     'THIS WAS SOME SORT OF SECURITY',0
                    dc.b     'ZONE, SO CAUTION IS ADVISED...',0
                    dc.b     '                                '
                    dc.b     -1
                    even
text_briefing_level_12:          
                    dc.w     8,40
                    dc.b     'THE HATCHERY..',0
                    dc.b     ' ',0
                    dc.b     'YOU ALMOST RETCH AS A FOUL STENCH',0
                    dc.b     'HITS THE BACK OF YOUR THROAT, ',0
                    dc.b     'YOU REALISE EXACTLY WHO IS DOWN',0
                    dc.b     'HERE.. ',0
                    dc.b     '                                ',0
                    dc.b     'THERE ARE EGGS EVERYWHERE AND',0
                    dc.b     'SLIME COVERS THE BIOFORM WALLS..',0
                    dc.b     ' ',0
                    dc.b     'YOUR MISSION IS SIMPLE, KILL',0
                    dc.b     'THE QUEEN AND GET THE HELL OUT',0
                    dc.b     'BEFORE THE STATION GOES UP..'
                    dc.b     -1
                    even

lbL02266A:          dcb.l    32,0

lbL0226EA:          dcb.l    $20,0
lbW02276A:          dcb.w    64,$FFF

level_palette1:     dcb.w    32,0

level_palette2:     dcb.w    32,0

start_music:        tst.w    lbW0003A2
                    beq      lbC022B92
                    clr.w    lbW0004E0
                    clr.w    audio_dmacon
                    clr.w    dma
                    clr.w    lbW022C70
                    clr.w    bpstep
                    clr.b    bppatcount
                    clr.b    st
                    clr.b    tr
                    move.b   #1,bpcount
                    move.b   #6,bpdelay
                    move.b   #1,arpcount
                    move.b   #1,bprepcount
                    clr.b    numtables
                    clr.l    tables
                    movem.l  d0/a0/a1,-(sp)
                    lea      bpreset,a0
                    lea      bpcurrent,a1
                    move.w   #64-1,d0
lbC022B64:          move.w   (a0)+,(a1)+
                    dbf      d0,lbC022B64
                    lea      bpbuffer,a0
                    move.w   #144-1,d0
lbC022B74:          clr.b    (a0)+
                    dbf      d0,lbC022B74
                    movem.l  (sp)+,d0/a0/a1
                    jsr      bpinit
                    jsr      bpresetbuffer
                    move.w   #1,lbW0004C4
lbC022B92:          rts

stop_sound:         tst.w    lbW0003A2
                    beq      lbC022C30
                    clr.w    lbW0004E0
                    moveq    #76,d0
                    moveq    #0,d2
                    jsr      trigger_sample_select_channel
                    moveq    #76,d0
                    moveq    #1,d2
                    jsr      trigger_sample_select_channel
                    moveq    #76,d0
                    moveq    #2,d2
                    jsr      trigger_sample_select_channel
                    moveq    #76,d0
                    moveq    #3,d2
                    jsr      trigger_sample_select_channel
                    move.l   #12,number_frames_to_wait
                    jsr      sleep_frames
                    clr.w    lbW0004C4
                    jsr      silence
                    move.w   #2,$dff0a2
                    move.w   #2,$dff0b2
                    move.w   #2,$dff0c2
                    move.w   #2,$dff0d2
                    move.w   #15,$dff096
                    clr.w    bpchannel1_status
                    clr.w    bpchannel2_status
                    clr.w    bpchannel3_status
                    clr.w    bpchannel4_status
                    clr.w    lbW022C70
lbC022C30:          rts

lbB022C32:          dcb.b    2,0

lbC022C34:          tst.w    music_enabled
                    bne      return2
                    move.w   audio_dmacon,d0
                    move.w   d0,$dff096
                    btst     #3,d0
                    beq.s    lbC022C60
                    move.w   #$400,$dff09c
                    move.w   #$8400,$dff09a
lbC022C60:          clr.w    audio_dmacon
                    rts

bpchannel1_status:  dc.w     0
bpchannel2_status:  dc.w     0
bpchannel3_status:  dc.w     0
bpchannel4_status:  dc.w     0
lbW022C70:          dc.l     0

lbC022D1E:          tst.w    lbW0004C2
                    beq      return2
                    move.l   #lbL02311A,d0
                    cmp.l    lbL02328C,d0
                    beq      return2
                    cmp.l    lbL02320C,d0
                    beq      return2
                    move.w   lbW008C9A,d7
                    subq.w   #1,d7
                    add.w    #$41,d7
                    cmp.w    lbW023126,d7
                    beq      return2
                    move.w   d7,lbW023126
                    lea      lbL02311A,a6
                    jsr      lbC02325A
                    tst.w    lbW02328A
                    bne      return2
                    lea      lbL02311A,a6
                    move.l   a6,lbL02328C
                    rts

install_lev4irq:    lea      lbL114EC4,a0
                    move.w   #129-1,d0
lbC022D8C:          clr.l    (a0)+
                    dbf      d0,lbC022D8C
                    move.w   #$780,$dff09a
                    move.w   #$780,$dff09c
                    move.l   reg_vbr,a1
                    move.l   $70(a1),d0
                    lea      lev4irq(pc),a0
                    cmp.l    a0,d0
                    beq.s    lbC022DBE
                    move.l   a0,$70(a1)
lbC022DBE:          rts

lev4irq:            move.l   d0,-(sp)
                    move.w   $dff01e,d0
                    btst     #10,d0
                    beq      lbC022F2E
                    move.w   #$400,$dff09c
                    movem.l  a0/a1,-(sp)
                    lea      lbW0230F8(pc),a0
                    lea      lbL114EC4,a1
                    move.l   2(a0),d0
                    bmi      lbC022E8E
                    not.w    0(a0)
                    beq.s    lbC022E16
                    add.w    #$100,a1
lbC022E16:          move.l   a1,$dff0d0
                    movem.l  d1-d7/a2/a3,-(sp)
                    move.l   6(a0),a2
                    add.l    #$100,6(a0)
                    sub.l    #$100,2(a0)
                    bmi.s    lbC022EB0
                    moveq    #$20,d0
                    movem.l  (a2)+,d1-d7/a3
                    movem.l  d1-d7/a3,(a1)
                    add.w    d0,a1
                    movem.l  (a2)+,d1-d7/a3
                    movem.l  d1-d7/a3,(a1)
                    add.w    d0,a1
                    movem.l  (a2)+,d1-d7/a3
                    movem.l  d1-d7/a3,(a1)
                    add.w    d0,a1
                    movem.l  (a2)+,d1-d7/a3
                    movem.l  d1-d7/a3,(a1)
                    add.w    d0,a1
                    movem.l  (a2)+,d1-d7/a3
                    movem.l  d1-d7/a3,(a1)
                    add.w    d0,a1
                    movem.l  (a2)+,d1-d7/a3
                    movem.l  d1-d7/a3,(a1)
                    add.w    d0,a1
                    movem.l  (a2)+,d1-d7/a3
                    movem.l  d1-d7/a3,(a1)
                    add.w    d0,a1
                    movem.l  (a2)+,d1-d7/a3
                    movem.l  d1-d7/a3,(a1)
                    movem.l  (sp)+,d1-d7/a2/a3
                    bra      lbC022F2A

lbC022E8E:          move.l   #lbL1150C4,$dff0d0
                    move.w   #1,$dff0d4
                    clr.w    $dff0d8
                    move.w   #$400,$dff09a
                    bra.s    lbC022F2A

lbC022EB0:          lsr.w    #1,d0
                    move.w   d0,$dff0d4
                    add.w    d0,d0
                    moveq    #$20,d1
                    movem.l  (a2)+,d2-d7/a0/a3
                    movem.l  d2-d7/a0/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    bmi.s    lbC022F26
                    movem.l  (a2)+,d2-d7/a0/a3
                    movem.l  d2-d7/a0/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    bmi.s    lbC022F26
                    movem.l  (a2)+,d2-d7/a0/a3
                    movem.l  d2-d7/a0/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    bmi.s    lbC022F26
                    movem.l  (a2)+,d2-d7/a0/a3
                    movem.l  d2-d7/a0/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    bmi.s    lbC022F26
                    movem.l  (a2)+,d2-d7/a0/a3
                    movem.l  d2-d7/a0/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    bmi.s    lbC022F26
                    movem.l  (a2)+,d2-d7/a0/a3
                    movem.l  d2-d7/a0/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    bmi.s    lbC022F26
                    movem.l  (a2)+,d2-d7/a0/a3
                    movem.l  d2-d7/a0/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    bmi.s    lbC022F26
                    movem.l  (a2)+,d2-d7/a0/a3
                    movem.l  d2-d7/a0/a3,(a1)
lbC022F26:          movem.l  (sp)+,d1-d7/a2/a3
lbC022F2A:          movem.l  (sp)+,a0/a1
lbC022F2E:          move.w   #$400,$dff09c
                    move.l   (sp)+,d0
                    rte

lbC022F3A:          movem.l  d2-d7/a2-a4,-(sp)
                    move.w   #$400,$dff09a
                    cmp.l    #$200,d0
                    bgt      lbC023070
                    move.l   d0,-(sp)
                    lea      lbL114EC4,a1
                    move.l   a1,a4
                    moveq    #$20,d1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble      lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble      lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble      lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble      lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble      lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble      lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    sub.w    d1,d0
                    ble.s    lbC023042
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
lbC023042:          move.l   (sp)+,d0
                    lsr.w    #1,d0
                    move.l   a4,$dff0d0
                    move.w   d0,$dff0d4
                    move.w   #$400,$dff09c
                    move.w   #$8400,$dff09a
                    move.l   #-1,lbL0230FA
                    bra      lbC0230F2

lbC023070:          clr.w    lbW0230F8
                    sub.l    #$100,d0
                    move.l   d0,lbL0230FA
                    lea      $100(a0),a1
                    move.l   a1,lbL0230FE
                    lea      lbL114EC4,a1
                    move.l   a1,a4
                    moveq    #$20,d1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    add.w    d1,a1
                    movem.l  (a0)+,d2-d7/a2/a3
                    movem.l  d2-d7/a2/a3,(a1)
                    move.l   a4,$dff0d0
                    move.w   #$80,$dff0d4
lbC0230F2:          movem.l  (sp)+,d2-d7/a2-a4
                    rts

lbW0230F8:          dc.w     0
lbL0230FA:          dc.l     0
lbL0230FE:          dc.l     0

lbL02311A:          dc.l     $1E0033
                    dc.w     3
                    dc.l     lbW023124
lbW023124:          dc.w     12
lbW023126:          dc.w     0,3,0,0
lbL02312E:          dc.l     $1E0039
                    dc.w     3
                    dc.l     lbW023138
lbW023138:          dc.w     13
lbW02313A:          dc.w     $42,3
                    dc.l     lbW023142
lbW023142:          dc.w     13,$3A,3
                    dc.l     lbW02314C
lbW02314C:          dc.w     $10
lbW02314E:          dc.w     0,3,0,0
lbW023156:          dc.w     1,$19,1
                    dc.l     lbW023160
lbW023160:          dc.w     15,$1A,1,0,0
lbW02316A:          dc.w     1,$1A,2
                    dc.l     lbW023174
lbW023174:          dc.w     $14,15,2
                    dc.l     lbW02317E
lbW02317E:          dc.w     1,$11,3
                    dc.l     lbW023188
lbW023188:          dc.w     $1E,$12,3
                    dc.l     lbW023192
lbW023192:          dc.w     $DC,$11,3
                    dc.l     lbW02319C
lbW02319C:          dc.w     $1E,$12,3
                    dc.l     lbW023192
lbW0231A6:          dc.w     1,$10,2
                    dc.l     lbW0231B0
lbW0231B0:          dc.w     $3C,$12,3
                    dc.l     lbW0231B0
lbW0231BA:          dc.w     1,10,2
                    dc.l     lbW0231C4
lbW0231C4:          dc.w     10,11,2
                    dc.l     lbW0231CE
lbW0231CE:          dc.w     $14,10,1
                    dc.l     lbW0231D8
lbW0231D8:          dc.w     $32,11,2
                    dc.l     lbW0231C4
                    dc.w     1,$29,1
                    dc.l     lbW0231EC
lbW0231EC:          dc.w     $96,$2A,2
                    dc.l     lbW0231F6
lbW0231F6:          dc.w     $32,$4C,1,0,0
lbL023200:          dc.l     0
lbW023204:          dcb.w    2,0
lbL023208:          dc.l     0
lbL02320C:          dc.l     0

lbC023210:          clr.l    lbL023200
                    clr.l    lbW023204
                    clr.l    lbL023208
                    clr.l    lbL02320C
                    clr.l    lbL02328C
                    clr.l    lbL023290
                    clr.l    lbL023294
                    clr.l    lbL023298
                    clr.l    lbL02329C
                    clr.l    lbL0232A0
                    clr.w    lbW023EA0
                    clr.w    lbW023EA2
                    rts

lbC02325A:          tst.l    lbL023200
                    bne      lbC023280
                    move.l   a6,lbL023200
                    move.l   a6,lbL02320C
                    clr.w    lbL023208
                    move.w   #1,lbW02328A
                    rts

lbC023280:          move.w   #0,lbW02328A
                    rts

lbW02328A:          dc.w     0
lbL02328C:          dc.l     0
lbL023290:          dc.l     0
lbL023294:          dc.l     0
lbL023298:          dc.l     0
lbL02329C:          dc.l     0
lbL0232A0:          dc.l     0

lbC0232A4:          lea      lbL02328C,a0
                    move.l   (a0),a6
                    cmp.l    #0,a6
                    beq.s    lbC0232BC
                    clr.l    (a0)
                    bra      lbC02325A

lbC0232BC:          rts

lbC023D20:          move.l   lbL023200,a0
                    cmp.l    #0,a0
                    beq      lbC0232A4
                    addq.w   #1,lbW023204
                    move.w   lbW023204,d0
                    cmp.w    0(a0),d0
                    bmi      lbC0232BC
                    move.w   2(a0),d0
                    move.w   4(a0),d2
                    jsr      trigger_sample_select_channel
                    move.l   lbL023200,a0
                    move.l   6(a0),d0
                    cmp.l    #0,d0
                    beq.s    lbC023D72
                    move.l   d0,lbL023200
                    clr.w    lbW023204
                    rts

lbC023D72:          clr.l    lbL023200
                    clr.w    lbW023204
                    clr.l    lbL02320C
                    clr.l    lbL02328C
                    rts

sample_to_play:     dc.w     0
lbW023D8E:          dc.w     0

trigger_sample:     tst.w    music_enabled
                    bne      lbC0232BC
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.w   sample_to_play,d0
                    cmp.w    #17,d0
                    beq.s    lbC023DD4
                    cmp.w    #18,d0
                    beq.s    lbC023DD4
                    cmp.w    #50,d0
                    bmi.s    lbC023DD8
                    cmp.w    #73,d0
                    bpl.s    lbC023DD8
                    cmp.w    #55,d0
                    beq.s    lbC023DD8
                    cmp.w    #56,d0
                    beq.s    lbC023DD8
lbC023DD4:          moveq    #3,d2
                    bra.s    lbC023DFA

lbC023DD8:          move.w   sample_to_play,d0
                    move.w   lbW023D8E,d2
                    tst.l    lbL023200
                    beq.s    lbC023DFA
                    cmp.w    #2,d2
                    bmi.s    lbC023DFA
                    clr.w    lbW023D8E
                    clr.w    d2
lbC023DFA:          ext.l    d0
                    ext.l    d2
                    bsr      play_sample
                    addq.w   #1,lbW023D8E
                    cmp.w    #2,lbW023D8E
                    bne.s    lbC023E18
                    clr.w    lbW023D8E
lbC023E18:          movem.l  (sp)+,d0-d7/a0-a6
                    rts

trigger_sample_select_channel:
                    tst.w    music_enabled
                    bne      return2
                    cmp.w    #37,d0
                    bne.s    lbC023E3E
                    tst.w    lbW023E9C
                    bne.s    lbC023E9A
                    move.w   #3,lbW023E9C
lbC023E3E:          cmp.w    #3,d2
                    bne.s    lbC023E46
                    moveq    #2,d2
lbC023E46:          cmp.w    #17,d0
                    beq.s    lbC023E76
                    cmp.w    #18,d0
                    beq.s    lbC023E76
                    cmp.w    #50,d0
                    bmi.s    lbC023E78
                    cmp.w    #73,d0
                    bpl.s    lbC023E78
                    cmp.w    #55,d0
                    beq.s    lbC023E78
                    cmp.w    #56,d0
                    beq.s    lbC023E78
lbC023E76:          moveq    #3,d2
lbC023E78:          cmp.w    #2,d2
                    bne.s    lbC023E84
                    move.w   d0,lbW023EA0
lbC023E84:          cmp.w    #3,d2
                    bne.s    lbC023E90
                    move.w   d0,lbW023EA2
lbC023E90:          movem.l  d1/d3-d7/a0-a6,-(sp)
                    bsr.s    play_sample
                    movem.l  (sp)+,d1/d3-d7/a0-a6
lbC023E9A:          rts

lbW023E9C:          dcb.w    2,0
lbW023EA0:          dc.w     0
lbW023EA2:          dc.w     0

; in:
; d0: sample number
; d2: channel
play_sample:        lea      $dff000,a6
                    move.w   d2,d1
                    lea      lbW022C70,a0
                    bsr      switch_sel_channel_off
                    lea      samples_table,a0
                    mulu     #18,d0
                    lea      0(a0,d0.w),a0
                    moveq    #0,d0
                    tst.w    d2
                    beq      lbC023F68
                    subq.w   #1,d2
                    beq      lbC023FF2
                    subq.w   #1,d2
                    beq      lbC02407C
                    move.w   #8,$96(a6)
                    pea      (a0)
                    moveq    #0,d0
                    move.w   4(a0),d0
                    move.l   (a0),a0
                    add.l    d0,d0
                    bsr      lbC022F3A
                    move.l   (sp)+,a0
                    move.w   8(a0),$D6(a6)
                    move.w   6(a0),$D8(a6)
                    move.b   #1,lbB024130
                    move.w   10(a0),d1
                    move.b   d1,lbB024131
                    move.w   12(a0),lbW02413C
                    move.w   6(a0),lbW02413A
                    move.w   8(a0),lbW024138
                    move.l   14(a0),lbL024132
                    move.b   15(a0),lbB024137
                    tst.b    15(a0)
                    bgt.s    lbC023F42
                    neg.b    lbB024137
lbC023F42:          move.b   $11(a0),lbB024136
                    tst.b    $11(a0)
                    bgt.s    lbC023F56
                    neg.b    lbB024136
lbC023F56:          or.w     #$8008,audio_dmacon
                    move.w   #1,bpchannel4_status
                    rts

lbC023F68:          move.w   #1,$96(a6)
                    move.l   (a0),$A0(a6)
                    move.w   4(a0),$A4(a6)
                    move.w   6(a0),$A8(a6)
                    move.w   8(a0),$A6(a6)
                    move.b   #1,lbB024106
                    move.w   10(a0),d1
                    move.b   d1,lbB024107
                    move.w   6(a0),lbW024110
                    move.w   8(a0),lbW02410E
                    move.w   12(a0),lbW024112
                    move.l   14(a0),lbL024108
                    move.b   15(a0),lbB02410D
                    tst.b    15(a0)
                    bgt.b    lbC023FCC
                    neg.b    lbB02410D
lbC023FCC:          move.b   $11(a0),lbB02410C
                    tst.b    $11(a0)
                    bgt.s    lbC023FE0
                    neg.b    lbB02410C
lbC023FE0:          or.w     #$8001,audio_dmacon
                    move.w   #1,bpchannel1_status
                    rts

lbC023FF2:          move.w   #2,$96(a6)
                    move.l   (a0),$B0(a6)
                    move.w   4(a0),$B4(a6)
                    move.w   6(a0),$B8(a6)
                    move.w   8(a0),$B6(a6)
                    move.b   #1,lbB024114
                    move.w   10(a0),d1
                    move.b   d1,lbB024115
                    move.w   6(a0),lbW02411E
                    move.w   8(a0),lbW02411C
                    move.w   12(a0),lbW024120
                    move.l   14(a0),lbL024116
                    move.b   15(a0),lbB02411B
                    tst.b    15(a0)
                    bgt.b    lbC024056
                    neg.b    lbB02411B
lbC024056:          move.b   $11(a0),lbB02411A
                    tst.b    $11(a0)
                    bgt.s    lbC02406A
                    neg.b    lbB02411A
lbC02406A:          or.w     #$8002,audio_dmacon
                    move.w   #1,bpchannel2_status
                    rts

lbC02407C:          move.w   #4,$96(a6)
                    move.l   (a0),$C0(a6)
                    move.w   4(a0),$C4(a6)
                    move.w   6(a0),$C8(a6)
                    move.w   8(a0),$C6(a6)
                    move.b   #1,lbB024122
                    move.w   10(a0),d1
                    move.b   d1,lbB024123
                    move.w   6(a0),lbW02412C
                    move.w   8(a0),lbW02412A
                    move.w   12(a0),lbW02412E
                    move.l   14(a0),lbL024124
                    move.b   15(a0),lbB024129
                    tst.b    15(a0)
                    bgt.b    lbC0240E0
                    neg.b    lbB024129
lbC0240E0:          move.b   $11(a0),lbB024128
                    tst.b    $11(a0)
                    bpl.s    lbC0240F4
                    neg.b    lbB024128
lbC0240F4:          or.w     #$8004,audio_dmacon
                    move.w   #1,bpchannel3_status
                    rts

lbB024106:          dc.b     0
lbB024107:          dc.b     0
lbL024108:          dc.l     0
lbB02410C:          dc.b     0
lbB02410D:          dc.b     0
lbW02410E:          dc.w     0
lbW024110:          dc.w     0
lbW024112:          dc.w     0
lbB024114:          dc.b     0
lbB024115:          dc.b     0
lbL024116:          dc.l     0
lbB02411A:          dc.b     0
lbB02411B:          dc.b     0
lbW02411C:          dc.w     0
lbW02411E:          dc.w     0
lbW024120:          dc.w     0
lbB024122:          dc.b     0
lbB024123:          dc.b     0
lbL024124:          dc.l     0
lbB024128:          dc.b     0
lbB024129:          dc.b     0
lbW02412A:          dc.w     0
lbW02412C:          dc.w     0
lbW02412E:          dc.w     0
lbB024130:          dc.b     0
lbB024131:          dc.b     0
lbL024132:          dc.l     0
lbB024136:          dc.b     0
lbB024137:          dc.b     0
lbW024138:          dc.w     0
lbW02413A:          dc.w     0
lbW02413C:          dcb.w    3,0

lbC024142:          tst.w    music_enabled
                    bne      return2
                    tst.w    lbW0004C4
                    beq      return2
                    lea      lbB024106,a0
                    lea      $dff0a6,a1
                    lea      $dff0a8,a2
                    moveq    #0,d1
                    moveq    #4-1,d7
lbC02416C:          tst.b    (a0)
                    bne.s    lbC024184
lbC024170:          lea      14(a0),a0
                    lea      $10(a1),a1
                    lea      $10(a2),a2
                    addq.w   #1,d1
                    dbf      d7,lbC02416C
                    rts

lbC024184:          tst.b    1(a0)
                    bne.s    lbC024190
                    subq.w   #1,12(a0)
                    beq.s    switch_sel_channel_off
lbC024190:          tst.b    2(a0)
                    beq.s    lbC0241C2
                    tst.b    7(a0)
                    bne.s    lbC0241BE
                    move.b   3(a0),7(a0)
                    tst.b    3(a0)
                    bpl.s    lbC0241B4
                    neg.b    7(a0)
                    sub.w    #$32,8(a0)
                    bra.s    lbC0241BA

lbC0241B4:          add.w    #$32,8(a0)
lbC0241BA:          move.w   8(a0),(a1)
lbC0241BE:          subq.b   #1,7(a0)
lbC0241C2:          tst.b    4(a0)
                    beq.s    lbC024170
                    tst.w    10(a0)
                    ble.s    lbC024170
                    cmp.w    #$40,10(a0)
                    bge.s    lbC024170
                    tst.b    6(a0)
                    bne.s    lbC024204
                    move.b   5(a0),6(a0)
                    tst.b    6(a0)
                    bpl.s    lbC0241FA
                    neg.b    6(a0)
                    sub.w    #8,10(a0)
                    move.w   10(a0),(a2)
                    bra      lbC024170

lbC0241FA:          add.w    #8,10(a0)
                    move.w   10(a0),(a2)
lbC024204:          sub.b    #1,6(a0)
                    bra      lbC024170

switch_sel_channel_off:
                    clr.b    (a0)
                    tst.w    d1
                    beq.s    lbC02423A
                    cmp.b    #1,d1
                    beq.s    lbC02424C
                    cmp.b    #2,d1
                    beq.s    lbC02425E
                    move.w   #0,bpchannel4_status
                    move.w   #8,$dff096
                    move.w   #$400,$dff09a
                    rts

lbC02423A:          move.w   #0,bpchannel1_status
                    move.w   #1,$dff096
                    rts

lbC02424C:          move.w   #0,bpchannel2_status
                    move.w   #2,$dff096
                    rts

lbC02425E:          move.w   #0,bpchannel3_status
                    move.w   #4,$dff096
                    rts

silence:            clr.w    $dff0a8
                    clr.w    $dff0b8
                    clr.w    $dff0c8
                    clr.w    $dff0d8
                    move.w   #15,$dff096
                    rts

bpinit:             lea     samples(pc),a0
                    lea     bpsong,a1
                    clr.b   numtables
                    cmpi.w  #'V.',26(a1)
                    bne.s   bpnotv2
                    cmpi.b  #'2',28(a1)
                    bne.s   bpnotv2
                    move.b  29(a1),numtables
bpnotv2:
                    move.l  #512,d0
                    move.w  30(a1),d1       ; d1 now contains length in steps
                    move.l  #1,d2           ; 1 is highest pattern number
                    mulu    #4,d1           ; 4 voices per step
                    subq.w  #1,d1           ; correction for DBRA
findhighest:
                    cmp.w   (a1,d0),d2      ; Is it higher
                    bge.s   nothigher       ; No
                    move.w  (a1,d0),d2      ; Yes, so let D2 be highest
nothigher:
                    addq.l  #4,d0           ; Next Voice
                    dbf     d1,findhighest  ; And search
                    move.w  30(a1),d1
                    mulu    #16,d1          ; 16 bytes per step
                    move.l  #512,d0         ; header is 512 bytes
                    mulu    #48,d2          ; 48 bytes per pattern
                    add.l   d2,d0
                    add.l   d1,d0           ; offset for samples
                    
                    add.l   #bpsong,d0
                    move.l  d0,tables
                    clr.l   d1
                    move.b  numtables,d1    ; Number of tables
                    lsl.l   #6,d1           ; x 64
                    add.l   d1,d0
                    move.l  #14,d1          ; 15 samples
                    add.l   #32,a1
initloop:
                    move.l  d0,(a0)+
                    cmpi.b  #$ff,(a1)
                    beq.s   bpissynth
                    move.w  24(a1),d2
                    mulu    #2,d2           ; Length is in words
                    add.l   d2,d0           ; offset next sample
bpissynth:
                    add.l   #32,a1          ; Length of Sample Part in header
                    dbf     d1,initloop
                    rts

bpresetbuffer:      moveq    #3,d7
                    lea      bpbuffer(pc),a0
lbC02433E:          tst.l    (a0)
                    beq.s    lbC024352
                    move.l   a0,a2
                    move.l   (a2),a1
                    clr.l    (a2)+
                    moveq    #7,d6
lbC02434A:          move.l   (a2),(a1)+
                    clr.l    (a2)+
                    dbf      d6,lbC02434A
lbC024352:          add.l    #$24,a0
                    dbf      d7,lbC02433E
                    rts

bpmusic:            tst.w    lbW0003A2
                    beq      return2
                    tst.w    lbW0004C4
                    beq      return2
                    bsr      bpsynth
                    subq.b   #1,arpcount
                    moveq    #3,d0
                    lea      bpcurrent,a0
                    move.l   #$dff0a0,a1
bloop1:             cmp.l    #$dff0a0,a1
                    beq      lbC024458
                    cmp.l    #$dff0b0,a1
                    beq      lbC024472
                    cmp.l    #$dff0c0,a1
                    beq      lbC02448C
                    cmp.l    #$dff0d0,a1
                    beq      lbC0244A6
bploop1_channels:   move.b   12(a0),d4
                    ext.w    d4
                    add.w    d4,(a0)
                    tst.b    $1E(a0)
                    bne.s    bpnovibr
                    move.w   (a0),6(a1)
bpnovibr:           move.l   4(a0),(a1)
                    move.w   8(a0),4(a1)
                    tst.b    11(a0)
                    bne.s    bpdoarp
                    tst.b    13(a0)
                    beq.s    not2
bpdoarp:            tst.b    arpcount
                    bne.s    lbC024402
                    move.b   11(a0),d3
                    move.b   13(a0),d4
                    and.w    #$F0,d4
                    and.w    #$F0,d3
                    lsr.w    #4,d3
                    lsr.w    #4,d4
                    add.w    d3,d4
                    add.b    10(a0),d4
                    bsr      bpplayarp
                    bra.s    not2

lbC024402:          cmp.b    #1,arpcount
                    bne.s    not1
                    move.b   11(a0),d3
                    move.b   13(a0),d4
                    and.w    #15,d3
                    and.w    #15,d4
                    add.w    d3,d4
                    add.b    10(a0),d4
                    bsr      bpplayarp
                    bra.s    not2

not1:               move.b   10(a0),d4
                    bsr      bpplayarp
not2:               lea      $10(a1),a1
                    lea      $20(a0),a0
                    dbf      d0,bloop1
lbC02443C:          tst.b    arpcount
                    bne.s    lbC02444C
                    move.b   #3,arpcount

lbC02444C:          subq.b   #1,bpcount
                    beq      bpskip1
                    rts

lbC024458:          tst.w    bpchannel1_status
                    beq.s    lbC02446E
                    lea      $10(a1),a1
                    lea      $20(a0),a0
                    dbf      d0,bloop1
                    rts

lbC02446E:          bra      bploop1_channels

lbC024472:          tst.w    bpchannel2_status
                    beq.s    lbC024488
                    lea      $10(a1),a1
                    lea      $20(a0),a0
                    dbf      d0,bloop1
                    rts

lbC024488:          bra      bploop1_channels

lbC02448C:          tst.w    bpchannel3_status
                    beq.s    lbC0244A2
                    lea      $10(a1),a1
                    lea      $20(a0),a0
                    dbf      d0,bloop1
                    rts

lbC0244A2:          bra      bploop1_channels

lbC0244A6:          tst.w    bpchannel4_status
                    beq.s    lbC0244BE
                    lea      $10(a1),a1
                    lea      $20(a0),a0
                    dbf      d0,bloop1
                    bra.s    lbC02443C

lbC0244BE:          bra      bploop1_channels

bpskip1:            move.b   bpdelay(pc),bpcount
                    bsr      bpnext
                    move.w   dma(pc),$dff096
                    jsr      lbC00EE2E
                    moveq    #3,d0
                    move.l   #$dff0a0,a1
                    moveq    #1,d1
                    lea      bpcurrent,a2
                    lea      bpbuffer,a5
bploop2:            cmp.l    #$dff0a0,a1
                    beq      lbC02453C
                    cmp.l    #$dff0b0,a1
                    beq      lbC02455C
                    cmp.l    #$dff0c0,a1
                    beq      lbC02457C
                    cmp.l    #$dff0d0,a1
                    beq      lbC02459C
bploop2_channels:   btst     #15,(a2)
                    beq.s    bpskip7
                    bsr      bpplayit
bpskip7:            asl.w    #1,d1
                    lea      $10(a1),a1
                    lea      $20(a2),a2
                    lea      $24(a5),a5
                    dbf      d0,bploop2
                    rts

lbC02453C:          tst.w    bpchannel1_status
                    beq.s    lbC024558
                    asl.w    #1,d1
                    lea      $10(a1),a1
                    lea      $20(a2),a2
                    lea      $24(a5),a5
                    dbf      d0,bploop2
                    rts

lbC024558:          bra      bploop2_channels

lbC02455C:          tst.w    bpchannel2_status
                    beq.s    lbC024578
                    asl.w    #1,d1
                    lea      $10(a1),a1
                    lea      $20(a2),a2
                    lea      $24(a5),a5
                    dbf      d0,bploop2
                    rts

lbC024578:          bra      bploop2_channels

lbC02457C:          tst.w    bpchannel3_status
                    beq.s    lbC024598
                    asl.w    #1,d1
                    lea      $10(a1),a1
                    lea      $20(a2),a2
                    lea      $24(a5),a5
                    dbf      d0,bploop2
                    rts

lbC024598:          bra      bploop2_channels

lbC02459C:          tst.w    bpchannel4_status
                    beq.s    lbC0245B8
                    asl.w    #1,d1
                    lea      $10(a1),a1
                    lea      $20(a2),a2
                    lea      $24(a5),a5
                    dbf      d0,bploop2
                    rts

lbC0245B8:          bra      bploop2_channels

bpnext:             clr.w    dma
                    lea      bpsong,a0
                    lea      bpcurrent,a1
                    move.l   #$dff0a0,a3
                    moveq    #3,d0
                    move.w   #1,d7
bploop3:            cmp.l    #$dff0a0,a3
                    beq      lbC0247D4
                    cmp.l    #$dff0b0,a3
                    beq      lbC0247F0
                    cmp.l    #$dff0c0,a3
                    beq      lbC02480C
                    cmp.l    #$dff0d0,a3
                    beq      lbC024828
bploop3_next:       moveq    #0,d1
                    move.w   bpstep,d1
                    lsl.w    #4,d1
                    move.l   d0,d2
                    lsl.l    #2,d2
                    add.l    d2,d1
                    add.l    #$200,d1
                    move.w   0(a0,d1.l),d2
                    move.b   2(a0,d1.l),st
                    move.b   3(a0,d1.l),tr
                    subq.w   #1,d2
                    mulu     #$30,d2
                    moveq    #0,d3
                    move.w   $1E(a0),d3
                    lsl.w    #4,d3
                    add.l    d2,d3
                    move.l   #$200,d4
                    move.b   bppatcount(pc),d4
                    add.l    d3,d4
                    move.l   d4,a2
                    add.l    a0,a2
                    moveq    #0,d3
                    move.b   (a2),d3
                    bne.s    bpskip4
                    bra      bpoptionals

bpskip4:            clr.w    12(a1)
                    move.b   1(a2),d4
                    and.b    #15,d4
                    cmp.b    #10,d4
                    bne.s    bp_do1
                    move.b   2(a2),d4
                    and.b    #$F0,d4
                    bne.s    bp_not1
bp_do1:             add.b    tr,d3
                    ext.w    d3
bp_not1:            move.b   d3,10(a1)
                    lea      bpper,a4
                    add.w    d3,d3
                    move.w   -2(a4,d3.w),(a1)
                    bset     #15,(a1)
                    move.b   #$FF,2(a1)
                    clr.w    d3
                    move.b   1(a2),d3
                    lsr.b    #4,d3
                    and.b    #15,d3
                    tst.b    d3
                    bne.s    bpskip5
                    move.b   3(a1),d3
bpskip5:            move.b   1(a2),d4
                    and.b    #15,d4
                    cmp.b    #10,d4
                    bne.s    bp_do2
                    move.b   2(a2),d4
                    and.b    #15,d4
                    bne.s    bp_not2
bp_do2:             add.b    st,d3
bp_not2:            cmp.w    #1,8(a1)
                    beq.s    bpsamplechange
                    cmp.b    3(a1),d3
                    beq.s    bpoptionals
bpsamplechange:     move.b   d3,3(a1)
                    or.w     d7,dma

bpoptionals:        moveq    #0,d3
                    moveq    #0,d4
                    move.b   1(a2),d3
                    and.b    #15,d3
                    move.b   2(a2),d4
                    tst.b    d3
                    bne.s    notopt0
                    move.b   d4,11(a1)
                    bra      notopt9

notopt0:            cmp.b    #1,d3
                    bne.s    bpskip3
                    move.w   d4,8(a3)
                    move.b   d4,2(a1)
                    bra      notopt9

bpskip3:            cmp.b    #2,d3
                    bne.s    bpskip9
                    and.b    #15,d4
                    cmp.b    #4,d4
                    blt.s    notopt9
                    move.b   d4,bpcount
                    move.b   d4,bpdelay
                    bra.s    notopt9

bpskip9:            cmp.b    #3,d3
                    bne.s    bpskipa
                    bra.s    notopt9

bpskipa:            cmp.b    #4,d3
                    bne.s    noportup
                    sub.w    d4,(a1)
                    clr.b    11(a1)
                    bra.s    notopt9

noportup:           cmp.b    #5,d3
                    bne.s    noportdn
                    add.w    d4,(a1)
                    clr.b    11(a1)
                    bra.s    notopt9

noportdn:           cmp.b    #6,d3
                    bne.s    notopt6
                    move.b   d4,bprepcount
                    bra.s    notopt9

notopt6:            cmp.b    #7,d3
                    bne.s    notopt7
                    subq.b   #1,bprepcount
                    beq.s    notopt9
                    move.w   d4,bpstep
                    bra.s    notopt9

notopt7:            cmp.b    #8,d3
                    bne.s    notopt8
                    move.b   d4,12(a1)
                    bra.s    notopt9

notopt8:            cmp.b    #9,d3
                    bne.s    notopt9
                    move.b   d4,13(a1)
notopt9:            lea      $10(a3),a3
                    lea      $20(a1),a1
                    asl.w    #1,d7
                    dbf      d0,bploop3
lbC02479E:          addq.b   #3,bppatcount
                    cmp.b    #$30,bppatcount
                    bne.s    bpskip8
                    clr.b    bppatcount
                    addq.w   #1,bpstep
                    lea      bpsong,a0
                    move.w   $1E(a0),d1
                    cmp.w    bpstep(pc),d1
                    bne.s    bpskip8
                    clr.w    bpstep
bpskip8:            rts

lbC0247D4:          tst.w    bpchannel1_status
                    beq.s    lbC0247EC
                    lea      $10(a3),a3
                    lea      $20(a1),a1
                    asl.w    #1,d7
                    dbf      d0,bploop3
                    rts

lbC0247EC:          bra      bploop3_next

lbC0247F0:          tst.w    bpchannel2_status
                    beq.s    lbC024808
                    lea      $10(a3),a3
                    lea      $20(a1),a1
                    asl.w    #1,d7
                    dbf      d0,bploop3
                    rts

lbC024808:          bra      bploop3_next

lbC02480C:          tst.w    bpchannel3_status
                    beq.s    lbC024824
                    lea      $10(a3),a3
                    lea      $20(a1),a1
                    asl.w    #1,d7
                    dbf      d0,bploop3
                    rts

lbC024824:          bra      bploop3_next

lbC024828:          tst.w    bpchannel4_status
                    beq.s    lbC024842
                    lea      $10(a3),a3
                    lea      $20(a1),a1
                    asl.w    #1,d7
                    dbf      d0,bploop3
                    bra      lbC02479E

lbC024842:          bra      bploop3_next

bpplayit:           bclr     #15,(a2)
                    tst.l    (a5)
                    beq.s    lbC02485E
                    clr.w    d3
                    move.l   (a5),a4
                    moveq    #8-1,d7
lbC024854:          move.l   4(a5,d3.w),(a4)+
                    addq.w   #4,d3
                    dbf      d7,lbC024854
lbC02485E:          move.w   (a2),6(a1)
                    moveq    #0,d7
                    move.b   3(a2),d7
                    move.l   d7,d6
                    lsl.l    #5,d7
                    lea      bpsong,a3
                    cmp.b    #$FF,0(a3,d7.w)
                    beq      bpplaysynthetic
                    clr.l    (a5)
                    clr.b    $1A(a2)
                    clr.w    $1E(a2)
                    add.l    #$18,d7
                    lsl.l    #2,d6
                    lea      samples(pc),a4
                    move.l   -4(a4,d6.l),d4
                    beq.s    bp_nosamp
                    move.l   d4,(a1)
                    move.w   0(a3,d7.l),4(a1)
                    move.b   2(a2),9(a1)
                    cmp.b    #$FF,2(a2)
                    bne.s    skipxx
                    move.w   6(a3,d7.l),8(a1)
skipxx:             move.w   4(a3,d7.l),8(a2)
                    moveq    #0,d6
                    move.w   2(a3,d7.l),d6
                    add.l    d6,d4
                    move.l   d4,4(a2)
                    cmp.w    #1,8(a2)
                    bne.s    bpskip6
bp_nosamp:          move.l   #lbL098E0C,4(a2)
                    bra.s    bpskip10

bpskip6:            move.w   8(a2),4(a1)
                    move.l   4(a2),(a1)
bpskip10:           add.w    #$8000,d1
                    move.w   d1,$dff096
                    rts

bpplaysynthetic:    move.b   #1,$1A(a2)
                    clr.w    14(a2)
                    clr.w    $10(a2)
                    clr.w    $12(a2)
                    move.w   $16(a3,d7.w),$14(a2)
                    addq.w   #1,$14(a2)
                    move.w   14(a3,d7.w),$16(a2)
                    addq.w   #1,$16(a2)
                    move.w   #1,$18(a2)
                    move.b   $11(a3,d7.w),$1D(a2)
                    move.b   9(a3,d7.w),$1E(a2)
                    move.b   4(a3,d7.w),$1F(a2)
                    move.b   $13(a3,d7.w),$1C(a2)
                    move.l   tables(pc),a4
                    clr.l    d3
                    move.b   1(a3,d7.w),d3
                    lsl.l    #6,d3
                    add.l    d3,a4
                    move.l   a4,(a1)
                    move.l   a4,4(a2)
                    move.w   2(a3,d7.w),4(a1)
                    move.w   2(a3,d7.w),8(a2)
                    tst.b    4(a3,d7.w)
                    beq.s    bpadsroff
                    move.l   tables(pc),a4
                    clr.l    d3
                    move.b   5(a3,d7.w),d3
                    lsl.l    #6,d3
                    add.l    d3,a4
                    clr.w    d3
                    move.b   (a4),d3
                    add.b    #$80,d3
                    lsr.w    #2,d3
                    cmp.b    #$FF,2(a2)
                    bne.s    bpskip99
                    move.b   $19(a3,d7.w),2(a2)
bpskip99:           clr.w    d4
                    move.b   2(a2),d4
                    mulu     d4,d3
                    lsr.w    #6,d3
                    move.w   d3,8(a1)
                    bra.s    bpflipper

bpadsroff:          moveq    #0,d3
                    move.b   2(a2),d3
                    cmp.b    #$FF,2(a2)
                    bne.s    bpflipper
                    moveq    #0,d3
                    move.b   $19(a3,d7.w),d3
bpflipper:          move.w   d3,8(a1)
                    move.l   4(a2),a4
                    move.l   a4,(a5)
                    clr.w    d3
                    moveq    #7,d4
eg2loop:            move.l   0(a4,d3.w),4(a5,d3.w)
                    addq.w   #4,d3
                    dbf      d4,eg2loop
                    tst.b    $11(a3,d7.w)
                    beq      bpskip10
                    tst.b    $13(a3,d7.w)
                    beq      bpskip10
                    clr.l    d3
                    move.b   $13(a3,d7.w),d3
                    lsr.l    #3,d3
                    move.b   d3,$1C(a2)
                    subq.l   #1,d3
eg3loop:            neg.b    (a4)+
                    dbf      d3,eg3loop
                    bra      bpskip10

bpplayarp:          lea      bpper(pc),a4
                    ext.w    d4
                    asl.w    #1,d4
                    move.w   -2(a4,d4.w),6(a1)
                    rts

bpsynth:            moveq    #3,d0
                    lea      $dff0a0,a1
                    lea      bpcurrent,a2
                    lea      bpsong,a3
                    lea      bpbuffer,a5
bpsynthloop:        cmp.l    #$dff0a0,a1
                    beq.s    lbC024A52
                    cmp.l    #$dff0b0,a1
                    beq.s    lbC024A70
                    cmp.l    #$dff0c0,a1
                    beq.s    lbC024A8E
                    cmp.l    #$dff0d0,a1
                    beq.s    lbC024AAC
lbC024A36:          tst.b    $1A(a2)
                    beq.s    bpnosynth
                    bsr      bpyessynth
bpnosynth:          lea      36(a5),a5
                    lea      32(a2),a2
                    lea      16(a1),a1
                    dbf      d0,bpsynthloop
                    rts

lbC024A52:          tst.w    bpchannel1_status
                    beq.s    lbC024A6C
                    lea      36(a5),a5
                    lea      32(a2),a2
                    lea      16(a1),a1
                    dbf      d0,bpsynthloop
                    rts

lbC024A6C:          bra      lbC024A36

lbC024A70:          tst.w    bpchannel2_status
                    beq.s    lbC024A8A
                    lea      36(a5),a5
                    lea      32(a2),a2
                    lea      16(a1),a1
                    dbf      d0,bpsynthloop
                    rts

lbC024A8A:          bra      lbC024A36

lbC024A8E:          tst.w    bpchannel3_status
                    beq.s    lbC024AA8
                    lea      36(a5),a5
                    lea      32(a2),a2
                    lea      16(a1),a1
                    dbf      d0,bpsynthloop
                    rts

lbC024AA8:          bra      lbC024A36

lbC024AAC:          tst.w    bpchannel4_status
                    beq.s    lbC024AC6
                    lea      36(a5),a5
                    lea      32(a2),a2
                    lea      16(a1),a1
                    dbf      d0,bpsynthloop
                    rts

lbC024AC6:          bra      lbC024A36

bpyessynth:         clr.w    d7
                    move.b   3(a2),d7
                    lsl.w    #5,d7
                    tst.b    $1F(a2)
                    beq.s    bpendadsr
                    subq.w   #1,$18(a2)
                    bne.s    bpendadsr
                    moveq    #0,d3
                    move.b   8(a3,d7.w),d3
                    move.w   d3,$18(a2)
                    move.l   tables,a4
                    move.b   5(a3,d7.w),d3
                    lsl.l    #6,d3
                    add.l    d3,a4
                    move.w   $12(a2),d3
                    clr.w    d4
                    move.b   0(a4,d3.w),d4
                    add.b    #$80,d4
                    lsr.w    #2,d4
                    clr.w    d3
                    move.b   2(a2),d3
                    mulu     d3,d4
                    lsr.w    #6,d4
                    move.w   d4,8(a1)
                    addq.w   #1,$12(a2)
                    move.w   6(a3,d7.w),d4
                    cmp.w    $12(a2),d4
                    bne.s    bpendadsr
                    clr.w    $12(a2)
                    cmp.b    #1,$1F(a2)
                    bne.s    bpendadsr
                    clr.b    $1F(a2)
bpendadsr:          tst.b    $1E(a2)
                    beq.s    bpendlfo
                    subq.w   #1,$16(a2)
                    bne.s    bpendlfo
                    moveq    #0,d3
                    move.b   $10(a3,d7.w),d3
                    move.w   d3,$16(a2)
                    move.l   tables,a4
                    move.b   10(a3,d7.w),d3
                    lsl.l    #6,d3
                    add.l    d3,a4
                    move.w   $10(a2),d3
                    move.b   0(a4,d3.w),d4
                    ext.w    d4
                    ext.l    d4
                    moveq    #0,d5
                    move.b   11(a3,d7.w),d5
                    beq.s    bpnotx
                    divs     d5,d4
bpnotx:             move.w   (a2),d5
                    add.w    d4,d5
                    move.w   d5,6(a1)
                    addq.w   #1,$10(a2)
                    move.w   12(a3,d7.w),d3
                    cmp.w    $10(a2),d3
                    bne.s    bpendlfo
                    clr.w    $10(a2)
                    cmp.b    #1,$1E(a2)
                    bne.s    bpendlfo
                    clr.b    $1E(a2)
bpendlfo:           tst.b    $1D(a2)
                    beq      bpendeg
                    subq.w   #1,$14(a2)
                    bne.s    bpendeg
                    tst.l    (a5)
                    beq.s    bpendeg
                    moveq    #0,d3
                    move.b   $18(a3,d7.w),d3
                    move.w   d3,$14(a2)
                    move.l   tables,a4
                    move.b   $12(a3,d7.w),d3
                    lsl.l    #6,d3
                    add.l    d3,a4
                    move.w   14(a2),d3
                    moveq    #0,d4
                    move.b   0(a4,d3.w),d4
                    move.l   (a5),a4
                    add.b    #$80,d4
                    lsr.l    #3,d4
                    moveq    #0,d3
                    move.b   $1C(a2),d3
                    move.b   d4,$1C(a2)
                    add.l    d3,a4
                    move.l   a5,a6
                    add.l    d3,a6
                    addq.l   #4,a6
                    cmp.b    d3,d4
                    beq.s    bpnexteg
                    bgt.s    bpishigh
                    sub.l    d4,d3
                    subq.w   #1,d3
bpegloop1a:         move.b   -(a6),-(a4)
                    dbf      d3,bpegloop1a
                    bra.s    bpnexteg

bpishigh:           sub.l    d3,d4
                    subq.w   #1,d4
bpegloop1b:         move.b   (a6)+,d3
                    neg.b    d3
                    move.b   d3,(a4)+
                    dbf      d4,bpegloop1b
bpnexteg:           addq.w   #1,14(a2)
                    move.w   $14(a3,d7.w),d3
                    cmp.w    14(a2),d3
                    bne.s    bpendeg
                    clr.w    14(a2)
                    cmp.b    #1,$1D(a2)
                    bne.s    bpendeg
                    clr.b    $1D(a2)
bpendeg:            rts

bpcurrent:          dc.w     0,0            ; period,instrument =(volume.b,instr nr.b)
                    dc.l     lbL098E0C      ; start
                    dc.w     1              ; length (words)
                    dc.b     0,0,0,0        ; noot,arpeggio,autoslide,autoarpeggio
                    dc.w     0,0,0          ; EG,LFO,ADSR pointers
                    dc.w     0,0,0          ; EG,LFO,ADSR count
                    dc.b     0,0            ; Synthetic yes/no, Volume Slide
                    dc.b     0,0            ; Current EG value,EG OOC
                    dc.b     0,0            ; LFO OOC,ADSR OOC
                    
                    dc.w     0,0
                    dc.l     lbL098E0C
                    dc.w     1,0,0
                    dc.w     0,0,0,0,0,0,0,0,0
                    
                    dc.w     0,0
                    dc.l     lbL098E0C
                    dc.w     1,0,0
                    dc.w     0,0,0,0,0,0,0,0,0
                    
                    dc.w     0,0
                    dc.l     lbL098E0C
                    dc.w     1,0,0
                    dc.w     0,0,0,0,0,0,0,0,0

bpreset:            dc.l     0
                    dc.l     lbL098E0C,$10000,0,0,0,0,0,0
                    dc.l     lbL098E0C,$10000,0,0,0,0,0,0
                    dc.l     lbL098E0C,$10000,0,0,0,0,0,0
                    dc.l     lbL098E0C,$10000,0,0,0,0,0
dma:                dc.w     0
bpstep:             dc.w     0
bppatcount:         dc.b     0
st:                 dc.b     0
tr:                 dc.b     0
bpcount:            dc.b     1
bpdelay:            dc.b     6
arpcount:           dc.b     1
bprepcount:         dc.b     1
numtables:          dc.b     0
tables:             dc.l     0
bpbuffer:           dcb.b    144,0
                    dc.w     $1AC0,$1940,$17C0,$1680,$1540,$1400,$12E0,$11E0
                    dc.w     $10E0,$FE0,$F00,$E20,$D60,$CA0,$BE0,$B40,$AA0
                    dc.w     $A00,$970,$8F0,$870,$7F0,$780,$710,$6B0,$650,$5F0
                    dc.w     $5A0,$550,$500,$4B8,$478,$438,$3F8,$3C0,$388
bpper:              dc.w     $358,$328,$2F8,$2D0,$2A8,$280,$25C,$23C,$21C,$1FC
                    dc.w     $1E0,$1C4,$1AC,$194,$17C,$168,$154,$140,$12E,$11E
                    dc.w     $10E,$FE,$F0,$E2,$D6,$CA,$BE,$B4,$AA,$A0,$97,$8F
                    dc.w     $87,$7F,$78,$71,$6B,$65,$5F,$5A,$55,$50,$4C,$48
                    dc.w     $44,$40,$3C,$39
samples:            dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0
                    dc.l     0

samples_table:      dc.l     sample1                            ; 0
                    dc.w     2437,62,428,0,28,0,0
                    dc.l     sample1
                    dc.w     2437,32,428,0,10,257,508
                    dc.l     sample2
                    dc.w     4150,32,284,0,31,0,0
                    dc.l     sample3
                    dc.w     4150,32,284,0,8,0,0
                    dc.l     sample4
                    dc.w     3894,64,284,0,30,0,0
                    dc.l     sample5
                    dc.w     3894,16,284,0,15,0,0
                    dc.l     sample6
                    dc.w     1249,48,120,0,29,257,508
                    dc.l     sample6
                    dc.w     1249,16,120,0,10,257,508
                    dc.l     sample6
                    dc.w     1249,32,140,0,40,0,508
                    dc.l     sample6
                    dc.w     1249,62,1400,0,38,0,508
                    dc.l     sample7                            ; 10
                    dc.w     2591,64,428,0,30,0,0
                    dc.l     sample7
                    dc.w     2591,64,856,0,60,0,0
                    dc.l     sample9
                    dc.w     1000,63,1400,0,150,272,494
                    dc.l     sample8
                    dc.w     1515,64,856,0,36,0,0
                    dc.l     sample10                           ; 14
                    dc.w     328,48,428,0,4,0,0
                    dc.l     sample11
                    dc.w     1949,24,428,1,10,0,0
                    dc.l     sample11
                    dc.w     1949,16,428,1,10,0,260
                    dc.l     voice_warning                      ; 17
                    dc.w     2727,64,428,0,33,0,0 
                    dc.l     voice_destruction_imminent
                    dc.w     6751,64,428,0,80,0,0
                    dc.l     sample12
                    dc.w     500,32,540,0,30,0,508
                    dc.l     sample13                           ; 20
                    dc.w     2380,64,428,0,27,0,0
                    dc.l     sample13
                    dc.w     2380,59,300,0,40,0,508
                    dc.l     sample14
                    dc.w     767,32,480,0,35,0,506
                    dc.l     sample15
                    dc.w     2420,64,480,0,31,0,0
                    dc.l     sample16
                    dc.w     2302,64,480,0,32,0,0
                    dc.l     sample26                           ; 25
                    dc.w     1812,32,1000,1,28,0,0
                    dc.l     sample26
                    dc.w     1812,32,1000,0,40,260,508
                    dc.l     sample11
                    dc.w     1812,60,200,0,40,0,508
                    dc.l     sample7
                    dc.w     1357,16,900,0,12,0,506
                    dc.l     sample6
                    dc.w     1357,22,2000,0,15,0,506
                    dc.l     sample25                           ; 30
                    dc.w     1143,62,180,0,15,0,511
                    dc.l     sample25
                    dc.w     1143,62,280,0,15,0,511
                    dc.l     sample18
                    dc.w     2,62,400,0,16,508,511
                    dc.l     sample19
                    dc.w     726,32,480,0,10,0,0
                    dc.l     sample20
                    dc.w     726,64,428,0,6,0,0
                    dc.l     sample27                           ; 35
                    dc.w     1246,62,900,0,50,0,506
                    dc.l     sample28
                    dc.w     4000,62,568,0,30,0,0
                    dc.l     sample21                           ; 37
                    dc.w     560,64,360,0,5,0,0
                    dc.l     sample10
                    dc.w     328,62,1200,0,8,0,0
                    dc.l     sample9
                    dc.w     1000,8,1400,1,26,0,0
                    dc.l     sample9                            ; 40
                    dc.w     1000,8,1000,0,10,0,508
                    dc.l     sample22
                    dc.w     727,40,1000,1,10,0,0
                    dc.l     sample24
                    dc.w     2206,37,1000,0,61,0,0
                    dc.l     sample2
                    dc.w     4150,32,202,0,22,0,0
                    dc.l     sample3
                    dc.w     4150,16,202,0,18,0,0
                    dc.l     sample23                           ; 45
                    dc.w     128,44,190,0,38,257,508
                    dc.l     sample23
                    dc.w     128,16,280,0,28,257,508
                    dc.l     sample17
                    dc.w     1000,32,480,0,10,0,0
                    dc.l     sample10
                    dc.w     328,16,428,0,4,0,0
                    dc.l     sample10
                    dc.w     328,16,600,0,4,0,0
                    dc.l     voice_entering                     ; 50
                    dc.w     3005,32,404,0,33,0,0
                    dc.l     voice_zone
                    dc.w     1713,32,404,0,20,0,0
                    dc.l     voice_welcome_to
                    dc.w     3000,64,400,0,33,0,0
                    dc.l     voice_intex_systems
                    dc.w     4518,42,480,0,60,0,0
                    dc.l     voice_death
                    dc.w     2796,32,470,0,18,0,0
                    dc.l     sample29                           ; 55
                    dc.w     2081,4,1000,0,57,0,260
                    dc.l     sample29
                    dc.w     2081,62,690,0,40,0,504
                    dc.l     voice_players
                    dc.w     1897,32,440,0,25,0,0
                    dc.l     voice_requires
                    dc.w     2880,32,390,0,31,0,0
                    dc.l     voice_ammo
                    dc.w     1754,32,440,0,21,0,0
                    dc.l     voice_first_aid                    ; 60
                    dc.w     3375,32,450,0,43,0,0
                    dc.l     voice_danger
                    dc.w     2200,64,480,0,28,0,0
                    dc.l     voice_insert_disk
                    dc.w     3562,32,440,0,44,0,0
                    dc.l     voice_keys
                    dc.w     2138,32,440,0,24,0,0
                    dc.l     voice_game_over
                    dc.w     3132,64,428,0,36,0,0
                    dc.l     voice_one                          ; 65
                    dc.w     1635,32,400,0,18,0,0
                    dc.l     voice_two
                    dc.w     1921,32,380,0,20,0,0
                    dc.l     voice_three
                    dc.w     2170,32,380,0,20,0,0
                    dc.l     voice_four
                    dc.w     2002,32,380,0,20,0,0
                    dc.l     voice_five
                    dc.w     2340,32,380,0,24,0,0
                    dc.l     voice_six                          ; 70
                    dc.w     2128,32,380,0,20,0,0
                    dc.l     voice_seven
                    dc.w     2345,32,380,0,24,0,0
                    dc.l     voice_eight
                    dc.w     1960,32,380,0,20,0,0
                    dc.l     sample30
                    dc.w     1487,64,600,0,25,0,0
                    dc.l     sample31
                    dc.w     1509,16,500,1,0,0,0
                    dc.l     sample31                           ; 75 
                    dc.w     1509,16,500,0,0,0,510
                    dc.l     empty_sample                       ; 76
                    dc.w     8,1,428,0,0,0,0

not_an_exe:         moveq    #-1,d0
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

reloc_exe:          movem.l  d0-d7/a0-a6,-(sp)
                    move.l   a1,a4
                    move.l   a1,a3
                    move.l   (a0)+,d0
                    cmp.l    #$3F3,d0
                    bne      not_an_exe
lbC0255B0:          move.l   (a0)+,d0
                    beq.s    lbC0255BC
                    add.l    d0,d0
                    add.l    d0,d0
                    add.l    d0,a0
                    bra.s    lbC0255B0

lbC0255BC:          move.l   (a0)+,d7
                    move.l   d7,d6
                    lsl.l    #3,d7
                    sub.l    d7,sp
                    addq.w   #8,a0
                    move.l   sp,a1
                    move.l   sp,a5
lbC0255CA:          move.l   (a0)+,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    move.l   d0,(a1)+
                    move.l   a3,(a1)+
                    add.l    d0,a3
                    subq.l   #1,d6
                    bne.s    lbC0255CA
                    move.l   d7,d6
lbC0255DC:          move.l   (a0)+,d0
                    move.l   d0,d1
                    sub.l    #$3E7,d1
                    add.l    d1,d1
                    add.l    d1,d1
                    jsr      lbC0255F4(pc,d1.w)
                    bne.s    lbC0255DC
                    bra      relocated_exe

lbC0255F4:          bra.w    lbC025624
                    bra.w    lbC025624
                    bra.w    lbC025634
                    bra.w    lbC025634
                    bra.w    lbC025652
                    bra.w    lbC025662
                    bra.w    lbC025630
                    bra.w    lbC025630
                    bra.w    lbC025630
                    bra.w    lbC025630
                    bra.w    lbC025630
                    bra.w    lbC025682

lbC025624:          move.l   (a0)+,d0
                    add.l    d0,d0
                    add.l    d0,d0
                    add.l    d0,a0
                    moveq    #1,d0
                    rts

lbC025630:          moveq    #0,d0
                    rts

lbC025634:          move.l   (a0)+,d0
                    move.l   (a5),d1
                    move.l   4(a5),a6
lbC02563C:          move.l   (a0)+,(a6)+
                    subq.l   #4,d1
                    subq.l   #1,d0
                    bne.s    lbC02563C
                    tst.l    d1
                    beq.s    lbC02564E
lbC025648:          clr.l    (a6)+
                    subq.l   #4,d1
                    bne.s    lbC025648
lbC02564E:          moveq    #1,d0
                    rts

lbC025652:          move.l   (a0)+,d0
                    move.l   4(a5),a6
lbC025658:          clr.l    (a6)+
                    subq.l   #1,d0
                    bne.s    lbC025658
                    moveq    #1,d0
                    rts

lbC025662:          move.l   (a0)+,d0
                    beq.s    lbC02567E
                    move.l   (a0)+,d1
                    lsl.l    #3,d1
                    move.l   8(sp,d1.l),d3
                    move.l   4(a5),a6
lbC025672:          move.l   (a0)+,d2
                    add.l    d3,0(a6,d2.l)
                    subq.l   #1,d0
                    bne.s    lbC025672
                    bra.s    lbC025662

lbC02567E:          moveq    #1,d0
                    rts

lbC025682:          addq.w   #8,a5
                    subq.l   #8,d6
                    rts

relocated_exe:      add.l    d7,sp
                    moveq    #0,d0
                    move.l   4.w,a6
                    jsr      _LVOCacheClearU(a6)
                    moveq    #0,d0
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

lbW0256B4:          dc.w     $4F,0,$56,1,$5E,2,$65,5,$6B,7,$72,11,$78,15,$7E
                    dc.w     $14,$84,$1A
lbW0256D8:          dc.w     $88,$20,$8C,$26,$90,$2D,$92,$34,$94,$3B,$96,$43
                    dc.w     $96,$4B,$96,$53,$94,$5B
lbW0256FC:          dc.w     $92,$62,$90,$69,$8D,$6F,$88,$76,$84,$7C,$7F,$81
                    dc.w     $79,$86,$72,$8B,$6C
                    dc.w     $8E
lbW025720:          dc.w     $65,$91,$5E,$94,$56,$95,$4F,$96,$47,$96,$3F,$95
                    dc.w     $38,$94,$31,$91,$2A,$8E
lbW025744:          dc.w     $24,$8B,$1D,$86,$18,$82,$12,$7C,14,$76,9,$6F,6
                    dc.w     $69,4,$62,2,$5A
lbW025768:          dc.w     0,$53,0,$4B,0,$43,2,$3C,3,$35,6,$2E,9,$27,13,$21
                    dc.w     $11,$1B
lbW02578C:          dc.w     $17,$15,$1D,$10,$23,12,$2A,8,$31,5,$38,2,$3F,1
                    dc.w     $47,0
                    dc.w     $FFFF,$FFFF

                    dcb.w    4*124,0
cur_map_top:        dcb.w    3*124,0
cur_map_datas:      dcb.w    124*98,0
end_map_datas:      dcb.w    124*4,0

                    incdir   "src/main/voices/"
voice_warning:      incbin   "warning.raw"
voice_destruction_imminent:
                    incbin   "destruction_imminent.raw"
voice_entering:     incbin   "entering.raw"
voice_zone:         incbin   "zone.raw"
voice_welcome_to:   incbin   "welcome_to.raw"
voice_intex_systems:
                    incbin   "intex_systems.raw"
voice_death:        incbin   "death.raw"
voice_players:      incbin   "player.raw"
voice_requires:     incbin   "requires.raw"
voice_ammo:         incbin   "ammo.raw"
voice_first_aid:    incbin   "first_aid.raw"
voice_danger:       incbin   "danger.raw"
voice_insert_disk:  incbin   "insert_disk.raw"
voice_keys:         incbin   "keys.raw"
voice_game_over:    incbin   "game_over.raw"
voice_one:          incbin   "one.raw"
voice_two:          incbin   "two.raw"
voice_three:        incbin   "three.raw"
voice_four:         incbin   "four.raw"
voice_five:         incbin   "five.raw"
voice_six:          incbin   "six.raw"
voice_seven:        incbin   "seven.raw"
voice_eight:        incbin   "eight.raw"

                    SECTION  AB08488C,BSS

bkgnd_tiles_block:  ds.b     76800

                    SECTION  AB09748C,DATA_c

                    incdir   "src/main/gfx/"
font_pic:           incbin   "font_16x504x5.raw"

letter_buffer:      dcb.b    128,0

                    incdir   "src/main/sprites/"
timer_digit_0:      incbin   "timer_digit_0.raw"
timer_digit_1:      incbin   "timer_digit_1.raw"
timer_digit_2:      incbin   "timer_digit_2.raw"
timer_digit_3:      incbin   "timer_digit_3.raw"
timer_digit_4:      incbin   "timer_digit_4.raw"
timer_digit_5:      incbin   "timer_digit_5.raw"
timer_digit_6:      incbin   "timer_digit_6.raw"
timer_digit_7:      incbin   "timer_digit_7.raw"
timer_digit_8:      incbin   "timer_digit_8.raw"
timer_digit_9:      incbin   "timer_digit_9.raw"

lbL098E0C:          dcb.l    8,0
lbL098E2C:          dcb.l    150,0

                    incdir   "src/main/gfx/"
player_1_status_pic:
                    incbin   "player_1_status_304x8x2.raw"
player_2_status_pic:
                    incbin   "player_2_status_304x8x2.raw"

player_1_status_bar:
                    dcb.b    37,0
lbB099569:          dcb.b    571,0
player_2_status_bar:
                    dcb.b    37,0
lbB0997C9:          dcb.b    571,0
top_bar_gfx:        dcb.b    37,0
lbB099A29:          dcb.b    267,0
lbL099B34:          dcb.l    3,0
lbB099B40:          dcb.b    21,0
ascii_MSG15:        dcb.b    2,0
                    dc.b     0
top_owned_keys_gfx: dcb.b    268,0
bottom_bar_gfx:     dcb.b    37,0
lbB099C89:          dcb.b    267,0
lbL099D94:          dcb.l    3,0
lbL099DA0:          dcb.l    5,0
                    dc.b     0
lbB099DB5:          dcb.b    3,0
bottom_owned_keys_gfx:
                    dcb.b    268,0
empty_sample:       dcb.b    16,0

; ------------------------------------------------------
; ------------------------------------------------------
copperlist_main:    dc.w    $104,$22
                    dc.w    $8E,$2B8E,$90,$2DB3
                    dc.w    $92,$38,$94,$D0
lbW099EE8:          dc.w    $180,0
                    dc.w    $96
sprites_dma:        dc.w    $8020
                    dc.w    $2001,$FF00
sprite_1_2_bps:     dc.w    $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0,$14A,0
sprite_3_4_bps:     dc.w    $128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0,$158,0,$15A,0
sprite_5_6_bps:     dc.w    $130,0,$132,0,$160,0,$162,0,$134,0,$136,0,$168,0,$16A,0
sprite_7_8_bps:     dc.w    $138,0,$13A,0,$170,0,$172,0,$13C,0,$13E,0,$178,0,$17A,0
                    dc.w    $2501,$FF00
copper_main_palette:
                    dc.w    $180,0,$182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
                    dc.w    $190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
                    dc.w    $1A0
lbW099FBA:          dc.w    0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
                    dc.w    $1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0
                    dc.w    $2901,$FF00
                    dc.w    $102,$DD
                    dc.w    $100,$2200
                    dc.w    $108,-2,$10A,-2
main_top_bar_bps:   dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $2B01,$FF00,$182,$111,$184,$444
                    dc.w    $2B51,$FFFE,$186,$610
                    dc.w    $2B51,$FFFE,$186,$620
                    dc.w    $2BA1,$FFFE,$186,$610
                    dc.w    $2BB1,$FFFE,$186,$620
                    dc.w    $2BC1,$FFFE,$186,$610
                    dc.w    $2BC5,$FFFE,$186,$620
                    dc.w    $2C01,$FF00,$182,$222,$184,$888
                    dc.w    $2C51,$FFFE,$186,$930
                    dc.w    $2C51,$FFFE,$186,$940
                    dc.w    $2CA1,$FFFE,$186,$930
                    dc.w    $2CB1,$FFFE,$186,$940
                    dc.w    $2CC1,$FFFE,$186,$930
                    dc.w    $2CC5,$FFFE,$186,$940
                    dc.w    $2D01,$FF00,$182,$333,$184,$CCC
                    dc.w    $2D51,$FFFE,$186,$C70
                    dc.w    $2D51,$FFFE,$186,$C80
                    dc.w    $2DA1,$FFFE,$186,$C70
                    dc.w    $2DB1,$FFFE,$186,$C80
                    dc.w    $2DC1,$FFFE,$186,$C70
                    dc.w    $2DC5,$FFFE,$186,$C80
                    dc.w    $2E01,$FF00,$182,$444,$184,$DDD
                    dc.w    $2E51,$FFFE,$186,$E90
                    dc.w    $2E51,$FFFE,$186,$EA0
                    dc.w    $2EA1,$FFFE,$186,$E90
                    dc.w    $2EB1,$FFFE,$186,$EA0
                    dc.w    $2EC1,$FFFE,$186,$E90
                    dc.w    $2EC5,$FFFE,$186,$EA0
                    dc.w    $2F01,$FF00,$182,$333,$184,$DDD
                    dc.w    $2F51,$FFFE,$186,$C70
                    dc.w    $2F51,$FFFE,$186,$C80
                    dc.w    $2FA1,$FFFE,$186,$C70
                    dc.w    $2FB1,$FFFE,$186,$C80
                    dc.w    $2FC1,$FFFE,$186,$C70
                    dc.w    $2FC5,$FFFE,$186,$C80
                    dc.w    $3001,$FF00,$182,$222,$184,$CCC
                    dc.w    $3051,$FFFE,$186,$A30
                    dc.w    $3051,$FFFE,$186,$A40
                    dc.w    $30A1,$FFFE,$186,$A30
                    dc.w    $30B1,$FFFE,$186,$A40
                    dc.w    $30C1,$FFFE,$186,$A30
                    dc.w    $30C5,$FFFE,$186,$A40
                    dc.w    $3101,$FF00,$182,$111,$184,$888
                    dc.w    $3151,$FFFE,$186,$710
                    dc.w    $3151,$FFFE,$186,$720
                    dc.w    $31A1,$FFFE,$186,$710
                    dc.w    $31B1,$FFFE,$186,$720
                    dc.w    $31C1,$FFFE,$186,$710
                    dc.w    $31C5,$FFFE,$186,$720
                    dc.w    $3201,$FF00,$182,$111,$184,$444
                    dc.w    $3251,$FFFE,$186,$510
                    dc.w    $3251,$FFFE,$186,$520
                    dc.w    $32A1,$FFFE,$186,$510
                    dc.w    $32B1,$FFFE,$186,$520
                    dc.w    $32C1,$FFFE,$186,$510
                    dc.w    $32C5,$FFFE,$186,$520
                    dc.w    $3301,$FF00,$108,2,$10A,2
                    dc.w    $100,$200
lbW09A20C:          dc.w    $180,0,$182
lbW09A212:          dc.w    0
                    dc.w    $184,0,$186,0
                    dc.w    $33E1,$FFFE
                    dc.w    $102
bplcon1:            dc.w    0
                    dc.w    $100
bplcon0:            dc.w    $5200
scroll_bp1:         dc.w    $E0,0,$E2,0
scroll_bp2:         dc.w    $E4,0,$E6,0
scroll_bp3:         dc.w    $E8,0,$EA,0
scroll_bp4:         dc.w    $EC,0,$EE,0
scroll_bp5:         dc.w    $F0,0,$F2,0
lbW09A250:          dc.w    $0098,$FF00
lbW09A254:          dc.w    $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0
                    dc.w    $14A,0,$128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0
                    dc.w    $158,0,$15A,0

lbW09A294:          dc.w    $FFDF,$FFFE
lbW09A298:          dc.w    $2BD7,$FFFE
lbW09A29E:          dc.w    $E0,0,$E2,0
lbW09A2A6:          dc.w    $E4,0,$E6,0
lbW09A2AE:          dc.w    $E8,0,$EA,0
lbW09A2B6:          dc.w    $EC,0,$EE,0
lbW09A2BE:          dc.w    $F0,0,$F2,0
lbW09A2C4:          dc.w    $98,$FF00
lbW09A2C8:          dc.w    $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0
                    dc.w    $14A,0,$128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0
                    dc.w    $158,0,$15A,0
lbW09A308:          dc.w    $2401,$FF00
                    dc.w    $2401,$FF00,$100,0
                    dc.w    $2501,$FF00,$102,$DD,$100,$2200
                    dc.w    $108,-2,$10A,-2
main_bottom_bar_bps:
                    dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $182,$111,$184,$444
                    dc.w    $2551,$FFFE,$186,$610
                    dc.w    $2551,$FFFE,$186,$620
                    dc.w    $25A1,$FFFE,$186,$610
                    dc.w    $25B1,$FFFE,$186,$620
                    dc.w    $25C1,$FFFE,$186,$610
                    dc.w    $25C5,$FFFE,$186,$620
                    dc.w    $2601,$FF00,$182,$222,$184,$888
                    dc.w    $2651,$FFFE,$186,$930
                    dc.w    $2651,$FFFE,$186,$940
                    dc.w    $26A1,$FFFE,$186,$930
                    dc.w    $26B1,$FFFE,$186,$940
                    dc.w    $26C1,$FFFE,$186,$930
                    dc.w    $26C5,$FFFE,$186,$940
                    dc.w    $2701,$FF00,$182,$333,$184,$CCC
                    dc.w    $2751,$FFFE,$186,$C70
                    dc.w    $2751,$FFFE,$186,$C80
                    dc.w    $27A1,$FFFE,$186,$C70
                    dc.w    $27B1,$FFFE,$186,$C80
                    dc.w    $27C1,$FFFE,$186,$C70
                    dc.w    $27C5,$FFFE,$186,$C80
                    dc.w    $2801,$FF00,$182,$444,$184,$DDD
                    dc.w    $2851,$FFFE,$186,$E90
                    dc.w    $2851,$FFFE,$186,$EA0
                    dc.w    $28A1,$FFFE,$186,$E90
                    dc.w    $28B1,$FFFE,$186,$EA0
                    dc.w    $28C1,$FFFE,$186,$E90
                    dc.w    $28C5,$FFFE,$186,$EA0
                    dc.w    $2901,$FF00,$182,$333,$184,$DDD
                    dc.w    $2951,$FFFE,$186,$C70
                    dc.w    $2951,$FFFE,$186,$C80
                    dc.w    $29A1,$FFFE,$186,$C70
                    dc.w    $29B1,$FFFE,$186,$C80
                    dc.w    $29C1,$FFFE,$186,$C70
                    dc.w    $29C5,$FFFE,$186,$C80
                    dc.w    $2A01,$FF00,$182,$222,$184,$CCC
                    dc.w    $2A51,$FFFE,$186,$A30
                    dc.w    $2A51,$FFFE,$186,$A40
                    dc.w    $2AA1,$FFFE,$186,$A30
                    dc.w    $2AB1,$FFFE,$186,$A40
                    dc.w    $2AC1,$FFFE,$186,$A30
                    dc.w    $2AC5,$FFFE,$186,$A40
                    dc.w    $2B01,$FF00,$182,$111,$184,$888
                    dc.w    $2B51,$FFFE,$186,$710
                    dc.w    $2B51,$FFFE,$186,$720
                    dc.w    $2BA1,$FFFE,$186,$710
                    dc.w    $2BB1,$FFFE,$186,$720
                    dc.w    $2BC1,$FFFE,$186,$710
                    dc.w    $2BC5,$FFFE,$186,$720
                    dc.w    $2C01,$FF00,$182,$111,$184,$444
                    dc.w    $2C51,$FFFE,$186,$510
                    dc.w    $2C51,$FFFE,$186,$520
                    dc.w    $2CA1,$FFFE,$186,$510
                    dc.w    $2CB1,$FFFE,$186,$520
                    dc.w    $2CC1,$FFFE,$186,$510
                    dc.w    $2CC5,$FFFE,$186,$520
                    dc.w    $2C01,$FF00
                    dc.w    $9C,$8010
                    dc.w    $FFFF,$FFFE

copper_blank:       dc.w    $100,$200
                    dc.w    $180,0
                    dc.w    $FFD7,$FFFE
                    dc.w    $101,$FF00
                    dc.w    $2F01,$FF00,$9C,$8010
                    dc.w    $FFFF,$FFFE

copperlist_overmap: dc.w    $104,$22,$8E
diwstrt_overmap:    dc.w    $2B8E
                    dc.w    $90
diwstop_overmap:    dc.w    $2DB3
                    dc.w    $92,$38,$94,$D0
                    dc.w    $96,$20
                    dc.w    $2901,$FF00,$102,$DD,$100,$2200
                    dc.w    $108,-2,$10A,-2
                    dc.w    $96,$8020
overmap_top_bar_bps:
                    dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $2B01,$FF00,$182,$111,$184,$444
                    dc.w    $2B51,$FFFE,$186,$610
                    dc.w    $2B51,$FFFE,$186,$620
                    dc.w    $2BA1,$FFFE,$186,$610
                    dc.w    $2BB1,$FFFE,$186,$620
                    dc.w    $2BC1,$FFFE,$186,$610
                    dc.w    $2BC5,$FFFE,$186,$620
                    dc.w    $2C01,$FF00,$182,$222,$184,$888
                    dc.w    $2C51,$FFFE,$186,$930
                    dc.w    $2C51,$FFFE,$186,$940
                    dc.w    $2CA1,$FFFE,$186,$930
                    dc.w    $2CB1,$FFFE,$186,$940
                    dc.w    $2CC1,$FFFE,$186,$930
                    dc.w    $2CC5,$FFFE,$186,$940
                    dc.w    $2D01,$FF00,$182,$333,$184,$CCC
                    dc.w    $2D51,$FFFE,$186,$C70
                    dc.w    $2D51,$FFFE,$186,$C80
                    dc.w    $2DA1,$FFFE,$186,$C70
                    dc.w    $2DB1,$FFFE,$186,$C80
                    dc.w    $2DC1,$FFFE,$186,$C70
                    dc.w    $2DC5,$FFFE,$186,$C80
                    dc.w    $2E01,$FF00,$182,$444,$184,$DDD
                    dc.w    $2E51,$FFFE,$186,$E90
                    dc.w    $2E51,$FFFE,$186,$EA0
                    dc.w    $2EA1,$FFFE,$186,$E90
                    dc.w    $2EB1,$FFFE,$186,$EA0
                    dc.w    $2EC1,$FFFE,$186,$E90
                    dc.w    $2EC5,$FFFE,$186,$EA0
                    dc.w    $2F01,$FF00,$182,$333,$184,$DDD
                    dc.w    $2F51,$FFFE,$186,$C70
                    dc.w    $2F51,$FFFE,$186,$C80
                    dc.w    $2FA1,$FFFE,$186,$C70
                    dc.w    $2FB1,$FFFE,$186,$C80
                    dc.w    $2FC1,$FFFE,$186,$C70
                    dc.w    $2FC5,$FFFE,$186,$C80
                    dc.w    $3001,$FF00,$182,$222,$184,$CCC
                    dc.w    $3051,$FFFE,$186,$A30
                    dc.w    $3051,$FFFE,$186,$A40
                    dc.w    $30A1,$FFFE,$186,$A30
                    dc.w    $30B1,$FFFE,$186,$A40
                    dc.w    $30C1,$FFFE,$186,$A30
                    dc.w    $30C5,$FFFE,$186,$A40
                    dc.w    $3101,$FF00,$182,$111,$184,$888
                    dc.w    $3151,$FFFE,$186,$710
                    dc.w    $3151,$FFFE,$186,$720
                    dc.w    $31A1,$FFFE,$186,$710
                    dc.w    $31B1,$FFFE,$186,$720
                    dc.w    $31C1,$FFFE,$186,$710
                    dc.w    $31C5,$FFFE,$186,$720
                    dc.w    $3201,$FF00,$182,$111,$184,$444
                    dc.w    $3251,$FFFE,$186,$510
                    dc.w    $3251,$FFFE,$186,$520
                    dc.w    $32A1,$FFFE,$186,$510
                    dc.w    $32B1,$FFFE,$186,$520
                    dc.w    $32C1,$FFFE,$186,$510
                    dc.w    $32C5,$FFFE,$186,$520
                    dc.w    $3301,$FF00,$100,$200
                    dc.w    $3401,$FF00,$100,$6200
overmap_bps:        dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $E8,0,$EA,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F0,0,$F2,0
                    dc.w    $F4,0,$F6,0
                    dc.w    $108,0,$10A,0
                    dc.w    $102,0
overmap_palette:    dc.w    $180,0
                    dc.w    $182,0,$184,0,$186,0,$188,0,$18A,0,$18C,0,$18E,0
                    dc.w    $190,0,$192,0,$194,0,$196,0,$198,0,$19A,0,$19C,0,$19E,0
                    dc.w    $1A0,0,$1A2,0,$1A4,0,$1A6,0,$1A8,0,$1AA,0,$1AC,0,$1AE,0
                    dc.w    $1B0,0,$1B2,0,$1B4,0,$1B6,0,$1B8,0,$1BA,0,$1BC,0,$1BE,0

                    dc.w    $138,0,$13A,0,$170,0,$172,0,$134,0,$136,0,$168,0,$16A,0
                    dc.w    $13C,0,$13E,0,$178,0,$17A,0,$120,0,$122,0,$140,0,$142,0
                    dc.w    $124,0,$126,0,$148,0,$14A,0,$128,0,$12A,0,$150,0,$152,0
                    dc.w    $12C,0,$12E,0,$158,0,$15A,0,$130,0,$132,0,$160,0,$162,0
                    dc.w    $FFD7,$FFF2
                    dc.w    $0601,$FF00
                    dc.w    $2401,$FF00,$100,0
                    dc.w    $2501,$FF00
                    dc.w    $102,$DD,$100,$2200
                    dc.w    $108,-2,$10A,-2
overmap_bottom_bar_bps: 
                    dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $182,$111,$184,$444
                    dc.w    $2551,$FFFE,$186,$610
                    dc.w    $2551,$FFFE,$186,$620
                    dc.w    $25A1,$FFFE,$186,$610
                    dc.w    $25B1,$FFFE,$186,$620
                    dc.w    $25C1,$FFFE,$186,$610
                    dc.w    $25C5,$FFFE,$186,$620
                    dc.w    $2601,$FF00,$182,$222,$184,$888
                    dc.w    $2651,$FFFE,$186,$930
                    dc.w    $2651,$FFFE,$186,$940
                    dc.w    $26A1,$FFFE,$186,$930
                    dc.w    $26B1,$FFFE,$186,$940
                    dc.w    $26C1,$FFFE,$186,$930
                    dc.w    $26C5,$FFFE,$186,$940
                    dc.w    $2701,$FF00,$182,$333,$184,$CCC
                    dc.w    $2751,$FFFE,$186,$C70
                    dc.w    $2751,$FFFE,$186,$C80
                    dc.w    $27A1,$FFFE,$186,$C70
                    dc.w    $27B1,$FFFE,$186,$C80
                    dc.w    $27C1,$FFFE,$186,$C70
                    dc.w    $27C5,$FFFE,$186,$C80
                    dc.w    $2801,$FF00,$182,$444,$184,$DDD
                    dc.w    $2851,$FFFE,$186,$E90
                    dc.w    $2851,$FFFE,$186,$EA0
                    dc.w    $28A1,$FFFE,$186,$E90
                    dc.w    $28B1,$FFFE,$186,$EA0
                    dc.w    $28C1,$FFFE,$186,$E90
                    dc.w    $28C5,$FFFE,$186,$EA0
                    dc.w    $2901,$FF00,$182,$333,$184,$DDD
                    dc.w    $2951,$FFFE,$186,$C70
                    dc.w    $2951,$FFFE,$186,$C80
                    dc.w    $29A1,$FFFE,$186,$C70
                    dc.w    $29B1,$FFFE,$186,$C80
                    dc.w    $29C1,$FFFE,$186,$C70
                    dc.w    $29C5,$FFFE,$186,$C80
                    dc.w    $2A01,$FF00,$182,$222,$184,$CCC
                    dc.w    $2A51,$FFFE,$186,$A30
                    dc.w    $2A51,$FFFE,$186,$A40
                    dc.w    $2AA1,$FFFE,$186,$A30
                    dc.w    $2AB1,$FFFE,$186,$A40
                    dc.w    $2AC1,$FFFE,$186,$A30
                    dc.w    $2AC5,$FFFE,$186,$A40
                    dc.w    $2B01,$FF00,$182,$111,$184,$888
                    dc.w    $2B51,$FFFE,$186,$710
                    dc.w    $2B51,$FFFE,$186,$720
                    dc.w    $2BA1,$FFFE,$186,$710
                    dc.w    $2BB1,$FFFE,$186,$720
                    dc.w    $2BC1,$FFFE,$186,$710
                    dc.w    $2BC5,$FFFE,$186,$720
                    dc.w    $2C01,$FF00,$182,$111,$184,$444
                    dc.w    $2C51,$FFFE,$186,$510
                    dc.w    $2C51,$FFFE,$186,$520
                    dc.w    $2CA1,$FFFE,$186,$510
                    dc.w    $2CB1,$FFFE,$186,$520
                    dc.w    $2CC1,$FFFE,$186,$510
                    dc.w    $2CC5,$FFFE,$186,$520
                    dc.w    $FFFF,$FFFE
; ------------------------------------------------------
; ------------------------------------------------------

                    incdir  "src/main/sprites/"
player_spr1_pic:    incbin  "player_sprite1.raw"
player_spr2_pic:    incbin  "player_sprite2.raw"
player_spr3_pic:    incbin  "player_sprite3.raw"
player_spr4_pic:    incbin  "player_sprite4.raw"
player_spr5_pic:    incbin  "player_sprite5.raw"
player_spr6_pic:    incbin  "player_sprite6.raw"
player_spr7_pic:    incbin  "player_sprite7.raw"
player_spr8_pic:    incbin  "player_sprite8.raw"
player_spr9_pic:    incbin  "player_sprite9.raw"
player_spr10_pic:   incbin  "player_sprite10.raw"
player_spr11_pic:   incbin  "player_sprite11.raw"
player_spr12_pic:   incbin  "player_sprite12.raw"
player_spr13_pic:   incbin  "player_sprite13.raw"
player_spr14_pic:   incbin  "player_sprite14.raw"
player_spr15_pic:   incbin  "player_sprite15.raw"
player_spr16_pic:   incbin  "player_sprite16.raw"
player_spr17_pic:   incbin  "player_sprite17.raw"
player_spr18_pic:   incbin  "player_sprite18.raw"
player_spr19_pic:   incbin  "player_sprite19.raw"
player_spr20_pic:   incbin  "player_sprite20.raw"
player_spr21_pic:   incbin  "player_sprite21.raw"
player_spr22_pic:   incbin  "player_sprite22.raw"
player_spr23_pic:   incbin  "player_sprite23.raw"
player_spr24_pic:   incbin  "player_sprite24.raw"
player_spr25_pic:   incbin  "player_sprite25.raw"
player_spr26_pic:   incbin  "player_sprite26.raw"
player_spr27_pic:   incbin  "player_sprite27.raw"
player_spr28_pic:   incbin  "player_sprite28.raw"
player_spr29_pic:   incbin  "player_sprite29.raw"
player_spr30_pic:   incbin  "player_sprite30.raw"
player_spr31_pic:   incbin  "player_sprite31.raw"
player_spr32_pic:   incbin  "player_sprite32.raw"
player_spr33_pic:   incbin  "player_sprite33.raw"
player_spr34_pic:   incbin  "player_sprite34.raw"
player_spr35_pic:   incbin  "player_sprite35.raw"
player_spr36_pic:   incbin  "player_sprite36.raw"
player_spr37_pic:   incbin  "player_sprite37.raw"
player_spr38_pic:   incbin  "player_sprite38.raw"
player_spr39_pic:   incbin  "player_sprite39.raw"
player_spr40_pic:   incbin  "player_sprite40.raw"
player_spr41_pic:   incbin  "player_sprite41.raw"
player_spr42_pic:   incbin  "player_sprite42.raw"
player_spr43_pic:   incbin  "player_sprite43.raw"
player_spr44_pic:   incbin  "player_sprite44.raw"
player_spr45_pic:   incbin  "player_sprite45.raw"
player_spr46_pic:   incbin  "player_sprite46.raw"
player_spr47_pic:   incbin  "player_sprite47.raw"
player_spr48_pic:   incbin  "player_sprite48.raw"
player_spr49_pic:   incbin  "player_sprite49.raw"
player_spr50_pic:   incbin  "player_sprite50.raw"
player_spr51_pic:   incbin  "player_sprite51.raw"
player_spr52_pic:   incbin  "player_sprite52.raw"
player_spr53_pic:   incbin  "player_sprite53.raw"
player_spr54_pic:   incbin  "player_sprite54.raw"
player_spr55_pic:   incbin  "player_sprite55.raw"
player_spr56_pic:   incbin  "player_sprite56.raw"
player_spr57_pic:   incbin  "player_sprite57.raw"
player_spr58_pic:   incbin  "player_sprite58.raw"
player_spr59_pic:   incbin  "player_sprite59.raw"
player_spr60_pic:   incbin  "player_sprite60.raw"
player_spr61_pic:   incbin  "player_sprite61.raw"
player_spr62_pic:   incbin  "player_sprite62.raw"
player_spr63_pic:   incbin  "player_sprite63.raw"
player_spr64_pic:   incbin  "player_sprite64.raw"
player_spr65_pic:   incbin  "player_sprite65.raw"
player_spr66_pic:   incbin  "player_sprite66.raw"
player_spr67_pic:   incbin  "player_sprite67.raw"
player_spr68_pic:   incbin  "player_sprite68.raw"
player_spr69_pic:   incbin  "player_sprite69.raw"
player_spr70_pic:   incbin  "player_sprite70.raw"
player_spr71_pic:   incbin  "player_sprite71.raw"
player_spr72_pic:   incbin  "player_sprite72.raw"
player_spr73_pic:   incbin  "player_sprite73.raw"
player_spr74_pic:   incbin  "player_sprite74.raw"
player_spr75_pic:   incbin  "player_sprite75.raw"
player_spr76_pic:   incbin  "player_sprite76.raw"
player_spr77_pic:   incbin  "player_sprite77.raw"
player_spr78_pic:   incbin  "player_sprite78.raw"
player_spr79_pic:   incbin  "player_sprite79.raw"
player_spr80_pic:   incbin  "player_sprite80.raw"

bkgnd_anim_block:   dcb.b    28800,0

                    incdir  "src/main/samples/"
sample1:            incbin  "sample1.raw"
sample2:            incbin  "sample2.raw"
sample3:            incbin  "sample3.raw"
sample4:            incbin  "sample4.raw"
sample5:            incbin  "sample5.raw"
sample6:            incbin  "sample6.raw"
sample7:            incbin  "sample7.raw"
sample8:            incbin  "sample8.raw"
sample9:            incbin  "sample9.raw"
sample10:           incbin  "sample10.raw"
sample11:           incbin  "sample11.raw"
sample12:           incbin  "sample12.raw"
sample13:           incbin  "sample13.raw"
sample14:           incbin  "sample14.raw"
sample15:           incbin  "sample15.raw"
sample16:           incbin  "sample16.raw"
sample17:           incbin  "sample17.raw"
sample18:           incbin  "sample18.raw"
sample19:           incbin  "sample19.raw"
sample20:           incbin  "sample20.raw"
sample21:           incbin  "sample21.raw"
sample22:           incbin  "sample22.raw"
sample23:           incbin  "sample23.raw"
sample24:           incbin  "sample24.raw"
sample25:           incbin  "sample25.raw"
sample26:           incbin  "sample26.raw"
sample27:           incbin  "sample27.raw"
sample28:           incbin  "sample28.raw"
sample29:           incbin  "sample29.raw"
sample30:           incbin  "sample30.raw"
sample31:           incbin  "sample31.raw"

                    SECTION  AB0D0240,BSS_c
bpsong:             ds.b     41*1024
bosstune:           ds.b     15*1024
leveltune:          ds.b     15*1024

aliens_sprites_block:
                    ds.l     16383
                    ds.l     2817
temp_buffer:        ds.b     11424
lbL0E5AE0:          ds.l     12579
map_overview_background_pic:
                    ds.l     4096
temp_map_buffer:    ds.b     24576
lbL0FBF6C:          ds.b     205
map_overview_planes:
                    ds.b     3395
lbL0FCD7C:          ds.l     1220
lbL0FE08C:          ds.l     430
lbL0FE744:          ds.l     10
lbL0FE76C:          ds.l     2635
lbL101098:          ds.l     3087
lbL1040D4:          ds.l     12348
lbL1101C4:          ds.l     4928
lbL114EC4:          ds.l     128
lbL1150C4:          ds.l     4

                    end
