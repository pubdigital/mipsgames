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
    # Colors
    red:       .word 0x00FF0000
    blue:      .word 0x000000FF
    brown:     .word 0x00654321
    black:     .word 0x00000000
    pink:      .word 0x00FF69B4
    
    # Player position (x, y)
    playerX:   .word 4
    playerY:   .word 53
    playerVelY: .word 0       # Vertical velocity
    onGround:  .word 1        # 1 if on platform, 0 if in air
    
    # Barrel positions
    barrelX:   .word 4
    barrelY:   .word 8
    barrelVelY: .word 0       # Barrel vertical velocity
    barrelOnGround: .word 1
    
    # Platform data (x1, x2, y) - better layout for jumping
    plat0:     .word 0, 20, 8    # Top left
    plat1:     .word 30, 63, 18   # Top right
    plat2:     .word 0, 33, 32    # Mid left
    plat3:     .word 40, 63, 42   # Mid right
    plat4:     .word 0, 63, 56    # Bottom (full width)
    
    # Game state
    gameOver:  .word 0

.text
.globl main

main:
    li $s0, 0x10008000    # Display address
    
game_loop:
    # Check game over
    lw $t1, gameOver
    bne $t1, $zero, end_game
    
    # Clear screen
    jal clear_screen
    
    # Draw platforms
    jal draw_platforms
    
    # Apply gravity to player
    jal apply_gravity
    
    # Check platform collisions for player
    jal check_platform_collision
    
    # Apply gravity to barrel
    jal apply_barrel_gravity
    
    # Check platform collisions for barrel
    jal check_barrel_platform
    
    # Move barrel horizontally
    jal update_barrel
    
    # Draw player
    jal draw_player
    
    # Draw barrel
    jal draw_barrel
    
    # Check input
    jal check_input
    
    # Check collision
    jal check_collision
    
    # Small delay
    li $v0, 32
    li $a0, 50
    syscall
    
    j game_loop

end_game:
    # Flash red
    li $t9, 0
flash_loop:
    beq $t9, 4, exit
    
    move $t0, $s0
    lw $t1, red
    li $t2, 0
flash_fill:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    blt $t2, 4096, flash_fill
    
    li $v0, 32
    li $a0, 200
    syscall
    
    addi $t9, $t9, 1
    j flash_loop

exit:
    li $v0, 10
    syscall

# Clear screen to black
clear_screen:
    move $t0, $s0
    lw $t1, black
    li $t2, 0
clear_loop:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    blt $t2, 4096, clear_loop
    jr $ra

# Apply gravity to player
apply_gravity:
    lw $t0, playerY
    lw $t1, playerVelY
    lw $t2, onGround
    
    # If on ground, no gravity
    beq $t2, 1, grav_done
    
    # Apply velocity
    add $t0, $t0, $t1
    
    # Increase velocity (gravity)
    addi $t1, $t1, 1
    
    # Cap velocity at 4
    bgt $t1, 4, cap_vel
    j store_grav
cap_vel:
    li $t1, 4
    
store_grav:
    # Keep player on screen
    bgt $t0, 61, floor_hit
    sw $t0, playerY
    sw $t1, playerVelY
    jr $ra
    
floor_hit:
    li $t0, 61
    sw $t0, playerY
    jr $ra

grav_done:
    jr $ra

# Apply gravity to barrel
apply_barrel_gravity:
    lw $t0, barrelY
    lw $t1, barrelVelY
    lw $t2, barrelOnGround
    
    # If on ground, no gravity
    beq $t2, 1, barrel_grav_done
    
    # Apply velocity
    add $t0, $t0, $t1
    
    # Increase velocity (gravity)
    addi $t1, $t1, 1
    
    # Cap velocity at 4
    bgt $t1, 4, cap_barrel_vel
    j store_barrel_grav
cap_barrel_vel:
    li $t1, 4
    
store_barrel_grav:
    # Reset if off screen
    bgt $t0, 61, reset_barrel_pos
    sw $t0, barrelY
    sw $t1, barrelVelY
    jr $ra

barrel_grav_done:
    jr $ra

# Check if player is on a platform
check_platform_collision:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, playerX
    lw $t1, playerY
    
    # Set not on ground by default
    li $t9, 0
    sw $t9, onGround
    
    # Check bottom of player (y + 3)
    addi $t1, $t1, 3
    
    # Check all platforms
    la $a0, plat0
    jal check_single_platform
    beq $v0, 1, player_plat_done
    
    la $a0, plat1
    jal check_single_platform
    beq $v0, 1, player_plat_done
    
    la $a0, plat2
    jal check_single_platform
    beq $v0, 1, player_plat_done
    
    la $a0, plat3
    jal check_single_platform
    beq $v0, 1, player_plat_done
    
    la $a0, plat4
    jal check_single_platform

player_plat_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Check single platform for player
# a0 = platform address, uses playerX, playerY
# Returns v0 = 1 if on platform
check_single_platform:
    lw $t0, playerX
    lw $t1, playerY
    addi $t1, $t1, 3
    
    lw $t3, 0($a0)    # x1
    lw $t4, 4($a0)    # x2
    lw $t5, 8($a0)    # y
    
    # Check if y matches (within 2 pixels)
    sub $t6, $t1, $t5
    blt $t6, -1, plat_no_match
    bgt $t6, 2, plat_no_match
    
    # Check if x is in range
    blt $t0, $t3, plat_no_match
    bgt $t0, $t4, plat_no_match
    
    # On platform!
    li $t9, 1
    sw $t9, onGround
    sub $t1, $t5, 3
    sw $t1, playerY
    li $t9, 0
    sw $t9, playerVelY
    li $v0, 1
    jr $ra

plat_no_match:
    li $v0, 0
    jr $ra

# Check if barrel is on a platform
check_barrel_platform:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, barrelX
    lw $t1, barrelY
    
    # Set not on ground by default
    li $t9, 0
    sw $t9, barrelOnGround
    
    # Check bottom of barrel (y + 3)
    addi $t1, $t1, 3
    
    # Check all platforms
    la $a0, plat0
    jal check_barrel_single_platform
    beq $v0, 1, barrel_plat_done
    
    la $a0, plat1
    jal check_barrel_single_platform
    beq $v0, 1, barrel_plat_done
    
    la $a0, plat2
    jal check_barrel_single_platform
    beq $v0, 1, barrel_plat_done
    
    la $a0, plat3
    jal check_barrel_single_platform
    beq $v0, 1, barrel_plat_done
    
    la $a0, plat4
    jal check_barrel_single_platform

barrel_plat_done:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Check single platform for barrel
check_barrel_single_platform:
    lw $t0, barrelX
    lw $t1, barrelY
    addi $t1, $t1, 3
    
    lw $t3, 0($a0)    # x1
    lw $t4, 4($a0)    # x2
    lw $t5, 8($a0)    # y
    
    # Check if y matches
    sub $t6, $t1, $t5
    blt $t6, -1, barrel_plat_no_match
    bgt $t6, 2, barrel_plat_no_match
    
    # Check if x is in range
    blt $t0, $t3, barrel_plat_no_match
    bgt $t0, $t4, barrel_plat_no_match
    
    # On platform!
    li $t9, 1
    sw $t9, barrelOnGround
    sub $t1, $t5, 3
    sw $t1, barrelY
    li $t9, 0
    sw $t9, barrelVelY
    li $v0, 1
    jr $ra

barrel_plat_no_match:
    li $v0, 0
    jr $ra

# Draw platforms
draw_platforms:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Draw all platforms
    la $t0, plat0
    lw $a0, 0($t0)
    lw $a1, 8($t0)
    lw $a2, 4($t0)
    jal draw_platform
    
    la $t0, plat1
    lw $a0, 0($t0)
    lw $a1, 8($t0)
    lw $a2, 4($t0)
    jal draw_platform
    
    la $t0, plat2
    lw $a0, 0($t0)
    lw $a1, 8($t0)
    lw $a2, 4($t0)
    jal draw_platform
    
    la $t0, plat3
    lw $a0, 0($t0)
    lw $a1, 8($t0)
    lw $a2, 4($t0)
    jal draw_platform
    
    la $t0, plat4
    lw $a0, 0($t0)
    lw $a1, 8($t0)
    lw $a2, 4($t0)
    jal draw_platform
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Draw single platform line
draw_platform:
    lw $t1, brown
    move $t3, $a0
    
platform_loop:
    sll $t4, $a1, 6
    add $t4, $t4, $t3
    sll $t4, $t4, 2
    add $t5, $s0, $t4
    
    sw $t1, 0($t5)
    
    addi $t3, $t3, 1
    ble $t3, $a2, platform_loop
    
    jr $ra

# Draw player
draw_player:
    lw $t1, blue
    lw $t2, playerX
    lw $t3, playerY
    
    li $t8, 0
player_row:
    beq $t8, 3, player_done
    li $t9, 0
    
player_col:
    beq $t9, 3, player_next_row
    
    add $t4, $t3, $t8
    add $t5, $t2, $t9
    
    # Check bounds
    blt $t4, 0, player_skip_pixel
    bge $t4, 64, player_skip_pixel
    blt $t5, 0, player_skip_pixel
    bge $t5, 64, player_skip_pixel
    
    sll $t6, $t4, 6
    add $t6, $t6, $t5
    sll $t6, $t6, 2
    add $t7, $s0, $t6
    
    sw $t1, 0($t7)

player_skip_pixel:
    addi $t9, $t9, 1
    j player_col

player_next_row:
    addi $t8, $t8, 1
    j player_row

player_done:
    jr $ra

# Draw barrel
draw_barrel:
    lw $t1, red
    lw $t2, barrelX
    lw $t3, barrelY
    
    li $t8, 0
barrel_row:
    beq $t8, 3, barrel_done
    li $t9, 0
    
barrel_col:
    beq $t9, 3, barrel_next_row
    
    add $t4, $t3, $t8
    add $t5, $t2, $t9
    
    # Check bounds
    blt $t4, 0, barrel_skip_pixel
    bge $t4, 64, barrel_skip_pixel
    blt $t5, 0, barrel_skip_pixel
    bge $t5, 64, barrel_skip_pixel
    
    sll $t6, $t4, 6
    add $t6, $t6, $t5
    sll $t6, $t6, 2
    add $t7, $s0, $t6
    
    sw $t1, 0($t7)

barrel_skip_pixel:
    addi $t9, $t9, 1
    j barrel_col

barrel_next_row:
    addi $t8, $t8, 1
    j barrel_row

barrel_done:
    jr $ra

# Check keyboard input
check_input:
    lw $t0, 0xffff0000
    bne $t0, 1, no_input
    
    lw $t1, 0xffff0004
    lw $t2, playerX
    lw $t3, onGround
    
    beq $t1, 119, try_jump      # w
    beq $t1, 97, move_left      # a
    beq $t1, 100, move_right    # d
    j no_input

try_jump:
    # Can only jump if on ground
    beq $t3, 0, no_input
    li $t4, -6
    sw $t4, playerVelY
    li $t4, 0
    sw $t4, onGround
    j no_input

move_left:
    ble $t2, 0, no_input
    addi $t2, $t2, -2
    sw $t2, playerX
    j no_input

move_right:
    bge $t2, 61, no_input
    addi $t2, $t2, 2
    sw $t2, playerX

no_input:
    jr $ra

# Update barrel horizontal movement
update_barrel:
    lw $t0, barrelX
    lw $t1, barrelOnGround
    
    # Only move horizontally if on ground
    beq $t1, 0, barrel_no_move
    
    # Move right
    addi $t0, $t0, 1
    
    # Check if at edge of current platform
    # This allows barrel to fall off edges
    sw $t0, barrelX

barrel_no_move:
    jr $ra

reset_barrel_pos:
    # Reset barrel to start
    li $t0, 4
    li $t1, 8
    li $t2, 0
    li $t3, 1
    sw $t0, barrelX
    sw $t1, barrelY
    sw $t2, barrelVelY
    sw $t3, barrelOnGround
    jr $ra

# Check collision
check_collision:
    lw $t0, playerX
    lw $t1, playerY
    lw $t2, barrelX
    lw $t3, barrelY
    
    sub $t4, $t0, $t2
    blt $t4, 0, abs_x
    j check_y
abs_x:
    sub $t4, $zero, $t4

check_y:
    bgt $t4, 5, no_collision
    
    sub $t5, $t1, $t3
    blt $t5, 0, abs_y
    j check_hit
abs_y:
    sub $t5, $zero, $t5

check_hit:
    bgt $t5, 5, no_collision
    
    li $t6, 1
    sw $t6, gameOver

no_collision:
    jr $ra