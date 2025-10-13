.data
base:   .word 0x10008000       # Dirección base del bitmap display
color:  .word 0x00FF0000       # Color del pixel (rojo)
black:  .word 0x00000000       # Color negro (para borrar)

.text
main:
    # Inicializar dirección base del display
    la   $t0, base
    lw   $t0, 0($t0)           # $t0 = dirección base

    # Posición inicial del pixel (fila 0, columna 0)
    li   $s0, 0                # x
    li   $s1, 0                # y

    jal  draw_pixel            # dibujar pixel inicial

main_loop:
    jal  get_key               # espera una tecla
    beq  $v0, $zero, main_loop # si no hay tecla, seguir esperando

    # borrar pixel en la posición anterior
    jal  erase_pixel

    # mover según la tecla
    li   $t1, 0x1B             # tecla ESC -> salir
    beq  $v0, $t1, exit

    li   $t1, 0x77             # 'w' arriba
    beq  $v0, $t1, move_up

    li   $t1, 0x73             # 's' abajo
    beq  $v0, $t1, move_down

    li   $t1, 0x61             # 'a' izquierda
    beq  $v0, $t1, move_left

    li   $t1, 0x64             # 'd' derecha
    beq  $v0, $t1, move_right

    j    main_loop

# --- movimientos ---
move_up:
    addi $s1, $s1, -1
    j    moved

move_down:
    addi $s1, $s1, 1
    j    moved

move_left:
    addi $s0, $s0, -1
    j    moved

move_right:
    addi $s0, $s0, 1
    j    moved

moved:
    jal  draw_pixel
    j    main_loop

# --- Rutina: dibujar pixel en (s0,s1) ---
draw_pixel:
    # offset = (y * 128 + x) * 4
   li $t2, 128   # ancho en memoria real
# para q pinte y sea como un snake => li $t2, 16     # ancho en bloques visibles en pixels
    mul  $t3, $s1, $t2
    add  $t3, $t3, $s0
    sll  $t3, $t3, 2

    lw   $t4, color
    add  $t5, $t0, $t3
    sw   $t4, 0($t5)
    jr   $ra

# --- Rutina: borrar pixel ---
erase_pixel:
    li   $t2, 128
    mul  $t3, $s1, $t2
    add  $t3, $t3, $s0
    sll  $t3, $t3, 2

    lw   $t4, black
    add  $t5, $t0, $t3
    sw   $t4, 0($t5)
    jr   $ra

# --- Rutina: leer tecla desde MMIO ---
get_key:
    li   $t6, 0xffff0000       # dirección del teclado (status)
    lw   $t7, 0($t6)
    beq  $t7, $zero, no_key
    lw   $v0, 4($t6)           # leer tecla
    jr   $ra

no_key:
    li   $v0, 0
    jr   $ra

exit:
    li   $v0, 10
    syscall
