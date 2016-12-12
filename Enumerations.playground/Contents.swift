enum CompassPoint {
    case north
    case south
    case east
    case west
}

enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.east
// now swift can infer the type
directionToHead = .north

// Matching Enumeration Values with a switch statement

// Switch must be exhaustive: you need to handle each case
switch directionToHead {
case .north:
    print("Where is cold")
case .south:
    print("Where is hot")
case .east:
    print("Where samurai eats cherries")
case .west:
    print("Where is no rules")
}

// or you can provide default
switch directionToHead {
case .west:
    print("One proper direction")
default:
    print("Go back!")
}

// Associated Values

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var product1 = Barcode.upc(5, 123431, 43343, 3)
var product2 = Barcode.qrCode("ABSHDHESKEKSKWOODOD")

switch product2 {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("\(numberSystem)")
case .qrCode(let code):
    print(code)
}
// if all associated values are constants or variables you can have one let or var keyword
switch product1 {
case let .upc(numberSystem, manufacturer, product, check):
    print("\(numberSystem)")
case let .qrCode(code):
    print(code)
}

//: # Raw values
//: ## explicit
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

//: ## implicit
enum Day: Int {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday // by default it starts from 0
}

enum YearQuarter: Int {
    case Q1 = 1, Q2, Q3, Q4 // next values are incremented
}

enum Season: String {
    case Spring, Summer, Autumn, Winter // implicit raw value same as each case
}

let currentDay = Day.Wednesday.rawValue // 2
let curentSeason = Season.Winter.rawValue // "Winter"
let curentQuater = YearQuarter.Q4.rawValue // 4

//: ## initialize from rawValue
// initializer always returns optional
if let maybeSunday = Day(rawValue: 7) {
    print("7th day of week")
}
if let sureSunday = Day(rawValue: 6) {
    print("Who da hell counts days from 0")
}

//: # Recursive Enumerations

enum ArithmeticExpression {
    case Number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

// (5 + 4) * 2
let five = ArithmeticExpression.Number(5)
let four = ArithmeticExpression.Number(4)
let two = ArithmeticExpression.Number(2)
let sum = ArithmeticExpression.addition(five, four)
let result = ArithmeticExpression.multiplication(sum, two)

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .Number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

evaluate(result) // 18