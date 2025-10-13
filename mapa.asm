# pacman_basic.asm
# Starter para MARS - Pacman en modo gráfico (Bitmap Display)
# Configuración en MARS:
# Unit Width=32, Unit Height=32, Display Width=512, Display Height=512
# Base Address = 0x10000000
        .data
map_rows:
        .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        .byte 1,0,0,0,0,0,0,3,0,0,0,0,0,0,0,1
        .byte 1,0,1,1,1,0,0,0,0,0,1,1,1,0,0,1
        .byte 1,0,1,0,1,0,4,0,0,4,1,0,1,0,0,1
        .byte 1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1
        .byte 1,0,1,1,1,1,1,1,1,1,1,1,1,0,0,1
        .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        .byte 1,0,0,0,2,0,0,0,0,0,0,0,0,0,0,1
        .byte 1,0,0,0,0,0,0,5,0,0,0,0,0,0,0,1
        .byte 1,0,1,1,1,0,0,0,0,0,1,1,1,0,0,1
        .byte 1,0,1,0,1,0,6,0,0,6,1,0,1,0,0,1
        .byte 1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1
        .byte 1,0,1,1,1,1,1,1,1,1,1,1,1,0,0,1
        .byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
map_len: .word 256

# Constantes como variables en data section para mayor confiabilidad
disp_width: .word 512
tile_size:  .word 32
grid_w:     .word 16
grid_h:     .word 16

        .text
        .globl main

# CONSTANTES
.eqv BASE_ADDR 0x10000000

# ---------------------------------------
# main
# ---------------------------------------
main:
    la $s0, map_rows    # mapa
    li $s1, BASE_ADDR   # framebuffer base
    lw $s2, disp_width  # ancho display (cargar desde memoria)
    jal draw_map
    
game_loop:
    li $v0, 12          # syscall read_char
    syscall
    move $t0, $v0       # $t0 = tecla
    beq $t0, $zero, game_loop
    jal move_pacman_by_key
    jal draw_map
    j game_loop

# ---------------------------------------
# draw_map: recorre el mapa y dibuja tiles
# ---------------------------------------
draw_map:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    la $s0, map_rows    # dirección base del mapa
    li $s3, 0           # fila = 0
    
draw_map_row:
    lw $t0, grid_h
    bge $s3, $t0, draw_map_done
    li $t1, 0           # col = 0
    
draw_map_col:
    lw $t0, grid_w
    bge $t1, $t0, next_row
    
    # Calcular índice: row * GRID_W + col
    lw $t0, grid_w
    mul $t2, $s3, $t0
    add $t2, $t2, $t1
    add $t3, $s0, $t2   # dirección del elemento en el mapa
    lb $a2, 0($t3)      # tile_code
    
    # Calcular coordenadas de pantalla
    lw $t0, tile_size
    mul $a0, $t1, $t0   # x = col * TILE_SIZE
    mul $a1, $s3, $t0   # y = row * TILE_SIZE
    
    # Llamar a draw_tile
    move $a3, $s1       # base address del framebuffer
    jal draw_tile
    
    addi $t1, $t1, 1    # siguiente columna
    j draw_map_col
    
next_row:
    addi $s3, $s3, 1    # siguiente fila
    j draw_map_row
    
draw_map_done:
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# ---------------------------------------
# draw_tile: pinta TILE_SIZE x TILE_SIZE
# Entrada: $a0=x, $a1=y, $a2=tile_code, $a3=base_fb
# ---------------------------------------
draw_tile:
    addi $sp, $sp, -28
    sw $ra, 24($sp)
    sw $t0, 20($sp)
    sw $t1, 16($sp)
    sw $t2, 12($sp)
    sw $t3, 8($sp)
    sw $t4, 4($sp)
    sw $t5, 0($sp)
    
    # DEBUG: Verificar parámetros
    # move $t9, $a2  # guardar tile_code temporalmente
    
    # Selección de color según tile_code ($a2)
    li $t1, 0x00000000  # negro por defecto (0)
    beq $a2, 0, dt_set_color
    
    li $t1, 0x000000FF  # azul oscuro (paredes - 1)
    beq $a2, 1, dt_set_color
    
    li $t1, 0x00FFFF00  # amarillo (pacman - 2)
    beq $a2, 2, dt_set_color
    
    li $t1, 0x00FFFFFF  # blanco (puntos - 3)
    beq $a2, 3, dt_set_color
    
    li $t1, 0x00FF00FF  # magenta (4)
    beq $a2, 4, dt_set_color
    
    li $t1, 0x0000FFFF  # cian (5)
    beq $a2, 5, dt_set_color
    
    li $t1, 0x00808080  # gris (6)
    # Si llega aquí, usa gris para cualquier otro valor
    
dt_set_color:
    li $t2, 0                    # fila dentro del tile = 0
    lw $t0, tile_size            # cargar TILE_SIZE desde memoria
    
dt_row_loop:
    bge $t2, $t0, dt_done        # si fila >= TILE_SIZE, terminar
    li $t3, 0                    # columna dentro del tile = 0
    
dt_col_loop:
    bge $t3, $t0, dt_next_row    # si columna >= TILE_SIZE, siguiente fila
    
    # Calcular posición en framebuffer
    add $t4, $a0, $t3            # x_pixel = x + col
    add $t5, $a1, $t2            # y_pixel = y + row
    
    # Calcular dirección: base + (y_pixel * DISP_WIDTH + x_pixel) * 4
    lw $t6, disp_width           # cargar DISP_WIDTH desde memoria
    mul $t7, $t5, $t6            # y_pixel * DISP_WIDTH
    add $t7, $t7, $t4            # + x_pixel
    sll $t7, $t7, 2              # * 4 (cada pixel = 4 bytes)
    add $t7, $t7, $a3            # + base address
    
    sw $t1, 0($t7)               # escribir color
    
    addi $t3, $t3, 1             # siguiente columna
    j dt_col_loop
    
dt_next_row:
    addi $t2, $t2, 1             # siguiente fila
    j dt_row_loop
    
dt_done:
    lw $ra, 24($sp)
    lw $t0, 20($sp)
    lw $t1, 16($sp)
    lw $t2, 12($sp)
    lw $t3, 8($sp)
    lw $t4, 4($sp)
    lw $t5, 0($sp)
    addi $sp, $sp, 28
    jr $ra

# ---------------------------------------
# move_pacman_by_key
# ---------------------------------------
move_pacman_by_key:
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    
    la $s0, map_rows
    li $s1, 0                    # i=0
    li $t6, 0                    # índice original = 0
    
find_pac:
    li $t0, 256
    beq $s1, $t0, mp_end
    add $t1, $s0, $s1
    lb $t4, 0($t1)
    li $t0, 2
    beq $t4, $t0, mp_found
    addi $s1, $s1, 1
    j find_pac

mp_found:
    move $t6, $s1                # guardar índice original
    
    # Calcular coordenadas (fila y columna)
    lw $t3, grid_w
    div $s1, $t3
    mflo $t8                     # row
    mfhi $t9                     # col
    
    # Verificar tecla presionada (usando $t0 del main loop)
    # W/w - arriba
    li $t1, 87
    beq $t0, $t1, do_up
    li $t1, 119
    beq $t0, $t1, do_up
    
    # A/a - izquierda
    li $t1, 65
    beq $t0, $t1, do_left
    li $t1, 97
    beq $t0, $t1, do_left
    
    # S/s - abajo
    li $t1, 83
    beq $t0, $t1, do_down
    li $t1, 115
    beq $t0, $t1, do_down
    
    # D/d - derecha
    li $t1, 68
    beq $t0, $t1, do_right
    li $t1, 100
    beq $t0, $t1, do_right
    
    j mp_end

do_up:
    addi $t8, $t8, -1
    j mp_apply

do_left:
    addi $t9, $t9, -1
    j mp_apply

do_down:
    addi $t8, $t8, 1
    j mp_apply

do_right:
    addi $t9, $t9, 1
    j mp_apply

mp_apply:
    # Verificar límites
    blt $t8, 0, mp_end
    blt $t9, 0, mp_end
    lw $t0, grid_h
    bge $t8, $t0, mp_end
    lw $t0, grid_w
    bge $t9, $t0, mp_end
    
    # Calcular nueva posición
    lw $t0, grid_w
    mul $t4, $t8, $t0
    add $t4, $t4, $t9
    
    # Actualizar mapa
    add $t1, $s0, $t6           # posición actual
    sb $zero, 0($t1)            # borrar pacman actual
    
    add $t1, $s0, $t4           # nueva posición
    li $t0, 2
    sb $t0, 0($t1)              # colocar pacman en nueva posición

mp_end:
    lw $ra, 8($sp)
    lw $s0, 4($sp)
    lw $s1, 0($sp)
    addi $sp, $sp, 12
    jr $ra