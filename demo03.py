#!/usr/bin/python3

import sys

#subset 3
# sys.stdin and int type casting 
# From Andrew Taylor's lecture example
sys.stdout.write("Enter a number: ")
a = int(sys.stdin.readline())
if a < 0:
    print("negative")
elif a == 0:
    print("zero")
elif a < 10:
    print("small")
else:
    print("large")
c = 15

#mutliline if and while statement
while c != 0:
    c -= 1
    if c == 12 :
        continue
    if c == 9:
        break
    print(c) 

#multiline for loop
i = 0
for i in range (4,9) :     
   if i == 6:
      continue
   print ("Current number :")
   print (i)


sys.stdout.write("stdout.write working!\n")
