.data
    # Configuracion del display bitmap (512x512, unit size 1)
    displayAddress: .word 0x10008000
    
    # Colores
    BLACK: .word 0x000000
    YELLOW: .word 0xFFFF00      # Pac-Man
    RED: .word 0xFF0000         # Fantasma perseguidor
    CYAN: .word 0x00FFFF        # Fantasma vertical
    BLUE: .word 0x0000FF        # Paredes
    
    # Dimensiones
    WIDTH: .word 512
    HEIGHT: .word 512
    PACMAN_SIZE: .word 8
    GHOST_SIZE: .word 8
    
    # Posición inicial de Pac-Man (centro-izquierda)
    pacmanX: .word 100
    pacmanY: .word 256
    
    # Dirección actual de Pac-Man (0=derecha, 1=arriba, 2=izquierda, 3=abajo)
    pacmanDir: .word 0
    pacmanSpeed: .word 2
    
    # Posición Fantasma 1 (movimiento vertical) - esquina superior derecha
    ghost1X: .word 400
    ghost1Y: .word 100
    ghost1DirY: .word 1         # 1=abajo, -1=arriba
    ghost1Speed: .word 1
    
    # Posición Fantasma 2 (perseguidor) - esquina inferior derecha
    ghost2X: .word 400
    ghost2Y: .word 400
    ghost2Speed: .word 1
    
    # Límites del área de juego (paredes)
    WALL_LEFT: .word 20
    WALL_RIGHT: .word 492
    WALL_TOP: .word 20
    WALL_BOTTOM: .word 492
    
    # Estado del juego
    gameOver: .word 0

.text
.globl main

main:
    # Inicializar display
    jal drawWalls
    
gameLoop:
    # Verificar game over
    lw $t0, gameOver
    bne $t0, $zero, endGame
    
    # Leer teclado
    jal readKeyboard
    
    # Mover Pac-Man
    jal movePacman
    
    # Mover fantasmas
    jal moveGhost1
    jal moveGhost2
    
    # Verificar colisiones
    jal checkCollisions
    
    # Dibujar todo
    jal drawPacman
    jal drawGhost1
    jal drawGhost2
    
    # Pequeña pausa para control de velocidad
    li $v0, 32
    li $a0, 16              # ~60 FPS
    syscall
    
    j gameLoop

endGame:
    # Pantalla de game over
    li $v0, 10
    syscall

# ============================================
# FUNCIÓN: Leer teclado
# ============================================
readKeyboard:
    # Dirección del keyboard MMIO
    li $t0, 0xffff0000
    lw $t1, 0($t0)          # Leer estado del teclado
    andi $t1, $t1, 0x0001   # Verificar bit de ready
    beq $t1, $zero, readKeyboard_end
    
    # Leer tecla presionada
    lw $t2, 4($t0)          # Leer carácter
    
    # Comparar con WASD
    li $t3, 'w'
    beq $t2, $t3, setDirUp
    li $t3, 'W'
    beq $t2, $t3, setDirUp
    
    li $t3, 'a'
    beq $t2, $t3, setDirLeft
    li $t3, 'A'
    beq $t2, $t3, setDirLeft
    
    li $t3, 's'
    beq $t2, $t3, setDirDown
    li $t3, 'S'
    beq $t2, $t3, setDirDown
    
    li $t3, 'd'
    beq $t2, $t3, setDirRight
    li $t3, 'D'
    beq $t2, $t3, setDirRight
    
    j readKeyboard_end

setDirRight:
    li $t0, 0
    sw $t0, pacmanDir
    j readKeyboard_end
    
setDirUp:
    li $t0, 1
    sw $t0, pacmanDir
    j readKeyboard_end
    
setDirLeft:
    li $t0, 2
    sw $t0, pacmanDir
    j readKeyboard_end
    
setDirDown:
    li $t0, 3
    sw $t0, pacmanDir
    j readKeyboard_end

readKeyboard_end:
    jr $ra

# ============================================
# FUNCIÓN: Mover Pac-Man
# ============================================
movePacman:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Borrar posición anterior
    lw $a0, pacmanX
    lw $a1, pacmanY
    lw $a2, PACMAN_SIZE
    lw $a3, BLACK
    jal drawSquare
    
    # Cargar dirección y velocidad
    lw $t0, pacmanDir
    lw $t1, pacmanSpeed
    lw $t2, pacmanX
    lw $t3, pacmanY
    
    # Switch según dirección
    beq $t0, 0, movePacman_right
    beq $t0, 1, movePacman_up
    beq $t0, 2, movePacman_left
    beq $t0, 3, movePacman_down
    j movePacman_end

movePacman_right:
    add $t2, $t2, $t1
    lw $t4, WALL_RIGHT
    lw $t5, PACMAN_SIZE
    add $t6, $t2, $t5
    bgt $t6, $t4, movePacman_clampRight
    j movePacman_update
movePacman_clampRight:
    sub $t2, $t4, $t5
    j movePacman_update

movePacman_left:
    sub $t2, $t2, $t1
    lw $t4, WALL_LEFT
    blt $t2, $t4, movePacman_clampLeft
    j movePacman_update
movePacman_clampLeft:
    move $t2, $t4
    j movePacman_update

movePacman_up:
    sub $t3, $t3, $t1
    lw $t4, WALL_TOP
    blt $t3, $t4, movePacman_clampUp
    j movePacman_update
movePacman_clampUp:
    move $t3, $t4
    j movePacman_update

movePacman_down:
    add $t3, $t3, $t1
    lw $t4, WALL_BOTTOM
    lw $t5, PACMAN_SIZE
    add $t6, $t3, $t5
    bgt $t6, $t4, movePacman_clampDown
    j movePacman_update
movePacman_clampDown:
    sub $t3, $t4, $t5
    j movePacman_update

movePacman_update:
    sw $t2, pacmanX
    sw $t3, pacmanY

movePacman_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ============================================
# FUNCIÓN: Mover Fantasma 1 (vertical)
# ============================================
moveGhost1:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Borrar posición anterior
    lw $a0, ghost1X
    lw $a1, ghost1Y
    lw $a2, GHOST_SIZE
    lw $a3, BLACK
    jal drawSquare
    
    # Cargar posición y dirección
    lw $t0, ghost1Y
    lw $t1, ghost1DirY
    lw $t2, ghost1Speed
    
    # Calcular nueva posición
    mul $t3, $t1, $t2
    add $t0, $t0, $t3
    
    # Verificar límites y cambiar dirección si es necesario
    lw $t4, WALL_TOP
    blt $t0, $t4, ghost1_bounceTop
    
    lw $t4, WALL_BOTTOM
    lw $t5, GHOST_SIZE
    add $t6, $t0, $t5
    bgt $t6, $t4, ghost1_bounceBottom
    
    j ghost1_update

ghost1_bounceTop:
    move $t0, $t4
    li $t1, 1
    sw $t1, ghost1DirY
    j ghost1_update

ghost1_bounceBottom:
    sub $t0, $t4, $t5
    li $t1, -1
    sw $t1, ghost1DirY
    j ghost1_update

ghost1_update:
    sw $t0, ghost1Y
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ============================================
# FUNCIÓN: Mover Fantasma 2 (perseguidor)
# ============================================
moveGhost2:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Borrar posición anterior
    lw $a0, ghost2X
    lw $a1, ghost2Y
    lw $a2, GHOST_SIZE
    lw $a3, BLACK
    jal drawSquare
    
    # Cargar posiciones
    lw $t0, ghost2X
    lw $t1, ghost2Y
    lw $t2, pacmanX
    lw $t3, pacmanY
    lw $t4, ghost2Speed
    
    # Mover en X hacia Pac-Man
    blt $t0, $t2, ghost2_moveRight
    bgt $t0, $t2, ghost2_moveLeft
    j ghost2_checkY

ghost2_moveRight:
    add $t0, $t0, $t4
    j ghost2_checkY

ghost2_moveLeft:
    sub $t0, $t0, $t4

ghost2_checkY:
    # Mover en Y hacia Pac-Man
    blt $t1, $t3, ghost2_moveDown
    bgt $t1, $t3, ghost2_moveUp
    j ghost2_clamp

ghost2_moveDown:
    add $t1, $t1, $t4
    j ghost2_clamp

ghost2_moveUp:
    sub $t1, $t1, $t4

ghost2_clamp:
    # Limitar a paredes
    lw $t5, WALL_LEFT
    blt $t0, $t5, ghost2_clampLeft
    lw $t5, WALL_RIGHT
    lw $t6, GHOST_SIZE
    add $t7, $t0, $t6
    bgt $t7, $t5, ghost2_clampRight
    j ghost2_clampY

ghost2_clampLeft:
    lw $t0, WALL_LEFT
    j ghost2_clampY
    
ghost2_clampRight:
    lw $t5, WALL_RIGHT
    sub $t0, $t5, $t6

ghost2_clampY:
    lw $t5, WALL_TOP
    blt $t1, $t5, ghost2_clampTop
    lw $t5, WALL_BOTTOM
    lw $t6, GHOST_SIZE
    add $t7, $t1, $t6
    bgt $t7, $t5, ghost2_clampBottom
    j ghost2_update

ghost2_clampTop:
    lw $t1, WALL_TOP
    j ghost2_update
    
ghost2_clampBottom:
    lw $t5, WALL_BOTTOM
    sub $t1, $t5, $t6

ghost2_update:
    sw $t0, ghost2X
    sw $t1, ghost2Y
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ============================================
# FUNCIÓN: Verificar colisiones
# ============================================
checkCollisions:
    # Colisión con fantasma 1
    lw $t0, pacmanX
    lw $t1, pacmanY
    lw $t2, ghost1X
    lw $t3, ghost1Y
    lw $t4, PACMAN_SIZE
    
    # Verificar overlap en X
    add $t5, $t0, $t4
    blt $t5, $t2, check_ghost2
    add $t6, $t2, $t4
    blt $t6, $t0, check_ghost2
    
    # Verificar overlap en Y
    add $t5, $t1, $t4
    blt $t5, $t3, check_ghost2
    add $t6, $t3, $t4
    blt $t6, $t1, check_ghost2
    
    # Hay colisión!
    li $t0, 1
    sw $t0, gameOver
    jr $ra

check_ghost2:
    # Colisión con fantasma 2
    lw $t0, pacmanX
    lw $t1, pacmanY
    lw $t2, ghost2X
    lw $t3, ghost2Y
    lw $t4, PACMAN_SIZE
    
    # Verificar overlap en X
    add $t5, $t0, $t4
    blt $t5, $t2, checkCollisions_end
    add $t6, $t2, $t4
    blt $t6, $t0, checkCollisions_end
    
    # Verificar overlap en Y
    add $t5, $t1, $t4
    blt $t5, $t3, checkCollisions_end
    add $t6, $t3, $t4
    blt $t6, $t1, checkCollisions_end
    
    # Hay colisión!
    li $t0, 1
    sw $t0, gameOver

checkCollisions_end:
    jr $ra

# ============================================
# FUNCIÓN: Dibujar Pac-Man
# ============================================
drawPacman:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $a0, pacmanX
    lw $a1, pacmanY
    lw $a2, PACMAN_SIZE
    lw $a3, YELLOW
    jal drawSquare
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ============================================
# FUNCIÓN: Dibujar Fantasma 1
# ============================================
drawGhost1:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $a0, ghost1X
    lw $a1, ghost1Y
    lw $a2, GHOST_SIZE
    lw $a3, CYAN
    jal drawSquare
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ============================================
# FUNCIÓN: Dibujar Fantasma 2
# ============================================
drawGhost2:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $a0, ghost2X
    lw $a1, ghost2Y
    lw $a2, GHOST_SIZE
    lw $a3, RED
    jal drawSquare
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ============================================
# FUNCIÓN: Dibujar paredes
# ============================================
drawWalls:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Pared superior
    li $a0, 0
    lw $a1, WALL_TOP
    lw $a2, WIDTH
    li $a3, 4
    lw $t0, BLUE
    move $a3, $t0
    jal drawRect
    
    # Pared inferior
    li $a0, 0
    lw $a1, WALL_BOTTOM
    lw $a2, WIDTH
    li $a3, 20
    lw $t0, BLUE
    move $a3, $t0
    jal drawRect
    
    # Pared izquierda
    lw $a0, WALL_LEFT
    li $a1, 0
    li $a2, 4
    lw $a3, HEIGHT
    lw $t0, BLUE
    move $a3, $t0
    jal drawRect
    
    # Pared derecha
    lw $a0, WALL_RIGHT
    li $a1, 0
    li $a2, 20
    lw $a3, HEIGHT
    lw $t0, BLUE
    move $a3, $t0
    jal drawRect
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ============================================
# FUNCIÓN: Dibujar cuadrado
# $a0 = x, $a1 = y, $a2 = size, $a3 = color
# ============================================
drawSquare:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    
    move $s0, $a0           # x
    move $s1, $a1           # y
    move $s2, $a2           # size
    move $s3, $a3           # color
    
    li $t0, 0               # contador y
drawSquare_loopY:
    bge $t0, $s2, drawSquare_end
    li $t1, 0               # contador x
    
drawSquare_loopX:
    bge $t1, $s2, drawSquare_nextY
    
    # Calcular posición del pixel
    add $t2, $s0, $t1       # x actual
    add $t3, $s1, $t0       # y actual
    
    # Calcular offset en memoria
    lw $t4, WIDTH
    mul $t5, $t3, $t4       # y * ancho
    add $t5, $t5, $t2       # + x
    sll $t5, $t5, 2         # * 4 (bytes por pixel)
    
    lw $t6, displayAddress
    add $t6, $t6, $t5
    sw $s3, 0($t6)          # Pintar pixel
    
    addi $t1, $t1, 1
    j drawSquare_loopX

drawSquare_nextY:
    addi $t0, $t0, 1
    j drawSquare_loopY

drawSquare_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

# ============================================
# FUNCIÓN: Dibujar rectángulo
# $a0 = x, $a1 = y, $a2 = width, $a3 = height (pero se usa como color por el código de paredes)
# ============================================
drawRect:
    # Simplificación: esta función necesita ajuste según el uso
    jr $ra
