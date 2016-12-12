//: # Generic functions
//: ## some not generic funcion
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let tempA = a
    a = b
    b = tempA
}

var someInt = 4
var anotherInt = 5

swapTwoInts(&someInt, &anotherInt)

print(someInt, anotherInt)

//: ## generic version

func swapTwoValues<T>(_ a: inout T, _ b: inout T){
    let tempA = a
    a = b
    b = tempA
}


swapTwoValues(&someInt, &anotherInt)
print(someInt, anotherInt)

var string1 = "one"
var string2 = "two"

swapTwoValues(&string1, &string2)
print(string1, string2)

//: # Generic Types
//: ## Writing Stack
//: ### Non generic version

struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

//: ### Generic Stack
struct Stack<Element>{
    var items = [Element]()
    mutating func push(_ item: Element){
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

//: #### Usage
var stackOfStrings = Stack<String>()
stackOfStrings.push("One")
stackOfStrings.push("Two")
stackOfStrings.pop()

//: #### Extending Generic Stack
extension Stack { //extension does not define a type parameter list
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
//: #### Usage of extended functionality
if let topItem = stackOfStrings.topItem {
    print(topItem)
}

//: # Type constraints

//: ## Some non generic function 
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
//: ## Generic version

func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

//: # Associated Types

protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}
//: ## non-generic
// if non-generic type conforms to protocol you need to specify associated value
// by typealias

struct IntStack2: Container {
    var items = [Int]()
    
    mutating func push (_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // Container protocol
    typealias ItemType = Int // Thanks to Swift’s type inference, you don’t actually need to declare a concrete ItemType of Int as part of the definition of IntStack.

    mutating func append(_ item: Int) { // Swift will infer ItemType from this function looking on its parameters
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

var intStack2 = IntStack2()
intStack2.append(4)
intStack2.count

//: ## generic

struct Stack2<Element>: Container {
    var items = [Element]()
    
    mutating func push (_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    // Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

var stack2 = Stack2<String>()
stack2.append("AAA")
stack2.count
stack2[0]
var stack3 = Stack2<Int>()
stack3.push(3)
stack3.append(4)
stack3.count
stack3[0]
stack3[1]

//: # Generic where clause
extension Array: Container {}


func allItemsMatch<C1: Container, C2: Container> (_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
    if someContainer.count != anotherContainer.count {
        return false
    }
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
}
// now we can compare two different containers, even if they are of a different container type
var stackOfStrings2 = Stack2<String>()
stackOfStrings2.push("ala")
stackOfStrings2.push("ma")
stackOfStrings2.push("kota")

stackOfStrings2.count

var arrayOfStrings2 = ["ala", "ma", "kota"]

if allItemsMatch(stackOfStrings2, arrayOfStrings2) {
    print("All items match")
} else {
    print("Not all items match")
}






