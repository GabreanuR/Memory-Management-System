.data
    folderstat: .space 1000000                              ;//Informatii despre folder
    fss: .space 4                                           ;//marimea ocupata in bytes a folderstat
    info: .space 100000                                     ;//fd si dim aici apar
    s: .space 1048576                                       ;//Memoria
    numar: .space 4                                         ;//Numar de operatii
    cod: .space 4                                           ;//Codul operatiei
    n: .space 4                                             ;//Numar de fisiere existente
    flist: .space 255                                       ;//Lista de fisiere
    flistdim: .space 1024                                   ;//Lista de dimensiuni
    aux: .space 4                                           ;//Auxiliara1 pt defragmentation
    aux2: .space 4                                          ;//Auxiliara2 pt delete
    aux3: .space 4                                          ;//Auxiliara3 pt delete
    aux4: .space 4                                          ;//Auxiliara4 pt delete
    id: .space 4                                            ;//Id fisier
    dim: .space 4                                           ;//Dimensiune fisier
    startx: .space 4                                        ;//Prima pozitie
    endx: .space 4                                          ;//Ultima pozitie  
    indexpoz: .long 0                                       ;//Pentru a parcurge memoria de la inceput
    pozy: .space 4                                          ;//Pozitia liniei
    x: .space 4                                             ;//Numar actual citit
    index: .space 4                                         ;//Indicele din memorie
    aux5: .space 4                                          ;//Auxiliara5 pt adddefrag
    aux6: .space 4                                          ;//Auxiliara6 pt adddefraf
    aux7: .space 4                                          ;//Auxiliara7 pt adddefraf
    aux8: .space 4                                          ;//Auxiliara8 pt adddefraf
    aux9: .space 4                                          ;//Auxiliara9 pt adddefraf
    aux10: .space 4                                         ;//Auxiliara10 pt adddefraf
    aux11: .space 4                                         ;//Auxiliara11 pt adddefrag SPER CA ULTIMUL
    aux12: .space 4                                         ;//Probabil se putea mai bine decat cu 12 aux uri
    aux13: .space 4                                         ;//Dezamagire
    aux14: .space 4                                         ;//Acum gata pe bune
    difline: .space 4                                       ;//spatiul ramas pe linie
    t: .space 10                                            ;//Variabila test
    p: .space 1024                                          ;//Path ul catre folder
    pfile: .space 1024                                      ;//PATH ul catre file
    plen: .space 4                                          ;//Lungimea PATH ului dat in bytes
    fds: .space 4                                           ;//File descriptor brut
    fd: .space 4                                            ;//File descriptor bun
    fileStat: .space 1000                                   ;//Informatiile despre fisier
    dim2: .space 4                                          ;//Dimensiunea fisierului
    EAX: .space 4                                           ;//Poate avem nevoie
    EBX: .space 4                                           ;//Poate avem nevoie
    ECX: .space 4                                           ;//Poate avem nevoie
    EDX: .space 4                                           ;//Poate avem nevoie
    ok: .space 4                                            ;//PENTRU CA AM CEDAT PSIHIC CU SORTAREA DE LISTA
    ok2: .space 4                                           ;//pt concrete ca gen avem fisiere minune . si ..
    formatStringCitire: .asciz "%ld"                        ;//Ce citim
    formatString0: .asciz "%d: ((%d, %d), (%d, %d))\n"      ;//Output pentru 1 3 4
    formatString1: .asciz "((%d, %d), (%d, %d))\n"          ;//Output pentru 2
    formatStringCitireFolder: .asciz "%s"                   ;//Citire folder path
    formatStringFds: .asciz "%ld\n"                         ;//Scriere Fds
    formatStringFd: .asciz "%ld\n"                          ;//Scriere Fd
    formatStringdim: .asciz "%ld\n"                         ;//Scriere dim
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
citire_path:
    pushl %ebp
    mov %esp, %ebp

    pushl $p
    pushl $formatStringCitireFolder
    call scanf
    popl %ebx
    popl %ebx

    popl %ebp
    ret
scriereFd:
    pushl %ebp
    mov %esp, %ebp

    pushl fd
    pushl $formatStringFd
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx

    popl %ebp
    ret
scrieredim:
    pushl %ebp
    mov %esp, %ebp

    pushl dim
    pushl $formatStringdim
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx

    popl %ebp
    ret
FDScatreFD:
    pushl %ebp
    mov %esp, %ebp

    movl 8(%ebp), %eax
    movl $0, %edx
    movl $255, %ebx
    div %ebx

    addl $1, %edx

    movl %edx, 8(%ebp)

    popl %ebp
    ret
opdiv:
    pushl %ebp
    mov %esp, %ebp

    movl 8(%ebp), %eax
    movl $0, %edx
    movl $1024, %ebx
    div %ebx

    movl %eax, 8(%ebp)

    popl %ebp
    ret
findlength:
    pushl %ebp
    mov %esp, %ebp

    movl 8(%ebp), %esi
    movl $0, %eax
    movl $0, %ecx
    movb (%esi,%ecx,1), %al
    et_loop_length:
        cmp $0, %al
        je et_loop_length_exit

        inc %ecx
        movb (%esi,%ecx,1), %al
        jmp et_loop_length
    et_loop_length_exit:
    movl %ecx, 8(%ebp)

    popl %ebp
    ret
copyfile:
    pushl %ebp
    mov %esp, %ebp

    movl 8(%ebp), %esi                      ;//adresa lui p
    movl 12(%ebp), %edi                     ;//adresa lui pfile
    movl 16(%ebp), %ecx                     ;//lungimea lui p
    
    et_loop_copy:
        cmp $0, %ecx
        jl et_loop_copy_exit

        movl $0, %eax
        movb (%esi, %ecx, 1), %al
        movb %al, (%edi, %ecx, 1)

        dec %ecx
        jmp et_loop_copy
    et_loop_copy_exit:

    popl %ebp
    ret
findandcopy:
    pushl %ebp
    mov %esp, %ebp

    sub $4, %esp

    movl 8(%ebp), %esi                          ;//folderstat
    movl 12(%ebp), %edi                         ;//pfile
    movl 16(%ebp), %ebx                         ;//plen
    movl 20(%ebp), %ecx                         ;//contorul in fss

    addl %ecx, %esi
    movl $0, %eax
    movb (%esi), %al                     ;//sa ajungem la pozitia curenta din folderstat
    movl %eax, -4(%ebp)                         ;//distanta pana la urmatorul contor
    addl %eax, %ecx
    movl %ecx, 20(%ebp)                         ;//trimitem contorul modificat inapoi in main
    addl %ebx, %edi                             ;//sa ajungem la prima pozitie de scris din pfile
    addl $2, %esi
    movl $0, %ecx
    movl $0x2F, %eax
    movb %al, (%edi,%ecx,1)
    movl $1, %ecx

    et_loop_findandcopy:
        movl $0, %eax
        movb -1(%esi, %ecx, 1), %al

        cmp $0x2E, %al
        je et_posibil_dubios                    ;//daca avem .
        jmp et_normal
        et_posibil_dubios:
            movl $0, %eax
            movb (%esi, %ecx, 1), %al

            cmp $0x2E, %al
            je et_probabil_dubios               ;//daca avem ..
            cmp $0, %eax
            je et_dubios                        ;//daca avem . si gata numele

            movl $0, %eax
            movb -1(%esi, %ecx, 1), %al
            jmp et_normal                       ;//inapoi la normal
            et_probabil_dubios:
                movl $0, %eax
                movb 1(%esi, %ecx, 1), %al

                cmp $0, %al                     ;//daca avem .. si gata
                je et_dubios

                movl $0, %eax
                movb -1(%esi, %ecx, 1), %al
                jmp et_normal                       ;//inapoi la normal
        et_normal:
        cmp $0, %eax
        je et_loop_findandcopy_exit

        movb %al, (%edi,%ecx,1)

        inc %ecx
        jmp et_loop_findandcopy
    et_loop_findandcopy_exit:
        movl $0, %eax
        movb %al, (%edi,%ecx,1)
        movl $0, %eax
        movl %eax, ok2                          ;//inseamna ca file urile sunt bune
        jmp et_salt_dubios
    et_dubios:
        movl $1, %eax
        movl %eax, ok2                          ;//file de forma . sau ..    (chestie de linux sau ceva)
    et_salt_dubios:
        
    add $4, %esp

    popl %ebp
    ret
concatfilenumar:
    pushl %ebp
    mov %esp, %ebp

    movl 8(%ebp), %esi                      ;//adresa PATH ului
    movl 12(%ebp), %ecx                     ;//distanta de la care adaugam
    movl 16(%ebp), %edx                     ;//numarul de tranformat
    
    cmp $9, %edx
    jg et_douacifre
    addl $0x30, %edx                        ;//din ascii in int
    movb %dl, (%esi,%ecx,1)                 ;//PATH = PATH + cifra
    inc %ecx                                ;//pt ca am mai adaugat un caracter
    jmp concatfiletxt

    et_douacifre:
        movl %edx, %eax
        movl $0, %edx
        movl $10, %ebx
        div %ebx                            ;//separam cifra zecilor (in eax) de cifra unitatilor (in edx)

        addl $0x30, %eax                    ;//din ascii in int
        movb %al, (%esi,%ecx,1)             ;//PATH = PATH + cifra zecilor
        inc %ecx                            ;//pt ca am mai adaugat un caracter

        addl $0x30, %edx                    ;//din ascii in int
        movb %dl, (%esi,%ecx,1)             ;//PATH = PATH + cifra unitatilor
        inc %ecx                            ;//pt ca am mai adaugat un caracter

    concatfiletxt:

    movl $0, %eax
    movb $0x2E, %al
    movb %al, (%esi,%ecx,1)                 ;//PATH = PATH + .

    movl $0, %eax
    movb $0x74, %al
    movb %al, 1(%esi,%ecx,1)                 ;//PATH = PATH + t

    movl $0, %eax
    movb $0x78, %al
    movb %al, 2(%esi,%ecx,1)                 ;//PATH = PATH + x

    movl $0, %eax
    movb $0x74, %al
    movb %al, 3(%esi,%ecx,1)                 ;//PATH = PATH + t

    popl %ebp
    ret
scriere134:
    pushl %ebp
    mov %esp, %ebp

    pushl endx
    pushl pozy
    pushl startx
    pushl pozy
    pushl id
    pushl $formatString0
    call printf
    popl %ebx
    popl %ebx
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
    pushl pozy
    pushl startx
    pushl pozy
    pushl $formatString1
    call printf
    popl %ebx
    popl %ebx
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
        je et_exit_get_1

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
opptsortget:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx
    
    movl 8(%ebp), %eax                           ;//Selectare id
    movl 12(%ebp), %edi                          ;//Selectare memorie

    movl $0, %ecx

    et_verif_get_ptsort:
        cmp $1048576, %ecx
        je et_exit_get_1_ptsort

        movl $0, %edx
        movb (%edi, %ecx, 1), %dl               ;//parcurgerea memoriei
        
        cmp %eax, %edx                          ;//verificare existenta id - ului
        je et_indexstartget_ptsort

        inc %ecx                                ;//incrementare memorie
        jmp et_verif_get_ptsort
    et_indexstartget_ptsort:
        movl $0, 16(%ebp)
        movl %ecx, 16(%ebp)                      ;//startx
    et_indexendget_ptsort:
        cmp %eax, %edx
        jne et_exit_get_2_ptsort

        movl $0, %edx
        movb (%edi, %ecx, 1), %dl               ;//parcurgerea memoriei

        movl $0, 20(%ebp)
        movl %ecx, 20(%ebp)                     ;//endx

        inc %ecx                                ;//incrementare memorie
        jmp et_indexendget_ptsort
    et_exit_get_1_ptsort:
        movl $0, %edx
        movl %edx, 16(%ebp)                     ;//startx
        movl %edx, 20(%ebp)                     ;//endx
        jmp et_exit_get_3_ptsort
    et_exit_get_2_ptsort:
        movl 20(%ebp), %ecx                     
        sub $1, %ecx
        movl %ecx, 20(%ebp)                      ;//endx
    et_exit_get_3_ptsort:
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
        cmp $1048576, %ecx
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
verif_rand:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx

    movl 8(%ebp), %eax
    movl $0, %edx
    movl $1024, %ebx
    div %ebx

    cmp $1023, %eax
    je et_numar_rau

    movl $1, 8(%ebp)
    jmp et_exit_verif

    et_numar_rau:
    movl $0, 8(%ebp)

    et_exit_verif:

    pop %ebx
    popl %ebp
    ret
opdefragmentation2:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx
    
    movl 8(%ebp), %edi                          ;//selectare memorie
    movl 12(%ebp), %edx                         ;//selectare lungime memorie
    dec %edx
    movl %edx, aux
    movl $0, %ecx
    movl %ecx, aux11                            ;//pentru ca altfel nu stiu cum sa fac if ul horror
    movl $-1, %ecx
    movl %ecx, difline
    movl $1023, %ecx
    et_loop_defrag_1_special:
        cmp aux, %ecx                           ;//cmp index cu memorie ca sa iesim daca e cazul
        jg et_exit_defrag_special 

        movl $0, %edx
        movb (%edi,%ecx,1), %dl                 ;//extragem ultimul element de pe randul i

        cmp $0, %edx
        je et_next_line_2_special
        movl %edx, aux5

        inc %ecx

        movl $0, %edx
        movb (%edi,%ecx,1), %dl                 ;//extragem primul element de pe randul i+1

        cmp $0, %edx
        je et_next_line_1_special

        cmp aux5, %edx
        je et_go_back_special

        movl %ebx, -16(%ebp)
        movl aux11, %ebx
        cmp $2, %ebx 

        movl -16(%ebp), %ebx
        movl %ecx, aux6                         ;//salvam contorul
        jmp et_next_line_1_special

        et_go_back_special:
        movl %ecx, aux6                         ;//salvam contorul
        movl %ecx, aux10
        dec %ecx
        dec %ecx
        movl $1, %edx                           ;//exista cel putin un numar aflat prost
        movl %edx, aux7
            et_go_back_while_special:
            movl $0, %edx
            movb (%edi,%ecx,1), %dl                 ;//parcurgem memoria invers

            cmp aux5, %edx
            jne et_gasit_cnt_gresite_special

            movl aux7, %edx
            inc %edx
            movl %edx, aux7                         ;//contor pozitii de mutat

            dec %ecx
            jmp et_go_back_while_special

            et_gasit_cnt_gresite_special:
            movl aux7, %ecx
            dec %ecx
            movl %ecx, aux7
            movl aux6, %ecx
            inc %ecx

            et_find_zero_special:
            movl $0, %edx
            movb (%edi,%ecx,1), %dl                 ;//parcurgem memoria

            cmp $0, %edx
            je et_found_zero_special

            inc %ecx
            jmp et_find_zero_special
            

            et_found_zero_special:
            dec %ecx
            movl %ecx, aux8                         ;//ultima poz nenula
            inc %ecx
            movl aux7, %edx                         ;//cate sunt de mutat

            et_nr_poz_special:
            inc %ecx
            dec %edx
            cmp $0, %edx
            je et_inloc_special
            jmp et_nr_poz_special

            et_inloc_special:
            movl %ecx, aux9                         ;//locatia in care trebuie sa mutam

            et_inloc_2_special:
            cmp aux10, %ecx
            jl et_next_line_1_special
            movl aux8, %ecx
            movl $0, %edx
            movb (%edi,%ecx,1), %dl
            movl $0, %eax
            movb %al, (%edi,%ecx,1)
            dec %ecx
            movl %ecx, aux8
            movl aux9, %ecx
            movb %dl, (%edi,%ecx,1)
            dec %ecx
            movl %ecx, aux9 
            jmp et_inloc_2_special

        et_next_line_1_special:
        movl $0, %ecx
        movl %ecx, aux5
        movl aux6, %ecx
        dec %ecx
        addl $1024, %ecx
        movl %ecx, aux6
        jmp et_loop_defrag_1_special                    ;//altfel loop

        et_next_line_2_special:
        addl $1024, %ecx
        movl %ecx, aux6
        jmp et_loop_defrag_1_special                    ;//altfel loop
    et_exit_defrag_special:
    pop %ebx
    popl %ebp
    ret
opsortflist:
    pushl %ebp
    mov %esp, %ebp
    pushl %ebx

    sub $28, %esp
    movl $0, -4(%ebp)                           ;//startx pentru i-1
    movl $0, -8(%ebp)                           ;//endx pentru i
    movl $0, -12(%ebp)                          ;//id element i-1
    movl n, %ebx
    dec %ebx
    movl %ebx, -28(%ebp)

    movl 8(%ebp), %esi                          ;//adresa listei de fisiere
    movl $1, %ebx                               ;//contor pentru numar de fisiere

    et_cautare:
        cmp 12(%ebp), %ebx
        je et_exit_cautare_fail

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
        call opptsortget                        ;//operatia de get pentru elementul i-1
        pop id
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;/////////////////////////////////////////////////////////
        movl -16(%ebp), %ebx
        
        movl startx, %eax
        movl %eax, -4(%ebp)                     ;//startx pentru i-1

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
        call opptsortget                        ;//operatia de get pentru elementul i
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

        movl $0, %edx
        movl %edx, -12(%ebp)                    ;//id element i

        et_sort_salt1:

        inc %ebx
        jmp et_cautare
    et_exit_cautare:
        movl $0, -4(%ebp)                       ;//startx pentru i-1
        movl $0, -8(%ebp)                       ;//endx pentru i
        movl endx, %eax
        movl %eax, -20(%ebp)                    ;//salvam endx
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
    movl 12(%ebp), %ebx
    movl %ebx, 12(%ebp)
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
        call opptsortget                        ;//operatia de get pentru elementul i-1
        pop id
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
    
    addl $28, %esp

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
        je et_defragmentation                   
        cmp $5, %eax
        je et_concrete                          ;//comparatiile
    et_add:           
        pushl %eax
        pushl %ecx
        pushl %edx
        call citire_rand                        ;//citim numar de fisiere
        pop %edx
        pop %ecx
        pop %eax

        movl $0, %eax
        movl %eax, pozy
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
        cmp $8192, %edx
        jg et_delete_flist_din_add
        ;///////////////////////////////////////////////////
        lea s, %edx

        et_loop_add_horror:

        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl %edx
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
        je et_loop_add_horror_inc
        jmp et_add_continue

        et_loop_add_horror_inc:
            movl pozy, %ebx
            inc %ebx
            movl %ebx, pozy
            addl $1024, %edx
            cmp $1024, %ebx
            je et_delete_flist_din_add
            jmp et_loop_add_horror
        ;//////////////////////////////////////////////////////////
        et_delete_flist_din_add:
        movl $0, %edx
        movl %edx, startx
        movl %edx, endx
        movl %edx, pozy
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

        movl $0, %ebx
        movl %ebx, pozy
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

        movl $0, %edx
        movl %edx, pozy
        lea s, %edx

        et_loop_get_horror:
        ;/////////////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl %edx
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
        movl endx, %ebx
        cmp $0, %ebx
        je et_loop_get_horror_inc
        jmp et_get_continue

        et_loop_get_horror_inc:
            movl pozy, %ebx
            inc %ebx
            movl %ebx, pozy
            addl $1024, %edx
            cmp $1024, %ebx
            je et_neexistent_ever
            jmp et_loop_get_horror
        ;//
        et_neexistent_ever:
            movl $0, %edx
            movl %edx, startx
            movl %edx, endx
            movl %edx, pozy
        et_get_continue:
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
        call opptsortget                        ;//operatia de get
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

        pushl n
        pushl $1048576
        pushl $s
        call opdefragmentation                  ;//operatia de defragmentation a listei de fisiere
        pop %ebx
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////
        ;/////////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl n
        pushl $1048576
        pushl $s
        call opdefragmentation2                  ;//operatia de defragmentation a listei de fisiere
        pop %ebx
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////
        jmp et_loop_scriere
    et_concrete:
        movl %eax, EAX
        movl %ebx, EBX
        movl %ecx, ECX
        movl %edx, EDX
        movl $0, %ebx
        movl %ebx, p
        ;////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx
        call citire_path                        ;//citim path ul folder ului
        pop %edx
        pop %ecx
        pop %eax
        ;////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $p
        call findlength                         ;//aflam lungimea lui p
        pop plen

        pop %edx
        pop %ecx
        pop %eax
        ;////////////////////////////////////////////
        movl $5, %eax                           ;//deschidem folder ul
        movl $p, %ebx                           ;//adresa folder ului
        movl $0, %ecx                           ;//mod citire
        int $0x80
        ;////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl plen
        pushl $pfile
        pushl $p
        call copyfile                           
        pop %ebx
        pop %ebx
        pop %ebx

        pop %edx
        pop %ecx
        pop %eax
        ;////////////////////////////////////////////
        movl %eax, %ebx                         ;//folder descriptor
        movl $141, %eax                         ;//getdents
        movl $folderstat, %ecx                  ;//aici apare informatia despre fisier
        movl $1000000, %edx                     ;//cam cata memorie alocam (probabil e cam mult dar mna)
        int $0x80
        ;////////////////////////////////////////////
        movl %eax, fss                          ;//cata memorie ocupa defapt
        ;////////////////////////////////////////////
        movl $0, %ecx
        movl %ecx, aux12
        movl EBX, %ebx
        movl %ebx, EBX                          ;//ca sa stiu ca am facut asta 
        movl $folderstat, %ebx                  ;//aici apare toata informatia 
        movl $0, %eax
        movb (%ebx), %al                        ;//de aici + 1 incepe informatia legata de fiecare fisier in parte
        ;//also, sunt 24 de bytes pana la urmatorul byte care are urmatoarea astfel de informatie
        ;//tin sa zic ca stau mai prost cu romana asa ca scuze
        movl $0, %edx                           ;//contor info
        et_superloop:
            movl aux12, %ecx
            cmp $0, %ecx
            jne et_superloop_1
            addl $8, %ecx
            movl %ecx, aux12

            et_superloop_1:
            cmp fss, %ecx  
            jg et_superloop_exit                ;//inseamna ca am parcurs tot folderstat ul
            ;////////////////////////////////////////////
            pushl %eax
            pushl %edx

            pushl %ecx
            pushl plen
            pushl $pfile
            pushl $folderstat
            call findandcopy                    ;//cautam in folderstat file ul si il adugam la final de pfile + / 
            pop %ebx
            pop %ebx
            pop %ebx
            pop %ecx

            pop %edx
            pop %eax
            ;////////////////////////////////////////////
            movl %ecx, aux12                    ;//ca sa avansam cu contorul prin folderstat
            movl ok2, %ecx
            cmp $1, %ecx
            je et_skip_file
            ;////////////////////////////////////////////
            movl $5, %eax                           ;//deschidem file ul
            movl $pfile, %ebx                       ;//adresa file ului
            movl $0, %ecx                           ;//mod citire
            int $0x80
            ;////////////////////////////////////////////
            cmp $-2, %eax                           ;// %eax == -2 <=> file ul nu poate fi deschis (nu exista)
            je et_superloop_exit
            ;////////////////////////////////////////////
            movl %eax, fds
            ;////////////////////////////////////////////
            movl %eax, %ebx                         ;//fds dat de sistem
            movl $108, %eax                         ;//cod fstat                        
            movl $fileStat, %ecx                    ;//spatiu pentru toata informatia
            int $0x80
            ;////////////////////////////////////////////
            movl $fileStat, %esi                    ;//Pentru a parcurge informatia (suna naspa dpdv al limbii romane)
            movl $0, %eax
            movl 20(%esi), %eax                     ;//Teoretic aici se afla dimensiunea
            movl %eax, dim2
            ;////////////////////////////////////////////
            pushl %eax
            pushl %ecx
            pushl %edx

            pushl dim2
            call opdiv                              ;//operatia de impartire la 1024
            pop dim2

            pop %edx
            pop %ecx
            pop %eax
            ;////////////////////////////////////////////
            pushl %eax
            pushl %ecx
            pushl %edx

            pushl fds
            call FDScatreFD                         ;//operatia de transformare a FDS in FD
            pop fd

            pop %edx
            pop %ecx
            pop %eax
            ;////////////////////////////////////////////
            movl $info, %edi
            movl fd, %eax
            movl %eax, (%edi,%edx,4)
            movl dim2, %eax
            movl %eax, 4(%edi,%edx,4)
            addl $2, %edx
            ;////////////////////////////////////////////
            movl $6, %eax                           ;//inchidem file ul
            movl $pfile, %ebx                       ;//adresa file ului
            int $0x80
            ;////////////////////////////////////////////
            movl aux14, %ecx
            inc %ecx
            movl %ecx, aux14
            et_skip_file:

            jmp et_superloop
        et_superloop_exit:

        ;////////////////////////////////////////////
        movl $6, %eax                           ;//inchidem folder ul
        movl $p, %ebx                           ;//adresa folder ului
        int $0x80
        ;////////////////////////////////////////////

        movl $0, %ecx
        movl %ecx, aux13                        ;//contor parcurgere memorie cu fd si dim

        movl EAX, %eax 
        movl EBX, %ebx 
        movl ECX, %ecx
        movl EDX, %edx

        movl $0, %eax
        movl %eax, pozy
        movl aux14, %eax                        ;//eax = numar de fisiere
        dec %eax
        addl %eax, n                            ;//n = numar de fisiere care sunt adaugate
        movl %eax, EAX
    et_loop_add_concrete:
        movl %ecx, ECX
        movl $info, %edi
        movl aux13, %ecx
        movl $0, %edx
        movl (%edi,%ecx,4), %edx
        movl %edx, fd
        movl %edx, id
        ;////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx
        call scriereFd                          ;//operatia de scriere FD
        pop %edx
        pop %ecx
        pop %eax
        ;////////////////////////////////////////////
        movl $0, %edx
        movl 4(%edi,%ecx,4), %edx
        movl %edx, dim
        addl $2, %ecx
        movl %ecx, aux13
        movl ECX, %ecx
        ;////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx
        call scrieredim                         ;//operatia de scriere dim
        pop %edx
        pop %ecx
        pop %eax
        ;////////////////////////////////////////////
        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl $s
        pushl id
        call opptsortget                        ;//operatia de get
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
        jne et_concrete_special
        jmp et_concrete_normal

        et_concrete_special:
            movl $0, %edx
            movl %edx, startx
            movl %edx, endx
            movl %edx, pozy
            jmp et_add_continue_concrete

        et_concrete_normal:
        ;////////////////////////////////////////////
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
        movl dim, %edx
        cmp $8192, %edx
        jg et_delete_flist_din_add_concrete
        ;///////////////////////////////////////////////////
        lea s, %edx

        et_loop_add_horror_concrete:

        pushl %eax
        pushl %ecx
        pushl %edx

        pushl $endx
        pushl $startx
        pushl %edx
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
        je et_loop_add_horror_inc_concrete
        jmp et_add_continue_concrete

        et_loop_add_horror_inc_concrete:
            movl pozy, %ebx
            inc %ebx
            movl %ebx, pozy
            addl $1024, %edx
            cmp $1024, %ebx
            je et_delete_flist_din_add_concrete
            jmp et_loop_add_horror_concrete
        ;//////////////////////////////////////////////////////////
        et_delete_flist_din_add_concrete:
        movl $0, %edx
        movl %edx, startx
        movl %edx, endx
        movl %edx, pozy
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

        et_add_continue_concrete:

        pushl %eax
        pushl %ecx
        pushl %edx
        call scriere134                         ;//operatia de scriere pt add
        pop %edx
        pop %ecx
        pop %eax

        movl $0, %ebx
        movl %ebx, pozy
        ;//////////////////////////////////////////////////
        movl n, %edx
        cmp $1, %edx
        jle et_loop_add_continue_concrete

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
        et_loop_add_continue_concrete:
        movl dim, %edx

        movl $0, %ebx

        movl EAX, %eax
        sub $1, %eax
        movl %eax, EAX
        cmp $0, %eax
        jge et_loop_add_concrete 

        jmp et_loop_operatii
    et_loop_scriere:
        movl $0, %eax
        movl %eax, aux2
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
        call opptsortget                        ;//operatia de get
        pop id
        pop %ebx
        pop startx
        pop endx

        pop %edx
        pop %ecx
        pop %eax
        ;///////////////////////////////////////////////////////////
        movl %ecx, aux3
        movl %edx, aux4
        movl %eax, aux2

        movl $0, %edx
        movl startx, %eax
        movl $1024, %ecx
        div %ecx
        movl %eax, pozy
        movl %edx, startx

        movl $0, %edx
        movl endx, %eax
        movl $1024, %ecx
        div %ecx
        movl %eax, pozy
        movl %edx, endx

        movl aux3, %ecx
        movl aux4, %edx
        movl aux2, %eax
        

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