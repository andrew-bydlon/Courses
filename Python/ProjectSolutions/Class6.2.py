from math import sqrt,pi

class Ellipse:
    def __init__(self,ma=0.0,MA=0.0):
        self.ma = ma
        self.MA = MA
    def FocalLength(self):
        return sqrt(self.MA**2-self.ma**2)
    def Area(self):
        return pi*self.MA*self.ma
    def Perimeter(self):
        return 2*pi*sqrt((self.MA**2+self.ma**2)/2)

MA = float(input("Enter your ellipse major axis: "))
ma = float(input("Enter your ellipse minor axis: "))

MyEllipse = Ellipse(ma,MA)

print("The focal length of your ellipse is", MyEllipse.FocalLength())
print("The area of your ellipse is", MyEllipse.Area())
print("The perimeter of your ellipse is", MyEllipse.Perimeter())