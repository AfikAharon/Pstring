    .data
    .section    .rodata
    
invalidInput: .string "invalid input!\n"


    .text
   
# pstrlen - The function gets pstring in return its length. 
.globl pstrlen
    .type   pstrlen,  @function
pstrlen:
    movb (%rdi), %al
    ret
   
# replaceChar - the function gets 3 parameter: address op Pstring, old char and new char
# replace every old char in the pstring with a new char.
.globl replaceChar
    .type   replaceChar,  @function
replaceChar:
    pushq %r12                          # backup the callee register
    pushq %r13                          # backup the callee register
    
    movq %rdi, %rax                     # Put the string in the return value
    movq $0, %r12                       # set the counter to zero
    movq $0, %r13                       # reset %r13 to zero
    movb (%rdi), %r13b                  # set the size of the string in $r13 register
    
    # start the loop
    .while:
        incq %rdi                       # move to the next character
        cmpq %r13, %r12
        jg .endLoop                     # check if the counter big than string size
        cmpb %sil, (%rdi)
        je .replaceC                    # check if %rdi point to old char
        incq %r12                       # increase the counter by 1
        jmp .while                      # continue the loop
    
    # replace every old char with a new char.
    .replaceC:
        movb %dl, (%rdi)
        incq %r12                       # increase the counter by 1
        jmp .while
     # end th loop
    
    .endLoop:
        # restore the calle registers
        popq %r13
        popq %r12
        ret

# pstrijcpy gets 2 indexes and 2 address of Pstring and replace the substring pstring1[i,j]  
# with pstring2[i,j].   
# if the index cross the array bounds the function will print an error.
.globl pstrijcpy
    .type   pstrijcpy,  @function
pstrijcpy:
    # %rdi first string %rsi second string %rdx start %rcx end
    pushq %r12                          # backup the callee register
    pushq %r13                          # backup the callee register
    
    movq $0, %r12                       # reset %r12 %r13  to zero
    movq $0, %r13
    
    movq %rdi, %rax                     # Put the string in the return value
    movb (%rdi), %r12b                  # set the size of the first string in $r12 register 
    movb (%rsi), %r13b                  # set the size of the second string in $r13 register
    cmpb %cl, %r12b
    jle  .crossingLimite                # jump if the first string size smaller than end string input
    cmpb %cl, %r13b
    jle  .crossingLimite                # jump if the second string size smaller than end string input
    cmpb $0, %dl
    jb  .crossingLimite                 # jump if the start index less than 0
    cmpb $0, %cl
    jl  .crossingLimite			# jump if the end index less than 0
    cmpb %dl, %cl
    jl  .crossingLimite			# jump if the end index less than the start index
    
    movq $0, %r12                       # set the cunter to zero
    incq %rdi                           # move to the first character in the first string
    incq %rsi                           # move to the first character in the second string
    # the loop set the pointer to point to the start index in the 2 strings
    .loop:
        cmpq %r12, %rdx                 # check if %rdi and %rsi point to the correct index
        je .changeSubStringLoop
        incq %rdi                       # move to the next character in first string
        incq %rsi                       # move to the next character in the second string
        incq %r12                       # increase the counter by 1
        jmp .loop
    # the loop replace every character in str1[i,j] with str2[i,j]
    .changeSubStringLoop:
        cmpq %rdx, %rcx
        jb .endChangeSubStringLoop      # check if the start index big than the end index
        movb (%rsi), %r13b              # save the the second string char in %r12
        movb %r13b, (%rdi)              # replace the character in the first string
        incq %rdx                       # increase the start index by 1
        incq %rdi                       # increase to the next character (first string)
        incq %rsi                       # increase to the next character (second string)
        jmp .changeSubStringLoop        # continue the loop
        
    .endChangeSubStringLoop:
        # restore the calle registers
        popq %r13
        popq %r12
        ret
      # if the index input crossing the size string
     .crossingLimite:
        pushq %rax                      # backup the return value
        movq $0, %rax                   # reset %rax to 0
        movq $invalidInput, %rdi
        call printf                     # print the error message
        popq %rax                       # restore the return value
        
        # restore the calle registers
        popq %r13
        popq %r12
        ret

# swapCase - gets one paramter a psting and replace every lowercase letter to capital letter
# and capital letter with a lowercase letter.
# if the character is not a letter the function not change the character.
.globl swapCase
    .type   swapCase,  @function
swapCase: 
    pushq %r12                          # backup the callee register
    pushq %r13                          # backup the callee register
    pushq %r14                          # backup the callee register
    
    movq %rdi, %rax                     # backup the return string
    movq $0, %r12                       # setup the counter to 0
    movq $0, %r13                       # reset %r13 to 0
    movb (%rdi), %r13b                  # store the string size in %r13
    incq %rdi                           # move to the first charcter in the given string
    
    .swapCaseLoop:
        cmpq %r12, %r13
        jbe .endSwapCaseLoop            # check if the counter big than the string size 
        
        movb (%rdi), %r14b              # store the character ascii value.
        cmpb $65, %r14b  
        jl .noChange                    # check if the character ascii value smaller than 65
        cmpb $90, %r14b 
        jle .swapFromCapitalLetter      # check if the character ascii value smaller than 90
        
        cmpb $122, %r14b  
        jg .noChange                    # check if the character ascii value bigger than 65
        cmpb $97, %r14b 
        jl .noChange                    # check if the character ascii value between (90-97)
        
        jmp .swapToCapitalLetter
     
     # swap from lowercase letter to capital letter   
    .swapToCapitalLetter:
        addb $-32, (%rdi)
        incq %r12                       # increase the counter
        incq %rdi                       # move to the next character
        jmp .swapCaseLoop               # continue the loop
     # swap from capital letter to lowercase letter. 
    .swapFromCapitalLetter:
        addb $32, (%rdi)
        incq %r12                       # increase the counter
        incq %rdi                       # move to the next character
        jmp .swapCaseLoop               # continue the loop
     # if the character not a letter skip the character. 
     .noChange:
        incq %r12                       # increase the counter
        incq %rdi                       # move to the next character
        jmp .swapCaseLoop               # continue the loop
        
     # end the loop
     .endSwapCaseLoop:
        # restore the callee registers
        popq %r14
        popq %r13
        popq %r12
        ret
        
# pstrijcmp - the function gets 2 pstrings and 2 index i,j and compare by lexicographic 
# order the substrings str1[i,j] with str2[i,j].
# if the index cross the array bounds the function will print an error.    
.globl pstrijcmp
    .type   pstrijcmp,  @function
pstrijcmp:
    # %rdi first string %rsi second string %rdx start %rcx end
    pushq %r12                          # backup the callee register
    pushq %r13                          # backup the callee register
    movq $0, %r12                       # reset %r12 %r13  to zero
    movq $0, %r13
    
    movb (%rdi), %r12b                  # set the size of the first string in $r12 register 
    movb (%rsi), %r13b                  # set the size of the second string in $r13 register
    cmpb %cl, %r12b
    jle  .crossingLimite2               # jump if the first string size smaller than end string input
    cmpb %cl, %r13b
    jle  .crossingLimite2               # jump if the second string size smaller than end string input
    cmpb $0, %dl
    jl   .crossingLimite2               # jump if the start index less than 0
    cmpb $0, %cl
    jl   .crossingLimite2		# jump if the end index less than 0
    cmpb %dl, %cl
    jl   .crossingLimite2	        # jump if the end index less than the start index


    movq $0, %r12                       # set the cunter to zero
    incq %rdi                           # move to the first character in the first string
    incq %rsi                           # move to the first character in the second string
    # the loop set the pointer to point to the start index in the 2 strings
    .pstrijcmpLoop:
        cmpq %r12, %rdx
        je .compareCharacterLoop
        incq %rdi                       # move to the next character in first string
        incq %rsi                       # move to the next character in the second string
        incq %r12                       # increase the counter by 1
        jmp .pstrijcmpLoop
    
    .compareCharacterLoop:
        cmpq %rcx, %rdx
        jg .equal                       # check if the start index big than the end index and if the loop finish the strings equals.
        movb (%rdi), %r12b              # save the first string char in %r12
        movb (%rsi), %r13b              # save the second string char in %r13
        cmpb %r13b, %r12b               # compare the characters
        ja .bigeer
        jb .smaller
        incq %rdi                       # move to the next first string character
        incq %rsi                       # move to the next second string character
        incq %rdx                       # increase the start index by 1
        jmp .compareCharacterLoop       # continue the loop
        
      # if the first string bigger than the second string return 1  
     .bigeer:
        # restore the calle registers
        popq %r13
        popq %r12
        movq $1, %rax # the substring equals
        ret
     
      # if the first string smaller than the second string return -1   
     .smaller:
        # restore the calle registers
        popq %r13
        popq %r12
        movq $-1, %rax # the substring equals
        ret
      
     # if the 2 string equals retun 0  
     .equal:
        # restore the calle registers
        popq %r13
        popq %r12
        movq $0, %rax # the substring equals
        ret
        
     # if the index cross the array bounds the function will print an error and return -2.
     .crossingLimite2:
        # reset %rax to 0
        movq $0, %rax
        movq $invalidInput, %rdi
        call printf
        movq $-2, %rax
        
        # restore the calle registers
        popq %r13
        popq %r12
        ret
 
