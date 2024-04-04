# Here we have the data section
.data
# Here we put the file path as the following form
filename: .asciiz "C:\\Users\\Dell\\Desktop\\data.txt"
# Here we define a buffer to store the file content inside it
file_buffer: .space 1024
buffer: .space 1500 # to store year

# Menue texts
menu_msg: .asciiz"\nWelcome to our System\n\n"
choice_1: .asciiz"1- Add new medical test\n"
choice_2: .asciiz"2- Search for a test by patiant ID\n"
choice_3: .asciiz"3- Searching for unnormal tests\n"
choice_4: .asciiz"4- Average test value\n"
choice_5: .asciiz"5- Update an existing test result\n"
choice_6: .asciiz"6- Delete a test\n"
choice_7: .asciiz"7- Exit from the program\n"

read_choice: .asciiz"Your choice: "
no_such_choice: .asciiz"There is no choice with this number, try again\n"
take_ID_msg: .asciiz"Enter the patiant ID: "
take_test_name:.asciiz"Select test name\n1- Hemoglobin (Hgb)\n2- Blood Glucose Test (BGT)\n3- Cholesterol Low-Density Lipoprotein\n4- Blood Pressure Test (BPT)\nEnter the number of the test only\nYour choice: "
take_year_msg: .asciiz"Enter the Year of the test : \n"
take_month_msg: .asciiz"Enter the Month of the test : \n"
take_test_result_msg: .asciiz"Enter the test result : \n"
not_integer_msg: .asciiz"The ID must be an integer number, try again...\n"
not_7digits_msg:.asciiz"The ID must be 7 digits only, try again...\n"
not_valid_year_msg: .asciiz"Not valid year number, try again ...\n"
invalid_month_msg: .asciiz"Not valid month number, try again ...\n"
not_4digits_msg:.asciiz"The Year must be 4 digits only, try again...\n"
exit_msg: .asciiz"Exitting from the program ...\n"
invalid_test_msg: .asciiz"Out of range test result, write it again...\n"


# buffers
ID: .space 128
test_name: .space 128
Year: .space 128
Month: .space 128
test_result: .float 0.0
Hgb_min: .float 1.0
Hgb_max: .float 20.0
BGT_min: .float 1.0
BGT_max: .float 20.0
LDL_min: .float 1.0
LDL_max: .float 20.0
BPT_min: .float 1.0
BPT_max: .float 20.0

Hgb:.asciiz"Hgb"
BGT:.asciiz"BGT"
LDL:.asciiz"LDL"
BPT:.asciiz"BPT"

###########################################################
# Here is the code section
.text
.globl	main
main:
	#open a file for reading
  	li $v0, 13 	# system call for open file
 	la $a0, filename # file name
  	li $a1, 0
 	 syscall

  	move $s0, $v0 # save the file descriptor

	# read from file
  	li $v0, 14
  	move $a0, $s0                # file descriptor
  	la $a1, file_buffer         # store file content into the buffer
  	li $a2, 1024                   # hardcoded input length
  	syscall
  
	# Close the file 
	li $v0, 16
	move $a0, $s0
	syscall
	j menu	# jump to the menue

#----------------------------------------------------
menu:
	# Print menue message
    	li $v0, 4	     # system call code for printing a string
    	la $a0, menu_msg  # address of the message
    	syscall                
    	
    	# Print choice 1
    	li $v0, 4	     # system call code for printing a string
    	la $a0, choice_1  # address of the message
    	syscall    
    	
    	# Print choice 2
    	li $v0, 4	     # system call code for printing a string
    	la $a0, choice_2     # address of the message
    	syscall  
    	
    	# Print choice 3
    	li $v0, 4	     # system call code for printing a string
    	la $a0, choice_3     # address of the message
    	syscall  
    	
    	# Print choice 4
    	li $v0, 4	     # system call code for printing a string
    	la $a0, choice_4     # address of the message
    	syscall  
    	
    	# Print choice 5
    	li $v0, 4	     # system call code for printing a string
    	la $a0, choice_5     # address of the message
    	syscall  
    	
    	# Print choice 6
    	li $v0, 4	     # system call code for printing a string
    	la $a0, choice_6     # address of the message
    	syscall  
    	
    	# Print choice 7
    	li $v0, 4	     # system call code for printing a string
    	la $a0, choice_7     # address of the message
    	syscall  
    	
    	# Ask user to choose a choice
    	li $v0, 4	        # system call code for printing a string
    	la $a0, read_choice  # address of the message
    	syscall  
    	
    	# Read a number from the user
    	li $v0, 5                 # system call code for reading an integer
   	syscall                  # read the character from the console
 	move $t0, $v0     # store the response in $t0 
 	
 	# If he chose choice 1
 	beq $t0,1, Add_test
 	# If he chose choice 2
 	beq $t0,2,search_by_ID
 	# If he entered another number then print an error message
 	li $v0,4
 	la $a0,no_such_choice
 	syscall
 	j menu 	# Go back to the menue
	
#-------------------------------------------------------------------------------
Add_test:
	# Start adding test
	li $v0,4
	la $a0,take_ID_msg
	syscall
	
	# Read patiant ID from the user
	li $v0,8	# System call code for reading a string
	la $a0, ID	# Store the read number in ID
	syscall
	
	# Check if the ID is integer
	la $a0,ID
	jal check_integer	#call the function
	
	# If the returned value ($v1) is 1 then continue
	beq $v1,1,continue_add
	
	# If the returned value ($v1) is 0 then try again
	li $v0,4
	la $a0,not_integer_msg
	syscall
	j Add_test
	
continue_add:	
	# Check if the ID is 7 digits only
	la $a0,ID
	jal check_7digits	#call the function
	
	# If the ID is 7 digits then continue
	beq $v1,1,continue_add2
	
	# If it is not 7 digits then try again
	li $v0,4
	la $a0,not_7digits_msg
	syscall
	j Add_test
	
continue_add2:	
	# Now lets move to the test name
		
	la $a0,ID
	jal remove_newline
	
	li $v0,4
	la $a0,take_test_name
	syscall
	
	li $v0,5
	syscall
	move $t0,$v0
	
	j check_test_name

	
continue_add3:

	# Now lets take the date
	li $v0,4
	la $a0,take_year_msg
	syscall
	
	# Read year from the user
	li $v0,8	# System call code for reading a string
	la $a0, Year	# Store the read number in year
	syscall
	
	# Check if the year is integer
	la $a0,Year
	jal check_integer	#call the function
	
	# If the returned value ($v1) is 1 then continue
	beq $v1,1,continue_add4
	
	# If the returned value ($v1) is 0 then try again
	li $v0,4
	la $a0,not_integer_msg
	syscall
	j continue_add3
	
	
continue_add4:
	# Check if the Year is 4 digits only
	la $a0,Year
	jal check_4digits	#call the function
	
	# If the ID is 4 digits then continue
	beq $v1,1,continue_add5
	
	# If it is not 4 digits then try again
	li $v0,4
	la $a0,not_4digits_msg
	syscall
	j continue_add3

#........................................
continue_add5:
   	 # Load the address of the string (Year) into $a0
    	la $a0, Year           
    	jal remove_newline
    	# Call the to_integer function to convert the string to an integer
    	jal Year_to_Integer
    	# Retrieve the integer value returned from to_integer
	
	move $t0, $v1

	# Check if the year is within an acceptable range (2000 to 2024)
	li $t1, 2000            # Lower bound of the acceptable range
	li $t2, 2024            # Upper bound of the acceptable range
   	ble $t0, $t1, not_valid_year # If year is less than or equal to 2000, not valid
 	bgt $t0, $t2, not_valid_year # If year is greater than  to 2024, not valid

	j continue_add6 # If the year is within the acceptable range, proceed to continue_add6

not_valid_year:
    	li $v0, 4               # System call code for printing string
    	la $a0, not_valid_year_msg # Load address of the error message
    	syscall                 # Print error message
    
    	j continue_add3          # Try again

#### NOTE THAT T0 IS THE YEAR 
 #........................................
continue_add6:
	
	# Now lets take the date (month)
	li $v0,4
	la $a0,take_month_msg
	syscall
	
	# Read month from the user
	li $v0,8	# System call code for reading a string
	la $a0, Month	# Store the read number in month
	syscall
	
	# Check if the month is integer
	la $a0,Month
	jal check_integer	#call the function
	
	# If the returned value ($v1) is 1 then continue
	beq $v1,1,continue_add7
	
	# If the returned value ($v1) is 0 then try again
	li $v0,4
	la $a0,not_integer_msg
	syscall	
	j continue_add6
	
continue_add7:
   	# Check if the month is between 1 and 12
  	la $a0, Month      
  	jal remove_newline
    	# Call the to_integer function to convert the string to an integer
    	jal Month_to_Integer
    	move $t1, $v1
    	li $t2, 1               # Lower bound of the acceptable range
    	li $t3, 12              # Upper bound of the acceptable range
    	blt $t1, $t2, invalid_month # If month is less than 1, it's invalid
    	bgt $t1, $t3, invalid_month # If month is greater than 12, it's invalid

    	j continue_add8                  # If the month is valid, return to the menu

invalid_month:
    	li $v0, 4               # System call code for printing string
    	la $a0, invalid_month_msg # Load address of the error message
    	syscall                 # Print error message
    
    	j continue_add6         # Return to adding month again
    	
################# NOTE THAT T1 IS THE MONTH

continue_add8:
	# Now lets take the test result for the patient 
	li $v0,4
	la $a0,take_test_result_msg
	syscall
		
	# Read the floating-point test result from the user
	li $v0, 6               # syscall code for read_float
	syscall
	s.s $f0, test_result    # Store the input float in the test_result variable
	
	jal check_result_test
	
	
check_result_test:
    	la $a0, test_name    # Load the address of test_name into $a0
    	
    	la $t1, Hgb    # Load the address of the string "Hgb" into $t1
    	la $t2, BGT    # Load the address of the string "BGT" into $t2
    	la $t3, LDL    # Load the address of the string "LDL" into $t3
    	la $t4, BPT    # Load the address of the string "BPT" into $t4
    	
    	beq $a0, $t1, check_Hgb    # Compare the values (not addresses) to see if they are equal
    	beq $a0, $t2, check_BGT    # Compare the values (not addresses) to see if they are equal
    	beq $a0, $t3, check_LDL    # Compare the values (not addresses) to see if they are equal
    	beq $a0, $t4, check_BPT    # Compare the values (not addresses) to see if they are equal
check_Hgb:

	# Load the floating-point test result from the memory into a floating-point register
	l.s $f1, test_result
	l.s $f2, Hgb_min
	l.s $f3, Hgb_max
	c.lt.s $f2, $f1          # Compare input with lower bound
	bc1f invalid_test        # Branch if input is less than lower bound
	c.lt.s $f1, $f3          # Compare input with upper bound
	bc1t append_patient              
check_BGT:

	# Load the floating-point test result from the memory into a floating-point register
	l.s $f1, test_result
	l.s $f2, BGT_min
	l.s $f3, BGT_max
	c.lt.s $f2, $f1          # Compare input with lower bound
	bc1f invalid_test        # Branch if input is less than lower bound
	c.lt.s $f1, $f3          # Compare input with upper bound
	bc1t append_patient          
	
check_LDL:

	# Load the floating-point test result from the memory into a floating-point register
	l.s $f1, test_result
	l.s $f2, LDL_min
	l.s $f3, LDL_max
	c.lt.s $f2, $f1          # Compare input with lower bound
	bc1f invalid_test        # Branch if input is less than lower bound
	c.lt.s $f1, $f3          # Compare input with upper bound
	bc1t append_patient          
			
check_BPT:

	# Load the floating-point test result from the memory into a floating-point register
	l.s $f1, test_result
	l.s $f2, BPT_min
	l.s $f3, BPT_max
	c.lt.s $f2, $f1          # Compare input with lower bound
	bc1f invalid_test        # Branch if input is less than lower bound
	c.lt.s $f1, $f3          # Compare input with upper bound
	bc1t append_patient         
	 
invalid_test:
    # Handle case where input is out of range
    # This could involve displaying an error message or taking corrective action
    # For example:
    	li $v0, 4
    	la $a0, invalid_test_msg
    	syscall

    # Branch back to menu or appropriate handling code
    	j continue_add8

 	 	

#---------------------------------------------------------------------------------------
check_test_name:
	beq $t0,1,append_Hgb
	beq $t0,2,append_BGT
	beq $t0,3,append_LDL
	beq $t0,4,append_BPT
	
	li $v0,4
 	la $a0,no_such_choice
 	syscall
 	j continue_add2
 	
 append_Hgb:	
   	la $a0, test_name   	 # Load the address of test_name into $a0
   	la $a1, Hgb 		# Load the address of Hgb into $a1
 	jal append_test_name
 	la $a0, test_name
    
 	j continue_add3
 	
 append_BGT:	
   	la $a0, test_name   	# Load the address of test_name into $a0
   	la $a1, BGT   	# Load the address of BGT into $a1
 	jal append_test_name
 	j continue_add3
 	
 append_LDL:	
   	la $a0, test_name   	# Load the address of test_name into $a0
   	la $a1, LDL   	# Load the address of BGT into $a1
 	jal append_test_name
 	j continue_add3
 	
 append_BPT:	
   	la $a0, test_name   	# Load the address of test_name into $a0
 	la $a1,BPT
 	jal append_test_name
 	j continue_add3
 #-------------------------------------------------------------------------------------- 
search_by_ID:
	
	j menu	#return to the main menue
#---------------------------------------------------------------------------------------  	   			
 
append_patient:
    # Allocate space on the stack for $ra
    addi $sp, $sp, -4  
    # Save $ra on the stack    
    sw   $ra, 0($sp)
    
    # Load address of ID into $a1
    la $a1, ID
loopAppend1:	
	lb $t0,($a1)
	beqz $t0,do_append1
	addi $a1,$a1,1
	j loopAppend1   
do_append1:	 
    # Append a colon (':')
    li $t0, 58    # ASCII code for ':'
    sb $t0, ($a1)
    addi $a1, $a1, 1

    li $t0,32	# Ascii code for the space
    sb $t0,($a1)
    addi $a1,$a1,1
    
    # Append the test name
    la $a0, test_name
    jal append_string
    
    # Append a comma (',')
    li $t0, 44    # ASCII code for ','
    sb $t0, ($a1)
    addi $a1, $a1, 1
    
    li $t0,32	# Ascii code for the space
    sb $t0,($a1)
    addi $a1,$a1,1
    
    # Append the year
    la $a0, Year
    jal append_string
    
    # Append a hyphen ('-')
    li $t0, 45    # ASCII code for '-'
    sb $t0, ($a1)
    addi $a1, $a1, 1
    
    # Append the month
    la $a0, Month
    jal append_string
    
    # Append a comma (',')
    li $t0, 44    # ASCII code for ','
    sb $t0, ($a1)
    addi $a1, $a1, 1
    
    li $t0,32	# Ascii code for the space
    sb $t0,($a1)
    addi $a1,$a1,1
        
    # Append the test result
#  l.s $f1, test_result
#    jal convert_float_to_string 
#    jal append_string
     
    
    # Print a newline character
    li $v0, 11         # syscall code for print_character
    li $a0, 10         # ASCII code for newline
    syscall

    # Print the appended string (ID)
    la $a0, ID
    li $v0, 4          # syscall code for print_string
    syscall

    # Restore $ra from the stack
    lw   $ra, 0($sp)
    # Deallocate space on the stack
    addi $sp, $sp, 4
    # Return to the caller
    j menu
 

append_string:
    lb $t0, ($a0)      # Load byte from source address
    beqz $t0, finish_append_string   # If byte is zero, finish
    sb $t0, ($a1)      # Store byte to destination address
    addi $a0, $a0, 1  # Increment source address
    addi $a1, $a1, 1  # Increment destination address
    j append_string    # Repeat loop

finish_append_string:
    jr $ra             # Return


###----------------- This method used to append the number of choice of tests into test_name to hold the name-------------------

append_test_name:
    move $s0, $a0    # Load the address of test_name into $s0
    move $s1, $a1    # Load the address of Hgb into $s1
    
    # Loop to copy characters from Hgb to test_name
    copy_loop:
        lb $t0, 0($s1)        # Load a character from Hgb
        beq $t0, $zero, end_copy_loop        # If the character is null, we've reached the end of Hgb
        sb $t0, 0($s0)        # Store the character into test_name
        # Move to the next character in Hgb and test_name
        addi $s1, $s1, 1
        addi $s0, $s0, 1
        
        # Continue copying
        j copy_loop

end_copy_loop:    # End of loop

     # Append null terminator to test_name
        sb $zero, 0($s0)
       # Return from subroutine
    	jr $ra
#---------------------------------------------------------------------------
# This function take the address of a string in $a0
# Return 1 in $v1 if it is integer, 0 if not integer
check_integer:
	# Allocate space on the stack for $ra
	addi $sp, $sp, -4  
	# Save $ra on the stack    
	sw   $ra, 0($sp)  
	
	# Consider $v1 is the flag (1: yes, 0: no)
	li $v1,1
loop_check:	lb $t0,($a0)
	beq $t0,10,finish_check
	addi $a0,$a0,1
	blt $t0,48,not_integer
	bgt $t0,57,not_integer
	j loop_check
	
	not_integer:
		li $v1,0
	finish_check:
		# Restore $ra from the stack
        		lw   $ra, 0($sp)
        		# Deallocate space on the stack
        		addi $sp, $sp, 4
        		#back to where it was last used
        		jr   $ra 
#---------------------------------------------------------------------------

#  This function takes the address of the year in $a0 and checks
# if the ID is 4 digits ($v1 = 1) or not ($v1 = 0)
check_4digits:
	# Allocate space on the stack for $ra
	addi $sp, $sp, -4  
	# Save $ra on the stack    
	sw   $ra, 0($sp)  
	
	# Counter initlized to zero
	li $t1,0
	# Consider $v1 is the flag (1: yes, 0: no)
	li $v1,1   
loop_check22:	lb $t0,($a0)
	beq $t0,10,finish_check22
	addi $a0,$a0,1
	addi $t1,$t1,1
	j loop_check22
	
	finish_check22:
		beq $t1,4,end_check22
		li $v1,0
	end_check22:	
		# Restore $ra from the stack
        		lw   $ra, 0($sp)
        		# Deallocate space on the stack
        		addi $sp, $sp, 4
        		#back to where it was last used
        		jr   $ra 
        		
#---------------------------------------------------------------------------------------
#  This function takes the address of the ID in $a0 and checks
# if the ID is 7 digits ($v1 = 1) or not ($v1 = 0)
check_7digits:
	# Allocate space on the stack for $ra
	addi $sp, $sp, -4  
	# Save $ra on the stack    
	sw   $ra, 0($sp)  
	
	# Counter initlized to zero
	li $t1,0
	# Consider $v1 is the flag (1: yes, 0: no)
	li $v1,1   
loop_check2:	lb $t0,($a0)
	beq $t0,10,finish_check2
	addi $a0,$a0,1
	addi $t1,$t1,1
	j loop_check2
	
	finish_check2:
		beq $t1,7,end_check
		li $v1,0
	end_check:	
		# Restore $ra from the stack
        		lw   $ra, 0($sp)
        		# Deallocate space on the stack
        		addi $sp, $sp, 4
        		#back to where it was last used
        		jr   $ra 
#---------------------------------------------------------------------------
clear_string:
	# Allocate space on the stack for the temporary address
	addi $sp, $sp, -4   
	# Save the return address on the stack  
	sw $ra, ($sp)         
	
	# Load the first character of the string
	lb $s5, 0($a0)   
	# If the character is null, we are done     
	beqz $s5, doneclear        

loopclear:
	# Store null byte at the current address
	sb $zero, 0($a0)    
	# Increment the address by 1  
	addiu $a0, $a0, 1   
	# Load the next character  
	lb $s5, 0($a0)       
	# If the character is not null, continue looping
	bnez $s5, loopclear        

doneclear:
	# Restore the return address from the stack
	lw $ra, ($sp) 
	# Deallocate space on the stack        
	addi $sp, $sp, 4      
	# Return from the function
	jr $ra            
	   
#------------------------------------Year_to_Integer-------------------------------------------------------------
#-------- This method to convert the year into integer -----
Year_to_Integer:
	#this is a function to convert an ascii number
	#to integer, its address stored in $a0
	#return the number in $v1
	
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	
    	lb $t6,3($a0)
	lb $t7,2($a0)
	lb $t8,1($a0)
	lb $t9,0($a0)
	

four_Digit:
#2022
    # Convert each ASCII character representing a digit to its corresponding integer value
    addi $t6, $t6, -48   # Convert thousands digit
    addi $t7, $t7, -48   # Convert hundreds digit
    addi $t8, $t8, -48   # Convert tens digit
    addi $t9, $t9, -48   # Convert ones digit
    
    # Combine the individual digits to form the four-digit year
    mul $t7, $t7, 10     # Multiply the hundreds digit by 10
    mul $t8, $t8, 100    # Multiply the tens digit by 100
    mul $t9, $t9, 1000   # Multiply the ones digit by 1000
    
    add $v1, $t6, $t7    # Add thousands and hundreds
    add $v1, $v1, $t8    # Add tens
    add $v1, $v1, $t9    # Add ones

    move $t0, $v1
    jr $ra 
#------------------------Month_to_Integer-----------------------------------------
Month_to_Integer:
	#this is a function to convert an ascii number
	#to integer, its address stored in $a0
	#return the number in $v1
	
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	
	lb $t8,0($a0)
	lb $t9,1($a0)
	blt $t9,48,oneDigit
	bgt $t9,57,oneDigit
twoDigit:
	addi $t8,$t8,-48
	mul $t8,$t8,10
	addi $t9,$t9,-48
	add $v1,$t8,$t9
	
  	move $t1, $v1

  	# Restore the return address from the stack
	lw $ra, ($sp) 
	# Deallocate space on the stack        
	addi $sp, $sp, 4      
	# Return from the function
	jr $ra 
oneDigit:
	addi $t8,$t8,-48
	move $v1,$t8
    	# Add leading zero to the month string
    	li $t2, 48              # Load ASCII '0' into $t2
    	sb $t2, ($a0)           # Store '0' in the month string
    	addi $a0, $a0, 1        # Move to the next index in the month string

   	 # Convert the single digit to ASCII
    	addi $t8, $t8, 48       # Convert the single digit to ASCII
    	sb $t8, ($a0)           # Store the single digit in the month string
    	addi $a0, $a0, 1        # Move to the next index in the month string

        move $t1, $v1
	
	# Restore the return address from the stack
	lw $ra, ($sp) 
	# Deallocate space on the stack        
	addi $sp, $sp, 4      
	# Return from the function
	jr $ra 


#--------------------------------------------------------------------------------
strcmp:  		
	loop1:
		# Load byte from string1
 		lb $s5, ($a0)   
 		# Load byte from string2  	
		lb $s6, ($a1)    
		#If end of string1, strings are equal 	
		beqz $s5, equal   
		# If end of string2, strings are not equal	
		beqz $s6, notequal 
		# If bytes are not equal, strings are not equal
		bne $s5, $s6, notequal 
		# Increment string1 pointer
		addi $a0, $a0, 1 
		# Increment string2 pointer	
		addi $a1, $a1, 1 	
		# Jump to loop1
		j loop1           	
	equal:
		# Set return value to 1
		li $v0, 0  
		#Jump to done      	
		j done
		
		           	           	
	notequal:
		# Set return value to 0
		li $v0, 1  
		      	
	done:
		# Exit function
		jr $ra
		
#----------------------------------------------------------------

# This function takes a string that its address stored in $a0
# and removes the new line char from the end of the string
remove_newline:
	# Allocate space on the stack for $ra
	addi $sp, $sp, -4  
	# Save $ra on the stack    
	sw   $ra, 0($sp)   
	    
	 # Copy the address of the string to $t0
	addi $s5, $a0, 0   
	# Initialize counter to 0    
	addi $s6, $zero, 0     

	loop6:
	        # Load a byte from memory
		lbu  $s7, ($s5)   
		# If byte is newline character, exit loop     
		beq  $s7, 10, done3  
		# Increment address to next byte   
		addi $s5, $s5, 1   
		# Increment counter    
		addi $s6, $s6, 1       
		j    loop6

	done3:
	        # If the string is empty, exit function
		beq  $s6, $zero, end4   	
     		# Decrement counter to account for removed newline character
     		addi $s6, $s6, -1      
        	        # Set $t2 to 0 to explicitly set null terminator
        		addi $s7, $zero, 0
        		# Replace newline character with null terminator     
        		sb   $s7, ($s5)       

    	end4:
    	# Restore $ra from the stack
        	lw   $ra, 0($sp)
        	# Deallocate space on the stack
        	addi $sp, $sp, 4
        	jr   $ra #back to where it was last used. 
        	
 #------------------------------------------------------------------------------------			       	
exit_program:
    # Print a message to inform the user that the program is exiting
    li $v0, 4             		# system call code for printing a string
    la $a0, exit_msg      	# address of the message
    syscall                	# print the message
    
    # Exit program
    li $v0, 10       		# system call code for exit program             	
    syscall
    
    
# This my first comment
#Test