#
# This tests a simple data dependency with I-type instructions
#

.data
.text
addi $t0, $0, 5
addi $t4, $0, 0 # 1 instruction between dependencies
subi $t1, $t0, 7
exit:
halt
