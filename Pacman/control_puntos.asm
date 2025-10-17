.macro draw_Puntos#igual que la función draw_P, pero el objetivo es escribir en el mapa de puntos
	la $t0,Pontos
	#multiplica por 4
	add $t1,$s1,$s1
	add $t1,$t1,$t1
	
	#pasar al heap
	add $t0,$t1,$t0
	
	addi $t1,$zero,0
	addi $t2,$zero,0	
	#multiplica y
	beq $s2,$zero,imprimir
	loop_y:
		addi $t1,$t1,256
		addi $t2,$t2,1
		bne $t2,$s2,loop_y
	
	add $t0,$t0,$t1
	imprimir:
		sw $s0,($t0)	
.end_macro
.macro cargar_puntos #s4 con valor de color en (s1,s2)
	lw $t0, pontos
	#multiplica por 4
	add $t1,$s1,$s1
	add $t1,$t1,$t1
	
	#pasar al heap
	add $t0,$t1,$t0
	
	addi $t1,$zero,0
	addi $t2,$zero,0	
	#multiplica y
	beq $s2,$zero,exit
	loop_y:
		addi $t1,$t1,256
		addi $t2,$t2,1
		bne $t2,$s2,loop_y
	
	add $t0,$t0,$t1
	lw $s4,($t0)
	exit:
.end_macro
