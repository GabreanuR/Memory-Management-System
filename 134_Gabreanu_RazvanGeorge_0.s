.data
    s: .space 1025                              ;//Memoria
    numar: .space 4                             ;//Numar de operatii
    cod: .space 4                               ;//Codul operatiei
    n: .space 4                                 ;//Numar de fisiere existente
    flist: .space 255                           ;//Lista de fisiere
    aux: .space 4                               ;//Auxiliara pt defragmentation
    id: .space 4                                ;//Id fisier
    dim: .space 4                               ;//Dimensiune fisier
    startx: .space 4                            ;//Prima pozitie
    endx: .space 4                              ;//Ultima pozitie  
    x: .space 4                                 ;//Numar actual citit
    index: .space 4                             ;//Indicele din memorie
    formatStringCitire: .asciz "%ld"            ;//Ce citim
    formatString0: .asciz "%d: (%d, %d)\n"      ;//Output pentru 1 3 4
    formatString1: .asciz "(%d, %d)\n"          ;//Output pentru 2
    ok: .space 4                                ;//PENTRU CA AM CEDAT PSIHIC CU SORTAREA DE LISTA
    aux3: .space 4
.text
citire_rand:
    pushl %ebp
    mov %esp, %ebp

    pushl $x
    pushl $formatStringCitire
    call scanf
    popl %ebx
    popl %ebx

    popl %ebp
    ret
scriere134:
    pushl %ebp
    mov %esp, %ebp

    pushl endx
    pushl startx
    pushl id
    pushl $formatString0
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx

    popl %ebp
    ret
scriere2:
    pushl %ebp
    mov %esp, %ebp

    pushl endx
    pushl startx
    pushl $formatString1
    call printf
    popl %ebx
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx

    popl %ebp
    ret   
opadd:    
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx

    subl $4, %esp
    movl $0, -4(%ebp)                           ;//var loc

    mov 16(%ebp), %edi                          ;//Selectare memorie

    et_div_dim:
        movl $0, %edx
        movl 8(%ebp), %eax                      ;//eax = dimensiune
        movl $8, %ecx
        idiv %ecx                               ;//transformarea (impartire la 8) dimensiune
        movl %eax, 8(%ebp)

        movl $0, %ecx

        cmp $0, %edx                            ;//verificam daca exista rest
        jne et_conv
        movl %eax, 8(%ebp)
        movl %eax, %ebx
        jmp et_verif
    et_conv:
        movl $0, %edx
        mov 8(%ebp), %eax
        add $1, %eax                         
        movl %eax, 8(%ebp)                      ;//rotujirea in sus a dimensiunii
        movl %eax, %ebx
    et_verif:
        cmp $1024, %ecx
        jg et_exit_3

        movl $0, %edx
        movb (%edi, %ecx, 1), %dl               ;//parcurgerea memoriei

        movl %ecx, -4(%ebp)                     ;//salvam contorul

        cmp $0, %edx                            ;//verificare spatiu liber
        je et_verif2

        inc %ecx                                ;//incrementare memorie
        jmp et_verif
    et_verif2:
        cmp $1024, %ecx
        jg et_exit_3
        cmp $0, %ebx
        je et_insert

        movl $0, %edx
        movb (%edi, %ecx, 1), %dl               ;//parcurgerea memoriei

        dec %ebx
        inc %ecx

        cmp $0, %edx
        jne et_verif_exit                       ;//ca sa vedem daca exista pozitii consecutive libere de memorie

        jmp et_verif2
    et_verif_exit:
        movl 8(%ebp), %ebx                      ;//reluam valoarea dimensiunii
        movl -4(%ebp), %ecx                     ;//reluam de la pozitia salvata
        inc %ecx                                ;//incrementare memorie
        jmp et_verif
    et_insert:
        movl -4(%ebp), %ecx
        movl %ecx, %edx
        movl %edx, 20(%ebp)                     ;//startx
    et_insert_2:  
        cmp $0, %eax                            ;//dimensiunea ramasa de introdus
        je et_exit_add

        movl 12(%ebp), %edx                     ;//inserarm id - ul
        movb %dl, (%edi, %ecx, 1)
        add $1, %ecx
        sub $1, %eax
        jmp et_insert_2
    et_exit_3:
        movl $0, %edx
        movl %edx, 20(%ebp)                     ;//startx
        movl %edx, 24(%ebp)                     ;//endx
        jmp et_exit_add_final
    et_exit_add:
        dec %ecx
        movl %ecx, %edx
        movl %edi, 16(%ebp)
        movl %edx, 24(%ebp)                     ;//endx
    et_exit_add_final:

    addl $4, %esp

    pop %ebx
    popl %ebp
    ret
opget:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx
    
    movl 8(%ebp), %eax                           ;//Selectare id
    movl 12(%ebp), %edi                          ;//Selectare memorie

    movl $0, %ecx

    et_verif_get:
        cmp $1024, %ecx
        jg et_exit_get_1

        movl $0, %edx
        movb (%edi, %ecx, 1), %dl               ;//parcurgerea memoriei
        
        cmp %eax, %edx                          ;//verificare existenta id - ului
        je et_indexstartget

        inc %ecx                                ;//incrementare memorie
        jmp et_verif_get
    et_indexstartget:
        movl $0, 16(%ebp)
        movl %ecx, 16(%ebp)                      ;//startx
    et_indexendget:
        cmp %eax, %edx
        jne et_exit_get_2

        movl $0, %edx
        movb (%edi, %ecx, 1), %dl               ;//parcurgerea memoriei

        movl $0, 20(%ebp)
        movl %ecx, 20(%ebp)                      ;//endx

        inc %ecx                                ;//incrementare memorie
        jmp et_indexendget
    et_exit_get_1:
        movl $0, %edx
        movl %edx, 16(%ebp)                     ;//startx
        movl %edx, 20(%ebp)                     ;//endx
        jmp et_exit_get_3
    et_exit_get_2:
        movl 20(%ebp), %ecx 
        sub $1, %ecx
        movl %ecx, 20(%ebp)                      ;//endx
    et_exit_get_3:
    pop %ebx
    popl %ebp
    ret
opdelete:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx
    
    mov 8(%ebp), %eax                           ;//Selectare id
    mov 12(%ebp), %edi                          ;//Selectare memorie

    mov $0, %ecx

    et_verif_delete:
        cmp $1024, %ecx
        jg et_exit_delete_1

        movl $0, %edx
        movb (%edi, %ecx, 1), %dl               ;//parcurgerea memoriei
        
        cmp %eax, %edx                          ;//verificare existenta id - ului
        je et_indexdelete

        inc %ecx                                ;//incrementare memorie
        jmp et_verif_delete
    et_indexdelete:
        cmp %eax, %edx
        jne et_exit_delete_1

        movl $0, %edx
        movb %dl, (%edi, %ecx, 1)               ;//parcurgerea memoriei
        movb 1(%edi, %ecx, 1), %dl

        inc %ecx                                ;//incrementare memorie
        jmp et_indexdelete
    et_exit_delete_1:
    pop %ebx
    popl %ebp
    ret
opdefragmentation:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx
    
    movl 8(%ebp), %edi                          ;//selectare memorie
    movl 12(%ebp), %edx                         ;//selectare lungime memorie
    dec %edx
    movl %edx, aux
    movl $0, %ecx

    et_loop_defrag_1:
        cmp aux, %ecx                           ;//cmp index cu memorie ca sa iesim daca e cazul
        je et_exit_defrag 

        movl $0, %edx
        movb (%edi,%ecx,1), %dl                 ;//extragem primul element

        cmp $0, %edx                            ;//vedem daca e 0
        je et_loop_defrag_2
        inc %ecx
        jmp et_loop_defrag_1                    ;//altfel loop
    et_loop_defrag_2:
        movl %ecx, %eax                         ;//salvam pozitia lui 0 in eax 
        inc %ecx
    et_loop_defrag_3:
        movl $0, %edx
        movb (%edi,%ecx,1), %dl                 ;//extragem elementul nr (ecx)

        cmp $0, %edx
        jne et_defrag_nr                        ;//cautam valoare diferita de 0

        cmp aux, %ecx
        je et_exit_defrag

        inc %ecx
        jmp et_loop_defrag_3
    et_defrag_nr:
        movb %dl, (%edi,%eax,1)                ;//inlocuim cu valoarea
        movb $0, (%edi,%ecx,1)                  ;//inlocuim cu 0 in memorie
        movl %eax, %ecx
        jmp et_loop_defrag_1
    et_exit_defrag:
    pop %ebx
    popl %ebp
    ret
opsortflist:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx

    sub $32, %esp
    movl $0, -4(%ebp)                           ;//starx pentru i-1
    movl $0, -8(%ebp)                           ;//endx pentru i
    movl $0, -12(%ebp)                          ;//id element i-1
    movl n, %ebx
    movl %ebx, -28(%ebp)

    movl 8(%ebp), %esi                          ;//adresa listei de fisiere
    movl $1, %ebx                               ;//contor pentru numar de fisiere

    et_cautare:
        cmp 12(%ebp), %ebx
        jg et_exit_cautare_fail

        movl $0, %edx
        movb -1(%esi,%ebx,1), %dl               ;//elementul i-1 din lista de fisiere
        movl %edx, id
        movl %edx, -12(%ebp)                    ;//id element i-1

        movl %ebx, -16(%ebp)
        ;/////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $s
        pushl id
        call opget                              ;//operatia de get pentru elementul i-1
        pop %ebx
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;/////////////////////////////////////////////////////////
        movl -16(%ebp), %ebx
        
        movl startx, %eax
        movl %eax, -4(%ebp)                     ;//starx pentru i-1

        movl $0, %edx
        movb (%esi,%ebx,1), %dl                 ;//elementul i din lista de fisiere
        movl %edx, id

        cmp $0, %edx
        je et_sort_salt1
        movl %ebx, -16(%ebp)
        ;/////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $s
        pushl id
        call opget                              ;//operatia de get pentru elementul i
        pop id
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////////////////
        movl -16(%ebp), %ebx

        movl endx, %eax
        movl %eax, -8(%ebp)                     ;//endx pentru i
        movl -4(%ebp), %eax
        cmp -8(%ebp), %eax                      ;//comparam i si i-1
        jg et_exit_cautare

        et_sort_salt1:

        inc %ebx
        jmp et_cautare
    et_exit_cautare:
        movl $0, -4(%ebp)                       ;//starx pentru i-1
        movl $0, -8(%ebp)                       ;//endx pentru i
        movl endx, %eax
        movl %eax, -20(%ebp)                    ;//salvam endx
        movl $0, %eax
        movl %eax, endx
        movl %eax, startx

        movl $0, %edx
        movb %dl, (%esi,%ebx,1)
        movl id, %edx
        movl %edx, -12(%ebp)                    ;//id element i

        jmp et_exit_cautare_succes
    et_exit_cautare_fail:
        jmp et_exit_total
    et_exit_cautare_succes:

    movl -12(%ebp), %edx    

    movl 8(%ebp), %esi                          ;//adresa listei de fisiere
    movl $1, %ebx                               ;//contor pentru numar de fisiere 

    et_cautare_insert:
        cmp 12(%ebp), %ebx
        jg et_exit_cautare_insert

        movl $0, %edx
        movb -1(%esi,%ebx,1), %dl               ;//elementul i-1 din lista de fisiere
        movl %edx, id

        movl %ebx, -16(%ebp)
        ;/////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $s
        pushl id
        call opget                              ;//operatia de get pentru elementul i-1
        pop %ebx
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;/////////////////////////////////////////////////////////
        movl -16(%ebp), %ebx

        movl $1, %eax
        movl %eax, ok                           ;//JUR CA NU INTELEG DE CE FUNCTIONEAZA ASA DAR ALTFEL NU SE POATE

        movl -20(%ebp), %eax                    ;//endx pentru id salvat

        cmp startx, %eax                        ;//startx pentru id i-1
        jl et_loop_insert
        jmp et_cautare_insert_continue

        et_loop_insert:
            movl $0, %eax
            movl %eax, ok

            movl id, %eax
            movl %eax, -24(%ebp)                ;//id existent in flist se salveaza

            movl -12(%ebp), %eax                ;//id pentru insert 
            movb %al, -1(%esi,%ebx,1)

            movl -24(%ebp), %eax
            movl %eax, -12(%ebp)

            cmp -28(%ebp), %ebx
            je et_loop_insert_final
            jmp et_loop_insert_continue

            et_loop_insert_final:
                movl id, %edx
                movb %dl, (%esi,%ebx,1)

            et_loop_insert_continue:

        et_cautare_insert_continue:

        inc %ebx
        jmp et_cautare_insert
    et_exit_cautare_insert:
        movl ok, %eax
        cmp $1, %eax
        jne et_exit_total

        movl -24(%ebp), %edx
        movb %dl, -2(%esi,%ebx,1)
        
    et_exit_total:

        pushl %eax
        pushl %ecx
        pushl %edx

        pushl n
        pushl $255
        pushl $flist
        call opdefragmentation                  ;//operatia de defragmentation a listei de fisiere
        pop %ebx
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
    
    addl $32, %esp

    pop %ebx
    popl %ebp
    ret
.global main
main:
    pushl %eax
    pushl %ecx
    pushl %edx
    call citire_rand                            ;//Cititm numarul de operatii
    pop %edx
    pop %ecx
    pop %eax

    movl x, %ecx                                ;//contor de operatii
    movl %ecx, numar                            ;//numar de operatii

    et_loop_operatii:
        movl numar, %ecx  
        sub $1, %ecx 
        movl %ecx, numar 
        cmp $0, %ecx
        jl et_exit

        pushl %eax
        pushl %ecx
        pushl %edx
        call citire_rand                        ;//Citim codul operatiei
        pop %edx
        pop %ecx
        pop %eax

        movl x, %eax                            ;//eax = codul operatiei
        movl %eax, cod                          ;//codul operatiei

        cmp $1, %eax
        je et_add
        cmp $2, %eax
        je et_get
        cmp $3, %eax
        je et_delete
        cmp $4, %eax
        je et_defragmentation                   ;//comparatiile
    et_add:           
        pushl %eax
        pushl %ecx
        pushl %edx
        call citire_rand                        ;//citim numar de fisiere
        pop %edx
        pop %ecx
        pop %eax

        movl x, %eax                            ;//eax = numar de fisiere
        addl %eax, n                            ;//n = numar de fisiere care sunt adaugate
    et_loop_add:
        pushl %eax
        pushl %ecx
        pushl %edx
        call citire_rand                        ;//citim id fisier
        pop %edx
        pop %ecx
        pop %eax

        movl x, %edx
        movb %dl, id
        ;///////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $flist
        pushl id
        pushl $1

        call opadd                              ;//operatia de add in lista de fisiere

        pop %ebx
        pop %ebx
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;//////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx
        call citire_rand                        ;//citim dimensiune fisier
        pop %edx
        pop %ecx
        pop %eax

        movl x, %edx
        movl %edx, dim
        ;///////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $s
        pushl id
        pushl dim

        call opadd                              ;//operatia de add in memorie

        pop %ebx
        pop %ebx
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;//////////////////////////////////////////////////
        movl endx, %ebx
        cmp $0, %ebx
        jne et_add_continue

        ;//////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $flist
        pushl id
        call opdelete                           ;//operatia de delete din lista de fisiere
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;//////////////////////////////////////////////////////////
        movl n, %ebx
        dec %ebx
        movl %ebx, n

        et_add_continue:
        pushl %eax
        pushl %ecx
        pushl %edx
        call scriere134                         ;//operatia de scriere pt add
        pop %edx
        pop %ecx
        pop %eax
        ;//////////////////////////////////////////////////
        movl n, %edx
        cmp $1, %edx
        jle et_loop_add_continue

        pushl %eax
        pushl %ecx
        pushl %edx

        pushl n
        pushl $flist
        call opsortflist                        ;//operatia de sortare a listei de fisiere
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////
        et_loop_add_continue:
        movl dim, %edx

        movl $0, %ebx

        sub $1, %eax
        cmp $0, %eax
        jne et_loop_add

        jmp et_loop_operatii
    et_get:
        pushl %eax
        pushl %ecx
        pushl %edx
        call citire_rand                        ;//citere id pt get   
        pop %edx
        pop %ecx
        pop %eax

        movl x, %edx
        movl %edx, id                           ;//id fisier de get-uit
        ;/////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $s
        pushl id
        call opget                              ;//operatia de get
        pop id
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx
        call scriere2                           ;//operatia de scriere pt get
        pop %edx
        pop %ecx
        pop %eax

        jmp et_loop_operatii
    et_delete:
        pushl %eax
        pushl %ecx
        pushl %edx
        call citire_rand                        ;//citere id pt delete   
        pop %edx
        pop %ecx
        pop %eax

        movl x, %edx
        movl %edx, id                           ;//id fisier de sters
        ;/////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $s
        pushl id
        call opget                              ;//operatia de get
        pop id
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;/////////////////////////////////////////////////////////

        movl endx, %edx
        cmp $0, %edx
        je et_delete_skip

        movl x, %edx
        movl %edx, id                           ;//id fisier de sters

        movl n, %eax
        sub $1, %eax
        movl %eax, n                            ;//numarul nou de fisiere
        ;/////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $s
        pushl id
        call opdelete                           ;//operatia de delete din memorie
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;//////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $flist
        pushl id
        call opdelete                           ;//operatia de delete din lista de fisiere
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;//////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl n
        pushl $255
        pushl $flist
        call opdefragmentation                  ;//operatia de defragmentation a listei de fisiere
        pop %ebx
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////
        et_delete_skip:

        jmp et_loop_scriere
    et_defragmentation:
        ;/////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $1024
        pushl $s
        call opdefragmentation                  ;//operatia de defragmentation a memoriei
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////
    et_loop_scriere:
        movl $0, %eax
        movl $0, %ebx
        movl $0, %edx
        lea flist, %esi
    et_loop_scriere_memorie:
        movl $0, %edx
        movb (%esi,%eax,1), %dl 
        movl %edx, id
        ;/////////////////////////////////////////
        add $1, %eax
        cmp n, %eax
        jg et_loop_operatii
        ;/////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $s
        pushl id
        call opget                              ;//operatia de get
        pop id
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx
        call scriere134                         ;//operatia de scriere memorie
        pop %edx
        pop %ecx
        pop %eax

        jmp et_loop_scriere_memorie
    et_exit: 
        movl $1, %eax
        xorl %ebx, %ebx
        int $0x80