    .data
    .section    .rodata
    
getString: .string "%s\0"
getInts: .string "%d"

    .text
.globl main
    .type   main,  @function
    
# Main function gets from the user two string, lengths and operation option. 
main:
    movq %rsp, %rbp #for correct debugging
    
    # backup the calle registers
    pushq %r12
    pushq %r13
    pushq %r14
    
    # backup the stack postion for free the memory and restore the calle register.
    movq %rsp, %r14    
        
    movq $getInts, %rdi                     # get the first string size
   
    movq $0, %rax                           # Reset %rax
    
    # get from the user a integer (the first length string)
    addq $-4, %rsp                          # Allocate 4 bytes for the string size
    leaq (%rsp), %rsi
    movq $getInts, %rdi
    call scanf
    movl (%rsp), %r8d                       # move the string size to %r8
    addq $4, %rsp                           # free the memory
    
    # get from the user the first string
    subq $2, %rsp                           # Allocate 2 bytes to the string size and '\0'
    subq %r8, %rsp                          # Allocate bytes to the first string
    movb %r8b, (%rsp)                       # move the string size to the first byte in the string
    movq %rsp, %r12                         # store the first string in %r12
    leaq 1(%rsp), %rsi                      # store the string adress in %rsi
    movq $0, %rax                           # reset %rax to 0
    movq $getString, %rdi                   # put the scanf pattern in %rdi
    call scanf
    
    # get from the user a integer (the second length string)
    movq $getInts, %rdi
    movq $0, %rax                           # Reset %rax
    addq $-4, %rsp                          # Allocate 4 bytes for the string size
    leaq (%rsp), %rsi                       # put the allocate address int %rsi
    movq $getInts, %rdi                     # put the string patter int %rdi
    call scanf
    movl (%rsp), %r8d                       # move the string size to %r8
    addq $4, %rsp                           # free the memory
    
    
    # get from the user the second string
    subq $2, %rsp                           # Allocate 2 bytes to the string size and '\0'
    subq %r8, %rsp                          # Allocate bytes to the first string
    movb %r8b, (%rsp)                       # move the string size to the first byte in the string
    movq %rsp, %r13                         # store the first string in %r12
    leaq 1(%rsp), %rsi                      # store the string adress in %rsi
    movq $0, %rax                           # reset %rax to 0
    movq $getString, %rdi                   # put the scanf pattern in %rdi
    call scanf
   
    
    # get the option input
    movq $getInts, %rdi                     # put the string pattern in %rdi
    movq $0, %rax                           # Reset %rax
    addq $-4, %rsp                          # Allocate 4 bytes for the string size
    leaq (%rsp), %rsi                       # store the string adress in %rsi
    movq $getInts, %rdi
    call scanf
    movl (%rsp), %r8d                       # move the string size to %r8
    addq $4, %rsp                           # free the memory
    
    # store the input arguments in the run_option function arguments.
    movq %r12, %rdi                         # the first string
    movq %r13, %rsi                         # the second string
    movq %r8, %rdx                          # the option   
    call run_option
    
    # free the all memory in the stack
    movq %r14, %rsp
    
    # restore the calle registers
    popq %r14
    popq %r13
    popq %r12
    ret
 