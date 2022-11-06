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
# s3 -> -1 for fixing negative
# s4 -> control variable for loop (i)
###########################

main:

    # Prompt number of rows
    la $a0, numberRows          # Loads message to print
    li $v0, 4                   # Prints message
    syscall

    # Read Integer
    li $v0, 5                   # Reads integer
    syscall
    move $s0, $v0               # Save number of lines

    # Check if negative
    # Have to be fixed, we need a jal
    blt $s0, $zero, fixNegative
    
    # Draw top
    move $a0, $s0               # Load argument with number of lines
    move $a1, $zero             # Load argument with 0
    jal drawTop
    move $s1, $v0               # Save number of stars

    # Draw bottom
    move $a0, $s0               # Load argument with number of lines
    move $a1, $zero             # Load argument with 0
    jal drawBottom
    move $s2, $v0               # Save drawBottom

    add $s1, $s1, $s2           # numStars = numStars + drawBottom

    # Print result
    la $a0, totalStars          # Loads message to print
    li $v0, 0x4                 # Prints message
    syscall

    # Print numStars
    move $a0, $s1               # Move numStars to a0
    li $v0, 4                   # Prints numStars
    syscall

    j exit

fixNegative:
    li $s3, -1
    mul $s0, $s0, $s3


drawTop:
    # save $s0, $s1
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)

    move $s0, $a0               # numLines
    move $s1, $a1               # currLine

    beq $s0, $s1, stopDrawTop

    li $s4, 0
    startLoop:
        bgt $s4, $s1, endLoop       # condition of while

        # Print asterisk
        la $a0, asterisk            # Loads message to print
        li $v0, 0x4                 # Prints message
        syscall

        # Increment i
        addi $s4, $s4, 1

        j startLoop

    endLoop:
        # restore $s0, $s1
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        addi $sp, $sp, 8

        # Draw top
        move $a0, $s0               # Load argument with numLines
        addi $a1, $s1, 1            # Load argument with currLine+1
        jal drawTop
        move $s1, $v0               # Save number of stars

        add $v0, $s4, $s1
        j exitDrawTop

    stopDrawTop:
        li $v0, 0

    exitDrawTop:
        # Return
        jr $ra


drawBottom:


exit:

