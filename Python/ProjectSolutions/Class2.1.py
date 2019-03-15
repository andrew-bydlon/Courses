P = float(input("How much money would you like to invest? "))
r = float(input("What is the annual rate of interest (express 5% as .05)? "))
n = float(input("How many times per year is the interest compounded? "))
t = float(input("For how many years will you keep this investment? "))

A = P*pow(1+r/n, n*t)

print("Your annuity after", t, "years is $", format(A,".2f"), ". You have earned $", format(A-P,".2f"))