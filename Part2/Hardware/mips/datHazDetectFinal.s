#
# This tests a simple data dependency with I-type instructions
#

.data
.text

#load initial values
addi  $1,  $0,  1 		# Place 1 in $1

addi  $2,  $0,  2

addi  $3,  $0,  3

addi  $4,  $0,  4

addi  $5,  $0,  5

addi  $6,  $5,  6 # 0 inbetween

addi  $7,  $0,  9

addi  $1,  $6,  9 # 1 inbetween

addi  $2,  $0,  9
addi  $2,  $0,  9

addi  $2,  $1,  9 # 2 inbetween

addi  $3,  $0,  9
addi  $3,  $0,  9
addi  $3,  $0,  9

addi  $3,  $2,  9 # 3 inbetween

addi  $4,  $0,  9
addi  $4,  $0,  9
addi  $4,  $0,  9
addi  $4,  $0,  9

addi  $4,  $3,  9 # 4 inbetween

exit:
halt
