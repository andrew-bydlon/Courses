Suits = ["Club","Spade","Heart","Diamond"]
from random import randint,choice

def Overlap(Deal,Card):
	if Card not in Deal:
		Deal += [Card]
	return Deal

def RandomCardGenerator():
	Card = [randint(2,14), choice(Suits)]
	return Card

def HandCreator(MyInt):
	Hand = []
	while len(Hand)<MyInt:
		Hand = Overlap(Hand,RandomCardGenerator())
	return Hand