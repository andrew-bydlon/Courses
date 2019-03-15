UserString = input("Type a string of characters: ")
print("Your string has length", len(UserString))

Excerpt = input("Type what you are looking for: ")
print("It is", Excerpt in UserString, "that '", Excerpt, "' occurs in '", UserString, "'!")

N = int(input("Enter an integer to partition your string: "))
print(UserString[:N],UserString[-N:],sep="$#@!")