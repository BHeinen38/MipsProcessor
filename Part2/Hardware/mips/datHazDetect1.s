#
# This tests a simple data dependency with I-type instructions
#

.data
.text
addi $t0, $0, 5 # No instructions inbetween dependencies
addi $t1, $t0, 7
exit:
halt
