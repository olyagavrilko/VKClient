import UIKit

protocol Coffee {
    var cost: Int { get }
}

protocol CoffeeDecorator: Coffee {
    var baseDrink: Coffee { get }
    init(base: Coffee)
}

class SimpleCoffee: Coffee {
    var cost: Int {
        return 100
    }
}

class CoffeeWithMilk: CoffeeDecorator {
    var baseDrink: Coffee
    var cost: Int {
        return baseDrink.cost + 20
    }

    required init(base: Coffee) {
        baseDrink = base
    }
}

class CoffeeWithSugar: CoffeeDecorator {
    var baseDrink: Coffee
    var cost: Int {
        return baseDrink.cost + 5
    }

    required init(base: Coffee) {
        baseDrink = base
    }
}

class CoffeeWithWhip: CoffeeDecorator {
    var baseDrink: Coffee
    var cost: Int {
        return baseDrink.cost + 50
    }

    required init(base: Coffee) {
        baseDrink = base
    }
}

let coffee = SimpleCoffee()

let coffeeWithMilk = CoffeeWithMilk(base: coffee)
let coffeeWithSugarAndMilk = CoffeeWithSugar(base: coffeeWithMilk)
let coffeeWithSugar = CoffeeWithSugar(base: coffee)
let coffeeWithWhipAndSugar = CoffeeWithWhip(base: coffeeWithSugar)

print(coffeeWithMilk.cost)
print(coffeeWithSugarAndMilk.cost)
print(coffeeWithSugar.cost)
print(coffeeWithWhipAndSugar.cost)
