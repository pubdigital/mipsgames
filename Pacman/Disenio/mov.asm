.include "draw.asm"
.data
.text

.macro mov_Ghost #comando s0 color s1 x s2 y s3
	addi $t7,$s0,0 #Guarda el valor de s0 en t7 para uso futuro.
#Condición especial (TELETRANSPORTACIÓN)
	bne $s1,61,test2
	bne $s3,100,test2
		#teletransporte derecho
		lw $s0,black
		draw_Ghost()
		addi $s1,$zero,1
		addi $s2,$zero,40
		addi $s0,$s0,0
		draw_Ghost()
		j recall
	test2:
		bne $s1,1,Normal
		bne $s3,97,Normal
		lw $s0,black
		draw_Ghost()
		addi $s1,$zero,61
		addi $s2,$zero,40
		addi $s0,$s0,0
		draw_Ghost()
		j recall
	Normal:
	bne $s3,119,salida1
	#w = 77 hexa Ir al inicio
#borrar anterior
	lw $s0,black
	draw_Ghost()
	#imprimir el nuevo
	subi $s2,$s2,3
	addi $s0,$t7,0 #devuelve el valor original de s0
	draw_Ghost()
	j recall

	salida1:
	bne $s3,115,salida2
	#s = 73 hexadecimal Bajar
#borrar anterior
	addi $t7,$s0,0 #Guarda el valor de s0 en t7 para uso futuro
	lw $s0,black
	draw_Ghost()
	#imprimir el nuevo
	addi $s2,$s2,3
	addi $s0,$t7,0 #devuelve el valor original de s0
	draw_Ghost()
	j recall
	
	salida2:
	bne $s3,97,salida3
	#a=61 hex va a la izquierda
#borrar anterior
	addi $t7,$s0,0 #Guarda el valor de s0 en t7 para uso futuro
	lw $s0,black
	draw_Ghost()
	#imprimir el nuevo
	subi $s1,$s1,3
	addi $s0,$t7,0 #devuelve el valor original de s0
	draw_Ghost()
	j recall
	
	salida3:
	bne $s3,100,recall
	#d = 64 hexa Mover a la derecha #borrar anterior
	addi $t7,$s0,0 #Guarda el valor de s0 en t7 para uso futuro
	lw $s0,black
	draw_Ghost()
	#imprimir el nuevo
	addi $s1,$s1,3
	addi $s0,$t7,0 #devuelve valor original de s0
	draw_Ghost()
	
	recall:
.end_macro

.macro mov_Pac_Man #cor s0 color s1 x s2 y s3

	next_Block_punto()
	la $t0, pontos
	lw $t1,($t0)
	add $t1,$t1,$s4
	sw $t1,($t0)
	
	next_Block_fruta()
	beq $s4, 1, comer_fruta
	j seApago
	comer_fruta:
		sw $zero,60($s7)
	seApago:
#Condición especial (TELETRANSPORTACIÓN)
	bne $s1,61,test2
	bne $s3,100,test2
		#teletransporte derecho
		lw $s0,black
		draw_quadrado()
		addi $s1,$zero,1
		addi $s2,$zero,40
		draw_Pac_Man()
		j recall
	test2:
		bne $s1,1,Normal
		bne $s3,97,Normal
		lw $s0,black
		draw_quadrado()
		addi $s1,$zero,61
		addi $s2,$zero,40
		draw_Pac_Man()
		j recall	
	Normal:
	bne $s3,119,salida1
	#w = 77 hexa Ir al inicio
#eliminar anterior
	lw $s0,black
	draw_quadrado()
	#printa o novo
	subi $s2,$s2,3
	draw_Pac_Man()
	j recall

	salida1:
	bne $s3,115,salida2
	#s = 73 hexadecimal Bajar
#borrar anterior
	lw $s0,black
	draw_quadrado()
	#imprimir el nuevo
	addi $s2,$s2,3
	draw_Pac_Man()
	j recall
	
	salida2:
	bne $s3,97,salida3
	# a=61 hex va a la izquierda
#borrar anterior
	lw $s0,black
	draw_quadrado()
	#imprimir el nuevo
	subi $s1,$s1,3
	draw_Pac_Man()
	j recall
	
	salida3:
	bne $s3,100,recall
	#d = 64 hexa Mover a la derecha #borrar anterior
	lw $s0,black
	draw_quadrado()
	#imprimir el nuevo
	addi $s1,$s1,3
	draw_Pac_Man()
	
	recall:
.end_macro

