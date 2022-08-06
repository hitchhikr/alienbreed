                    section  end,code_c
start:
                    lea      pic_bp,a0
                    move.l   #background_pic,d0
                    move.l   #4,d1
set_bkgnd_bps:      move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #(256*40),d0
                    addq.l   #8,a0
                    subq.w   #1,d1
                    bne.s    set_bkgnd_bps
                    lea      scroll_bp,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    add.l    #40,d0
                    move.l   #copperlist_main,$dff080
                    move.l   #$1A,d0
scroll_background:  bsr      wait_sync
                    sub.b    #8,diwstrt
                    subq.w   #1,d0
                    bne.s    scroll_background
                    move.b   #$2C,diwstrt
                    move.l   #scroll_pic,d0
                    move.l   #$300,d1
                    clr.l    d7
scroll_text:        btst     #7,$bfe001
                    beq.s    exit
                    bsr      wait_sync
                    lea      scroll_bp,a0
                    move.w   d0,6(a0)
                    swap     d0
                    move.w   d0,2(a0)
                    swap     d0
                    addq.w   #1,d7
                    cmp.w    #4,d7
                    bmi      scroll_text
                    clr.l    d7
                    add.l    #40,d0
                    subq.w   #1,d1
                    bne.s    scroll_text
exit:               move.l   #26,d0
remove_background:  bsr      wait_sync
                    add.b    #8,diwstrt
                    subq.w   #1,d0
                    bne.s    remove_background
                    move.b   #$FF,diwstrt
                    clr.l    d0
                    rts

wait_sync:          cmp.b    #255,$dff006
                    bne.s    wait_sync
.wait:              cmp.b    #0,$dff006
                    bne.s    .wait
                    rts

copperlist_main:    dc.w    $120,0,$122,0,$140,0,$142,0,$124,0,$126,0,$148,0
                    dc.w    $14A,0,$128,0,$12A,0,$150,0,$152,0,$12C,0,$12E,0
                    dc.w    $158,0,$15A,0,$130,0,$132,0,$160,0,$162,0,$134,0
                    dc.w    $136,0,$168,0,$16A,0,$138,0,$13A,0,$170,0,$172,0
                    dc.w    $13C,0,$13E,0,$178,0,$17A,0,$100,$5200
                    dc.w    $8E
diwstrt:            dc.w    $FF81
                    dc.w    $90,$2CC1
                    dc.w    $92,$38,$94,$D0
                    dc.w    $108,0,$10A,0
                    dc.w    $104,0,$102,0
                    dc.w    $180,$000,$182,$AAA,$184,$222,$186,$332,$188,$333,$18A,$444,$18C,$543,$18E,$555
                    dc.w    $190,$765,$192,$666,$194,$877,$196,$A87,$198,$999,$19A,$111,$19C,$DDD,$19E,$FFF
                    dc.w    $1A0,$FFF,$1A2,$FFF,$1A4,$FFF,$1A6,$FFF,$1A8,$FFF,$1AA,$FFF,$1AC,$FFF,$1AE,$FFF
                    dc.w    $1B0,$FFF,$1B2,$FFF,$1B4,$FFF,$1B6,$FFF,$1B8,$FFF,$1BA,$FFF,$1BC,$FFF,$1BE,$FFF
pic_bp:             dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $E8,0,$EA,0
                    dc.w    $EC,0,$EE,0
scroll_bp:          dc.w    $F0,0,$F2,0
                    dc.w    $FFFF,$FFFE

background_pic:     incbin   "end/gfx/bkgnd_320x256x4.raw"
scroll_pic:         incbin   "end/gfx/scroll_320x1024x1.raw"

                    end
