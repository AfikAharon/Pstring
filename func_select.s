    .data
    .section    .rodata
    
    #Align adress to multiple of 8
    .align 8 
  
.funcSelect:
    .quad .case_A
    .quad .case_B
    .quad .case_C
    .quad .case_D
    .quad .case_E
    .quad .case_def

printLengthString: .string "first pstring length: %d, second pstring length: %d\n"
printOldNewChar: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
printSubString: .string "length: %d, string: %s\n"
printSwapCase: .string "length: %d, string: %s\n"
invalidOption: .string "invalid option!\n"
invalidInput: .string "invalid input!\n"
printComprePstring: .string "compare result: %d\n"
getChars: .string "%c %c"
getInts: .string "%d"
getDummy: .string "%c"
  
    
.globl run_option
    .type   run_option, @function
# run_option is a function that get 3 arguments 2 string (%rdi first %rsi second) and option (%rdx)
run_option:
    # check wich option the user input
    leaq -50(%rdx), %rcx
    cmpq $4, %rcx 
    # check if the case option > 4
    ja .case_def 
    jmp *.funcSelect(,%rcx,8)
    
    # If the user input case 50 - print the string length.
    .case_A:
        # Backup the caller registers
        pushq %rdi
        pushq %rsi
        pushq %rdx
        pushq %rsi
        
        
        movq $0, %rax
        call pstrlen                        # get the first string length
        movb %al, %dl                       # Backup the first string legnth
        
        movq $0, %rax
        # Move the second string to %rdi for the first argument to the function pstlen
        popq %rdi                           # move the second string to %rdi from the stack.
        call pstrlen
        movb %al, %r8b                      # Backup the second string legnth
        
        movq $printLengthString, %rdi       # Put the print pattern in %rdi
        movzbq %dl, %rsi                    # Move the first string length to %rsi
        movzbq %r8b, %rdx                   # Move the second string length to %rdi
        movq $0, %rax                       # reset %rax to 0/
        call printf
        movq $0, %rax
        
        # restore the caller registers
        popq %rdx
        popq %rsi
        popq %rdi
        
        # Finish the operation
        jmp .done
    
    # If the user input case 51 - gets old char and new char and replace every old
    # char in the string with a new char- by call the function replaceChar
    .case_B:
        # Backup the caller registers
        pushq %rdi
        pushq %rsi
        pushq %rdx
        
        # get '\n' to a dummy
        movq $getDummy, %rdi
        movq $0, %rax                       # Reset %rax
        addq $-1, %rsp                      # Allocate 1 bytes for the \n char
        leaq (%rsp), %rsi                   # put the allocate address in %rsi
        call scanf
        addq $1, %rsp                       # free the memory
    
        movq $getChars, %rdi
        movq $0, %rax                       # Reset %rax
        addq $-2, %rsp                      # Allocate 2 bytes for the new char and the old char
        leaq (%rsp), %rsi
        leaq 1(%rsp), %rdx
        call scanf
        
        movzbq (%rsp), %rcx                 # Store the first char in %rcx
        movzbq 1(%rsp), %r8                 # Store the second char in %r8
        addq $2, %rsp                       # Free the allocation memory
        
        # Restore the caller registers for reuse
        pop %rdx
        pop %rsi
        pop %rdi
        
        # Backup the caller registers
        pushq %rdi
        pushq %rsi
        pushq %rdx
        pushq %rsi
        
        # %rdi the string %rsi the first char % rdx the second char
        movq %rcx, %rsi
        movq %r8, %rdx
        
        #Backup the chars
        pushq %rsi
        pushq %rdx
        
        movq $0, %rax                       # Reset %rax
        call replaceChar
        
        # Restore the chars and the second string
        popq %rdx                           # the first char
        popq %rsi                           # the second char
        popq %rdi                           # the second string
        
        # Backup the new string and the first and the second chars
        pushq %rax                          # push the new first string
        pushq %rdx                          # push the second char
        pushq %rsi                          # push the first char
        
        movq $0, %rax                       # Reset %rax
        call replaceChar                    # %rdi the string %rsi the first char % rdx the second char
        
        # insert the prinf arguments
        popq %rsi                           # put the first char
        popq %rdx                           # put the second char
        popq %rcx                           # put the first new string
        leaq 1(%rcx), %rcx                  # move to the first charater string
        leaq 1(%rax), %r8                   # put the second new string and move to the first charater string
        
        movq $printOldNewChar, %rdi         # put the print pattern
        movq $0, %rax                       # Reset %rax
        call printf
        
        # Restore the caller registers
        pop %rdx
        pop %rsi
        pop %rdi
        
        # Finish the operation
        jmp .done
    
     # If the user input case 52 - the case gets from the user index i and index j
     # the case uses the pstrijcpy function to replace the substring str1[i..j] to the substring str2[i..j]
    .case_C:
        # Backup the caller registers
        pushq %rdi
        pushq %rsi
        pushq %rdx
        pushq %rsi
        
        pushq %rsi                          # backup the first string
        pushq %rdi                          # backup the second string
        
        movq $getInts, %rdi
        movq $0, %rax                       # Reset %rax
        addq $-4, %rsp                      # Allocate 4 bytes for the start substring and the end  substring integers
        leaq (%rsp), %rsi                   # put the allocate address in %rsi
        call scanf
        
        movl (%rsp), %ecx                   # put the first number in %rcx
        addq $4, %rsp                       # free the allocation memory    
        pushq %rcx                          # Backup the caller register before scanf
        
        movq $getInts, %rdi
        movq $0, %rax                       # Reset %rax
        addq $-4, %rsp                      # Allocate 4 bytes for the end substring
        leaq (%rsp), %rsi                   # put the allocate address in %rsi
        call scanf
        movl (%rsp), %ecx                   # put the second number in %rcx
        addq $4, %rsp                       # Free the allocation memory
        
        popq %rdx                           # restore the start substring
        movzbq %dl, %rdx                    # put the first number in %rdx
        movzbq %cl, %rcx                    # put the scond number in %rcx
        
        
        movq $0, %rax                       # Reset %rax
        popq %rdi                           # restore the first string
        popq %rsi                           # resotre the second string
        call pstrijcpy                      # %rdi first string %rsi second string %rdx start %rcx end 
        
        pushq %rax                          # backup the string in the stack
        
        movq %rax, %rdi                     # get the length string
        movq $0, %rax                       # Reset %rax
        call pstrlen
        
        
        movq $printSubString, %rdi          # put the print pattern in %rdi
        movq %rax, %rsi                     # put the length string in %rsi
        popq %rdx                           # get the new string from the stack
        leaq 1(%rdx), %rdx                  # move to the first charater (to print the string without the length)
        movq $0, %rax                       # Reset %rax
        call printf
        
        movq $printSubString, %rdi          # put the print pattern in %rdi
        popq %rdx                           # get the second string from the stack
	movq $0, %rsi                       # reset %rsi
        movb (%rdx), %sil                   # put the length string in %rsi
        leaq 1(%rdx), %rdx                  # move to the first charater (to print the string without the length)
        movq $0, %rax                       # Reset %rax
        call printf
        
        # restore the caller registers
        pop %rdx
        pop %rsi
        pop %rdi
        
        # Finish the operation
        jmp .done
        
        
     # If the user input case 53 -  the case gets 2 strings and using the function swapCase 
     # replaces each lower letter with a capital letter, and each capital letter with lower letter.
    .case_D:
        # Backup the caller registers
        pushq %rdi
        pushq %rsi
        pushq %rdx
        
        pushq %rsi                         # backup the second string
        
        movq $0, %rax                      # reset the %rax register to 0
        call swapCase                      # %rdi - the first string
        
        pushq %rax                         # backup the new first stirng
        movq %rax, %rdi                    # put the new string in the first argument function
        movq $0, %rax                      # reset the %rax register to 0
        call pstrlen
        
        
        movq $printSwapCase, %rdi
        movq %rax, %rsi                    # put the length string in %rsi
        popq %rdx                          # put the new string in %rdx
        leaq 1(%rdx), %rdx                 # move to the first character string(to print without the length)
        movq $0, %rax                      # reset the %rax register to 0
        call printf
        
        # restore the second string
        popq %rdi
      
        movq $0, %rdx                      # %rdi - the second string
        call swapCase
        
        pushq %rax                         # backup the new second stirng
        movq %rax, %rdi                    # put the new string in the first argument function
        movq $0, %rax                      # reset the %rax register to 0
        call pstrlen
        
        # print the new string
        movq $printSwapCase, %rdi
        movq %rax, %rsi                    # put the length string in %rsi
        popq %rdx                          # put the new string in %rdx
        leaq 1(%rdx), %rdx                 # move to the first character string(to print without the length)
        movq $0, %rax                      # reset the %rax register to 0
        call printf
        
        # restore the caller registers
        pop %rdx
        pop %rsi
        pop %rdi
        
        # Finish the operation
        jmp .done
     # If the user input case 54 -  the case gets 2 strings and using the function pstrijcmp 
     # compares the strings.
    .case_E:
        # Backup the caller registers
        pushq %rdi
        pushq %rsi
        pushq %rdx
        
        # backup the strings
        pushq %rsi
        pushq %rdi
        
        movq $getInts, %rdi
        movq $0, %rax                       # Reset %rax
        addq $-4, %rsp                      # Allocate 4 bytes for the start substring and the end  substring integers
        leaq (%rsp), %rsi                   # put the allocate address in %rsi
        call scanf        
        movl (%rsp), %ecx                   # put the first number in %rcx
        addq $4, %rsp                       # free the allocation memory
        
        # Backup the caller register before scanf
        pushq %rcx
        
        movq $getInts, %rdi       
        movq $0, %rax                       # Reset %rax 
        addq $-4, %rsp                      # Allocate 4 bytes for the end substring
        leaq (%rsp), %rsi                   # put the allocate address in %rsi
        call scanf
        movl (%rsp), %ecx                   # put the second number in %rcx
        addq $4, %rsp                       # Free the allocation memory
        
        popq %rdx                           # restore the start substring
        movzbq %dl, %rdx                    # put the start substring in %rdx
        movzbq %cl, %rcx                    # put the end substring in %rcx
        
        movq $0, %rax                       # Reset %rax
        popq %rdi                           # get the first string from the stack
        popq %rsi                           # get the first second from the stack
        call pstrijcmp                      # %rdi first string %rsi second string %rdx start %rcx end 
        
        movq $printComprePstring, %rdi      # put the print pattern in %rdi
        movq %rax, %rsi                     # put compare result in %rsi
        movq $0, %rax                       # Reset %rax
        call printf
        
        # restore the caller registers
        pop %rdx
        pop %rsi
        pop %rdi
        
        # Finish the operation
        jmp .done
                             
    # case defualt - a defualt case if the user input option that not between 50-53 print error option.
    .case_def:
        # reset the %rax register to 0
        movq $0, %rax
        movq $invalidOption, %rdi
        call printf
        
        # Finish the operation
        jmp .done
    
    # Finish the operation
    .done:
        ret
