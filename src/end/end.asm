; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

                    include  "common.inc"

; -----------------------------------------------------

                    section  end,code_c

start:              lea      pic_bp(pc),a0
                    move.l   #background_pic,d0
                    moveq    #4,d1
set_bkgnd_bps:      move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(256*40),d0
                    addq.l   #8,a0
                    subq.w   #1,d1
                    bne.b    set_bkgnd_bps
                    lea      scroll_bp(pc),a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #40,d0
                    move.l   #copperlist_main,CUSTOM+COP1LCH
                    move.l   #$1A,d0
scroll_background:  bsr.b    wait_frame
                    sub.b    #8,diwstrt
                    subq.w   #1,d0
                    bne.b    scroll_background
                    move.b   #$2C,diwstrt
                    move.l   #scroll_pic,d0
                    move.l   #$300,d1
                    moveq    #0,d7
scroll_text:        btst     #CIAB_GAMEPORT1,CIAA
                    beq.b    exit
                    bsr.b    wait_frame
                    lea      scroll_bp(pc),a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.w   #1,d7
                    cmp.w    #4,d7
                    bmi.b    scroll_text
                    moveq    #0,d7
                    add.l    #40,d0
                    subq.w   #1,d1
                    bne.b    scroll_text
exit:               move.l   #26,d0
remove_background:  bsr.b    wait_frame
                    add.b    #8,diwstrt
                    subq.w   #1,d0
                    bne.b    remove_background
                    move.b   #$FF,diwstrt
                    moveq    #0,d0
                    rts

wait_frame:         cmp.b    #255,$dff006
                    bne.b    wait_frame
.wait:              cmp.b    #0,$dff006
                    bne.b    .wait
                    rts

; -----------------------------------------------------

copperlist_main:    dc.w     SPR0PTH,0,SPR0PTL,0,SPR0POS,0,SPR0CTL,0,SPR1PTH,0,SPR1PTL,0,SPR1POS,0,SPR1CTL,0
                    dc.w     SPR2PTH,0,SPR2PTL,0,SPR2POS,0,SPR2CTL,0,SPR3PTH,0,SPR3PTL,0,SPR3POS,0,SPR3CTL,0
                    dc.w     SPR4PTH,0,SPR4PTL,0,SPR4POS,0,SPR4CTL,0,SPR5PTH,0,SPR5PTL,0,SPR5POS,0,SPR5CTL,0
                    dc.w     SPR6PTH,0,SPR6PTL,0,SPR6POS,0,SPR6CTL,0,SPR7PTH,0,SPR7PTL,0,SPR7POS,0,SPR7CTL,0
                    dc.w     BPLCON0,$5200
                    dc.w     DIWSTRT
diwstrt:            dc.w     $FF81
                    dc.w     DIWSTOP,$2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,0,BPL2MOD,0
                    dc.w     BPLCON2,0,BPLCON1,0
                    dc.w     COLOR00,$000,COLOR01,$AAA,COLOR02,$222,COLOR03,$332,COLOR04,$333,COLOR05,$444,COLOR06,$543,COLOR07,$555
                    dc.w     COLOR08,$765,COLOR09,$666,COLOR10,$877,COLOR11,$A87,COLOR12,$999,COLOR13,$111,COLOR14,$DDD,COLOR15,$FFF
                    dc.w     COLOR16,$FFF,COLOR17,$FFF,COLOR18,$FFF,COLOR19,$FFF,COLOR20,$FFF,COLOR21,$FFF,COLOR22,$FFF,COLOR23,$FFF
                    dc.w     COLOR24,$FFF,COLOR25,$FFF,COLOR26,$FFF,COLOR27,$FFF,COLOR28,$FFF,COLOR29,$FFF,COLOR30,$FFF,COLOR31,$FFF
pic_bp:             dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
scroll_bp:          dc.w     BPL5PTH,0,BPL5PTL,0
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

background_pic:     incbin   "bkgnd_320x256x4.raw"
scroll_pic:         incbin   "scroll_320x1024x1.raw"

                    end
