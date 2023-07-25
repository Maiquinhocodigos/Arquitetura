.data
array:  .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   # Array de 10 inteiros inicializado com zeros
mensagem: .asciiz "Informe o elemento "
result: .asciiz "Elementos do Array Ordenados:"

.text
.globl main

main:
    # Preenche "array" com os elementos informados pelo usuário
    li $t0, 0                   
    li $t1, 0
input_loop:
    beq $t0, 40, sort_array     # Verificar se todos os elementos foram informados

    li $v0, 4                   
    la $a0, mensagem              
    syscall                     

    add $a0, $t1, $zero         # inicia i com 0
    li $v0, 1                
    syscall                     # Aqui é pra mostrar o valor de i junto da mensagem "informe o elemento tal"

    li $v0, 11   				
	li $a0, 10  				# Serve pra quebrar uma linha
	syscall

    li $v0, 5                   
    syscall                   
    sw $v0, array($t0)          # Armazenar o elemento no array
    addi $t1, $t1,1
    addi $t0, $t0, 4            # Incrementar o contador i em 4 (tamanho de um inteiro)
    j input_loop                # Voltar para o início do loop de entrada

sort_array:
    la $a0, array               # Carregar o endereço do array
    jal sort                    # Chamar a função sort para ordenar o array

    # Imprimir o array ordenado
    li $v0, 4                   
    la $a0, result              
    syscall                     # Imprimir o resultado

    li $t0, 0                   # Re-inicializa contador i com 0

mostra_elementos:
    li $v0, 11	
    li $a0, 32               	# Vai dar espaço entre cadas valor fornecido
    syscall                     
    
    li $v0, 1                  
    lw $a0, array($t0)         
    syscall                     

    addi $t0, $t0, 4            # Incrementar o endereço do array em 4 (tamanho de um inteiro)
    bne $t0, 40, mostra_elementos     # Verificar se ainda há elementos a serem impressos

    li $v0, 10                  
    syscall                     

sort:
    move $s0, $a0               		# Move o endereço do array para o registrador $s0
    li $t0, 10                  		# Carrega o valor 10 em $t0 (N)
    addi $t4, $a0, 36  				

	# evita perder os valores em $t? usados antes de chamar a função
    addi $sp, $sp, -20           		# Aloca espaço na pilha para os registrador $t3
	sw $t0, 0($sp)              		
	sw $t1, 4($sp)              		
	sw $t2, 8($sp)              		
    sw $t3, 12($sp)              		
    sw $t4, 16($sp)              		
	outer_loop:
    	sub $t0, $t0, 1         		# Decrementa o contador N
    	move $t3, $s0        			# Reseta $t3 para o endereço inicial do array

	inner_loop:
    	lw $t1, 0($t3)              # Carregar o valor do elemento atual do array para $t1
    	lw $t2, 4($t3)              # Carregar o valor do próximo elemento do array para $t2

    	blt $t1, $t2, skip_swap     # Verificar se o elemento atual é maior ou igual ao próximo elemento

    	sw $t1, 4($t3)              # Armazenar o valor do elemento atual no próximo elemento
    	sw $t2, 0($t3)              # Armazenar o valor do próximo elemento no elemento atual

	skip_swap:
    	addi $t3, $t3, 4            	# Avança para o próximo elemento do array
		
    	bne $t3, $t4, inner_loop    	# Verificar se ainda há elementos a serem percorridos no array
    	bgtz $t0, outer_loop        	# Verificar se ainda há iterações externas a serem realizadas

    	lw $t0, 0($sp)              	# Restaurar o valor do registrador $t0 da pilha
    	lw $t1, 4($sp)              	# Restaurar o valor do registrador $t1 da pilha
    	lw $t2, 8($sp)              	# Restaurar o valor do registrador $t2 da pilha
    	lw $t3, 12($sp)              	# Restaurar o valor do registrador $t3 da pilha
    	lw $t4, 16($sp)              	# Restaurar o valor do registrador $t4 da pilha
    	addi $sp, $sp, 20            	# Liberar o espaço na pilha

    	jr $ra                      	# Retornar para a função chamadora