try:
	MyInteger = input("Enter your favorite integer: ")
	if int(MyInteger)!= float(MyInteger):
		raise RuntimeError("You need to enter an integer without decimals")
except:
	print("You need to enter an integer!")
	raise TypeError

try:
	MyFloat = float(input("Enter your favorite decimal number: "))
except:
	print("You need to enter a floating point number! ")
	raise TypeError
MyString = input("Enter an alphanumeric string: ")
if not MyString.isalnum():
	raise RuntimeError("Your string needs to be composed of letters and numbers")

print("Good job!")