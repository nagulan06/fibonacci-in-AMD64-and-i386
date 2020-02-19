  .global main

  .text


fib:

/* Variable mapping: in fib(n),
                     %rbx = n
                     %rax = result */

    enter $16, $0

//%rbx and %r12 are safe registers and hence it is saved (callee save)
  
    push %rbx
    push %r12
    mov %rdi, %rbx
    
    cmp $1,%rbx
    je one

    cmp $0, %rbx
    je zero
                    //The safe register %rbx is used as it is again required and decremented by 2 for the second recursive call
    mov %rbx, %rdi
    dec %rdi
   
    call fib
                    //The output is stored in %r12, a safe register since it is required to survive the next fib function call 
    mov %rax, %r12 
    mov %rbx, %rdi
    dec %rdi
    dec %rdi
    
    call fib

    add %r12, %rax
    jmp done
            //return 0 for n=0 and return one for n=1
one:
    mov $1, %rax
    jmp done

zero:
    mov $0, %rax
    jmp done

            // restore the values of %r12 and %rbx and return
done:
    pop %r12 
    pop %rbx   
    leave 
    ret

main:

/* Variable mapping: argc = %rdi
                     argv[1] = 8(%rsi)
                     output = %rax   */   

  enter $16, $0

  cmp $2, %rdi
  jne error

  mov 8(%rsi), %rdi
  call atol
  cmp $0, %rax
  jl error
  // the value in %rax is pushed onto the stack and popped back into %rcx later as fib may clobber the value (caller save).
  push %rax
  mov %rax, %rdi
  call fib
  pop %rcx
                 // Print result
  mov %rax,%rdx 
  mov %rcx, %rsi
  mov $output_fmt, %rdi
             //To speicfy there are no floating point values passed to printf
  mov $0, %al
  call printf

  leave
  ret

error:
    mov $usage, %rdi
    call puts
    leave
    ret
.data
    output_fmt:  .string "fib(%ld) = %ld\n"
    usage: .string "Usage: ./fib N where N >= 0"
