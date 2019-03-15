ListInvestments=[]

r=float(input("What is your rate of return? "))
n=float(input("What is your compounding frequency? "))

MyFileName =float(input("Enter the name of your file: "))
MyFile = open(MyFileName,"r")

P = list(map(float, (MyFile.readline().strip("\n")).split()))
t = list(map(float, (MyFile.readline().strip("\n")).split()))

i = 0

while i<min(len(P),len(t)):
	ListInvestments += [P[i]*(1+r/(n*t[i]))]
	i+= 1

print("Your largest investment is $", format(max(ListInvestments),"2f"))
print("Your smallest investment is $", format(min(ListInvestments),"2f"))
print("Your total investment is $", format(sum(ListInvestments),"2f"))

MyAnnuity = open("Annuity.txt","w")
MyAnnuity.write(str(ListInvestments))