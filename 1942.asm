# Game 1942 - Version 2.0 

.data
    .align 2
    SCREEN_WIDTH:    .word 64
    SCREEN_HEIGHT:   .word 64
    
    player_x:        .word 26
    player_y:        .word 46
    
    player_x_old:    .word 26
    player_y_old:    .word 46
    
    PLAYER_SIZE:     .word 12      # Reducido a 12x8 (escala 50%)
    PLAYER_HEIGHT:   .word 8
    MOVE_SPEED:      .word 2
    
    first_draw:      .word 1
    
    # Sistema de scroll del mar
    sea_scroll_offset: .word 0
    sea_scroll_speed:  .word 1
    sea_scroll_counter: .word 0
    SEA_SCROLL_RATE:   .word 3    # Cada 3 frames
    
    # Sistema de balas enemigas
    MAX_BULLETS:     .word 5
    BULLET_SIZE:     .word 3           # 3x3 para forma de cruz
    BULLET_SPEED:    .word 2           # Reducido a 2 (era 3)
    bullet_spawn_counter: .word 0
    BULLET_SPAWN_RATE:    .word 40
    
    # Sistema de aviones enemigos
    MAX_ENEMIES:     .word 3
    ENEMY_SIZE:      .word 9
    ENEMY_SPEED:     .word 1
    ENEMY_MOVE_RATE: .word 3
    enemy_spawn_counter: .word 0
    ENEMY_SPAWN_RATE:    .word 50
    ENEMY_SHOOT_RATE:    .word 30
    
    # Después de ENEMY_SHOOT_RATE
    ENEMY_TYPE_2_SIZE:   .word 11        # 11x11 (tamaño real del sprite)
    enemy_type_2_speed:  .word 1        # Misma velocidad
    enemy_spawn_count:   .word 0        # Contador de spawns
    SPAWN_TYPE_2_EVERY:  .word 5        # Cada 5 enemigos
    
    # Sistema de balas del jugador
    MAX_PLAYER_BULLETS: .word 10
    PLAYER_BULLET_WIDTH: .word 1
    PLAYER_BULLET_HEIGHT: .word 3
    PLAYER_BULLET_SPEED: .word 2
    player_can_shoot: .word 1
    
    # Sistema de vidas
    player_lives:    .word 3
    player_score:    .word 0
    POINTS_PER_KILL: .word 50
    game_over_flag:  .word 0
    invulnerable_counter: .word 0
    INVULNERABLE_TIME:    .word 60
    
    # Paleta de colores
    sea_colors:
    .word 0x000066CC
    .word 0x004499DD
    
    # Colores del avión del jugador
    plane_white:     .word 0x00FCFCFC    # Blanco (cuerpo)
    plane_gray:      .word 0x00BCBCBC    # Gris (sombras)
    plane_salmon:    .word 0x00FC7460    # Salmón (detalles)
    
    # Colores del cañón (bala enemiga)
    bullet_yellow:   .word 0x00F0BC3C    # Amarillo (bordes)
    bullet_red:      .word 0x00D82800    # Rojo (centro)
    
    # Color de bala del jugador
    player_bullet_yellow: .word 0x00F0BC3C  # Amarillo (punta)
    player_bullet_red:    .word 0x00D82800  # Rojo (cuerpo)
    
    # Color de enemigos (temporalmente rojo)
    enemy_gray_light: .word 0x00BCBCBC  # Gris claro (cuerpo)
    enemy_gray_dark:  .word 0x00747474  # Gris oscuro (sombras)
    enemy_red:        .word 0x00D82800  # Rojo (cabina)
    
    # Colores del enemigo tipo 2
    enemy2_green_light: .word 0x0080CF10  # Verde claro (cuerpo)
    enemy2_green_dark:  .word 0x00009300  # Verde oscuro (sombras)
    enemy2_red:         .word 0x00D82800  # Rojo (cabina)
    
    # Array de balas enemigas (cada bala son 5 words: active, x, y, old_x, old_y)
    .align 2
    bullet_0: .word 0, 0, 0, 0, 0
    bullet_1: .word 0, 0, 0, 0, 0
    bullet_2: .word 0, 0, 0, 0, 0
    bullet_3: .word 0, 0, 0, 0, 0
    bullet_4: .word 0, 0, 0, 0, 0
    
    # Array de aviones enemigos (active, x, y, old_x, old_y, shoot_counter, move_counter)
    .align 2
    enemy_0: .word 0, 0, 0, 0, 0, 0, 0, 0
    enemy_1: .word 0, 0, 0, 0, 0, 0, 0, 0
    enemy_2: .word 0, 0, 0, 0, 0, 0, 0, 0
    
    # Array de balas del jugador
    .align 2
    player_bullet_0: .word 0, 0, 0, 0, 0
    player_bullet_1: .word 0, 0, 0, 0, 0
    player_bullet_2: .word 0, 0, 0, 0, 0
    player_bullet_3: .word 0, 0, 0, 0, 0
    player_bullet_4: .word 0, 0, 0, 0, 0
    player_bullet_5: .word 0, 0, 0, 0, 0
    player_bullet_6: .word 0, 0, 0, 0, 0
    player_bullet_7: .word 0, 0, 0, 0, 0
    player_bullet_8: .word 0, 0, 0, 0, 0
    player_bullet_9: .word 0, 0, 0, 0, 0
    
    # Sprite de bala del jugador 1x3 (1=amarillo/punta, 2=rojo/cuerpo)
    .align 2
    player_bullet_sprite:
    .byte 1
    .byte 2
    .byte 2
    
    # Sprite del enemigo Kuro-Den 9x9 (0=transparente, 1=gris claro, 2=gris oscuro, 3=rojo)
    .align 2
    enemy_sprite:
    .byte 0,0,0,0,1,0,0,0,0
    .byte 0,0,1,1,2,2,1,0,0
    .byte 0,0,0,1,2,1,0,0,0
    .byte 0,0,0,0,1,0,0,0,0
    .byte 0,2,2,1,1,1,2,2,0
    .byte 1,1,1,1,3,1,1,1,1
    .byte 0,1,1,1,3,1,1,1,0
    .byte 0,0,0,1,1,1,0,0,0
    .byte 0,0,1,1,2,1,1,0,0
    
    # Sprite del enemigo tipo 2 (A2) 11x11 (0=transparente, 1=verde claro, 2=verde oscuro, 3=rojo)
    .align 2
    enemy2_sprite:
    .byte 0,0,0,0,0,1,0,0,0,0,0
    .byte 0,0,0,1,1,2,2,1,0,0,0
    .byte 0,0,0,1,1,2,1,0,0,0,0
    .byte 0,0,0,0,1,2,0,0,0,0,0
    .byte 0,0,0,0,1,0,0,0,0,0,0
    .byte 0,0,0,0,1,0,0,0,0,0,0
    .byte 0,0,0,2,1,1,2,0,0,0,0
    .byte 0,0,2,2,1,1,1,1,2,2,0
    .byte 0,1,1,1,1,3,3,1,2,1,2
    .byte 0,1,1,1,1,3,3,1,2,1,0
    .byte 0,0,1,1,1,3,3,1,1,1,0
    .byte 0,0,0,0,1,1,1,1,0,0,0
    .byte 0,0,0,2,1,1,1,2,0,0,0
    .byte 0,0,1,1,1,2,2,1,1,1,0
    
    # Sprite del cañón 3x3 (0=transparente, 1=amarillo, 2=rojo)
    .align 2
    bullet_sprite:
    .byte 0,1,0
    .byte 1,2,1
    .byte 0,1,0
    
    # Sprite del avión 12x8 (0=transparente, 1=gris, 2=blanco, 3=salmón) - escala 50%
    .align 2
    plane_sprite:
    .byte 0,0,0,0,0,1,0,0,0,0,0,0
    .byte 0,0,1,2,1,1,1,2,1,0,0,0
    .byte 0,0,1,2,0,3,0,2,1,0,0,0
    .byte 2,2,2,2,2,3,2,2,2,2,2,0
    .byte 0,1,2,1,1,2,1,1,2,1,0,0
    .byte 0,0,1,1,1,1,1,1,1,0,0,0
    .byte 0,0,0,2,0,0,0,2,0,0,0,0
    .byte 0,0,2,1,1,1,1,1,1,0,0,0
    
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
    msg_score:       .asciiz "Puntos: "
    msg_kill:        .asciiz "¡Enemigo Muerto!\n"
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
    
    li $v0, 4
    la $a0, msg_score
    syscall
    li $v0, 1
    lw $a0, player_score
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    jal draw_sea_full
    sw $zero, first_draw
    
    # Dibujar jugador al inicio
    jal draw_player_new
    
    # Spawn inicial de un enemigo para prueba
    la $t0, enemy_0
    li $t1, 1
    sw $t1, 0($t0)      # active
    li $t1, 30
    sw $t1, 4($t0)      # x = 30
    li $t1, 5
    sw $t1, 8($t0)      # y = 5
    sw $t1, 12($t0)     # old_x
    sw $t1, 16($t0)     # old_y
    li $t1, 29
    sw $t1, 20($t0)     # shoot_counter = 29 (disparará pronto)
    sw $zero, 24($t0)   # move_counter = 0
    
game_loop:
    lw $t0, game_over_flag
    bnez $t0, game_over
    
    jal scroll_sea
    jal process_input
    jal update_enemies
    jal spawn_enemy
    jal update_bullets
    jal update_player_bullets
    jal check_collisions
    jal check_bullet_enemy_collisions
    jal draw_player_smart
    jal draw_enemies
    jal draw_bullets
    jal draw_player_bullets
    jal update_invulnerability
    jal delay
    j game_loop

game_over:
    li $v0, 4
    la $a0, msg_game_over
    syscall
    
    # Mostrar puntaje final
    li $v0, 4
    la $a0, msg_score
    syscall
    li $v0, 1
    lw $a0, player_score
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 10
    syscall

# ===== SCROLL DEL MAR =====
scroll_sea:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Incrementar contador
    lw $t0, sea_scroll_counter
    addi $t0, $t0, 1
    sw $t0, sea_scroll_counter
    
    # Verificar si toca scrollear
    lw $t1, SEA_SCROLL_RATE
    blt $t0, $t1, scroll_done
    
    # Resetear contador
    sw $zero, sea_scroll_counter
    
    # Incrementar offset
    lw $t0, sea_scroll_offset
    lw $t1, sea_scroll_speed
    add $t0, $t0, $t1
    
    # Si llega a 16, resetear (tamaño del patrón)
    li $t2, 16
    blt $t0, $t2, scroll_save
    sub $t0, $t0, $t2
    
scroll_save:
    sw $t0, sea_scroll_offset
    
    # Redibujar mar completo con nuevo offset
    jal draw_sea_scrolling
    
    # Redibujar todos los elementos después del scroll
    jal draw_enemies
    jal draw_bullets
    jal draw_player_bullets
    jal draw_player_new

scroll_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR MAR CON SCROLL =====
draw_sea_scrolling:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t0, $gp
    la $t9, wave_pattern
    la $s7, sea_colors
    lw $s6, sea_scroll_offset
    
    li $t1, 0
    
sea_scroll_y_loop:
    li $t8, 64
    bge $t1, $t8, sea_scroll_done
    
    # Aplicar offset de scroll
    add $t7, $t1, $s6
    andi $t2, $t7, 0xF
    sll $t2, $t2, 5
    add $t3, $t9, $t2
    
    li $t4, 0
    
sea_scroll_x_loop:
    li $t8, 64
    bge $t4, $t8, sea_scroll_next_y
    
    andi $t5, $t4, 0x1F
    add $t6, $t3, $t5
    lb $t6, 0($t6)
    
    sll $t7, $t6, 2
    add $t7, $s7, $t7
    lw $t7, 0($t7)
    
    sw $t7, 0($t0)
    addi $t0, $t0, 4
    addi $t4, $t4, 1
    j sea_scroll_x_loop

sea_scroll_next_y:
    addi $t1, $t1, 1
    j sea_scroll_y_loop

sea_scroll_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

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
    li $t4, 59                  # Ajustado para 3x3
    bgt $t3, $t4, spawn_adjust
    j spawn_set_pos
    
spawn_adjust:
    li $t3, 59
    
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

# ===== GENERAR ENEMIGO =====
spawn_enemy:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, enemy_spawn_counter
    addi $t0, $t0, 1
    sw $t0, enemy_spawn_counter
    
    lw $t1, ENEMY_SPAWN_RATE
    blt $t0, $t1, spawn_enemy_done
    
    sw $zero, enemy_spawn_counter
    
    # Incrementar contador de spawns
    lw $t7, enemy_spawn_count
    addi $t7, $t7, 1
    sw $t7, enemy_spawn_count
    
    # Determinar tipo de enemigo
    lw $t8, SPAWN_TYPE_2_EVERY
    div $t7, $t8
    mfhi $t9                    # t9 = resto (0 si es múltiplo de 5)
    
    # Si resto == 0, spawner tipo 2, sino tipo 1
    li $s6, 0                   # s6 = tipo (0=normal, 1=tipo2)
    bnez $t9, spawn_type_normal
    li $s6, 1                   # Es tipo 2
    
spawn_type_normal:
    # Buscar slot libre
    la $t0, enemy_0
    lw $t1, 0($t0)
    beqz $t1, spawn_enemy_in_slot
    
    la $t0, enemy_1
    lw $t1, 0($t0)
    beqz $t1, spawn_enemy_in_slot
    
    la $t0, enemy_2
    lw $t1, 0($t0)
    beqz $t1, spawn_enemy_in_slot
    
    j spawn_enemy_done

spawn_enemy_in_slot:
    # Activar enemigo
    li $t2, 1
    sw $t2, 0($t0)
    
    # Posición X aleatoria
    li $v0, 30
    syscall
    move $t3, $a0
    andi $t3, $t3, 0x3F
    
    # Ajustar límites según tipo
    beqz $s6, spawn_normal_limits
    j spawn_type2_limits        # Saltar a los límites del tipo 2
    j spawn_check_limits
    
spawn_normal_limits:
    # Tipo 1: 9x9
    li $t4, 55
    j spawn_check_limits
    
spawn_type2_limits:
    # Tipo 2: 11x11
    li $t4, 53              # 64 - 11 = 53
    
spawn_check_limits:
    bgt $t3, $t4, spawn_enemy_adjust
    j spawn_enemy_set_pos
    
spawn_enemy_adjust:
    li $t3, 27
    
spawn_enemy_set_pos:
    sw $t3, 4($t0)      # x
    li $t4, 0
    sw $t4, 8($t0)      # y = 0
    sw $t3, 12($t0)     # old_x
    sw $t4, 16($t0)     # old_y
    li $t5, 0
    sw $t5, 20($t0)     # shoot_counter = 0
    sw $t5, 24($t0)     # move_counter = 0
    sw $s6, 28($t0)     # type (0 o 1)

spawn_enemy_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== ACTUALIZAR ENEMIGOS =====
update_enemies:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, enemy_0
    jal update_single_enemy
    
    la $t0, enemy_1
    jal update_single_enemy
    
    la $t0, enemy_2
    jal update_single_enemy
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

update_single_enemy:
    lw $t1, 0($t0)
    beqz $t1, update_enemy_end
    
    # Actualizar contador de movimiento
    lw $t7, 24($t0)
    addi $t7, $t7, 1
    sw $t7, 24($t0)
    
    # Verificar si debe moverse
    lw $t8, ENEMY_MOVE_RATE
    blt $t7, $t8, skip_enemy_move
    
    # Resetear contador de movimiento
    sw $zero, 24($t0)
    
    # Guardar posición anterior
    lw $t2, 4($t0)
    lw $t3, 8($t0)
    sw $t2, 12($t0)
    sw $t3, 16($t0)
    
    # Mover hacia abajo
    lw $t4, ENEMY_SPEED
    add $t3, $t3, $t4
    sw $t3, 8($t0)
    
skip_enemy_move:
    # Actualizar contador de disparo
    lw $t5, 20($t0)
    addi $t5, $t5, 1
    sw $t5, 20($t0)
    
    # Verificar si debe disparar
    lw $t6, ENEMY_SHOOT_RATE
    blt $t5, $t6, check_enemy_bounds
    
    # Resetear contador y disparar
    sw $zero, 20($t0)
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal enemy_shoot
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
check_enemy_bounds:
    # Desactivar si sale de pantalla
    lw $t3, 8($t0)
    lw $t7, SCREEN_HEIGHT
    bge $t3, $t7, deactivate_enemy
    jr $ra

deactivate_enemy:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    
    lw $a0, 12($t0)
    lw $a1, 16($t0)
    lw $a2, 28($t0)     # ? AGREGAR ESTA LÍNEA (pasar tipo)
    jal erase_enemy
    
    lw $t0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    
    sw $zero, 0($t0)
    jr $ra

update_enemy_end:
    jr $ra

# ===== ENEMIGO DISPARA =====
enemy_shoot:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Buscar slot libre para bala
    la $t1, bullet_0
    lw $t2, 0($t1)
    beqz $t2, enemy_shoot_in_slot
    
    la $t1, bullet_1
    lw $t2, 0($t1)
    beqz $t2, enemy_shoot_in_slot
    
    la $t1, bullet_2
    lw $t2, 0($t1)
    beqz $t2, enemy_shoot_in_slot
    
    la $t1, bullet_3
    lw $t2, 0($t1)
    beqz $t2, enemy_shoot_in_slot
    
    la $t1, bullet_4
    lw $t2, 0($t1)
    beqz $t2, enemy_shoot_in_slot
    
    j enemy_shoot_done

enemy_shoot_in_slot:
    # Activar bala
    li $t3, 1
    sw $t3, 0($t1)
    
    # Posición desde el enemigo
    lw $t4, 4($t0)      # enemy x
    lw $t5, 8($t0)      # enemy y
    
    # Centrar bala bajo el enemigo y dar espacio
    lw $t6, ENEMY_SIZE
    add $t5, $t5, $t6   # Y del enemigo + tamaño
    addi $t5, $t5, 2    # Agregar 2 píxeles más de separación
    
    # Centrar en X
    lw $t6, ENEMY_SIZE
    srl $t6, $t6, 1
    add $t4, $t4, $t6
    lw $t6, BULLET_SIZE
    srl $t6, $t6, 1
    sub $t4, $t4, $t6
    
    sw $t4, 4($t1)      # bullet x
    sw $t5, 8($t1)      # bullet y
    sw $t4, 12($t1)     # bullet old_x
    sw $t5, 16($t1)     # bullet old_y

enemy_shoot_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR ENEMIGOS =====
draw_enemies:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, enemy_0
    jal draw_single_enemy
    
    la $t0, enemy_1
    jal draw_single_enemy
    
    la $t0, enemy_2
    jal draw_single_enemy
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

draw_single_enemy:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t1, 0($t0)
    beqz $t1, draw_enemy_end
    
    # Verificar tipo de enemigo
    lw $t2, 28($t0)         # Cargar tipo
    
    # Borrar posición anterior
    lw $a0, 12($t0)
    lw $a1, 16($t0)
    move $a2, $t2           # Pasar tipo como argumento
    jal erase_enemy
    
    # Dibujar en nueva posición
    lw $a0, 4($t0)
    lw $a1, 8($t0)
    lw $a2, 28($t0)         # Pasar tipo
    jal draw_enemy_at

draw_enemy_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== BORRAR ENEMIGO =====
erase_enemy:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    move $s0, $a0
    move $s1, $a1
    
    # Determinar tamaño según tipo
    beqz $a2, erase_type_normal
    lw $s2, ENEMY_TYPE_2_SIZE   # Tipo 2: 1x1
    j erase_enemy_continue
    
erase_type_normal:
    lw $s2, ENEMY_SIZE          # Tipo 1: 9x9
    
erase_enemy_continue:
    la $s3, wave_pattern
    la $t9, sea_colors
    
    li $t5, 0
    
erase_enemy_y:
    bge $t5, $s2, erase_enemy_done_loop
    
    add $t8, $s1, $t5
    andi $t2, $t8, 0xF
    sll $t2, $t2, 5
    add $t3, $s3, $t2
    
    li $t6, 0
    
erase_enemy_x:
    bge $t6, $s2, erase_enemy_next_y
    
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
    j erase_enemy_x

erase_enemy_next_y:
    addi $t5, $t5, 1
    j erase_enemy_y

erase_enemy_done_loop:
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

draw_enemy_at:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Verificar tipo (viene en $a2)
    beqz $a2, draw_enemy_type_normal
    
    # ========== TIPO 2: Dibujar sprite verde ==========
    move $t0, $a0           # x position
    move $t1, $a1           # y position
    lw $t2, ENEMY_TYPE_2_SIZE    # 11
    
    la $s0, enemy2_sprite
    lw $s1, enemy2_green_light   # Verde claro
    lw $s2, enemy2_green_dark    # Verde oscuro
    lw $s3, enemy2_red           # Rojo
    
    li $t4, 0               # Y counter
    
draw_enemy2_y:
    bge $t4, $t2, draw_enemy_done_loop
    
    li $t5, 0               # X counter
    
draw_enemy2_x:
    bge $t5, $t2, draw_enemy2_next_y
    
    # Obtener índice del sprite (Y * 11 + X)
    # 11 = 8 + 2 + 1
    sll $t6, $t4, 3         # Y * 8
    sll $t7, $t4, 1         # Y * 2
    add $t6, $t6, $t7       # Y * 10
    add $t6, $t6, $t4       # Y * 11
    add $t6, $t6, $t5       # + X
    add $t7, $s0, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Si es 0, es transparente
    beqz $t7, skip_enemy2_pixel
    
    # Seleccionar color según valor
    li $t8, 1
    beq $t7, $t8, use_enemy2_light
    li $t8, 2
    beq $t7, $t8, use_enemy2_dark
    li $t8, 3
    beq $t7, $t8, use_enemy2_red
    j skip_enemy2_pixel
    
use_enemy2_light:
    move $t9, $s1
    j draw_enemy2_pixel
use_enemy2_dark:
    move $t9, $s2
    j draw_enemy2_pixel
use_enemy2_red:
    move $t9, $s3
    
draw_enemy2_pixel:
    add $s4, $t1, $t4
    sll $s4, $s4, 6
    add $s4, $s4, $t0
    add $s4, $s4, $t5
    sll $s4, $s4, 2
    add $s4, $gp, $s4
    
    sw $t9, 0($s4)
    
skip_enemy2_pixel:
    addi $t5, $t5, 1
    j draw_enemy2_x

draw_enemy2_next_y:
    addi $t4, $t4, 1
    j draw_enemy2_y
    
    # ========== TIPO 1: Dibujar sprite original ==========
draw_enemy_type_normal:
    move $t0, $a0
    move $t1, $a1
    lw $t2, ENEMY_SIZE
    
    la $s0, enemy_sprite
    lw $s1, enemy_gray_light
    lw $s2, enemy_gray_dark
    lw $s3, enemy_red
    
    li $t4, 0
    
draw_enemy_y:
    bge $t4, $t2, draw_enemy_done_loop
    
    li $t5, 0
    
draw_enemy_x:
    bge $t5, $t2, draw_enemy_next_y
    
    sll $t6, $t4, 3
    add $t6, $t6, $t4
    add $t6, $t6, $t5
    add $t7, $s0, $t6
    lb $t7, 0($t7)
    
    beqz $t7, skip_enemy_pixel
    
    li $t8, 1
    beq $t7, $t8, use_enemy_light
    li $t8, 2
    beq $t7, $t8, use_enemy_dark
    li $t8, 3
    beq $t7, $t8, use_enemy_red
    j skip_enemy_pixel
    
use_enemy_light:
    move $t9, $s1
    j draw_enemy_pixel
use_enemy_dark:
    move $t9, $s2
    j draw_enemy_pixel
use_enemy_red:
    move $t9, $s3
    
draw_enemy_pixel:
    add $s4, $t1, $t4
    sll $s4, $s4, 6
    add $s4, $s4, $t0
    add $s4, $s4, $t5
    sll $s4, $s4, 2
    add $s4, $gp, $s4
    
    sw $t9, 0($s4)
    
skip_enemy_pixel:
    addi $t5, $t5, 1
    j draw_enemy_x

draw_enemy_next_y:
    addi $t4, $t4, 1
    j draw_enemy_y

draw_enemy_done_loop:
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
    bge $t3, $t5, deactivate_bullet
    jr $ra

deactivate_bullet:
    # Borrar bala antes de desactivar
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    
    lw $a0, 12($t0)
    lw $a1, 16($t0)
    jal erase_bullet
    
    lw $t0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    
    sw $zero, 0($t0)
    jr $ra

update_bullet_end:
    jr $ra

# ===== DISPARAR BALA DEL JUGADOR =====
spawn_player_bullet:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Verificar si puede disparar
    lw $t0, player_can_shoot
    beqz $t0, spawn_player_done
    
    # Buscar slot libre
    la $t0, player_bullet_0
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_1
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_2
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_3
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_4
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_5
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_6
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_7
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_8
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    la $t0, player_bullet_9
    lw $t1, 0($t0)
    beqz $t1, spawn_player_in_slot
    
    j spawn_player_done

spawn_player_in_slot:
    # Activar bala
    li $t2, 1
    sw $t2, 0($t0)
    
    # Calcular posición (centro del avión)
    lw $t3, player_x
    lw $t4, PLAYER_SIZE
    srl $t4, $t4, 1         # ancho / 2
    add $t3, $t3, $t4
    lw $t5, PLAYER_BULLET_WIDTH
    srl $t5, $t5, 1         # bullet_width / 2
    sub $t3, $t3, $t5       # centrar
    
    lw $t4, player_y
    
    sw $t3, 4($t0)          # x
    sw $t4, 8($t0)          # y
    sw $t3, 12($t0)         # old_x
    sw $t4, 16($t0)         # old_y

spawn_player_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== ACTUALIZAR BALAS DEL JUGADOR =====
update_player_bullets:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, player_bullet_0
    jal update_single_player_bullet
    
    la $t0, player_bullet_1
    jal update_single_player_bullet
    
    la $t0, player_bullet_2
    jal update_single_player_bullet
    
    la $t0, player_bullet_3
    jal update_single_player_bullet
    
    la $t0, player_bullet_4
    jal update_single_player_bullet
    
    la $t0, player_bullet_5
    jal update_single_player_bullet
    
    la $t0, player_bullet_6
    jal update_single_player_bullet
    
    la $t0, player_bullet_7
    jal update_single_player_bullet
    
    la $t0, player_bullet_8
    jal update_single_player_bullet
    
    la $t0, player_bullet_9
    jal update_single_player_bullet
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

update_single_player_bullet:
    lw $t1, 0($t0)
    beqz $t1, update_player_bullet_end
    
    # Guardar posición anterior
    lw $t2, 4($t0)
    lw $t3, 8($t0)
    sw $t2, 12($t0)
    sw $t3, 16($t0)
    
    # Mover hacia arriba
    lw $t4, PLAYER_BULLET_SPEED
    sub $t3, $t3, $t4
    sw $t3, 8($t0)
    
    # Desactivar si sale de pantalla
    bltz $t3, deactivate_player_bullet
    jr $ra

deactivate_player_bullet:
    # Borrar bala antes de desactivar
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    
    lw $a0, 12($t0)
    lw $a1, 16($t0)
    jal erase_player_bullet
    
    lw $t0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    
    sw $zero, 0($t0)
    jr $ra

update_player_bullet_end:
    jr $ra

# ===== DIBUJAR BALAS DEL JUGADOR =====
draw_player_bullets:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, player_bullet_0
    jal draw_single_player_bullet
    
    la $t0, player_bullet_1
    jal draw_single_player_bullet
    
    la $t0, player_bullet_2
    jal draw_single_player_bullet
    
    la $t0, player_bullet_3
    jal draw_single_player_bullet
    
    la $t0, player_bullet_4
    jal draw_single_player_bullet
    
    la $t0, player_bullet_5
    jal draw_single_player_bullet
    
    la $t0, player_bullet_6
    jal draw_single_player_bullet
    
    la $t0, player_bullet_7
    jal draw_single_player_bullet
    
    la $t0, player_bullet_8
    jal draw_single_player_bullet
    
    la $t0, player_bullet_9
    jal draw_single_player_bullet
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

draw_single_player_bullet:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t1, 0($t0)
    beqz $t1, draw_single_player_end
    
    # Borrar posición anterior
    lw $a0, 12($t0)
    lw $a1, 16($t0)
    jal erase_player_bullet
    
    # Dibujar en nueva posición
    lw $a0, 4($t0)
    lw $a1, 8($t0)
    jal draw_player_bullet_at

draw_single_player_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== BORRAR BALA DEL JUGADOR =====
erase_player_bullet:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    move $s0, $a0
    move $s1, $a1
    lw $s2, PLAYER_BULLET_WIDTH
    lw $s3, PLAYER_BULLET_HEIGHT
    
    la $t8, wave_pattern
    la $t9, sea_colors
    
    li $t5, 0
    
erase_player_bullet_y:
    bge $t5, $s3, erase_player_bullet_done_loop
    
    add $t7, $s1, $t5
    andi $t2, $t7, 0xF
    sll $t2, $t2, 5
    add $t3, $t8, $t2
    
    li $t6, 0
    
erase_player_bullet_x:
    bge $t6, $s2, erase_player_bullet_next_y
    
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
    j erase_player_bullet_x

erase_player_bullet_next_y:
    addi $t5, $t5, 1
    j erase_player_bullet_y

erase_player_bullet_done_loop:
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# ===== DIBUJAR BALA DEL JUGADOR =====
draw_player_bullet_at:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t0, $a0           # x position
    move $t1, $a1           # y position
    lw $t2, PLAYER_BULLET_WIDTH   # 2
    lw $t3, PLAYER_BULLET_HEIGHT  # 6
    
    la $s0, player_bullet_sprite
    lw $s1, player_bullet_yellow  # Amarillo
    lw $s2, player_bullet_red     # Rojo
    
    li $t4, 0               # Y counter
    
draw_player_bullet_y:
    bge $t4, $t3, draw_player_bullet_done_loop
    
    li $t5, 0               # X counter
    
draw_player_bullet_x:
    bge $t5, $t2, draw_player_bullet_next_y
    
    # Obtener índice del sprite (Y * 1 + X)
    add $t6, $t4, $t5       # Y + X
    add $t7, $s0, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Seleccionar color según valor
    li $t8, 1
    beq $t7, $t8, use_player_yellow
    li $t8, 2
    beq $t7, $t8, use_player_red
    j skip_player_bullet_pixel
    
use_player_yellow:
    move $t9, $s1
    j draw_player_bullet_pixel
use_player_red:
    move $t9, $s2
    
draw_player_bullet_pixel:
    # Calcular offset en display
    add $s3, $t1, $t4       # Y total
    sll $s3, $s3, 6         # * 64
    add $s3, $s3, $t0       # + X base
    add $s3, $s3, $t5       # + X offset
    sll $s3, $s3, 2         # * 4
    add $s3, $gp, $s3
    
    sw $t9, 0($s3)
    
skip_player_bullet_pixel:
    addi $t5, $t5, 1
    j draw_player_bullet_x

draw_player_bullet_next_y:
    addi $t4, $t4, 1
    j draw_player_bullet_y

draw_player_bullet_done_loop:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DETECTAR COLISIONES =====
check_collisions:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, invulnerable_counter
    bnez $t0, collision_done
    
    lw $t0, player_x
    lw $t1, player_y
    
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
    
    # AABB collision detection (usar PLAYER_SIZE para ancho)
    lw $t2, PLAYER_SIZE
    add $t8, $t0, $t2   # player_right
    blt $t8, $t5, check_bullet_end
    
    add $t9, $t5, $t7   # bullet_right
    blt $t9, $t0, check_bullet_end
    
    lw $t2, PLAYER_HEIGHT
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

# ===== DETECTAR COLISIONES BALA-ENEMIGO =====
check_bullet_enemy_collisions:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Verificar bullet_0
    la $a0, player_bullet_0
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_0
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_0
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_1
    la $a0, player_bullet_1
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_1
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_1
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_2
    la $a0, player_bullet_2
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_2
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_2
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_3
    la $a0, player_bullet_3
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_3
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_3
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_4
    la $a0, player_bullet_4
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_4
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_4
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_5
    la $a0, player_bullet_5
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_5
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_5
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_6
    la $a0, player_bullet_6
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_6
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_6
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_7
    la $a0, player_bullet_7
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_7
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_7
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_8
    la $a0, player_bullet_8
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_8
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_8
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    # Verificar bullet_9
    la $a0, player_bullet_9
    la $a1, enemy_0
    jal test_bullet_hit_enemy
    la $a0, player_bullet_9
    la $a1, enemy_1
    jal test_bullet_hit_enemy
    la $a0, player_bullet_9
    la $a1, enemy_2
    jal test_bullet_hit_enemy
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

test_bullet_hit_enemy:
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $t0, 12($sp)
    sw $t1, 16($sp)
    sw $t2, 20($sp)
    sw $t3, 24($sp)
    sw $t8, 28($sp)
    
    move $t8, $a0           # bullet pointer
    move $t9, $a1           # enemy pointer
    
    # Verificar si bala está activa
    lw $t0, 0($t8)
    beqz $t0, test_end
    
    # Verificar si enemigo está activo
    lw $t0, 0($t9)
    beqz $t0, test_end
    
    # Obtener posiciones
    lw $t0, 4($t8)          # bullet_x
    lw $t1, 8($t8)          # bullet_y
    lw $t2, 4($t9)          # enemy_x
    lw $t3, 8($t9)          # enemy_y
    
    # Calcular límites
    lw $t4, PLAYER_BULLET_WIDTH
    add $t4, $t0, $t4       # bullet_right
    
    # Obtener tamaño según tipo
    lw $t7, 28($t9)         # Cargar tipo de enemigo
    beqz $t7, collision_normal_size
    lw $t5, ENEMY_TYPE_2_SIZE
    j collision_calc_right

collision_normal_size:
    lw $t5, ENEMY_SIZE

collision_calc_right:
    add $t5, $t2, $t5       # enemy_right
    
    # Colisión en X?
    blt $t4, $t2, test_end  # bullet_right < enemy_left
    blt $t5, $t0, test_end  # enemy_right < bullet_left
    
    # Calcular límites Y
    lw $t4, PLAYER_BULLET_HEIGHT
    add $t4, $t1, $t4       # bullet_bottom
    
    # Calcular límites Y
    lw $t4, PLAYER_BULLET_HEIGHT
    add $t4, $t1, $t4       # bullet_bottom

    # Obtener tamaño según tipo para Y
    lw $t7, 28($t9)
    beqz $t7, collision_normal_size_y
    lw $t5, ENEMY_TYPE_2_SIZE
    j collision_calc_bottom

collision_normal_size_y:
    lw $t5, ENEMY_SIZE

collision_calc_bottom:
    add $t5, $t3, $t5       # enemy_bottom
    
    # Colisión en Y?
    blt $t4, $t3, test_end  # bullet_bottom < enemy_top
    blt $t5, $t1, test_end  # enemy_bottom < bullet_top
    
    # ¡HAY COLISIÓN!
    # Guardar punteros antes de borrar
    addi $sp, $sp, -8
    sw $t8, 0($sp)
    sw $t9, 4($sp)
    
    # Sumar puntos según tipo de enemigo
    lw $t6, player_score
    lw $s5, 28($t9)          # Cargar tipo de enemigo
    beqz $s5, points_type_normal

    # Tipo 2: 100 puntos
    li $t7, 100
    j add_points

points_type_normal:
    # Tipo 1: 50 puntos
    lw $t7, POINTS_PER_KILL

add_points:
    add $t6, $t6, $t7
    sw $t6, player_score
    
    # Mostrar mensaje de puntos
    li $v0, 4
    la $a0, msg_kill
    syscall
    
    # Mostrar puntaje actualizado
    li $v0, 4
    la $a0, msg_score
    syscall
    li $v0, 1
    lw $a0, player_score
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    # Borrar enemigo
    lw $a0, 12($t9)
    lw $a1, 16($t9)
    lw $a2, 28($t9)     # ? AGREGAR ESTA LÍNEA
    jal erase_enemy
    
    # Restaurar punteros
    lw $t9, 4($sp)
    lw $t8, 0($sp)
    
    # Desactivar enemigo
    sw $zero, 0($t9)
    
    # Borrar bala
    lw $a0, 12($t8)
    lw $a1, 16($t8)
    jal erase_player_bullet
    
    # Restaurar punteros de nuevo
    lw $t9, 4($sp)
    lw $t8, 0($sp)
    addi $sp, $sp, 8
    
    # Desactivar bala
    sw $zero, 0($t8)

test_end:
    lw $t8, 28($sp)
    lw $t3, 24($sp)
    lw $t2, 20($sp)
    lw $t1, 16($sp)
    lw $t0, 12($sp)
    lw $a1, 8($sp)
    lw $a0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 32
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
    
    move $t0, $a0           # x position
    move $t1, $a1           # y position
    lw $t2, BULLET_SIZE     # 4x4
    
    la $s0, bullet_sprite   # Sprite data
    lw $s1, bullet_yellow   # Amarillo
    lw $s2, bullet_red      # Rojo
    
    li $t4, 0               # Y counter
    
draw_bullet_y:
    bge $t4, $t2, draw_bullet_done_loop
    
    li $t5, 0               # X counter
    
draw_bullet_x:
    bge $t5, $t2, draw_bullet_next_y
    
    # Obtener índice del sprite (Y * 3 + X)
    sll $t6, $t4, 1         # Y * 2
    add $t6, $t6, $t4       # Y * 3
    add $t6, $t6, $t5       # + X
    add $t7, $s0, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Si es 0, es transparente (no dibujar)
    beqz $t7, skip_bullet_pixel
    
    # Seleccionar color según valor
    li $t8, 1
    beq $t7, $t8, use_bullet_yellow
    li $t8, 2
    beq $t7, $t8, use_bullet_red
    j skip_bullet_pixel
    
use_bullet_yellow:
    move $t3, $s1
    j draw_bullet_pixel
use_bullet_red:
    move $t3, $s2
    
draw_bullet_pixel:
    # Calcular offset en display
    add $t6, $t1, $t4       # Y total
    sll $t6, $t6, 6         # * 64
    add $t6, $t6, $t0       # + X base
    add $t6, $t6, $t5       # + X offset
    sll $t6, $t6, 2         # * 4
    add $t6, $gp, $t6
    
    sw $t3, 0($t6)
    
skip_bullet_pixel:
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
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s7, 4($sp)
    
    lw $t0, player_x_old
    lw $t1, player_y_old
    lw $t9, PLAYER_SIZE      # ancho = 12
    lw $s7, PLAYER_HEIGHT    # alto = 8
    
    la $s6, wave_pattern
    la $s5, sea_colors
    
    li $t5, 0
    
erase_y_loop:
    bge $t5, $s7, erase_done
    
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
    add $s3, $s5, $s3
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
    lw $s7, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

# ===== DIBUJAR JUGADOR EN NUEVA POSICIÓN =====
draw_player_new:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s7, 4($sp)
    
    lw $t0, player_x
    lw $t1, player_y
    lw $t9, PLAYER_SIZE      # ancho = 12
    lw $s7, PLAYER_HEIGHT    # alto = 8
    
    la $s0, plane_sprite
    lw $s1, plane_gray       # Gris
    lw $s2, plane_white      # Blanco
    lw $s3, plane_salmon     # Salmón
    
    li $t5, 0                # Y counter
    
new_y_loop:
    bge $t5, $s7, new_done
    
    li $t6, 0                # X counter
    
new_x_loop:
    bge $t6, $t9, new_next_row
    
    # Obtener índice del sprite (Y * 12 + X)
    sll $t7, $t5, 3         # Y * 8
    sll $a3, $t5, 2         # Y * 4
    add $t7, $t7, $a3       # Y * 12
    add $t7, $t7, $t6
    add $t8, $s0, $t7
    lb $t8, 0($t8)           # Valor del pixel en sprite
    
    # Si es 0, es transparente (no dibujar)
    beqz $t8, skip_pixel
    
    # Seleccionar color según valor
    li $a0, 1
    beq $t8, $a0, use_gray
    li $a0, 2
    beq $t8, $a0, use_white
    li $a0, 3
    beq $t8, $a0, use_salmon
    j skip_pixel
    
use_gray:
    move $a1, $s1
    j draw_pixel
use_white:
    move $a1, $s2
    j draw_pixel
use_salmon:
    move $a1, $s3
    
draw_pixel:
    # Calcular offset en display
    add $a2, $t1, $t5        # Y total
    sll $a2, $a2, 6          # * 64
    add $a2, $a2, $t0        # + X base
    add $a2, $a2, $t6        # + X offset
    sll $a2, $a2, 2          # * 4
    add $a2, $gp, $a2
    
    sw $a1, 0($a2)
    
skip_pixel:
    addi $t6, $t6, 1
    j new_x_loop

new_next_row:
    addi $t5, $t5, 1
    j new_y_loop

new_done:
    lw $s7, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
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
    li $t3, 106
    beq $t2, $t3, shoot
    li $t3, 74
    beq $t2, $t3, shoot
    j no_input

shoot:
    jal spawn_player_bullet
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
    lw $t3, PLAYER_HEIGHT
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
