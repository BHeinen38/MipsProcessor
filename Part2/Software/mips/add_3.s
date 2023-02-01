.data

.text

#load initial values
addi  $1,  $0,  1 		# Place 1 in $1
nop
nop
nop
andi  $2,  $1,  2		# Place 2 in $2
nop
nop
nop
ori  $3,  $2,  50 
nop
nop
nop
 
addi  $4,  $3,  20
nop
nop
nop
xor   $5,  $0,  40
nop
nop
nop
sub   $6,  $5,  $4
nop
nop
nop
and $9, $6, $5
nop
nop
nop

or $9, $6, $5
nop
nop
nop

nor $9, $6, $5
nop
nop
nop

bne $0, $0, exit
nop
nop
nop
nop
addi $8, $0, 5
j temp
nop 
nop
nop
nop



temp:
slt $7, $1,  $2
beq, $0,  $0,  exit
nop
nop
nop
nop

exit:
halt
nop
nop
nop
nop
