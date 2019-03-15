def ListElementTracker(MyList,MyInt):
    PosList = []
    i = 0
    N = MyList.count(MyInt)
    while i<N:
    	PosList += [MyList.index(MyInt)+i]
    	MyList.remove(MyInt)
    	i+=1
    return PosList

def ListReverser(MyList):
    MyList.reverse()
    return MyList

print("Enter some integers separated by spaces: ", end="")
UserList = [int(x) for x in input().split()]
M = int(input("Enter an integer to search for: "))
print("The positions of", M, "are", ListElementTracker(UserList,M))
print("Enter some integers separated by spaces: ", end="")
UserList2 = [int(x) for x in input().split()]
print("The position list of", M, "in the reversed list is", ListElementTracker(ListReverser(UserList2),M))
