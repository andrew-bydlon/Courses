N = int(input("Enter an integer: "))
d = int(input("Enter a divisor: "))
e = int(input("Enter another divisor: "))

for i in range(0,N+1):
    if i%d == 0 and i%e==0:
        print(":)")
    elif i%d== 0:
        print("Multiple of first divisor.")
    elif i%e == 0:
        print("Multiple of second divisor.")
    else:
        print(i)