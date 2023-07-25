    .data
msg: .asciiz "Digite a posição (n) na sequência de Fibonacci: "
resultado: .asciiz "O valor na posição n é: "

    .text
    .globl main

main:
    li $v0, 4        
    la $a0, msg   
    syscall          

    # Lê o número informado pelo usuário
    li $v0, 5 
    syscall   
    move $t0, $v0

    beqz $t0, print_resultado  # Se n for 0, imprime o resultado 0
    li $t1, 1        # Carrega o valor 1 para $t1
    beq $t0, $t1, print_resultado  # Se n for 1, imprime o resultado 1

    # Inicializa os primeiros valores da sequência
    li $t2, 0        
    li $t3, 1        

    # Calcula a sequência de Fibonacci até a posição n
    addi $t0, $t0, -2   # Decrementa n por 2 para os dois primeiros valores
    loop:
        add $t4, $t2, $t3   
        move $t2, $t3       
        move $t3, $t4       
        addi $t0, $t0, -1   # Decrementa n
        bgez $t0, loop      # Se n for maior ou igual a zero, volta para o loop

print_resultado:
    li $v0, 4        
    la $a0, resultado
    syscall          

    # Exibe o valor na posição n
    li $v0, 1       
    move $a0, $t3   
    syscall         

    # Encerra o programa
    li $v0, 10       
    syscall          
