.data
array: .space 40             # Array de 10 elementos (10 * 4 bytes = 40 bytes)
length: .word 10             # Tamanho do array

input_prompt: .asciiz "Digite o valor %d: "
output_prompt: .asciiz "Valores ordenados: "

.text
.globl main
main:
    # Lê os valores do teclado e armazena no array
    la $a0, input_prompt      # Carrega o endereço da mensagem de prompt
    lw $a1, length            # Carrega o tamanho do array
    jal read_array            # Chama a função read_array

    # Ordena o array
    la $a0, array             # Carrega o endereço do array
    lw $a1, length            # Carrega o tamanho do array
    jal bubble_sort           # Chama a função bubble_sort

    # Imprime os valores ordenados
    la $a0, output_prompt     # Carrega o endereço da mensagem de output
    li $v0, 4                 # Carrega o código do syscall para imprimir string
    syscall

    la $a0, array             # Carrega o endereço do array
    lw $a1, length            # Carrega o tamanho do array
    jal print_array           # Chama a função print_array

    # Termina o programa
    li $v0, 10                # Carrega o código do syscall para terminar o programa
    syscall

# Função para ler os valores do teclado e armazenar no array
read_array:
    addi $sp, $sp, -4         # Reserva espaço na pilha para 1 variável
    sw $ra, 0($sp)            # Salva o endereço de retorno na pilha

    move $s0, $a0             # Copia o endereço do array para $s0
    move $s1, $a1             # Copia o tamanho do array para $s1

    addi $t0, $zero, 0        # Inicializa $t0 com 0 (índice de loop)

read_loop:
    slt $t2, $t0, $s1         # Verifica se o índice é menor que o tamanho do array
    beqz $t2, end_read

    move $a0, $t0             # Copia o índice atual para $a0

    li $v0, 1                 # Carrega o código do syscall para imprimir inteiro
    syscall

    li $v0, 5                 # Carrega o código do syscall para ler inteiro
    syscall

    sw $v0, 0($s0)            # Armazena o valor lido no array

    addi $t0, $t0, 1          # Incrementa o índice de loop
    addi $s0, $s0, 4          # Atualiza o endereço do array para o próximo elemento

    j read_loop

end_read:
    lw $ra, 0($sp)            # Restaura o endereço de retorno
    addi $sp, $sp, 4          # Libera o espaço da pilha

    jr $ra                    # Retorna para a função chamadora

# Função para ordenar o array usando o algoritmo Bubble Sort
bubble_sort:
    addi $sp, $sp, -4         # Reserva espaço na pilha para 1 variável
    sw $ra, 0($sp)            # Salva o endereço de retorno na pilha

    move $s0, $a0             # Copia o endereço do array para $s0
    move $s1, $a1             # Copia o tamanho do array para $s1

    addi $t0, $zero, 0        # Inicializa $t0 com 0 (índice de loop externo)
    addi $t1, $zero, 1        # Inicializa $t1 com 1 (flag de troca)

outer_loop:
    slt $t2, $t0, $s1         # Verifica se o índice externo é menor que o tamanho do array
    beqz $t2, end_sort

    addi $t1, $zero, 0        # Reinicia o flag de troca para 0

    addi $t3, $zero, 0        # Inicializa $t3 com 0 (índice de loop interno)

inner_loop:
    slt $t4, $t3, $s1         # Verifica se o índice interno é menor que o tamanho do array
    beqz $t4, next_outer

    add $t5, $s0, $t3         # Calcula o endereço do elemento atual
    addi $t6, $t3, 1          # Calcula o próximo índice

    lw $t7, 0($t5)            # Carrega o valor atual
    lw $t8, 0($t6)            # Carrega o próximo valor

    ble $t7, $t8, no_swap     # Verifica se é necessário fazer a troca
    sw $t8, 0($t5)            # Salva o próximo valor no lugar do valor atual
    sw $t7, 0($t6)            # Salva o valor atual no lugar do próximo valor

    addi $t1, $t1, 1          # Seta o flag de troca para 1

no_swap:
    addi $t3, $t3, 1          # Incrementa o índice interno
    j inner_loop

next_outer:
    beqz $t1, end_sort        # Verifica se houve alguma troca no loop externo
    addi $t0, $t0, 1          # Incrementa o índice externo
    j outer_loop

end_sort:
    lw $ra, 0($sp)            # Restaura o endereço de retorno
    addi $sp, $sp, 4          # Libera o espaço da pilha

    jr $ra                    # Retorna para a função chamadora

# Função para imprimir os valores do array
print_array:
    addi $sp, $sp, -4         # Reserva espaço na pilha para 1 variável
    sw $ra, 0($sp)            # Salva o endereço de retorno na pilha

    move $s0, $a0             # Copia o endereço do array para $s0
    move $s1, $a1             # Copia o tamanho do array para $s1

    addi $t0, $zero, 0        # Inicializa $t0 com 0 (índice de loop)

print_loop:
    slt $t2, $t0, $s1         # Verifica se o índice é menor que o tamanho do array
    beqz $t2, end_print

    lw $a0, 0($s0)            # Carrega o valor atual para $a0
    li $v0, 1                 # Carrega o código do syscall para imprimir inteiro
    syscall

    li $v0, 4                 # Carrega o código do syscall para imprimir string
    la $a0, " "               # Carrega o endereço da string de espaço
    syscall

    addi $t0, $t0, 1          # Incrementa o índice de loop
    addi $s0, $s0, 4          # Atualiza o endereço do array para o próximo elemento

    j print_loop

end_print:
    li $v0, 4                 # Carrega o código do syscall para imprimir uma nova linha
    la $a0, "\n"              # Carrega o endereço da string de nova linha
    syscall

    lw $ra, 0($sp)            # Restaura o endereço de retorno
    addi $sp, $sp, 4          # Libera o espaço da pilha

    jr $ra                    # Retorna para a função chamadora
