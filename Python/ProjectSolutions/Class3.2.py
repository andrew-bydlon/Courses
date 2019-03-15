UserString = input("Type a string of characters: ")
print(UserString[-1], UserString[1:len(UserString)-1],UserString[0],sep="")
Replace = input("Enter the string you would like to replace: ")
Replacement = input("Enter its replacement: ")
UpdateString = UserString[:UserString.find(Replace) + len(Replace)] + UserString.replace(Replace,Replacement)[UserString.find(Replace) + len(Replacement):]

# Here I print every character of the original string up to the end of the first occurence of the word,
# which occurs at character UserString.find(Replace) + len(Replace)-1
# Then I print the replaced version from that point onward.

# Alternative method
# UpdateString = UserString[:UserString.find(Replace) + len(Replace)] + UserString[UserString.find(Replace) + len(Replace):].replace(Replace,Replacement)

print(UpdateString)