################################################# 
#  
# Author(s): Maria Nunez and Collins Wyatt
#  
# Date: 11/05/2022
# 
# This program draws a number of stars in increasing order.
# The user is asked how many lines he/she wants and the program prints a number 
# of stars in increasing order until it reaches the number of lines introduced 
# and then, it prints the stars in decreasing order until it reaches 0.
# Finally, the program prints the number of stars that has been printed along 
# the program
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
# s5 -> number of stars 
# s6 -> number of stars in drawBottom
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
    bgt $s0, $zero, continueMain
    jal fixNegative
    
continueMain:
    # Draw top
    move $a0, $s0               # Load argument with number of lines
    li $a1, 0                   # Load argument with 0 (current line)
    li $a2, 0                   # Load argument with 0 (numStars in top)
    jal drawTop
    move $s5, $v0               # Save number of stars (drawTop)

    # Draw bottom
    move $a0, $s0               # Load argument with number of lines
    li $a1, 0                   # Load argument with 0 (current line)
    li $a2, 0                   # Load argument with 0 (numStars in bottom)
    jal drawBottom
    move $s6, $v0               # Save number of stars (drawBottom)

    # numStars = numStars(drawTop) + numStars(drawBottom)
    add $s5, $s5, $s6           

    # Print result
    la $a0, totalStars          # Loads message to print
    li $v0, 4                   # Prints message
    syscall

    # Print numStars
    move $a0, $s5               # Move numStars to a0
    li $v0, 1                   # Prints numStars
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
# s2 -> number of stars
# s3 -> control variable for loop (i)
###########################

drawTop:
    move $s0, $a0               # numLines
    move $s1, $a1               # currLine
    move $s2, $a2               # numStars

    beq $s0, $s1, exitDrawTop

    li $s3, 0                   # initialize i
    startLoopTop:
        bgt $s3, $s1, endLoopTop    # condition of while

        # Print asterisk
        la $a0, asterisk            # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        # Increment numStars
        addi $s2, $s2, 1

        # Increment i
        addi $s3, $s3, 1

        j startLoopTop

    endLoopTop:
        # New line
        la $a0, newline             # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        move $a0, $s0               # Load argument with numbLines
        addi $a1, $s1, 1            # Load argument with currLine + 1
        move $a2, $s2               # Load argument with numStars
        j drawTop

    exitDrawTop:
        # Return
        move $v0, $s2
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
# s2 -> number of stars
# s3 -> control variable for loop (i)
# s4 -> numLines - currLine
###########################

drawBottom:
    move $s0, $a0               # numLines
    move $s1, $a1               # currLine
    move $s2, $a2               # numStars

    beq $s0, $s1, exitDrawBottom

    li $s3, 0
    startLoopBottom:
        sub $s4, $s0, $s1
        bgt $s3, $s4, endLoopBottom     # condition of while
        beq $s3, $s4, endLoopBottom     # condition of while

        # Print asterisk
        la $a0, asterisk                # Loads message to print
        li $v0, 4                       # Prints message
        syscall

        # Increment numStars
        addi $s2, $s2, 1

        # Increment i
        addi $s3, $s3, 1

        j startLoopBottom

    endLoopBottom:
        # New line
        la $a0, newline             # Loads message to print
        li $v0, 4                   # Prints message
        syscall

        move $a0, $s0               # Load argument with numbLines
        addi $a1, $s1, 1            # Load argument with currLine + 1
        move $a2, $s2               # Load argument with numStars
        j drawBottom

    exitDrawBottom:
        # Return
        move $v0, $s2
        jr $ra

exit:
    li $v0, 10                   # Exit
    syscall
