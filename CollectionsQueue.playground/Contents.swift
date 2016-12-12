protocol Queue {
    associatedtype Element
    mutating func enqueue(_ newElement: Element)
    mutating func dequeue() -> Element?
}

struct FIFOQueue<Element>: Queue {
    fileprivate var left: [Element] = []
    fileprivate var right: [Element] = []
    
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

extension FIFOQueue: Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    public subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

extension FIFOQueue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(left: elements.reversed(), right: [])
    }
}

var q = FIFOQueue<String>()

// We can iterate over queues
for x in ["1", "foo", "2", "bar"] {
    q.enqueue(x)
}

for s in q {
    print(s, terminator: "-")
}

// We can pass queues to methods that take sequences
var a = Array(q)
a.append(contentsOf: q[2...3])

// We can call methods and properties that extend Sequence
q.map { $0.uppercased() }
q.flatMap { Int($0) }
q.filter { $0.characters.count > 1 }
q.sorted()
q.joined(separator: "-")

// And we can call methods and properties that extend Collection
q.isEmpty
q.count
q.first

// Thanks to ExpressibleByArrayLiteral extension
let queue: FIFOQueue = [1,2,3]

