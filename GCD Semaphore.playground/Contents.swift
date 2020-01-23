import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//MARK: - GCD Semaphore

let queue = DispatchQueue(label: "Custom concurrent queue", attributes: .concurrent)

let numberOfThreads = 2 // if we change this value to 1 => it will run one after another

let semaphore = DispatchSemaphore(value: numberOfThreads) //this semaphore can pass 2 threads

queue.async {
    semaphore.wait() // DispatchSemaphore.value - 1
    sleep(3)
    print("Method 1")
    semaphore.signal() // DispatchSemaphore.value + 1
}

queue.async {
    semaphore.wait() // DispatchSemaphore.value - 1
    sleep(3)
    print("Method 2")
    semaphore.signal() // DispatchSemaphore.value + 1
}

queue.async {
    semaphore.wait() // DispatchSemaphore.value - 1
    sleep(3)
    print("Method 3")
    semaphore.signal() // DispatchSemaphore.value + 1
}

let sem = DispatchSemaphore(value: 2)

DispatchQueue.concurrentPerform(iterations: 10) { (id: Int) in
    sem.wait(timeout: DispatchTime.distantFuture)
    sleep(1)
    print("Block \(id)")
    sem.signal()
}

class SemaphoreTest {
    private let semaphoreTest = DispatchSemaphore(value: 2)
    private var array = [Int]()
    
    private func methodWork(_ id: Int) {
        semaphoreTest.wait()
        array.append(id)
        print("This is a test array count: \(array.count)")
        Thread.sleep(forTimeInterval: 1)
        semaphoreTest.signal()
    }
    
    public func startAllThreads() {
        DispatchQueue.global().async {
            self.methodWork(111)
            print("The current thread is \(Thread.current)")
        }
        DispatchQueue.global().async {
            self.methodWork(222)
            print("The current thread is \(Thread.current)")
        }
        DispatchQueue.global().async {
            self.methodWork(333)
            print("The current thread is \(Thread.current)")
        }
        DispatchQueue.global().async {
            self.methodWork(444)
            print("The current thread is \(Thread.current)")
        }
    }
}

let semaphoreTest = SemaphoreTest()
semaphoreTest.startAllThreads()

