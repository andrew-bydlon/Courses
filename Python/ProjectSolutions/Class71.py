class Pet:
    def __init__(self,name="",age=0,weight=0.0):
        self.name = name
        self.age = age
        self.weight = weight

    def WeightKG(self):
        return self.weight*0.453592

class Dog(Pet):
	def __init__(self, age=0,size=""):
		name = input("What is the dogs name? ")
		weight = int(input("What is the dogs weight?"))
		super().__init__(name, age, weight)
		self.age = age
		self.size = size

	def AgeDoggyYears(self):
		return self.age*7

	def WalkingTime(self):
		return self.weight/20

	def FoodCosts(self):
		print("You should feed your dog", self.weight/50, "lbs of food per day.  This will cost you approximately $" + format(self.weight/80,".2f") + " per day or $" + format(self.weight*.375,".2f") + " per month.")

class Cat(Pet):
	def __init__(self, age=""):
		self.age = age

	def AgeCatYears(self):
		return self.age*6

	def LitterBox(self):
		print("You need that!")

class Poodle(Dog):
	def __init__(self, name=""):
		self.name = name
		size = input("What is the dogs name? ")
		name = int(input("What is the dogs weight?"))
		super().__init__(10, "Medium")

	def GroomingCosts(self):
		GroomFreq = int(input("How many times per year would you like to groom" +str(self.name) + "? "))
		return 75*GroomFreq