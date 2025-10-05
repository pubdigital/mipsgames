# Game 1942 - Version 1.2 - Con sistema de balas

.data
    .align 2
    SCREEN_WIDTH:    .word 64
    SCREEN_HEIGHT:   .word 64
    
    player_x:        .word 28
    player_y:        .word 28
    
    player_x_old:    .word 28
    player_y_old:    .word 28
    
    PLAYER_SIZE:     .word 7
    MOVE_SPEED:      .word 2
    
    first_draw:      .word 1
    
    # Sistema de balas
    MAX_BULLETS:     .word 5
    BULLET_SIZE:     .word 2
    BULLET_SPEED:    .word 1
    bullet_spawn_counter: .word 0
    BULLET_SPAWN_RATE:    .word 40
    
    # Sistema de vidas
    player_lives:    .word 3
    game_over_flag:  .word 0
    invulnerable_counter: .word 0
    INVULNERABLE_TIME:    .word 60
    
    # Paleta de colores
    sea_colors:
    .word 0x000066CC
    .word 0x004499DD
    
    plane_body:      .word 0x00CCCCCC
    plane_dark:      .word 0x00888888
    plane_red:       .word 0x00DD0000
    plane_window:    .word 0x0044AAFF
    bullet_color:    .word 0x00FF0000
    
    # Array de balas (cada bala son 5 words: active, x, y, old_x, old_y)
    .align 2
    bullet_0: .word 0, 0, 0, 0, 0
    bullet_1: .word 0, 0, 0, 0, 0
    bullet_2: .word 0, 0, 0, 0, 0
    bullet_3: .word 0, 0, 0, 0, 0
    bullet_4: .word 0, 0, 0, 0, 0
    
    .align 2
    plane_sprite:
    .byte 0,0,0,2,0,0,0
    .byte 0,0,2,2,2,0,0
    .byte 0,2,2,4,2,2,0
    .byte 2,2,2,2,2,2,2
    .byte 0,2,2,2,2,2,0
    .byte 0,0,1,2,1,0,0
    .byte 0,0,0,1,0,0,0
    
    .align 2
    wave_pattern:
    .byte 0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1
    .byte 1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0
    .byte 0,1,0,1,0,1,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1
    .byte 1,0,1,0,1,0,0,1,0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0
    .byte 0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1,0,1
    .byte 1,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0
    .byte 0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,1,0,1,0,1,0,0,1,0,1,0,1,0,1
    .byte 1,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,0,1,0,1,0,1,1,0,1,0,1,0,1,0
    .byte 0,1,0,1,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,0,1,0,1,0,1,1,0
    .byte 1,0,1,0,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,1,1,0,1,0,1,0,0,1
    .byte 0,1,0,1,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,0,1,0,1,1,0,1,0
    .byte 1,0,1,0,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,1,0,1,0,0,1,0,1
    .byte 0,1,0,1,1,0,1,0,0,1,0,1,0,1,1,0,0,1,0,1,1,0,0,1,0,1,0,1,1,0,1,0
    .byte 1,0,1,0,0,1,0,1,1,0,1,0,1,0,0,1,1,0,1,0,0,1,1,0,1,0,1,0,0,1,0,1
    .byte 0,1,1,0,1,0,1,0,0,1,0,1,0,1,1,0,0,1,0,1,1,0,0,1,0,1,0,1,1,0,1,0
    .byte 1,0,0,1,0,1,0,1,1,0,1,0,1,0,0,1,1,0,1,0,0,1,1,0,1,0,1,0,0,1,0,1
    
    .align 2
    msg_init:        .asciiz "=== 1942 v1.2 ===\n"
    msg_controls:    .asciiz "W/A/S/D - Esquiva las balas!\n"
    msg_lives:       .asciiz "Vidas: "
    msg_game_over:   .asciiz "\n*** GAME OVER ***\n"
    newline:         .asciiz "\n"
    
.text
.globl main

main:
    li $v0, 4
    la $a0, msg_init
    syscall
    la $a0, msg_controls
    syscall
    
    jal draw_sea_full
    sw $zero, first_draw
    
game_loop:
    lw $t0, game_over_flag
    bnez $t0, game_over
    
    jal process_input
    jal update_bullets
    jal spawn_bullet
    jal check_collisions
    jal draw_player_smart
    jal draw_bullets
    jal update_invulnerability
    jal delay
    j game_loop

game_over:
    li $v0, 4
    la $a0, msg_game_over
    syscall
    li $v0, 10
    syscall

# ===== GENERAR NUEVA BALA =====
spawn_bullet:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, bullet_spawn_counter
    addi $t0, $t0, 1
    sw $t0, bullet_spawn_counter
    
    lw $t1, BULLET_SPAWN_RATE
    blt $t0, $t1, spawn_done
    
    sw $zero, bullet_spawn_counter
    
    # Buscar slot libre (verificar cada bala manualmente)
    la $t0, bullet_0
    lw $t1, 0($t0)
    beqz $t1, spawn_in_slot
    
    la $t0, bullet_1
    lw $t1, 0($t0)
    beqz $t1, spawn_in_slot
    
    la $t0, bullet_2
    lw $t1, 0($t0)
    beqz $t1, spawn_in_slot
    
    la $t0, bullet_3
    lw $t1, 0($t0)
    beqz $t1, spawn_in_slot
    
    la $t0, bullet_4
    lw $t1, 0($t0)
    beqz $t1, spawn_in_slot
    
    j spawn_done

spawn_in_slot:
    # Activar bala
    li $t2, 1
    sw $t2, 0($t0)
    
    # Posición X aleatoria
    li $v0, 30
    syscall
    move $t3, $a0
    andi $t3, $t3, 0x3F
    li $t4, 58
    bgt $t3, $t4, spawn_adjust
    j spawn_set_pos
    
spawn_adjust:
    li $t3, 58
    
spawn_set_pos:
    sw $t3, 4($t0)      # x
    li $t4, 0
    sw $t4, 8($t0)      # y = 0
    sw $t3, 12($t0)     # old_x
    sw $t4, 16($t0)     # old_y

spawn_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== ACTUALIZAR BALAS =====
update_bullets:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Actualizar bullet_0
    la $t0, bullet_0
    jal update_single_bullet
    
    # Actualizar bullet_1
    la $t0, bullet_1
    jal update_single_bullet
    
    # Actualizar bullet_2
    la $t0, bullet_2
    jal update_single_bullet
    
    # Actualizar bullet_3
    la $t0, bullet_3
    jal update_single_bullet
    
    # Actualizar bullet_4
    la $t0, bullet_4
    jal update_single_bullet
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

update_single_bullet:
    lw $t1, 0($t0)
    beqz $t1, update_bullet_end
    
    # Guardar posición anterior
    lw $t2, 4($t0)
    lw $t3, 8($t0)
    sw $t2, 12($t0)
    sw $t3, 16($t0)
    
    # Mover hacia abajo
    lw $t4, BULLET_SPEED
    add $t3, $t3, $t4
    sw $t3, 8($t0)
    
    # Desactivar si sale de pantalla
    lw $t5, SCREEN_HEIGHT
    blt $t3, $t5, update_bullet_end
    sw $zero, 0($t0)

update_bullet_end:
    jr $ra

# ===== DETECTAR COLISIONES =====
check_collisions:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, invulnerable_counter
    bnez $t0, collision_done
    
    lw $t0, player_x
    lw $t1, player_y
    lw $t2, PLAYER_SIZE
    
    # Verificar cada bala
    la $t3, bullet_0
    jal check_bullet_collision
    
    la $t3, bullet_1
    jal check_bullet_collision
    
    la $t3, bullet_2
    jal check_bullet_collision
    
    la $t3, bullet_3
    jal check_bullet_collision
    
    la $t3, bullet_4
    jal check_bullet_collision

collision_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

check_bullet_collision:
    lw $t4, 0($t3)
    beqz $t4, check_bullet_end
    
    lw $t5, 4($t3)      # bullet_x
    lw $t6, 8($t3)      # bullet_y
    lw $t7, BULLET_SIZE
    
    # AABB collision detection
    add $t8, $t0, $t2   # player_right
    blt $t8, $t5, check_bullet_end
    
    add $t9, $t5, $t7   # bullet_right
    blt $t9, $t0, check_bullet_end
    
    add $s0, $t1, $t2   # player_bottom
    blt $s0, $t6, check_bullet_end
    
    add $s1, $t6, $t7   # bullet_bottom
    blt $s1, $t1, check_bullet_end
    
    # Colisión detectada
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal handle_hit
    lw $ra, 0($sp)
    addi $sp, $sp, 4

check_bullet_end:
    jr $ra

# ===== MANEJAR IMPACTO =====
handle_hit:
    lw $t0, player_lives
    addi $t0, $t0, -1
    sw $t0, player_lives
    
    li $v0, 4
    la $a0, msg_lives
    syscall
    li $v0, 1
    lw $a0, player_lives
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    lw $t1, INVULNERABLE_TIME
    sw $t1, invulnerable_counter
    
    blez $t0, set_game_over
    jr $ra

set_game_over:
    li $t2, 1
    sw $t2, game_over_flag
    jr $ra

# ===== ACTUALIZAR INVULNERABILIDAD =====
update_invulnerability:
    lw $t0, invulnerable_counter
    beqz $t0, invuln_done
    addi $t0, $t0, -1
    sw $t0, invulnerable_counter
invuln_done:
    jr $ra

# ===== DIBUJAR BALAS =====
draw_bullets:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, bullet_0
    jal draw_single_bullet
    
    la $t0, bullet_1
    jal draw_single_bullet
    
    la $t0, bullet_2
    jal draw_single_bullet
    
    la $t0, bullet_3
    jal draw_single_bullet
    
    la $t0, bullet_4
    jal draw_single_bullet
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

draw_single_bullet:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t1, 0($t0)
    beqz $t1, draw_single_end
    
    # Borrar posición anterior
    lw $a0, 12($t0)
    lw $a1, 16($t0)
    jal erase_bullet
    
    # Dibujar en nueva posición
    lw $a0, 4($t0)
    lw $a1, 8($t0)
    jal draw_bullet_at

draw_single_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== BORRAR BALA =====
erase_bullet:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    move $s0, $a0
    move $s1, $a1
    lw $s2, BULLET_SIZE
    
    la $s3, wave_pattern
    la $t9, sea_colors
    
    li $t5, 0
    
erase_bullet_y:
    bge $t5, $s2, erase_bullet_done_loop
    
    add $t8, $s1, $t5
    andi $t2, $t8, 0xF
    sll $t2, $t2, 5
    add $t3, $s3, $t2
    
    li $t6, 0
    
erase_bullet_x:
    bge $t6, $s2, erase_bullet_next_y
    
    add $t7, $s0, $t6
    andi $s4, $t7, 0x1F
    add $s5, $t3, $s4
    lb $s5, 0($s5)
    
    sll $s6, $s5, 2
    add $s6, $t9, $s6
    lw $s6, 0($s6)
    
    add $s7, $s1, $t5
    sll $s7, $s7, 6
    add $s7, $s7, $s0
    add $s7, $s7, $t6
    sll $s7, $s7, 2
    add $s7, $gp, $s7
    
    sw $s6, 0($s7)
    
    addi $t6, $t6, 1
    j erase_bullet_x

erase_bullet_next_y:
    addi $t5, $t5, 1
    j erase_bullet_y

erase_bullet_done_loop:
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# ===== DIBUJAR BALA =====
draw_bullet_at:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t0, $a0
    move $t1, $a1
    lw $t2, BULLET_SIZE
    lw $t3, bullet_color
    
    li $t4, 0
    
draw_bullet_y:
    bge $t4, $t2, draw_bullet_done_loop
    
    li $t5, 0
    
draw_bullet_x:
    bge $t5, $t2, draw_bullet_next_y
    
    add $t6, $t1, $t4
    sll $t6, $t6, 6
    add $t6, $t6, $t0
    add $t6, $t6, $t5
    sll $t6, $t6, 2
    add $t6, $gp, $t6
    
    sw $t3, 0($t6)
    
    addi $t5, $t5, 1
    j draw_bullet_x

draw_bullet_next_y:
    addi $t4, $t4, 1
    j draw_bullet_y

draw_bullet_done_loop:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR MAR COMPLETO =====
draw_sea_full:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t0, $gp
    la $t9, wave_pattern
    la $s7, sea_colors
    
    li $t1, 0
    
sea_y_loop:
    li $t8, 64
    bge $t1, $t8, sea_done
    
    andi $t2, $t1, 0xF
    sll $t2, $t2, 5
    add $t3, $t9, $t2
    
    li $t4, 0
    
sea_x_loop:
    li $t8, 64
    bge $t4, $t8, sea_next_y
    
    andi $t5, $t4, 0x1F
    add $t6, $t3, $t5
    lb $t6, 0($t6)
    
    sll $t7, $t6, 2
    add $t7, $s7, $t7
    lw $t7, 0($t7)
    
    sw $t7, 0($t0)
    addi $t0, $t0, 4
    addi $t4, $t4, 1
    j sea_x_loop

sea_next_y:
    addi $t1, $t1, 1
    j sea_y_loop

sea_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR JUGADOR INTELIGENTE =====
draw_player_smart:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, player_x
    lw $t1, player_x_old
    lw $t2, player_y
    lw $t3, player_y_old
    
    bne $t0, $t1, player_moved
    bne $t2, $t3, player_moved
    j draw_smart_done

player_moved:
    jal erase_old_player
    
    lw $t0, player_x
    sw $t0, player_x_old
    lw $t0, player_y
    sw $t0, player_y_old
    
    jal draw_player_new

draw_smart_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== BORRAR JUGADOR ANTERIOR =====
erase_old_player:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, player_x_old
    lw $t1, player_y_old
    lw $t9, PLAYER_SIZE
    
    la $s6, wave_pattern
    la $s7, sea_colors
    
    li $t5, 0
    
erase_y_loop:
    bge $t5, $t9, erase_done
    
    add $t8, $t1, $t5
    andi $t2, $t8, 0xF
    sll $t2, $t2, 5
    add $t3, $s6, $t2
    
    li $t6, 0
    
erase_x_loop:
    bge $t6, $t9, erase_next_y
    
    add $s0, $t0, $t6
    andi $s1, $s0, 0x1F
    add $s2, $t3, $s1
    lb $s2, 0($s2)
    
    sll $s3, $s2, 2
    add $s3, $s7, $s3
    lw $s3, 0($s3)
    
    add $s4, $t1, $t5
    sll $s4, $s4, 6
    add $s4, $s4, $t0
    add $s4, $s4, $t6
    sll $s4, $s4, 2
    add $s4, $gp, $s4
    
    sw $s3, 0($s4)
    
    addi $t6, $t6, 1
    j erase_x_loop

erase_next_y:
    addi $t5, $t5, 1
    j erase_y_loop

erase_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR JUGADOR EN NUEVA POSICIÓN =====
draw_player_new:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, player_x
    lw $t1, player_y
    lw $t9, PLAYER_SIZE
    
    la $s0, plane_sprite
    lw $s1, plane_dark
    lw $s2, plane_body
    lw $s3, plane_red
    lw $s4, plane_window
    
    li $t5, 0
    
new_y_loop:
    bge $t5, $t9, new_done
    
    li $t6, 0
    
new_x_loop:
    bge $t6, $t9, new_next_row
    
    mul $t7, $t5, $t9
    add $t7, $t7, $t6
    add $t8, $s0, $t7
    lb $t8, 0($t8)
    
    beqz $t8, skip_pixel
    
    li $a0, 1
    beq $t8, $a0, use_dark
    li $a0, 2
    beq $t8, $a0, use_body
    li $a0, 3
    beq $t8, $a0, use_red
    li $a0, 4
    beq $t8, $a0, use_window
    j skip_pixel
    
use_dark:
    move $a1, $s1
    j draw_pixel
use_body:
    move $a1, $s2
    j draw_pixel
use_red:
    move $a1, $s3
    j draw_pixel
use_window:
    move $a1, $s4
    
draw_pixel:
    add $a2, $t1, $t5
    sll $a2, $a2, 6
    add $a2, $a2, $t0
    add $a2, $a2, $t6
    sll $a2, $a2, 2
    add $a2, $gp, $a2
    
    sw $a1, 0($a2)
    
skip_pixel:
    addi $t6, $t6, 1
    j new_x_loop

new_next_row:
    addi $t5, $t5, 1
    j new_y_loop

new_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== PROCESAR INPUT =====
process_input:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 0xffff0000
    lw $t1, 0($t0)
    andi $t1, $t1, 1
    beqz $t1, no_input
    
    li $t0, 0xffff0004
    lw $t2, 0($t0)
    
    li $t3, 119
    beq $t2, $t3, move_up
    li $t3, 87
    beq $t2, $t3, move_up
    li $t3, 115
    beq $t2, $t3, move_down
    li $t3, 83
    beq $t2, $t3, move_down
    li $t3, 97
    beq $t2, $t3, move_left
    li $t3, 65
    beq $t2, $t3, move_left
    li $t3, 100
    beq $t2, $t3, move_right
    li $t3, 68
    beq $t2, $t3, move_right
    j no_input

move_up:
    lw $t0, player_y
    lw $t1, MOVE_SPEED
    sub $t0, $t0, $t1
    bltz $t0, no_input
    sw $t0, player_y
    j no_input

move_down:
    lw $t0, player_y
    lw $t1, MOVE_SPEED
    add $t0, $t0, $t1
    lw $t2, SCREEN_HEIGHT
    lw $t3, PLAYER_SIZE
    sub $t2, $t2, $t3
    bgt $t0, $t2, no_input
    sw $t0, player_y
    j no_input

move_left:
    lw $t0, player_x
    lw $t1, MOVE_SPEED
    sub $t0, $t0, $t1
    bltz $t0, no_input
    sw $t0, player_x
    j no_input

move_right:
    lw $t0, player_x
    lw $t1, MOVE_SPEED
    add $t0, $t0, $t1
    lw $t2, SCREEN_WIDTH
    lw $t3, PLAYER_SIZE
    sub $t2, $t2, $t3
    bgt $t0, $t2, no_input
    sw $t0, player_x

no_input:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DELAY =====
delay:
    li $t0, 80000
delay_loop:
    addi $t0, $t0, -1
    bnez $t0, delay_loop
    jr $ra
