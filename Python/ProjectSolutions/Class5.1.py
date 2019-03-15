ListInvestments=[]
r=float(input("What is your rate of return? "))
n=float(input("What is your compounding frequency? "))

while True:
	P = input("Enter a principal investment.  Type 'q' to quit. ")
	if P == 'q':
		break
	t = float(input("How many years did you keep this investment? "))

	if not P.isdigit():
		print("P must be a number! ")
		continue
	else:
		ListInvestments += [float(P)*(1+r/n)**(n*t)]

print("Your largest investment is $", format(max(ListInvestments),"2f"))
print("Your smallest investment is $", format(min(ListInvestments),"2f"))
print("Your total investment is $", format(sum(ListInvestments),"2f"))
