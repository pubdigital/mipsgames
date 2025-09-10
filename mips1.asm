.data
bitmap_base: .word 0x10010000
color_azul: .word 0xFF0000FF
color_negro: .word 0xFF000000
gravedad: .word 2
salto_inicial: .word -20

.text
.globl main

main:
    li $s0, 50      # x jugador
    li $s1, 200     # y jugador
    li $s2, 0       # velY

loop:
    # Guardar posición anterior
    move $t9, $s0
    move $t8, $s1

    # Leer teclado
    li $t1, 0xFFFF0000
    lw $t2, 0($t1)
    bne $t2, $zero, leer_tecla

    j aplicar_fisica

leer_tecla:
    li $t3, 0xFFFF0004
    lw $t4, 0($t3)

    # Salto con W
    li $t5, 119  # 'w'
    beq $t4, $t5, iniciar_salto

    # Ignorar S
    li $t5, 115
    beq $t4, $t5, aplicar_fisica

    # Movimiento horizontal
    li $t5, 97
    beq $t4, $t5, move_left
    li $t5, 100
    beq $t4, $t5, move_right

    j aplicar_fisica

iniciar_salto:
    # Solo saltar si está en el suelo
    li $t0, 200
    bne $s1, $t0, aplicar_fisica

    la $t1, salto_inicial
    lw $s2, 0($t1)
    j aplicar_fisica

move_left:
    li $t0, 0
    ble $s0, $t0, aplicar_fisica
    subi $s0, $s0, 4
    j aplicar_fisica

move_right:
    li $t0, 240
    bge $s0, $t0, aplicar_fisica
    addi $s0, $s0, 4
    j aplicar_fisica

aplicar_fisica:
    # Aplicar gravedad
    la $t1, gravedad
    lw $t2, 0($t1)
    add $s2, $s2, $t2       # velY += gravedad
    add $s1, $s1, $s2       # y += velY

    # Límite inferior
    li $t0, 200
    bgt $s1, $t0, en_suelo
    j actualizar

en_suelo:
    li $s1, 200
    li $s2, 0
    j actualizar

actualizar:
    # Solo redibujar si cambió la posición
    bne $s0, $t9, redibujar
    bne $s1, $t8, redibujar
    j loop

redibujar:
    # Borrar jugador anterior
    move $a0, $t9
    move $a1, $t8
    la $t0, color_negro
    lw $a2, 0($t0)
    jal draw_square

    # Dibujar jugador nuevo
    move $a0, $s0
    move $a1, $s1
    la $t0, color_azul
    lw $a2, 0($t0)
    jal draw_square

    j loop

# Dibuja un cuadrado de 16x16 en (x=$a0, y=$a1) con color $a2
draw_square:
    la $t0, bitmap_base
    lw $t0, 0($t0)

    li $t4, 0
draw_row:
    li $t5, 0
draw_col:
    add $t6, $a0, $t5
    add $t7, $a1, $t4

    li $t1, 256
    mul $t2, $t7, $t1
    add $t2, $t2, $t6
    sll $t2, $t2, 2
    add $t3, $t0, $t2

    sw $a2, 0($t3)

    addi $t5, $t5, 1
    li $t8, 16
    blt $t5, $t8, draw_col

    addi $t4, $t4, 1
    blt $t4, $t8, draw_row

    jr $ra
