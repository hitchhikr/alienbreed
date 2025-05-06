; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

                    include  "common.inc"

; -----------------------------------------------------

                    section  gameover,code_c

start:              lea      screen_buffer_1(pc),a0
                    lea      screen_buffer_2(pc),a1
                    lea      iff_animation,a2
                    lea      anim_struct(pc),a3
                    moveq    #40,d0
                    move.l   #256,d1
                    bsr      prepare_anim
                    bsr      set_copper_buffer_2
                    moveq    #0,d7
                    lea      copper_palette(pc),a0
                    lea      palette(pc),a1
                    moveq    #4,d0
                    bsr      prep_fade_speeds_fade_in

anim_loop:          addq.l   #1,frames_counter
                    cmp.l    #37,frames_counter
                    beq      wait_exit
                    lea      anim_struct(pc),a0
                    bsr      decode_anim
                    tst.w    d0
                    bne      wait_exit
                    bsr      wait_2_frames
                    bsr      set_copper_buffer_2
                    movem.l  d0-d7/a0-a6,-(sp)
                    tst.w    done_fade
                    bne      fade_in
                    move.w   #2,frames_slowdown
                    bsr      fade_palette_in
fade_in:            movem.l  (sp)+,d0-d7/a0-a6
                    btst     #CIAB_GAMEPORT0,CIAA
                    beq      exit
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      exit
                    lea      anim_struct(pc),a0
                    bsr      decode_anim
                    tst.w    d0
                    bne      wait_exit
                    bsr      wait_2_frames
                    bsr      set_copper_buffer_1
                    bra      anim_loop

wait_exit:          bsr      set_copper_buffer_2
                    move.l   #150,d0
.wait:              bsr      wait_frame
                    subq.l   #1,d0
                    beq      exit
                    btst     #CIAB_GAMEPORT1,CIAA
                    beq      exit
                    btst     #CIAB_GAMEPORT0,CIAA
                    bne      .wait
exit:               bra      fade_out

wait_frame:         cmp.b    #255,$dff006
                    bne      wait_frame
.wait:              cmp.b    #44,$dff006
                    bne      .wait
                    rts

wait_2_frames:      cmp.b    #255,$dff006
                    bne      wait_2_frames
.wait_frame_2:      cmp.b    #254,$dff006
                    bne      .wait_frame_2
.wait_rast:         cmp.b    #44,$dff006
                    bne      .wait_rast
                    rts

fade_out:           lea      copper_palette(pc),a0
                    lea      black_palette(pc),a1
                    moveq    #4,d0
                    move.w   #1,frames_slowdown
                    bsr      prep_fade_speeds_fade_out
.loop:              bsr      wait_frame
                    bsr      fade_palette_out
                    tst.w    done_fade
                    beq      .loop
                    rts

prep_fade_speeds_fade_in:
                    lea      cur_rgb_block(pc),a4
                    moveq    #48,d2
.clear:             clr.l    (a4)+
                    subq.l   #1,d2
                    bne      .clear
                    move.l   d0,d7
                    move.l   a1,a2
                    moveq    #0,d6
                    lea      rgb_speeds_block(pc),a3
.loop:              move.w   (a2),d6
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
                    bne      .loop
                    move.l   d1,d4
                    subq.l   #2,a0
                    subq.l   #2,a1
                    move.w   d0,colors_amount
                    move.l   a0,ptr_copper_palette
                    move.l   a1,ptr_source_palette
                    clr.w    done_fade
                    rts

fade_palette_in:    tst.w    done_fade
                    bne      return
                    add.w    #1,cur_frame_counter
                    move.w   cur_frame_counter(pc),d0
                    cmp.w    frames_slowdown(pc),d0
                    bmi      return
                    clr.w    cur_frame_counter
                    move.l   ptr_copper_palette(pc),a0
                    move.l   ptr_source_palette(pc),a1
                    moveq    #0,d0
                    move.w   colors_amount(pc),d0
                    move.l   d0,d6
                    mulu     #3,d6
                    lea      rgb_speeds_block(pc),a2
                    lea      cur_rgb_block(pc),a3
                    move.l   d6,d7
                    move.l   d0,d1
.loop:              addq.l   #4,a0
                    addq.l   #2,a1
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F00,d2
                    and.w    #$F00,d3
                    cmp.w    d2,d3
                    beq      .fade_red
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
.fade_red:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq      .fade_green
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
.fade_green:        add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F,d2
                    and.w    #$F,d3
                    cmp.w    d2,d3
                    beq      .fade_blue
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
.fade_blue:         addq.l   #2,a2
                    addq.l   #2,a3
                    subq.w   #1,d1
                    bne      .loop
                    cmp.l    d6,d7
                    bne      .fade_end
                    move.w   #1,done_fade
.fade_end:          rts

prep_fade_speeds_fade_out:
                    lea      cur_rgb_block(pc),a4
                    moveq    #48,d2
.clear:             clr.l    (a4)+
                    subq.l   #1,d2
                    bne      .clear
                    move.l   d0,d7
                    move.l   a0,a2
                    add.l    #2,a2
                    moveq    #0,d6
                    lea      rgb_speeds_block(pc),a3
.set_speeds:        move.w   (a2),d6
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
                    bne      .set_speeds
                    lea      cur_rgb_block(pc),a3
                    move.l   a0,a2
                    addq.l   #2,a2
                    move.l   d0,d4
.set_cur_rgb:       move.w   (a2),d7
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
                    bne      .set_cur_rgb
                    lea      rgb_speeds_block(pc),a2
                    lea      cur_rgb_block(pc),a3
                    move.l   d1,d4
                    subq.l   #2,a0
                    move.w   d0,colors_amount
                    move.l   a0,ptr_copper_palette
                    clr.w    done_fade
                    rts

fade_palette_out:   tst.w    done_fade
                    bne      return
                    add.w    #1,cur_frame_counter
                    move.w   cur_frame_counter(pc),d0
                    cmp.w    frames_slowdown(pc),d0
                    bmi      return
                    clr.w    cur_frame_counter
                    moveq    #0,d0
                    move.w   colors_amount(pc),d0
                    move.l   ptr_copper_palette(pc),a0
                    move.l   d0,d1
                    moveq    #0,d7
                    lea      rgb_speeds_block(pc),a2
                    lea      cur_rgb_block(pc),a3
.loop:              addq.l   #4,a0
                    move.w   (a0),d2
                    and.w    #$F00,d2
                    beq.b    .fade_red
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
.fade_red:          add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F0,d2
                    beq.b    .fade_green
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
.fade_green:        add.l    #2,a2
                    add.l    #2,a3
                    move.w   (a0),d2
                    and.w    #$F,d2
                    beq.b    .fade_blue
                    move.w   (a2),d3
                    sub.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.l    #8,d3
                    and.w    #$FFF0,(a0)
                    add.w    d3,(a0)
                    addq.w   #1,d7
.fade_blue:         add.l    #2,a2
                    add.l    #2,a3
                    subq.w   #1,d1
                    bne      .loop
                    tst.l    d7
                    bne.b    .fade_end
                    move.w   #1,done_fade
.fade_end:          rts

return:             rts

set_copper_buffer_1:
                    lea      screen_buffer_1(pc),a1
                    bra.b    set_copper
set_copper_buffer_2:
                    lea      screen_buffer_2(pc),a1
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
                    move.l   a0,CUSTOM+COP1LCH
                    rts

; -----------------------------------------------------

prepare_anim:       movem.l  d0-d7/a0-a6,-(sp)
                    move.l   a3,a6
                    movem.l  d0/d1/a0-a2,0(a6)
                    clr.b    25(a6)
                    clr.l    30(a6)
                    move.l   (a2)+,d0
                    cmp.l    #'FORM',d0
                    bne      .error
                    addq.l   #4,a2
                    move.l   (a2)+,d0
                    cmp.l    #'ANIM',d0
                    bne      .error
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
                    bra      .end

.error:             move.w   #$F00,$dff180
                    btst     #6,$bfe001
                    bne      .error
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
                    bne      err_anim_chunk_name
                    addq.l   #4,a5
                    move.l   (a5)+,d0
                    cmp.l    #'ILBM',d0
                    bne      err_anim_chunk_name
.continue:          move.l   (a5)+,d0
                    cmp.l    #'ANHD',d0
                    beq      .get_ANHD_chunk
                    cmp.l    #'DLTA',d0
                    beq      .get_DLTA_chunk
                    move.l   (a5)+,d0
                    add.l    d0,a5
                    bra      .continue

.get_ANHD_chunk:    addq.l   #4,a5
                    move.b   (a5)+,d0
                    cmp.b    #5,d0
                    bne      err_anim_chunk_name
                    lea      19(a5),a5
                    move.l   (a5)+,d7
                    lea      16(a5),a5
                    bra      .continue

.get_DLTA_chunk:    move.l   (a5)+,d4
                    move.l   a5,a3
                    add.l    d4,a3
                    move.l   a5,a4
                    move.l   0(a6),d4
                    move.b   24(a6),d5
                    tst.b    25(a6)
                    beq      lbC000A88
                    move.l   8(a6),a1
                    bra      lbC000A8C

lbC000A88:          move.l   12(a6),a1
lbC000A8C:          move.w   20(a6),d6
                    move.l   a1,a2
                    move.l   (a5)+,d0
                    lea      0(a4,d0.l),a0
lbC000A98:          move.b   (a0)+,d3
                    beq      lbC000ACE
lbC000A9C:          moveq    #0,d0
                    move.b   (a0)+,d0
                    bmi.b    lbC000ABC
                    beq      lbC000AAA
                    mulu     d4,d0
                    add.w    d0,a1
                    bra      lbC000ACA

lbC000AAA:          moveq    #0,d0
                    move.b   (a0)+,d0
                    move.b   (a0)+,d1
                    subq.w   #1,d0
lbC000AB2:          move.b   d1,(a1)
                    add.w    d4,a1
                    dbra     d0,lbC000AB2
                    bra      lbC000ACA

lbC000ABC:          and.w    #$7F,d0
                    subq.w   #1,d0
lbC000AC2:          move.b   (a0)+,(a1)
                    add.w    d4,a1
                    dbra     d0,lbC000AC2
lbC000ACA:          subq.b   #1,d3
                    bne      lbC000A9C
lbC000ACE:          addq.w   #1,a2
                    move.l   a2,a1
                    subq.w   #1,d6
                    bne      lbC000A98
                    sub.l    0(a6),a2
                    move.l   0(a6),d0
                    move.l   4(a6),d1
                    mulu     d1,d0
                    add.l    d0,a2
                    move.l   a2,a1
                    subq.b   #1,d5
                    bne      lbC000A8C
                    move.l   a3,d0
                    addq.l   #1,d0
                    and.l    #$FFFFFFFE,d0
                    move.l   d0,a3
                    move.l   a3,26(a6)
                    not.b    25(a6)
                    tst.l    30(a6)
                    bne      lbC000B0A
                    move.l   a3,30(a6)
lbC000B0A:          moveq    #0,d0
                    bra.b    end_decode

err_anim_chunk_name:
                    moveq    #-1,d0
end_decode:         movem.l  (sp)+,d1-d7/a0-a6
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
                    beq.b    .get_BMHD_chunk
                    cmp.l    #'BODY',d0
                    beq.b    .get_BODY_chunk
                    move.l   (a0)+,d0               ; just take the size of this unknown chunk
                    add.l    d0,a0                  ; and move over it
                    bra.b    .loop

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
                    bne.b    .depack_line
                    swap     d5
                    add.w    d6,a5
                    subq.w   #1,d5
                    bne.b    .depack_all
                    bra.b    .end

.error:             move.w   #$F00,CUSTOM+COLOR00
                    btst     #CIAB_GAMEPORT0,CIAA
                    bne.b    .error
.end:               movem.l  (sp)+,d0-d7/a1-a6
                    rts

rle_depack:         movem.l  d2/a1,-(sp)
                    move.w   d4,d2
                    subq.w   #1,d2
.loop:              tst.w    d2
                    bmi.b    .end
                    move.b   (a0)+,d0
                    bmi.b    .rep_byte
                    ext.w    d0
.copy_lit_bytes:    move.b   (a0)+,(a1)+
                    subq.w   #1,d2
                    dbra     d0,.copy_lit_bytes
                    bra.b    .loop
.rep_byte:          ext.w    d0
                    neg.w    d0
                    move.b   (a0)+,d1
.copy_rep_byte:     move.b   d1,(a1)+
                    subq.w   #1,d2
                    dbra     d0,.copy_rep_byte
                    bra.b    .loop
.end:               movem.l  (sp)+,d2/a1
                    rts

; -----------------------------------------------------

anim_struct:        dcb.w    17,0
frames_counter:     dc.l     0
frames_slowdown:    dc.w     25
cur_frame_counter:  dc.w     0
done_fade:          dc.w     0
colors_amount:      dc.w     0
ptr_source_palette: dc.l     0
ptr_copper_palette: dc.l     0
rgb_speeds_block:   dcb.w    (32*3),0
cur_rgb_block:      dcb.w    (32*3),0

black_palette:      dcb.w    32,0
palette:            dc.w     0,$A99,$766,$333

; -----------------------------------------------------

copperlist_main:    dc.w     BPLCON0,$2200
                    dc.w     DIWSTRT,$2C81,DIWSTOP,$2CC1
                    dc.w     DDFSTRT,$38,DDFSTOP,$D0
                    dc.w     BPL1MOD,0,BPL2MOD,0
                    dc.w     BPLCON1,0,DMACON,DMAF_SPRITE
copper_bitplanes:   dc.w     BPL1PTH,0,BPL1PTL,0
                    dc.w     BPL2PTH,0,BPL2PTL,0
                    dc.w     BPL3PTH,0,BPL3PTL,0
                    dc.w     BPL4PTH,0,BPL4PTL,0
                    dc.w     BPL5PTH,0,BPL5PTL,0
copper_palette:     dc.w     COLOR00,0,COLOR01,0,COLOR02,0,COLOR03,0
                    dc.w     $FFFF,$FFFE

; -----------------------------------------------------

screen_buffer_1:    dcb.b    (256*40*2),0
screen_buffer_2:    dcb.b    (256*40*2),0

; -----------------------------------------------------

iff_animation:      incbin   "gameover.anim"

                    end
