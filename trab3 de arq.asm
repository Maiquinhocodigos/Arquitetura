.data
msg1: .asciiz "Informe o primeiro número positivo: "
msg2: .asciiz "Informe o segundo número positivo: "
resultado: .asciiz "A multiplicação é: "

.text
.globl main

main:
    # Solicitar o primeiro número
    li $v0, 4
    la $a0, msg1
    syscall
    li $v0, 5
    syscall
    move $t0, $v0 # Armazena ele em $t0
    
    # Solicitar o segundo número
    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 5
    syscall
    move $t1, $v0 # Armazena ele em $t1
    
    # Inicio da função mult
    move $a0, $t0
    move $a1, $t1
    jal mult
    move $t2, $v0 # salva o "return" em t2
    
    #mostra o resultado
    li $v0, 4
    la $a0, resultado
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 10
    syscall

mult:
    move $t2, $zero
    li $t3, 1
    beqz $a1, end_mult #se y é diferente de zero continua, senão encerra a função
    
    loop:
        # Adicionar x a ans
        add $t2, $t2, $a0
        
        # Incrementar i
        addi $t3, $t3, 1
        
        # Comparar se i é menor ou igual a y
        ble $t3, $a1, loop
    
    end_mult:
        move $v0, $t2
        jr $ra
