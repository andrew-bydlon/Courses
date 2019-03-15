P = float(input("How much money would you like to invest? "))
r = float(input("What is the annual rate of interest (express 5% as .05)? "))
n = float(input("How many times per year is the interest compounded? "))
t = float(input("For how many years will you keep this investment? "))

A = P*pow(1+r/n,n*t)

Awish = float(input("How much money would you like to have after " + str(t) + " years?"))
rwish = n * ((Awish/P)**(1/(n*t))-1)

print("It is", Awish<= A, "that you will have the desired money after", t, "years.  The required interest rate to achieve your goal is", format(rwish,".2%"))