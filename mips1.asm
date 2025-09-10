.data
bitmap_base: .word 0x10010000
color_azul: .word 0xFF0000FF
color_negro: .word 0xFF000000

.text
.globl main

main:
    li $s0, 50      # x jugador
    li $s1, 50      # y jugador

loop:
    # Leer teclado
    li $t1, 0xFFFF0000
    lw $t2, 0($t1)
    beq $t2, $zero, loop

    li $t3, 0xFFFF0004
    lw $t4, 0($t3)

    # Guardar posición actual
    move $t9, $s0
    move $t8, $s1

    # Movimiento
    li $t5, 119  # 'w'
    beq $t4, $t5, move_up
    li $t5, 115  # 's'
    beq $t4, $t5, move_down
    li $t5, 97   # 'a'
    beq $t4, $t5, move_left
    li $t5, 100  # 'd'
    beq $t4, $t5, move_right

    j loop

move_up:
    # Verificar límite superior
    li $t0, 16
    ble $s1, $t0, loop  # si ya está en 0, no mover
    subi $s1, $s1, 16
    j update

move_down:
    # Verificar límite inferior
    li $t0, 240
    bge $s1, $t0, loop  # si ya está en 240 o más, no mover
    addi $s1, $s1, 16
    j update

move_left:
    subi $s0, $s0, 16
    j update

move_right:
    addi $s0, $s0, 16
    j update

update:
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
