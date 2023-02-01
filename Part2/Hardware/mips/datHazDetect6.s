#
# This tests a simple data dependency with I-type and R-type instructions
#

.data
.text
addi $t0, $0, 5
nor $t6, $t7, $t8
subi $t7, $0, 0
ori $t5, $0, 0    
subi $t1, $t6, 7  # 3 instructions between dependencies
nor $t8, $t5, $t0 # 2 instructions between dependencies
exit:
halt
