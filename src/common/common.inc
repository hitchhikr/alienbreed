; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; ------------------------------------------------------

                    include  'custom.i'
                    include  'cia.i'
                    include  'dmabits.i'
                    include  'intbits.i'

                    mc68000

; ------------------------------------------------------

; 1 to activate the debug mode
DEBUG               equ      1

lbW05F7A8           equ      cur_map_datas+612
map_reactor_up      equ      cur_map_datas+2598
lbW060644           equ      cur_map_datas+4352
lbW06188C           equ      cur_map_datas+9032
lbW0619E8           equ      cur_map_datas+9380
lbW061AFC           equ      cur_map_datas+9656
lbW061D6C           equ      cur_map_datas+10280
lbW061FDC           equ      cur_map_datas+10904
map_reactor_left    equ      cur_map_datas+10928
lbW06224C           equ      cur_map_datas+11528
lbW062296           equ      cur_map_datas+11602
lbW062366           equ      cur_map_datas+11810
lbW062368           equ      cur_map_datas+11812
map_reactor_right   equ      cur_map_datas+11872
lbW062460           equ      cur_map_datas+12060
lbW06258C           equ      cur_map_datas+12360
lbW0627FC           equ      cur_map_datas+12984
lbW062872           equ      cur_map_datas+13102
lbW062D52           equ      cur_map_datas+14350
lbW063124           equ      cur_map_datas+15328
lbW063804           equ      cur_map_datas+17088
lbW063806           equ      cur_map_datas+17090
lbW063CCE           equ      cur_map_datas+18314
lbW063DB8           equ      cur_map_datas+18548
lbL063DC6           equ      cur_map_datas+18562
lbW064204           equ      cur_map_datas+19648
map_reactor_down    equ      cur_map_datas+20698

; exec
_LVOSupervisor      equ      -30
_LVOSuperState      equ      -150
_LVOUserState       equ      -156
_LVOAddIntServer    equ      -168
_LVORemIntServer    equ      -174
_LVOOldOpenLibrary  equ      -408
_LVOCloseLibrary    equ      -414
_LVOOpenLibrary     equ      -552
_LVOCacheClearU     equ      -636
_LVOCacheControl    equ      -648

AttnFlags           equ      $128
LIB_VERSION         equ      20

; dos
_LVOOpen            equ      -30
_LVOClose           equ      -36
_LVORead            equ      -42

MODE_OLDFILE        equ      1005

; gfx
_LVOLoadView        equ      -222
_LVOWaitTOF         equ      -270

KEY_P               equ      $19
KEY_M               equ      $37
KEY_SPACE           equ      $40
KEY_RETURN          equ      $44
KEY_ESC             equ      $45
KEY_UP              equ      $4c
KEY_DOWN            equ      $4d
KEY_RIGHT           equ      $4e
KEY_LEFT            equ      $4f
KEY_LEFT_ALT        equ      $64
KEY_RIGHT_ALT       equ      $65

PLAYER_MAX_AMMO     equ      32
PLAYER_MAX_AMMOPCKS equ      4
PLAYER_MAX_HEALTH   equ      64

PLAYER_CUR_WEAPON   equ      256
PLAYER_POS_X        equ      300
PLAYER_POS_Y        equ      302
PLAYER_ALIVE        equ      316
PLAYER_CUR_SPRITE   equ      320
PLAYER_HEALTH       equ      336
PLAYER_LIVES        equ      340
PLAYER_AMMOPACKS    equ      344
PLAYER_AMMUNITIONS  equ      348
PLAYER_KEYS         equ      352
PLAYER_CREDITS      equ      356
PLAYER_EXTRA_SPD_X  equ      376
PLAYER_EXTRA_SPD_Y  equ      378
PLAYER_OWNEDWEAPONS equ      402
PLAYER_OLD_POS_X    equ      428
PLAYER_OLD_POS_Y    equ      432
PLAYER_SHOTS        equ      436
PLAYER_SCORE        equ      440

PLAYER_FACE_UP      equ      1
PLAYER_FACE_UP_LEFT equ      8
PLAYER_FACE_UP_RIGHT equ     2
PLAYER_FACE_DOWN    equ      5
PLAYER_FACE_DOWN_LEFT equ    6
PLAYER_FACE_DOWN_RIGHT equ   4
PLAYER_FACE_LEFT    equ      7
PLAYER_FACE_RIGHT   equ      3

WEAPON_MACHINEGUN   equ      1
WEAPON_TWINFIRE     equ      2
WEAPON_FLAMEARC     equ      3
WEAPON_PLASMAGUN    equ      4
WEAPON_FLAMETHROWER equ      5
WEAPON_SIDEWINDERS  equ      6
WEAPON_LAZER        equ      7
WEAPON_MAX          equ      8

SUPPLY_MAP_OVERVIEW equ      1
SUPPLY_AMMO_CHARGE  equ      2
SUPPLY_NRG_INJECT   equ      4
SUPPLY_KEY_PACK     equ      8
SUPPLY_EXTRA_LIFE   equ      16

SAMPLE_KEY          equ      22
SAMPLE_AMMO         equ      24
SAMPLE_1UP          equ      27
SAMPLE_1STAID_CREDS equ      30
SAMPLE_ACID_POOL    equ      34

ALIEN_SPEED         equ      10
ALIEN_POS_X         equ      30
ALIEN_POS_Y         equ      32
ALIEN_STRENGTH      equ      60

TILE_DOOR           equ      3

VOICE_WARNING       equ      17
VOICE_DESTRUCT_IMM  equ      18
VOICE_ENTERING      equ      50
VOICE_ZONE          equ      51
VOICE_WELCOME_TO    equ      52
VOICE_INTEX_SYSTEM  equ      53
VOICE_DEATH         equ      54
VOICE_PLAYER        equ      57
VOICE_REQUIRES      equ      58
VOICE_AMMO          equ      59
VOICE_FIRST_AID     equ      60
VOICE_DANGER        equ      61
VOICE_INSERT_DISK   equ      62
VOICE_KEYS          equ      63
VOICE_GAME_OVER     equ      64
VOICE_ONE           equ      65
VOICE_TWO           equ      66
VOICE_THREE         equ      67
VOICE_FOUR          equ      68
VOICE_FIVE          equ      69
VOICE_SIX           equ      70
VOICE_SEVEN         equ      71
VOICE_EIGHT         equ      72

INTEX_CUR_CREDITS   equ      0
INTEX_ALIENS_KILLED equ      4
INTEX_SHOTS_FIRED   equ      8
INTEX_UNUSED        equ      12
INTEX_DOORS_OPENED  equ      16
INTEX_AMMO_PACKS    equ      20
INTEX_HEALTH        equ      24
INTEX_CUR_WEAPON    equ      28
