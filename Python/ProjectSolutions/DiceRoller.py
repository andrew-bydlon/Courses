from random import randint

def DiceRoller(Quantity,Dice,Modifier):
    Roll = 0
    for i in range(Quantity):
        Roll += randint(1,Dice)
    return Roll+Modifier

def Main():
    ReRoll = 'n'
    while True:
        if ReRoll == 'n':
            Quant = input("How many dice would you like to roll? ")
            if Quant == "":
                Quant = 1
            elif Quant.isnumeric():
                Quant = int(Quant)
            else:
                print("Needs to be integral!")
                continue
            Dice = input("What die size would you like? ")
            if Dice == "":
                Dice = 20
            elif Dice.isnumeric():
                Dice = int(Dice)
            else:
                print("Needs to be integral!")
                continue
            Mod = input("Is there any modifier? ")
            if Mod == "":
                Mod = 0
            elif Mod.isnumeric():
                Mod = int(Mod)
            else:
                print("Needs to be integral!")
                continue
        elif ReRoll!='':
            print("Please input either y or n.")
            ReRoll = input("Would you like to reroll? ([y]es/[n]o, change parameters/[q]uit]").lower()
            continue
        if Mod<0:
            print(Quant, "d", Dice, Mod, " = ", DiceRoller(Quant, Dice, Mod), sep="")
        else:
            print(Quant, "d", Dice, "+", Mod, " = ", DiceRoller(Quant,Dice,Mod),sep="")
        ReRoll = input("Would you like to reroll? (yes/[n]o, change parameters/[q]uit]").lower()
        if ReRoll=='q':
            break

Main()
