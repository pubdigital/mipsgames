.data
    display: .word 0x10008000
    display_back: .word 0x10040000
    negro: .word 0x00000000
    azul: .word 0x000088FF
    rojo: .word 0x00FF0000
    verde: .word 0x0000FF00
    blanco: .word 0x00FFFFFF
    amarillo: .word 0x00FFFF00
    
    nave_x: .word 31
    nave_y: .word 50
    
    asteroides: .space 400      # 20 asteroides * 20 bytes (x, y, dx, dy, tipo)
    num_ast: .word 0
    frames: .word 0
    seed: .word 12345
    
    vidas: .word 3
    game_over: .word 0
    invulnerable: .word 0
    invul_frames: .word 0

.text
main:
    li $sp, 0x7ffffffc

game_loop:
    lw $t0, game_over
    bnez $t0, fin_juego
    
    jal actualizar_invulnerabilidad
    jal limpiar_back_buffer
    jal teclas
    jal mover_asteroides
    jal crear_asteroide
    jal dibujar_nave_back
    jal dibujar_asteroides_back
    jal dibujar_vidas_back
    jal verificar_colisiones
    jal swap_buffers
    jal esperar
    j game_loop

fin_juego:
    jal dibujar_calavera_back
    j fin_juego

# ==========================================
# DOUBLE BUFFERING FUNCTIONS
# ==========================================
limpiar_back_buffer:
    lw $t0, display_back
    lw $t1, negro
    li $t2, 4096
limpiar_back_loop:
    sw $t1, 0($t0)
    addiu $t0, $t0, 4
    addiu $t2, $t2, -1
    bnez $t2, limpiar_back_loop
    jr $ra

swap_buffers:
    lw $t0, display
    lw $t1, display_back
    li $t2, 4096
swap_loop:
    lw $t3, 0($t1)
    sw $t3, 0($t0)
    addiu $t0, $t0, 4
    addiu $t1, $t1, 4
    addiu $t2, $t2, -1
    bnez $t2, swap_loop
    jr $ra

# ==========================================
# PIXEL PARA BACK BUFFER
# ==========================================
pixel_back:
    bltz $a0, pixel_back_fin
    li $t9, 64
    bge $a0, $t9, pixel_back_fin
    bltz $a1, pixel_back_fin
    bge $a1, $t9, pixel_back_fin
    
    sll $t0, $a1, 6
    addu $t0, $t0, $a0
    sll $t0, $t0, 2
    
    lw $t1, display_back
    addu $t1, $t1, $t0
    sw $a2, 0($t1)

pixel_back_fin:
    jr $ra

# ==========================================
# DIBUJAR METEORITO GRANDE
# ==========================================
dibujar_meteorito_grande_back:
    # $a0 = x, $a1 = y, $a2 = color
    addiu $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    move $s0, $a0  # Guardar posición base x
    move $s1, $a1  # Guardar posición base y
    move $s2, $a2  # Guardar color
    
    # Patrón 4x4 del meteorito grande
    # Fila 0: X X X X
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal pixel_back
    addiu $a0, $s0, 1
    jal pixel_back
    addiu $a0, $s0, 2
    jal pixel_back
    addiu $a0, $s0, 3
    jal pixel_back
    
    # Fila 1: X X X X
    addiu $a1, $s1, 1
    move $a0, $s0
    jal pixel_back
    addiu $a0, $s0, 1
    jal pixel_back
    addiu $a0, $s0, 2
    jal pixel_back
    addiu $a0, $s0, 3
    jal pixel_back
    
    # Fila 2: X X X X
    addiu $a1, $s1, 2
    move $a0, $s0
    jal pixel_back
    addiu $a0, $s0, 1
    jal pixel_back
    addiu $a0, $s0, 2
    jal pixel_back
    addiu $a0, $s0, 3
    jal pixel_back
    
    # Fila 3: X X X X
    addiu $a1, $s1, 3
    move $a0, $s0
    jal pixel_back
    addiu $a0, $s0, 1
    jal pixel_back
    addiu $a0, $s0, 2
    jal pixel_back
    addiu $a0, $s0, 3
    jal pixel_back
    
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addiu $sp, $sp, 16
    jr $ra

# ==========================================
# FUNCIONES DE DIBUJO
# ==========================================
dibujar_calavera_back:
    jal limpiar_back_buffer
    lw $a2, blanco
    
    # Ojos de la calavera
    li $a0, 29
    li $a1, 28
    jal pixel_back
    li $a0, 34
    jal pixel_back
    
    # Nariz
    li $a0, 31
    li $a1, 30
    jal pixel_back
    li $a0, 32
    jal pixel_back
    
    # Boca
    li $a0, 28
    li $a1, 32
    jal pixel_back
    li $a0, 29
    li $a1, 33
    jal pixel_back
    li $a0, 30
    li $a1, 34
    jal pixel_back
    li $a0, 31
    li $a1, 34
    jal pixel_back
    li $a0, 32
    li $a1, 34
    jal pixel_back
    li $a0, 33
    li $a1, 33
    jal pixel_back
    li $a0, 34
    li $a1, 32
    jal pixel_back
    
    jal swap_buffers
    jr $ra

dibujar_vidas_back:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, vidas
    lw $a2, verde
    
    beq $t0, 3, dibujar_tres_vidas_back
    beq $t0, 2, dibujar_dos_vidas_back  
    beq $t0, 1, dibujar_una_vida_back
    j dibujar_vidas_back_fin

dibujar_tres_vidas_back:
    li $a0, 2
    li $a1, 2
    jal pixel_back
    addiu $a0, $a0, 1
    jal pixel_back
    
    li $a0, 5
    li $a1, 2
    jal pixel_back
    addiu $a0, $a0, 1
    jal pixel_back
    
    li $a0, 8
    li $a1, 2
    jal pixel_back
    addiu $a0, $a0, 1
    jal pixel_back
    j dibujar_vidas_back_fin

dibujar_dos_vidas_back:
    li $a0, 2
    li $a1, 2
    jal pixel_back
    addiu $a0, $a0, 1
    jal pixel_back
    
    li $a0, 5
    li $a1, 2
    jal pixel_back
    addiu $a0, $a0, 1
    jal pixel_back
    j dibujar_vidas_back_fin

dibujar_una_vida_back:
    li $a0, 2
    li $a1, 2
    jal pixel_back
    addiu $a0, $a0, 1
    jal pixel_back

dibujar_vidas_back_fin:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

dibujar_nave_back:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, invulnerable
    beqz $t0, dibujar_nave_normal_back
    
    lw $t1, invul_frames
    andi $t1, $t1, 2
    bnez $t1, dibujar_nave_back_fin

dibujar_nave_normal_back:
    lw $t0, nave_x
    lw $t1, nave_y
    lw $t2, azul
    
    move $a0, $t0
    move $a1, $t1
    move $a2, $t2
    jal pixel_back
    
    addiu $a0, $t0, 1
    jal pixel_back
    
    move $a0, $t0
    addiu $a1, $t1, 1
    jal pixel_back
    
    addiu $a0, $t0, 1
    addiu $a1, $t1, 1
    jal pixel_back

dibujar_nave_back_fin:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

dibujar_asteroides_back:
    lw $t0, num_ast
    beqz $t0, dibujar_ast_back_fin
    
    addiu $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    
    li $s0, 0
    la $t7, asteroides

dibujar_ast_back_loop:
    lw $t0, num_ast
    bge $s0, $t0, dibujar_ast_back_done
    
    # Cada asteroide usa 20 bytes: x, y, dx, dy, tipo
    mul $t2, $s0, 20
    addu $t3, $t7, $t2
    
    lw $a0, 0($t3)    # x
    lw $a1, 4($t3)    # y
    lw $t4, 16($t3)   # tipo (0=pequeño, 1=grande)
    
    beqz $t4, dibujar_ast_pequeno_back
    
    # Dibujar asteroide grande
    lw $a2, amarillo
    jal dibujar_meteorito_grande_back
    j siguiente_ast_back
    
dibujar_ast_pequeno_back:
    lw $a2, rojo
    jal pixel_back

siguiente_ast_back:
    addiu $s0, $s0, 1
    j dibujar_ast_back_loop

dibujar_ast_back_done:
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addiu $sp, $sp, 12

dibujar_ast_back_fin:
    jr $ra

# ==========================================
# FUNCIONES DE COLISIONES MODIFICADAS
# ==========================================
verificar_colisiones:
    lw $t0, invulnerable
    bnez $t0, colisiones_fin
    
    lw $t0, num_ast
    beqz $t0, colisiones_fin
    
    lw $t1, nave_x
    lw $t2, nave_y
    
    li $t3, 0
    la $t4, asteroides

colisiones_loop:
    bge $t3, $t0, colisiones_fin
    
    # Cada asteroide usa 20 bytes
    mul $t5, $t3, 20
    addu $t6, $t4, $t5
    
    lw $t7, 0($t6)    # x
    lw $t8, 4($t6)    # y
    lw $s5, 16($t6)   # tipo
    
    beqz $s5, colision_pequena
    j colision_grande

colision_pequena:
    # Colisión con meteorito pequeño (1x1)
    blt $t7, $t1, siguiente_colision
    addiu $t9, $t1, 1
    bgt $t7, $t9, siguiente_colision
    blt $t8, $t2, siguiente_colision
    addiu $t9, $t2, 1
    bgt $t8, $t9, siguiente_colision
    
    j colision_detectada

colision_grande:
    # Colisión con meteorito grande (4x4)
    addiu $s0, $t7, 3    # x + 3 (ancho del meteorito grande)
    addiu $s1, $t8, 3    # y + 3 (alto del meteorito grande)
    
    addiu $s2, $t1, 1    # x_nave + 1 (ancho de la nave)
    addiu $s3, $t2, 1    # y_nave + 1 (alto de la nave)
    
    # Verificar solapamiento
    bgt $t1, $s0, siguiente_colision    # nave_x > meteorito_x+3
    bgt $t7, $s2, siguiente_colision    # meteorito_x > nave_x+1
    bgt $t2, $s1, siguiente_colision    # nave_y > meteorito_y+3
    bgt $t8, $s3, siguiente_colision    # meteorito_y > nave_y+1
    
colision_detectada:
    lw $s0, vidas
    addiu $s0, $s0, -1
    sw $s0, vidas
    
    # Mover el asteroide fuera de pantalla
    li $s1, 100
    sw $s1, 4($t6)
    
    li $s2, 1
    sw $s2, invulnerable
    sw $zero, invul_frames
    
    bgtz $s0, colisiones_fin
    li $s2, 1
    sw $s2, game_over
    j colisiones_fin

siguiente_colision:
    addiu $t3, $t3, 1
    j colisiones_loop

colisiones_fin:
    jr $ra

# ==========================================
# FUNCIONES DE MOVIMIENTO MODIFICADAS
# ==========================================
actualizar_invulnerabilidad:
    lw $t0, invulnerable
    beqz $t0, invul_fin
    
    lw $t1, invul_frames
    addiu $t1, $t1, 1
    sw $t1, invul_frames
    
    li $t2, 30
    blt $t1, $t2, invul_fin
    
    sw $zero, invulnerable
    sw $zero, invul_frames

invul_fin:
    jr $ra

rand:
    lw $t0, seed
    li $t1, 1103515245
    mult $t0, $t1
    mflo $t0
    addiu $t0, $t0, 12345
    sw $t0, seed
    move $v0, $t0
    jr $ra

crear_asteroide:
    lw $t0, frames
    addiu $t0, $t0, 1
    sw $t0, frames
    
    li $t1, 15  # Reducido para más asteroides
    blt $t0, $t1, crear_fin
    
    sw $zero, frames
    
    lw $t0, num_ast
    li $t1, 15  # Aumentado el máximo de asteroides
    bge $t0, $t1, crear_fin
    
    addiu $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    jal rand
    move $s1, $v0      # Guardar valor random
    
    # Decidir dirección del asteroide (0=arriba, 1=izquierda, 2=derecha)
    andi $t0, $s1, 0x3  # 0-3
    li $t1, 3
    beq $t0, $t1, crear_fin_pop  # 25% de no crear asteroide
    
    # Decidir tipo de asteroide (25% grandes)
    srl $s2, $s1, 8
    andi $s2, $s2, 0xFF
    li $t9, 64  # 25% probabilidad
    blt $s2, $t9, asteroide_grande
    
    # Asteroide pequeño
    li $s0, 0
    j decidir_direccion
    
asteroide_grande:
    li $s0, 1

decidir_direccion:
    # Usar otro bit aleatorio para dirección
    srl $t2, $s1, 16
    andi $t2, $t2, 0x3  # 0-3
    
    # 0 = desde arriba (hacia abajo)
    # 1 = desde izquierda (hacia derecha)  
    # 2 = desde derecha (hacia izquierda)
    # 3 = diagonal (abajo-derecha o abajo-izquierda)
    
    beqz $t2, desde_arriba
    li $t3, 1
    beq $t2, $t3, desde_izquierda
    li $t3, 2
    beq $t2, $t3, desde_derecha
    j desde_diagonal

desde_arriba:
    # Posición X aleatoria, Y = 0
    andi $t4, $s1, 63
    # Ajustar para meteoritos grandes
    beqz $s0, desde_arriba_pequeno
    # Para grandes, evitar bordes
    blt $t4, 2, ajustar_arriba_min
    bgt $t4, 59, ajustar_arriba_max
    j desde_arriba_continuar
    
ajustar_arriba_min:
    li $t4, 2
    j desde_arriba_continuar
    
ajustar_arriba_max:
    li $t4, 59
    
desde_arriba_pequeno:
    # Para pequeños, cualquier posición está bien
desde_arriba_continuar:
    li $t5, 0          # y = 0
    li $t6, 0          # dx = 0
    li $t7, 1          # dy = 1 (hacia abajo)
    j guardar_ast

desde_izquierda:
    # X = 0, posición Y aleatoria
    andi $t5, $s1, 63
    # Ajustar para meteoritos grandes
    beqz $s0, desde_izquierda_pequeno
    # Para grandes, evitar bordes
    blt $t5, 2, ajustar_izquierda_min
    bgt $t5, 59, ajustar_izquierda_max
    j desde_izquierda_continuar
    
ajustar_izquierda_min:
    li $t5, 2
    j desde_izquierda_continuar
    
ajustar_izquierda_max:
    li $t5, 59
    
desde_izquierda_pequeno:
    # Para pequeños, cualquier posición está bien
desde_izquierda_continuar:
    li $t4, 0          # x = 0
    li $t6, 1          # dx = 1 (hacia derecha)
    li $t7, 0          # dy = 0
    j guardar_ast

desde_derecha:
    # X = 63, posición Y aleatoria
    andi $t5, $s1, 63
    # Ajustar para meteoritos grandes
    beqz $s0, desde_derecha_pequeno
    # Para grandes, evitar bordes
    blt $t5, 2, ajustar_derecha_min
    bgt $t5, 59, ajustar_derecha_max
    j desde_derecha_continuar
    
ajustar_derecha_min:
    li $t5, 2
    j desde_derecha_continuar
    
ajustar_derecha_max:
    li $t5, 59
    
desde_derecha_pequeno:
    # Para pequeños, cualquier posición está bien
desde_derecha_continuar:
    li $t4, 63         # x = 63
    li $t6, -1         # dx = -1 (hacia izquierda)
    li $t7, 0          # dy = 0
    j guardar_ast

desde_diagonal:
    # Decidir dirección diagonal
    srl $t8, $s1, 24
    andi $t8, $t8, 0x1
    beqz $t8, diagonal_abajo_derecha
    
    # Diagonal abajo-izquierda (desde derecha)
    li $t4, 63         # x = 63
    andi $t5, $s1, 63  # y aleatorio
    li $t6, -1         # dx = -1
    li $t7, 1          # dy = 1
    j diagonal_ajustar

diagonal_abajo_derecha:
    # Diagonal abajo-derecha (desde izquierda)
    li $t4, 0          # x = 0
    andi $t5, $s1, 63  # y aleatorio
    li $t6, 1          # dx = 1
    li $t7, 1          # dy = 1

diagonal_ajustar:
    # Ajustar para meteoritos grandes
    beqz $s0, guardar_ast
    # Para grandes en diagonal, ajustar posición Y
    blt $t5, 2, ajustar_diagonal_min
    bgt $t5, 59, ajustar_diagonal_max
    j guardar_ast
    
ajustar_diagonal_min:
    li $t5, 2
    j guardar_ast
    
ajustar_diagonal_max:
    li $t5, 59

guardar_ast:
    lw $t9, num_ast
    # Cada asteroide usa 20 bytes: x, y, dx, dy, tipo
    mul $t2, $t9, 20
    la $t3, asteroides
    addu $t3, $t3, $t2
    
    sw $t4, 0($t3)   # x
    sw $t5, 4($t3)   # y
    sw $t6, 8($t3)   # dx
    sw $t7, 12($t3)  # dy
    sw $s0, 16($t3)  # tipo (0=pequeño, 1=grande)
    
    addiu $t9, $t9, 1
    sw $t9, num_ast

crear_fin_pop:
    # Restaurar registros
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addiu $sp, $sp, 16

crear_fin:
    jr $ra

teclas:
    lui $t0, 0xffff
    lw $t1, 0($t0)
    andi $t1, $t1, 1
    beqz $t1, teclas_fin
    
    lw $t2, 4($t0)
    
    li $t3, 119      # 'w' - arriba
    beq $t2, $t3, t_arriba
    li $t3, 115      # 's' - abajo
    beq $t2, $t3, t_abajo
    li $t3, 97       # 'a' - izquierda
    beq $t2, $t3, t_izq
    li $t3, 100      # 'd' - derecha
    beq $t2, $t3, t_der
    j teclas_fin

t_arriba:
    lw $t0, nave_y
    blez $t0, teclas_fin
    addiu $t0, $t0, -1
    sw $t0, nave_y
    j teclas_fin

t_abajo:
    lw $t0, nave_y
    li $t1, 62
    bge $t0, $t1, teclas_fin
    addiu $t0, $t0, 1
    sw $t0, nave_y
    j teclas_fin

t_izq:
    lw $t0, nave_x
    blez $t0, teclas_fin
    addiu $t0, $t0, -1
    sw $t0, nave_x
    j teclas_fin

t_der:
    lw $t0, nave_x
    li $t1, 62
    bge $t0, $t1, teclas_fin
    addiu $t0, $t0, 1
    sw $t0, nave_x

teclas_fin:
    jr $ra

mover_asteroides:
    lw $t0, num_ast
    beqz $t0, mover_fin
    
    li $t1, 0
    la $t7, asteroides

mover_loop:
    bge $t1, $t0, mover_fin
    
    # Cada asteroide usa 20 bytes
    mul $t2, $t1, 20
    addu $t3, $t7, $t2
    
    lw $t4, 0($t3)   # x
    lw $t5, 4($t3)   # y
    lw $t6, 8($t3)   # dx
    lw $t8, 12($t3)  # dy
    
    # Mover según dirección
    addu $t4, $t4, $t6
    addu $t5, $t5, $t8
    
    # Verificar si está fuera de pantalla
    li $t9, 64
    bge $t5, $t9, borrar_ast    # Fuera por abajo
    bltz $t5, borrar_ast        # Fuera por arriba
    bge $t4, $t9, borrar_ast    # Fuera por derecha
    bltz $t4, borrar_ast        # Fuera por izquierda
    
    # Actualizar posición
    sw $t4, 0($t3)
    sw $t5, 4($t3)
    
    addiu $t1, $t1, 1
    j mover_loop

borrar_ast:
    lw $t0, num_ast
    addiu $t0, $t0, -1
    sw $t0, num_ast
    
    beq $t1, $t0, mover_fin
    
    # Copiar el último asteroide a la posición actual
    mul $t9, $t0, 20
    addu $s0, $t7, $t9
    
    lw $s1, 0($s0)   # x
    lw $s2, 4($s0)   # y
    lw $s3, 8($s0)   # dx
    lw $s4, 12($s0)  # dy
    lw $s5, 16($s0)  # tipo
    
    sw $s1, 0($t3)
    sw $s2, 4($t3)
    sw $s3, 8($t3)
    sw $s4, 12($t3)
    sw $s5, 16($t3)
    
    j mover_loop

mover_fin:
    jr $ra

esperar:
    li $t0, 8000  # Reducido para mejor fluidez con más asteroides
esperar_loop:
    addiu $t0, $t0, -1
    bnez $t0, esperar_loop
    jr $ra