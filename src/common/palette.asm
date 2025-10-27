prep_fade_speeds_fade_to_rgb:
                    movem.l  d0-d7/a0-a6,-(sp)
                    move.w   #1,fading_go_flag
                    move.w   d0,colors_amount
                    move.l   a1,ptr_source_palette
                    move.l   a2,ptr_copper_palette
                    move.l   a0,a2
                    lea      rgb_speeds_block_to_rgb(pc),a3
                    move.w   colors_amount(pc),d0
.loop:              move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bmi.b    .red_negative
                    bhi.b    .red_positive
                    clr.b    (a3)+
                    bra.b    .red_done
.red_negative:      move.b   #-1,(a3)+
                    bra.b    .red_done
.red_positive:      move.b   #1,(a3)+
.red_done:          move.w   (a2),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bmi.b    .green_negative
                    bhi.b    .green_positive
                    clr.b    (a3)+
                    bra.b    .green_done
.green_negative:    move.b   #-1,(a3)+
                    bra.b    .green_done
.green_positive:    move.b   #1,(a3)+
.green_done:        move.w   (a2)+,d1
                    move.w   (a1)+,d2
                    and.w    #$F,d1
                    and.w    #$F,d2
                    cmp.w    d1,d2
                    bmi.b    .blue_negative
                    bhi.b    .blue_positive
                    clr.b    (a3)+
                    bra.b    .blue_done
.blue_negative:     move.b   #-1,(a3)+
                    bra.b    .blue_done
.blue_positive:     move.b   #1,(a3)+
.blue_done:         subq.b   #1,d0
                    bne.b    .loop
                    move.l   ptr_copper_palette(pc),a2
                    move.w   colors_amount(pc),d0
                    addq.l   #2,a2
.copy:              move.w   (a0)+,(a2)
                    addq.l   #4,a2
                    subq.b   #1,d0
                    bne.b    .copy
                    clr.w    done_fade
                    movem.l  (sp)+,d0-d7/a0-a6
                    rts

fade_palette_to_rgb:
                    cmp.w    #1,fading_go_flag
                    bne      return
                    tst.w    done_fade
                    bne      return
                    moveq    #0,d7
                    add.w    #1,cur_frame_counter
                    move.w   cur_frame_counter(pc),d0
                    cmp.w    frames_slowdown(pc),d0
                    bmi      return
                    clr.w    cur_frame_counter
                    move.w   colors_amount(pc),d0
                    move.l   ptr_copper_palette(pc),a0
                    move.l   ptr_source_palette(pc),a1
                    lea      rgb_speeds_block_to_rgb(pc),a3
                    addq.l   #2,a0
.loop:              move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F00,d1
                    and.w    #$F00,d2
                    cmp.w    d1,d2
                    bne.b    .red_fade
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    .red_done
.red_fade:          move.b   (a3)+,d3
                    lsr.w    #8,d1
                    add.b    d3,d1
                    lsl.w    #8,d1
                    and.w    #$FF,(a0)
                    or.w     d1,(a0)
.red_done:          move.w   (a0),d1
                    move.w   (a1),d2
                    and.w    #$F0,d1
                    and.w    #$F0,d2
                    cmp.w    d1,d2
                    bne.b    .green_fade
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    .green_done
.green_fade:        move.b   (a3)+,d3
                    lsr.w    #4,d1
                    add.b    d3,d1
                    lsl.w    #4,d1
                    and.w    #$F0F,(a0)
                    or.w     d1,(a0)
.green_done:        move.w   (a0),d1
                    move.w   (a1)+,d2
                    and.w    #$F,d1
                    and.w    #$F,d2
                    cmp.w    d1,d2
                    bne.b    .blue_fade
                    addq.b   #1,d7
                    addq.l   #1,a3
                    bra.b    .blue_done
.blue_fade:         move.b   (a3)+,d3
                    add.b    d3,d1
                    and.w    #$FF0,(a0)
                    or.w     d1,(a0)
.blue_done:         addq.l   #4,a0
                    subq.b   #1,d0
                    bne.b    .loop
                    divu     #3,d7
                    cmp.w    colors_amount(pc),d7
                    bne.b    .fade_end
                    move.w   #1,done_fade
                    clr.w    fading_go_flag
.fade_end:          rts

set_palette:        addq.l   #2,a1
.copy_loop:         move.w   (a0)+,(a1)
                    addq.l   #4,a1
                    subq.b   #1,d0
                    bne.b    .copy_loop
                    rts

prep_fade_speeds_fade_in:
                    move.w   #2,fading_go_flag
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
                    bne.b    .loop
                    move.l   d1,d4
                    subq.l   #2,a0
                    subq.l   #2,a1
                    move.w   d0,colors_amount
                    move.l   a0,ptr_copper_palette
                    move.l   a1,ptr_source_palette
                    clr.w    done_fade
                    rts

fade_palette_in:    cmp.w    #2,fading_go_flag
                    bne      return
                    tst.w    done_fade
                    bne      return
                    addq.w   #1,cur_frame_counter
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
                    beq.b    .fade_red
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    and.w    #$F0FF,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
.fade_red:          addq.l   #2,a2
                    addq.l   #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F0,d2
                    and.w    #$F0,d3
                    cmp.w    d2,d3
                    beq.b    .fade_green
                    move.w   (a2),d3
                    add.w    d3,(a3)
                    move.w   (a3),d3
                    and.w    #$F00,d3
                    lsr.w    #4,d3
                    and.w    #$FF0F,(a0)
                    add.w    d3,(a0)
                    subq.w   #1,d7
.fade_green:        addq.l   #2,a2
                    addq.l   #2,a3
                    move.w   (a0),d2
                    move.w   (a1),d3
                    and.w    #$F,d2
                    and.w    #$F,d3
                    cmp.w    d2,d3
                    beq.b    .fade_blue
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
                    bne.b    .loop
                    cmp.l    d6,d7
                    bne.b    .fade_end
                    move.w   #1,done_fade
                    clr.w    fading_go_flag
.fade_end:          rts

prep_fade_speeds_fade_out:
                    move.w   #3,fading_go_flag
                    lea      cur_rgb_block(pc),a4
                    moveq    #48,d2
.clear:             clr.l    (a4)+
                    subq.l   #1,d2
                    bne.b    .clear
                    move.l   d0,d7
                    move.l   a0,a2
                    addq.l   #2,a2
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
                    bne.b    .set_speeds
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
                    bne.b    .set_cur_rgb
                    lea      rgb_speeds_block(pc),a2
                    lea      cur_rgb_block(pc),a3
                    move.l   d1,d4
                    subq.l   #2,a0
                    move.w   d0,colors_amount
                    move.l   a0,ptr_copper_palette
                    clr.w    done_fade
                    rts

fade_palette_out:   cmp.w    #3,fading_go_flag
                    bne      return
                    tst.w    done_fade
                    bne      return
                    addq.w   #1,cur_frame_counter
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
.fade_red:          addq.l   #2,a2
                    addq.l   #2,a3
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
.fade_green:        addq.l   #2,a2
                    addq.l   #2,a3
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
.fade_blue:         addq.l   #2,a2
                    addq.l   #2,a3
                    subq.w   #1,d1
                    bne.b    .loop
                    tst.l    d7
                    bne.b    .fade_end
                    move.w   #1,done_fade
                    clr.w    fading_go_flag
.fade_end:          rts

fading_go_flag:     dc.w     0
frames_slowdown:    dc.w     FADE_SPEED
cur_frame_counter:  dc.w     0
done_fade:          dc.w     0
colors_amount:      dc.w     0
ptr_source_palette: dc.l     0
ptr_copper_palette: dc.l     0
rgb_speeds_block_to_rgb:
                    dcb.l    24,0
rgb_speeds_block:   dcb.l    48,0
cur_rgb_block:      dcb.l    48,0
