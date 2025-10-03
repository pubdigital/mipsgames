# Game 1942 - Version 1.0

.data
    SCREEN_WIDTH:    .word 64
    SCREEN_HEIGHT:   .word 64
    
    player_x:        .word 28
    player_y:        .word 28
    
    # Posición anterior del jugador (para borrar)
    player_x_old:    .word 28
    player_y_old:    .word 28
    
    PLAYER_SIZE:     .word 2
    MOVE_SPEED:      .word 2
    
    first_draw:      .word 1     # Flag para primer dibujado
    
    # Paleta de colores del mar (más tonos para irregularidad)
    sea_colors:
    .word 0x00103d6b    # 0 - Muy oscuro
    .word 0x00154775    # 1 - Oscuro profundo
    .word 0x001a5180    # 2 - Oscuro
    .word 0x001f5a8a    # 3 - Medio oscuro
    .word 0x00246495    # 4 - Medio
    .word 0x00296da0    # 5 - Medio claro
    .word 0x002e76ab    # 6 - Claro
    .word 0x00337fb6    # 7 - Claro brillante
    .word 0x003888c1    # 8 - Muy claro
    .word 0x003d91cc    # 9 - Espuma
    
    # Patrón irregular de mar (16x16 para más variedad)
    # Patrón más orgánico, no simétrico
    wave_pattern:
    .byte 2,3,2,1,2,3,4,3,2,3,2,1,2,3,2,1,0,1,2,1,0,1,2,3,2,1,2,3,4,3,2,1
    .byte 3,4,3,2,3,4,5,4,3,4,3,2,3,4,3,2,1,2,3,2,1,2,3,4,3,2,3,4,5,4,3,2
    .byte 2,3,4,3,2,3,4,5,4,3,2,3,4,5,4,3,2,3,4,3,2,3,4,5,4,3,2,3,4,3,2,1
    .byte 3,4,5,4,3,4,5,6,5,4,3,4,5,6,5,4,3,4,5,4,3,4,5,6,5,4,3,2,3,2,1,2
    .byte 4,5,6,5,4,5,6,7,6,5,4,5,6,7,6,5,4,5,6,5,4,5,6,7,6,5,4,3,4,3,2,3
    .byte 3,4,5,6,5,4,5,6,7,6,5,4,5,6,7,6,5,4,5,6,7,6,5,6,7,6,5,4,5,4,3,4
    .byte 4,5,6,7,6,5,6,7,8,7,6,5,6,7,8,7,6,5,6,7,8,7,6,7,8,7,6,5,6,5,4,5
    .byte 5,6,7,8,7,6,7,8,9,8,7,6,7,8,9,8,7,6,7,8,9,8,7,8,9,8,7,6,7,6,5,6
    .byte 4,5,6,7,8,7,6,7,8,9,8,7,6,7,8,7,6,5,6,7,8,7,6,7,8,7,6,5,6,5,4,5
    .byte 3,4,5,6,7,6,5,6,7,8,7,6,5,6,7,6,5,4,5,6,7,6,5,6,7,6,5,4,5,4,3,4
    .byte 4,5,4,5,6,5,4,5,6,7,6,5,4,5,6,5,4,3,4,5,6,5,4,5,6,5,4,3,4,3,2,3
    .byte 3,4,3,4,5,4,3,4,5,6,5,4,3,4,5,4,3,2,3,4,5,4,3,4,5,4,3,2,3,2,1,2
    .byte 2,3,2,3,4,3,2,3,4,5,4,3,2,3,4,3,2,1,2,3,4,3,2,3,4,3,2,1,2,1,0,1
    .byte 3,2,3,2,3,4,3,2,3,4,5,4,3,2,3,2,1,2,3,2,3,4,3,2,3,2,1,2,3,2,1,2
    .byte 2,1,2,1,2,3,2,1,2,3,4,3,2,1,2,1,0,1,2,1,2,3,2,1,2,1,0,1,2,1,0,1
    .byte 1,0,1,0,1,2,1,0,1,2,3,2,1,0,1,0,1,0,1,0,1,2,1,0,1,0,1,0,1,0,1,0
    
    # Mensajes
    msg_init:        .asciiz "=== 1942 v1.0 - Mar Realista ===\n"
    msg_controls:    .asciiz "W/A/S/D para mover (sin parpadeo)\n\n"
    
.text
.globl main

main:
    li $v0, 4
    la $a0, msg_init
    syscall
    la $a0, msg_controls
    syscall
    
    # Dibujar fondo completo solo una vez
    jal draw_sea_full
    
    # Marcar que ya no es el primer frame
    sw $zero, first_draw
    
game_loop:
    jal process_input
    jal draw_player_smart    # Dibuja solo lo necesario
    jal delay
    j game_loop

# ===== DIBUJAR MAR COMPLETO (SOLO UNA VEZ) =====
draw_sea_full:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t0, $gp
    la $t9, wave_pattern
    la $s7, sea_colors
    
    li $t1, 0                    # Y counter
    
sea_y_loop:
    li $t8, 64
    bge $t1, $t8, sea_done
    
    # Usar Y mod 16 para patrón
    andi $t2, $t1, 0xF
    sll $t2, $t2, 5              # * 32 (bytes por línea)
    add $t3, $t9, $t2
    
    li $t4, 0                    # X counter
    
sea_x_loop:
    li $t8, 64
    bge $t4, $t8, sea_next_y
    
    # Usar X mod 32 para patrón
    andi $t5, $t4, 0x1F
    add $t6, $t3, $t5
    lb $t6, 0($t6)
    
    # Obtener color
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

# ===== DIBUJAR JUGADOR INTELIGENTE (SIN PARPADEO) =====
draw_player_smart:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Verificar si el jugador se movió
    lw $t0, player_x
    lw $t1, player_x_old
    lw $t2, player_y
    lw $t3, player_y_old
    
    # Si no se movió, no hacer nada
    bne $t0, $t1, player_moved
    bne $t2, $t3, player_moved
    j draw_smart_done

player_moved:
    # Borrar posición anterior (redibujar mar ahí)
    jal erase_old_player
    
    # Actualizar posición antigua
    lw $t0, player_x
    sw $t0, player_x_old
    lw $t0, player_y
    sw $t0, player_y_old
    
    # Dibujar en nueva posición
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
    
    li $t5, 0                    # Y counter
    
erase_y_loop:
    bge $t5, $t9, erase_done
    
    add $t8, $t1, $t5            # Y actual
    andi $t2, $t8, 0xF           # Y mod 16
    sll $t2, $t2, 5              # * 32
    add $t3, $s6, $t2
    
    li $t6, 0                    # X counter
    
erase_x_loop:
    bge $t6, $t9, erase_next_y
    
    add $s0, $t0, $t6            # X actual
    andi $s1, $s0, 0x1F          # X mod 32
    add $s2, $t3, $s1
    lb $s2, 0($s2)               # Índice de color
    
    # Obtener color del mar
    sll $s3, $s2, 2
    add $s3, $s7, $s3
    lw $s3, 0($s3)               # Color
    
    # Calcular offset en display
    add $s4, $t1, $t5            # Y total
    sll $s4, $s4, 6              # * 64
    add $s4, $s4, $t0            # + X base
    add $s4, $s4, $t6            # + X offset
    sll $s4, $s4, 2              # * 4
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
    
    sll $t2, $t1, 6
    add $t2, $t2, $t0
    sll $t2, $t2, 2
    
    move $t3, $gp
    add $t3, $t3, $t2
    
    li $t4, 0x00FFFFFF           # Blanco
    li $t5, 0
    
new_y_loop:
    bge $t5, $t9, new_done
    
    li $t6, 0
    move $t7, $t3
    
new_x_loop:
    bge $t6, $t9, new_next_row
    
    sw $t4, 0($t7)
    addi $t7, $t7, 4
    addi $t6, $t6, 1
    j new_x_loop

new_next_row:
    addi $t3, $t3, 256
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
