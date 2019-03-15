class Class:
	def __init__(self,name="",subject="",studentlist=[]):
		self.name = name
		self.subject = subject
		self.students = studentlist

	def __add__(self,Class2):
		NewClass = self
		NewClass.name += " & " + Class2.name
		NewClass.students +=  Class2.students
		return NewClass

	def __mul__(self, Class2):
		m = min(len(self.students),len(Class2.students))
		NewClass = self
		PairList = []
		for i in range(0,m):
			if self.students[i]!=Class2.students[i]:
				PairList += [[self.students[i],Class2.students[i]]]
		NewClass.students = PairList
		return NewClass

	def __eq__(self, Class2):
		return self.students==Class2.students

	def __ne__(self, Class2):
		return not self==Class2

Python = Class("Introduction to Python", subject="Math", studentlist=["Jacob","Benjamin","Mia","ManyMore"])
AddPython = Python + Python
print(AddPython.name, AddPython.subject, AddPython.students)
MultiplyPython = Python*Python
print(MultiplyPython.name, MultiplyPython.subject, MultiplyPython.students)
PythonOld = Class("Introduction to Python", subject="Math", studentlist=["Jacob","Benjamin","Mia","ManyMore"])
print(Python == Python, PythonOld == AddPython)