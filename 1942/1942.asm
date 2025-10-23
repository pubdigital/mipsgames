# Game 1942 - Version 4.0 

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
    
    # Sistema del portaaviones
    carrier_visible:      .word 1
    carrier_y_offset:     .word 16
    CARRIER_HEIGHT:       .word 48
    CARRIER_SCROLL_SPEED: .word 1
    
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
    
    # Sistema de Power-Up
pow_active:          .word 0        # Si hay un POW en pantalla
pow_x:               .word 0
pow_y:               .word 0
pow_old_x:           .word 0
pow_old_y:           .word 0
POW_SIZE:            .word 7        # 7x7 p�xeles
POW_SPEED:           .word 1        # Velocidad de ca�da
pow_move_counter:    .word 0
POW_MOVE_RATE:       .word 5        # Se mueve cada 2 frames
pow_spawn_counter:   .word 0        # Contador de enemigos para spawn
POW_SPAWN_EVERY:     .word 5       # Cada 20 enemigos

# Sistema de doble disparo
double_shot_active:  .word 0        # Si el power-up est� activo
double_shot_ammo:    .word 0        # Disparos restantes con doble bala
    
    ENEMY_HORIZONTAL_SPEED: .word 1
    ENEMY_DIRECTION_CHANGE_RATE: .word 10   # Cada 60 frames cambia direcci�n
    
    # Despu�s de ENEMY_SHOOT_RATE
    ENEMY_TYPE_2_SIZE:   .word 9        # 11x11 (tama�o real del sprite)
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
    game_won_flag:   .word 0
    
    # Sistema de Barco Final
    final_ship_active:     .word 0
    final_ship_y_offset:   .word -48     # Empieza arriba (fuera de pantalla, negativo)
    final_ship_scroll_speed: .word 1     # Velocidad de aparici�n
    game_timer:            .word 0       
    FINAL_SHIP_TRIGGER:    .word 600
    
    # Sistema de Boss Final
    boss_active:         .word 0
    boss_x:              .word 18           # Centrado (64-27)/2 ? 18
    boss_y:              .word -27          # Empieza arriba (fuera de pantalla)
    boss_old_x:          .word 18
    boss_old_y:          .word -27
    boss_health:         .word 15           # 15 golpes para matarlo
    BOSS_MAX_HEALTH:     .word 15
    BOSS_SIZE:           .word 27
    BOSS_MOVE_SPEED:     .word 1
    boss_move_counter:   .word 0
    BOSS_MOVE_RATE:      .word 5            # Se mueve cada 5 frames
    boss_direction:      .word 1            # 1=derecha, -1=izquierda
    BOSS_POINTS:         .word 1000
    boss_shoot_counter:  .word 0
    BOSS_SHOOT_RATE:     .word 60            # Dispara cada 25 frames

    # Colores del boss
    boss_green_light:    .word 0x00AA00     # Verde claro
    boss_green_dark:     .word 0x005000     # Verde oscuro  
    boss_white:          .word 0xFFFFFF     # Blanco (h�lices)
    
    # Colores del HUD
    hud_white:       .word 0x00FFFFFF  # Blanco (n�meros)
    hud_red:         .word 0x00FF0000  # Rojo (corazones)
    hud_black:       .word 0x00000000  # Negro (contorno)
    
    # Paleta de colores
    sea_colors:
    .word 0x000066CC
    .word 0x004499DD
    
    carrier_gray:       .word 0x00627070  # Gris (cuerpo)
    carrier_light_gray: .word 0x009D9D9D  # Gris claro (l�neas)
    carrier_black:      .word 0x00000000  # Negro (detalles)
    
    # Colores del avi�n del jugador
    plane_white:     .word 0x00FCFCFC    # Blanco (cuerpo)
    plane_gray:      .word 0x00BCBCBC    # Gris (sombras)
    plane_salmon:    .word 0x00FC7460    # Salm�n (detalles)
    
    # Colores del ca��n (bala enemiga)
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
    
    # Colores del enemigo tipo 3
    enemy3_yellow:      .word 0x00F0BC3C  # Amarillo (cuerpo)
    enemy3_red:         .word 0x00D82800  # Rojo (detalles)
    enemy3_white:       .word 0x00FCFCFC  # Blanco (cabina)
    
    # Colores del power-up POW
pow_green_light:  .word 0x0080D010  # Verde claro (relleno)
pow_green_dark:   .word 0x00009400  # Verde oscuro (contorno)

    # Sprites de n�meros 3x5 (0=transparente, 1=blanco)
    .align 2
    digit_0:
    .byte 1,1,1
.byte 1,0,1
.byte 1,0,1
.byte 1,0,1
.byte 1,1,1

.align 2
digit_1:
.byte 0,1,0
.byte 1,1,0
.byte 0,1,0
.byte 0,1,0
.byte 1,1,1

.align 2
digit_2:
.byte 1,1,1
.byte 0,0,1
.byte 1,1,1
.byte 1,0,0
.byte 1,1,1

.align 2
digit_3:
.byte 1,1,1
.byte 0,0,1
.byte 1,1,1
.byte 0,0,1
.byte 1,1,1

.align 2
digit_4:
.byte 1,0,1
.byte 1,0,1
.byte 1,1,1
.byte 0,0,1
.byte 0,0,1

.align 2
digit_5:
.byte 1,1,1
.byte 1,0,0
.byte 1,1,1
.byte 0,0,1
.byte 1,1,1

.align 2
digit_6:
.byte 1,1,1
.byte 1,0,0
.byte 1,1,1
.byte 1,0,1
.byte 1,1,1

.align 2
digit_7:
.byte 1,1,1
.byte 0,0,1
.byte 0,1,0
.byte 0,1,0
.byte 0,1,0

.align 2
digit_8:
.byte 1,1,1
.byte 1,0,1
.byte 1,1,1
.byte 1,0,1
.byte 1,1,1

.align 2
digit_9:
.byte 1,1,1
.byte 1,0,1
.byte 1,1,1
.byte 0,0,1
.byte 1,1,1
    
    # Sprite del coraz�n 7x7 (0=transparente, 1=rojo)
    # Sprite del coraz�n 5x5 (0=transparente, 1=rojo)
.align 2
heart_sprite:
.byte 1,1,0,1,1
.byte 1,1,1,1,1
.byte 0,1,1,1,0
.byte 0,0,1,0,0
.byte 0,0,0,0,0
    
    # Tabla de punteros a sprites de d�gitos
   .align 2
   digit_table:
   .word digit_0, digit_1, digit_2, digit_3, digit_4
   .word digit_5, digit_6, digit_7, digit_8, digit_9
    
    # Array de balas enemigas (cada bala son 5 words: active, x, y, old_x, old_y)
    .align 4
    bullet_0: .word 0, 0, 0, 0, 0
    .align 4
    bullet_1: .word 0, 0, 0, 0, 0
    .align 4
    bullet_2: .word 0, 0, 0, 0, 0
    .align 4
    bullet_3: .word 0, 0, 0, 0, 0
    .align 4
    bullet_4: .word 0, 0, 0, 0, 0
    
    # Array de aviones enemigos (active, x, y, old_x, old_y, shoot_counter, move_counter)
    .align 2
    enemy_0: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
    .align 2
    enemy_1: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
    .align 2
    enemy_2: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
    
    # Array de balas del jugador
    .align 4
    player_bullet_0: .word 0, 0, 0, 0, 0
    .align 4
    player_bullet_1: .word 0, 0, 0, 0, 0
    .align 4
    player_bullet_2: .word 0, 0, 0, 0, 0
    .align 4
    player_bullet_3: .word 0, 0, 0, 0, 0
    .align 4
    player_bullet_4: .word 0, 0, 0, 0, 0
    .align 4
    player_bullet_5: .word 0, 0, 0, 0, 0
    .align 4
    player_bullet_6: .word 0, 0, 0, 0, 0
    .align 4
    player_bullet_7: .word 0, 0, 0, 0, 0
    .align 4
    player_bullet_8: .word 0, 0, 0, 0, 0
    .align 4
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
    
    # Sprite del enemigo tipo 2 (A2) 9x9 (0=transparente, 1=verde claro, 2=verde oscuro, 3=rojo)
    .align 2
    enemy2_sprite:
    .byte 0,0,0,0,1,0,0,0,0
    .byte 0,0,1,1,2,2,1,0,0
    .byte 0,0,0,1,2,1,0,0,0
    .byte 0,0,0,0,1,0,0,0,0
    .byte 0,2,2,1,1,1,2,2,0
    .byte 1,1,1,1,3,1,1,1,1
    .byte 0,1,1,1,3,1,1,1,0
    .byte 0,0,0,1,1,1,0,0,0
    .byte 0,0,1,1,2,1,1,0,0
    
    # Sprite del enemigo tipo 3 (KDK2) 9x9 (0=transparente, 1=amarillo, 2=rojo, 3=blanco)
    .align 2
    enemy3_sprite:
    .byte 0,0,0,0,1,0,0,0,0
    .byte 0,0,1,1,2,2,1,0,0
    .byte 0,0,0,1,2,1,0,0,0
    .byte 0,0,0,0,1,0,0,0,0
    .byte 0,2,2,1,1,1,2,2,0
    .byte 1,1,1,1,3,1,1,1,1
    .byte 0,1,1,1,3,1,1,1,0
    .byte 0,0,0,1,1,1,0,0,0
    .byte 0,0,1,1,2,1,1,0,0
    
     # Sprite del POW 7x7 - Estrella cruz
.align 2
pow_sprite:
.byte 0,0,0,2,0,0,0
.byte 0,0,2,2,2,0,0
.byte 0,2,1,2,1,2,0
.byte 2,2,2,1,2,2,2
.byte 0,2,1,2,1,2,0
.byte 0,0,2,2,2,0,0
.byte 0,0,0,2,0,0,0
    
    # Sprite del Boss 27x27 (0=transparente, 1=verde claro, 2=verde oscuro, 3=blanco)
    # Sprite del Boss 27x27 (0=transparente, 1=verde claro, 2=verde oscuro, 3=blanco)
.align 2
boss_sprite:
.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,0,0,0,0,0,0
.byte 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,0,0,0,0,0,0
.byte 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,1,1,1,2,2,2,1,1,1,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,1,1,1,2,2,2,1,1,1,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,1,1,1,2,2,2,1,1,1,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,0,0,0
.byte 0,0,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,0,0,0
.byte 0,0,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,0,0,0
.byte 1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1
.byte 0,0,1,1,1,1,1,1,1,1,1,1,3,3,3,1,1,1,1,1,1,1,1,1,0,0,0
.byte 0,0,1,1,1,1,1,1,1,1,1,1,3,3,3,1,1,1,1,1,1,1,1,1,0,0,0
.byte 0,0,1,1,1,1,1,1,1,1,1,1,3,3,3,1,1,1,1,1,1,1,1,1,0,0,0
.byte 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,0,0,0,0,0,0
.byte 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,0,0,0,0,0,0
.byte 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,0,0,0,0,0,0
    
    # Sprite del portaaviones 32x48 (0=mar, 1=gris, 2=gris claro, 3=negro)
    .align 2
    carrier_sprite:
    # Fila 0-5: Torre de control (parte superior)
    .byte 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,1,1,3,3,1,1,3,3,1,1,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0

     # Fila 6-11: Cubierta superior
     .byte 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
     .byte 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
     .byte 0,0,0,0,0,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,0,0,0,0,0,0,0
     .byte 0,0,0,0,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0,0,0,0,0,0
     .byte 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
     .byte 0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0

     # Fila 12-23: Cubierta principal con l�neas de aterrizaje
     .byte 0,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,0,0
     .byte 0,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,0,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0

     # Fila 24-35: Cubierta media
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,0
     .byte 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
     .byte 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0

     # Fila 36-47: Casco inferior
     .byte 0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
     .byte 0,0,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,0,0,0
     .byte 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
     .byte 0,0,0,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,0,0,0,0
     .byte 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
     .byte 0,0,0,0,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,0,0,0,0,0
     .byte 0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
     .byte 0,0,0,0,0,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,0,0,0,0,0,0
     .byte 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
     .byte 0,0,0,0,0,0,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,0,0,0,0,0,0,0
     .byte 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
     .byte 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
    .align 2
    	
    
    # Sprite del ca��n 3x3 (0=transparente, 1=amarillo, 2=rojo)
    .align 2
    bullet_sprite:
    .byte 0,1,0
    .byte 1,2,1
    .byte 0,1,0
    
    # Sprite del avi�n 12x8 (0=transparente, 1=gris, 2=blanco, 3=salm�n) - escala 50%
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
    msg_kill:        .asciiz "�Enemigo Muerto!\n"
    msg_game_over:   .asciiz "\n*** GAME OVER ***\n"
    msg_victory:     .asciiz "\n*** �VICTORIA! Has llegado al portaaviones final! ***\n"
    msg_final_ship:  .asciiz "\n�Portaaviones final a la vista!\n"
    msg_boss_appears: .asciiz "\n�BOSS FINAL DETECTADO!\n"
    msg_boss_defeated: .asciiz "\n�BOSS DERROTADO!\n"
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
    jal draw_carrier
    sw $zero, first_draw
    
    # Dibujar jugador al inicio
    jal draw_player_new
    
    # DIBUJAR HUD AL INICIO
    jal draw_hud
    
game_loop:
    lw $t0, game_over_flag
    bnez $t0, game_over
    
    lw $t0, game_won_flag
    bnez $t0, game_victory
    
    # Incrementar timer del juego
    lw $t0, game_timer
    addi $t0, $t0, 1
    sw $t0, game_timer
    
    # Verificar si activar boss final
    lw $t1, FINAL_SHIP_TRIGGER
    blt $t0, $t1, continue_normal_game
    
    # Activar boss si no est� activo y no fue derrotado
    lw $t2, boss_active
    bnez $t2, continue_normal_game
    
    lw $t3, boss_health
    bnez $t3, activate_boss    # Si tiene vida, activar
    
    # Si boss fue derrotado (health=0), activar barco final
    lw $t4, final_ship_active
    bnez $t4, continue_normal_game
    
    li $t4, 1
    sw $t4, final_ship_active
    
    li $v0, 4
    la $a0, msg_final_ship
    syscall
    j continue_normal_game
    
activate_boss:
    li $t2, 1
    sw $t2, boss_active
    
    li $v0, 4
    la $a0, msg_boss_appears
    syscall

continue_normal_game:
    jal scroll_sea
    jal process_input
    
    # SIEMPRE actualizar enemigos y balas (incluso con boss)
    jal update_enemies
    jal update_bullets
    
    # Actualizar power-up
    jal update_pow
    
    # Actualizar boss si est� activo
    lw $t0, boss_active
    beqz $t0, no_boss_active
    jal update_boss
    j skip_enemy_spawn
    
no_boss_active:
    # Solo spawnear nuevos enemigos si boss Y barco final NO est�n activos
    lw $t0, final_ship_active
    bnez $t0, skip_enemy_spawn
    jal spawn_enemy
    
skip_enemy_spawn:
    
    jal update_player_bullets
    jal check_collisions
    jal check_bullet_enemy_collisions
    
    # Actualizar power-up
    jal update_pow
    
    # Actualizar y dibujar barco final si est� activo
    lw $t0, final_ship_active
    beqz $t0, skip_final_ship
    jal update_final_ship
    jal draw_final_ship
skip_final_ship:
    
    jal draw_enemies
    jal draw_bullets
    jal draw_player_bullets
    
    # Dibujar power-up
    jal draw_pow
    
    # DIBUJAR BOSS AL FINAL (encima de todo)
    lw $t0, boss_active
    beqz $t0, skip_boss_draw
    jal draw_boss
skip_boss_draw:
    
    jal draw_player_new
    
    # DIBUJAR HUD (lo �ltimo, encima de todo)
    jal draw_hud
    
    jal delay
    j game_loop

game_victory:
    li $v0, 4
    la $a0, msg_victory
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
    
    # Si llega a 16, resetear (tama�o del patr�n)
    li $t2, 16
    blt $t0, $t2, scroll_save
    sub $t0, $t0, $t2
    
scroll_save:
    sw $t0, sea_scroll_offset
    
    # Mover el portaaviones hacia abajo
    lw $t0, carrier_visible
    beqz $t0, scroll_redraw
    
    lw $t1, carrier_y_offset
    lw $t2, CARRIER_SCROLL_SPEED
    add $t1, $t1, $t2
    sw $t1, carrier_y_offset
    
scroll_redraw:
    # Redibujar mar completo con nuevo offset
    jal draw_sea_scrolling
    
    # Redibujar portaaviones si sigue visible
    jal draw_carrier

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
    
    # Posici�n X aleatoria
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
    # Tipo 3 (amarillo): cada 15 enemigos (spawn_count % 15 == 0)
    # Tipo 2 (verde): cada 5 enemigos (spawn_count % 5 == 0 y no m�ltiplo de 15)
    # Tipo 1 (gris): resto
    
    li $s6, 0                   # s6 = tipo (0=normal, 1=verde, 2=amarillo)
    
    # Verificar si es m�ltiplo de 15 (tipo 3)
    li $t8, 15
    div $t7, $t8
    mfhi $t9                    # t9 = resto
    beqz $t9, spawn_type_3      # Si resto == 0, es tipo 3
    
    # Verificar si es m�ltiplo de 5 (tipo 2)
    li $t8, 5
    div $t7, $t8
    mfhi $t9                    # t9 = resto
    beqz $t9, spawn_type_2      # Si resto == 0, es tipo 2
    
    # Si no, es tipo 1 (normal)
    j spawn_type_normal

spawn_type_3:
    li $s6, 2                   # Tipo 3 (amarillo)
    j spawn_find_slot

spawn_type_2:
    li $s6, 1                   # Tipo 2 (verde)
    j spawn_find_slot
    
spawn_type_normal:
    li $s6, 0                   # Tipo 1 (gris)
    
spawn_find_slot:
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
    
    # GUARDAR $t0 (puntero del enemigo) antes de trabajar con POW
    move $s7, $t0           # <-- GUARDAR AQU�
    
    # Incrementar contador de power-up
    lw $t8, pow_spawn_counter
    addi $t8, $t8, 1
    sw $t8, pow_spawn_counter
    
    # Verificar si spawear POW
    lw $t9, POW_SPAWN_EVERY
    bne $t8, $t9, skip_pow_spawn
    
    # Resetear contador
    sw $zero, pow_spawn_counter
    
    # Spawear POW si no hay uno activo
    lw $a3, pow_active
    bnez $a3, skip_pow_spawn
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal spawn_pow
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
skip_pow_spawn:
    # RESTAURAR $t0 (puntero del enemigo)
    move $t0, $s7           # <-- RESTAURAR AQU�
    
    # Posici�n X aleatoria
    li $v0, 30
    syscall
    move $t3, $a0
    andi $t3, $t3, 0x3F
    
    # L�mite para enemigos 9x9
    li $t4, 55              # 64 - 9 = 55
    bgt $t3, $t4, spawn_center_enemy
    j spawn_set_enemy_pos
    
spawn_center_enemy:
    li $t3, 27              # Centrar
    
spawn_set_enemy_pos:
    sw $t3, 4($t0)      # x
    li $t4, 0
    sw $t4, 8($t0)      # y = 0
    sw $t3, 12($t0)     # old_x = x
    sw $t4, 16($t0)     # old_y = 0
    sw $zero, 20($t0)   # shoot_counter = 0
    sw $zero, 24($t0)   # move_counter = 0
    sw $s6, 28($t0)     # type (0, 1, o 2)
    
    # Direcci�n horizontal aleatoria
    li $v0, 30
    syscall
    move $t5, $a0
    andi $t5, $t5, 0x3       # 0, 1, 2, o 3
    
    # Convertir a -1, 0, o 1
    li $t6, 2
    beq $t5, $t6, set_direction_left
    li $t6, 3
    beq $t5, $t6, set_direction_right
    # Si es 0 o 1, no moverse horizontalmente
    sw $zero, 32($t0)
    j spawn_enemy_done
    
set_direction_left:
    li $t6, -1
    sw $t6, 32($t0)
    j spawn_enemy_done
    
set_direction_right:
    li $t6, 1
    sw $t6, 32($t0)
    
spawn_enemy_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
    
# ===== SPAWEAR POWER-UP POW =====
spawn_pow:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Activar POW
    li $t0, 1
    sw $t0, pow_active
    
    # Posici�n X aleatoria
    li $v0, 30
    syscall
    move $t1, $a0
    andi $t1, $t1, 0x3F     # 0-63
    
    # Ajustar para que quepa (64 - 7 = 57)
    li $t2, 57
    bgt $t1, $t2, pow_center
    j pow_set_pos
    
pow_center:
    li $t1, 28              # Centrar
    
pow_set_pos:
    sw $t1, pow_x
    sw $t1, pow_old_x
    li $t3, 0
    sw $t3, pow_y
    sw $t3, pow_old_y
    sw $zero, pow_move_counter
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== ACTUALIZAR POWER-UP POW =====
update_pow:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, pow_active
    beqz $t0, update_pow_done
    
    # Incrementar contador de movimiento
    lw $t1, pow_move_counter
    addi $t1, $t1, 1
    sw $t1, pow_move_counter
    
    # Verificar si debe moverse
    lw $t2, POW_MOVE_RATE
    blt $t1, $t2, update_pow_done
    
    # Resetear contador
    sw $zero, pow_move_counter
    
    # Guardar posici�n anterior
    lw $t3, pow_x
    lw $t4, pow_y
    sw $t3, pow_old_x
    sw $t4, pow_old_y
    
    # Mover hacia abajo
    lw $t5, POW_SPEED
    add $t4, $t4, $t5
    sw $t4, pow_y
    
    # Verificar si sale de pantalla
    lw $t6, SCREEN_HEIGHT
    bge $t4, $t6, deactivate_pow
    
    # Verificar colisi�n con jugador
    jal check_pow_collision
    j update_pow_done

deactivate_pow:
    # Borrar POW antes de desactivar
    lw $a0, pow_old_x
    lw $a1, pow_old_y
    jal erase_pow
    
    sw $zero, pow_active

update_pow_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra    

# ===== VERIFICAR COLISI�N JUGADOR-POW =====
check_pow_collision:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, pow_x
    lw $t1, pow_y
    lw $t2, player_x
    lw $t3, player_y
    
    # AABB collision
    lw $t4, PLAYER_SIZE
    add $t4, $t2, $t4       # player_right
    blt $t4, $t0, no_pow_collision
    
    lw $t5, POW_SIZE
    add $t5, $t0, $t5       # pow_right
    blt $t5, $t2, no_pow_collision
    
    lw $t4, PLAYER_HEIGHT
    add $t4, $t3, $t4       # player_bottom
    blt $t4, $t1, no_pow_collision
    
    lw $t5, POW_SIZE
    add $t5, $t1, $t5       # pow_bottom
    blt $t5, $t3, no_pow_collision
    
    # �COLISI�N! Activar power-up
    li $t6, 1
    sw $t6, double_shot_active
    li $t7, 5
    sw $t7, double_shot_ammo
    
    # Borrar POW
    lw $a0, pow_old_x
    lw $a1, pow_old_y
    jal erase_pow
    
    # Desactivar POW
    sw $zero, pow_active

no_pow_collision:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra            

# ===== BORRAR POW =====
erase_pow:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    move $s0, $a0
    move $s1, $a1
    lw $s2, POW_SIZE
    
    li $t5, 0
    
erase_pow_y:
    bge $t5, $s2, erase_pow_done
    
    li $t6, 0
    
erase_pow_x:
    bge $t6, $s2, erase_pow_next_y
    
    # Calcular posici�n absoluta
    add $a0, $s0, $t6
    add $a1, $s1, $t5
    
    # Guardar registros
    addi $sp, $sp, -12
    sw $t5, 0($sp)
    sw $t6, 4($sp)
    sw $ra, 8($sp)
    
    # Obtener color de fondo
    jal get_background_color
    move $s3, $v0
    
    # Restaurar
    lw $ra, 8($sp)
    lw $t6, 4($sp)
    lw $t5, 0($sp)
    addi $sp, $sp, 12
    
    # Dibujar
    add $t7, $s1, $t5
    sll $t7, $t7, 6
    add $t7, $t7, $s0
    add $t7, $t7, $t6
    sll $t7, $t7, 2
    add $t7, $gp, $t7
    
    sw $s3, 0($t7)
    
    addi $t6, $t6, 1
    j erase_pow_x

erase_pow_next_y:
    addi $t5, $t5, 1
    j erase_pow_y

erase_pow_done:
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra                                    

# ===== DIBUJAR POW =====
draw_pow:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, pow_active
    beqz $t0, draw_pow_done
    
    # Borrar posici�n anterior
    lw $a0, pow_old_x
    lw $a1, pow_old_y
    jal erase_pow
    
    # Dibujar en nueva posici�n
    lw $a0, pow_x
    lw $a1, pow_y
    jal draw_pow_at

draw_pow_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR POW EN POSICI�N =====
draw_pow_at:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t0, $a0
    move $t1, $a1
    lw $t2, POW_SIZE
    
    la $s0, pow_sprite
    lw $s1, pow_green_dark      # Verde oscuro
    lw $s2, pow_green_light     # Verde claro
    
    li $t4, 0
    
draw_pow_y:
    bge $t4, $t2, draw_pow_done_loop
    
    li $t5, 0
    
draw_pow_x:
    bge $t5, $t2, draw_pow_next_y
    
    # Obtener �ndice sprite (Y * 7 + X)
    li $t6, 7
    mul $t7, $t4, $t6
    add $t7, $t7, $t5
    add $t8, $s0, $t7
    lb $t8, 0($t8)
    
    # Si es 0, transparente
    beqz $t8, skip_pow_pixel
    
    # Seleccionar color
    li $t9, 1
    beq $t8, $t9, use_pow_dark
    li $t9, 2
    beq $t8, $t9, use_pow_light
    j skip_pow_pixel
    
use_pow_dark:
    move $a2, $s1
    j draw_pow_pixel
use_pow_light:
    move $a2, $s2
    
draw_pow_pixel:
    add $a3, $t1, $t4
    sll $a3, $a3, 6
    add $a3, $a3, $t0
    add $a3, $a3, $t5
    sll $a3, $a3, 2
    add $a3, $gp, $a3
    
    sw $a2, 0($a3)
    
skip_pow_pixel:
    addi $t5, $t5, 1
    j draw_pow_x

draw_pow_next_y:
    addi $t4, $t4, 1
    j draw_pow_y

draw_pow_done_loop:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra                                                                                                            
                                                                                                                                                                                                                                                                                                                                    
# ===== ACTUALIZAR ENEMIGOS =====
update_enemies:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, enemy_0
    # VERIFICAR que sea una direcci�n v�lida
    beqz $t0, skip_enemy_0
    jal update_single_enemy
    
skip_enemy_0:  
    la $t0, enemy_1
    beqz $t0, skip_enemy_1
    jal update_single_enemy
    
skip_enemy_1:
    la $t0, enemy_2
    beqz $t0, skip_enemy_2
    jal update_single_enemy
    
skip_enemy_2:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

update_single_enemy:
    # Guardar el puntero del enemigo
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    move $s0, $t0
    
    lw $t1, 0($s0)
    beqz $t1, update_enemy_end_safe
    
    # Actualizar contador de movimiento
    lw $t7, 24($s0)
    addi $t7, $t7, 1
    sw $t7, 24($s0)
    
    # Verificar si debe moverse
    lw $t8, ENEMY_MOVE_RATE
    blt $t7, $t8, skip_enemy_move_safe
    
    # Resetear contador de movimiento
    sw $zero, 24($s0)
    
    # Guardar posici�n anterior
    lw $t2, 4($s0)
    lw $t3, 8($s0)
    sw $t2, 12($s0)
    sw $t3, 16($s0)
    
    # ===== MOVIMIENTO VERTICAL (hacia abajo) =====
    lw $t4, ENEMY_SPEED
    add $t3, $t3, $t4
    sw $t3, 8($s0)
    
    # ===== MOVIMIENTO HORIZONTAL =====
    lw $t5, 32($s0)          # Cargar direcci�n
    beqz $t5, skip_horizontal_move
    
    lw $t6, ENEMY_HORIZONTAL_SPEED
    
    # Si direcci�n es negativa, multiplicar velocidad por -1
    bltz $t5, move_enemy_left
    
move_enemy_right:
    add $t2, $t2, $t6        # x += velocidad
    j check_horizontal_bounds
    
move_enemy_left:
    sub $t2, $t2, $t6        # x -= velocidad
    
check_horizontal_bounds:
    # Verificar l�mites y cambiar direcci�n si es necesario
    bltz $t2, bounce_enemy_right
    
    # Ambos enemigos son 9x9
    lw $t8, ENEMY_SIZE
    lw $t9, SCREEN_WIDTH
    sub $t9, $t9, $t8        # l�mite_derecho = 64 - 9 = 55
    
check_bounds_normal:
    lw $t8, ENEMY_SIZE
    
calc_right_bound:
    lw $t9, SCREEN_WIDTH
    sub $t9, $t9, $t8        # l�mite_derecho = 64 - tama�o
    bgt $t2, $t9, bounce_enemy_left
    j save_new_x
    
bounce_enemy_right:
    li $t2, 0                # Posici�n X = 0
    li $t5, 1                # Cambiar direcci�n a derecha
    sw $t5, 32($s0)
    j save_new_x
    
bounce_enemy_left:
    move $t2, $t9            # Posici�n X = l�mite
    li $t5, -1               # Cambiar direcci�n a izquierda
    sw $t5, 32($s0)
    
save_new_x:
    sw $t2, 4($s0)           # Guardar nueva posici�n X
    
skip_horizontal_move:
    
skip_enemy_move_safe:
    # Cambiar direcci�n aleatoriamente cada cierto tiempo
    lw $t7, 24($s0)
    lw $t8, ENEMY_DIRECTION_CHANGE_RATE
    bne $t7, $t8, skip_direction_change
    
    # Generar nueva direcci�n aleatoria
    li $v0, 30
    syscall
    move $t9, $a0
    andi $t9, $t9, 0x3       # 0-3
    
    li $a0, 2
    blt $t9, $a0, set_no_horizontal
    beq $t9, $a0, set_left
    # Si es 3, ir a la derecha
    li $t9, 1
    sw $t9, 32($s0)
    j skip_direction_change
    
set_left:
    li $t9, -1
    sw $t9, 32($s0)
    j skip_direction_change
    
set_no_horizontal:
    sw $zero, 32($s0)
    
skip_direction_change:
    # Actualizar contador de disparo
    lw $t5, 20($s0)
    addi $t5, $t5, 1
    sw $t5, 20($s0)
    
    # Verificar si debe disparar
    lw $t6, ENEMY_SHOOT_RATE
    blt $t5, $t6, check_enemy_bounds_safe
    
    # Resetear contador y disparar
    sw $zero, 20($s0)
    
    move $t0, $s0
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal enemy_shoot
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
check_enemy_bounds_safe:
    # Desactivar si sale de pantalla
    lw $t3, 8($s0)
    lw $t7, SCREEN_HEIGHT
    bge $t3, $t7, deactivate_enemy_safe
    j update_enemy_end_safe

deactivate_enemy_safe:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    lw $a0, 12($s0)
    lw $a1, 16($s0)
    lw $a2, 28($s0)
    jal erase_enemy
    
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    
    sw $zero, 0($s0)

update_enemy_end_safe:
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    jr $ra

enemy_shoot:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    # Guardar puntero del enemigo
    move $s0, $t0
    
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
    
    # Posici�n desde el enemigo (usar $s0)
    lw $t4, 4($s0)      # enemy x
    lw $t5, 8($s0)      # enemy y
    
    # Centrar bala bajo el enemigo y dar espacio
    lw $t6, ENEMY_SIZE
    add $t5, $t5, $t6   # Y del enemigo + tama�o
    addi $t5, $t5, 2    # Agregar 2 p�xeles m�s de separaci�n
    
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
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

# ===== DIBUJAR ENEMIGOS =====
draw_enemies:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    la $s0, enemy_0
    move $t0, $s0
    jal draw_single_enemy
    
    la $s0, enemy_1
    move $t0, $s0
    jal draw_single_enemy
    
    la $s0, enemy_2
    move $t0, $s0
    jal draw_single_enemy
    
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

draw_single_enemy:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    # Guardar puntero del enemigo en $s0
    move $s0, $t0
    
    # VERIFICAR ALINEACI�N
    andi $t9, $s0, 0x3
    bnez $t9, draw_enemy_end_safe
    
    # VERIFICAR QUE NO SEA NULL
    beqz $s0, draw_enemy_end_safe
    
    # Cargar active
    lw $t1, 0($s0)
    beqz $t1, draw_enemy_end_safe
    
    # Verificar tipo de enemigo
    lw $t2, 28($s0)
    
    # Borrar posici�n anterior
    lw $a0, 12($s0)
    lw $a1, 16($s0)
    move $a2, $t2
    jal erase_enemy
    
    # Dibujar en nueva posici�n
    lw $a0, 4($s0)
    lw $a1, 8($s0)
    lw $a2, 28($s0)
    jal draw_enemy_at

draw_enemy_end_safe:
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
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
    
    # Ambos enemigos son 9x9
    lw $s2, ENEMY_SIZE
    
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
    
    # Calcular posici�n absoluta
    add $a0, $s0, $t6       # x absoluto
    add $a1, $s1, $t5       # y absoluto
    
    # Guardar registros temporales
    addi $sp, $sp, -12
    sw $t5, 0($sp)
    sw $t6, 4($sp)
    sw $ra, 8($sp)
    
    # Obtener color de fondo correcto
    jal get_background_color
    move $s6, $v0           # Guardar color
    
    # Restaurar registros
    lw $ra, 8($sp)
    lw $t6, 4($sp)
    lw $t5, 0($sp)
    addi $sp, $sp, 12
    
    # Dibujar el color
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
    
    # Verificar tipo (viene en $a2: 0=gris, 1=verde, 2=amarillo)
    beqz $a2, draw_enemy_type_1
    li $t9, 1
    beq $a2, $t9, draw_enemy_type_2
    li $t9, 2
    beq $a2, $t9, draw_enemy_type_3
    j draw_enemy_done_loop
    
    # ========== TIPO 3: Dibujar sprite amarillo ==========
draw_enemy_type_3:
    move $t0, $a0           # x position
    move $t1, $a1           # y position
    lw $t2, ENEMY_SIZE      # 9
    
    la $s0, enemy3_sprite
    lw $s1, enemy3_yellow   # Amarillo
    lw $s2, enemy3_red      # Rojo
    lw $s3, enemy3_white    # Blanco
    
    li $t4, 0               # Y counter
    
draw_enemy3_y:
    bge $t4, $t2, draw_enemy_done_loop
    
    li $t5, 0               # X counter
    
draw_enemy3_x:
    bge $t5, $t2, draw_enemy3_next_y
    
    # Obtener �ndice del sprite (Y * 9 + X)
    sll $t6, $t4, 3         # Y * 8
    add $t6, $t6, $t4       # Y * 9
    add $t6, $t6, $t5       # + X
    add $t7, $s0, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Si es 0, es transparente
    beqz $t7, skip_enemy3_pixel
    
    # Seleccionar color seg�n valor
    li $t8, 1
    beq $t7, $t8, use_enemy3_yellow
    li $t8, 2
    beq $t7, $t8, use_enemy3_red
    li $t8, 3
    beq $t7, $t8, use_enemy3_white
    j skip_enemy3_pixel
    
use_enemy3_yellow:
    move $t9, $s1
    j draw_enemy3_pixel
use_enemy3_red:
    move $t9, $s2
    j draw_enemy3_pixel
use_enemy3_white:
    move $t9, $s3
    
draw_enemy3_pixel:
    add $s4, $t1, $t4
    sll $s4, $s4, 6
    add $s4, $s4, $t0
    add $s4, $s4, $t5
    sll $s4, $s4, 2
    add $s4, $gp, $s4
    
    sw $t9, 0($s4)
    
skip_enemy3_pixel:
    addi $t5, $t5, 1
    j draw_enemy3_x

draw_enemy3_next_y:
    addi $t4, $t4, 1
    j draw_enemy3_y
    
    # ========== TIPO 2: Dibujar sprite verde ==========
draw_enemy_type_2:
    move $t0, $a0           # x position
    move $t1, $a1           # y position
    lw $t2, ENEMY_SIZE      # 9
    
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
    
    # Obtener �ndice del sprite (Y * 9 + X)
    sll $t6, $t4, 3         # Y * 8
    add $t6, $t6, $t4       # Y * 9
    add $t6, $t6, $t5       # + X
    add $t7, $s0, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Si es 0, es transparente
    beqz $t7, skip_enemy2_pixel
    
    # Seleccionar color seg�n valor
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
    
    # ========== TIPO 1: Dibujar sprite gris ==========
draw_enemy_type_1:
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
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    # Actualizar bullet_0
    la $s0, bullet_0
    move $t0, $s0
    jal update_single_bullet
    
    # Actualizar bullet_1
    la $s0, bullet_1
    move $t0, $s0
    jal update_single_bullet
    
    # Actualizar bullet_2
    la $s0, bullet_2
    move $t0, $s0
    jal update_single_bullet
    
    # Actualizar bullet_3
    la $s0, bullet_3
    move $t0, $s0
    jal update_single_bullet
    
    # Actualizar bullet_4
    la $s0, bullet_4
    move $t0, $s0
    jal update_single_bullet
    
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

update_single_bullet:
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    
    # Guardar puntero
    move $s0, $t0
    
    lw $t1, 0($s0)
    beqz $t1, update_bullet_end_safe
    
    # Guardar posici�n anterior
    lw $t2, 4($s0)
    lw $t3, 8($s0)
    sw $t2, 12($s0)
    sw $t3, 16($s0)
    
    # Mover hacia abajo
    lw $t4, BULLET_SPEED
    add $t3, $t3, $t4
    sw $t3, 8($s0)
    
    # Desactivar si sale de pantalla
    lw $t5, SCREEN_HEIGHT
    bge $t3, $t5, deactivate_bullet_safe
    j update_bullet_end_safe

deactivate_bullet_safe:
    # Borrar bala antes de desactivar
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    lw $a0, 12($s0)
    lw $a1, 16($s0)
    jal erase_bullet
    
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    
    sw $zero, 0($s0)

update_bullet_end_safe:
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    jr $ra

spawn_player_bullet:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Verificar si puede disparar
    lw $t0, player_can_shoot
    beqz $t0, spawn_player_done
    
    # Verificar si tiene power-up activo
    lw $t9, double_shot_active
    beqz $t9, spawn_single_bullet
    
    # DOBLE DISPARO
    # Buscar dos slots libres
    la $t0, player_bullet_0
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_1
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_2
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_3
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_4
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_5
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_6
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_7
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_8
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    la $t0, player_bullet_9
    lw $t1, 0($t0)
    beqz $t1, found_first_slot
    
    j spawn_player_done

found_first_slot:
    # Activar primera bala (IZQUIERDA)
    li $t2, 1
    sw $t2, 0($t0)
    
    # Calcular posici�n IZQUIERDA
    lw $t3, player_x
    addi $t3, $t3, 3        # Offset izquierdo
    lw $t4, player_y
    
    sw $t3, 4($t0)
    sw $t4, 8($t0)
    sw $t3, 12($t0)
    sw $t4, 16($t0)
    
    # Buscar segundo slot para bala DERECHA
    move $s7, $t0           # Guardar primer slot
    
find_second_slot:
    la $t0, player_bullet_0
    beq $t0, $s7, try_bullet_1
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_1:
    la $t0, player_bullet_1
    beq $t0, $s7, try_bullet_2
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_2:
    la $t0, player_bullet_2
    beq $t0, $s7, try_bullet_3
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_3:
    la $t0, player_bullet_3
    beq $t0, $s7, try_bullet_4
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_4:
    la $t0, player_bullet_4
    beq $t0, $s7, try_bullet_5
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_5:
    la $t0, player_bullet_5
    beq $t0, $s7, try_bullet_6
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_6:
    la $t0, player_bullet_6
    beq $t0, $s7, try_bullet_7
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_7:
    la $t0, player_bullet_7
    beq $t0, $s7, try_bullet_8
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_8:
    la $t0, player_bullet_8
    beq $t0, $s7, try_bullet_9
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    
try_bullet_9:
    la $t0, player_bullet_9
    beq $t0, $s7, decrease_ammo
    lw $t1, 0($t0)
    beqz $t1, found_second_slot
    j decrease_ammo

found_second_slot:
    # Activar segunda bala (DERECHA)
    li $t2, 1
    sw $t2, 0($t0)
    
    # Calcular posici�n DERECHA
    lw $t3, player_x
    addi $t3, $t3, 9        # Offset derecho (12 - 3)
    lw $t4, player_y
    
    sw $t3, 4($t0)
    sw $t4, 8($t0)
    sw $t3, 12($t0)
    sw $t4, 16($t0)
    
decrease_ammo:
    # Reducir munici�n del power-up
    lw $t5, double_shot_ammo
    addi $t5, $t5, -1
    sw $t5, double_shot_ammo
    
    # Si se acab� la munici�n, desactivar power-up
    bgtz $t5, spawn_player_done
    sw $zero, double_shot_active
    j spawn_player_done

spawn_single_bullet:
    # DISPARO NORMAL (c�digo original)
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
    
    # Calcular posici�n (centro del avi�n)
    lw $t3, player_x
    lw $t4, PLAYER_SIZE
    srl $t4, $t4, 1
    add $t3, $t3, $t4
    lw $t5, PLAYER_BULLET_WIDTH
    srl $t5, $t5, 1
    sub $t3, $t3, $t5
    
    lw $t4, player_y
    
    sw $t3, 4($t0)
    sw $t4, 8($t0)
    sw $t3, 12($t0)
    sw $t4, 16($t0)

spawn_player_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== ACTUALIZAR BALAS DEL JUGADOR =====
update_player_bullets:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    la $s0, player_bullet_0
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_1
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_2
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_3
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_4
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_5
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_6
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_7
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_8
    move $t0, $s0
    jal update_single_player_bullet
    
    la $s0, player_bullet_9
    move $t0, $s0
    jal update_single_player_bullet
    
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

update_single_player_bullet:
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    
    # Guardar puntero
    move $s0, $t0
    
    lw $t1, 0($s0)
    beqz $t1, update_player_bullet_end_safe
    
    # Guardar posici�n anterior
    lw $t2, 4($s0)
    lw $t3, 8($s0)
    sw $t2, 12($s0)
    sw $t3, 16($s0)
    
    # Mover hacia arriba
    lw $t4, PLAYER_BULLET_SPEED
    sub $t3, $t3, $t4
    sw $t3, 8($s0)
    
    # Desactivar si sale de pantalla
    bltz $t3, deactivate_player_bullet_safe
    j update_player_bullet_end_safe

deactivate_player_bullet_safe:
    # Borrar bala antes de desactivar
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    lw $a0, 12($s0)
    lw $a1, 16($s0)
    jal erase_player_bullet
    
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    
    sw $zero, 0($s0)

update_player_bullet_end_safe:
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR BALAS DEL JUGADOR =====
draw_player_bullets:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    la $s0, player_bullet_0
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_1
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_2
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_3
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_4
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_5
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_6
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_7
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_8
    move $t0, $s0
    jal draw_single_player_bullet
    
    la $s0, player_bullet_9
    move $t0, $s0
    jal draw_single_player_bullet
    
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

draw_single_player_bullet:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    # Guardar puntero de la bala en $s0
    move $s0, $t0
    
    # VERIFICAR ALINEACI�N
    andi $t9, $s0, 0x3
    bnez $t9, draw_single_player_bullet_end
    
    # VERIFICAR QUE NO SEA NULL
    beqz $s0, draw_single_player_bullet_end
    
    lw $t1, 0($s0)
    beqz $t1, draw_single_player_bullet_end
    
    # Borrar posici�n anterior
    lw $a0, 12($s0)
    lw $a1, 16($s0)
    jal erase_player_bullet
    
    # Dibujar en nueva posici�n
    lw $a0, 4($s0)
    lw $a1, 8($s0)
    jal draw_player_bullet_at

draw_single_player_bullet_end:
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
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
    
    # Calcular posici�n absoluta
    add $a0, $s0, $t6       # x absoluto
    add $a1, $s1, $t5       # y absoluto
    
    # Guardar registros temporales
    addi $sp, $sp, -12
    sw $t5, 0($sp)
    sw $t6, 4($sp)
    sw $ra, 8($sp)
    
    # Obtener color de fondo correcto
    jal get_background_color
    move $s6, $v0           # Guardar color
    
    # Restaurar registros
    lw $ra, 8($sp)
    lw $t6, 4($sp)
    lw $t5, 0($sp)
    addi $sp, $sp, 12
    
    # Dibujar el color
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
    
    # Obtener �ndice del sprite (Y * 1 + X)
    add $t6, $t4, $t5       # Y + X
    add $t7, $s0, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Seleccionar color seg�n valor
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
    
    lw $t0, player_x
    lw $t1, player_y
    
    # Verificar cada bala (sin verificar invulnerabilidad)
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
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
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
    
    # Colisi�n detectada
    # AGREGAR: Desactivar la bala antes de llamar a handle_hit
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t3, 8($sp)
    
    # Borrar bala visualmente
    lw $a0, 12($t3)
    lw $a1, 16($t3)
    jal erase_bullet
    
    # Restaurar $t3 y desactivar
    lw $t3, 8($sp)
    sw $zero, 0($t3)    # ? DESACTIVAR LA BALA
    
    # Ahora manejar el da�o
    jal handle_hit
    
    lw $t3, 8($sp)
    lw $t0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 12

check_bullet_end:
    jr $ra

# ===== DETECTAR COLISIONES BALA-ENEMIGO =====
check_bullet_enemy_collisions:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, boss_active
    beqz $t0, check_normal_enemies
    
    la $a0, player_bullet_0
    jal test_bullet_hit_boss
    la $a0, player_bullet_1
    jal test_bullet_hit_boss
    la $a0, player_bullet_2
    jal test_bullet_hit_boss
    la $a0, player_bullet_3
    jal test_bullet_hit_boss
    la $a0, player_bullet_4
    jal test_bullet_hit_boss
    la $a0, player_bullet_5
    jal test_bullet_hit_boss
    la $a0, player_bullet_6
    jal test_bullet_hit_boss
    la $a0, player_bullet_7
    jal test_bullet_hit_boss
    la $a0, player_bullet_8
    jal test_bullet_hit_boss
    la $a0, player_bullet_9
    jal test_bullet_hit_boss

check_normal_enemies:
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
    
    # Verificar si bala est� activa
    lw $t0, 0($t8)
    beqz $t0, test_end
    
    # Verificar si enemigo est� activo
    lw $t0, 0($t9)
    beqz $t0, test_end
    
    # Obtener posiciones
    lw $t0, 4($t8)          # bullet_x
    lw $t1, 8($t8)          # bullet_y
    lw $t2, 4($t9)          # enemy_x
    lw $t3, 8($t9)          # enemy_y
    
    # Calcular l�mites X
    lw $t4, PLAYER_BULLET_WIDTH
    add $t4, $t0, $t4       # bullet_right
    
    # Todos los enemigos son 9x9
    lw $t5, ENEMY_SIZE
    add $t5, $t2, $t5       # enemy_right
    
    # Colisi�n en X?
    blt $t4, $t2, test_end  # bullet_right < enemy_left
    blt $t5, $t0, test_end  # enemy_right < bullet_left
    
    # Calcular l�mites Y
    lw $t4, PLAYER_BULLET_HEIGHT
    add $t4, $t1, $t4       # bullet_bottom
    
    # Todos los enemigos son 9x9
    lw $t5, ENEMY_SIZE
    add $t5, $t3, $t5       # enemy_bottom
    
    # Colisi�n en Y?
    blt $t4, $t3, test_end  # bullet_bottom < enemy_top
    blt $t5, $t1, test_end  # enemy_bottom < bullet_top
    
    # �HAY COLISI�N!
    # Guardar punteros antes de borrar
    addi $sp, $sp, -8
    sw $t8, 0($sp)
    sw $t9, 4($sp)
    
    # Sumar puntos seg�n tipo de enemigo
    lw $t6, player_score
    lw $s5, 28($t9)          # Cargar tipo de enemigo (0=gris, 1=verde, 2=amarillo)
    
    # Verificar tipo 2 (amarillo)
    li $t8, 2
    beq $s5, $t8, points_type_3
    
    # Verificar tipo 1 (verde)
    li $t8, 1
    beq $s5, $t8, points_type_2
    
    # Tipo 0 (gris): 50 puntos
    lw $t7, POINTS_PER_KILL
    j add_points

points_type_2:
    # Tipo 1 (verde): 100 puntos
    li $t7, 100
    j add_points

points_type_3:
    # Tipo 2 (amarillo): 150 puntos
    li $t7, 150

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
    lw $a2, 28($t9)         # Pasar tipo de enemigo
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

# ===== DETECTAR COLISI�N BALA-BOSS =====
test_bullet_hit_boss:
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $t0, 12($sp)
    sw $t1, 16($sp)
    sw $t2, 20($sp)
    sw $t3, 24($sp)
    sw $t8, 28($sp)
    
    move $t8, $a0
    
    # Verificar si bala est� activa
    lw $t0, 0($t8)
    beqz $t0, test_boss_end
    
    # Obtener posiciones
    lw $t0, 4($t8)          # bullet_x
    lw $t1, 8($t8)          # bullet_y
    lw $t2, boss_x
    lw $t3, boss_y
    
    # Colisi�n AABB
    lw $t4, PLAYER_BULLET_WIDTH
    add $t4, $t0, $t4
    
    lw $t5, BOSS_SIZE
    add $t5, $t2, $t5
    
    blt $t4, $t2, test_boss_end
    blt $t5, $t0, test_boss_end
    
    lw $t4, PLAYER_BULLET_HEIGHT
    add $t4, $t1, $t4
    
    lw $t5, BOSS_SIZE
    add $t5, $t3, $t5
    
    blt $t4, $t3, test_boss_end
    blt $t5, $t1, test_boss_end
    
    # �COLISI�N!
    # Reducir vida del boss
    lw $t6, boss_health
    addi $t6, $t6, -1
    sw $t6, boss_health
    
    # Borrar bala
    lw $a0, 12($t8)
    lw $a1, 16($t8)
    
    addi $sp, $sp, -4
    sw $t8, 0($sp)
    jal erase_player_bullet
    lw $t8, 0($sp)
    addi $sp, $sp, 4
    
    sw $zero, 0($t8)
    
    # Verificar si boss muri�
    lw $t6, boss_health
    bnez $t6, test_boss_end
    
    # Boss derrotado!
    li $v0, 4
    la $a0, msg_boss_defeated
    syscall
    
    # Sumar 1000 puntos
    lw $t7, player_score
    lw $t9, BOSS_POINTS
    add $t7, $t7, $t9
    sw $t7, player_score
    
    li $v0, 4
    la $a0, msg_score
    syscall
    li $v0, 1
    lw $a0, player_score
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    # Desactivar boss
    sw $zero, boss_active
    
    # ACTIVAR BARCO FINAL
    li $t9, 1
    sw $t9, final_ship_active
    
    li $v0, 4
    la $a0, msg_final_ship
    syscall

test_boss_end:
    lw $t8, 28($sp)
    lw $t3, 24($sp)
    lw $t2, 20($sp)
    lw $t1, 16($sp)
    lw $t0, 12($sp)
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
   
    blez $t0, set_game_over
    jr $ra

set_game_over:
    li $t2, 1
    sw $t2, game_over_flag
    jr $ra

# ===== DIBUJAR BALAS =====
draw_bullets:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    la $s0, bullet_0
    move $t0, $s0
    jal draw_single_bullet
    
    la $s0, bullet_1
    move $t0, $s0
    jal draw_single_bullet
    
    la $s0, bullet_2
    move $t0, $s0
    jal draw_single_bullet
    
    la $s0, bullet_3
    move $t0, $s0
    jal draw_single_bullet
    
    la $s0, bullet_4
    move $t0, $s0
    jal draw_single_bullet
    
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

draw_single_bullet:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    # Guardar puntero de la bala en $s0
    move $s0, $t0
    
    # VERIFICAR ALINEACI�N
    andi $t9, $s0, 0x3
    bnez $t9, draw_single_bullet_end
    
    # VERIFICAR QUE NO SEA NULL
    beqz $s0, draw_single_bullet_end
    
    lw $t1, 0($s0)
    beqz $t1, draw_single_bullet_end
    
    # Borrar posici�n anterior
    lw $a0, 12($s0)
    lw $a1, 16($s0)
    jal erase_bullet
    
    # Dibujar en nueva posici�n
    lw $a0, 4($s0)
    lw $a1, 8($s0)
    jal draw_bullet_at

draw_single_bullet_end:
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
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
    
    # Calcular posici�n absoluta
    add $a0, $s0, $t6       # x absoluto
    add $a1, $s1, $t5       # y absoluto
    
    # Guardar registros temporales
    addi $sp, $sp, -12
    sw $t5, 0($sp)
    sw $t6, 4($sp)
    sw $ra, 8($sp)
    
    # Obtener color de fondo correcto
    jal get_background_color
    move $s6, $v0           # Guardar color
    
    # Restaurar registros
    lw $ra, 8($sp)
    lw $t6, 4($sp)
    lw $t5, 0($sp)
    addi $sp, $sp, 12
    
    # Dibujar el color
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
    
    # Obtener �ndice del sprite (Y * 3 + X)
    sll $t6, $t4, 1         # Y * 2
    add $t6, $t6, $t4       # Y * 3
    add $t6, $t6, $t5       # + X
    add $t7, $s0, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Si es 0, es transparente (no dibujar)
    beqz $t7, skip_bullet_pixel
    
    # Seleccionar color seg�n valor
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

# ===== DIBUJAR PORTAAVIONES =====
draw_carrier:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, carrier_visible
    beqz $t0, draw_carrier_done
    
    # Posici�n: centrado horizontalmente, Y din�mico
    li $t0, 16              # x = 16 (centrado en 64)
    lw $t1, carrier_y_offset  # y = offset din�mico
    lw $t2, CARRIER_HEIGHT  # 48
    li $t3, 32              # ancho
    
    # Si el barco ya sali� completamente de la pantalla, ocultarlo
    li $t4, 64
    bge $t1, $t4, hide_carrier_complete
    
    la $s0, carrier_sprite
    lw $s1, carrier_gray
    lw $s2, carrier_light_gray
    lw $s3, carrier_black
    la $s4, sea_colors
    
    li $t4, 0               # Y counter
    
draw_carrier_y:
    bge $t4, $t2, draw_carrier_done
    
    # Calcular Y en pantalla
    add $t5, $t1, $t4
    # Si Y >= 64, no dibujar esta fila
    li $t6, 64
    bge $t5, $t6, draw_carrier_next_y
    # Si Y < 0, no dibujar esta fila
    bltz $t5, draw_carrier_next_y
    
    li $t6, 0               # X counter
    
draw_carrier_x:
    bge $t6, $t3, draw_carrier_next_y
    
    # Calcular X en pantalla
    add $t7, $t0, $t6
    # Si X >= 64, no dibujar este pixel
    li $t8, 64
    bge $t7, $t8, skip_carrier_pixel
    # Si X < 0, no dibujar este pixel
    bltz $t7, skip_carrier_pixel
    
    # Obtener �ndice del sprite (Y * 32 + X)
    sll $t7, $t4, 5         # Y * 32
    add $t7, $t7, $t6       # + X
    add $t8, $s0, $t7
    lb $t8, 0($t8)          # Valor del pixel
    
    # Si es 0, dibujar mar
    beqz $t8, draw_carrier_sea
    
    # Seleccionar color seg�n valor
    li $t9, 1
    beq $t8, $t9, use_carrier_gray
    li $t9, 2
    beq $t8, $t9, use_carrier_light
    li $t9, 3
    beq $t8, $t9, use_carrier_black
    j skip_carrier_pixel
    
use_carrier_gray:
    move $s5, $s1
    j draw_carrier_pixel
use_carrier_light:
    move $s5, $s2
    j draw_carrier_pixel
use_carrier_black:
    move $s5, $s3
    j draw_carrier_pixel

draw_carrier_sea:
    # Dibujar patr�n de mar
    add $s6, $t1, $t4       # Y absoluto
    andi $s6, $s6, 0xF
    sll $s6, $s6, 5
    la $s7, wave_pattern
    add $s6, $s7, $s6
    
    add $s7, $t0, $t6       # X absoluto
    andi $s7, $s7, 0x1F
    add $s6, $s6, $s7
    lb $s6, 0($s6)
    
    sll $s6, $s6, 2
    add $s6, $s4, $s6
    lw $s5, 0($s6)
    
draw_carrier_pixel:
    # Calcular offset en display
    add $s6, $t1, $t4       # Y total
    sll $s6, $s6, 6         # * 64
    add $s6, $s6, $t0       # + X base
    add $s6, $s6, $t6       # + X offset
    sll $s6, $s6, 2         # * 4
    add $s6, $gp, $s6
    
    sw $s5, 0($s6)
    
skip_carrier_pixel:
    addi $t6, $t6, 1
    j draw_carrier_x

draw_carrier_next_y:
    addi $t4, $t4, 1
    j draw_carrier_y

hide_carrier_complete:
    sw $zero, carrier_visible

draw_carrier_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== ACTUALIZAR BARCO FINAL =====
update_final_ship:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Mover el barco hacia abajo (apareciendo desde arriba)
    lw $t0, final_ship_y_offset
    lw $t1, final_ship_scroll_speed
    add $t0, $t0, $t1           # Sumar para mover hacia abajo
    sw $t0, final_ship_y_offset
    
    # Verificar si el barco est� completamente visible
    # El barco est� completo cuando Y >= 8 (visible en pantalla)
    li $t2, 8
    blt $t0, $t2, update_final_ship_done
    
    # Barco completamente visible - Victoria
    li $t3, 1
    sw $t3, game_won_flag

update_final_ship_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR BARCO FINAL =====
draw_final_ship:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Posici�n: centrado horizontalmente, Y din�mico
    li $t0, 16              # x = 16 (centrado en 64)
    lw $t1, final_ship_y_offset  # y = offset din�mico
    lw $t2, CARRIER_HEIGHT  # 48
    li $t3, 32              # ancho
    
    # Si el barco no ha empezado a aparecer, no dibujar
    li $t4, 64
    bge $t1, $t4, draw_final_ship_done
    
    la $s0, carrier_sprite
    lw $s1, carrier_gray
    lw $s2, carrier_light_gray
    lw $s3, carrier_black
    la $s4, sea_colors
    
    li $t4, 0               # Y counter
    
draw_final_ship_y:
    bge $t4, $t2, draw_final_ship_done
    
    # Calcular Y en pantalla
    add $t5, $t1, $t4
    # Si Y >= 64, no dibujar esta fila
    li $t6, 64
    bge $t5, $t6, draw_final_ship_next_y
    # Si Y < 0, no dibujar esta fila
    bltz $t5, draw_final_ship_next_y
    
    li $t6, 0               # X counter
    
draw_final_ship_x:
    bge $t6, $t3, draw_final_ship_next_y
    
    # Calcular X en pantalla
    add $t7, $t0, $t6
    # Si X >= 64, no dibujar este pixel
    li $t8, 64
    bge $t7, $t8, skip_final_ship_pixel
    # Si X < 0, no dibujar este pixel
    bltz $t7, skip_final_ship_pixel
    
    # Obtener �ndice del sprite (Y * 32 + X)
    sll $t7, $t4, 5         # Y * 32
    add $t7, $t7, $t6       # + X
    add $t8, $s0, $t7
    lb $t8, 0($t8)          # Valor del pixel
    
    # Si es 0, dibujar mar
    beqz $t8, draw_final_ship_sea
    
    # Seleccionar color seg�n valor
    li $t9, 1
    beq $t8, $t9, use_final_carrier_gray
    li $t9, 2
    beq $t8, $t9, use_final_carrier_light
    li $t9, 3
    beq $t8, $t9, use_final_carrier_black
    j skip_final_ship_pixel
    
use_final_carrier_gray:
    move $s5, $s1
    j draw_final_ship_pixel
use_final_carrier_light:
    move $s5, $s2
    j draw_final_ship_pixel
use_final_carrier_black:
    move $s5, $s3
    j draw_final_ship_pixel

draw_final_ship_sea:
    # Dibujar patr�n de mar
    add $s6, $t1, $t4       # Y absoluto
    andi $s6, $s6, 0xF
    sll $s6, $s6, 5
    la $s7, wave_pattern
    add $s6, $s7, $s6
    
    add $s7, $t0, $t6       # X absoluto
    andi $s7, $s7, 0x1F
    add $s6, $s6, $s7
    lb $s6, 0($s6)
    
    sll $s6, $s6, 2
    add $s6, $s4, $s6
    lw $s5, 0($s6)
    
draw_final_ship_pixel:
    # Calcular offset en display
    add $s6, $t1, $t4       # Y total
    sll $s6, $s6, 6         # * 64
    add $s6, $s6, $t0       # + X base
    add $s6, $s6, $t6       # + X offset
    sll $s6, $s6, 2         # * 4
    add $s6, $gp, $s6
    
    sw $s5, 0($s6)
    
skip_final_ship_pixel:
    addi $t6, $t6, 1
    j draw_final_ship_x

draw_final_ship_next_y:
    addi $t4, $t4, 1
    j draw_final_ship_y

draw_final_ship_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

get_background_color:
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    
    move $s0, $a0           # x
    move $s1, $a1           # y
    
    lw $t0, final_ship_active
    lw $t1, carrier_visible
    or $t2, $t0, $t1
    beqz $t2, get_bg_sea    # Si ninguno visible, ir directo al mar
    
    # PRIMERO: Verificar si barco final est� activo
    lw $t0, final_ship_active
    beqz $t0, check_initial_carrier
    
    # Verificar si el punto est� dentro del �rea del barco final
    li $t1, 16              # final_ship_x
    lw $t2, final_ship_y_offset  # final_ship_y DIN�MICO
    li $t3, 32              # final_ship_width
    lw $t4, CARRIER_HEIGHT  # final_ship_height
    
    # Verificar X: x >= final_ship_x && x < final_ship_x + width
    blt $s0, $t1, check_initial_carrier
    add $t5, $t1, $t3
    bge $s0, $t5, check_initial_carrier
    
    # Verificar Y: y >= final_ship_y && y < final_ship_y + height
    blt $s1, $t2, check_initial_carrier
    add $t5, $t2, $t4
    bge $s1, $t5, check_initial_carrier
    
    # Est� sobre el barco final - obtener color del sprite
    sub $t5, $s0, $t1       # offset_x
    sub $t6, $s1, $t2       # offset_y
    
    # Calcular �ndice en sprite (offset_y * 32 + offset_x)
    sll $t7, $t6, 5         # offset_y * 32
    add $t7, $t7, $t5       # + offset_x
    la $t8, carrier_sprite
    add $t8, $t8, $t7
    lb $t8, 0($t8)          # Valor del pixel
    
    # Si es 0, es mar
    beqz $t8, get_bg_sea
    
    # Seleccionar color seg�n valor
    li $t9, 1
    beq $t8, $t9, get_bg_carrier_gray
    li $t9, 2
    beq $t8, $t9, get_bg_carrier_light
    li $t9, 3
    beq $t8, $t9, get_bg_carrier_black
    j get_bg_sea

check_initial_carrier:
    # SEGUNDO: Verificar si portaaviones inicial est� visible
    lw $t0, carrier_visible
    beqz $t0, get_bg_sea
    
    # Verificar si el punto est� dentro del �rea del portaaviones inicial
    li $t1, 16              # carrier_x
    lw $t2, carrier_y_offset  # carrier_y DIN�MICO
    li $t3, 32              # carrier_width
    lw $t4, CARRIER_HEIGHT  # carrier_height
    
    # Verificar X: x >= carrier_x && x < carrier_x + width
    blt $s0, $t1, get_bg_sea
    add $t5, $t1, $t3
    bge $s0, $t5, get_bg_sea
    
    # Verificar Y: y >= carrier_y && y < carrier_y + height
    blt $s1, $t2, get_bg_sea
    add $t5, $t2, $t4
    bge $s1, $t5, get_bg_sea
    
    # Est� sobre el portaaviones inicial - obtener color del sprite
    sub $t5, $s0, $t1       # offset_x
    sub $t6, $s1, $t2       # offset_y
    
    # Calcular �ndice en sprite (offset_y * 32 + offset_x)
    sll $t7, $t6, 5         # offset_y * 32
    add $t7, $t7, $t5       # + offset_x
    la $t8, carrier_sprite
    add $t8, $t8, $t7
    lb $t8, 0($t8)          # Valor del pixel
    
    # Si es 0, es mar
    beqz $t8, get_bg_sea
    
    # Seleccionar color seg�n valor
    li $t9, 1
    beq $t8, $t9, get_bg_carrier_gray
    li $t9, 2
    beq $t8, $t9, get_bg_carrier_light
    li $t9, 3
    beq $t8, $t9, get_bg_carrier_black
    j get_bg_sea
    
get_bg_carrier_gray:
    lw $v0, carrier_gray
    j get_bg_done
get_bg_carrier_light:
    lw $v0, carrier_light_gray
    j get_bg_done
get_bg_carrier_black:
    lw $v0, carrier_black
    j get_bg_done
    
get_bg_sea:
    # Obtener color del mar usando el patr�n de olas
    andi $t2, $s1, 0xF
    sll $t2, $t2, 5
    la $t3, wave_pattern
    add $t3, $t3, $t2
    
    andi $t5, $s0, 0x1F
    add $t6, $t3, $t5
    lb $t6, 0($t6)
    
    sll $t7, $t6, 2
    la $t9, sea_colors
    add $t7, $t9, $t7
    lw $v0, 0($t7)
    
get_bg_done:
    lw $s4, 20($sp)
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 24
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

# ===== DIBUJAR JUGADOR EN NUEVA POSICI�N =====
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
    lw $s3, plane_salmon     # Salm�n
    
    li $t5, 0                # Y counter
    
new_y_loop:
    bge $t5, $s7, new_done
    
    li $t6, 0                # X counter
    
new_x_loop:
    bge $t6, $t9, new_next_row
    
    # Obtener �ndice del sprite (Y * 12 + X)
    sll $t7, $t5, 3         # Y * 8
    sll $a3, $t5, 2         # Y * 4
    add $t7, $t7, $a3       # Y * 12
    add $t7, $t7, $t6
    add $t8, $s0, $t7
    lb $t8, 0($t8)           # Valor del pixel en sprite
    
    # Si es 0, es transparente (no dibujar)
    beqz $t8, skip_pixel
    
    # Seleccionar color seg�n valor
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

# ===== ACTUALIZAR BOSS =====
update_boss:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Guardar posici�n anterior
    lw $t0, boss_x
    lw $t1, boss_y
    sw $t0, boss_old_x
    sw $t1, boss_old_y
    
    # Incrementar contador de movimiento
    lw $t2, boss_move_counter
    addi $t2, $t2, 1
    sw $t2, boss_move_counter
    
    lw $t3, BOSS_MOVE_RATE
    blt $t2, $t3, boss_check_shoot
    
    # Resetear contador
    sw $zero, boss_move_counter
    
    # Mover verticalmente hacia abajo hasta posici�n Y=5
    li $t4, 5
    bge $t1, $t4, boss_move_horizontal
    
    lw $t5, BOSS_MOVE_SPEED
    add $t1, $t1, $t5
    sw $t1, boss_y
    j boss_check_shoot
    
boss_move_horizontal:
    # Mover horizontalmente
    lw $t5, boss_direction
    lw $t6, BOSS_MOVE_SPEED
    
    bltz $t5, boss_move_left_dir
    add $t0, $t0, $t6
    j boss_check_bounds
    
boss_move_left_dir:
    sub $t0, $t0, $t6
    
boss_check_bounds:
    # Verificar l�mites (0 a 64-27=37)
    bltz $t0, boss_bounce_right
    li $t7, 37
    bgt $t0, $t7, boss_bounce_left
    sw $t0, boss_x
    j boss_check_shoot
    
boss_bounce_right:
    li $t0, 0
    sw $t0, boss_x
    li $t5, 1
    sw $t5, boss_direction
    j boss_check_shoot
    
boss_bounce_left:
    li $t0, 37
    sw $t0, boss_x
    li $t5, -1
    sw $t5, boss_direction

boss_check_shoot:
    # Sistema de disparo
    lw $t0, boss_shoot_counter
    addi $t0, $t0, 1
    sw $t0, boss_shoot_counter
    
    lw $t1, BOSS_SHOOT_RATE
    blt $t0, $t1, boss_no_shoot
    
    # Resetear contador y disparar
    sw $zero, boss_shoot_counter
    jal boss_shoot

boss_no_shoot:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== BOSS DISPARA 3 BALAS =====
boss_shoot:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Posici�n del boss
    lw $t4, boss_x
    lw $t5, boss_y
    
    # Calcular Y de disparo (debajo del boss)
    addi $t5, $t5, 27
    addi $t5, $t5, 2
    
    # BALA IZQUIERDA (desde x + 3)
    la $t1, bullet_0
    lw $t2, 0($t1)
    bnez $t2, try_bullet_1_left
    
    # Slot libre para bala izquierda
    li $t3, 1
    sw $t3, 0($t1)
    
    addi $t6, $t4, 3        # Posici�n x izquierda
    sw $t6, 4($t1)
    sw $t5, 8($t1)
    sw $t6, 12($t1)
    sw $t5, 16($t1)
    j boss_shoot_center

try_bullet_1_left:
    la $t1, bullet_1
    lw $t2, 0($t1)
    bnez $t2, boss_shoot_center
    
    li $t3, 1
    sw $t3, 0($t1)
    
    addi $t6, $t4, 3
    sw $t6, 4($t1)
    sw $t5, 8($t1)
    sw $t6, 12($t1)
    sw $t5, 16($t1)

boss_shoot_center:
    # BALA CENTRAL (desde x + 13, el centro)
    la $t1, bullet_2
    lw $t2, 0($t1)
    bnez $t2, try_bullet_3_center
    
    # Slot libre para bala central
    li $t3, 1
    sw $t3, 0($t1)
    
    addi $t6, $t4, 12       # Centro del boss (27/2 ? 13)
    sw $t6, 4($t1)
    sw $t5, 8($t1)
    sw $t6, 12($t1)
    sw $t5, 16($t1)
    j boss_shoot_right

try_bullet_3_center:
    la $t1, bullet_3
    lw $t2, 0($t1)
    bnez $t2, boss_shoot_right
    
    li $t3, 1
    sw $t3, 0($t1)
    
    addi $t6, $t4, 12
    sw $t6, 4($t1)
    sw $t5, 8($t1)
    sw $t6, 12($t1)
    sw $t5, 16($t1)

boss_shoot_right:
    # BALA DERECHA (desde x + 21)
    la $t1, bullet_4
    lw $t2, 0($t1)
    bnez $t2, try_bullet_0_right
    
    # Slot libre para bala derecha
    li $t3, 1
    sw $t3, 0($t1)
    
    addi $t6, $t4, 21       # Posici�n x derecha
    sw $t6, 4($t1)
    sw $t5, 8($t1)
    sw $t6, 12($t1)
    sw $t5, 16($t1)
    j boss_shoot_done

try_bullet_0_right:
    # Si bullet_4 est� ocupada, intentar usar bullet_0 para la derecha
    la $t1, bullet_0
    lw $t2, 0($t1)
    bnez $t2, boss_shoot_done
    
    li $t3, 1
    sw $t3, 0($t1)
    
    addi $t6, $t4, 21
    sw $t6, 4($t1)
    sw $t5, 8($t1)
    sw $t6, 12($t1)
    sw $t5, 16($t1)

boss_shoot_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR BOSS =====
draw_boss:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    # Borrar posici�n anterior
    lw $a0, boss_old_x
    lw $a1, boss_old_y
    jal erase_boss
    
    # Dibujar en nueva posici�n
    lw $a0, boss_x
    lw $a1, boss_y
    jal draw_boss_at
    
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# ===== BORRAR BOSS =====
erase_boss:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    move $s0, $a0
    move $s1, $a1
    lw $s2, BOSS_SIZE
    
    li $t5, 0
    
erase_boss_y:
    bge $t5, $s2, erase_boss_done
    
    li $t6, 0
    
erase_boss_x:
    bge $t6, $s2, erase_boss_next_y
    
    # Calcular posici�n absoluta
    add $a0, $s0, $t6
    add $a1, $s1, $t5
    
    # Verificar que est� en pantalla
    bltz $a1, skip_erase_boss_pixel
    li $t9, 64
    bge $a1, $t9, skip_erase_boss_pixel
    
    addi $sp, $sp, -12
    sw $t5, 0($sp)
    sw $t6, 4($sp)
    sw $ra, 8($sp)
    
    jal get_background_color
    move $s6, $v0
    
    lw $ra, 8($sp)
    lw $t6, 4($sp)
    lw $t5, 0($sp)
    addi $sp, $sp, 12
    
    add $s7, $s1, $t5
    sll $s7, $s7, 6
    add $s7, $s7, $s0
    add $s7, $s7, $t6
    sll $s7, $s7, 2
    add $s7, $gp, $s7
    
    sw $s6, 0($s7)

skip_erase_boss_pixel:
    addi $t6, $t6, 1
    j erase_boss_x

erase_boss_next_y:
    addi $t5, $t5, 1
    j erase_boss_y

erase_boss_done:
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# ===== DIBUJAR BOSS EN POSICI�N =====
draw_boss_at:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t0, $a0
    move $t1, $a1
    lw $t2, BOSS_SIZE
    
    la $s0, boss_sprite
    lw $s1, boss_green_light
    lw $s2, boss_green_dark
    lw $s3, boss_white
    
    li $t4, 0
    
draw_boss_y:
    bge $t4, $t2, draw_boss_done
    
    add $t5, $t1, $t4
    li $t6, 64
    bge $t5, $t6, draw_boss_next_y
    bltz $t5, draw_boss_next_y
    
    li $t6, 0
    
draw_boss_x:
    bge $t6, $t2, draw_boss_next_y
    
    # Calcular �ndice sprite (Y * 27 + X)
    li $t7, 27
    mul $t8, $t4, $t7
    add $t8, $t8, $t6
    add $t9, $s0, $t8
    lb $t9, 0($t9)
    
    beqz $t9, skip_boss_pixel
    
    li $a0, 1
    beq $t9, $a0, use_boss_green_light
    li $a0, 2
    beq $t9, $a0, use_boss_green_dark
    li $a0, 3
    beq $t9, $a0, use_boss_white
    j skip_boss_pixel
    
use_boss_green_light:
    move $a1, $s1
    j draw_boss_pixel
use_boss_green_dark:
    move $a1, $s2
    j draw_boss_pixel
use_boss_white:
    move $a1, $s3
    
draw_boss_pixel:
    add $a2, $t1, $t4
    sll $a2, $a2, 6
    add $a2, $a2, $t0
    add $a2, $a2, $t6
    sll $a2, $a2, 2
    add $a2, $gp, $a2
    
    sw $a1, 0($a2)
    
skip_boss_pixel:
    addi $t6, $t6, 1
    j draw_boss_x

draw_boss_next_y:
    addi $t4, $t4, 1
    j draw_boss_y

draw_boss_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ===== DIBUJAR UN D�GITO EN POSICI�N X, Y =====
# $a0 = d�gito (0-9)
# $a1 = x position
# $a2 = y position
draw_digit:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    # Validar d�gito (0-9)
    bltz $a0, draw_digit_done
    li $t0, 9
    bgt $a0, $t0, draw_digit_done
    
    move $s0, $a1           # x position
    move $s1, $a2           # y position
    
    # Obtener puntero al sprite del d�gito
    la $t0, digit_table
    sll $t1, $a0, 2         # d�gito * 4
    add $t0, $t0, $t1
    lw $s2, 0($t0)          # s2 = puntero al sprite
    
    lw $s3, hud_white       # Color blanco
    
    li $t4, 0               # Y counter (0-6)
    
draw_digit_y:
    li $t0, 5
    bge $t4, $t0, draw_digit_done
    
    li $t5, 0               # X counter (0-4)
    
draw_digit_x:
    li $t0, 3
    bge $t5, $t0, draw_digit_next_y
    
    # Calcular �ndice en sprite (Y * 3 + X)
    li $t0, 3
    mul $t6, $t4, $t0
    add $t6, $t6, $t5
    add $t7, $s2, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Si es 0, es transparente
    beqz $t7, skip_digit_pixel
    
    # Dibujar pixel blanco
    add $t8, $s1, $t4       # Y total
    add $t9, $s0, $t5       # X total
    
    # Calcular offset en display
    sll $t8, $t8, 6         # Y * 64
    add $t8, $t8, $t9       # + X
    sll $t8, $t8, 2         # * 4
    add $t8, $gp, $t8
    
    sw $s3, 0($t8)
    
skip_digit_pixel:
    addi $t5, $t5, 1
    j draw_digit_x

draw_digit_next_y:
    addi $t4, $t4, 1
    j draw_digit_y

draw_digit_done:
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# ===== DIBUJAR N�MERO COMPLETO =====
# $a0 = n�mero a dibujar
# $a1 = x position (esquina superior izquierda)
# $a2 = y position
# ===== DIBUJAR N�MERO COMPLETO =====
# $a0 = n�mero a dibujar
# $a1 = x position (esquina superior izquierda)
# $a2 = y position
draw_number:
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    
    move $s0, $a0           # n�mero
    move $s1, $a1           # x inicial
    move $s2, $a2           # y
    
    # Caso especial: si es 0, dibujar solo un 0
    bnez $s0, extract_digits
    
    li $a0, 0
    move $a1, $s1
    move $a2, $s2
    jal draw_digit
    j draw_number_done
    
extract_digits:
    # Extraer d�gitos usando divisiones sucesivas
    # Primero contamos cu�ntos d�gitos tiene
    move $t0, $s0           # copia del n�mero
    li $s3, 0               # contador de d�gitos
    
count_loop:
    beqz $t0, start_drawing
    li $t1, 10
    div $t0, $t1
    mflo $t0                # t0 = t0 / 10
    addi $s3, $s3, 1
    j count_loop
    
start_drawing:
    # s3 = cantidad de d�gitos
    # Calcular divisor para extraer primer d�gito
    li $s4, 1               # divisor
    li $t2, 1               # contador
    
calc_divisor:
    bge $t2, $s3, draw_loop
    li $t1, 10
    mul $s4, $s4, $t1       # divisor *= 10
    addi $t2, $t2, 1
    j calc_divisor
    
draw_loop:
    beqz $s3, draw_number_done
    
    # Extraer d�gito m�s significativo
    div $s0, $s4
    mflo $a0                # d�gito = n�mero / divisor
    mfhi $s0                # n�mero = n�mero % divisor
    
    # Dibujar d�gito
    move $a1, $s1
    move $a2, $s2
    
    addi $sp, $sp, -8
    sw $s3, 0($sp)
    sw $s4, 4($sp)
    jal draw_digit
    lw $s4, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 8
    
    # Siguiente posici�n x
    addi $s1, $s1, 4
    
    # Dividir divisor por 10
    li $t1, 10
    div $s4, $t1
    mflo $s4
    
    addi $s3, $s3, -1
    j draw_loop

draw_number_done:
    lw $s4, 20($sp)
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 24
    jr $ra

# ===== DIBUJAR UN CORAZ�N =====
# $a0 = x position
# $a1 = y position
draw_heart:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    move $s0, $a0           # x position
    move $s1, $a1           # y position
    
    la $s2, heart_sprite
    lw $t9, hud_red         # Color rojo
    
    li $t4, 0               # Y counter (0-6)
    
draw_heart_y:
    li $t0, 5
    bge $t4, $t0, draw_heart_done
    
    li $t5, 0               # X counter (0-6)
    
draw_heart_x:
    li $t0, 5
    bge $t5, $t0, draw_heart_next_y
    
    # Calcular �ndice en sprite (Y * 7 + X)
    li $t0, 5
    mul $t6, $t4, $t0
    add $t6, $t6, $t5
    add $t7, $s2, $t6
    lb $t7, 0($t7)          # Valor del pixel
    
    # Si es 0, es transparente
    beqz $t7, skip_heart_pixel
    
    # Dibujar pixel rojo
    add $t8, $s1, $t4       # Y total
    add $a2, $s0, $t5       # X total
    
    # Calcular offset en display
    sll $t8, $t8, 6         # Y * 64
    add $t8, $t8, $a2       # + X
    sll $t8, $t8, 2         # * 4
    add $t8, $gp, $t8
    
    sw $t9, 0($t8)
    
skip_heart_pixel:
    addi $t5, $t5, 1
    j draw_heart_x

draw_heart_next_y:
    addi $t4, $t4, 1
    j draw_heart_y

draw_heart_done:
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra

# ===== DIBUJAR HUD COMPLETO =====
draw_hud:
    addi $sp, $sp, -32
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    
    # Dibujar score arriba a la izquierda (posici�n 2, 2)
    lw $a0, player_score
    li $a1, 2               # x = 2
    li $a2, 2               # y = 2
    jal draw_number
    
    # BORRAR �rea de corazones con color de fondo correcto
    li $s0, 44              # x inicial corazones
    li $s1, 57              # y inicial corazones
    
    # Borrar �rea de 18x5 p�xeles
    li $s2, 0               # contador Y
erase_hearts_y:
    li $t4, 5
    bge $s2, $t4, draw_hearts_start
    
    li $s3, 0               # contador X
erase_hearts_x:
    li $t4, 18
    bge $s3, $t4, erase_hearts_next_y
    
    # Calcular posici�n absoluta
    add $a0, $s0, $s3       # x
    add $a1, $s1, $s2       # y
    
    # Guardar registros
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Obtener color de fondo (mar con patr�n)
    jal get_background_color
    move $s4, $v0           # guardar color
    
    # Restaurar
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    # Dibujar pixel del fondo
    add $t7, $s1, $s2       # Y total
    sll $t7, $t7, 6         # * 64
    add $t7, $t7, $s0       # + X base
    add $t7, $t7, $s3       # + X offset
    sll $t7, $t7, 2         # * 4
    add $t7, $gp, $t7
    sw $s4, 0($t7)
    
    addi $s3, $s3, 1
    j erase_hearts_x

erase_hearts_next_y:
    addi $s2, $s2, 1
    j erase_hearts_y

draw_hearts_start:
    # Dibujar corazones seg�n vidas actuales
    lw $t0, player_lives
    li $s0, 44              # x inicial
    li $s1, 57              # y
    
    # DEBUG: Si lives == 3, dibujar 3 corazones
    li $t3, 3
    bne $t0, $t3, check_two_lives
    
    # Dibujar los 3 corazones
    move $a0, $s0
    move $a1, $s1
    jal draw_heart
    
    addi $a0, $s0, 6
    move $a1, $s1
    jal draw_heart
    
    addi $a0, $s0, 12
    move $a1, $s1
    jal draw_heart
    j skip_all_hearts

check_two_lives:
    # Si lives == 2, dibujar 2 corazones
    li $t3, 2
    bne $t0, $t3, check_one_life
    
    move $a0, $s0
    move $a1, $s1
    jal draw_heart
    
    addi $a0, $s0, 6
    move $a1, $s1
    jal draw_heart
    j skip_all_hearts

check_one_life:
    # Si lives == 1, dibujar 1 coraz�n
    li $t3, 1
    bne $t0, $t3, check_zero_lives
    
    move $a0, $s0
    move $a1, $s1
    jal draw_heart
    j skip_all_hearts

check_zero_lives:
    # Si lives == 0, no dibujar nada (ya borrado)
    
skip_all_hearts:
    lw $s6, 28($sp)
    lw $s5, 24($sp)
    lw $s4, 20($sp)
    lw $s3, 16($sp)
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 32
    jr $ra
    
# ===== DELAY =====
delay:
    li $t0, 20000    
delay_loop:
    addi $t0, $t0, -1
    bnez $t0, delay_loop
    jr $ra
