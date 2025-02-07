.data
true_msg:   .asciz "true\n"
false_msg:  .asciz "false\n"
buffer:     .space 10    # Input buffer for reading integer

.text
main:
    # Read integer from console
    li a7, 63         # syscall: Read
    li a0, 0          # stdin
    la a1, buffer     # Load address of input buffer
    li a2, 10         # Read max 10 bytes
    ecall

    # Convert input string to integer
    la a0, buffer     # Load buffer address
    call atoi         # Convert to integer

    # Call prime function
    mv a0, a0        # Argument: p (input number)
    call prime       # Call function
    beqz a0, print_false  # If result is 0 (false), print "false"
    j print_true

print_false:
    la a0, false_msg  # Load address of "false" string
    j print_result

print_true:
    la a0, true_msg   # Load address of "true" string
    j print_result

print_result:
    li a7, 64        # syscall: Write
    li a0, 1         # stdout
    mv a1, a0        # Message address
    li a2, 6         # Length of string
    ecall

    # Exit program
    li a7, 93        # syscall: Exit
    ecall

# Function: prime(int p)
# Returns 1 if prime, 0 if not
prime:
    li t3, 2         # t3 = 2 (start of loop)
    bge a0, t3, check_loop  # If p >= 2, continue
    li a0, 0         # Return 0 (false)
    ret

check_loop:
    mv t4, a0        # t4 = p
    li t5, 2         # t5 = loop index i

loop:
    bge t5, t4, return_true  # If i >= p, return true

    # Compute p % i
    div t6, t4, t5   # t6 = p / i
    mul t6, t6, t5   # t6 = (p / i) * i
    sub t6, t4, t6   # t6 = p - ((p / i) * i)  (this is p % i)

    beqz t6, return_false  # If remainder == 0, return false
    addi t5, t5, 1  # Increment i
    j loop

return_true:
    li a0, 1         # Return 1 (true)
    ret

return_false:
    li a0, 0         # Return 0 (false)
    ret

# Function: atoi (string to integer)
atoi:
    li t0, 0        # Result = 0
    li t1, 10       # Multiplier (base 10)

atoi_loop:
    lbu t2, 0(a0)   # Load byte from string
    beqz t2, atoi_done  # Stop if null terminator
    li t3, '0'      # ASCII of '0'
    sub t2, t2, t3  # Convert ASCII to number
    mul t0, t0, t1  # result *= 10
    add t0, t0, t2  # result += digit
    addi a0, a0, 1  # Move to next character
    j atoi_loop

atoi_done:
    mv a0, t0       # Return result
    ret
