    .global main

    .text
fib:
/* Variable mapping: in fib(n)
                    %ebx = n 
                    %eax = result*/

    enter $16, $0
                 //%ebx and %edi is a safe register. Hence it is stored in stack (callee save)
    push %ebx
    push %edi
                    // argument in stack - 8(%ebp)
    mov 8(%ebp), %ebx
    mov %ebx, %ecx
                   // return 0 for n=0 and return 1 for n=1
    cmp $0, %ecx
    je zero

    cmp $1, %ecx
    je one 
                  //fib(n-1)
    dec %ecx
    
    push %ecx
    call fib        
                  // since %ecx was pushed, stack pointer is restored
    add $4, %esp    
                  // fib(n-2)
    mov %eax, %edi
    mov %ebx, %ecx
    dec %ecx
    dec %ecx
    
    push %ecx
    call fib
    add $4, %esp
                 /* %edi contains the result of the function call fib(n-1)
                    final result = %eax */
                    
    add %edi, %eax
    jmp done

                 //return(0)
zero:
    mov $0, %eax
    jmp done

                //return(1)
one:
    mov $1, %eax
    jmp done

                //restore the values of safe registers and return
done:
    pop %edi
    pop %ebx
    leave 
    ret

main:
/* Variable mapping: %edx = argc
                     %esi = argv[1] */

    enter $16, $0
                    //%esi is a safe register
    push %esi

    mov 8(%ebp), %edx
    cmp $2, %edx
    jne error
                        //12(%ebp) contains the base pointer of the string argv[1]
    mov 12(%ebp), %ecx
                        //argv[1]
    mov 4(%ecx), %esi  
    push %esi
    call atoi
    add $4, %esp
                        // to show usage message for negative numbers
    cmp $0, %eax
    jl error

    push %eax
    call fib
    add $4, %esp
                    //print result
    push %eax
    push %esi
    push $output_fmt
    call printf
    add $12, %esp
                    // restore the value of safe register %esi and return
    pop %esi
    leave
    ret
                    // throw usage message
error:
    push $usage
    call puts
    leave
    ret    

.data
    output_fmt:  .string "fib(%s) = %ld\n"
    usage: .string "Usage: ./fib N where N >= 0"
