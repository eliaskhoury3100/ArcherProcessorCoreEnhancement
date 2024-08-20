test1:
    addi x10, x0, 23
    addi x11, x0, 3
    addi x12, x0, 102
    mul  x15, x10, x11 #we expect the output to be 69
    mulh x16, x10, x11 #we expect the output to be 0
    mulhsu x17, x10, x11 #we also expect the output to be 0
    mulhu x18, x10, x11 # we expect 0

    div  x19, x10, x11 # we expect the output to be 7
    divu  x20, x10, x11 # we expect 7 also
    rem  x21, x10, x11 # we expect the output to be 2
    remu x22, x10, x11 #also we expect 2

    
test2:
    addi x10, x0, 173
    mul  x10, x10, x10 #x10 contains now 29929
    addi x10, x10, 71  #this is done so that x10 contains 30000 now
    addi x11, x0, -1
    mul   x13, x10, x11 #we expect the output to be -30000 because it is FFFF8AD0
    mulh  x14, x10, x11 #we expect the output to be -1 because it is FFFFFFFF (sign extend of -30000)
    mulhu x15, x10, x11 #we expect the output to be 29999
    mulhsu x16, x10, x11 #we expect the output to be 29999 since it is taking the second as unsigned and the first is already unsigned
    
test3:
    addi x12, x0, 8
    slli, x12, x12, 28 #we are initializing x12 to be used to indicate overflow. the output will be 0x80000000 or -2147483648 because this is what will be stored in x12
    div x17, x10, x0 #we expect the output to be -1 and the div_zero signal to be asserted
    div x18, x12, x11 #we expect the output to be 0x80000000 or -2147483648 and the overflow signal to be asserted
    divu x19, x10, x11 #we expect the output to be 0 since we are performing 30000/4294967295
    rem x20, x10, x11 #we expect the output to be 0 since we are performing 30000%-1
    remu x21, x10, x11 #we expect the output to be 30000 since we are performing 30000%4294967295
    