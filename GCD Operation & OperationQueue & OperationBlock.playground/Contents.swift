import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//MARK: - #15 - Operation & OperationQueue & OperationBlock

//TOREAD: https://developer.apple.com/documentation/foundation/operation, https://developer.apple.com/documentation/foundation/operationqueue

//Operation - is an abstract class that represents the code and data associated with a single task. Operation is a finished task and abstract class, which represents thread-safe structure for modeling the state of operation and it's priority.

//Operation lifecylce: pending -> ready(to execute) -> executing -> finished. There is also cancelled case.

//OperationQueue - is a queue that regulates the execution of operations.

//The main difference comparing to DispatchQueue is that we can set maxConcurrentOperationsCount: Int

print("0️⃣The current thread is: \(Thread.current)")

//let operation1 = { // just a closure
//    print("Starting operation1")
//    print("The current thread in: \(Thread.current)")
//    print("Finish operation1")
//}
//
//let queue = OperationQueue()
//queue.addOperation(operation1) // not thread-safe

var result: String? = ""
let concatOperation = BlockOperation { // sync
    result = "The result value has been changed."
    print("The current thread is: \(Thread.current)")
}

//concatOperation.start()
//print(result!)

let queue = OperationQueue()
queue.addOperation(concatOperation)
print(result!)


let queue2 = OperationQueue()
queue2.addOperation {
    print("Testing . . .")
    print("The current thread is: \(Thread.current)")
}

class MyThread: Thread {
    override func main() {
        print("Test main thread")
        print("The current thread is: \(Thread.current)")
    }
}

let myThread = MyThread()
myThread.start()

class OperationA: Operation {
    override func main() {
        print("Test operation A")
        print("The current thread is: \(Thread.current)")
    }
}

let operationA = OperationA()
//operationA.start()

let queue3 = OperationQueue()
queue3.addOperation(operationA)
