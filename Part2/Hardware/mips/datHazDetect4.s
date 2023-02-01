#
# This tests a simple data dependency with I-type and R-type instructions
#

.data
.text
addi $t0, $0, 5
nor $t6, $t7, $t8
addi $t4, $0, 0
ori $t5, $0, 0    # 3 instructions between dependencies
subi $t1, $t0, 7
exit:
halt
