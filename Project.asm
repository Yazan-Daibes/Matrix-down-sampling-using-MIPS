# Done by:
# 1180414 - Yazan Daibes
# 1182972 - Abdallah Afifi
.data  
# Change the directory of the input and output file depending on your files locations
myFile:					.asciiz "D:\\BZU All years\\Fourth Year 2021-2022\\Second Semester\\COMPUTER ARCHITECTURE (ENCS4370)\\PROJECT1\\Final\\test2.txt"      # filename for input
fout:					.asciiz "D:\\BZU All years\\Fourth Year 2021-2022\\Second Semester\\COMPUTER ARCHITECTURE (ENCS4370)\\PROJECT1\\Final\\output.txt"
#myFile:				.asciiz "input.txt"
#fout:					.asciiz "output.txt"
newLine: 				.asciiz "\n"
newTab:					.asciiz "\t"
inputMatrix: 				.asciiz "The input matrix is read from a file called input.txt \n"
reqLevel: 				.asciiz "Enter required level \n"
compAvg:  				.asciiz "Please enter 1 for chosing Arithmetic mean OR 2 for chosing Median\n"
compAvgError: 				.asciiz "Error: entered integer is not 1 or 2\n"
meanPrint: 				.asciiz "Mean:  \n"
medianPrint:				.asciiz "Median: \n"
rowsMsg:				.asciiz "Number of rows in the input matrix = "
colsMsg:				.asciiz "Number of columns in the input matrix = "
errorNAN:				.asciiz "ERROR: The Input contains a character that is not a number or the file path is incorrect"
levelStr:				.asciiz "Current Level = " #17 bytes long
errorLastLevel:				.asciiz "Error: Can Not Continue Any Further, we can't compute Level: "
errorMatrixSize:		.asciiz "Error: the size of the matrix is not divided by the required level entered!\n"
sperater:				.asciiz "\n=============================================\n"
decimalPointtoPrint:			.asciiz "."
buffer: 				.space 4096 #used for reading from the file
line: 					.space 50
numRows: 				.word 0	    #declare variable to print the output
numCols:				.word 0
CurrentNumRows:				.word 0     #used in the mean and median calculations
CurrentNumCols:				.word 0     #used in the mean and median calculations
isEven:					.byte 0
level:					.word 0
operation:				.word 0
Window0p5: 				.float 1.5 
Window1p5:				.float 0.5
divby4:					.float 4.0
cmprFloat1:				.float 1.0
cmprFloat2:				.float 2.0
divBy2:					.float 2.0
tempConvertToInt: 			.word 0
byteToPrint:				.byte 0

#numbers to be stored in floating point registers
ten:					.float 10
fourtyEight:				.float 48
zero:					.float 0
#2D matrix will be saved in $s5
.text
main:
    li $v0, 4
    la $a0, newLine
    syscall

    li $v0, 4
    la $a0, inputMatrix
    syscall
    JAL readFile            #read the input matrix file
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    li $v0, 4
    la $a0, reqLevel
    syscall
    JAL readRequiredLevel   #read how many levels we are going to process

    
    JAL readCompAvg         #check to see if we want to calculate it using median or mean
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    li $v0, 4
    la $a0, rowsMsg
    syscall
    
    lw   $v0, numRows       #store the return value from the loop in testOutput
    move 	$a0,$v0         #print output (#of lines)
    li 	$v0,1		
    syscall
    
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    li $v0, 4
    la $a0, colsMsg
    syscall
    
    lw   $v0, numCols  		#store the return value from the loop in testOutput
    move 	$a0,$v0	        #print output (#of lines)
    li 	$v0,1		
    syscall
		
#read File function
readFile:
    #Open file for reading
	li   $v0, 13            #system call for open file
	la   $a0, myFile        #input file name
	li   $a1, 0             #flag for reading
	li   $a2, 0             #mode is ignored
	syscall                 #open a file 
	move $s0, $v0           #save the file descriptor  


    #reading from file just opened
	li   $v0, 14		    #system call for reading from file
	move $a0, $s0		    #file descriptor 
	la   $a1, buffer	    #address of buffer from which to read
	li   $a2,  4096		    #hardcoded buffer length
	syscall			        #read from file
	blez $v0,error          #exit in case there was an error reading from the file

    #Calculating #of rows and #of columns
    la 	$s0, buffer 	    #load the buffer
   	addi 	$s2, $zero, 1   #set s2 value to 1 (incremental row value)
    addi 	$s3, $zero, 1   #set s3 value to 1 (incremental col value)
    addi 	$s4, $zero, 0   #set s4 value to 0 (col condition value) 
    	
    NumOfRowsAndCols:
    	lb $s1, 0($s0)			        #Load the character by characetr
    	beqz $s1, exit			        #If s1 value is 0 then call exit system function
    	addi $s0, $s0, 1 		        #Increment the system call
		beq $s1, '\n', updateRow	    #If \n characer occurs call updateRow
		beq $s1, ' ', updateCol		    #If space occurs call updateCol
    	j NumOfRowsAndCols		        #call NumOfLines function
    		
    updateRow:			
		addi $s2, $s2, 1		        #Increment the rows count
		addi $s4,$s4,  1	 	        #set $s4 to 1
		j NumOfRowsAndCols		        #call loop
		
    updateCol:
		bge $s4, 1, NumOfRowsAndCols	#increment#of cols only once
		addi $s3, $s3, 1		        #Increment the cols count
		j NumOfRowsAndCols		        #call NumOfLines
	
    exit: 				
		move $v0,$s2          		    #move value of register in $v0
    	sw   $v0, numRows  		        #store the return value from the loop in testOutput
    	sw   $v0,CurrentNumRows
		move $v0,$s3          		    #move value of register $s3 to $v0
    	sw   $v0, numCols  		        #store the return value from the NumOfLines in numCols
    	sw   $v0,CurrentNumCols
    		
        li $v0, 4
		la $a0, rowsMsg
		syscall
		
		lw   $v0, numRows  		        #store the return value from the loop in testOutput
    	move 	$a0,$v0	         	    #print output (#of lines)
    	li 	$v0,1		
    	syscall
		
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		li $v0, 4
		la $a0, colsMsg
		syscall
		
		lw   $v0, numCols  		        #store the return value from the loop in testOutput
    	move 	$a0,$v0	         	    #print output (#of lines)
    	li 	$v0,1		
    	syscall
    		
    	li $v0, 4
		la $a0, newLine
		syscall
    ###########################################################################################
    ###__   |  	|	_	_	__	_____	___	_    	__		###
    ###|__|  |      |     /	 \    /        |__|       |	 |     | \  |  |  _		###
    ###|  |  |___   |___  \__/    \__      |  |       |     _|_    |  \_|  |__|		###
    ###											###
    ### __  ___    ____      ____   ______							###
    ###/    |   \  |    |   /       | 			|				###
    ###\___ |___/  |____|  /        |______			|				###
    ###   \|      |    |  \        |			|				###
    ###___/|      |    |   \_____	|______			*				###
    ###########################################################################################
    #allocating space for the array knowing that they are floating point numbers
    AllocateSpace:
	 	lw  $t1,numRows #number of rows
		lw  $t2,numCols #number of columns
		mul $a0, $t1, $t2
		sll $a0, $a0, 3 #multiply number of elements by 2^3 = 8
        #because each double precision floating point number takes 8 bytes
		li  $v0, 9
		syscall
		move $s5,$v0    #save array address in $s5

    #saving the numbers to the allocated array    	
    SaveArray:
		la $t0,buffer 	#store the address of the buffer
		li $t1,0		#store the number of rows
		li $t2,0		#store the number of columns
		li $t4,0	    #set $t4 to 0 where it will store each number | 2 registers are needed
		li $t5,0	    #set $t5 to 0 where it will store each number | as we are reading FP
		li $t8,10	    #in order to multiply by 10 later
		li $t9,10	    #in order to divide by 10 later
		li $s1,0	    #FLAG Used to tell if we are doing FPR operations or normal addition
		sw $zero,-88($fp) 
		lwc1 $f6,-88($fp)
		cvt.s.w $f4,$f6	

    #storing the content of the array
    StoringLoop:
		lb $t3,0($t0)	    #load the characters one by one
		beq $t3,' ',nextCol
		beq $t3,10,nextRow  #\n is 10 then 13 so save when we encounter 10
		beq $t3,13,nextRow  #\n is 13 then 10 then increment line when we encounter 13
		beq $t3,$zero,finishedReading
		beq $t3,'.',calculateDecimal
		blt $t3,'0', error
		bgt $t3,'9', error
		addiu $t3,$t3,-48 	#convert from ascii to int

		#check if we are using fpr
		beq $s1,1,processDecimal
		mul $t4,$t4,$t8		#mult by 10
		addu $t4,$t4,$t3	#add the number 
		addiu $t0,$t0,1		#increment pointer in buffer
		j StoringLoop

    #in case an error occurs at any point in reading the file
    error:
		li  $v0, 4          #system Call for PRINT STRING
		la  $a0, errorNAN   
		syscall  
		li $v0,10	        #exit program
		syscall	

    #processing after reading a " "
    nextCol:
		#check if we are using fpr
		beq $s1,1,saveDecimal

		#setting registers up
		move $t7,$s5	    #load array  addres into t
		lw $t6,numCols      #we will store the address in $t6

		#getting the address			
		mulu $t6,$t6,$t1    #find the row*num of columns
		addu $t6,$t6,$t2    #add the column we want to access
		sll $t6,$t6,3       #shift left by 3 since data size is 8 bytes
		
        #Storing the word
		addu $t7,$t7,$t6	#point to the correct index
		sw $t4,-88($fp)     #converting to float
		lwc1 $f6,-88($fp)
		cvt.s.w $f0,$f6	    #store the current num in f0
		s.s $f0,($t7)	    #store the word
		mtc1 $zero,$f0
		mtc1 $zero,$f1
		mtc1 $zero,$f2

		#now we need to increment number of columns and reset registers
		#finishing up
		addiu $t2,$t2,1		#increase number of columns
		addiu $t0,$t0,1		#increment pointer
		li $t4,0
		j StoringLoop

    #processing after reading a "\n"
    nextRow:
		#check if we are using fpr
		beq $s1,1,saveDecimalRow	

		#setting registers up
		move $t7,$s5	    #load array  addres into t
		lw $t6,numCols      #we will store the address in $t6

		#getting the address			
		mulu $t6,$t6,$t1    #find the row*num of columns
		addu $t6,$t6,$t2    #add the column we want to access
		sll $t6,$t6,3       #shift left by 3 since data size is 8 bytes

		#Storing the word
		addu $t7,$t7,$t6	#point to the correct index

		#converting to float
		sw $t4,-88($fp)
		lwc1 $f6,-88($fp)
		cvt.s.w $f0,$f6	    #store the current num in f0
		s.s $f0,($t7)	    #store the word
		mtc1 $zero,$f0
		mtc1 $zero,$f1
		mtc1 $zero,$f2

		#now we need to increment number of columns and reset registers
		#finishing up
		addiu $t0,$t0,1		#increment pointer
		li $t4,0            #reset the register that holds the value (temporarily, before storing it or changing back to float)
		li $t2,0		    #reset the number of columns
		addiu $t0,$t0,1 	#increment pointer by 1 since \n is 13 then 10 but they are read as a single byte (at least it seems so)
		addiu $t1,$t1,1 	#increment number of rows by 1
		j StoringLoop 

    #if we encountered a ".", set the value in $s1 to 1 (acts as a flag to process a floating point input)
    calculateDecimal:
		li $s1,1            #setting the flag 
		addiu $t0,$t0,1
		j StoringLoop

    processDecimal:
        #Storing and converting an int into a float
        #first, check if we were using the $fn registers so we won't load
        #the integer value every time
		c.eq.s $f0,$f4
		bc1f alreadyLoadedFloat	
		sw $t4,-88($fp)
		lwc1 $f6,-88($fp)
		cvt.s.w $f0,$f6	    #store the current num in f0

    #so we already converted $f4 from int to float, so now continue processing with
    alreadyLoadedFloat:
		sw $t9,-88($fp)	    #multiple of 10 in order to divide by 10,100,100...etc correctly
		lwc1 $f6,-88($fp)
		cvt.s.w $f1,$f6	    #move multiple of 10 to f1 for division
		sw $t3,-88($fp)	    #last number we read as int
		lwc1 $f6,-88($fp)
		cvt.s.w $f2,$f6	    #store the current number in f2
		mulu $t9,$t9,$t8	#mul by 10 for next time to divide by a lower decimal value
		div.s $f2,$f2,$f1	#div last number read by 10 and set result in f2
		add.s  $f0,$f0,$f2	#add the number to previous number
		li $t4,0	        #reset $t4
		addiu $t0,$t0,1		#increment pointer
		j StoringLoop

    #ending the reading once finding a 0 (EOF)
    finishedReading:	
		#check if we are using fpr
		beq $s1,1,saveLastDecimal

		#save last integer before continuing
		#setting registers up
		move $t7,$s5	    #load array  addres into t
		lw $t6,numCols      #we will store the address in $t6

		#getting the address			
		mulu $t6,$t6,$t1    #find the row*num of columns
		addu $t6,$t6,$t2    #add the column we want to access
		sll $t6,$t6,3       #shift left by 3 since data size is 8 bytes

		#Storing the word
		addu $t7,$t7,$t6	#point to the correct index

		#converting to float
		sw $t4,-88($fp)
		lwc1 $f6,-88($fp)
		cvt.s.w $f0,$f6	    #store the current num in f0
		s.s $f0,($t7)	    #store the word
		mtc1 $zero,$f0
		mtc1 $zero,$f1
		mtc1 $zero,$f2
		
		li $t4,0
		li $t2,0		    #reset the number of columns

		#Close the file 
		li   $v0, 16        #system call for close file
		move $a0, $s6       #file descriptor to close
		syscall             #close file
		jr $ra              #return to main function

    #save the number that we read and it appeared to be a float
    #this function is called when we find a " " and we are in floating point mode ($s3 = 1)
    saveDecimal:
		#setting registers up
		move $t7,$s5	    #load array  addres into t
		lw $t6,numCols      #we will store the address in $t6

		#getting the address			
		mulu $t6,$t6,$t1    #find the row*num of columns
		addu $t6,$t6,$t2    #add the column we want to access
		sll $t6,$t6,3       #shift left by 3 since data size is 8 bytes

		#Storing the word
		addu $t7,$t7,$t6	#point to the correct index
		s.s $f0,($t7)	    #store the word

		#now we need to increment number of columns and reset registers
		#finishing up
		addiu $t2,$t2,1		#increase number of columns
		addiu $t0,$t0,1		#increment pointer
		li $t4,0
		mtc1 $zero,$f0      #resetting the floating point registers for further use later
		mtc1 $zero,$f1
		mtc1 $zero,$f2
		li $t9,10		    #reset t9 to 10
		li $s1,0            #reset flag it back to integer
		j StoringLoop

    #save the number that we read and it appeared to be a float
    #this function is called when we find a "\n" and we are in floating point mode ($s3 = 1)
    saveDecimalRow:
		#setting registers up
		move $t7,$s5	    #load array  addres into t
		lw $t6,numCols      #we will store the address in $t6

		#getting the address			
		mulu $t6,$t6,$t1    #find the row*num of columns
		addu $t6,$t6,$t2    #add the column we want to access
		sll $t6,$t6,3       #shift left by 3 since data size is 8 bytes

		#Storing the word
		addu $t7,$t7,$t6	#point to the correct index
		s.s $f0,($t7)	    #store the word

		#now we need to increment number of columns and reset registers
		#finishing up
		addiu $t0,$t0,1		#increment pointer
		addiu $t0,$t0,1 	#increment pointer by 1 since \n is 13 then 10 but they are read as a single byte (at least it seems so)
		li $t4,0
		mtc1 $zero,$f0
		mtc1 $zero,$f1
		mtc1 $zero,$f2
		li $t9,10		    #reset t9 to 10
		li $s1,0 		    #reset flag it back to integer
		li $t2,0		    #reset the number of columns
		addiu $t1,$t1,1		#increase number of rows
		j StoringLoop

    #save the number that we read and it appeared to be a float
    #this function is called when we find a 0 (EOF) and we are in floating point mode ($s3 = 1)
    saveLastDecimal:
		#setting registers up
		move $t7,$s5	    #load array  addres into t
		lw $t6,numCols      #we will store the address in $t6

		#getting the address			
		mulu $t6,$t6,$t1    #find the row*num of columns
		addu $t6,$t6,$t2    #add the column we want to access
		sll $t6,$t6,3       #shift left by 3 since data size is 8 bytes

		#Storing the word
		addu $t7,$t7,$t6	#point to the correct index
		s.s $f0,($t7)	    #store the word

		#now we need to increment number of columns and reset registers
		#finishing up
		li $t4,0
		li $t2,0		    #reset the number of columns

        #Close the file 
		li   $v0, 16       #system call for close file
		move $a0, $s6      #file descriptor to close
		syscall            #close file
		jr $ra
	
	#read how many levels does the user want
    readRequiredLevel:
		li $v0, 5 	    #Read integer
		syscall 	    #$v0 = value read
		move $t0,$v0    #move the read level value into $t0
		sw $t0,level    #save the level in the operation variable
		jr $ra
    
    #read if the user wants to find the results using arithmatic mean or median
    readCompAvg:
		li $v0, 4
		la $a0, compAvg
		syscall
	
		li $v0, 5 	        #Read integer
		syscall 	        #$v0 = value read
	
		move $t0,$v0	    #move the read opearation value into $t0
		sw $t0,operation    #save the operation in the operation variable

		beq  $t0, 1 , mean
		beq  $t0, 2 , median
	
		#if t0 != 1 and t0!=2 print error and read again
		li $v0, 4
		la $a0, compAvgError
		syscall
		j readCompAvg
	
    #return to main. Usually called withing many functions as a label
    #since we can't check for a statement and jump to return in the same time
    return:
		jr $ra

    #in case we want to want to find the mean, we want to do some preprocessing first
    mean: 
		li $s3,0        #flag =0 means mean
		j prcoessInputMatrix
	
		li $v0, 4
		la $a0, meanPrint
		syscall
   
        #Printing out the number
    	lw $a0,operation
		li $v0, 1 		#Print integer
		syscall	

    #in case we want to want to find the median, we want to do some preprocessing first
    median:
	
		li $s3,1
		j prcoessInputMatrix
	
		li $v0, 4
		la $a0, medianPrint
		syscall
	
		lw $a0,operation
		li $v0, 1 		#Print integer
		syscall	
		
	j return
	
prcoessInputMatrix:
#############################################################################################################
###  _____	___    _____	_____	____   	___    ___    _________     _           _____		  ###
### |     \   |   \  /    \   /       |      /      /            |        | \    |   / 		  ###
### |_____/   |___/ |      | |        |____  \____  \____        |        |  \   |  |     __		  ###
### |         |   \ |      | |        |           \      \       |        |   \  |  |       |		  ###
### |         |    \\_____/  \______  |____   ____/  ____/   ____|____    |    \_|   \ ____/  		  ###
#############################################################################################################
 	#setting registers up
	#allocating space for the array knowing that they are floating point numbers
	lw  $t1,numRows		#number of rows
	move $t0,$t1
	div $t1,$t1,2
	and $t0,$t0,1		
	xor $t0,$t0,1	    #if first bit is 1 then we are odd
	beq $t0,$zero,InavalidLevels
	lw  $t2,numCols		#number of columns
	move $t0,$t2
	div $t2,$t2,2
	and $t0,$t0,1		
	xor $t0,$t0,1	    #if first bit is 1 then we are odd
	beq $t0,$zero,InavalidLevels
	mul $a0,$t1,$t2
	sll $a0,$a0,3
	li $v0,9
	syscall
	move $s6,$v0
	#now we have finished allocating space for even arrays, now lets see odd arrays
	lw  $t1,numRows		#number of rows
	lw  $t2,numCols		#number of columns
	div $t1,$t1,4
	div $t2,$t2,4
	mul $a0,$t1,$t2
	sll $a0,$a0,3
	li $v0,9
	syscall
	move $s7,$v0

	#now allocated space for odd matrices
	lw $t0,level 	

#  _                    _   _                       
# | |                  | | | |                      
# | |     _____   _____| | | |     ___   ___  _ __  
# | |    / _ \ \ / / _ | | | |    / _ \ / _ \| '_ \ 
# | |___|  __/\ V |  __| | | |___| (_) | (_) | |_) |
# \_____/\___| \_/ \___|_| \_____/\___/ \___/| .__/ 
#                                            | |    
#                                            |_|    

#
#	Registers to be used in the loops below:
#
#	TEMPORARY REGISTERS
#	$t0 -> iterator for the Levels loop (levelLoop). Ends when $t0 = 0
#	$t1 -> iterator for the rows loop (outerLoopAllMatrix). Ends when $t1 = $t9 which contains the length of rows in the current iteration, starting from 0 with stepping = 2
#	$t2 -> iterator for the columns loop (innerLoopAllMatrix). Ends when $t2 = $t3 which contains the length of columns in the current iteration, starting from 0 with stepping = 2
#	$t4 -> iterator for i, which is the iterator for the number of rows in the current window (outerLoop4by4Matrix), it ends when we reach 2, starting from 0, stepping = 1
#	$t5 -> iterator for j, which is the iterator for the number of cols in the current window (innerLoop4by4Matrix), it ends when we reach 2, starting from 0, stepping = 1
#	$t6 -> in it we do the calculation to see how much should we add to the index of the array in order to access the desired location in the array, by adding the result to the base address
#	$t7 -> contains the base address of the array that we want to do operations on (the one we are reading from)
#	$t8 -> general purpose, used for immediate calculations. In calculateMean and calculateMedian, it contains the address of the heap where we will write the result to
#	$t9 -> already mentions, it contains the length of the current array we are reading from (number of rows)
#	
#	ARITHMATIC REGISTERS
#	$a0 -> used for general purpose calculations, we can't use it for storing as it is needed for printing and other syscalls
#	$a1 -> used for general purpose calculations, we can't use it for storing as it is needed for certain syscalls 
#	$a2 -> used for general purpose calculations, usually used to check if the number investigated is even or odd (by anding with 1 then xoring with 1 then beqz to odd otherwise even)
#	$a3 -> used for general purpose calculations, mainly for finding the length from base address of the array we are writing to (similar to $t6 and $t7 above)
#	
#	REGISTERS USED FOR SAVING
#	$s0 -> not used in the loop below
#	$s1 -> used in result array
#	$s2	-> contains the window (even or odd) for calculating the mean
#	$s3 -> contains the flag for calculating mean (0) or median (1)
#	$s4 -> contains the base address of the array we are going to use caluclations on currently (reading from) in the heap
#	$s5 -> contains the base address of the main heap (original matrix read from the input file)
#	$s6 -> contains the base address of the even levels heap. levels 2,4,6..etc. read from this heap. levels 1,3,5...etc, write to this heap
#	$s7 -> contains the base address of the odd levels heap. levels 1,3,5..etc. read from this heap. levels 2,4,6...etc, write to this heap
#
levelLoop:

	subi $t0,$t0,1			    #decrease number of levels by 1 to see if we reached the final level or not
	beqz $t0, printOnFile
		
	lw $a0,CurrentNumRows	    #to store the current number of rows inside the designated variables before we change them (befoe we divide $a2 by 2 to store it in CurrentNymRows again for next level
	move $a2,$a0
	move $t9,$a0			    #store it in $t9 so that we can know when the ROWS loop (outerLoopAllMatrix) ends

	div $a0,$a0,2			    #divide the current number of rows by  2 in order to save it in CurrentNumRows for next loop
	and $a2,$a2,1			
	xor $a2,$a2,1	            #if first bit is 1 then we are odd to check if we are in last level or not, since we can't compute Odd arrays (3x3 , 1x1, 5x5,,...etc.)
	beq $a2,$zero,lastLevelReached
	sw $a0,CurrentNumRows	    #load the current number of rows 
	lw $a0,numCols
	lw $a1,CurrentNumCols
	move $t1,$zero	            #ending counter for outerLoopAllMatrix
	beq $a0,$a1,stillAtLevelOne #to see if we are in the first loop or not, compare between current number of columns and number of columns
	li $a0, 1
	lb $a1, isEven

	#beq $a1,$a0,saveArrayAndToggle #if we are not in first loop, then we are either at an odd or even loop
	j saveArrayAndToggle

    #label that is called to finish some things up before moving to next phase (outerLoopAllMatrix)
    continueYourThing:
        lw $a1,CurrentNumCols
		move $a2,$a1
		and $a2,$a2,1		
		xor $a2,$a2,1	    #if first bit is 1 then we are odd
        beq $a2,$zero,lastLevelReached
        move $t3,$a1        #REFERENCE NUMBER OF COLUMNS TO BE USED FOR LOOPING, $t2 WILL BE USED IN LOOP OF COLUMNS
        div $a1,$a1,2
        sw $a1,CurrentNumCols
        j outerLoopAllMatrix

    #in case we are in first level, we need to load the matrix in $s5
    stillAtLevelOne:
        li $s4,1
        sb $s4,isEven	    #this means that next time we check it will be even
        move $s4,$s5	    #store the address of the main array in $s4 to be used later
        move $s1,$s6        #store the address of the array that we are going store the result in
        lw $t9,numRows      #REFERENCE NUMBER OF ROWS TO BE USED FOR LATER, $t9 WILL BE USED AS A REFERENCE
        lw $a1,CurrentNumCols
		move $a2,$a1
		and $a2,$a2,1		
		xor $a2,$a2,1	    #if first bit is 1 then we are odd
        beq $a2,$zero,lastLevelReached
        div $a1,$a1,2
        sw $a1,CurrentNumCols
        lw $t3,numCols      #REFERENCE NUMBER OF COLUMNS TO BE USED FOR LOOPING, $t2 WILL BE USED IN LOOP OF COLUMNS

        j outerLoopAllMatrix

    #toggle here is to toggle isEven so that next round we load the Odd matrix
    saveArrayAndToggle:
        #in here $a0 = 1, and $a1 containes what isEven has
        xor $a1,$a0,$a1	    #when we xor the 2 numbers, if it was 0 it will become 1 and vice versa
        sb $a1,isEven	    #this means that next time we check it will be even
        beqz $a1,itIsEven
        move $s4,$s7	    #store the address of the main array in $s4 to be used later
        move $s1,$s6        #store the address of the array that we are going store the result in
        
        j continueYourThing

    #to load the even matrix
    itIsEven:
        move $s4,$s6
        move $s1,$s7        #store the address of the array that we are going store the result in

       j continueYourThing
        

        #  _____       _              _                          ___  _ _  ___  ___      _        _      
        # |  _  |     | |            | |                        / _ \| | | |  \/  |     | |      (_)     
        # | | | |_   _| |_ ___ _ __  | |     ___   ___  _ __   / /_\ | | | | .  . | __ _| |_ _ __ ___  __
        # | | | | | | | __/ _ | '__| | |    / _ \ / _ \| '_ \  |  _  | | | | |\/| |/ _` | __| '__| \ \/ /
        # \ \_/ | |_| | ||  __| |    | |___| (_) | (_) | |_) | | | | | | | | |  | | (_| | |_| |  | |>  < 
        #  \___/ \__,_|\__\___|_|    \_____/\___/ \___/| .__/  \_| |_|_|_| \_|  |_/\__,_|\__|_|  |_/_/\_\
        #                                              | |                                               
        #                                              |_|                                               
        outerLoopAllMatrix:
            beq $t1,$t9,ret	
            move $t2,$zero	#i ==> cols, starting counter for innerLoopAllMatrix
        
        
            #  _____                        _                          ___  _ _  ___  ___      _        _      
            # |_   _|                      | |                        / _ \| | | |  \/  |     | |      (_)     
            #   | | _ __  _ __   ___ _ __  | |     ___   ___  _ __   / /_\ | | | | .  . | __ _| |_ _ __ ___  __
            #   | || '_ \| '_ \ / _ | '__| | |    / _ \ / _ \| '_ \  |  _  | | | | |\/| |/ _` | __| '__| \ \/ /
            #  _| || | | | | | |  __| |    | |___| (_) | (_) | |_) | | | | | | | | |  | | (_| | |_| |  | |>  < 
            #  \___|_| |_|_| |_|\___|_|    \_____/\___/ \___/| .__/  \_| |_|_|_| \_|  |_/\__,_|\__|_|  |_/_/\_\
            #                                                | |                                               
            #                                                |_|                                               

            innerLoopAllMatrix:	
                beq $t2,$t3,endInnerLoopAllMatrix
                li $t4,0
                        
            #  _____       _              _                           ___        ___  ___  ___      _        _      
            # |  _  |     | |            | |                         /   |      /   | |  \/  |     | |      (_)     
            # | | | |_   _| |_ ___ _ __  | |     ___   ___  _ __    / /| __  __/ /| | | .  . | __ _| |_ _ __ ___  __
            # | | | | | | | __/ _ | '__| | |    / _ \ / _ \| '_ \  / /_| \ \/ / /_| | | |\/| |/ _` | __| '__| \ \/ /
            # \ \_/ | |_| | ||  __| |    | |___| (_) | (_) | |_) | \___  |>  <\___  | | |  | | (_| | |_| |  | |>  < 
            #  \___/ \__,_|\__\___|_|    \_____/\___/ \___/| .__/      |_/_/\_\   |_/ \_|  |_/\__,_|\__|_|  |_/_/\_\
            #                                              | |                                                      
            #                                              |_|                                                      

            outerLoop4by4Matrix:
                beq $t4,2, endOuterLoop4by4Matrix #t4 rows (inner))
                li $t5,0
                
                #  _____                        _                           ___        ___  ___  ___      _        _      
                # |_   _|                      | |                         /   |      /   | |  \/  |     | |      (_)     
                #   | | _ __  _ __   ___ _ __  | |     ___   ___  _ __    / /| __  __/ /| | | .  . | __ _| |_ _ __ ___  __
                #   | || '_ \| '_ \ / _ | '__| | |    / _ \ / _ \| '_ \  / /_| \ \/ / /_| | | |\/| |/ _` | __| '__| \ \/ /
                #  _| || | | | | | |  __| |    | |___| (_) | (_) | |_) | \___  |>  <\___  | | |  | | (_| | |_| |  | |>  < 
                #  \___|_| |_|_| |_|\___|_|    \_____/\___/ \___/| .__/      |_/_/\_\   |_/ \_|  |_/\__,_|\__|_|  |_/_/\_\
                #                                                | |                                                      
                #                                                |_|                                                      

                innerLoop4by4Matrix:
                    beq $t5,2, endInnerLoop4by4Matrix   #t5 cols (inner)

                    move $t7,$s4	                    #load array  addres into t7			
                    move $t6,$t3                        #$t6 = current cols #
                    addu $a0,$t4,$t1                    #add i(t4) + row(t1)
                    mulu $t6,$t6,$a0                    #find the row*num of columns
                    
                    addu $a0,$t5,$t2                    #cols($t2) + j($t5)
                    addu $t6,$t6,$a0                    #add the column we want to access
                    sll $t6,$t6,3                       #shift left by 3 since data size is 8 bytes
                    addu $t7,$t7,$t6	                #point to the correct index
                    
                    beq $t4,0,row0                      #check if we are in row 0
                    #save value in row 1 column 1 to $f2 
                    beq $t5,0,row1Col0                  #check if we are in row 1 col 0
                    l.s $f3,($t7)                       #store the value of row 1 col 1 in $f3
                    j continue

            #save value in row 1 column 0 to $f2       
                    row1Col0:
                        l.s $f2,($t7)                       #store the value of row 1 col 0 in $f2
                        j continue

            #in case we were in row 0
                    row0: 
                        beq $t5,0, row0Col0                 #check if we are in row 0 col 0
                        #save value in row 1 column 0 to $f1
                        l.s $f1,($t7)                       #store the value of row 0 col 1 in $f1
                        j continue

            #save value in row 0 column 0 to $f0
                    row0Col0: 
                        l.s $f0,($t7) #store the value of row 0 col 0 in $f0
                        j continue

                    continue:	
                        addu $t5,$t5,1
                        j innerLoop4by4Matrix
                    
                                        
                    #  _____ _   _______   _____                        _                           ___        ___  ___  ___      _        _      
                    # |  ___| \ | |  _  \ |_   _|                      | |                         /   |      /   | |  \/  |     | |      (_)     
                    # | |__ |  \| | | | |   | | _ __  _ __   ___ _ __  | |     ___   ___  _ __    / /| __  __/ /| | | .  . | __ _| |_ _ __ ___  __
                    # |  __|| . ` | | | |   | || '_ \| '_ \ / _ | '__| | |    / _ \ / _ \| '_ \  / /_| \ \/ / /_| | | |\/| |/ _` | __| '__| \ \/ /
                    # | |___| |\  | |/ /   _| || | | | | | |  __| |    | |___| (_) | (_) | |_) | \___  |>  <\___  | | |  | | (_| | |_| |  | |>  < 
                    # \____/\_| \_|___/    \___|_| |_|_| |_|\___|_|    \_____/\___/ \___/| .__/      |_/_/\_\   |_/ \_|  |_/\__,_|\__|_|  |_/_/\_\
                    #                                                                    | |                                                      
                    #                                                                    |_|                                                      

                    endInnerLoop4by4Matrix:
                        addu $t4,$t4,1
                        j outerLoop4by4Matrix

                #  _____ _   _______   _____       _              _                           ___        ___  ___  ___      _        _      
                # |  ___| \ | |  _  \ |  _  |     | |            | |                         /   |      /   | |  \/  |     | |      (_)     
                # | |__ |  \| | | | | | | | |_   _| |_ ___ _ __  | |     ___   ___  _ __    / /| __  __/ /| | | .  . | __ _| |_ _ __ ___  __
                # |  __|| . ` | | | | | | | | | | | __/ _ | '__| | |    / _ \ / _ \| '_ \  / /_| \ \/ / /_| | | |\/| |/ _` | __| '__| \ \/ /
                # | |___| |\  | |/ /  \ \_/ | |_| | ||  __| |    | |___| (_) | (_) | |_) | \___  |>  <\___  | | |  | | (_| | |_| |  | |>  < 
                # \____/\_| \_|___/    \___/ \__,_|\__\___|_|    \_____/\___/ \___/| .__/      |_/_/\_\   |_/ \_|  |_/\__,_|\__|_|  |_/_/\_\
                #                                                                  | |                                                      
                #                                                                  |_|                                                      

                endOuterLoop4by4Matrix:
                    addu $t2,$t2,2 
                    beq $s3,0,CalculateMean
                    beq $s3,1,CalculateMedian
                    j innerLoopAllMatrix #2nd loop


            #  _____ _   _______   _____                        _                               _ _  ___  ___      _        _      
            # |  ___| \ | |  _  \ |_   _|                      | |                             | | | |  \/  |     | |      (_)     
            # | |__ |  \| | | | |   | | _ __  _ __   ___ _ __  | |     ___   ___  _ __     __ _| | | | .  . | __ _| |_ _ __ ___  __
            # |  __|| . ` | | | |   | || '_ \| '_ \ / _ | '__| | |    / _ \ / _ \| '_ \   / _` | | | | |\/| |/ _` | __| '__| \ \/ /
            # | |___| |\  | |/ /   _| || | | | | | |  __| |    | |___| (_) | (_) | |_) | | (_| | | | | |  | | (_| | |_| |  | |>  < 
            # \____/\_| \_|___/    \___|_| |_|_| |_|\___|_|    \_____/\___/ \___/| .__/   \__,_|_|_| \_|  |_/\__,_|\__|_|  |_/_/\_\
            #                                                                    | |                                               
            #                                                                    |_|                                               

            endInnerLoopAllMatrix:
                    addu $t1,$t1,2          #outer loop counter
                    j outerLoopAllMatrix    #might delete later

        ret:	                    
            #print content of S1 with length = t1 / 2 (current length of rows / 2) and t2 / 2 (same but cols),, $s1 is the array
			li $a2,0
			move $a3,$t2
			sll $a3,$a3,2       #$a3 = (number of columns / 2)*8 : cols / 2 = length of the array having the result matrix and 8 is the element size 

   			li $v0, 4
            la $a0, sperater
            syscall
            
			li $v0, 4
            la $a0, sperater
            syscall
			
			li $v0, 4
            la $a0, levelStr
        	syscall

			lw $a0 , level
			sub $a0,$a0,$t0
			addi $a0,$a0,1
           	
			li $v0,1            #Print integer
			syscall

			li $v0, 4
        	la $a0, newLine
            syscall

        printLoop:
			move $a1, $s1       #a0 = base address of the array 
			
			add $a1,$a2,$a1
			l.s $f12,($a1)
			li $v0, 2
            syscall

			li $v0, 4           #TAB
            la $a0, newTab
            syscall

			addi $a2,$a2,8      #$a2 is the offset 
			div $a1,$a2,$a3 
			mfhi $a1
			beqz $a1,printNewLine 

        contPrinting:
			mul $a1,$t1,$t2
			sll $a1,$a1,1
			bge $a2,$a1,levelLoop
			j printLoop

        printNewLine:
       		li $v0, 4
            la $a0, newLine
            syscall
			j contPrinting

j levelLoop


            
    #$s6: new array, $s7: newest array
    #after processing 	
    CalculateMean:
            #setting registers up
			lw $a0 , level
			sub $a0,$a0,$t0
			andi $t8,$a0,1          #check if number of level is even or odd
               
		    bnez $t8, weAreEven
            move $t8, $s1	        #t8 contains the location of the allocated heap area

            #In Case Odd
            l.s $f5,Window1p5       #1.5
        	l.s $f6,Window0p5       #0.5
            l.s $f7,cmprFloat1      #flag
            j contInLoop

    weAreEven:
                move $t8, $s1	    #t8 contains the location of the allocated heap area
                l.s $f5,Window0p5   #0.5
                l.s $f6,Window1p5   #1.5
                l.s $f7,cmprFloat2  #flag

    contInLoop:
                move $a3,$t3            #this contains the total number of columns in our current iteration. It must be divided by 2 to map it correctly    	           
                divu $a3,$a3,2

            	#getting the address	
                move $a0,$t1            #this contains the total number of rows in this current iteration translated to the mapping (it must be divided by 2, that is the translation required)
                divu $a0,$a0,2
                move $a1,$t2	        #current column we are at, but we must map it to newer dimentsions by dividing by 2
                subiu $a1,$a1,2         #sub in order to remove the eeffect of last increment in innerLoopAllMatrix
                divu $a1,$a1,2
        	
                mulu $a3,$a3,$a0        #find the row*num of columns
                addu $a3,$a3,$a1        #add the column we want to access
                sll $a3,$a3,3           #shift left by 3 since data size is 8 bytes

            	#Storing the word
                addu $t8,$t8,$a3	    #point to the correct index

                
                l.s   $f8, cmprFloat1   #store the value 1 in register $f8
				c.eq.s $f8, $f7         #$f8 = $f7?
				bc1t oddOper            #if true, branch to the label called "loop"

				#odd operation
				mul.s $f9,$f0,$f5       #$f9 = $f0 *  0.5
                mul.s $f10,$f1,$f6      #$f10 = $f1 * 1.5
                add.s $f11, $f9,$f10    #$f11 = $f9 + $f10
                
                mul.s $f12,$f2,$f6      #$f12 = $f2 * 1.5
                mul.s $f13,$f3,$f5      #$f13 = $f3 * 0.5
                add.s $f14, $f12,$f13   #$f13 = $f12 + $f13
                
                add.s $f15,$f14,$f11    #$f14 = $f14 + $f11 #now $f14 has the the result of mul and addition and $f4 will have the final result after dividing by 4
                l.s   $f16,divby4
                div.s $f4, $f15, $f16
				j goToSaving
		
                oddOper:  
                    mul.s $f9,$f0,$f5       #$f9 = $f0 *  1.5
                    mul.s $f10,$f1,$f6      #$f10 = $f1 * 0.5
                    add.s $f11, $f9,$f10    #$f11 = $f9 + $f10

                    mul.s $f12,$f2,$f6      #$f12 = $f2 * 0.5
                    mul.s $f13,$f3,$f5      #$f13 = $f3 * 1.5
                
                    add.s $f14, $f12,$f13   #$f14 = $f12 + $f13
                    
                    add.s $f15,$f14,$f11    #$f14 = $f14 + $f11 #now $f14 has the the result of mul and addition and $f4 will have the final result after dividing by 4
                    l.s   $f16,divby4
                    div.s $f4, $f15, $f16   #$f4  = total/4
                
 	    goToSaving:
               
                #store current matrix multiplication output in $f4
                s.s $f4,($t8)	    #store the word
                
              	li $v0, 4
                la $a0, sperater
                syscall

				li $v0, 2
                mov.s $f12, $f4    #print result of the mean operation
                syscall
                
                li $v0, 4
                la $a0, newLine
                syscall
                

		        li $v0, 2
                mov.s $f12, $f0   #print 1st number in window array
                syscall
                

                li $v0, 4
                la $a0, newTab
                syscall

                li $v0, 2
                mov.s $f12, $f1   #print 2nd number in window array
                syscall
                

                li $v0, 4
                la $a0, newLine
                syscall
                
                li $v0, 2
                mov.s $f12, $f2   #print 3rd number in window array
                syscall
                

                li $v0, 4
                la $a0, newTab
                syscall

                li $v0, 2
                mov.s $f12, $f3   #print 4th number in window array
                syscall
                

                li $v0, 4
                la $a0, newLine
                syscall

        j innerLoopAllMatrix

        
            
                    
    CalculateMedian:
	#f4 is used as the temporary register where we will do everything
    #setting registers up
        move $t8, $s1	    #t8 contains the location of the allocated heap area

        move $a3,$t3        #this contains the total number of columns in our current iteration. It must be divided by 2 to map it correctly    	           
        divu $a3,$a3,2

        #getting the address	
        move $a0,$t1        #this contains the total number of rows in this current iteration translated to the mapping (it must be divided by 2, that is the translation required)
        divu $a0,$a0,2
        move $a1,$t2	    #current column we are at, but we must map it to newer dimentsions by dividing by 2
        subiu $a1,$a1,2     #sub in order to remove the eeffect of last increment in innerLoopAllMatrix
        divu $a1,$a1,2
            
        mulu $a3,$a3,$a0    #find the row*num of columns
        addu $a3,$a3,$a1    #add the column we want to access
        sll $a3,$a3,3       #shift left by 3 since data size is 8 bytes

        #Storing the word
        addu $t8,$t8,$a3	#point to the correct index
        #DO THE OPERATIONS IN HERE

        sort:
			#sort first 2, then last 2, then middle 2, then first 2 again then last 2 again
			#Last swap is not needed as we want the middle 2 so we can skip 1 time which makes this 
			#sorting algorithm less than nlogn (FASTER THAN QUICK SORT)
			c.lt.s $f0,$f1 	#check if f0 is less than f1, if not then swap
			bc1f	swap1
			j cont1

        swap1:
			mov.s $f4, $f0		#move f0 to f4
			mov.s $f0,$f1		#move f0 to f1
			mov.s $f1,$f4		#move f4 to f1 (complete the swap)

        cont1:
			#checking 2 rightmost registers
			c.lt.s $f2,$f3 	    #check if f0 is less than f1, if not then swap
			bc1f	swap2
			j cont2

        swap2:
			mov.s $f4, $f2		#move f2 to f4
			mov.s $f2,$f3		#move f2 to f3
			mov.s $f3,$f4		#move f4 to f3 (complete the swap)

        cont2:
			#checking middle 2 registers
			c.lt.s $f1,$f2      #check if f0 is less than f1, if not then swap
			bc1f	swap3
			j cont3

        swap3:
			mov.s $f4,$f1		#move f1 to f4
			mov.s $f1,$f2		#move f1 to f2
			mov.s $f2,$f4		#move f4 to f2 (complete the swap)

        cont3:
			#checking first 2 registers again
			c.lt.s $f0,$f1 	    #check if f0 is less than f1, if not then swap
			bc1f	swap4
			j cont4

        swap4:
			mov.s $f4, $f0		#move f0 to f4
			mov.s $f0,$f1		#move f0 to f1
			mov.s $f1,$f4		#move f4 to f1 (complete the swap)

        cont4:
			#checking 2 rightmost registers again
			c.lt.s $f2,$f3 	    #check if f0 is less than f1, if not then swap
			bc1f	swap5
			j cont5

        swap5:
			mov.s $f4, $f2		#move f2 to f4
			mov.s $f2,$f3		#move f2 to f3
			mov.s $f3,$f4		#move f4 to f3 (complete the swap)

        cont5:	
        #checking 2 middle registers again OPTIONAL SINCE WE ARE LOOKING INTO MEDIAN, NOT SORING
        #	c.lt.s $f1,$f2 	#check if f0 is less than f1, if not then swap
        #	bc1f	swap6
        #	j cont6
        #swap6:
        #	mov.s $f4, $f1		#move f1 to f4
        #	mov.s $f1,$f2		#move f1 to f2
        #	mov.s $f2,$f4		#move f4 to f2 (complete the swap)

        #cont6:
            #now they are sorted (in sha' allah)
            add.s $f4,$f1,$f2	#add the 2 registers in the middle
            l.s $f13,divBy2
            div.s $f4,$f4,$f13
            j goToMedianSaving

            #now they are sorted (in sha' allah)
            add.s $f4,$f1,$f2	#add the 2 registers in the middle
            l.s $f13,divBy2
            div.s $f4,$f4,$f13
            j goToMedianSaving
	
        goToMedianSaving:
            li $v0, 4
            la $a0, sperater
            syscall

            #store current matrix multiplication output in $f4
            s.s $f4,($t8)	    #store the word
            li $v0, 2
            mov.s $f12, $f4     #print the result of the median operation 
            syscall
                    
            li $v0, 4
            la $a0, newLine
            syscall
                    

            li $v0, 2
            mov.s $f12, $f0     #print 1st number in window array
            syscall
                    

            li $v0, 4
            la $a0, newTab
            syscall

            li $v0, 2
            mov.s $f12, $f1     #print 2nd number in window array
            syscall
                    

            li $v0, 4
            la $a0, newLine
            syscall
                    
            li $v0, 2
            mov.s $f12, $f2     #print 3rd number in window array
            syscall
                    

            li $v0, 4
            la $a0, newTab
            syscall

            li $v0, 2
            mov.s $f12, $f3     #print 4th number in window array
            syscall
                    

            li $v0, 4
            la $a0, newLine
            syscall

            j innerLoopAllMatrix

    lastLevelReached:
		li $v0, 4
        la $a0, sperater
        syscall
			
		li $v0, 4
        la $a0, errorLastLevel
        syscall

		lw $a0 , level
		sub $a0,$a0,$t0
		addi $a0,$a0,1
           	
		li $v0,1        #Print integer
		syscall
			
		#Now print to file, $t9 = correct number of rows, $t3 needs to be divided by 2
		div $t3,$t3,2
		mul $t1,$t3,$t9	#save total number of elements in array in $t1 
		move $t2,$s1	#t2 contains the address of where to read
		j continuePrinting

    InavalidLevels:
		li $v0, 4
        la $a0, sperater
        syscall
			
		# li $v0, 4
        # la $a0, errorLastLevel
    	# syscall

					
		li $v0, 4
        la $a0, errorMatrixSize
    	syscall


		# li $a0,1
		# li $v0,1 #Print integer
		# syscall
		j endOfProcessing

	#this gets called when we finish properly, size of matrix is $t3/2 * $t9/2 (rows/2 * cols/2)
	#starting address is in S1
    printOnFile:
		#first check if we were on the first level
		lw $t4,level
		subi $t4,$t4,1
		beq $t4,$t0,endOfProcessing	    #if we were on first level then skip printing.
		div $t3,$t3,2	                #number of cols
		div $t9,$t9,2	                #number of rows

		#save total number of elements in the array in $t1
		mul $t1,$t9,$t3	                #t1 now contains the maximum length of the array
		move $t2,$s1	                #t2 contains the address of where to read
	
    continuePrinting:
		#Setting Up The Registers and Opening the File to write on
		l.s $f13,ten	            #used for multiplication by 10 later on
		l.s $f14,fourtyEight	    #used for converting to ascii
		l.s $f15,zero	            #used for comparing with 0

		#opening a file
		li   $v0, 13                #system call for open file
		la   $a0, fout              #output file name
		li   $a1, 1                 #Open for writing (flags are 0: read, 1: write)
		li   $a2, 0                 #mode is ignored
		syscall                     #open a file (file descriptor returned in $v0)

		move $s6, $v0               #save the file descriptor 
		li   $v0, 15                #system call for write to file
		move $a0, $s6               #file descriptor 
		la $a1,levelStr             #address of buffer from which to write
		li   $a2, 17                #hardcoded buffer length
		syscall  

		lw $a0,level
		sub $a0,$a0,$t0
		add $a0,$a0,48	            #convert last level reached to ascii assuming it is single digit
		sb $a0,byteToPrint	        #store the number of last level we reached
		li   $v0, 15                #system call for write to file
		move $a0, $s6               #file descriptor 
		la $a1,byteToPrint          #address of buffer from which to write
		li   $a2, 1                 #hardcoded buffer length
		syscall  
	
		li   $v0, 15                #system call for write to file
		move $a0, $s6               #file descriptor 
		la $a1,newLine              #address of buffer from which to write
		li   $a2, 1                 #hardcoded buffer length
		syscall                     #write to file  
	
	#start reading
    readingAndPrintingLoop:
		l.s $f10,($t2)	            #store the content of heap in $f10 
		cvt.w.s $f11,$f10
		s.s $f11,tempConvertToInt
		cvt.s.w $f11,$f11
		sub.s $f10,$f10,$f11        #remove the integer part of the number and keep what is after the decimal point
		cvt.w.s $f11,$f11
		jal printFirstNumber
	
		#now first number is printed, we need to print the decimal point first
		li   $v0, 15                #system call for write to file
		move $a0, $s6               #file descriptor 
		la $a1,decimalPointtoPrint  #address of buffer from which to write
		li $a2, 1                   #hardcoded buffer length
		syscall                     #write to file
	
		#now we need to multiply by 10 and print to file until there is nothing remaining in register (0)
		li $t9,4	

    printingDecimalPoint:
		mul.s $f10,$f10,$f13
		cvt.w.s $f11,$f10
		cvt.s.w $f11,$f11
		sub.s $f10,$f10,$f11
		add.s $f11,$f11,$f14	    #convert to ascii
		cvt.w.s $f11,$f11
		s.s $f11,byteToPrint	    #store the int value to be printed later
		c.le.s $f10,$f15 	        #check if f10 is 0

		#Write to file just opened
		li   $v0, 15                #system call for write to file
		move $a0, $s6               #file descriptor 
		la $a1,byteToPrint          #address of buffer from which to write
		li   $a2, 1                 #hardcoded buffer length
		syscall

		bc1t endFirstNumber	        #if it became 0 then go do next number
		subi $t9,$t9,1
		beqz $t9,endFirstNumber
		j printingDecimalPoint

    endFirstNumber:
		#in here print \t or \n accordingly
		#first check if it is a new line, if ($t2 (current address to write to) - $s1 (base address) )/8...
		#== $t3 (number of columns)
		add $t2,$t2,8	            #the new address to read from
		sub $a3,$t2,$s1
		srl $a3,$a3,3	            #div by 8 to convert to value not value*element size (which is 8 bytes)
		div $a3,$a3,$t3	            #to see if we finished a row
		mfhi $a3
		beqz $a3,writeNewLine	    #if we finished the row

		#otherwise print \t
		li   $v0, 15                #system call for write to file
		move $a0, $s6               #file descriptor 
		la $a1,newTab               #address of buffer from which to write
		li   $a2,1                  #hardcoded buffer length
		syscall                     #write to file
	
		sub $a3,$t2,$s1
		srl $a3,$a3,3	            #div by 8 to convert to value not value*element size (which is 8 bytes) and check if it was the last address
		bge $a3,$t1,endOfProcessing	#if so then end the program
		j readingAndPrintingLoop

    writeNewLine:
		li   $v0, 15                #system call for write to file
		move $a0, $s6               #file descriptor 
		la $a1,newLine              #address of buffer from which to write
		li   $a2, 1                 #hardcoded buffer length
		syscall                     #write to file

		sub $a3,$t2,$s1
		srl $a3,$a3,3	            #div by 8 to convert to value not value*element size (which is 8 bytes) and check if it was the last address
		bge $a3,$t1,endOfProcessing	#if so then end the program
		j readingAndPrintingLoop

endOfProcessing:
    #Close the file 
    li   $v0, 16                #system call for close file
    move $a0, $s6               #file descriptor to close
    syscall       

    li $v0, 10                  #Finish the Program
    syscall

#in here we want to see the length of the number at first then go back to printing rest of the numbers
printFirstNumber:
	lw $t4,tempConvertToInt         #the number that we want to print as a signle byte integer
	beqz $t4,print0AndContinue	    #if the number was 0 then just print and return to continue executing
	move $t5,$zero	                #use t5 as a counter 

checkLength:
	beqz $t4,continuePrintingToFile	#if the number is 0, then we have the total length of the array
	div $t4,$t4,10		            #divide the number by 10
	addi $t5,$t5,1		            #then increment the length
	j checkLength		            #and loop again

continuePrintingToFile:
	#now we have the length of the Integer part of the Floating point number
	lw $t4,tempConvertToInt	        #load the byte again as value in $t4 became 0 in checkLength Loop
	bnez $t5,contWithoutReturning	#if we finished all levels then return, otherwise continue without returning
	jr $ra				            #otherwise we need to return and continue executing

contWithoutReturning:
	li $t7,1	                    #load 1 into $t7 and keep multiplying by 10 according to the order of the integer
	move $t8,$t5	                #move the length of integer to t8 in order not to lose original value

divisorLoop:
		subi $t8,$t8,1
		beqz $t8,contAfterDivision
		mul $t7,$t7,10
		j divisorLoop

contAfterDivision:
	subi $t5,$t5,1	                #decrease the number of order by 1
	div $t4,$t4,$t7	                #divide the number by t7 which contains 10^(order - 1)
	addi $t4,$t4,48	                #convert to ascii
	sb $t4,	byteToPrint	            #store in the place in memory that is reserved for printing byte by byte

	#Write to file just opened
	li   $v0, 15                    #system call for write to file
	move $a0, $s6                   #file descriptor 
	la $a1,byteToPrint              #address of buffer from which to write
	li   $a2, 1                     #hardcoded buffer length
	syscall                         #write to file
	lw $t4,tempConvertToInt	        #load original number again
	div $t4,$t4,$t7		            #divide by 10
	mfhi $t4
	sw $t4,tempConvertToInt	        #store the number divided by 10 in the temprorary place used to save the integer
	j continuePrintingToFile
	
#if the number was 0.n then we don't need to process the number, just print the 0
print0AndContinue:
	addi $t4,$t4,48	                #converto 0 to ascii 
	sb $t4,	byteToPrint	            #same as above but byte = 0

	#Write to file just opened
	li   $v0, 15                    #system call for write to file
	move $a0, $s6                   #file descriptor 
	la $a1,byteToPrint              #address of buffer from which to write
	li   $a2, 1                     #hardcoded buffer length
	syscall                         #write to file
	lw $t4,tempConvertToInt
	div $t4,$t4,10
	sw $t4,tempConvertToInt
	jr $ra
