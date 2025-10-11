########################################################################
# Clon de Donkey Kong - MIPS Assembly
# Autor: Ignacio Joaquin (grupo 2)
# Fecha: Octubre 2025
# 
# Controles:
#   'a' - Mover izquierda
#   'd' - Mover derecha
#   'w' - Saltar
#   'q' - Salir del juego
#
# Descripción:
#   Plataformero simple inspirado en Donkey Kong. El jugador debe
#   escalar plataformas mientras evita barriles para llegar a la cima.
########################################################################

.data
    # Configuración del display
    displayAddress: .word 0x10008000
    displayWidth: .word 64
    displayHeight: .word 64
    
    # Paleta de colores
    colorBlack: .word 0x000000
    colorRed: .word 0xFF0000
    colorBlue: .word 0x0000FF
    colorWhite: .word 0xFFFFFF
    colorBrown: .word 0x8B4513
    colorYellow: .word 0xFFFF00
    colorGreen: .word 0x00FF00
    colorOrange: .word 0xFF8C00
    
    # Estado del jugador
    playerX: .word 4
    playerY: .word 58
    playerVelY: .word 0
    isJumping: .word 0
    jumpStrength: .word -4
    gravity: .word 1
    onGround: .word 1
    
    # Estado del juego
    score: .word 0
    gameOver: .word 0
    winCondition: .word 0
    
    # Datos de barriles (máximo 3 barriles)
    numBarrels: .word 0
    barrelX: .word 60, 60, 60
    barrelY: .word 8, 8, 8
    barrelActive: .word 0, 0, 0
    
    # Definición de plataformas (y-posición, inicio-x, fin-x)
    platforms: .word 60, 0, 63    # suelo
               .word 47, 8, 56
               .word 35, 8, 56
               .word 23, 8, 56
               .word 11, 8, 56
               .word 4, 20, 44    # plataforma superior (meta)
    numPlatforms: .word 6
    
    # Contador de frames para generar barriles
    frameCount: .word 0
    spawnInterval: .word 80
    
    # Mensajes
    msgWin: .asciiz "\nGanaste! Puntaje: "
    msgLose: .asciiz "\nGame Over! Puntaje: "
    newline: .asciiz "\n"

.text
.globl main

main:
    # Inicializar display
    jal clearScreen
    
    # Bucle principal del juego
    gameLoop:
        # Verificar si el juego terminó
        lw $t0, gameOver
        bne $t0, $zero, endGame
        
        lw $t0, winCondition
        bne $t0, $zero, endGame
        
        # Limpiar pantalla cada frame
        jal clearScreen
        
        # Dibujar elementos del juego
        jal drawPlatforms
        jal drawGoal
        jal updateBarrels
        jal drawBarrels
        jal drawPlayer
        
        # Manejar entrada del usuario
        jal checkInput
        
        # Actualizar física
        jal updatePlayer
        
        # Verificar colisiones
        jal checkPlatformCollision
        jal checkBarrelCollision
        jal checkWinCondition
        
        # Generar barriles periódicamente
        jal spawnBarrel
        
        # Pequeño delay para velocidad del juego
        li $v0, 32
        li $a0, 50
        syscall
        
        j gameLoop
    
    endGame:
        # Verificar si ganó o perdió
        lw $t0, winCondition
        beq $t0, $zero, gameLost
        
        # El jugador ganó
        li $v0, 4
        la $a0, msgWin
        syscall
        
        li $v0, 1
        lw $a0, score
        syscall
        j exitProgram
        
    gameLost:
        # El jugador perdió
        li $v0, 4
        la $a0, msgLose
        syscall
        
        li $v0, 1
        lw $a0, score
        syscall
        
    exitProgram:
        li $v0, 10
        syscall

########################################################################
# clearScreen - Rellena toda la pantalla con negro
########################################################################
clearScreen:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, displayAddress
    lw $t1, colorBlack
    lw $t2, displayWidth
    lw $t3, displayHeight
    mul $t2, $t2, $t3      # total de píxeles
    
    clearLoop:
        beq $t2, $zero, clearDone
        sw $t1, 0($t0)
        addi $t0, $t0, 4
        addi $t2, $t2, -1
        j clearLoop
    
    clearDone:
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

########################################################################
# drawPlatforms - Dibuja todas las plataformas del juego
########################################################################
drawPlatforms:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $t0, platforms      # puntero a datos de plataformas
    lw $t1, numPlatforms   # número de plataformas
    
    drawPlatformLoop:
        beq $t1, $zero, drawPlatformsDone
        
        # Cargar datos de la plataforma actual
        lw $a1, 0($t0)     # y posición
        lw $a0, 4($t0)     # x inicio
        lw $a2, 8($t0)     # x fin
        lw $a3, colorBrown # color
        
        # Guardar registros temporales
        addi $sp, $sp, -12
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        
        # Dibujar línea horizontal para esta plataforma
        move $t2, $a0      # x actual
        drawPlatformLine:
            bgt $t2, $a2, drawPlatformLineDone
            
            move $a0, $t2
            # $a1 ya contiene y
            # $a3 ya contiene color
            jal drawPixel
            
            addi $t2, $t2, 1
            j drawPlatformLine
        
        drawPlatformLineDone:
            # Restaurar registros
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            addi $sp, $sp, 12
            
            # Avanzar al siguiente conjunto de datos de plataforma
            addi $t0, $t0, 12
            addi $t1, $t1, -1
            j drawPlatformLoop
    
    drawPlatformsDone:
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

########################################################################
# drawPlayer - Dibuja el jugador (Mario) como un cuadrado 3x3
########################################################################
drawPlayer:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $a0, playerX
    lw $a1, playerY
    lw $a3, colorRed
    
    # Dibujar jugador 3x3
    addi $sp, $sp, -8
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    
    # Fila 1
    jal drawPixel
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addi $a0, $a0, 1
    jal drawPixel
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addi $a0, $a0, 2
    jal drawPixel
    
    # Fila 2
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addi $a1, $a1, 1
    jal drawPixel
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    jal drawPixel
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addi $a0, $a0, 2
    addi $a1, $a1, 1
    jal drawPixel
    
    # Fila 3
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addi $a1, $a1, 2
    jal drawPixel
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addi $a0, $a0, 1
    addi $a1, $a1, 2
    jal drawPixel
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    addi $a0, $a0, 2
    addi $a1, $a1, 2
    jal drawPixel
    
    addi $sp, $sp, 8
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

########################################################################
# drawGoal - Dibuja la zona de meta en la plataforma superior
########################################################################
drawGoal:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Dibujar un rectángulo amarillo en la meta
    li $t0, 20         # x inicio
    li $t1, 2          # y posición
    li $t2, 44         # x fin
    lw $a3, colorYellow
    
    drawGoalLoop:
        bgt $t0, $t2, drawGoalDone
        
        move $a0, $t0
        move $a1, $t1
        jal drawPixel
        
        addi $a1, $a1, 1  # dibujar abajo también
        jal drawPixel
        
        addi $t0, $t0, 1
        j drawGoalLoop
    
    drawGoalDone:
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

########################################################################
# drawBarrels - Dibuja todos los barriles activos
########################################################################
drawBarrels:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 0          # índice del barril
    
    drawBarrelLoop:
        bge $t0, 3, drawBarrelsDone  # máximo 3 barriles
        
        # Verificar si este barril está activo
        la $t1, barrelActive
        sll $t2, $t0, 2
        add $t1, $t1, $t2
        lw $t3, 0($t1)
        beq $t3, $zero, skipBarrel
        
        # Obtener posición del barril
        la $t1, barrelX
        add $t1, $t1, $t2
        lw $a0, 0($t1)
        
        la $t1, barrelY
        add $t1, $t1, $t2
        lw $a1, 0($t1)
        
        # Dibujar barril (3x3 píxeles naranjas)
        lw $a3, colorOrange
        
        addi $sp, $sp, -12
        sw $t0, 0($sp)
        sw $a0, 4($sp)
        sw $a1, 8($sp)
        
        # Fila 1
        jal drawPixel
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addi $a0, $a0, 1
        jal drawPixel
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addi $a0, $a0, 2
        jal drawPixel
        
        # Fila 2
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addi $a1, $a1, 1
        jal drawPixel
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addi $a0, $a0, 1
        addi $a1, $a1, 1
        jal drawPixel
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addi $a0, $a0, 2
        addi $a1, $a1, 1
        jal drawPixel
        
        # Fila 3
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addi $a1, $a1, 2
        jal drawPixel
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addi $a0, $a0, 1
        addi $a1, $a1, 2
        jal drawPixel
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        addi $a0, $a0, 2
        addi $a1, $a1, 2
        jal drawPixel
        
        lw $t0, 0($sp)
        addi $sp, $sp, 12
        
    skipBarrel:
        addi $t0, $t0, 1
        j drawBarrelLoop
    
    drawBarrelsDone:
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

########################################################################
# updateBarrels - Actualiza posición de todos los barriles
########################################################################
updateBarrels:
    li $t0, 0          # índice del barril
    
    updateBarrelLoop:
        bge $t0, 3, updateBarrelsDone
        
        # Verificar si este barril está activo
        la $t1, barrelActive
        sll $t2, $t0, 2
        add $t1, $t1, $t2
        lw $t3, 0($t1)
        beq $t3, $zero, skipUpdate
        
        # Mover barril hacia abajo y a la izquierda
        la $t1, barrelY
        add $t1, $t1, $t2
        lw $t4, 0($t1)
        addi $t4, $t4, 2   # mover abajo
        sw $t4, 0($t1)
        
        la $t1, barrelX
        add $t1, $t1, $t2
        lw $t4, 0($t1)
        addi $t4, $t4, -2  # mover izquierda
        sw $t4, 0($t1)
        
        # Desactivar barril si sale de la pantalla
        lw $t4, 0($t1)
        blt $t4, -5, deactivateBarrel
        
        la $t1, barrelY
        add $t1, $t1, $t2
        lw $t4, 0($t1)
        bgt $t4, 65, deactivateBarrel
        j skipUpdate
        
    deactivateBarrel:
        la $t1, barrelActive
        add $t1, $t1, $t2
        sw $zero, 0($t1)
        
        # Incrementar puntaje por esquivar barril
        lw $t5, score
        addi $t5, $t5, 10
        sw $t5, score
        
    skipUpdate:
        addi $t0, $t0, 1
        j updateBarrelLoop
    
    updateBarrelsDone:
        jr $ra

########################################################################
# spawnBarrel - Genera un nuevo barril periódicamente
########################################################################
spawnBarrel:
    # Incrementar contador de frames
    lw $t0, frameCount
    addi $t0, $t0, 1
    sw $t0, frameCount
    
    # Verificar si es momento de generar
    lw $t1, spawnInterval
    div $t0, $t1
    mfhi $t2
    bne $t2, $zero, spawnDone
    
    # Buscar slot disponible para barril
    li $t0, 0
    findSlot:
        bge $t0, 3, spawnDone
        
        la $t1, barrelActive
        sll $t2, $t0, 2
        add $t1, $t1, $t2
        lw $t3, 0($t1)
        bne $t3, $zero, nextSlot
        
        # Activar este barril
        li $t3, 1
        sw $t3, 0($t1)
        
        # Establecer posición inicial
        la $t1, barrelX
        add $t1, $t1, $t2
        li $t3, 58
        sw $t3, 0($t1)
        
        la $t1, barrelY
        add $t1, $t1, $t2
        li $t3, 6
        sw $t3, 0($t1)
        
        j spawnDone
        
    nextSlot:
        addi $t0, $t0, 1
        j findSlot
    
    spawnDone:
        jr $ra

########################################################################
# checkInput - Verifica entrada del teclado
########################################################################
checkInput:
    # Verificar si hay tecla presionada
    li $t0, 0xffff0000
    lw $t1, 0($t0)
    andi $t1, $t1, 0x0001
    beq $t1, $zero, inputDone
    
    # Leer el carácter
    lw $t2, 4($t0)
    
    # Verificar 'a' (izquierda)
    li $t3, 0x61
    bne $t2, $t3, checkD
    lw $t4, playerX
    addi $t4, $t4, -2
    blt $t4, 0, inputDone
    sw $t4, playerX
    j inputDone
    
    # Verificar 'd' (derecha)
    checkD:
    li $t3, 0x64
    bne $t2, $t3, checkW
    lw $t4, playerX
    addi $t4, $t4, 2
    bgt $t4, 61, inputDone
    sw $t4, playerX
    j inputDone
    
    # Verificar 'w' (saltar)
    checkW:
    li $t3, 0x77
    bne $t2, $t3, checkQ
    lw $t4, onGround
    beq $t4, $zero, inputDone
    
    # Iniciar salto
    li $t4, 1
    sw $t4, isJumping
    sw $zero, onGround
    lw $t4, jumpStrength
    sw $t4, playerVelY
    j inputDone
    
    # Verificar 'q' (salir)
    checkQ:
    li $t3, 0x71
    bne $t2, $t3, inputDone
    li $t4, 1
    sw $t4, gameOver
    
    inputDone:
        jr $ra

########################################################################
# updatePlayer - Actualiza física del jugador (gravedad, velocidad)
########################################################################
updatePlayer:
    # Aplicar gravedad
    lw $t0, playerVelY
    lw $t1, gravity
    add $t0, $t0, $t1
    
    # Limitar velocidad de caída
    li $t2, 5
    ble $t0, $t2, velOk
    li $t0, 5
    
    velOk:
    sw $t0, playerVelY
    
    # Actualizar posición Y
    lw $t1, playerY
    add $t1, $t1, $t0
    
    # Limitar a pantalla
    blt $t1, 0, clampTop
    bgt $t1, 61, clampBottom
    sw $t1, playerY
    jr $ra
    
    clampTop:
        li $t1, 0
        sw $t1, playerY
        sw $zero, playerVelY
        jr $ra
    
    clampBottom:
        li $t1, 61
        sw $t1, playerY
        sw $zero, playerVelY
        li $t2, 1
        sw $t2, onGround
        sw $zero, isJumping
        jr $ra

########################################################################
# checkPlatformCollision - Detecta colisión con plataformas
########################################################################
checkPlatformCollision:
    lw $t0, playerX
    lw $t1, playerY
    lw $t9, playerVelY
    
    # Solo verificar si está cayendo
    ble $t9, $zero, checkPlatDone
    
    la $t2, platforms
    lw $t3, numPlatforms
    
    checkPlatLoop:
        beq $t3, $zero, checkPlatDone
        
        lw $t4, 0($t2)     # y de plataforma
        lw $t5, 4($t2)     # x inicio
        lw $t6, 8($t2)     # x fin
        
        # Verificar si jugador está en rango X (con margen)
        addi $t7, $t0, 2   # centro del jugador
        blt $t7, $t5, nextPlat
        bgt $t7, $t6, nextPlat
        
        # Verificar si está cerca de la plataforma
        addi $t7, $t1, 3   # pie del jugador
        sub $t8, $t7, $t4
        bltz $t8, nextPlat
        bgt $t8, 3, nextPlat
        
        # Colisión detectada - colocar sobre plataforma
        addi $t4, $t4, -3
        sw $t4, playerY
        sw $zero, playerVelY
        sw $zero, isJumping
        li $t8, 1
        sw $t8, onGround
        j checkPlatDone
        
    nextPlat:
        addi $t2, $t2, 12
        addi $t3, $t3, -1
        j checkPlatLoop
    
    checkPlatDone:
        jr $ra

########################################################################
# checkBarrelCollision - Detecta colisión con barriles
########################################################################
checkBarrelCollision:
    lw $t0, playerX
    lw $t1, playerY
    
    li $t2, 0          # índice de barril
    
    checkBarrelColLoop:
        bge $t2, 3, checkBarrelColDone
        
        # Verificar si barril está activo
        la $t3, barrelActive
        sll $t4, $t2, 2
        add $t3, $t3, $t4
        lw $t5, 0($t3)
        beq $t5, $zero, nextBarrelCol
        
        # Obtener posición de barril
        la $t3, barrelX
        add $t3, $t3, $t4
        lw $t6, 0($t3)
        
        la $t3, barrelY
        add $t3, $t3, $t4
        lw $t7, 0($t3)
        
        # Verificar colisión (AABB simple con overlap)
        sub $t8, $t0, $t6
        abs $t8, $t8
        bgt $t8, 4, nextBarrelCol
        
        sub $t8, $t1, $t7
        abs $t8, $t8
        bgt $t8, 4, nextBarrelCol
        
        # Colisión detectada - game over
        li $t9, 1
        sw $t9, gameOver
        j checkBarrelColDone
        
    nextBarrelCol:
        addi $t2, $t2, 1
        j checkBarrelColLoop
    
    checkBarrelColDone:
        jr $ra

########################################################################
# checkWinCondition - Verifica si el jugador llegó a la meta
########################################################################
checkWinCondition:
    lw $t0, playerX
    lw $t1, playerY
    
    # Verificar si está en plataforma superior
    bgt $t1, 8, winCheckDone
    
    # Verificar si está en rango X de la meta
    blt $t0, 18, winCheckDone
    bgt $t0, 44, winCheckDone
    
    # Victoria!
    li $t2, 1
    sw $t2, winCondition
    
    # Incrementar puntaje bonus
    lw $t3, score
    addi $t3, $t3, 500
    sw $t3, score
    
    winCheckDone:
        jr $ra

########################################################################
# drawPixel - Dibuja un píxel en la pantalla
# $a0 = x, $a1 = y, $a3 = color
########################################################################
drawPixel:
    # Verificar límites
    blt $a0, $zero, pixelDone
    blt $a1, $zero, pixelDone
    lw $t9, displayWidth
    bge $a0, $t9, pixelDone
    lw $t9, displayHeight
    bge $a1, $t9, pixelDone
    
    # Calcular offset en memoria: (y * ancho + x) * 4
    lw $t0, displayWidth
    mul $t1, $a1, $t0
    add $t1, $t1, $a0
    sll $t1, $t1, 2
    
    # Añadir dirección base
    lw $t0, displayAddress
    add $t1, $t1, $t0
    
    # Escribir color
    sw $a3, 0($t1)
    
    pixelDone:
        jr $ra

########################################################################
# abs - Valor absoluto
# $t8 = abs($t8)
########################################################################
abs:
    bgez $t8, absPositive
    sub $t8, $zero, $t8
    absPositive:
        jr $ra