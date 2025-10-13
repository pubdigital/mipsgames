# ui_pacman.asm

.data
# --- CONSTANTES UI --- 
UI_BASE_ADDR:   .word 0x10000000
UI_DISP_WIDTH:  .word 512
UI_DISP_HEIGHT: .word 480     # 512-32 para HUD
UI_TILE_SIZE:   .word 32
UI_HUD_HEIGHT:  .word 32      # Altura del área de UI

# --- COLORES UI ---
UI_COLOR_BLACK: .word 0x00000000
UI_COLOR_WHITE: .word 0x00FFFFFF
UI_COLOR_YELLOW:.word 0x00FFFF00
UI_COLOR_RED:   .word 0x00FF0000
UI_COLOR_GREEN: .word 0x0000FF00
UI_COLOR_BLUE:  .word 0x000000FF

# --- TEXTO UI ---
ui_text_score:  .asciiz "SCORE"
ui_text_lives:  .asciiz "LIVES"  
ui_text_level:  .asciiz "LEVEL"
ui_text_ready:  .asciiz "READY!"
ui_text_go:     .asciiz "GAME OVER"
ui_text_win:    .asciiz "YOU WIN!"
ui_text_pause:  .asciiz "PAUSED"

# --- VARIABLES UI (solo para display) ---
ui_score:       .word 0
ui_lives:       .word 3
ui_level:       .word 1
ui_game_state:  .word 0      # 0=playing, 1=paused, 2=game over, 3=win

.text
.globl ui_init, ui_draw, ui_update_score, ui_update_lives, ui_update_level, ui_set_game_state

# ---------------------------------------
# ui_init: Inicializa la UI
# ---------------------------------------
ui_init:
    # Inicializar variables de UI
    li $t0, 3
    sw $t0, ui_lives
    li $t0, 1
    sw $t0, ui_level
    sw $zero, ui_score
    sw $zero, ui_game_state
    
    # Dibujar HUD inicial
    jal ui_draw_hud
    jr $ra

# ---------------------------------------
# ui_draw: Dibuja toda la interfaz
# ---------------------------------------
ui_draw:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal ui_draw_hud
    jr $ra 
    jal ui_draw_game_status
    jr $ra 
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ---------------------------------------
# ui_draw_hud: Dibuja score, vidas y nivel
# ---------------------------------------
ui_draw_hud:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    # Fondo negro para HUD
    lw $a0, UI_BASE_ADDR
    li $a1, 0              # x inicio
    li $a2, 0              # y inicio  
    li $a3, 512            # ancho
    lw $t0, UI_HUD_HEIGHT  # alto
    lw $t1, UI_COLOR_BLACK
    jal ui_draw_rect
    
    # --- SCORE ---
    # Texto "SCORE"
    la $a0, ui_text_score
    li $a1, 10
    li $a2, 8
    lw $a3, UI_COLOR_WHITE
    jal ui_draw_text
    
    # Valor del score
    lw $a0, ui_score
    li $a1, 80
    li $a2, 8
    lw $a3, UI_COLOR_YELLOW
    jal ui_draw_number
    
    # --- LIVES ---
    # Texto "LIVES"
    la $a0, ui_text_lives
    li $a1, 200
    li $a2, 8
    lw $a3, UI_COLOR_WHITE
    jal ui_draw_text
    
    # Iconos de vidas (pacmans pequeños)
    lw $s0, ui_lives
    li $s1, 250           # x inicial
    li $s2, 8             # y
    
ui_draw_lives_loop:
    blez $s0, ui_draw_level
    move $a0, $s1
    move $a1, $s2
    lw $a2, UI_COLOR_YELLOW
    jal ui_draw_small_pacman
    
    addi $s1, $s1, 12     # espacio entre iconos
    addi $s0, $s0, -1
    j ui_draw_lives_loop
    
ui_draw_level:
    # --- LEVEL ---
    # Texto "LEVEL"  
    la $a0, ui_text_level
    li $a1, 350
    li $a2, 8
    lw $a3, UI_COLOR_WHITE
    jal ui_draw_text
    
    # Número de nivel
    lw $a0, ui_level
    li $a1, 420
    li $a2, 8
    lw $a3, UI_COLOR_GREEN
    jal ui_draw_number
    
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# ---------------------------------------
# ui_draw_game_status: Mensajes de estado
# ---------------------------------------
ui_draw_game_status:
    lw $t0, ui_game_state
    beqz $t0, ui_status_done    # Estado 0 = playing, no dibujar nada
    
    # Posición centrada en el área de juego
    li $a1, 200
    li $a2, 200
    
    li $t1, 1
    beq $t0, $t1, ui_draw_paused
    
    li $t1, 2
    beq $t0, $t1, ui_draw_game_over
    
    li $t1, 3
    beq $t0, $t1, ui_draw_win
    
    j ui_status_done

ui_draw_paused:
    la $a0, ui_text_pause
    lw $a3, UI_COLOR_WHITE
    jal ui_draw_text
    j ui_status_done

ui_draw_game_over:
    la $a0, ui_text_go
    lw $a3, UI_COLOR_RED
    jal ui_draw_text
    j ui_status_done

ui_draw_win:
    la $a0, ui_text_win
    lw $a3, UI_COLOR_GREEN
    jal ui_draw_text

ui_status_done:
    jr $ra
