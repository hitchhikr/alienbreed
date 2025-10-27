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
                    lea      palette_black(pc),a1
                    moveq    #4,d0
                    move.w   #1,frames_slowdown
                    bsr      prep_fade_speeds_fade_out
.loop:              bsr      wait_frame
                    bsr      fade_palette_out
                    tst.w    done_fade
                    beq      .loop
                    rts

FADE_SPEED          equ      25
                    include  "palette.asm"

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
                    movem.l  d0/d1/a0-a2,(a6)
                    clr.b    25(a6)
                    ; source
                    move.l   (a2)+,d0
                    cmp.l    #'FORM',d0
                    bne      .error
                    addq.l   #4,a2
                    move.l   (a2)+,d0
                    cmp.l    #'ANIM',d0
                    bne      .error
                    ; source
                    move.l   a2,a0
                    ; screen buffer 1
                    move.l   8(a6),a1
                    ; width
                    move.l   (a6),d0
                    ; height
                    move.l   4(a6),d1
                    bsr      get_first_pic
                    move.l   a0,26(a6)
                    ; screen buffer 2
                    move.l   12(a6),a1
                    ; screen buffer 1
                    move.l   8(a6),a0
                    ; width
                    move.l   (a6),d0
                    moveq    #0,d1
                    ; depth
                    move.b   24(a6),d1
                    mulu     d1,d0
                    ; height
                    move.l   4(a6),d1
                    mulu     d1,d0
                    subq.l   #1,d0
                    lsr.l    #2,d0
.copy_first_pic:    move.l   (a0)+,(a1)+
                    dbra     d0,.copy_first_pic
                    bra      .end

.error:             move.w   #$F00,$dff180
                    btst     #6,$bfe001
                    bne      .error
.end:               movem.l  (sp)+,d0-d7/a0-a6
                    rts

decode_anim:        movem.l  d1-d7/a0-a6,-(sp)
                    move.l   a0,a6
                    ; frame pointer
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
                    ; only anim5 type
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
                    ; width
                    move.l   (a6),d4
                    ; depth
                    move.b   24(a6),d5
                    tst.b    25(a6)
                    beq      .odd_frame
                    ; screen buffer 1
                    move.l   8(a6),a1
                    bra      .loop_decode_depth
.odd_frame:         ; screen buffer 2
                    move.l   12(a6),a1
.loop_decode_depth: ; width
                    move.w   20(a6),d6
                    move.l   a1,a2
                    move.l   (a5)+,d0
                    lea      0(a4,d0.l),a0
.loop_decode_line:  move.b   (a0)+,d3
                    beq      .no_copy
.loop_copy:         moveq    #0,d0
                    move.b   (a0)+,d0
                    bmi.b    .lit_block
                    beq      .rep_block
                    mulu     d4,d0
                    add.l    d0,a1
                    bra      .next
.rep_block:         moveq    #0,d0
                    move.b   (a0)+,d0
                    move.b   (a0)+,d1
                    subq.w   #1,d0
.copy_rep_byte:     move.b   d1,(a1)
                    add.l    d4,a1
                    dbra     d0,.copy_rep_byte
                    bra      .next
.lit_block:         and.w    #$7F,d0
                    subq.w   #1,d0
.copy_lit_bytes:    move.b   (a0)+,(a1)
                    add.l    d4,a1
                    dbra     d0,.copy_lit_bytes
.next:              subq.b   #1,d3
                    bne      .loop_copy
.no_copy:           addq.l   #1,a2
                    move.l   a2,a1
                    subq.w   #1,d6
                    bne      .loop_decode_line
                    sub.l    0(a6),a2
                    ; width
                    move.l   0(a6),d0
                    ; height
                    move.l   4(a6),d1
                    mulu     d1,d0
                    add.l    d0,a2
                    move.l   a2,a1
                    subq.b   #1,d5
                    bne      .loop_decode_depth
                    move.l   a3,d0
                    ; make sure the next frame is even
                    addq.l   #1,d0
                    and.l    #$FFFFFFFE,d0
                    move.l   d0,a3
                    ; next frame
                    move.l   a3,26(a6)
                    ; flip buffer
                    not.b    25(a6)
                    ; OK
                    moveq    #0,d0
                    bra.b    end_decode
err_anim_chunk_name:
                    ; not OK
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
                    ; width
                    move.w   d4,20(a6)
                    move.w   (a0)+,d5
                    ; height
                    move.w   d5,22(a6)
                    addq.l   #4,a0
                    move.b   (a0)+,d3
                    ; depth
                    move.b   d3,24(a6)
                    lea      11(a0),a0
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

anim_struct:        dcb.b    34,0
frames_counter:     dc.l     0
palette_black:      dcb.w    32,0
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
