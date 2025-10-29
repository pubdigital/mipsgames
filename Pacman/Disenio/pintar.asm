.data
	BaseAddress: .word 0x10040000
.text
.macro draw_P 
	lw $t0, BaseAddress
	
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
