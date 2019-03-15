CandyType = input("What is your favorite type of candy? ")
Quantity = int(input("How much candy would you like? "))
Cost = float(input("What is the cost of 1 unit of "+ str(CandyType) + "? "))

print("The cost of", Quantity, "units of", CandyType," is $", Cost*Quantity)