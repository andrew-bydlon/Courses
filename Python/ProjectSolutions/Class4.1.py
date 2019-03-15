Password = input("Enter your new password: ")
ExtraPW = input("Enter your password again: ")

if Password != ExtraPW:
    print("Your passwords are not the same!")
elif len(Password) < 8:
    print("Your password must be at least 8 characters!")
elif not Password[0].isalpha():
    print("Your passwords must begin with a letter!")
elif Password.find("@")<0 and Password.find("#")<0:
    print("Your password must contain @ or #")
else:
    print("Great password!")