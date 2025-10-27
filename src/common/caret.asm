; -----------------------------------------------------
; Alien Breed Special Edition 92 CD32 by Team 17
; -----------------------------------------------------
; Disassembled by Franck 'hitchhikr' Charlet.
; -----------------------------------------------------

; -----------------------------------------------------

set_caret_bp:       tst.l    16(a0)
                    bne.b    .set_caret_ptr
                    move.l   12(a0),d0
.set_caret_copper_dat:
                    move.l   8(a0),a1
                    move.w   6(a0),d1
                    or.w     d1,14(a1)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    rts

.set_caret_ptr:     move.l   16(a0),a1
                    move.l   a1,20(a0)
                    move.w   6(a1),24(a0)
                    move.l   (a1),d0
                    bra.b    .set_caret_copper_dat

disp_caret:         move.l   8(a0),a1
                    tst.l    16(a0)
                    bne      .animate
.set_caret_pos:     and.w    #$80,14(a1)
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
                    bpl      .set_caret_pos
                    addq.l   #8,20(a0)
.set_caret_copper:  move.l   20(a0),a2
                    move.l   (a2),d0
                    bmi.b    .reset_anim
                    move.w   6(a2),24(a0)
                    move.w   d0,6(a1)
                    swap     d0
                    move.w   d0,2(a1)
                    bra      .set_caret_pos

.reset_anim:        move.l   16(a0),20(a0)
                    bra.b    .set_caret_copper
