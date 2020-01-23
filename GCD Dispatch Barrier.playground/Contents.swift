import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//MARK: - #13 - GCD Dispatch Barrier

var array = [Int]()

//for i in 0...9 {
//    array.append(i)
//}
//
//print("Array: \(array)\nNumber of elements: \(array.count)") // sync call in .main

//DispatchQueue.concurrentPerform(iterations: 10) { (index) in // Race Condition
//    array.append(index)
//}
//
//print("Array: \(array)\nNumber of elements: \(array.count)")

class SafeArray<T> {
    private var array = [T]()
    private let queue = DispatchQueue(label: "Some concurrent queue", attributes: .concurrent)
    
    public func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }
    
    public var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }
}

var arraySafe = SafeArray<Int>()
DispatchQueue.concurrentPerform(iterations: 10) { (index) in
    arraySafe.append(index)
}

print("Array safe: \(arraySafe.valueArray)\nCount: \(arraySafe.valueArray.count)")
