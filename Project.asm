.data  
myFile: .asciiz "D:\\BZU All years\\Fourth Year 2021-2022\\Second Semester\\COMPUTER ARCHITECTURE (ENCS4370)\\PROJECT1\\input.txt"      # filename for input
buffer: .space 1024

strMenuHr: .asciiz " \n"
inputMatrix: .asciiz "The input matrix is read from a file called input.txt \n"
reqLevel: .asciiz "Enter required level \n"
compAvg:  .ascii "Please enter 1 for chosing Arithmetic mean OR 2 for chosing Median\n"

.text

menuOptsScr:
		li $v0, 4
		la $a0, strMenuHr
		syscall

		li $v0, 4
		la $a0, inputMatrix
		syscall
		# read the input matrix file
		JAL readFile
		
		li $v0, 4
		la $a0, reqLevel
		syscall
		JAL readRequiredLevel
		
		li $v0, 4
		la $a0, compAvg
		syscall
		JAL readCompAvg
		
		li $v0, 10      # Finish the Program
		syscall

# read File function
readFile:
# Open file for reading
	li   $v0, 13          # system call for open file
	la   $a0, myFile      # input file name
	li   $a1, 0           # flag for reading
	li   $a2, 0           # mode is ignored
	syscall               # open a file 
	move $s0, $v0         # save the file descriptor  


# reading from file just opened
	li   $v0, 14        # system call for reading from file
	move $a0, $s0       # file descriptor 
	la   $a1, buffer    # address of buffer from which to read
	li   $a2,  1024       # hardcoded buffer length
	syscall             # read from file


# Printing File Content
	li  $v0, 4          # system Call for PRINT STRING
	la  $a0, buffer     # buffer contains the values
	syscall             # print int


# Close the file 
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file
	jr $ra

readRequiredLevel:
	li $v0, 5 	# Read integer
	syscall 	# $v0 = value read
	# to be deleted
	move $a0, $v0	# $a0 = value to print
	li $v0, 1 	# Print integer
	syscall

	jr $ra
	
readCompAvg:
	# CHECK IF USER ENTERS  1 or 0
	li $v0, 5 	# Read integer
	syscall 	# $v0 = value read
	# to be deleted
	move $a0, $v0	# $a0 = value to print
	li $v0, 1 	# Print integer
	syscall

	jr $ra
	
	
	