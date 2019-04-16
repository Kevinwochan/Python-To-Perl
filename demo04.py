#!/usr/bin/python3

#subset 4

array = [5,4,3,2,1]

print ("original array is ")
print (array)

# testing popping
variable = array.pop()
print (variable)

# testing append
array.append( 6 )
print ( array )

# testing indexing

variable= array.index( 3 )
print (variable)

# testing sorted 
array = sorted( array )
print (array)

# testing len
variable= len(array)
print (variable)

# testing sys.stdin.readlines
inputLines = sys.stdin.readlines()
print (inputLines)

