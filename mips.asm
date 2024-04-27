# Here we have the data section
.data
# Here we put the file path as the following form
 filename: .asciiz "C:\\Users\\Geinus\\Desktop\\Proj-Arch1Medical-Test-Management-System\\medical.txt"

# Here we have the data section
file_buffer: .space 1024

# Menue texts
menu_msg: .asciiz"\nWelcome to our System\n\n"
choice_1: .asciiz"1- Add new medical test\n"
choice_2: .asciiz"2- Search for a test by patiant ID\n"
choice_3: .asciiz"3- Searching for unnormal tests\n"
choice_4: .asciiz"4- Average test value\n"
choice_5: .asciiz"5- Update an existing test result\n"
choice_6: .asciiz"6- Delete a test\n"
choice_7: .asciiz"7- Exit from the program\n"
normal_string: .asciiz "normal\n"
print: .asciiz"********************************************\n"

output_message: .asciiz"hi program\n"

#Menue search_id
menu_prompt: .asciiz "# Menu - Search by Patient ID\nEnter your choice:\n1. Retrieve all patient tests\n2. Retrieve all abnormal patient tests\n3. Retrieve all patient tests in a specific period\n4. Back\n"

read_choice: .asciiz"Your choice: "
no_such_choice: .asciiz"There is no choice with this number, try again\n"
take_ID_msg: .asciiz"Enter the patiant ID: "
take_test_name:.asciiz"Select test name\n1- Hemoglobin (Hgb)\n2- Blood Glucose Test (BGT)\n3- Cholesterol Low-Density Lipoprotein\n4- Blood Pressure Test (BPT)\nEnter the number of the test only\nYour choice: "
take_year_msg: .asciiz"Enter the Year of the test : "
take_month_msg: .asciiz"Enter the Month of the test : "
take_test_result_msg: .asciiz"Enter the test result : "
not_integer_msg: .asciiz"The Entered value must be an integer number, try again...\n"
not_7digits_msg:.asciiz"The ID must be 7 digits only, try again...\n"
not_valid_year_msg: .asciiz"Not valid year number, try again ...\n"
not_integer_year: .asciiz"The year must be an integer number, try again...\n"
invalid_month_msg: .asciiz"Not valid month number, try again ...\n"
not_integer_month: .asciiz"The month must be an integer number, try again...\n"
not_4digits_msg:.asciiz"The Year must be 4 digits only, try again...\n"
exit_msg: .asciiz"Exitting from the program ...\n"
invalid_test_result_msg: .asciiz"Not valid test result, try again ...\n"
invalid_test_msg: .asciiz"Out of range test result, write it again...\n"
patientIDSearch_msg: .asciiz"Enter the patiant ID to search: "
not_found_message:  .asciiz "Patient ID not found.\n"
# Debug message
debug_message: .asciiz "Debug message \n"
# buffers
menue_space: .space 128 
test_name: .space 128 
menu_search_id: .space 128 
test_num: .space 128 
ID: .space 128
append_test: .space 128
Year: .space 128
Month: .space 128
test_result: .space 128
Hgb_min: .float 1.0
Hgb_max: .float 20.0
BGT_min: .float 1.0
BGT_max: .float 20.0
LDL_min: .float 1.0
LDL_max: .float 20.0
BPT_min: .float 1.0
BPT_max: .float 20.0

patientIDtemp:.space 128
result_buffer  : .space 1024 # to store the search
newline: .asciiz "\n"                    # New line character
line_buffer: .space 1024   # Buffer to hold a single line from the file
id_not_found_message: .asciiz "There is no medical file for this patient\n"
Hgb:.asciiz"Hgb"
BGT:.asciiz"BGT"
LDL:.asciiz"LDL"
BPT:.asciiz"BPT"
Systolic:.space 128
Systolic_msg:.asciiz"Enter Systolic Blood Pressure: "
Diastolic:.space 128
Diastolic_msg:.asciiz"Enter Diastolic Blood Pressure: "
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
    
	j menu	# jump to the menu
   
#----------------------------------------------------
menu:
	la $t1,ID
	li $t1,0
	# Print menu message
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
    	li $v0, 8                # system call code for reading an integer
    	la $a0,menue_space 
   	syscall                  # read the character from the console
   	   # Store the entered value in $t5
        move $t5, $v0        # Move the value from $v0 to $t5
    
   	
   	# Check if the ID is integer
	la $a0,menue_space 
	la $a1,menue_space 
	jal check_integer	#call the function
	
	# If the returned value ($v1) is 1 then continue
	beq $v1,1,GO
	
	# If the returned value ($v1) is 0 then try again
	li $v0,4
	la $a0,not_integer_msg
	syscall
	j menu
	
GO:
# If he chose choice 1
lb $t0, 0($a1)          # Load the first byte of the entered choice
lb $t1, 1($a1)          # Load the second byte of the entered choice
li $t2, '1'             # ASCII value of '1'
li $t4, '2'             # ASCII value of '1'
li $t3,10               # ASCII value of null terminator
j check_null



check_null:
beq $t1, $t3, Selection_check # Proceed to choice if only one byte was entered
j no_Selection_check 

Selection_check  :
beq $t0, $t2, Add_test  # If the first byte matches '1', proceed to choice 1
beq $t0, $t4, search_by_ID # If the first byte matches '2', proceed to choice 1
# If the second byte is null terminator, it's a single-digit choice

no_Selection_check :
# If the first byte doesn't match '1', or if the second byte is not null, it's an invalid choice
li $v0, 4
la $a0, no_such_choice
syscall
j menu                  # Go back to the menu


#---------------------------------------------------------------------------
Add_test:

        jal take_id
        jal take_testname
        jal take_year_month
        jal take_results

take_id:
	    # Allocate space on the stack for $ra
    addi $sp, $sp, -4  
    # Save $ra on the stack    
    sw   $ra, 0($sp)
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
	j take_id
	
continue_add:	

	# Check if the ID is 7 digits only
	la $a0,ID
	jal check_7digits	#call the function
			
	la $a0,ID
	jal remove_newline
	
	# If the ID is 7 digits then continue
	beq $v1,1,continue_add2
	
	# If it is not 7 digits then try again
	li $v0,4
	la $a0,not_7digits_msg
	syscall
	
	j take_id

continue_add2:
    # If the ID is valid, return
        # Restore $ra from the stack
    lw   $ra, 0($sp)
    # Deallocate space on the stack
    addi $sp, $sp, 4
    jr $ra               # Return
    
take_testname:    
	# Now lets move to the test name
    # Allocate space on the stack for $ra
    addi $sp, $sp, -4  
    # Save $ra on the stack    
    sw   $ra, 0($sp)
    
    		
	li $v0,4
	la $a0,take_test_name
	syscall
	

	# Read patiant test name from the user
	li $v0,8	# System call code for reading a string
	la $a0, test_num	# Store the read number 
	syscall
	
	# Check if the ID is integer
	la $a1,test_num
	jal check_integer	#call the function
	
	# If the returned value ($v1) is 1 then continue
	beq $v1,1,GO1
	
	# If the returned value ($v1) is 0 then try again
	li $v0,4
	la $a0,not_integer_msg
	syscall
	j take_testname
	
GO1:	
	j check_test_name
	

	
continue_add3:
    # Restore $ra from the stack
    lw   $ra, 0($sp)
    # Deallocate space on the stack
    addi $sp, $sp, 4
    jr $ra               # Return
    
    
take_year_month:	# Now lets take the date

    # Allocate space on the stack for $ra
    addi $sp, $sp, -4  
    # Save $ra on the stack    
    sw   $ra, 0($sp)
take_year:    
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
	la $a0,not_integer_year
	syscall
	j take_year
	
	
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
	j take_year

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
    bgt $t0, $t2, not_valid_year # If year is greater than 2024, not valid

    j continue_add6 # If the year is within the acceptable range, proceed to continue_add6

not_valid_year:
    # Print error message
    li $v0, 4
    la $a0, not_valid_year_msg
    syscall
    
    # Try again
    j take_year

continue_add6:
    # Now lets take the date (month)
    li $v0,4
    la $a0,take_month_msg
    syscall
    
    # Read month from the user
    li $v0,8    # System call code for reading a string
    la $a0, Month   # Store the read number in month
    syscall
    
    # Check if the month is integer
    la $a0,Month
    jal check_integer    #call the function
    
    # If the returned value ($v1) is 1 then continue
    beq $v1,1,continue_add7
    
    # If the returned value ($v1) is 0 then try again
    li $v0,4
    la $a0,not_integer_month
    syscall 
    
    # Return to adding month again
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
    # Print error message
    li $v0, 4
    la $a0, invalid_month_msg
    syscall                 
    
    # Return to adding month again
    j continue_add6

continue_add8:
    # Restore $ra from the stack
    lw   $ra, 0($sp)
    # Deallocate space on the stack
    addi $sp, $sp, 4
    jr $ra               # Return
################# NOTE THAT T1 IS THE MONTH

take_results:
        # Allocate space on the stack for $ra
    addi $sp, $sp, -4  
    # Save $ra on the stack    
    sw   $ra, 0($sp)
    
	la $a0,test_num
	jal remove_newline
	

    lb $t0, ($a0)  
    li $t1, 52      # ASCII value of '4'
    beq $t0, $t1, Bpt_test

    # If the comparison fails, jump to take_test
    j take_test
take_test:		
	# Now lets take the test result for the patient 
	li $v0,4
	la $a0,take_test_result_msg
	syscall
	
	li $v0,8	# System call code for reading a string
	la $a0, test_result	# Store the read number in ID
	syscall
	
	jal remove_newline
	jal check_float

	beq $v0, $zero, Invalid_test_result
	    # Load address of ID into $a1
        la $a1, ID
   	j append_patient
#...........................................................................................
Bpt_test:
    # Allocate space on the stack for $ra
    addi $sp, $sp, -4  
    # Save $ra on the stack    
    sw   $ra, 0($sp)
    
Systolic_label:    
    li $v0,4 
    la $a0,Systolic_msg
    syscall
    li $v0,8	# System call code for reading a string
    la $a0, Systolic	# Store the read number in ID
    syscall    

    la $a0,Systolic
    jal remove_newline
    jal check_float
    beq $v0, $zero, Invalid_Systolic_result    
    
Diastolic_label:            
    li $v0,4 
    la $a0,Diastolic_msg
    syscall
    li $v0,8	# System call code for reading a string
    la $a0, Diastolic	# Store the read number in ID
    syscall    
    
    la $a0,Diastolic
    jal remove_newline
    jal check_float
    beq $v0, $zero, Invalid_Diastolic_result                      

    # Load address of ID into $a1
    la $a1, ID
    jal append_patient


 #-------------------------------------------------------------------------------------- 
###################### OPTION 2 #########################################################
search_by_ID:

    # Display prompt to enter patient ID
    li $v0, 4
    la $a0, patientIDSearch_msg
    syscall
    
    # Read patient ID from user
    li $v0, 8
    la $a0, patientIDtemp
    syscall

	
     # Check if the ID is integer
     la $a0,patientIDtemp
     jal check_integer	   #call the function
	
     # If the returned value ($v1) is 1 then continue
     beq $v1,1,search1
	
     # If the returned value ($v1) is 0 then try again
     li $v0,4
     la $a0,not_integer_msg
     syscall
     j search_by_ID
	
search1:	
     # Check if the ID is 7 digits only
     la $a0,patientIDtemp
     jal check_7digits	#call the function
			
      # If the ID is 7 digits then continue
      beq $v1,1,search1_1
      
	
      # If it is not 7 digits then try again
      li $v0,4
      la $a0,not_7digits_msg
      syscall
      j search_by_ID
     
#---------------------------------------------------------------------------------------  	   		
search1_1:
      # print menue for search id 
      li $v0,4
      la $a0,menu_prompt
      syscall
      
      
        # Ask user to choose a choice
    	li $v0, 4	        # system call code for printing a string
    	la $a0, read_choice  # address of the message
    	syscall  

   
         # Read a number from the user
    	li $v0, 8                # system call code for reading an integer
    	la $a0,menu_search_id
    	la $a1,menu_search_id
   	syscall                  # read the character from the console
      
        # Check if the ID is integer
	la $a0,menu_search_id
	la $a1,menu_search_id
	jal check_integer	#call the function
	
	# If the returned value ($v1) is 1 then continue
	beq $v1,1,GO3
	
	# If the returned value ($v1) is 0 then try again
	li $v0,4
	la $a0,not_integer_msg
	syscall
	j search1_1
	
GO3:
# If he chose choice 1e choice 1
# If he chose choice 1
lb $t0, 0($a1)          # Load the first byte of the entered choice
lb $t1, 1($a1)          # Load the second byte of the entered choice
li $t2, '1'             # ASCII value of '1'
li $t4, '2'             # ASCII value of '1'
li $t5, '3'             # ASCII value of '1'
li $t6, '4'             # ASCII value of '1'
li $t3,10               # ASCII value of null terminator
j check_null2

check_null2:
beq $t1, $t3, Selection_check2 # Proceed to choice if only one byte was entered
j no_Selection_check2 

Selection_check2  :
beq $t0, $t2,  show_all_test # If the first byte matches '1', proceed to choice 1
beq $t0, $t4, show_test_normal# If the first byte matches '2', proceed to choice 1
beq $t0, $t5, show_test_from_date# If the first byte matches '2', proceed to choice 1
beq $t0, $t6, back_to_menue# If the first byte matches '2', proceed to choice 1
# If the second byte is null terminator, it's a single-digit choice
no_Selection_check2 :
# If the first byte doesn't match '1', or if the second byte is not null, it's an invalid choice
li $v0, 4
la $a0, no_such_choice
syscall
j search1_1                  # Go back to the menu

back_to_menue:
	j menu
show_all_test:
    # Set up pointers for search
    la $s0, file_buffer          # Load address of file_buffer
    move $s1, $s0                # Load address of result_buffer

    la $t7, patientIDtemp        # Load address of patientIDtemp
    li $t8, 0                    # Initialize flag to 0 (not found), if ID is found set to 1
    li $t2, 0                    # Counter for characters in ID

    la $a0, print
    li $v0, 4
    syscall

read_loop:
    lb $t0, 0($s0)               # Load a byte from buffer
    lb $t4, 0($t7)               # Load a byte from patientIDtemp

    beq $t0, $t4, continue_checking    # If characters match, continue checking
    beqz $t0, end                      # Check if end of buffer

    beq $t0, 10, next_line             # Check for end of line

    beq $t4, $zero, next_line         # Check for end of patient ID

    j next_line                         # If not, move to next line

continue_checking:
    addi $t2, $t2, 1                    # Increment character counter
    beq $t2, 7, set_flag                 # If ID found, set flag

    # Move to next character
    addi $s0, $s0, 1
    addi $t7, $t7, 1
    j read_loop

next_line:
    # Reset character counter for new line
    li $t2, 0
    addi $s0, $s0, 1
    move $s1, $s0                       # Load address of result_buffer
    la $t7, patientIDtemp               # Reload address of patientIDtemp
    j read_loop

set_flag:
    # Set flag indicating ID found
    li $t8, 1
    j print_line

print_line:
    # Load byte from memory address in $s1
    lb $t0, 0($s1)
   
    beqz $t0, end_print_line
    
    # Check if the byte is newline character
    beq $t0, 10, end_print_line
    
    # Print the character
    li $v0, 11         # syscall to print character
    move $a0, $t0      # Move byte to print into $a0
    syscall
    
    # Move to next byte
    addi $s1, $s1, 1
    
    # Continue printing characters
    j print_line

end_print_line:
    # Print newline character
    li $v0, 11     # Print newline character
    li $a0, 10
    syscall
    j read_loop

end:
    # If ID not found, print message
    beqz $t8, id_not_found
    
    la $a0, print
    li $v0, 4
    syscall
    j menu

id_not_found:
    # Print message indicating ID not found
    la $a0, id_not_found_message
    li $v0, 4
    syscall
    j menu


show_test_normal:

       # Set up pointers for search
    la $s0, file_buffer          # Load address of file_buffer
    move $s1, $s0                # Load address of result_buffer

    la $t7, patientIDtemp        # Load address of patientIDtemp
    li $t8, 0                    # Initialize flag to 0 (not found), if ID is found set to 1
    li $t2, 0                    # Counter for characters in ID
    li $t5, 0                    # Counter 
    la $a0, print
    li $v0, 4
    syscall

read_loop2:

    lb $t0, 0($s0)               # Load a byte from buffer
    lb $t4, 0($t7)               # Load a byte from patientIDtemp

    beq $t0, $t4, continue_checking2    # If characters match, continue checking
    beqz $t0, end2                      # Check if end2 of buffer

    beq $t0, 10, next_line2             # Check for end2 of line

    beq $t4, $zero, next_line2         # Check for end2 of patient ID

    j next_line2                         # If not, move to next line

continue_checking2:
    addi $t2, $t2, 1                    # Increment character counter
    beq $t2, 7, set_flag2                 # If ID found, set flag

    # Move to next character
    addi $s0, $s0, 1
    addi $t7, $t7, 1
    j read_loop2

next_line2:
    # Reset character counter for new line
    li $t2, 0
    addi $s0, $s0, 1
    move $s1, $s0                       # Load address of result_buffer
    la $t7, patientIDtemp               # Reload address of patientIDtemp
    j read_loop2

set_flag2:
    # Set flag indicating ID found
    li $t8, 1
    jal check_normality
     beq $v1,1,print_line2
     la $t7, patientIDtemp        # Load address of patientIDtemp
     j read_loop2

print_line2:
    # Load byte from memory address in $s11200430
    lb $t0, 0($s1)
   
    beqz $t0, end2_print_line2
    
    # Check if the byte is newline character
    beq $t0, 10, end2_print_line2
    
    # Print the character
    li $v0, 11         # syscall to print character
    move $a0, $t0      # Move byte to print into $a0
    syscall
    addi $t5, $t5, 1
    

    # Move to next byte
    addi $s1, $s1, 1
    
    # Continue printing characters
    j print_line2

end2_print_line2:
    # Print newline character
    li $v0, 11     # Print newline character
    li $a0, 10
    syscall
    la $t7, patientIDtemp        # Load address of patientIDtemp
    j read_loop2

end2:
    # If ID not found, print message
    beqz $t8, id_not_found2
    
    la $a0, print
    li $v0, 4
    syscall
    j menu

id_not_found2:
    # Print message indicating ID not found
    la $a0, id_not_found_message
    li $v0, 4
    syscall
   j menu
show_test_from_date:	
 	


#---------------------------------------------------------------------------------------
check_test_name:
# Check if the input is a single character
lb $t1, 1($a1)          # Load the second byte of the entered choice
li $t2, 10               # ASCII value of null terminator
beq $t1, $t2, check_single_character   # If only one byte was entered, proceed to check_single_character
j invalid_choice        # If more than one byte was entered, it's an invalid choice

# If only one byte was entered, check if it's '1' or '2'
check_single_character:
lb $t0, ($a1)           # Load the entered choice
beq $t0, '1', append_Hgb    # If the entered choice is '1', go to append_Hgb
beq $t0, '2', append_BGT    # If the entered choice is '2', go to append_BGT
beq $t0, '3', append_LDL    # If the entered choice is '3', go to append_LDL
beq $t0, '4', append_BPT    # If the entered choice is '4', go to append_BPT
j invalid_choice        # If the entered choice is neither '1' nor '2', it's an invalid choice

# Define your append functions (append_Hgb, append_BGT, etc.) here

# Label for invalid choice
invalid_choice:
li $v0, 4
la $a0, no_such_choice
syscall
j continue_add2   # Go back to the menu or appropriate section after displaying the message

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
 	
#----------------------------------------------------------------------------
  	
append_patient:
    # Clear the buffer
    li $t0, 0        # ASCII code for null terminator
    sb $t0, append_test       # Set the first byte of the buffer to null terminator

    # Load address of ID into $a1
    la $a1, append_test 
    # Append the test name
    la $a0, ID
    jal append_string
	 
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


    la $a2,test_num
    lb $t0, ($a2)  
    li $t1, 52      # ASCII value of '4'
    beq $t0, $t1, complete_BPT_append

    # If the comparison fails, jump to take_test
    j complete_append   
      
complete_append: 

    # Append the test result
    la $a0, test_result
    jal append_string
  
  # Manually add null terminator
li $t0, 0         # ASCII value of null terminator
sb $t0, ($a1)     # Store null terminator at the end of the string buffer
    # Print a newline character
    li $v0, 11         # syscall code for print_character
    li $a0, 10         # ASCII code for newline
    syscall

    # Print the appended string (ID)
    la $a0, test_result
    li $v0, 4          # syscall code for print_string
    syscall

    # Print a newline character
    li $v0, 11         # syscall code for print_character
    li $a0, 10         # ASCII code for newline
    syscall
    
    # Print a newline character
    li $v0, 11         # syscall code for print_character
    li $a0, 10         # ASCII code for newline
    syscall
    j AppendToFileBuffer
########################################################3
 
complete_BPT_append:

    # Append the test result
    la $a0, Systolic
    jal append_string
    
   # Append a comma (',')
    li $t0, 44    # ASCII code for ','
    sb $t0, ($a1)
    addi $a1, $a1, 1
    
    li $t0,32	# Ascii code for the space
    sb $t0,($a1)
    addi $a1,$a1,1  
       
    # Append the test result
    la $a0, Diastolic
    jal append_string    
    # Print a newline character
    li $v0, 11         # syscall code for print_character
    li $a0, 10         # ASCII code for newline
    syscall

    # Print the appended string (ID)
    la $a0, append_test
    li $v0, 4          # syscall code for print_string
    syscall

    # Print a newline character
    li $v0, 11         # syscall code for print_character
    li $a0, 10         # ASCII code for newline
    syscall
    
    # Print a newline character
    li $v0, 11         # syscall code for print_character
    li $a0, 10         # ASCII code for newline
    syscall

    j AppendToFileBuffer
    
    
append_string:
    lb $t0, ($a0)      # Load byte from source address
    beqz $t0, finish_append_string   # If byte is zero, finish
    sb $t0, ($a1)      # Store byte to destination address
    addi $a0, $a0, 1  # Increment source address
    addi $a1, $a1, 1  # Increment destination address
    j append_string    # Repeat loop

finish_append_string:
    jr $ra             # Return


#-------------------------------------------------------------------
AppendToFileBuffer:

  la $s3, append_test
  la $s1, file_buffer

  find_end:
    lb $t0, ($s1)
    beqz $t0, append_new_line
    addi $s1, $s1, 1
    j find_end

  append_new_line:
    li $t0, 10
    sb $t0, ($s1)
    addi $s1, $s1, 1


    copy_id:
      lb $t0, ($s3)
      sb $t0, ($s1)
      beqz $t0, end_append
      addi $s1, $s1, 1
      addi $s3, $s3, 1
      j copy_id

  end_append:
    sb $zero, ($s1)

  la $s0, file_buffer

  print_buffer:
    lb $t0, ($s0)
    beqz $t0, end_print
    li $v0, 11
    move $a0, $t0
    syscall
    addi $s0, $s0, 1
    j print_buffer

  end_print:
    j saveToFile


#------------------------------------------------------------------------------

saveToFile:
    # Close the file
    li $v0, 16          # System call for close file
    move $a0, $s0       # File descriptor
    syscall             # Close file
    
    # Open the file for writing with truncation
    li $v0, 13          # System call for open file
    la $a0, filename    # File name
    li $a1, 1          # Open for write mode with truncation
    syscall             # Open file
    move $s0, $v0       # Save file descriptor

    # Write content to the file
    li $v0, 15          # System call for write file
    move $a0, $s0       # File descriptor
    la $a1, file_buffer # Address of the content to write
    li $a2, 1024        # Length of the content (adjust as needed)
    syscall             # Write to file

    # Close the file
    li $v0, 16          # System call for close file
    move $a0, $s0       # File descriptor
    syscall             # Close file

    j menu              # Return
    
    
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
# Function to check if the input string is a valid float
# Input: $a0 - Pointer to the input string
# Output: $v0 = 1 if the input string is a valid float, $v0 = 0 otherwise
# Preserves: $t0, $t1, $t2, $t3, $t4
check_float:
    # Allocate space on the stack for $ra
    addi $sp, $sp, -4  
    # Save $ra on the stack    
    sw   $ra, 0($sp)

    li $v0, 1            # Assume it's a float
    li $t0, 0            # Counter for digits before decimal point
    li $t1, 0            # Counter for digits after decimal point
    li $t2, 0            # Flag to track if decimal point encountered

check_digit:
    lb $t3, ($a0)         # Load the ASCII character into $t3

    beqz $t3, end_check  # If it's end of string, return 1
    beq $t3, 46, check_decimal  # Branch if it's a decimal point
    li $t4, 48           # ASCII code for '0'
    blt $t3, $t4, invalid_input  # Branch if it's not a digit
    li $t4, 57           # ASCII code for '9'
    bgt $t3, $t4, invalid_input  # Branch if it's not a digit

    j read_integer

check_decimal:
    beq $t2, 1, invalid_input  # If decimal point already encountered, it's invalid
    li $t2, 1            # Set decimal point flag
    addi $a0, $a0, 1     # Move pointer to the next character

    j check_digit

add_decimal_zero:
    li $t2, 1            # Set decimal point flag
    
add_test:
	lb $t0,($a0)
	beqz $t0,do
	addi $a0,$a0,1
	j add_test 
do:	
    li $t0, 46           # ASCII code for '.'
    sb $t0, ($a0)        # Store decimal point in test_result
    addi $a0, $a0, 1     # Move pointer to the next character

    li $t0, 48           # ASCII code for '0'
    sb $t0, ($a0)        # Store '0' after the decimal point
    addi $a0, $a0, 1     # Move pointer to the next character

    j end_check

read_integer:
    addi $a0, $a0, 1     # Increment digit counter
    j check_digit

invalid_input:
    li $v0, 0            # Set $v0 to 0 (not a float)
    j end_check

end_check:

    beqz $t2,add_decimal_zero
    # Restore $ra from the stack
    lw   $ra, 0($sp)
    # Deallocate space on the stack
    addi $sp, $sp, 4
    jr $ra               # Return


#--------------------------------------------------------------------------  	   			

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
	move $t5,$t0
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
		beq $t1,7,end_check11
		li $v1,0
	end_check11:	
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
Invalid_test_result:
    # Print error message for invalid test result
    li $v0, 4               # System call code for printing string
    la $a0, invalid_test_result_msg
    syscall
    
    j take_results  
        
Invalid_Systolic_result:

    li $v0, 4               # System call code for printing string
    la $a0,invalid_test_result_msg
    syscall
    
    j Systolic_label  
Invalid_Diastolic_result:
       
    li $v0, 4               # System call code for printing string
    la $a0, invalid_test_result_msg
    syscall
    
    j Diastolic_label        	
        	
 #------------------------------------------------------------------------------------			       	
exit_program:
    # Print a message to inform the user that the program is exiting
    li $v0, 4             		# system call code for printing a string
    la $a0, exit_msg      	# address of the message
    syscall                	# print the message
    
    # Exit program
    li $v0, 10       		# system call code for exit program             	
    syscall
#-----------------------------------------------------------------------------------

#-----------------------function normal or nor normal------------------------------------------------------------
check_normality:
	# Allocate space on the stack for $ra
	addi $sp, $sp, -4  
	# Save $ra on the stack    
	sw   $ra, 0($sp)  
	
	# Counter initlized to zero
	li $t1,0
	li $v1,0

check:

    lb $t0, 9($s1)         # Load the first byte from buffer

    # Check the value of $t0
    beq $t0, 72, end2_check  # If H, print Hgb
    beq $t0, 76, end2_check2 # If L, print LDL
    beq $t0, 66, check_B    # If B, check the second byte

    j end2_check             # Jump to the end2 if none of the above conditions are met

check_B:
    lb $t1, 10($s1)         # Load the second byte from buffer
    beq $t1, 71, end2_check3# If G, print BGT
    beq $t1, 80, end2_check4 # If P, print BPT
    j end2_check             # Jump to the end2 if the second byte is neither G nor P


end2_check:
    # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $t2, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
   move $t2 ,$s1 
    
    # Load the first byte
    lb $t0, 23($t2)
    # Check if the first byte is 49 (ASCII value for '1')
    li $t8, 49
    bne $t0, $t8, not_normal   # If not 49, jump to not_normal

    li $t3, 0              # Initialize $t3 to store the sum
    
    
sum_loop:
    lb $t0, 23($t2)         # Load a byte from buffer
    beq $t0, '.', check_sum   # If '.' is found, check the sum
    add $t3, $t3, $t0      # Add the byte to the sum
    addi $t2, $t2, 1       # Move to the next byte
    j sum_loop
    
check_sum:
    # Check if the sum is greater than 100 and less than 104
    li $t4, 100            # Load 100 into $t4
    blt $t3, $t4, not_normal   # If sum < 100, jump to not_normal
    li $t5, 104            # Load 104 into $t5
    bgt $t3, $t5, not_normal   # If sum > 104, jump to not_normal
    
    # If sum is 100 or 104, perform additional checks
    beq $t3, $t4, check_decimal_100
      beq $t3, $t5, check_decimal_104
  #  beq $t3, $t5, check_decimal_104

    # If sum is between 100 and 104, print "normal"
    li $v0, 4               # syscall to print string
    la $a0, normal_string   # Load the address of the string
    syscall
    j end2_check11
    
check_decimal_100:
    # Load the next byte after '.' and check if it meets the condition for sum 100
    addi $t2, $t2, 1       # Move to the next byte after '.'
    lb $t0, 23($t2)        # Load the byte after '.'
    
    # Check if the number after '.' is 56 or above for sum 100
    li $t6, 56             # Load 56 into $t6
    bge $t0, $t6, print_normal   # If number >= 56, jump to print_normal
    j not_normal    
    
check_decimal_104:
    # Load the next byte after '.' and check if it meets the condition for sum 104
    addi $t2, $t2, 1       # Move to the next byte after '.'
    lb $t0, 23($t2)        # Load the byte after '.'
    
    # Check if the number after '.' is 50 or above for sum 104
    li $t7, 50             # Load 50 into $t7
    ble $t0, $t7, print_normal   # If number >= 50, jump to print_normal
    j not_normal
        
print_normal :

    li $v1,1
    j end2_check11
    
not_normal:

    li $v1,0
    j end2_check11


end2_program:
    # Exit program
    li $v0, 10          # syscall code for exit
    syscall
    # Continue with your code logic here
    
end2_check2:
    # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $t2, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    
      # Load the first byte
    lb $t0, 23($t2)
    
        # Check if the first byte is in the specified range
    li $t4, 49             # ASCII value for '1'
    li $t5, 57             # ASCII value for '9'
    li $t6, 53             # ASCII value for '5'
    li $t7, 54             # ASCII value for '6'
    li $t8, 55             # ASCII value for '7'
    li $t9, 56             # ASCII value for '8'
    li $t3, 0              # Initialize $t3 to store the sum
    

check_first_byte:

    beq $t0, $t4, sum_loop2
    beq $t0, $t5, sum_loop2
    beq $t0, $t6,sum_loop2
    beq $t0, $t7,sum_loop2
    beq $t0, $t8, sum_loop2
    beq $t0, $t9, sum_loop2
    
    j not_normal 
    
sum_loop2:
    lb $t0, 23($t2)         # Load a byte from buffer
    beq $t0, '.', check_sum2   # If '.' is found, check the sum
    add $t3, $t3, $t0      # Add the byte to the sum
    addi $t2, $t2, 1       # Move to the next byte
    j sum_loop2
    
check_sum2:
    # Check if the sum is greater than 100 and less than 104
    li $t4, 145            # Load 100 into $t4
    bgt $t3, $t4, not_normal   # If sum > 104, jump to not_normal
    li $t5, 101            # Load 104 into $t5
    blt $t3, $t5, not_normal   # If sum > 104, jump to not_normal

    # If sum is between 100 and 104, print "normal"
    beq $t3, $t4, check_decimal_101
    j print_normal 
    
check_decimal_101:
    # Load the next byte after '.' and check if it meets the condition for sum 100
    addi $t2, $t2, 1       # Move to the next byte after '.'
    lb $t0, 23($t2)        # Load the byte after '.'
    
    # Check if the number after '.' is 56 or above for sum 100
    li $t6, 48             # Load 56 into $t6
    beq $t0, $t6, print_normal   # If number >= 56, jump to print_normal
    j not_normal    
    
           

end2_check3:
    # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $t2, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    
    
    # Load the first byte
    lb $t0, 23($t2)
    
    # Check if the first byte is in the specified range

    li $t5, 55             # ASCII value for '7'
    li $t6, 56             # ASCII value for '8'
    li $t7, 57             # ASCII value for '9'
    li $t3, 0              # Initialize $t3 to store the sum
    

    beq $t0, $t5, sum_loop3
    beq $t0, $t6,sum_loop3
    beq $t0, $t7,sum_loop3
    
    j not_normal 

    
sum_loop3:
    lb $t0, 23($t2)         # Load a byte from buffer
    beq $t0, '.', check_sum3   # If '.' is found, check the sum
    add $t3, $t3, $t0      # Add the byte to the sum
    addi $t2, $t2, 1       # Move to the next byte
    j sum_loop3
    
check_sum3:
    # Check if the sum is greater than 100 and less than 104
    li $t4, 103            # Load 100 into $t4
    blt $t3, $t4, not_normal   # If sum < 100, jump to not_normal
    li $t5, 114            # Load 104 into $t5
    bgt $t3, $t5, not_normal   # If sum > 104, jump to not_normal

    beq $t3, $t5, check_decimal_114

    j print_normal 
    
check_decimal_114:
    # Load the next byte after '.' and check if it meets the condition for sum 100
    addi $t2, $t2, 1       # Move to the next byte after '.'
    lb $t0, 23($t2)        # Load the byte after '.'
    
    # Check if the number after '.' is 56 or above for sum 100
    li $t6, 48             # Load 56 into $t6
    beq $t0, $t6, print_normal   # If number >= 56, jump to print_normal
    j not_normal    
    
end2_check4:
	li $t9,0
    # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $t2, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer

    
    # Load the first byte
    lb $t0, 23($t2)
    

    li $t5, 48             # ASCII value for '0'
    li $t3, 0              # Initialize $t3 to store the sum
    
   bne $t0, $t5, sum_loop4
       j not_normal 
       
sum_loop4:
    lb $t0, 23($t2)         # Load a byte from buffer
    beq $t0, '.', check_sum4   # If '.' is found, check the sum
    add $t3, $t3, $t0      # Add the byte to the sum
    addi $t9,$t9,1
    addi $t2, $t2, 1       # Move to the next byte
    j sum_loop4
    
check_sum4:
    # Check if the sum is greater than 100 and less than 104
    li $t4, 105            # Load 100 into $t4
    blt $t3, $t4, not_normal   # If sum < 100, jump to not_normal
    li $t5, 147           # Load 104 into $t5
    bgt $t3, $t5, not_normal   # If sum > 104, jump to not_normal

    beq $t3, $t5, check_decimal_147

    j end2_check5

check_decimal_147:
    # Load the next byte after '.' and check if it meets the condition for sum 100
    addi $t2, $t2, 1       # Move to the next byte after '.'
    lb $t0, 23($t2)        # Load the byte after '.'
    
    # Check if the number after '.' is 56 or above for sum 100
    li $t6, 48             # Load 56 into $t6
    beq $t0, $t6, end2_check5  # If number >= 56, jump to print_normal
    j not_normal    

end2_check5:
	
    # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $t2, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer

     beq $t9,2,cond2  
    # Load the first byte
    lb $t0, 30($t2)   
        li $t3, 0              # Initialize $t3 to store the sum

 

   # Check if the first byte is in the specified range
           lb $t0, 30($t2)         # Load a byte from buffer
    li $t5, 54            # ASCII value for '6'
    li $t6, 55             # ASCII value for '7'
    li $t8, 56             # ASCII value for '8'
    li $t3, 0              # Initialize $t3 to store the sum

    beq $t0, $t5, sum_loop5
    beq $t0, $t6,sum_loop5
    beq $t0, $t8,sum_loop5
    
    j not_normal 
sum_loop5:    
    lb $t0, 30($t2)         # Load a byte from buffer
    beq $t0, '.', check_sum5   # If '.' is found, check the sum
    add $t3, $t3, $t0      # Add the byte to the sum
    addi $t2, $t2, 1       # Move to the next byte
    j sum_loop5
 cond2:
    # Check if the first byte is in the specified rang
        lb $t0, 29($t2)         # Load a byte from buffer
        
    li $t5, 54            # ASCII value for '6'
    li $t6, 55             # ASCII value for '7'
    li $t8, 56             # ASCII value for '8'
    li $t3, 0              # Initialize $t3 to store 

    beq $t0, $t5, done_cond
    beq $t0, $t6,done_cond
    beq $t0, $t8,done_cond
    
    j not_normal 
    
done_cond:
    
     lb $t0, 29($t2)         # Load a byte from buffer
    beq $t0, '.', check_sum5   # If '.' is found, check the sum
    add $t3, $t3, $t0      # Add the byte to the sum
    addi $t2, $t2, 1       # Move to the next byte
    j done_cond
    
check_decimal_104_2:
    # Load the next byte after '.' and check if it meets the condition for sum 100
    addi $t2, $t2, 1       # Move to the next byte after '.'
    lb $t0, 30($t2)        # Load the byte after '.'
    
    # Check if the number after '.' is 56 or above for sum 100
    li $t6, 48             # Load 56 into $t6
    beq $t0, $t6, print_normal   # If number >= 56, jump to print_normal
    j not_normal    
        
check_sum5:
    # Check if the sum is greater than 100 and less than 104
    li $t4, 102            # Load 100 into $t4
    blt $t3, $t4, not_normal   # If sum < 100, jump to not_normal
    li $t5, 104            # Load 104 into $t5
    bgt $t3, $t5, not_normal   # If sum > 104, jump to not_normal

    beq $t3, $t5, check_decimal_104_3

    j print_normal 
    
check_decimal_104_3:
    # Load the next byte after '.' and check if it meets the condition for sum 100
    addi $t2, $t2, 1       # Move to the next byte after '.'
    lb $t0, 29($t2)        # Load the byte after '.'
    
    # Check if the number after '.' is 56 or above for sum 100
    li $t6, 48             # Load 56 into $t6
    beq $t0, $t6, print_normal   # If number >= 56, jump to print_normal
    j not_normal    
              
     end2_check11:		

		# Restore $ra from the stack
        		lw   $ra, 0($sp)
        		# Deallocate space on the stack
        		addi $sp, $sp, 4
        		#back to where it was last used
        		jr   $ra 
        		
        		
#--------------------------------------------------------------------------------------------        		
 