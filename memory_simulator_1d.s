.macro SAVE_REGS
    pushl %eax
    pushl %ecx
    pushl %edx
.endm

.macro RESTORE_REGS
    popl %edx
    popl %ecx
    popl %eax
.endm

# Macro pentru citirea unei variabile
.macro READ_NUM target_addr
    SAVE_REGS
    pushl \target_addr
    pushl $formatStringCitire
    call scanf
    addl $8, %esp
    RESTORE_REGS
.endm

# Macro pentru scrierea pentru cazurile 1, 3, 4
.macro PRINT_FORMAT_0 format_id, start_val, end_val
    SAVE_REGS
    pushl \end_val
    pushl \start_val
    pushl \format_id
    pushl $formatString0
    call printf
    addl $16, %esp
    pushl $0
    call fflush
    addl $4, %esp
    RESTORE_REGS
.endm

# Macro pentru scrierea pentru cazul 2 (Get)
.macro PRINT_FORMAT_1 start_val, end_val
    SAVE_REGS
    pushl \end_val
    pushl \start_val
    pushl $formatString1
    call printf
    addl $12, %esp
    pushl $0
    call fflush
    addl $4, %esp
    RESTORE_REGS
.endm

.data
    s: .space 1025                              # Memoria (1024 + 1)
    numar: .space 4                             # Numar de operatii
    cod: .space 4                               # Codul operatiei
    n: .space 4                                 # Numar de fisiere existente
    flist: .space 255                           # Lista de fisiere
    aux: .space 4                               # Auxiliara pt defragmentation
    id: .space 4                                # Id fisier
    dim: .space 4                               # Dimensiune fisier
    startx: .space 4                            # Prima pozitie
    endx: .space 4                              # Ultima pozitie
    x: .space 4                                 # Numar actual citit
    index: .space 4                             # Indicele din memorie
    formatStringCitire: .asciz "%ld"            # Ce citim
    formatString0: .asciz "%d: (%d, %d)\n"      # Output pentru 1 3 4
    formatString1: .asciz "(%d, %d)\n"          # Output pentru 2

.text
# ==========================================
# FUNCTII PRINCIPALE (Add, Get, Delete, Defrag, Sort)
# ==========================================
opadd:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %edi
    pushl %esi

    movl 16(%ebp), %edi
    movl 8(%ebp), %eax
    addl $7, %eax
    shrl $3, %eax
    movl %eax, 8(%ebp)

    movl $0, %ecx
    movl $0, %ebx
    movl $0, %esi

find_free_loop:
    cmpl $1024, %ecx
    jge alloc_failed

    cmpb $0, (%edi, %ecx, 1)
    jne reset_streak

    cmpl $0, %ebx
    jne increment_streak
    movl %ecx, %esi

increment_streak:
    incl %ebx
    incl %ecx

    cmpl 8(%ebp), %ebx
    je alloc_success
    jmp find_free_loop

reset_streak:
    movl $0, %ebx
    incl %ecx
    jmp find_free_loop

alloc_failed:
    movl $0, %eax
    movl %eax, 20(%ebp)
    movl %eax, 24(%ebp)
    jmp opadd_end

alloc_success:
    movl %esi, 20(%ebp)
    movl %ecx, %edx
    decl %edx
    movl %edx, 24(%ebp)

    movl %esi, %ecx
    movl 12(%ebp), %edx
    movl 8(%ebp), %ebx

fill_memory_loop:
    cmpl $0, %ebx
    je opadd_end
    movb %dl, (%edi, %ecx, 1)
    incl %ecx
    decl %ebx
    jmp fill_memory_loop

opadd_end:
    popl %esi
    popl %edi
    popl %ebx
    popl %ebp
    ret

opget:
    pushl %ebp
    movl %esp, %ebp
    pushl %edi

    movl 8(%ebp), %eax
    movl 12(%ebp), %edi
    movl $0, %ecx

find_start_loop:
    cmpl $1024, %ecx
    jge not_found
    cmpb %al, (%edi, %ecx, 1)
    je start_found
    incl %ecx
    jmp find_start_loop

start_found:
    movl %ecx, 16(%ebp)

find_end_loop:
    incl %ecx
    cmpl $1024, %ecx
    jge end_found
    cmpb %al, (%edi, %ecx, 1)
    jne end_found
    jmp find_end_loop

end_found:
    decl %ecx
    movl %ecx, 20(%ebp)
    jmp opget_end

not_found:
    movl $0, 16(%ebp)
    movl $0, 20(%ebp)

opget_end:
    popl %edi
    popl %ebp
    ret

opdelete:
    pushl %ebp
    movl %esp, %ebp
    pushl %edi

    movl 8(%ebp), %eax
    movl 12(%ebp), %edi
    movl $0, %ecx

delete_fast_search:
    cmpl $1024, %ecx
    jge opdelete_end
    cmpb %al, (%edi, %ecx, 1)
    je delete_block
    incl %ecx
    jmp delete_fast_search

delete_block:
    cmpl $1024, %ecx
    jge opdelete_end
    cmpb %al, (%edi, %ecx, 1)
    jne opdelete_end
    movb $0, (%edi, %ecx, 1)
    incl %ecx
    jmp delete_block

opdelete_end:
    popl %edi
    popl %ebp
    ret

opdefragmentation:
    pushl %ebp
    movl %esp, %ebp
    pushl %edi
    pushl %esi

    movl 8(%ebp), %edi
    movl 12(%ebp), %edx

    movl $0, %eax
    movl $0, %ecx

defrag_read_loop:
    cmpl %edx, %ecx
    jge defrag_fill_zeroes

    movb (%edi, %ecx, 1), %bl
    cmpb $0, %bl
    je defrag_continue
    movb %bl, (%edi, %eax, 1)
    incl %eax

defrag_continue:
    incl %ecx
    jmp defrag_read_loop

defrag_fill_zeroes:
    cmpl %edx, %eax
    jge defrag_end
    movb $0, (%edi, %eax, 1)
    incl %eax
    jmp defrag_fill_zeroes

defrag_end:
    popl %esi
    popl %edi
    popl %ebp
    ret

opsortflist:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi

    subl $32, %esp
    movl $0, -4(%ebp)
    movl $0, -8(%ebp)
    movl $0, -12(%ebp)

    movl n, %ebx
    movl %ebx, -28(%ebp)
    movl 8(%ebp), %esi
    movl $1, %ebx

sort_search_loop:
    cmpl 12(%ebp), %ebx
    jg sort_search_fail
    movl $0, %eax
    movb -1(%esi, %ebx, 1), %al
    movl %eax, id
    movl %eax, -12(%ebp)
    movl %ebx, -16(%ebp)

    SAVE_REGS
    pushl $endx
    pushl $startx
    pushl $s
    pushl id
    call opget
    addl $16, %esp
    RESTORE_REGS

    movl -16(%ebp), %ebx
    movl startx, %eax
    movl %eax, -4(%ebp)

    movl $0, %eax
    movb (%esi, %ebx, 1), %al
    movl %eax, id

    cmpl $0, %eax
    je sort_jump_1

    movl %ebx, -16(%ebp)

    SAVE_REGS
    pushl $endx
    pushl $startx
    pushl $s
    pushl id
    call opget
    addl $16, %esp
    RESTORE_REGS

    movl -16(%ebp), %ebx
    movl endx, %eax
    movl %eax, -8(%ebp)
    movl -4(%ebp), %ecx
    cmpl %eax, %ecx
    jg sort_exit_search

sort_jump_1:
    incl %ebx
    jmp sort_search_loop

sort_exit_search:
    movl $0, -4(%ebp)
    movl $0, -8(%ebp)
    movl endx, %eax
    movl %eax, -20(%ebp)
    movl $0, endx
    movl $0, startx
    movb %dl, (%esi, %ebx, 1)
    movl id, %eax
    movl %eax, -12(%ebp)
    jmp sort_search_success

sort_search_fail:
    jmp sort_exit_total

sort_search_success:
    movl -12(%ebp), %edx
    movl 8(%ebp), %esi
    movl $1, %ebx

sort_insert_loop:
    cmpl 12(%ebp), %ebx
    jg sort_insert_exit
    movl $0, %eax
    movb -1(%esi, %ebx, 1), %al
    movl %eax, id
    movl %ebx, -16(%ebp)

    SAVE_REGS
    pushl $endx
    pushl $startx
    pushl $s
    pushl id
    call opget
    addl $16, %esp
    RESTORE_REGS

    movl -16(%ebp), %ebx
    movl $1, ok

    movl -20(%ebp), %eax
    cmpl startx, %eax
    jl loop_insert_exec
    jmp insert_continue

loop_insert_exec:
    movl $0, ok
    movl id, %eax
    movl %eax, -24(%ebp)
    movl -12(%ebp), %eax
    movb %al, -1(%esi, %ebx, 1)
    movl -24(%ebp), %eax
    movl %eax, -12(%ebp)

    cmpl -28(%ebp), %ebx
    je loop_insert_final
    jmp loop_insert_continue

loop_insert_final:
    movl id, %eax
    movb %al, (%esi, %ebx, 1)

loop_insert_continue:
insert_continue:
    incl %ebx
    jmp sort_insert_loop

sort_insert_exit:
    cmpl $1, ok
    jne sort_exit_total
    movl -24(%ebp), %eax
    movb %al, -2(%esi, %ebx, 1)

sort_exit_total:
    SAVE_REGS
    pushl n
    pushl $255
    pushl $flist
    call opdefragmentation
    addl $12, %esp
    RESTORE_REGS

    addl $32, %esp
    popl %edi
    popl %esi
    popl %ebx
    popl %ebp
    ret

# ==========================================
# MAIN ROUTINE
# ==========================================
.global main
main:
    pushl %ebp
    movl %esp, %ebp

    READ_NUM $x
    movl x, %ecx
    movl %ecx, numar

et_loop_operatii:
    movl numar, %ecx
    decl %ecx
    movl %ecx, numar
    cmpl $0, %ecx
    jl et_exit

    READ_NUM $x
    movl x, %eax
    movl %eax, cod

    cmpl $1, %eax
    je et_add
    cmpl $2, %eax
    je et_get
    cmpl $3, %eax
    je et_delete
    cmpl $4, %eax
    je et_defragmentation
    jmp et_loop_operatii

# --- 1: ADD ---
et_add:
    READ_NUM $x
    movl x, %eax
    addl %eax, n

et_loop_add:
    READ_NUM $x
    movl x, %edx
    movb %dl, id

    SAVE_REGS
    pushl $endx
    pushl $startx
    pushl $flist
    pushl id
    pushl $1
    call opadd
    addl $20, %esp
    RESTORE_REGS

    READ_NUM $x
    movl x, %edx
    movl %edx, dim

    SAVE_REGS
    pushl $endx
    pushl $startx
    pushl $s
    pushl id
    pushl dim
    call opadd
    addl $20, %esp
    RESTORE_REGS

    movl endx, %ebx
    cmpl $0, %ebx
    jne et_add_continue

    SAVE_REGS
    pushl $flist
    pushl id
    call opdelete
    addl $8, %esp
    RESTORE_REGS
    decl n

et_add_continue:
    PRINT_FORMAT_0 id, startx, endx

    movl n, %edx
    cmpl $1, %edx
    jle et_loop_add_check

    SAVE_REGS
    pushl n
    pushl $flist
    call opsortflist
    addl $8, %esp
    RESTORE_REGS

et_loop_add_check:
    decl %eax
    cmpl $0, %eax
    jne et_loop_add
    jmp et_loop_operatii

# --- 2: GET ---
et_get:
    READ_NUM $x
    movl x, %edx
    movl %edx, id

    SAVE_REGS
    pushl $endx
    pushl $startx
    pushl $s
    pushl id
    call opget
    addl $16, %esp
    RESTORE_REGS

    PRINT_FORMAT_1 start_val=startx, end_val=endx
    jmp et_loop_operatii

# --- 3: DELETE ---
et_delete:
    READ_NUM $x
    movl x, %edx
    movl %edx, id

    SAVE_REGS
    pushl $endx
    pushl $startx
    pushl $s
    pushl id
    call opget
    addl $16, %esp
    RESTORE_REGS

    movl endx, %edx
    cmpl $0, %edx
    je et_delete_skip
    decl n

    SAVE_REGS
    pushl $s
    pushl id
    call opdelete
    addl $8, %esp
    RESTORE_REGS

    SAVE_REGS
    pushl $flist
    pushl id
    call opdelete
    addl $8, %esp
    RESTORE_REGS

    SAVE_REGS
    pushl n
    pushl $255
    pushl $flist
    call opdefragmentation
    addl $12, %esp
    RESTORE_REGS

et_delete_skip:
    jmp et_loop_scriere

# --- 4: DEFRAGMENTATION ---
et_defragmentation:
    SAVE_REGS
    pushl $1024
    pushl $s
    call opdefragmentation
    addl $8, %esp
    RESTORE_REGS
    jmp et_loop_scriere

# --- PRINT GLOBAL ---
et_loop_scriere:
    movl $0, %eax
    lea flist, %esi

et_loop_scriere_memorie:
    cmpl n, %eax
    jge et_loop_operatii

    movl $0, %edx
    movb (%esi, %eax, 1), %dl
    movl %edx, id

    SAVE_REGS
    pushl $endx
    pushl $startx
    pushl $s
    pushl id
    call opget
    addl $16, %esp
    RESTORE_REGS

    PRINT_FORMAT_0 id, startx, endx

    incl %eax
    jmp et_loop_scriere_memorie

et_exit:
    popl %ebp
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80