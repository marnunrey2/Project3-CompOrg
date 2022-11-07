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
    blt $s0, $zero, fixNegative
    
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
    li $v0, 4                   # Prints numStars
    syscall

    j exit

###########################
# Fix negative
#
# Register Legend:
# s0 -> number of lines
# s3 -> -1 for fixing negative
###########################

fixNegative:
    li $s3, -1
    mul $s0, $s0, $s3


###########################
# Draw Top
#
# Register Legend:
# a0 -> arguments for numLines
# a1 -> arguments for currLine
# v0 -> syscall numbers
# s0 -> number of lines
# s1 -> current line
# s4 -> control variable for loop (i)
###########################

drawTop:
    move $s0, $a0               # numLines
    move $s1, $a1               # currLine

    beq $s0, $s1, exitDrawTop

    li $s4, 0
    startLoopTop:
        bgt $s4, $s1, endLoopTop    # condition of while

        # Print asterisk
        la $a0, asterisk            # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        # Increment i
        addi $s4, $s4, 1

        j startLoopTop

    endLoopTop:
        # New line
        la $a0, newline             # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        move $a0, $s0               # Load argument with numbLines
        addi $a1, $s1, 1            # Load argument with currLine + 1
        j drawTop

    exitDrawTop:
        # Return
        li $v0, 0
        jr $ra


###########################
# Draw Top
#
# Register Legend:
# a0 -> arguments for numLines
# a1 -> arguments for currLine
# v0 -> syscall numbers
# s0 -> number of lines
# s1 -> current line
# s4 -> control variable for loop (i)
# s5 -> numLines - currLine
###########################

drawBottom:
    move $s0, $a0               # numLines
    move $s1, $a1               # currLine

    beq $s0, $s1, exitDrawBottom

    li $s4, 0
    startLoopBottom:
        sub $s5, $s0, $s1
        bgt $s4, $s5, endLoopBottom # condition of while
        beq $s4, $s5, endLoopBottom # condition of while

        # Print asterisk
        la $a0, asterisk            # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        # Increment i
        addi $s4, $s4, 1

        j startLoopBottom

    endLoopBottom:
        # New line
        la $a0, newline             # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        move $a0, $s0               # Load argument with numbLines
        addi $a1, $s1, 1            # Load argument with currLine + 1
        j drawBottom

    exitDrawBottom:
        # Return
        li $v0, 0
        jr $ra

exit:
    li $v0, 10                   # Exit
    syscall
