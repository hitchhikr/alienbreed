; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

                    mc68000

                    section  gameover,code_c

start:              lea      screen_buffer_1,a0
                    lea      screen_buffer_2,a1
                    lea      iff_animation,a2
                    lea      anim_struct(pc),a3
                    moveq    #40,d0
                    move.l   #256,d1
                    bsr      prepare_anim
                    bsr      set_copper_buffer_2
                    moveq    #0,d7
                    lea      copper_palette,a0
                    lea      palette,a1
                    move.l   #4,d0
                    jsr      lbC000378

anim_loop:          addq.l   #1,frames_counter
                    cmp.l    #37,frames_counter
                    beq      wait_exit
                    lea      anim_struct(pc),a0
                    bsr      decode_anim
                    tst.w    d0
                    bne.s    wait_exit
                    bsr      wait_2_frames
                    bsr      set_copper_buffer_2
                    movem.l  d0-d7/a0-a6,-(sp)
                    tst.w    done_fade
                    bne.s    fade_in
                    move.w   #2,lbW0006C6
                    jsr      lbC0003F4
fade_in:            movem.l  (sp)+,d0-d7/a0-a6
                    btst     #6,$bfe001
                    beq      exit
                    btst     #7,$bfe001
                    beq.s    exit
                    lea      anim_struct(pc),a0
                    bsr      decode_anim
                    tst.w    d0
                    bne.s    wait_exit
                    bsr      wait_2_frames
                    bsr      set_copper_buffer_1
                    bra      anim_loop

wait_exit:          bsr      set_copper_buffer_2
                    move.l   #150,d0
.wait:              bsr      wait_frame
                    subq.l   #1,d0
                    beq      exit
                    btst     #7,$bfe001
                    beq.s    exit
                    btst     #6,$bfe001
                    bne.s    .wait
exit:               jsr      fade_out
                    rts

wait_frame:         cmp.b    #255,$dff006
                    bne.s    wait_frame
.wait:              cmp.b    #44,$dff006
                    bne.s    .wait
                    rts

wait_2_frames:      cmp.b    #255,$dff006
                    bne.s    wait_2_frames
.wait_frame_2:      cmp.b    #254,$dff006
                    bne.s    .wait_frame_2
.wait_rast:         cmp.b    #44,$dff006
                    bne.s    .wait_rast
                    rts

fade_out:           lea      copper_palette,a0
                    lea      lbL000182,a1
                    move.l   #4,d0
                    move.w   #1,lbW0006C6
                    jsr      lbC000506
.loop:              bsr      wait_frame
                    jsr      fade_palette
                    tst.w    done_fade
                    beq.s    .loop
                    rts

lbL000182:          dcb.w    32,0
palette:            dc.w     0,$A99,$766,$333

lbC000378:          move.w   #2,lbW0006C4
                    lea      lbL0007F8,a4
                    move.l   #48,d2
lbC00038C:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC00038C
                    move.l   d0,d7
                    move.l   a1,a2
                    clr.l    d6
                    lea      lbL000738,a3
lbC0003A0:          move.w   (a2),d6
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
                    bne      lbC0003A0
                    move.l   d1,d4
                    subq.l   #2,a0
                    subq.l   #2,a1
                    move.w   d0,lbW0006CC
                    move.l   a0,lbL0006D2
                    move.l   a1,lbL0006CE
                    clr.w    done_fade
                    rts

lbC0003F4:          cmp.w    #2,lbW0006C4
                    bne      return
                    tst.w    done_fade
                    bne      return
                    add.w    #1,lbW0006C8
                    move.w   lbW0006C8,d0
                    cmp.w    lbW0006C6,d0
                    bmi      return
                    clr.w    lbW0006C8
                    move.l   lbL0006D2,a0
                    move.l   lbL0006CE,a1
                    clr.l    d0
                    move.w   lbW0006CC,d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      lbL000738,a2
                    lea      lbL0007F8,a3
                    move.l   d6,d7
                    move.l   d0,d1
lbC000452:          addq.l   #4,a0
                    addq.l   #2,a1
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F00,d2
                    and.w    #$F00,d3
                    cmp.w    d2,d3
                    beq      lbC00047A
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC00047A:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq      lbC0004AC
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC0004AC:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #15,d2
                    and.w    #15,d3
                    cmp.w    d2,d3
                    beq      lbC0004DE
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
lbC0004DE:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC000452
                    cmp.l    d6,d7
                    bne      lbC000504
                    move.w   #1,done_fade
                    clr.w    lbW0006C4
lbC000504:          rts

lbC000506:          move.w   #3,lbW0006C4
                    lea      lbL0007F8,a4
                    move.l   #$30,d2
lbC00051A:          clr.l    (a4)+
                    subq.l   #1,d2
                    bne      lbC00051A
                    move.l   d0,d7
                    move.l   a0,a2
                    add.l    #2,a2
                    clr.l    d6
                    lea      lbL000738,a3
lbC000534:          move.w   (a2),d6
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
                    bne      lbC000534
                    lea      lbL0007F8,a3
                    move.l   a0,a2
                    add.l    #2,a2
                    move.l   d0,d4
lbC00057E:          move.w   (a2),d7
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
                    bne      lbC00057E
                    lea      lbL000738,a2
                    lea      lbL0007F8,a3
                    move.l   d1,d4
                    sub.l    #2,a0
                    move.w   d0,lbW0006CC
                    move.l   a0,lbL0006D2
                    clr.w    done_fade
                    rts

fade_palette:       cmp.w    #3,lbW0006C4
                    bne      return
                    tst.w    done_fade
                    bne      return
                    add.w    #1,lbW0006C8
                    move.w   lbW0006C8,d0
                    cmp.w    lbW0006C6,d0
                    bmi      return
                    clr.w    lbW0006C8
                    clr.l    d0
                    move.w   lbW0006CC,d0
                    move.l   lbL0006D2,a0
                    move.l   d0,d1
                    clr.l    d7
                    lea      lbL000738,a2
                    lea      lbL0007F8,a3
lbC000624:          addq.l   #4,a0
                    move.w   (a0),d2
                    and.w    #$F00,d2
                    tst.w    d2
                    beq      lbC000644
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000644:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F0,d2
                    tst.w    d2
                    beq      lbC000670
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC000670:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F,d2
                    tst.w    d2
                    beq      lbC00069C
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.l    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
lbC00069C:          add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      lbC000624
                    tst.l    d7
                    bne      lbC0006C2
                    move.w   #1,done_fade
                    clr.w    lbW0006C4
lbC0006C2:          rts

lbW0006C4:          dc.w     0
lbW0006C6:          dc.w     $19
lbW0006C8:          dc.w     0
done_fade:          dc.w     0
lbW0006CC:          dc.w     0
lbL0006CE:          dc.l     0
lbL0006D2:          dc.l     0
lbL0006D6:          dcb.l    $18,0

return:             rts

lbL000738:          dcb.l    48,0
lbL0007F8:          dcb.l    48,0

set_copper_buffer_1:
                    lea      screen_buffer_1,a1
                    bra      set_copper
set_copper_buffer_2:
                    lea      screen_buffer_2,a1
set_copper:         lea      copperlist_main(pc),a0
                    lea      copper_bitplanes(pc),a2
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    addq.l   #8,a2
                    add.w    #(256*40),a1
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    addq.l   #8,a2
                    add.w    #(256*40),a1
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    addq.l   #8,a2
                    add.w    #(256*40),a1
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    addq.l   #8,a2
                    add.w    #(256*40),a1
                    move.l   a1,d0
                    move.w   d0,6(a2)
                    swap     d0
                    move.w   d0,2(a2)
                    move.l   a0,$dff080
                    rts

copperlist_main:    dc.w    $100,$2200
                    dc.w    $8E,$2C81,$90,$2CC1
                    dc.w    $92,$38,$94,$D0
                    dc.w    $108,0,$10A,0
                    dc.w    $102,0,$96,$20
copper_bitplanes:                    
                    dc.w    $E0,0,$E2,0
                    dc.w    $E4,0,$E6,0
                    dc.w    $E8,0,$EA,0
                    dc.w    $EC,0,$EE,0
                    dc.w    $F0,0,$F2,0
copper_palette:     dc.w    $180,0,$182,0,$184,0,$186,0
                    dc.w    $FFFF,$FFFE

prepare_anim:       movem.l  d0-d7/a0-a6,-(sp)
                    move.l   a3,a6
                    movem.l  d0/d1/a0-a2,0(a6)
                    clr.b    25(a6)
                    clr.l    30(a6)
                    move.l   (a2)+,d0
                    cmp.l    #'FORM',d0
                    bne.s    .error
                    addq.l   #4,a2
                    move.l   (a2)+,d0
                    cmp.l    #'ANIM',d0
                    bne.s    .error
                    move.l   a2,a0
                    move.l   8(a6),a1
                    move.l   0(a6),d0
                    move.l   4(a6),d1
                    bsr      get_first_pic
                    move.l   a0,26(a6)
                    move.l   12(a6),a1
                    move.l   8(a6),a0
                    move.l   0(a6),d0
                    moveq    #0,d1
                    move.b   24(a6),d1
                    mulu     d1,d0
                    move.l   4(a6),d1
                    mulu     d1,d0
                    subq.l   #1,d0
                    lsr.l    #2,d0
.loop:              move.l   (a0)+,(a1)+
                    dbra     d0,.loop
                    bra.s    .end

.error:             move.w   #$F00,$dff180
                    btst     #6,$bfe001
                    bne.s    .error
.end:               movem.l  (sp)+,d0-d7/a0-a6
                    rts

decode_anim:        movem.l  d1-d7/a0-a6,-(sp)
                    move.l   a0,a6
                    move.l   26(a6),d0
                    addq.l   #1,d0
                    and.w    #$FFFE,d0
                    move.l   d0,a5
                    move.l   (a5)+,d0
                    cmp.l    #'FORM',d0
                    bne      lbC000B0E
                    addq.l   #4,a5
                    move.l   (a5)+,d0
                    cmp.l    #'ILBM',d0
                    bne      lbC000B0E
lbC000A3C:          move.l   (a5)+,d0
                    cmp.l    #'ANHD',d0
                    beq.s    get_ANHD_chunk
                    cmp.l    #'DLTA',d0
                    beq.s    get_DLTA_chunk
                    move.l   (a5)+,d0
                    add.l    d0,a5
                    bra.s    lbC000A3C

get_ANHD_chunk:     addq.l   #4,a5
                    move.b   (a5)+,d0
                    cmp.b    #5,d0
                    bne      lbC000B0E
                    add.w    #$13,a5
                    move.l   (a5)+,d7
                    add.w    #16,a5
                    bra.s    lbC000A3C

get_DLTA_chunk:     move.l   (a5)+,d4
                    move.l   a5,a3
                    add.l    d4,a3
                    move.l   a5,a4
                    move.l   0(a6),d4
                    move.b   24(a6),d5
                    tst.b    25(a6)
                    beq.s    lbC000A88
                    move.l   8(a6),a1
                    bra.s    lbC000A8C

lbC000A88:          move.l   12(a6),a1
lbC000A8C:          move.w   20(a6),d6
                    move.l   a1,a2
                    move.l   (a5)+,d0
                    lea      0(a4,d0.l),a0
lbC000A98:          move.b   (a0)+,d3
                    beq.s    lbC000ACE
lbC000A9C:          moveq    #0,d0
                    move.b   (a0)+,d0
                    bmi.s    lbC000ABC
                    beq.s    lbC000AAA
                    mulu     d4,d0
                    add.w    d0,a1
                    bra.s    lbC000ACA

lbC000AAA:          moveq    #0,d0
                    move.b   (a0)+,d0
                    move.b   (a0)+,d1
                    subq.w   #1,d0
lbC000AB2:          move.b   d1,(a1)
                    add.w    d4,a1
                    dbra     d0,lbC000AB2
                    bra.s    lbC000ACA

lbC000ABC:          and.w    #$7F,d0
                    subq.w   #1,d0
lbC000AC2:          move.b   (a0)+,(a1)
                    add.w    d4,a1
                    dbra     d0,lbC000AC2
lbC000ACA:          subq.b   #1,d3
                    bne.s    lbC000A9C
lbC000ACE:          addq.w   #1,a2
                    move.l   a2,a1
                    subq.w   #1,d6
                    bne.s    lbC000A98
                    sub.l    0(a6),a2
                    move.l   0(a6),d0
                    move.l   4(a6),d1
                    mulu     d1,d0
                    add.l    d0,a2
                    move.l   a2,a1
                    subq.b   #1,d5
                    bne.s    lbC000A8C
                    move.l   a3,d0
                    addq.l   #1,d0
                    and.l    #$FFFFFFFE,d0
                    move.l   d0,a3
                    move.l   a3,26(a6)
                    not.b    25(a6)
                    tst.l    30(a6)
                    bne.s    lbC000B0A
                    move.l   a3,30(a6)
lbC000B0A:          moveq    #0,d0
                    bra.s    lbC000B10

lbC000B0E:          moveq    #-1,d0
lbC000B10:          movem.l  (sp)+,d1-d7/a0-a6
                    rts

get_first_pic:      movem.l  d0-d7/a1-a6,-(sp)
                    move.l   d0,d6
                    move.l   d1,d7
                    move.l   (a0)+,d0
                    cmp.l    #'FORM',d0
                    bne      .error
                    addq.l   #4,a0
                    move.l   (a0)+,d0
                    cmp.l    #'ILBM',d0
                    bne      .error
.loop:              move.l   (a0)+,d0
                    cmp.l    #'BMHD',d0
                    beq.s    .get_BMHD_chunk
                    cmp.l    #'BODY',d0
                    beq.s    .get_BODY_chunk
                    move.l   (a0)+,d0               ; just take the size of this unknown chunk
                    add.l    d0,a0                  ; and move
                    bra.s    .loop

.get_BMHD_chunk:    addq.l   #4,a0
                    move.w   (a0)+,d4
                    lsr.w    #3,d4
                    move.w   d4,20(a6)
                    move.w   (a0)+,d5
                    move.w   d5,22(a6)
                    addq.l   #4,a0
                    move.b   (a0)+,d3
                    move.b   d3,24(a6)
                    add.w    #11,a0
                    bra      .loop

.get_BODY_chunk:    addq.l   #4,a0
                    move.l   a1,a5
                    move.w   d6,d2
                    mulu     d7,d2
.depack_all:        move.l   a5,a1
                    swap     d5
                    move.b   d3,d5
.depack_line:       bsr      rle_depack
                    add.w    d2,a1
                    subq.b   #1,d5
                    bne.s    .depack_line
                    swap     d5
                    add.w    d6,a5
                    subq.w   #1,d5
                    bne.s    .depack_all
                    bra.s    .end

.error:             move.w   #$F00,$dff180
                    btst     #6,$bfe001
                    bne.s    .error
.end:               movem.l  (sp)+,d0-d7/a1-a6
                    rts

rle_depack:         movem.l  d2/a1,-(sp)
                    move.w   d4,d2
                    subq.w   #1,d2
.loop:              tst.w    d2
                    bmi.s    .end
                    move.b   (a0)+,d0
                    bmi.s    .rep_byte
                    ext.w    d0
.copy_lit_bytes:    move.b   (a0)+,(a1)+
                    subq.w   #1,d2
                    dbra     d0,.copy_lit_bytes
                    bra.s    .loop
.rep_byte:          ext.w    d0
                    neg.w    d0
                    move.b   (a0)+,d1
.copy_rep_byte:     move.b   d1,(a1)+
                    subq.w   #1,d2
                    dbra     d0,.copy_rep_byte
                    bra.s    .loop
.end:               movem.l  (sp)+,d2/a1
                    rts

anim_struct:        dcb.w    17,0
frames_counter:     dc.l     0
screen_buffer_1:    dcb.b    (256*40*2),0
screen_buffer_2:    dcb.b    (256*40*2),0

                    incdir   "src/gameover/anim/"
iff_animation:      incbin   "gameover.anim"

                    end
