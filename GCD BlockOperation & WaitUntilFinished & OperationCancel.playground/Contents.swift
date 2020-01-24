import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//MARK: - #16 - BlockOperation & WaitUntilFinished & OperationCancel
//waitUntilFinished() is pretty simmilar to Barrier in GCD

let operationQueue = OperationQueue()

class OperationCancelTest: Operation {
    override func main() {
        if isCancelled {
            print("The operation is cancelled: \(isCancelled)")
            return
        }
        print("Testing 1")
        sleep(1)
        if isCancelled {
            print("The operation is cancelled: \(isCancelled)")
            return
        }
        print("Testing 1")
    }
}

func cancelOperationMethod() {
    let cancelOperation = OperationCancelTest()
    operationQueue.addOperation(cancelOperation)
    cancelOperation.cancel() //uncomment to test cancelling the operation
}

cancelOperationMethod()

class WaitOperationTest {
    private let operationQueue = OperationQueue()
    
    func testing() {
        operationQueue.addOperation {
            sleep(1)
            print("0️⃣ WaitOperationTest")
        }
        operationQueue.addOperation {
            sleep(1)
            print("1️⃣ WaitOperationTest")
        }
        operationQueue.waitUntilAllOperationsAreFinished() // will no execute other functions untill above are finished
        operationQueue.addOperation {
            sleep(1)
            print("2️⃣ WaitOperationTest")
        }
        operationQueue.addOperation {
            sleep(1)
            print("3️⃣ WaitOperationTest\n")
        }
    }
}

let waitOperationTest = WaitOperationTest()
waitOperationTest.testing()


class WaitOperationTest2 {
    private let operationQueue = OperationQueue()
    
    func testing() {
        let operation1 = BlockOperation {
            sleep(1)
            print("Executing operation1️⃣ in WaitOperationTest2️⃣")
        }
        let operation2 = BlockOperation {
            sleep(2)
            print("Executing operation2️⃣ in WaitOperationTest2️⃣")
        }
        
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: true)
    }
}

let waitOperationTest2 = WaitOperationTest2()
waitOperationTest2.testing()

class CompletionBlockTest {
    private let operationQueue = OperationQueue()
    
    func test() {
        let operation = BlockOperation {
            sleep(5)
            print("Testing CompletionBlockTest")
        }
        operation.completionBlock = {
            print("Finish testing CompletionBlockTest")
        }
        operationQueue.addOperation(operation)
    }
}

let completionBlockTest = CompletionBlockTest()
completionBlockTest.test()
