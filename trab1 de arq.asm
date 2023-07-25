    .data
mensagem: .asciiz "Digite um número positivo (ou negativo para sair): "  # o programa vai rodar até você informar um numero negativo
soma: .asciiz "A soma dos números positivos é: "

    .text
    .globl main

main:
    # inicio
    li $s0, 0        
    li $v0, 4        
    la $a0, mensagem   
    syscall          

loop:
    # Lê o número informado pelo usuário
    li $v0, 5
    syscall         
    move $t0, $v0    # Move o número lido para $t0

    bltz $t0, exit   # Esse comandinho aqui faz vc saber se o numero q foi informado é menor q 0 (ai entra o paranaue do numero negativo pra acabar o programma)

    add $s0, $s0, $t0  # Soma o número ao total armazenado em $s0
    j loop           # Volta para o início do loop

exit:
    # Exibe o resultado da soma
    li $v0, 4        
    la $a0, soma   
    syscall          

    # Exibe a soma dos números positivos
    li $v0, 1       
    move $a0, $s0    # Move a soma para $a0
    syscall        

    # Encerra o programa
    li $v0, 10       
    syscall          
