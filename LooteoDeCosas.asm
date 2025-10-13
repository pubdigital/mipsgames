.data
# --- Direcciones y colores ---
base:     .word 0x10008000       # Dirección base del Bitmap Display
color:    .word 0x00FF0000       # Rojo (jugador)
black:    .word 0x00000000       # Negro (fondo)
pillcol:  .word 0x0000FF00       # Verde (pastillitas)

# --- Posiciones de las pastillas (x,y) ---
# se borran poniéndolas en (-1,-1)
pills:    .word 5,5
          .word 10,7
          .word 7,12
          .word 14,3

.text
main:
    # Inicializar dirección base del display
    la   $t0, base
    lw   $t0, 0($t0)           # $t0 = dirección base

    # Posición inicial del jugador (x=0,y=0)
    li   $s0, 0
    li   $s1, 0

    # Dibujar pastillas
    jal  draw_pills

    # Dibujar jugador inicial
    jal  draw_pixel

main_loop:
    jal  get_key
    beq  $v0, $zero, main_loop   # esperar tecla

    # borrar pixel en posición anterior
    jal  erase_pixel

    # tecla ESC -> salir
    li   $t1, 0x1B
    beq  $v0, $t1, exit

    # 'w' arriba
    li   $t1, 0x77
    beq  $v0, $t1, move_up

    # 's' abajo
    li   $t1, 0x73
    beq  $v0, $t1, move_down

    # 'a' izquierda
    li   $t1, 0x61
    beq  $v0, $t1, move_left

    # 'd' derecha
    li   $t1, 0x64
    beq  $v0, $t1, move_right

    j    main_loop

# --- movimientos ---
move_up:
    addi $s1, $s1, -1
    j    moved
    nop

move_down:
    addi $s1, $s1, 1
    j    moved
    nop

move_left:
    addi $s0, $s0, -1
    j    moved
    nop

move_right:
    addi $s0, $s0, 1
    j    moved
    nop

moved:
    jal  check_pills     # ver si comió pastilla
    jal  draw_pixel
    j    main_loop

# --- Rutina: dibujar píxel jugador ---
draw_pixel:
    li   $t2, 128        # ancho en píxeles
    mul  $t3, $s1, $t2
    add  $t3, $t3, $s0
    sll  $t3, $t3, 2

    lw   $t4, color
    add  $t5, $t0, $t3
    sw   $t4, 0($t5)
    jr   $ra

# --- Rutina: borrar píxel jugador ---
erase_pixel:
    li   $t2, 128
    mul  $t3, $s1, $t2
    add  $t3, $t3, $s0
    sll  $t3, $t3, 2

    lw   $t4, black
    add  $t5, $t0, $t3
    sw   $t4, 0($t5)
    jr   $ra

# --- Rutina: dibujar todas las pastillas ---
draw_pills:
    la   $t6, pills
    li   $t7, 4          # cantidad de pastillas
draw_pills_loop:
    beqz $t7, draw_pills_end

    lw   $t8, 0($t6)     # x
    lw   $t9, 4($t6)     # y

    bltz $t8, skip_pill  # si ya fue comida (-1,-1), saltar

    # offset = (y*128 + x)*4
    li   $t2, 128
    mul  $t3, $t9, $t2
    add  $t3, $t3, $t8
    sll  $t3, $t3, 2

    lw   $t4, pillcol
    add  $t5, $t0, $t3
    sw   $t4, 0($t5)

skip_pill:
    addi $t6, $t6, 8     # siguiente pastilla
    addi $t7, $t7, -1
    j    draw_pills_loop

draw_pills_end:
    jr   $ra

# --- Rutina: chequear si jugador comió pastilla ---
check_pills:
    la   $t6, pills
    li   $t7, 4
check_loop:
    beqz $t7, check_end

    lw   $t8, 0($t6)   # x
    lw   $t9, 4($t6)   # y

    bltz $t8, skip_check  # ya comida ? saltar

    beq  $s0, $t8, same_x
    j    skip_check
same_x:
    beq  $s1, $t9, eat_pill
    j    skip_check

eat_pill:
    # borrar de pantalla
    li   $t2, 128
    mul  $t3, $t9, $t2
    add  $t3, $t3, $t8
    sll  $t3, $t3, 2

    lw   $t4, black
    add  $t5, $t0, $t3
    sw   $t4, 0($t5)

    # marcar como comida (-1,-1)
    li   $t4, -1
    sw   $t4, 0($t6)
    sw   $t4, 4($t6)

skip_check:
    addi $t6, $t6, 8
    addi $t7, $t7, -1
    j    check_loop

check_end:
    jr   $ra

# --- Leer teclado (MMIO) ---
get_key:
    li   $t6, 0xffff0000
    lw   $t7, 0($t6)
    beq  $t7, $zero, no_key
    lw   $v0, 4($t6)
    jr   $ra
no_key:
    li   $v0, 0
    jr   $ra

# --- Salida ---
exit:
    li   $v0, 10
    syscall
