 
 #!/usr/bin/python3

 
 #subset 2

 
 #logical operators

# truth is 1, so not of 0 is 1 => true
if not 0:
    print ("0 is True! not operator success")
# and operator 
if 0 and not 1:
    print ("0 is True and 1 is False! and operator success")
# or operator
if 0 or 1 :
    print ("either 1 is true or 2 is true or operator success") 
 
# comparison operators

if 2 > 8:
    print ("2 is greater than 8! > comparison success")
if not 2 < 8:
    print ("and 2 is not smaller than 8")
if 2 => 2:
    print ("2 is greater than or equal to uhh 2?")
if 3 <= 3:
    print ("3 is smaller than or equal to ...3")
if not 3 != 3:
    print ("3 is not not equal to 3, 3 is equal to 3")
if 3 == 3:
    print ("3 is equal to 3")

 
 #bitwise operations
 
 # taken from https://www.tutorialspoint.com/python/bitwise_operators_example.htm

var1 = 60            
 
 # 60 = 0011 1100 
var2 = 13            
 
 # 13 = 0000 1101 
var3 = 0

var3 = var1 & var2;         
 # 12 = 0000 1100
print ("Line 1 - Value of var3 is ")
print (var3)
print ()

var3 = var1 | var2;         
# 61 = 0011 1101 
print ("Line 2 - Value of var3 is ")
print (var3)
print ()
var3 = var1 ^ var2;         
 # 49 = 0011 0001
print ("Line 3 - Value of var3 is ")
print (var3)
print ()
var3 = ~var1;            
 # 18446744073709551555 = 1100 0011 (floating point arithmetic)
print ("Line 4 - Value of var3 is ")
print (var3)
print ()
var3 = var1 << 2;        
 # 240 = 1111 0000
print ("Line 5 - Value of var3 is ")
print (var3)
print ()
var3 = var1 >> 2;        
 # 15 = 0000 1111
print ("Line 6 - Value of var3 is ")
print (var3)
print ()

var2 = 12

#Value of var1 = 60 and value of var2 = 13
#Value of var1 & var2 = 12
#Value of var1 | var2 = 61
#Value of var1 ^ var2 = 49
#Value of ~var1 = -61
#Value of var1 << 2 = 240
#Value of var1 >> 2 = 15 


#inline ifstatemetns
if 3 != 27 : print ("inline If statements working");
 
print()
 # inline while statements
while var2 >= 2 : print(var2); var2 = var2 / 2;
var3 = 30
print ()
 

