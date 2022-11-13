################################################# 
#  
# Author(s): Maria Nunez and Collins Wyatt
#  
# Date: 11/05/2022
# 
# 
# 
################################################ 

#------- Data Segment ----------
.data

# Newline
newline:   .asciiz "\n"

# space character
space:     .asciiz " "

# *
asterisk:  .asciiz "*"

# Prompt for entering number of lines
numberLines:  .asciiz "Enter the number of lines: "

# Result message
totalStars:  .asciiz "Total Stars: "


#------- Text Segment ----------
.text
.globl main


###########################
# Main routine
#
# Register Legend:
# a0 -> arguments for routines and syscalls
# v0 -> syscall numbers
# s0 -> number of lines
# s1 -> number of stars
# s2 -> return from drawBottom
###########################

main:

    # Prompt number of rows
    la $a0, numberLines         # Loads message to print
    li $v0, 4                   # Prints message
    syscall

    # Read Integer
    li $v0, 5                   # Reads integer
    syscall
    move $s0, $v0               # Save number of lines

    # Check if negative
    # Have to be fixed, we need a jal
    bge $s0, $zero, endIf
    move $a0, $s0 # s0 is argument for fixNegative
    jal fixNegative
    move $s0, $v0 # set s0 to return value.
    endIf:

    # Draw top
    move $a0, $s0               # Load argument with number of lines
    li $a1, 0                   # Load argument with 0
    jal drawTop
    move $s1, $v0               # Save number of stars

    # Draw bottom
    move $a0, $s0               # Load argument with number of lines
    li $a1, 0                   # Load argument with 0
    jal drawBottom
    move $s2, $v0               # Save drawBottom

    add $s1, $s1, $s2           # numStars = numStars + drawBottom

    # Print result
    la $a0, totalStars          # Loads message to print
    li $v0, 4                   # Prints message
    syscall

    # Print numStars
    move $a0, $s1               # Move numStars to a0
    li $v0, 1                   # Prints numStars
    syscall

    j exit

###########################
# Fix negative
#
# Register Legend:
# a0 -> number of lines
# s0 -> -1 for fixing negative
###########################

fixNegative:
    addi $sp, -4
    sw $sp, 0($sp)
    
    lw $s0, 0($sp)
    mul $v0, $s0, $s3
    jr $ra

    lw $sp, 0($sp)
    addi $sp, 4


###########################
# Draw Bottom
#
# Register Legend:
# a0 -> argument for numLines (later overridden by syscall arguments)
# a1 -> argument for currLine (later overridden with a1+1)
# s0 -> number of lines (saved from a0)
# s1 -> current line (saved from a1)
# s2 -> control variable for loop (i)
# v0 -> syscall numbers
###########################

drawTop:
    addi $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    # saving a0, a1 to s0, s1.
    # a0 especially conflicts with syscalls, so instead of
    # saving/restoring from memory, it makes sense to just move it to an s register.
    move $s0, $a0
    move $s1, $a1

    beq $s0, $s1, baseCaseTop
    li $s2, 0 # control variable i = 0
    loopTop:
        bgt $s2, $s1, endLoopTop
        
        # Print asterisk
        la $a0, asterisk            # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        # Increment i
        addi $s2, $s2, 1

        j loopTop
    baseCaseTop:
        li $v0, 0
        j restoreEndTop
    endLoopTop:
        # New line
        la $a0, newline             # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        move $a0, $s0               # Load argument with numbLines
        addi $a1, $s1, 1            # Load argument with currLine + 1

        # preserve $ra, call drawTop recursively.
        addi $sp, -4
        sw $ra, 0($sp)
        jal drawTop
        lw $ra, 0($sp)
        addi $sp, 4
        # return value ($v0) is i ($s2) plus return from call ($v0)
        add $v0, $s2, $v0
        # fall through to restoreEndTop
    restoreEndTop:
        lw $s2, 8($sp)
        lw $s1, 4($sp)
        lw $s0, 0($sp)
        addi $sp, 16
        jr $ra

###########################
# Draw Bottom
#
# The difference between draw bottom and draw top is the condition
# for ending branching on the loop. We add a register s3 which s2 is compared to.
# Register Legend:
# a0 -> argument for numLines (later overridden by syscall arguments)
# a1 -> argument for currLine (later overridden with a1+1)
# s0 -> number of lines (saved from a0)
# s1 -> current line (saved from a1)
# s2 -> control variable for loop (i)
# s3 -> numLines - currLine
# v0 -> syscall numbers
###########################

drawBottom:
    addi $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    # saving a0, a1 to s0, s1.
    # a0 especially conflicts with syscalls, so instead of
    # saving/restoring from memory, it makes sense to just move it to an s register.
    move $s0, $a0
    move $s1, $a1

    beq $s0, $s1, baseCaseBottom
    li $s2, 0 # control variable i = 0
    sub $s3, $s0, $s1 # s3 = numLines - currLine
    loopBottom:
        bge $s2, $s3, endLoopBottom
        
        # Print asterisk
        la $a0, asterisk            # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        # Increment i
        addi $s2, $s2, 1

        j loopBottom
    baseCaseBottom:
        li $v0, 0
        j restoreEndBottom
    endLoopBottom:
        # New line
        la $a0, newline             # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        move $a0, $s0               # Load argument with numbLines
        addi $a1, $s1, 1            # Load argument with currLine + 1

        # preserve $ra, call drawBottom recursively.
        addi $sp, -4
        sw $ra, 0($sp)
        jal drawBottom
        lw $ra, 0($sp)
        addi $sp, 4
        # return value ($v0) is i ($s2) plus return from call ($v0)
        add $v0, $s2, $v0
        # fall through to restoreEndBottom
    restoreEndBottom:
        lw $s3, 12($sp)
        lw $s2, 8($sp)
        lw $s1, 4($sp)
        lw $s0, 0($sp)
        addi $sp, 16
        jr $ra

exit:
    li $v0, 10                   # Exit
    syscall
