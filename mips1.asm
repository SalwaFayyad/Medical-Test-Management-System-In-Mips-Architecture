
#         **********************************************************************
#         *          Medical Test Management System in MIPS Assembly           *
#         *                                                                    *
#         *	          .........> Students <...... 		               *
#         *		  SALWA FATYYAD	      1200430   	               *
#         *		  REBAL ZABADE 	      1210162	                       *
#         *                                                                    *
#         **********************************************************************
.data   
    # Here we put the file path as the following form
    filename:                   .asciiz "C:\\Users\\User\\New folder\\medical.txt"
    #filename:                   .asciiz "C:\\Users\\Geinus\\Desktop\\Proj-Arch1Medical-Test-Management-System\\medical.txt"
file_buffer:                    .space  1024
search_buffer:                  .space  1024                                                                                                                                                                                                                                                                                            #the buffer store the searched results
deleted_line_buffer:            .space  128                                                                                                                                                                                                                                                                                             # the line want delete it
deleted_buffer:                 .space  1024                                                                                                                                                                                                                                                                                            # result buffer after delete and update
deleted_line:                   .space  4                                                                                                                                                                                                                                                                                               # to store the number of line
result:                         .word   0
menue_space:                    .space  128
test_name:                      .space  128
menu_search_id:                 .space  128
test_num:                       .space  128
ID:                             .space  128
append_test:                    .space  128
Year:                           .space  128
Month:                          .space  128
test_result:                    .space  1024
patientIDtemp:                  .space  128
search_date:                    .space  128
result_buffer:                  .space  1024                                                                                                                                                                                                                                                                                            # to store the search
ID_testname_append:             .space  128
Hgb_buffer:                     .space  2048
BGT_buffer:                     .space  2048
LDL_buffer:                     .space  2048
BPT_buffer:                     .space  2048
year1:                          .space  128
year2:                          .space  128
month1:                         .space  128
month2:                         .space  128
search_year:                    .space  128
search_month:                   .space  128
Diastolic:                      .space  1024
Systolic:                       .space  1024
tempbuffer:                     .space  4
    # Menue texts
menu_msg:                       .asciiz "\n           Welcome to our System\n"
choice_1:                       .asciiz "1- Add new medical test\n"
choice_2:                       .asciiz "2- Search for a test by patiant ID\n"
choice_3:                       .asciiz "3- Searching for unnormal tests\n"
choice_4:                       .asciiz "4- Average test value\n"
choice_5:                       .asciiz "5- Update an existing test result\n"
choice_6:                       .asciiz "6- Delete a test\n"
choice_7:                       .asciiz "7- Exit from the program\n"
print:                          .asciiz "********************************************\n"
file_error_message:             .asciiz "Error: File not found or could not be opened.\n"
menu_prompt:                    .asciiz "********************************************\n# Menu - Search by Patient ID\nEnter your choice:\n1. Retrieve all patient tests\n2. Retrieve all abnormal patient tests\n3. Retrieve all patient tests in a specific period\n4. Back\n********************************************\n"
read_choice:                    .asciiz "Your choice: "
no_such_choice:                 .asciiz "There is no choice with this number, try again\n"
take_ID_msg:                    .asciiz "Enter the patiant ID: "
take_test_name:                 .asciiz "********************************************\nSelect test name\n1- Hemoglobin (Hgb)\n2- Blood Glucose Test (BGT)\n3- Cholesterol Low-Density Lipoprotein(LDL)\n4- Blood Pressure Test (BPT)\nEnter the number of the test only\n********************************************\nYour choice: "
take_year_msg:                  .asciiz "Enter the Year of the test : "
take_month_msg:                 .asciiz "Enter the Month of the test : "
take_test_result_msg:           .asciiz "Enter the test result : "
not_integer_msg:                .asciiz "The Entered value must be an integer number, try again...\n"
not_7digits_msg:                .asciiz "The ID must be 7 digits only, try again...\n"
not_valid_year_msg:             .asciiz "Not valid year number, try again ...\n"
not_integer_year:               .asciiz "The year must be an integer number, try again...\n"
invalid_month_msg:              .asciiz "Not valid month number, try again ...\n"
not_integer_month:              .asciiz "The month must be an integer number, try again...\n"
not_4digits_msg:                .asciiz "The Year must be 4 digits only, try again...\n"
exit_msg:                       .asciiz "             Exitting from our program\n             Greeting with SALWA & REBAL \n"
invalid_test_result_msg:        .asciiz "Not valid test result, try again ...\n"
patientIDSearch_msg:            .asciiz "Enter the patiant ID to search: "
not_found_message:              .asciiz "Patient ID not found.\n"
enter_deleted_line_msg:         .asciiz "Enter number of line want : "
id_not_found_message:           .asciiz "There is no medical file for this patient\n"
Systolic_msg:                   .asciiz "Enter Systolic Blood Pressure: "
Diastolic_msg:                  .asciiz "Enter Diastolic Blood Pressure: "
less_than_or_equal_zero_msg:    .asciiz "Error: The entered line number must be greater than 0.\n"
greater_than_t3_msg:            .asciiz "Error: The entered line number exceeds the maximum line number.\n"
Avg_Hgb:                        .asciiz "\nThe Average value for medical Test Hgb =  "
Avg_BGT:                        .asciiz "\nThe Average value for medical Test BGT =  "
Avg_LDL:                        .asciiz "\nThe Average value for medical Test LDL =  "
Avg_BPT1:                       .asciiz "\nThe Average value for medical Test BPT (Systolic Blood Pressure) =  "
Avg_BPT2:                       .asciiz "\nThe Average value for medical Test BPT (Diastolic Blood Pressure) =  "
Hgb:                            .asciiz "Hgb"
BGT:                            .asciiz "BGT"
LDL:                            .asciiz "LDL"
BPT:                            .asciiz "BPT"  
#*****************************************************************************************
.text
.globl	main
main:
	# Open a file for reading
	li $v0, 13		# Branch if file opened successfully
	la $a0, filename
	li $a1, 0
	syscall
	
	bgez $v0, file_opened   # Branch if file opened successfully
	# File not found or error occurred	
	li $v0, 4           	# Print string system call
	la $a0, file_error_message
	syscall

	j exit_program		# Jump to exit program

	file_opened:	
    	move $s0, $v0   	# Save the file descriptor

    	# Read from file
    	li $v0, 14
    	move $a0, $s0     	# File descriptor
    	la $a1, file_buffer    # Store file content into the buffer
    	li $a2, 1024           # Hardcoded input length
    	syscall

    	# Close the file 
    	li $v0, 16
    	move $a0, $s0
    	syscall

    	j menu          # Jump to the menu
#----------------------------------------------------
menu:
	la $t1,ID
	li $t1,0
	li $v0, 4
    	la $a0, menu_msg
    	syscall                
        la $a0, print
        li $v0, 4
        syscall    	
    	li $v0, 4
    	la $a0, choice_1
    	syscall    
    	
    	li $v0, 4
    	la $a0, choice_2
    	syscall  
    	
    	li $v0, 4
    	la $a0, choice_3
    	syscall  
    	
    	li $v0, 4
    	la $a0, choice_4
    	syscall  
    	
    	li $v0, 4
    	la $a0, choice_5
    	syscall  
    	
    	li $v0, 4
    	la $a0, choice_6
    	syscall  
    	
    	li $v0, 4
    	la $a0, choice_7
    	syscall  
    	
        la $a0, print
        li $v0, 4
        syscall	
           	
    	li $v0, 4
    	la $a0, read_choice
    	syscall  
    	
    	li $v0, 8
    	la $a0,menue_space 
   	syscall                  
        move $t5, $v0
   
	la $a0,menue_space 
	la $a1,menue_space 
	jal check_integer	

	beq $v1,1,GO	# If the returned value ($v1) is 1 then continue
	
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
	li $t4, '2'             # ASCII value of '2'
	li $t5, '3'             # ASCII value of '3'
	li $t6, '4'             # ASCII value of '4'
	li $t7, '5'             # ASCII value of '5'
	li $t8, '6'             # ASCII value of '6'
	li $t9,'7'

	li $t3,10               # ASCII value of null terminator
	j check_null
	
check_null:
	beq $t1, $t3, Selection_check # Proceed to choice if only one byte was entered
	j no_Selection_check 

Selection_check  :
	beq $t0, $t2, Add_test
	beq $t0, $t4, search_by_ID
	beq $t0, $t5, search_unnormal
	beq $t0, $t6, cal_Avg
	beq $t0, $t7, Delete_update_process
	beq $t0, $t8, Delete_update_process
	beq $t0, $t9, exit_program

no_Selection_check :
	li $v0, 4
	la $a0, no_such_choice
	syscall
	j menu         
##############################Add_test############################################
Add_test:
        jal take_id
        jal take_testname
        jal take_year_month
        jal take_results
        
        # Load address of ID into $a1
        la $a1, ID
   	j append_patient
take_id:
    	addi $sp, $sp, -4	# Allocate space on the stack for $ra
    	sw   $ra, 0($sp)  	# Save $ra on the stack    

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
	# Check if the ID is 7 digits onl
	la $a0,ID
	jal check_7digits	#call the function
	la $a0,ID
	jal remove_newline			
	beq $v1,1,continue_add2 	# If the ID is 7 digits then continue
	# If it is not 7 digits then try again
	li $v0,4
	la $a0,not_7digits_msg
	syscall
	j take_id

continue_add2:
  	# If the ID is valid, return
	lw   $ra, 0($sp)    # Restore $ra from the stack
	addi $sp, $sp, 4    # Deallocate space on the stack
  	jr $ra              # Return
    
take_testname:    
	# Now lets move to the test name
	addi $sp, $sp, -4      # Allocate space on the stack for $ra
	sw   $ra, 0($sp)       # Save $ra on the stack    
    	
	li $v0,4
	la $a0,take_test_name
	syscall
	
	# Read patiant test name from the user
	li $v0,8	# System call code for reading a string
	la $a0, test_num	# Store the read number 
	syscall
	
	la $a1,test_num
	jal check_integer	#call the function
	
	beq $v1,1,GO1
	
	li $v0,4
	la $a0,not_integer_msg
	syscall
	j take_testname
	
GO1:	
	j check_test_name
	
continue_add3:
	lw   $ra, 0($sp)
	addi $sp, $sp, 4     # Deallocate space on the stack
 	jr $ra               # Return
       
take_year_month:	# Now lets take the date
        addi $sp, $sp, -4      # Allocate space on the stack for $ra
        sw   $ra, 0($sp)        # Save $ra on the stack    
    
take_year:    
	li $v0,4
	la $a0,take_year_msg
	syscall
	
	# Read year from the user
	li $v0,8	# System call code for reading a string
	la $a0, Year	# Store the read number in year
	syscall
	
	la $a0,Year
	jal check_integer	#call the function
	
	beq $v1,1,continue_add4		# If the returned value ($v1) is 1 then continue
	
	li $v0,4	# If the returned value ($v1) is 0 then try again
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

continue_add5:
    	la $a0, Year           	# Load the address of the string (Year) into $a0    
    	jal remove_newline
    	jal strToInt    	# Call the to_integer function to convert the string to an integer
    	move $t0, $v1    	# Retrieve the integer value returned from to_integer
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
	j take_year 	# Try again

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
    	#Call the to_integer function to convert the string to an integer
    	jal Month_to_Integer
    	move $t1, $v1
    	li $t2, 1               # Lower bound of the acceptable range
    	li $t3, 12              # Upper bound of the acceptable range
    	blt $t1, $t2, invalid_month # If month is less than 1, it's invalid
    	bgt $t1, $t3, invalid_month # If month is greater than 12, it's invalid
        j continue_add8                  # If the month is valid, return to the menu

invalid_month:
    	li $v0, 4    # Print error message
    	la $a0, invalid_month_msg
   	syscall                 
    	j continue_add6    # Return to adding month again

continue_add8:
   	 lw   $ra, 0($sp)     # Restore $ra from the stack
    	 addi $sp, $sp, 4    # Deallocate space on the stack
   	 jr $ra               # Return

Bpt_test:

Systolic_label:    
la $s0,Systolic
jal initialize_to_zero
    li $v0,4 
    la $a0,Systolic_msg
    syscall
    
    li $v0,8	# System call code for reading a string
    la $a0, Systolic	# Store the read number in ID
    syscall    

    jal remove_newline
    jal check_float
    beq $v0, $zero, Invalid_Systolic_result    
    
Diastolic_label:      
la $s0,Diastolic
jal initialize_to_zero
    li $v0,4 
    la $a0,Diastolic_msg
    syscall
    
    li $v0,8	# System call code for reading a string
    la $a0, Diastolic	# Store the read number in ID
    syscall    
    
    jal remove_newline
    jal check_float
    beq $v0, $zero, Invalid_Diastolic_result              

    lw   $ra, 0($sp)    # Restore $ra from the stack
    addi $sp, $sp, 4    # Deallocate space on the stack
    jr $ra               # Return

###################### OPTION 2 #########################################################
search_by_ID:

    jal take_id
    la $a0, ID
    la $a1, patientIDtemp

    li $t0, 0 # Initialize loop counter
    
    jal copy_loop
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
	
	lb $t0, 0($a1)          # Load the first byte of the entered choice

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

Selection_check2:
 
la $a0, tempbuffer
sb $t0,($a0)
jal strToInt

blt $v1,1,no_Selection_check2
bgt $v1,4,no_Selection_check2
beq $v1, 3, date_search 
beq $v1, 4, back_to_menue
j comple

no_Selection_check2 :
li $v0, 4
la $a0, no_such_choice
syscall
j search1_1                  # Go back to the menu

back_to_menue:
	j menu

date_search:    
   jal take_year_month	  
   la $t0, Year       
la $t1, year1  
year1loop:
  lb $t2, ($t0)  # Load byte from the memory location labeled 'Year' into $t2
  sb $t2, ($t1)  # Store byte into the memory location labeled 'year1'
  addi $t0, $t0, 1  # Increment the address of 'Year'
  addi $t1, $t1, 1  # Increment the address of 'year1'
  beqz $t2, endyear  # If the byte loaded was 0, exit the loop
  j year1loop  # Repeat the loop

endyear:  
la $t0, Month   
la $t1, month1
month1loop:
  lb $t2, ($t0)  # Load byte from the memory location labeled 'Year' into $t2
  sb $t2, ($t1)  # Store byte into the memory location labeled 'year1'
  addi $t0, $t0, 1  # Increment the address of 'Year'
  addi $t1, $t1, 1  # Increment the address of 'year1'
  beqz $t2, endmonth  # If the byte loaded was 0, exit the loop
  j month1loop  # Repeat the loop
  
endmonth:
jal take_year_month
la $t0, Year  
la $t1, year2  
year2loop:
 lb $t2, ($t0)  # Load byte from the memory location labeled 'Year' into $t2
  sb $t2, ($t1)  # Store byte into the memory location labeled 'year1'
  addi $t0, $t0, 1  # Increment the address of 'Year'
  addi $t1, $t1, 1  # Increment the address of 'year1'
  beqz $t2, end2year  # If the byte loaded was 0, exit the loop
  j year2loop  # Repeat the loop

end2year:  
la $t0, Month   
la $t1, month2

month2loop:
  lb $t2, ($t0)  # Load byte from the memory location labeled 'Year' into $t2
  sb $t2, ($t1)  # Store byte into the memory location labeled 'year1'
  addi $t0, $t0, 1  # Increment the address of 'Year'
  addi $t1, $t1, 1  # Increment the address of 'year1'
  beqz $t2, end2month  # If the byte loaded was 0, exit the loop
  j month2loop  # Repeat the loop

end2month:
	
la $a0,year1
jal strToInt
move $s3,$v1

la $a0,year2
jal strToInt
move $s4,$v1

beq $s3,$s4,checkmonth
bgt $s3,$s4,swapyears

j comple
########
swapyears:
la $t0, year1    # Load the address of str1 into $t0
la $t1, year2    # Load the address of str2 into $t1

# Swap the strings
swap_strings:
    lb $t2, ($t0)  # Load byte from str1 into $t2
    lb $t3, ($t1)  # Load byte from str2 into $t3
    sb $t3, ($t0)  # Store byte from str2 into str1
    sb $t2, ($t1)  # Store byte from str1 into str2
    addi $t0, $t0, 1  # Move to the next character in str1
    addi $t1, $t1, 1  # Move to the next character in str2
    bnez $t2, swap_strings  # If str1 is not null-terminated, continue swapping

j swapmonths

checkmonth:
la $a0,month1
jal Month_to_Integer
move $s3,$v1

la $a0,month2
jal Month_to_Integer
move $s4,$v1

bgt $s3,$s4,swapmonths
j comple


swapmonths:
la $t0, month1    # Load the address of str1 into $t0
la $t1, month2    # Load the address of str2 into $t1
# Swap the strings
swap2strings:
    lb $t2, ($t0)  # Load byte from str1 into $t2
    lb $t3, ($t1)  # Load byte from str2 into $t3
    sb $t3, ($t0)  # Store byte from str2 into str1
    sb $t2, ($t1)  # Store byte from str1 into str2
    addi $t0, $t0, 1  # Move to the next character in str1
    addi $t1, $t1, 1  # Move to the next character in str2
    bnez $t2, swap2strings  # If str1 is not null-terminated, continue swapping		
      					 										 																		 										 																		 										 																		 										 																		 										 																	 										 																		 										 																		 										 																		 										 																		 										 										
comple:
    # Set up pointers for search
    la $s0, file_buffer          # Load address of file_buffer
    move $s1, $s0                # Load address of result_buffer
    la $a0, print
    li $v0, 4
    syscall
    li $t8, 0                    # Initialize flag to 0 (not found), if ID is found set to 1

pp:
    la $t7, patientIDtemp        # Load address of patientIDtemp
    li $t2, 0                    # Counter for characters in ID

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

li $t2, '1'             # ASCII value of '1'
li $t4, '2'             # ASCII value of '1'
li $t5, '3'             # ASCII value of '1'
li $t6, '4'             # ASCII value of '1'

    la $a1,menu_search_id
    lb $t0, 0($a1)          # Load the first byte of the entered choice
        # important, we will print s1 in case 1
    beq $t0, $t2,  show_all_test # If the first byte matches '1', proceed to choice 1
    beq $t0, $t4, show_test_normal# If the first byte matches '2', proceed to choice 1
    beq $t0, $t5, show_test_from_date# If the first byte matches '2', proceed to choice 1
    beq $t0, $t6, back_to_menue# If the first byte matches '2', proceed to choice 1

show_all_test:
      li $t8, 1
      j print_line
    
#.......................
 show_test_normal:	 

     jal check_normality
     bne $v1,1,print_line
     la $t7, patientIDtemp        # Load address of patientIDtemp
     j pp
#.......................
show_test_from_date:	

    # Set up pointers for searching
    la $s3, year1    # Pointer for the search date
    la $s4,year2
    la $s2, result_buffer    # Pointer for the test data
    move $s2,$s1

    la $s5,search_year
    la $s6,search_month

search_date_in_line:
    # Set up pointers
    move $a0, $s2         # Pointer to the start of the line
    move $a1, $s3         # Pointer to the search year1
    
    # Initialize counters
    li $t0, 0             # Counter for characters in the line
    li $t1, 14            # Start searching from byte 14
    
    # Move to byte 14 in the line
    add $a0, $a0, $t1
    
loop:    # Loop through the line
    lb $t2, 0($a0)      # Load character from the line    
    sb $t2,($s5)    #store into checkyear

    beq $t0,3,check_year
    addi $a0, $a0, 1   # Move to next character in the line
    addi $s5, $s5, 1   # Move to next character in the search date
    addi $t0, $t0, 1   # Increment line counter
    j loop                

check_year:

la $a0,year1
jal strToInt
move $s3,$v1

la $a0,year2
jal strToInt
move $s4,$v1

la $a0,search_year
jal strToInt
move $s7,$v1

beq $s3,$s7, g2 
beq $s4,$s7, checkmonth2                      
blt $s7,$s3,not_found   # 
bgt $s7,$s4,not_found   # 

found:
    li $t8,1
    j print_line
    
not_found:
    j pp

g2:
 beq $s4,$s7, checkequalyear 
 j  checkmonth1  
#......................................................                        
checkmmonth:
addi $sp, $sp, -4  
sw   $ra, 0($sp)  

# here i stored the month in the line into search mont 
# byte 19 and byte 20 are the month
la $a0, search_month
lb $t0, 19($s1)  
sb $t0, ($a0)     

addi $a0, $a0, 1  
lb $t1, 20($s1)    
sb $t1, ($a0)  

la $a0,month1
jal Month_to_Integer
move $s3,$v1

la $a0,month2
jal Month_to_Integer
move $s4,$v1

la $a0, search_month
jal Month_to_Integer
move $s7,$v1

lw   $ra, 0($sp)
addi $sp, $sp, 4
jr   $ra 
#----------------------------------------
checkmonth1: # if the year of line = just year1
jal checkmmonth
blt $s7,$s3,not_found
j found
checkmonth2: # if the year of line just = year2
jal checkmmonth
bgt $s7,$s4,not_found
j found
checkequalyear: # if the year of line = year1 $ year2
jal checkmmonth
blt $s7,$s3,not_found   # 
bgt $s7,$s4,not_found  
j found

####################################
print_line:
    lb $t0, 0($s1)
    beqz $t0, end_print_line
    beq $t0, 10, end_print_line

    li $v0, 11
    move $a0, $t0
    syscall
    li $t8,1
    addi $s1, $s1, 1
    j print_line

end_print_line:
    # Print newline character
    li $v0, 11     # Print newline character
    li $a0, 10
    syscall

    j pp

end:
    # If ID not found, print message
    beqz $t8, id_not_found
   
    la $a0, print
    li $v0, 4
    syscall
    j menu
####################################Option_3############################################
search_unnormal:
        jal take_testname

       # Set up pointers for search
    la $s0, file_buffer          # Load address of file_buffer
    move $s1, $s0                # Load address of result_buffer

    la $t7, test_name        # Load address of test_name
    li $t8, 0                    # Initialize flag to 0 (not found), if ID is found set to 1
    li $t2, 0                    # Counter for characters in ID
    li $t5, 0                    # Counter 
    la $a0, print
    li $v0, 4
    syscall

read_loop2:

    lb $t0, 9($s0)               # Load a byte from buffer
    lb $t4, 0($t7)               # Load a byte from test_name

    beq $t0, $t4, continue_checking2    # If characters match, continue checking
    beqz $t0, end2                      # Check if end2 of buffer

    beq $t0, 10, next_line2             # Check for end2 of line

    beq $t4, $zero, next_line2         # Check for end2 of patient ID

    j next_line2                         # If not, move to next line

continue_checking2:
    addi $t2, $t2, 1                    # Increment character counter
    beq $t2, 3, set_flag2                 # If ID found, set flag

    # Move to next character
    addi $s0, $s0, 1
    addi $t7, $t7, 1
    j read_loop2

next_line2:
    # Reset character counter for new line
    li $t2, 0
    addi $s0, $s0, 1
    move $s1, $s0                       # Load address of result_buffer
    la $t7, test_name               # Reload address of test_name
    j read_loop2

set_flag2:
    # Set flag indicating ID found
    li $t8, 1
    jal check_normality
     bne $v1,1,print_line2
     la $t7, test_name        # Load address of test_name
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
    la $t7, test_name        # Load address of test_name
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
#===================================Option 4===================================
cal_Avg :
la $s0,Hgb_buffer
jal initialize_to_zero
la $s0,BGT_buffer
jal initialize_to_zero
la $s0,LDL_buffer 
jal initialize_to_zero
la $s0,BPT_buffer
jal initialize_to_zero

jal Load_buffers
jal  Average_test_value   
#===================================OPTION 5+6===================================     
Delete_update_process:
jal take_id
jal take_testname
 
    la $a1,ID_testname_append
    la $a0,ID
    jal append_string
    # Append a colon (':')
    li $t0, 58    # ASCII code for ':'
    sb $t0, ($a1)
    addi $a1, $a1, 1

    li $t0,32	# Ascii code for the space
    sb $t0,($a1)
    addi $a1,$a1,1
    
    la $a0, test_name
    jal append_string
    
    la $s0,search_buffer
    jal initialize_to_zero
    la $s0,deleted_buffer
    jal initialize_to_zero 
    la $s0,deleted_line_buffer 
    jal initialize_to_zero 
 #.... now    ID_testname_append ready to search
la $s0, file_buffer         
move $s1, $s0                

la $t7,ID_testname_append   

li $t8, 0                   
li $t2, 0                   
la $a0, print
li $v0, 4
syscall

li $t3,0 # counter for number of lines in the resulted buffer

searchloop:
    lb $t0, 0($s0)               # Load a byte from buffer
    lb $t4, 0($t7)               # Load a byte from pattern
    beq $t0, $t4, continue_check     # If characters match, continue checking
    beqz $t0, endddd                      # Check if end of buffer
    beq $t0, 10, nexttline            # Check for end of line
    beq $t4, $zero, nexttline         # Check for end of patient ID
    j nexttline                      # If not, move to next line

continue_check :
    addi $t2, $t2, 1                    # Increment character counter
    beq $t2, 12, setfflag               # If ID found, set flag

    # Move to next character
    addi $s0, $s0, 1
    addi $t7, $t7, 1
    j searchloop

nexttline:
    li $t2, 0    # Reset character counter for new line
    addi $s0, $s0, 1
    move $s1, $s0                       # Load address of searched line
    la $t7, ID_testname_append            # Reload address of ID_testname_append  
    j searchloop
setfflag:
    li $t8, 1    # Set flag indicating ID found
    addi $t3,$t3,1
    j add_search_buffer
endddd:
    beqz $t8, id_not_found    # If ID not found, print message
    la $s0,search_buffer
    jal print_buffer
    j choice_deleted_line
    
#===================== Now add the search deleted line into the buffer==================
add_search_buffer:
    la $s3, search_buffer       # Load address of search_buffer
    
    # Find end of search_buffer
find_end:
    lb $t0, ($s3)
    beqz $t0, copy_id  # If zero byte found, start appending new line
    addi $s3, $s3, 1
    j find_end

copy_id:
    lb $t0, ($s1)               # Load byte from result buffer
    sb $t0, ($s3)               # Append byte to search buffer
    beqz $t0, end_append        # If null character, finish appending
    addi $s3, $s3, 1            # Move to next location in search buffer
    addi $s1, $s1, 1            # Move to next character in result buffer
    beq $t0, 10, end_append    # If newline character encountered, finish appending
    j copy_id

end_append:
    la $t7, ID_testname_append            # Reload address of ID_testname_append  
    j searchloop                 # Jump back to the reading loop
    

#.......................to choice the line number want delete it...........................
choice_deleted_line:
  #t3 the counter of lines in the buffer
  # s0 is the search_buffer
  
   li $v0,4
   la $a0,enter_deleted_line_msg
   syscall
   
   # Read patiant ID from the user
   li $v0,8	# System call code for reading a string
   la $a0, deleted_line	# Store the read number in ID
   syscall     

   jal  check_integer
   # If the returned value ($v1) is 1 then continue
   beq $v1,1,continue
	
   # If the returned value ($v1) is 0 then try again
   li $v0,4
   la $a0,not_integer_msg
   syscall
   j choice_deleted_line
   
continue:
   la $a0,deleted_line	
   jal strToInt
   # now v1 contain the deleted line
   bgt $v1, $t3, greater_than_t3  # If deleted_line > t3, jump to greater_than_t3
   blez $v1, less_than_or_equal_zero  # If deleted_line <= 0, jump to less_than_or_equal_zero
   
   j Find_delete_line

      
 greater_than_t3:
    # Code to handle deleted_line greater than t3
    # Print an error message or take necessary action
    li $v0, 4
    la $a0, greater_than_t3_msg
    syscall
    j choice_deleted_line  # Example: Jump to exit_program

less_than_or_equal_zero:
    # Code to handle deleted_line less than or equal to 0
    # Print an error message or take necessary action
    li $v0, 4
    la $a0, less_than_or_equal_zero_msg
    syscall
    j choice_deleted_line# Example: Jump to exit_program  

#################################################
Find_delete_line:

    la $s0, search_buffer   
    move $s1, $s0             # Initialize pointer for the start of the desired line
    li $t1, 0                   # Counter for lines read
    
    li $t2,0  #counter for characters in deleted line
    # Loop through the search buffer
read_1:
    lb $t3, 0($s0)              # Load a byte from buffer
    beq $t3, 10, check_line_number    # Check if the current character is a newline
    addi $t2,$t2,1
    beqz $t3, linedelete      # Check for end of buffer

    addi $s0, $s0, 1    # Move to the next character
    j read_1

# Check if the current line number matches the desired line number
check_line_number:
    addi $t1, $t1, 1            # Increment line counter
    beq $t1, $v1, add_delete_line    # If the line numbers match, copy the line
    
    li $t2,0  #counter for characters in deleted line
    addi $s0, $s0, 1    # Move to the next character
    move $s1, $s0               # Update pointer to start of the current line
    j read_1

add_delete_line:
    li $v1,0 # counter for the number of bytes in the deleted line
    la $s3, deleted_line_buffer       # Load address of search_buffer
    
linedelete:
li $t4,0  # count the characters
 la $s3, deleted_line_buffer       # Load address of search_buffer
copy_idd:
    lb $t0, ($s1) 
    sb $t0, ($s3)             
    addi $t4,$t4,1
    beq $t4,$t2, end_appendd                   
    beqz $t0,end_appendd
    addi $s3, $s3, 1           
    addi $s1, $s1, 1   
    addi $v1,$v1,1               # counter for the number of bytes in the deleted line     
    beq $t0, 10, end_appendd    # If newline character encountered, finish appending
    j copy_idd

end_appendd:
    la $a0, print
    li $v0, 4
    syscall
#----------------Now to choice if it is update or delete
    
li $t7, '5'             # ASCII value of '5'
li $t8, '6'             # ASCII value of '6'
la $a1,menue_space
lb $t0, 0($a1)          # Load the first byte of the entered choice

beq $t0, $t8, delete_line_process
beq $t0, $t7, update_line_process
    

end_search:
li $t7, '5'             # ASCII value of '5'
li $t8, '6'             # ASCII value of '6'
la $a1,menue_space
lb $t0, 0($a1)          # Load the first byte of the entered choice

beq $t0, $t8, delete_line_process
beq $t0, $t7, update_line_process
 #---------------------------------------------------------------------------
delete_line_process:
  # s0 --> file_buffer
  # a1 --> deleted_line
  # a2 --> new_buffer

la $s0,deleted_line_buffer  
jal print_buffer

  la $s0,file_buffer       
  move $s1,$s0
  la $t7,deleted_line_buffer       

  li $t8, 0              # Initialize flag indicating whether the line is found
   li $t5,0
#========= we want to add the non-match lines into deleted buffer
# t2 counter of read bytes
# v1 counter for number of bytes in t7 (pattern)
start_loop:
  lb $t0, 0($s0)             
  lb $t4, 0($t7)     

  # Compare bytes
  beqz $t0, enddddd            
  beq $t0, 10, skipline        
  beqz $t4,skipline       
  bne $t0, $t4, setflag        # If characters don't match, set the flag

  # Move to next character
  j continue_loop

continue_loop:
  addi $s0, $s0, 1
  addi $t7, $t7, 1

  j start_loop                # Continue checking

skipline:
  addi $s0, $s0, 1              # Move to the next byte in file buffer
  move $s1, $s0                 # Load address of result buffer
  la $t7,deleted_line_buffer                 # Reload address of deleted line buffer
  addi $t5,$t5,1
  j start_loop

move_to_new_line:
  # Move to the next line
  li $t2, 0                   # Reset character counter for new line
  looop:
    addi $s0, $s0, 1          # Move to the next byte in file buffer
    lb $t0, ($s0)             # Load a byte from buffer
    beq $t0, 10, doone         # Check for end of line
    beqz $t0,endlooppp
    j looop
doone:   
  addi $s0, $s0, 1            # Move to the next byte in file buffer
  move $s1, $s0               # Load address of result buffer
  la $t7, deleted_line_buffer        # Reload address of deleted line buffer
  j start_loop
  
setflag:
  # Set flag indicating line found
  li $t8, 1
  j add_toDeleted_buffer

enddddd:
j remove_last_newline
endlooppp:

  j  saveToFile1

##---------- To add the lines not match into deleted buffer
add_toDeleted_buffer:

 la $s3,deleted_buffer
  # Find end of new buffer
  findend:
    lb $t0, ($s3)
    beqz $t0, copynew         # If zero byte found, start copying
    addi $s3, $s3, 1
    j findend

  copynew:
    lb $t0, ($s1)             
    sb $t0, ($s3)           
    beqz $t0, endAppend     
    addi $s3, $s3, 1         
    addi $s1, $s1, 1       
    beq $t0, 10, endAppend   
    j copynew

endAppend:
  j move_to_new_line             # Jump back to the reading loop
#-----------------------------------------------------------------
update_line_process:

la $s0,deleted_line_buffer  
jal print_buffer

    # Clear the buffer
    li $t0, 0        # ASCII code for null terminator
    sb $t0, ID_testname_append      # Set the first byte of the buffer to null terminator

jal take_year_month
jal take_results

    # Load address of ID into $a1
    la $a1,ID_testname_append
    la $a0,ID
    jal append_string
    # Append a colon (':')
    li $t0, 58    # ASCII code for ':'
    sb $t0, ($a1)
    addi $a1, $a1, 1

    li $t0,32	# Ascii code for the space
    sb $t0,($a1)
    addi $a1,$a1,1
    
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
    beq $t0, $t1, comp_BPT_append

    # If the comparison fails, jump to take_test
    j testcomplete_append   
      
testcomplete_append: 

    # Append the test result
    la $a0, test_result
    jal append_string
    
    li $t0, 10           # Load the ASCII code for newline character
    sb $t0, ($a1)       # Store the newline character at the end of the string
addi $a1, $a1, 1
# Manually add null terminator
li $t0, 0            # ASCII value of null terminator
sb $t0, ($a1)        # Store null terminator at the end of the string buffer
    j update_process
########################################################3
 
comp_BPT_append:

# Append the test result
la $a0, Systolic
jal append_string   

# Append a comma (',')
li $t0, 44    # ASCII code for ','
sb $t0, ($a1)
addi $a1, $a1, 1

# Append a space
li $t0, 32    # ASCII code for space
sb $t0, ($a1)
addi $a1, $a1, 1  

# Append the test result
la $a0, Diastolic
jal append_string   

    li $t0, 10           # Load the ASCII code for newline character
    sb $t0, ($a1)        # Store the newline character at the end of the string
addi $a1, $a1, 1
# Manually add null terminator
li $t0, 0            # ASCII value of null terminator
sb $t0, ($a1)        # Store null terminator at the end of the string buffer
j update_process
#---------------------------------------------------------------------------------------                 
 update_process:
  # deleted buffer
  # deleted line buffer
  # ID_testname_append   


  la $s0,file_buffer       
  move $s1,$s0
  la $t7,deleted_line_buffer       

  li $t8, 0              # Initialize flag indicating whether the line is found
  
#========= we want to add the non-match lines into deleted buffer

startloop:
  lb $t0, 0($s0)             
  lb $t4, 0($t7)     

  # Compare bytes
  beqz $t0, updatelastline            
  beqz $t4,updateline       


  bne $t0, $t4, setttflag        # If characters don't match, set the flag
  # Move to next character
  j continueloop

continueloop:
  addi $s0, $s0, 1
  addi $t7, $t7, 1

  j startloop              # Continue checking

nextttline:
  addi $s0, $s0, 1              # Move to the next byte in file buffer
  move $s1, $s0                 # Load address of result buffer
  la $t7,deleted_line_buffer                 # Reload address of deleted line buffer
  j startloop

movetonewline:
  # Move to the next line
  li $t2, 0                   # Reset character counter for new line
  lineloop:
    addi $s0, $s0, 1          # Move to the next byte in file buffer
    lb $t0, ($s0)             # Load a byte from buffer
    beq $t0, 10, dooneloop         # Check for end of line
    beqz $t0,endupdate
    j lineloop
dooneloop:   
  addi $s0, $s0, 1            # Move to the next byte in file buffer
  move $s1, $s0               # Load address of result buffer
  la $t7, deleted_line_buffer        # Reload address of deleted line buffer
  j startloop

updateline:
    la $s2, ID_testname_append
     j  addupdatelineto_buffer

setttflag:
  # Set flag indicating line found
  li $t8, 1
  j addtoDeleted_buffer

endupdate:
 
  j  saveToFile1

##---------- To add the lines not match into deleted buffer
addtoDeleted_buffer:

 la $s3,deleted_buffer
  # Find end of new buffer
  findendd:
    lb $t0, ($s3)
    beqz $t0, copyneww         # If zero byte found, start copying
    addi $s3, $s3, 1
    j findendd

  copyneww:
    lb $t0, ($s1)             
    sb $t0, ($s3)           
    beqz $t0, enddAppend     
    addi $s3, $s3, 1         
    addi $s1, $s1, 1       
    beq $t0, 10, enddAppend   
    j copyneww

enddAppend:
  j movetonewline            # Jump back to the reading loop

 #==================                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
 addupdatelineto_buffer:
 la $s3,deleted_buffer
  # Find end of new buffer
  findennd:
    lb $t0, ($s3)
    beqz $t0, copynneww         # If zero byte found, start copying
    addi $s3, $s3, 1
    j findennd

  copynneww:
    lb $t0, ($s2)             
    sb $t0, ($s3)           
    beqz $t0, enddAppendd     
    addi $s3, $s3, 1         
    addi $s2, $s2, 1       
    beq $t0, 10, enddAppendd   
    j copynneww

enddAppendd:
   addi $s3, $s3, 1         
  addi $s0, $s0, 1              # Move to the next byte in file buffer

  move $s1, $s0                 # Load address of result buffer
  la $t7,deleted_line_buffer                 # Reload address of deleted line buffer
  j startloop

#------------------------
updatelastline:
    la $s2, ID_testname_append  
  la $s3,deleted_buffer
  # Find end of new buffer
findddennd:
    lb $t0, ($s3)
    beqz $t0, copynnewww         # If zero byte found, start copying
    addi $s3, $s3, 1
    j findddennd

copynnewww:
    lb $t0, ($s2)             
    sb $t0, ($s3)           
    beqz $t0, enddAppenddd     
    addi $s3, $s3, 1         
    addi $s2, $s2, 1       
    beq $t0, 10, enddAppenddd   
    j copynnewww

enddAppenddd:
   j remove_last_newline
#-----------------------------------------------------------------
 remove_last_newline:
    # Initialize variables
    li $t1, 0          # Index for iterating through the buffer
    la $s2, deleted_buffer  # Set $a0 to point to the beginning of the buffer

    # Find the end of the buffer and the index of the last newline character
loop_find_newline:
    lb $t0, ($s2)           # Load byte from buffer into $t0
    beqz $t0,foundnewline     # If byte is null terminator, jump to found_end
    addi $t1, $t1, 1       # Increment index
    addi $s2, $s2, 1       # Increment buffer pointer
    j loop_find_newline             # Repeat loop

foundnewline:
    # Move back to the last character and check if it's a newline
    beqz $t1, remove          # If buffer is empty, exit
    addi $s2, $s2, -1      # Move back one character
    lb $t0, ($s2)          # Load the last character
    beq $t0, 10, remove    # If last character is newline, remove it
    
remove:
    sb $zero, ($s2)        # Replace the newline character with null terminator

    jal saveToFile1
  #////////////////////////////////////////////////////////////////////////////

check_test_name:
li $t7, 0                      # Initialize sum
la $a1,test_num
lb $t1, 0($a1)                 # Load the first byte of input
li $t2, 49                     # ASCII value of '1'
li $t4, 52                     # ASCII value of '4'
blt $t1, $t2, invalid_choice  # If input is less than '1', it's invalid
bgt $t1, $t4, invalid_choice  # If input is greater than '4', it's invalid

goo:
lb $t1, 1($a1)          # Load the second byte of the entered choice
li $t2, 10               # ASCII value of null terminator
beq $t1, $t2, check_single_character   # If only one byte was entered, proceed to check_single_character
j invalid_choice        # If more than one byte was entered, it's an invalid choice

# If only one byte was entered, check if it's '1', '2', '3', or '4'
check_single_character:
    lb $t0, ($a1)           # Load the entered choice
    beq $t0, '1', append_Hgb   
    beq $t0, '2', append_BGT  
    beq $t0, '3', append_LDL 
    beq $t0, '4', append_BPT 
    
    # If the entered choice is not '1', '2', '3', or '4', it's an invalid choice
    j invalid_choice

invalid_choice:

    li $v0, 4
    la $a0, no_such_choice
    syscall
    j take_testname  # Go back to the menu or appropriate section after displaying the message
   
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


    j AppendLineToBuffer
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

  # Manually add null terminator
li $t0, 0         # ASCII value of null terminator
sb $t0, ($a1)     # Store null terminator at the end of the string buffer
    j AppendLineToBuffer
    
    
append_string:
    lb $t0, ($a0)      # Load byte from source address
    beqz $t0, finish_append_string   # If byte is zero, finish
    sb $t0, ($a1)      # Store byte to destination address
    addi $a0, $a0, 1  # Increment source address
    addi $a1, $a1, 1  # Increment destination address
    j append_string    # Repeat loop

finish_append_string:
    jr $ra             # Return

#---------------------------------------------------------------------------------

saveToFile1:           # Close the file
 la $s0,file_buffer
 jal initialize_to_zero 
 
 li $t1,0 # counter to count the  buffer
 la $s2, deleted_buffer

li $v0,4
la $a0,print
syscall
la $s0,deleted_buffer
jal print_buffer
llooppp:
    lb $t0,($s2)
    beqz $t0,endllloppp
    addi $t1,$t1,1
    addi $s2,$s2,1
    j llooppp
    
endllloppp:
    # Open the file for writing with truncation
    li $v0, 13          # System call for open file
    la $a0, filename    # File name
    li $a1, 1          # Open for write mode with truncation
    syscall             # Open file
    move $s0, $v0       # Save file descriptor

    # Write content to the file
    li $v0, 15          # System call for write file
    move $a0, $s0       # File descriptor
    la $a1, deleted_buffer # Address of the content to write
    move $a2, $t1        # Length of the content (adjust as needed)
    syscall             # Write to file

    # Close the file
    li $v0, 16          # System call for close file
    move $a0, $s0       # File descriptor
    syscall             # Close file
    j main
  
#------------------------------------------------------------------------------
 saveToFile:           # Close the file

 li $t1,0 # counter to count the  buffer
 la $s2, file_buffer
 
 lloopp:
    lb $t0,($s2)
    beqz $t0,endlloppp
    addi $t1,$t1,1
    addi $s2,$s2,1
    j lloopp
endlloppp:

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
    move $a2, $t1        # Length of the content (adjust as needed)
    syscall             # Write to file

    # Close the file
    li $v0, 16          # System call for close file
    move $a0, $s0       # File descriptor
    syscall             # Close file
    j menu
          
###----------------- This method used to append the number of choice of tests into test_name to hold the name-------------------
AppendLineToBuffer:
 la $s3, append_test
  la $s1, file_buffer
  lb $t0, ($s1)
  beqz $t0,  copyiid
  
finddend:
    lb $t0, ($s1)
    beqz $t0, append_new_line
    addi $s1, $s1, 1
    j finddend

append_new_line:
    li $t0, 10
    sb $t0, ($s1)
    addi $s1, $s1, 1

copyiid:
      lb $t0, ($s3)
      sb $t0, ($s1)
      beqz $t0, endaappend
      addi $s1, $s1, 1
      addi $s3, $s3, 1
      j copyiid

  endaappend:
    sb $zero, ($s1)

  li $v0,4
  la $a0,print
  syscall
  
  la $s0, file_buffer
  jal print_buffer
  j saveToFile
  
##############################NOTE THAT T1 IS THE MONTH###########################################
take_results:
    addi $sp, $sp, -4  
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
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra               # Return  
######################### Function append_test_name#####################
append_test_name:
    move $s0, $a0    # Load the address of test_name into $s0
    move $s1, $a1    # Load the address of Hgb into $s1
    
    # Loop to copy characters from Hgb to test_name
copy_loop1:
        lb $t0, 0($s1)        # Load a character from Hgb
        beq $t0, $zero, end_copy_loop        # If the character is null, we've reached the end of Hgb
        sb $t0, 0($s0)        # Store the character into test_name
        # Move to the next character in Hgb and test_name
        addi $s1, $s1, 1
        addi $s0, $s0, 1
        # Continue copying
        j copy_loop1

end_copy_loop:    # End of loo
        sb $zero, 0($s0)
    	jr $ra
######################### Function check_float#####################
# Function to check if the input string is a valid float
# Input: $a0 - Pointer to the input string
# Output: $v0 = 1 if the input string is a valid float, $v0 = 0 otherwise
check_float:
    # Allocate space on the stack for $ra
    addi $sp, $sp, -4  
    # Save $ra on the stack    
    sw   $ra, 0($sp)


    li $v0, 1            # Assume it's a float
    li $t0, 0            # Counter for digits before decimal point
    li $t1, 0            # Counter for digits after decimal point
    li $t2, 0            # Flag to track if decimal point encountered
    li $t5, 0            # Counter for digits before decimal point

check_digit:
    lb $t3, ($a0)         # Load the ASCII character into $t3

    beqz $t3, counter_check # If it's end of string, return 1
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

    j check_afterdecimal
    
check_afterdecimal:
    lb $t3, ($a0)         # Load the ASCII character into $t3
    beqz $t3, counter_check # If it's end of string, return 1
    beq $t3, 46, invalid_input  # Branch if it's a decimal point
    li $t4, 48           # ASCII code for '0'
    blt $t3, $t4, invalid_input  # Branch if it's not a digit
    li $t4, 57           # ASCII code for '9'
    bgt $t3, $t4, invalid_input  # Branch if it's not a digit
    
    addi $t1, $t1, 1     # Increment digit counter after decimal point
    beq $t1, 2, remove_extra_digit  # If more than one digit after decimal point, remove it
    
    addi $a0, $a0, 1     # Move pointer to the next character
    j check_afterdecimal

remove_extra_digit:
    sb $zero, ($a0)       # Remove extra digit by replacing it with NULL
    j counter_check

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
    addi $t5,$t5,1
    addi $a0, $a0, 1     # Increment digit counter
    j check_digit

invalid_input:
    li $v0, 0            # Set $v0 to 0 (not a float)
    j end_check
    
counter_check:    
    beq $t5, 2, counter_valid   # If counter is 2, it's valid
    beq $t5, 3, counter_valid   # If counter is 3, it's valid
    j invalid_input           # If counter is neither 2 nor 3, it's invalid
 
counter_valid :
    li $v0, 1            # Set $v0 to 0 (not a float)
    beqz $t2,add_decimal_zero
       
end_check:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra               # Return
######################### Function check_integer#####################
# This function take the address of a string in $a0
# Return 1 in $v1 if it is integer, 0 if not integer
check_integer:
	addi $sp, $sp, -4  
	sw   $ra, 0($sp)  
	
	# Consider $v1 is the flag (1: yes, 0: no)
	li $v1,1
loop_check:	lb $t0,($a0)
	move $t5,$t0
	beq $t0,10,finish_check
	beq $t0,0,finish_check
	addi $a0,$a0,1
	blt $t0,48,not_integer
	bgt $t0,57,not_integer
	j loop_check
	
	not_integer:
		li $v1,0
	finish_check:
        		lw   $ra, 0($sp)
        		addi $sp, $sp, 4
        		jr   $ra 
######################### Function check_4digits#####################
#  This function takes the address of the year in $a0 and checks
# if the ID is 4 digits ($v1 = 1) or not ($v1 = 0)
check_4digits:
	addi $sp, $sp, -4  
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
        		lw   $ra, 0($sp)
        		addi $sp, $sp, 4
        		jr   $ra 	
######################### Function check_7digits######################
#  This function takes the address of the ID in $a0 and checks
# if the ID is 7 digits ($v1 = 1) or not ($v1 = 0)
check_7digits:
	addi $sp, $sp, -4  
	sw   $ra, 0($sp)  
	# Counter initlized to zero
	li $t1,0
	# Consider $v1 is the flag (1: yes, 0: no)
	li $v1,1   
loop_check2:	
        lb $t0,0($a0)
	beq $t0,10,finish_check2
	beq $t0,0,finish_check2
	addi $a0,$a0,1
	addi $t1,$t1,1
	j loop_check2
	
	finish_check2:

		beq $t1,7,end_check11
		li $v1,0
	end_check11:	
	lw $ra, ($sp) 
	addi $sp, $sp, 4      
	jr $ra            
######################### Function strToInt######################
strToInt:
#to integer, its address stored in $a0
#return the number in $v1
addi $sp, $sp, -4
sw $ra, 0($sp)

li $v1, 0 # Initialize: $v0 = sum = 0
li $t0, 10 # Initialize: $t0 = 10
L1: 
lb $t1, 0($a0) # load $t1 = str[i]
blt $t1, '0', donne # exit loop if ($t1 < '0')
bgt $t1, '9', donne # exit loop if ($t1 > '9')
addiu $t1, $t1, -48 # Convert character to digit
mul $v1, $v1, $t0 # $v0 = sum * 10
addu $v1, $v1, $t1 # $v0 = sum * 10 + digit
addiu $a0, $a0, 1 # $a0 = address of next char
j L1 # loop back

donne: 
	lw $ra, ($sp) 
	addi $sp, $sp, 4      
    jr $ra 
######################### Function Month_to_Integer#######################
Month_to_Integer:
	#this is a function to convert an ascii number
	#to integer, its address stored in $a0
	#return the number in $v1
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	
	lb $t7,0($a0)
	lb $t9,1($a0)
	blt $t9,48,oneDigit
	bgt $t9,57,oneDigit
twoDigit:
	addi $t7,$t7,-48
	mul $t7,$t7,10
	addi $t9,$t9,-48
	add $v1,$t7,$t9
	
  	move $t1, $v1

	lw $ra, ($sp) 
	addi $sp, $sp, 4      
	jr $ra 
oneDigit:
	addi $t7,$t7,-48
	move $v1,$t7
    	# Add leading zero to the month string
    	li $t2, 48              # Load ASCII '0' into $t2
    	sb $t2, ($a0)           # Store '0' in the month string
    	addi $a0, $a0, 1        # Move to the next index in the month string

   	 # Convert the single digit to ASCII
    	addi $t7, $t7, 48       # Convert the single digit to ASCII
    	sb $t7, ($a0)           # Store the single digit in the month string
    	addi $a0, $a0, 1        # Move to the next index in the month string

        move $t1, $v1
	
	lw $ra, ($sp) 
	addi $sp, $sp, 4      
	jr $ra 
######################### initialize_to_zero########################
initialize_to_zero:
     addi $sp, $sp, -4  
     sw   $ra, 0($sp)   

    li $t0, 0               # Set $t0 to zero (ASCII value for null terminator)
    li $t1, 1024             # Number of bytes in the buffer

    # Loop to set each byte to zero
init_buffer_loop:
    sb $t0, ($s0)           # Store zero in current byte of buffer
    addi $s0, $s0, 1        # Move to next byte in buffer
    addi $t1, $t1, -1       # Decrement counter
    bnez $t1, init_buffer_loop  # Continue loop if counter is not zero
    lw $ra, ($sp) 
    addi $sp, $sp, 4      
	jr $ra
######################### remove_newline########################
# This function takes a string that its address stored in $a0
# and removes the new line char from the end of the string
remove_newline:
	addi $sp, $sp, -4  
	sw   $ra, 0($sp)
	addi $s5, $a0, 0   
	addi $s6, $zero, 0     

	loop6:
		lbu  $s7, ($s5)   
		beq  $s7, 10, done3  
		addi $s5, $s5, 1   
		addi $s6, $s6, 1       
		j    loop6

	done3:
		beq  $s6, $zero, end4   	
     		addi $s6, $s6, -1      
        		addi $s7, $zero, 0
        		sb   $s7, ($s5)       
    	end4:
        	lw   $ra, 0($sp)
        	addi $sp, $sp, 4
        	jr   $ra 
######################### Function copy_loop#########################
 # This code used to copy the buffer in a0 into a1        	
copy_loop:
	addi $sp, $sp, -4  
	sw   $ra, 0($sp)   
start_copy:	    
    lb $t1, 0($a0)  # Load byte from ID buffer
    sb $t1, 0($a1)  # Store byte to patientIDtemp buffer
    addi $a0, $a0, 1 # Increment source address
    addi $a1, $a1, 1 # Increment destination address
    addi $t0, $t0, 1 # Increment loop counter
    bne $t0, 7, start_copy# Check loop condition     	
    	# Restore $ra from the stack
        	lw   $ra, 0($sp)
        	addi $sp, $sp, 4
        	jr   $ra #back to where it was last used.     	
######################### Function Invalid_test_result########################
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
    
id_not_found:
    # Print message indicating ID not found
    la $a0, id_not_found_message
    li $v0, 4
    syscall
   
    la $a0, print
    li $v0, 4
    syscall
    j menu    
######################### Function normal or not normal###########################
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
    li $k1,0
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
# 13.8 to 17.2
    # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,23
    jal convertStringToInt
   
    
      # Compare the result with 13 and 17
    lw $t3, result        # Load the integer result
    li $t4, 13           # Load 13
    li $t5, 17           # Load 17
    blt $t3,$t4,not_normal
    bgt $t3,$t5,not_normal
    beq $t3, $t4, check_dot_13  # Branch if result equals 13
    beq $t3, $t5, check_dot_17  # Branch if result equals 17
    b normal   # Jump to normal execution if result neither equals 13 nor 17

check_dot_13:
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k1
    jal convertStringToInt
    bge $t2, 8, normal
    j not_normal

check_dot_17:
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k1
    jal convertStringToInt
    ble $t2, 2, normal
    j not_normal

end2_check2 :
#50 to 100
 # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,23
    jal convertStringToInt
   
    
      # Compare the result with 13 and 17
    lw $t3, result        # Load the integer result
    li $t4, 50           # Load 13
    li $t5, 100           # Load 17
    blt $t3,$t4,not_normal
    bgt $t3,$t5,not_normal
    beq $t3, $t4, check_dot_50  # Branch if result equals 13
    beq $t3, $t5, check_dot_100  # Branch if result equals 17
    b normal   # Jump to normal execution if result neither equals 13 nor 17

check_dot_50 :
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k1
    jal convertStringToInt
    bge $t2, 0, normal
    j not_normal

check_dot_100 :
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k1
    jal convertStringToInt
    ble $t2, 0, normal
    j not_normal       
        
end2_check3 :  
#70 to 99
      # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,23
    jal convertStringToInt
    

      # Compare the result with 13 and 17
    lw $t3, result        # Load the integer result
    li $t4, 70           # Load 13
    li $t5, 99           # Load 17
    blt $t3,$t4,not_normal
    bgt $t3,$t5,not_normal
    beq $t3, $t4, check_dot_70  # Branch if result equals 13
    beq $t3, $t5, check_dot_99  # Branch if result equals 17
    b normal   # Jump to normal execution if result neither equals 13 nor 17

check_dot_70 :
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k1
    jal convertStringToInt
    bge $t2, 0, normal
    j not_normal

check_dot_99 :
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k1
    jal convertStringToInt
    ble $t2, 0, normal
    j not_normal                      



end2_check4: 
#90 to 120
      # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,23
    jal convertStringToInt
    move $k0,$k1  
    
    
      # Compare the result with 13 and 17
    lw $t3, result        # Load the integer result
    li $t4, 90           # Load 13
    li $t5, 120           # Load 17
    blt $t3,$t4,not_normal
    bgt $t3,$t5,not_normal
    beq $t3, $t4, check_dot_90  # Branch if result equals 13
    beq $t3, $t5, check_dot_120  # Branch if result equals 17
    b end2_check5   # Jump to normal execution if result neither equals 13 nor 17

check_dot_90 :
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k1
    jal convertStringToInt
    bge $t2, 0, end2_check5
    j not_normal

check_dot_120 :
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k1
    jal convertStringToInt
    ble $t2, 0, end2_check5
    j not_normal                      

end2_check5:
# 60 to 80
      # Reset $t2 to point to the beginning of the bufferg of the buffer
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k0
    addi $a0,$a0,3
    jal convertStringToInt
    
      # Compare the result with 13 and 17
    lw $t3, result        # Load the integer result
    li $t4, 60           # Load 13
    li $t5, 80           # Load 17
    blt $t3,$t4,not_normal
    bgt $t3,$t5,not_normal
    beq $t3, $t4, check_dot_60 # Branch if result equals 13
    beq $t3, $t5, check_dot_80 # Branch if result equals 17
    b normal   # Jump to normal execution if result neither equals 13 nor 17

check_dot_60 :
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k0
    addi $a0,$a0,5
    jal convertStringToInt
    bge $t2, 0, normal
    j not_normal

check_dot_80 :
    move $a0, $s1          # $t2 points to the beginning of the bufferto the beginning of the buffer
    addi $a0,$a0,24
    add $a0,$a0,$k0
    addi $a0,$a0,5
    jal convertStringToInt
    ble $t2, 0, normal
    j not_normal                      

#--------
normal :
    li $v1,1
    j end2_check11
    
not_normal:
    li $v1,0
    j end2_check11
#--------
end2_check11:		
        		lw   $ra, 0($sp)		# Restore $ra from the stack
        		addi $sp, $sp, 4        		# Deallocate space on the stack
        		jr   $ra         		#back to where it was last used
######################### Function Average_test_value#############################
Average_test_value:
	addi $sp, $sp, -4  	# Allocate space on the stack for $ra
	sw   $ra, 0($sp)  	# Save $ra on the stack    
    move $s0, $a0           # Set $s0 to the address of the buffer
    # Load the addresses of the buffers into $s0, $s1, $s2, $s3
    # (Assuming the addresses of the buffers are already loaded into $s0, $s1, $s2, $s3)
    # Check if any of the buffers is empty
Check_Hgb_buffer: 
li $v0,4
la $a0,print
syscall  
    li $t8,0 
    la $a0, Hgb_buffer      # Load address of Hgb_buffer
    jal check_buffer_empty  # Check if Hgb_buffer is empty
    beqz $v1, print_Avg_Hgb   # If Hgb_buffer is empty, print "avg Hgb=0" and return 0
    j Calculate_Avg_Hgb
    
Check_BGT_buffer:  
    li $t8,0 
    la $a0, BGT_buffer      # Load address of BGT_buffer
    jal check_buffer_empty  # Check if BGT_buffer is empty
    beqz $v1, print_Avg_BGT    # If Hgb_buffer is empty, print "avg Hgb=0" and return 0
    j Calculate_Avg_BGT

Check_LDL_buffer: 
    li $t8,0  
    la $a0, LDL_buffer      # Load address of LDL_buffer
    jal check_buffer_empty  # Check if LDL_buffer is empty
    beqz $v1,print_Avg_LDL    # If Hgb_buffer is empty, print "avg Hgb=0" and return 0
    j Calculate_Avg_LDL

Check_BPT1_buffer:  
    li $t8,0 
    la $a0, BPT_buffer      # Load address of BPT_buffer
    jal check_buffer_empty  # Check if BPT_buffer is empty
    beqz $v1, print_Avg_BPT1    # If Hgb_buffer is empty, print "avg Hgb=0" and return 0
    j Calculate_Avg_BPT1
    
Check_BPT2_buffer:  
    li $t8,0 
    la $a0, BPT_buffer      # Load address of BPT_buffer
    jal check_buffer_empty  # Check if BPT_buffer is empty
    beqz $v1, print_Avg_BPT2    # If Hgb_buffer is empty, print "avg Hgb=0" and return 0
    j Calculate_Avg_BPT2
                 
print_Avg_Hgb :
    li $v0,4
    la $a0, Avg_Hgb
    syscall
    beq $v1,0,print_res
    
        # Print the result
     li $v0, 2               # system call for print float
     mov.s $f12,$f10         # result
     syscall
     j Check_BGT_buffer
    print_res:
    # Print the result
    #the result in V0  
    li $v0,1
    move $a0, $v1
    syscall
    j Check_BGT_buffer
      
print_Avg_BGT :
    li $v0,4
    la $a0, Avg_BGT
    syscall
    beq $v1,0,print_res2
        # Print the result
     li $v0, 2               # system call for print float
     mov.s $f12,$f10         # result
     syscall
     j Check_LDL_buffer
    print_res2:
    # Print the result
    #the result in V0  
    li $v0,1
    move $a0, $v1
    syscall
    j Check_LDL_buffer

    
print_Avg_LDL :
    li $v0,4
    la $a0, Avg_LDL
    syscall
    beq $v1,0,print_res3
        # Print the result
     li $v0, 2               # system call for print float
     mov.s $f12,$f10         # result
     syscall
     j Check_BPT1_buffer
    print_res3:
    # Print the result
    #the result in V0  
    li $v0,1
    move $a0, $v1
    syscall
    j Check_BPT1_buffer
    
    
print_Avg_BPT1 :
    li $v0,4
    la $a0, Avg_BPT1
    syscall
    beq $v1,0,print_res4
        # Print the result
     li $v0, 2               # system call for print float
     mov.s $f12,$f10         # result
     syscall
     j Check_BPT2_buffer
 print_res4:
    # Print the result
    #the result in V0  
    li $v0,1
    move $a0, $v1
    syscall
     j Check_BPT2_buffer
    
  print_Avg_BPT2 :
    li $v0,4
    la $a0, Avg_BPT2
    syscall
    beq $v1,0,print_res5
        # Print the result
     li $v0, 2               # system call for print float
     mov.s $f12,$f10         # result
     syscall     # result
     j end_res
 print_res5:
    # Print the result
    #the result in V0  
    li $v0,1
    move $a0, $v1
    syscall
    j end_res
             
end_res:
li $v0,11
la $a0,10
syscall 
li $v0,4
la $a0,print
syscall 
j menu
                     
Calculate_Avg_Hgb:
    # Calculate average for Hgb_buffer
    la $s0, Hgb_buffer          # Load address of file_buffer
    move $s1, $s0                # Load address of result_buffer
    li $t9,0
        li $k1 ,1 # flag for BPT
    jal AVG_tests
     j print_Avg_Hgb
   
    
Calculate_Avg_BGT:
    # Calculate average for Hgb_buffer
    la $s0, BGT_buffer          # Load address of file_buffer
    move $s1, $s0                # Load address of result_buffer
      li $t9,0
          li $k1 ,1 # flag for BPT
          jal AVG_tests
         j print_Avg_BGT
    j Check_LDL_buffer
    
Calculate_Avg_LDL:
    # Calculate average for Hgb_buffer
    la $s0, LDL_buffer          # Load address of file_buffer
    move $s1, $s0                # Load address of result_buffer
      li $t9,0
          li $k1 ,1 # flag for BPT
       jal AVG_tests

    j print_Avg_LDL
    j Check_BPT1_buffer

Calculate_Avg_BPT1:
    # Calculate average for Hgb_buffer
    la $s0, BPT_buffer          # Load address of file_buffer
    move $s1, $s0      # Load address of result_buffer
    li $t9,0
    li $k1 ,1 # flag for BPT
    jal AVG_tests
    la $s0, BPT_buffer          # Load address of file_buffer
    j print_Avg_BPT1
    j End_Avg
    
 Calculate_Avg_BPT2:
    # Calculate average for Hgb_buffer
    la $s0, BPT_buffer          # Load address of file_buffer
    move $s1, $s0      # Load address of result_buffer
    li $t6,0
        li $t9,0
   # jal AVG_BPT2
       li $k1 ,0 # flag for BPT
      jal AVG_tests
          la $s0, BPT_buffer          # Load address of file_buffer
    j print_Avg_BPT2
    j End_Avg  
     
End_Avg:
        		lw   $ra, 0($sp)        		# Deallocate space on the stack
        		addi $sp, $sp, 4        		#back to where it was last used
                           jr $ra                  # Return from subroutine                                                      
############################# Function to check if a buffer is empty############
check_buffer_empty:
	addi $sp, $sp, -4  	# Allocate space on the stack for $ra
	sw   $ra, 0($sp)  	# Save $ra on the stack    

   	 move $s0, $a0           # Set $s0 to the address of the buffer
	 li $v1, 0
	 
    lb $t0, ($s0)           # Load the first byte from the buffer
    beqz $t0, buffer_empty  # If it's null, the buffer is empty

    li $v1, 1    # If the buffer is not empty, return 1 (non-empty)
    j end_result
    
buffer_empty:
    li $v1, 0
    end_result:
        		lw   $ra, 0($sp)        		# Deallocate space on the stack
        		addi $sp, $sp, 4        		#back to where it was last used
        		jr   $ra 		
############################# Function sum the num for calculate the avg ############
AVG_tests:
    addi $sp, $sp, -4      # Allocate space on the stack for $ra
    sw   $ra, 0($sp)      # Save $ra on the stack    

    jal remove_dot_make_int
    
    move $t3, $v0   # Move integer result to $t3
    add $t8, $t8, $t3
    addi $t9, $t9, 1
    

    lw   $ra, 0($sp)    # Restore $ra from the stack
    addi $sp, $sp, 4    # Deallocate space on the stack

    j go_to_next_line

go_to_next_line:
    # Reset character counter for new line
    li $t2, 0

    # Loop to find the next newline character
    find_next_line1:
        lb $t0, ($s0)         # Load the byte at the current position
        beqz $t0, end_sum_avg # If it's null, it's the end of the file_buffer
        beq $t0, 10, found_newline1 # If it's newline, we found the end of the current line
        addi $s0, $s0, 1      # Move to the next byte in the buffer
        j find_next_line1      # Repeat the loop

    # If we reach here, it means we found the next newline character
    found_newline1:
    addi $s0, $s0, 1          # Move past the newline character
    move $s1, $s0              # Set the result_buffer pointer to the new line

    # Check if we've reached the end of the file_buffer
    lb $t0, ($s0)             # Load the byte at the current position
    beqz $t0, end_sum_avg     # If it's null, it's the end of the file_buffer

    # Otherwise, continue reading
    li $v0, 14                # Load syscall for reading from file
    move $a0, $s0             # Load file descriptor
    la $a1, file_buffer       # Load buffer to store file content
    li $a2, 1024              # Load input length
    syscall
    j AVG_tests

end_sum_avg:
    mtc1 $t8, $f0             # Convert the integer into float number
    mtc1 $t9, $f1 
    div.s $f0, $f0, $f1

    cvt.w.s $f0, $f0          # Convert the float in $f0 to an integer in $f0

    li $t3, 10
    mtc1 $t3, $f4
    div.s $f10, $f0, $f4
    jr $ra    # Return to the calle
#########################remove_dot_make_int###########################################
# Convert a string containing a float number to an integer
# Input: Address of the input string (in $a0)
# Output: Integer result (in $v0)
# Saved Registers: $ra, $k0
remove_dot_make_int:
    addi $sp, $sp, -8      # Allocate space on the stack for $ra and $k0
    sw   $ra, 4($sp)      # Save $ra and $k0 on the stack    
    sw   $k0, 0($sp)  
    
    move $t0, $s1  # Save the address of the input string
      
    li $t1, 0       # Initialize index to 0
    li $t2, 0       # Initialize integer result to 0
    li $t3, 0       # Flag to check if the decimal point has been encountered
    li $k0,0

    # Loop through the characters of the string
    jal countDigitsUntilComma
     move $t0, $s1  # Save the address of the input string
    lb $t5,10($t0)
    beq $t5,'P', go_to
    
go_to:
beq $k1,1,loop5
beq $k0,2,make2
beq $k0,3,make3
make2:
move $t0, $s1  # Save the address of the input string
addi $t0,$t0 ,6
j loop5
make3:  
move $t0, $s1  # Save the address of the input string
addi $t0,$t0 ,7  
j loop5
loop5:
    lb $t4, 23($t0)   # Load character into $t4
    beqz $t4, done  # Exit loop if end of string
    beq $t4,32, done  # Exit loop if end of string(space)
    # Check if the character is a dot
    beq $t4, '.', skip_dot
    
    # Check if the character is a digit
    blt $t4, '0', not_digit
    bgt $t4, '9', not_digit
    sub $t4, $t4, '0'    # Convert character to integer
    mul $t2, $t2, 10    # Multiply current result by 10 and add the digit
    add $t2, $t2, $t4
    beq $t3, 1, next    # Check if decimal point encountered
    addi $t0, $t0, 1   # Increment index
    j loop5
    
not_digit:
    beq $t4, 10, done    # Check if the character is a newline
    beq $t4, ',', done    # Check if the character is a comma
    beq $t4, '.', set_decimal    # Set the flag if decimal point encountered
    
next:
    addi $t1, $t1, 1   # Increment index
    j loop5

set_decimal:
    li $t3, 1       # Set flag for decimal point
    addi $t0, $t0, 1   # Move to the next character
    j loop5

skip_dot:
    addi $t0, $t0, 1   # Skip the dot
    j loop5

done:
    move $v0, $t2    # Store the integer result
    lw $k0, 0($sp)    # Restore $ra and $k0 from the stack
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra	         # Return from subroutine 
#########################Count the number of the digit ############################################
# Count the number of digits until a comma is encountered
# Input: Address of the input string (in $a0)
# Output: Number of digits (in $k0)
# Saved Registers: $ra, $t0, $t1
countDigitsUntilComma:
    addi $sp, $sp, -12    # Save $ra, $t0, and $t1 on the stack
    sw $ra, 8($sp)
    sw $t0, 4($sp)
    sw $t1, 0($sp)

    li $k0, 0    # Initialize counter to 0
    move $a0, $s1  # Save the address of the input string

count_loop1:    # Loop through the characters of the string
    lb $t1, 23($a0)       # Load character into $t1
    beqz $t1, end_count1 # If it's null, end of string
    beq $t1, '.', end_count1 # If it's comma, end count
    blt $t1, '0', not_digit1 # If it's not a digit, skip
    bgt $t1, '9', not_digit1
    addi $k0, $k0, 1    # Increment digit counter

not_digit1:
    addi $a0, $a0, 1    # Move to the next character
    j count_loop1

end_count1:
    lw $ra, 8($sp)    # Restore $ra, $t0, and $t1 from the stack
    lw $t0, 4($sp)
    lw $t1, 0($sp)
    addi $sp, $sp, 12
    jr $ra            # Return to the caller       
#########################Function to load lines to the buffers#####################################
Load_buffers:
	addi $sp, $sp, -4  	# Allocate space on the stack for $ra
	sw   $ra, 0($sp)  	# Save $ra on the stack    

       # Set up pointers for search
    la $s0, file_buffer          # Load address of file_buffer
    move $s1, $s0                # Load address of result_buffer

read_loop3:

check_the_type_buffer:
    lb $t0, 9($s1)         # Load the first byte from buffer
        beqz $t0, end3                      # Check if end2 of buffer

    # Check the value of $t0
    beq $t0, 72, Load_Hgb_buffer # If H, print Hgb
    beq $t0, 76, Load_LDL_buffer# If L, print LDL
    beq $t0, 66, check_B2    # If B, check the second byte

check_B2:
    lb $t1, 10($s1)         # Load the second byte from buffer
    beq $t1, 71, Load_BGT_buffer# If G, print BGT
    beq $t1, 80, Load_BPT_buffer # If P, print BPT


Load_Hgb_buffer:
  la $s3, Hgb_buffer   
j add_search_buffer2

Load_BGT_buffer:
  la $s3,BGT_buffer 
j add_search_buffer2

Load_LDL_buffer:
  la $s3, LDL_buffer
j add_search_buffer2

Load_BPT_buffer:
  la $s3, BPT_buffer    
j add_search_buffer2
####################### Function to add_search_buffer################################
add_search_buffer2:

find_end3:    # Find end of search_buffer
    lb $t0, ($s3)
    beqz $t0, copy_id2  # If zero byte found, start appending new line
    addi $s3, $s3, 1
    j find_end3

copy_id2:
    lb $t0, ($s1)               # Load byte from result buffer
    sb $t0, ($s3)               # Append byte to search buffer
    beqz $t0, end_append2        # If null character, finish appending
    addi $s3, $s3, 1            # Move to next location in search buffer
    addi $s1, $s1, 1            # Move to next character in result buffer
    beq $t0, 10, end_append2    # If newline character encountered, finish appending
    j copy_id2

end_append2:
    li $t2, 0    # Reset character counter for new line


    find_next_line:    # Loop to find the next newline character
        lb $t0, ($s0)         # Load the byte at the current position
        beqz $t0, end3# If it's null, it's the end of the file_buffer
        beq $t0, 10, found_newline # If it's newline, we found the end of the current line
        addi $s0, $s0, 1      # Move to the next byte in the buffer
        j find_next_line      # Repeat the loop

    found_newline:    # If we reach here, it means we found the next newline character
    addi $s0, $s0, 1          # Move past the newline character
    move $s1, $s0              # Set the result_buffer pointer to the new line

    # Check if we've reached the end of the file_buffer
    lb $t0, ($s0)             # Load the byte at the current position
    beqz $t0, end3    # If it's null, it's the end of the file_buffer

    # Otherwise, continue reading
    li $v0, 14                # Load syscall for reading from file
    move $a0, $s0             # Load file descriptor
    la $a1, file_buffer       # Load buffer to store file content
    li $a2, 1024              # Load input length
    syscall

    j read_loop3    # After reading, return to the read_loop3
     
    end3:
        		lw   $ra, 0($sp)        		# Deallocate space on the stack
        		addi $sp, $sp, 4
                           jr $ra                  # Return from subroutine                      
####################### Function to convert string to integer#################################
convertStringToInt:
    addi $sp, $sp, -8      # Allocate space on the stack for $ra and $k0
    sw   $ra, 4($sp)      # Save $ra and $k0 on the stack    
    sw   $k0, 0($sp)  
    
    move $t0, $a0   # Save the address of the input string
    li $t1, 0       # Initialize index to 0
    li $t2, 0       # Initialize integer result to 0
    li $k1, 0       # Initialize counter for the number of digits to 0

loop11:
    lb $t3, ($t0)   # Load character into $t3
    beqz $t3, doneee  # Exit loop if end of string

    beq $t3, '.', doneee    # Check if the character is a dot
    beq $t3, 10, doneee
    beq $t3, ',', doneee

    blt $t3, '0', not_digittt    # Check if the character is a digit
    bgt $t3, '9', not_digittt
    
    sub $t3, $t3, '0'    # Convert character to integer
    mul $t2, $t2, 10    # Multiply current result by 10 and add the digit
    add $t2, $t2, $t3  
    addi $k1, $k1, 1    # Increment the counter for the number of digits
    
not_digittt:
    addi $t0, $t0, 1   # Move to the next character
    j loop11

doneee:
    sw $t2, result    # Store the integer result
    move $k0, $t4
    lw $k0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra	        # Return from subroutine           
####################### Function to print_buffer-###############################		       	        		
print_buffer:  ### S0 hold the printed buffer
 addi $sp, $sp, -4  # Allocate space on the stack for $ra
 sw   $ra, 0($sp)  
    
start_print:
    lb $t0, ($s0)
    beqz $t0, end_print
    li $v0, 11
    move $a0, $t0
    syscall
    addi $s0, $s0, 1
    j start_print

end_print: 
    li $a0, 10
    li $v0, 11
    syscall
    la $a0, print
    li $v0, 4
    syscall
    lw   $ra, 0($sp)    # Restore $ra from the stack
    addi $sp, $sp, 4    # Deallocate space on the stack
    jr   $ra     #back to where it was last used     
####################### Function to exit_program-##############################		       	        		
exit_program:
    li $v0, 4             
    la $a0, exit_msg      
    syscall  
    li $v0, 10       		# system call code for exit program             	
    syscall	
