import UIKit

// MARK: - #1 - Thread & Pthread

//TOREAD - Thread, Operation, GCD. https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/Introduction/Introduction.html#//apple_ref/doc/uid/10000057i-CH1-SW1

//Queue: Parallel(Concurrent), Serial(Последовательная очередь), Asynchronous

//Parallel(Concurrent)
//1Thread  ----------
//2Thread  ----------

//Serial(Последовательная очередь)
//1Thread   - - - - -
//2Thread  - - - - -

//Asynchronous
//1Main(UI) ----------
//2Thread        -

//Unix - POSIX

var pthread1 = pthread_t(bitPattern: 0) //create C thread
var attribute1 = pthread_attr_t() // create C attribute
pthread_attr_init(&attribute1)

pthread_create(&pthread1, &attribute1, { (pointer) -> UnsafeMutableRawPointer? in
    print("This code will be runned in the thread we created (C) (#1 - Thread & Pthread)")
    return nil
}, nil)

//iOS

var nsthread1 = Thread {
    print("This code will be runned in the thread we created (Swift) (#1 - Thread & Pthread)")
}
nsthread1.start()

// MARK: - #2 - Quality of Service(QoS)/Priorities

//TOREAD - https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html, https://www.raywenderlich.com/5370-grand-central-dispatch-tutorial-for-swift-4-part-1-2

var pthread2 = pthread_t(bitPattern: 0)
var attribute2 = pthread_attr_t()

pthread_attr_init(&attribute2)
pthread_attr_set_qos_class_np(&attribute2, QOS_CLASS_USER_INITIATED, 0) // set a priority for attribute2
pthread_create(&pthread2, &attribute2, { (pointer) -> UnsafeMutableRawPointer? in
    print("This code will be runned in the thread we created (C) (#2 Quality of Service(QoS))")
    pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0) //put the thread in background after running the above code
    return nil
}, nil)

// QOS_CLASS_USER_INTERACTIVE -     Work that is interacting with the user, such as operating on the main thread, refreshing the user interface, or performing animations. If the work doesn’t happen quickly, the user interface may appear frozen. Focuses on responsiveness and performance. Work is virtually instantaneous.
// QOS_CLASS_USER_INITIATED -       Work that the user has initiated and requires immediate results, such as opening a saved document or performing an action when the user clicks something in the user interface. The work is required in order to continue user interaction. Focuses on responsiveness and performance. Work is nearly instantaneous, such as a few seconds or less.
// QOS_CLASS_DEFAULT -              The priority level of this QoS falls between user-initiated and utility. This QoS is not intended to be used by developers to classify work. Work that has no QoS information assigned is treated as default, and the GCD global queue runs at this level.
// QOS_CLASS_UTILITY -              Work that may take some time to complete and doesn’t require an immediate result, such as downloading or importing data. Utility tasks typically have a progress bar that is visible to the user. Focuses on providing a balance between responsiveness, performance, and energy efficiency. Work takes a few seconds to a few minutes.
// QOS_CLASS_BACKGROUND -           Work that operates in the background and isn’t visible to the user, such as indexing, synchronizing, and backups. Focuses on energy efficiency. Work takes significant time, such as minutes or hours.
// QOS_CLASS_UNSPECIFIED -          This represents the absence of QoS information and cues the system that an environmental QoS should be inferred. Threads can have an unspecified QoS if they use legacy APIs that may opt the thread out of QoS.

let nsthread2 = Thread {
    print("This code will be runned in the thread we created (Swift) (#2 Quality of Service(QoS))")
    print(qos_class_self())
}
nsthread2.qualityOfService = .userInteractive
nsthread2.start()
print(qos_class_main())

// MARK: - #3 - Synchronization & Mutex

//TOREAD - https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafety/ThreadSafety.html#//apple_ref/doc/uid/10000057i-CH8-SW1, https://www.cocoawithlove.com/blog/2016/06/02/threads-and-mutexes.html, https://en.wikipedia.org/wiki/Mutual_exclusion, https://en.wikipedia.org/wiki/Semaphore_(programming)

// Imagine we have array and 2 theads. Both of them are trying to append or read data from/to the array. This will cause data corruption. This is where Mutex will help. Synchronization is like saying "hey threads, please form a queue if you want to work with this array"

// Semaphore - is a variable or abstract data type used to control access to a common resource by multiple processes in a concurrent system such as a multitasking operating system. A semaphore is simply a variable. This variable is used to solve critical section problems and to achieve process synchronization in the multi processing environment. A trivial semaphore is a plain variable that is changed (for example, incremented or decremented, or toggled) depending on programmer-defined conditions.

// Семафо́р (англ. semaphore) — примитив синхронизации работы процессов и потоков, в основе которого лежит счётчик, над которым можно производить две атомарные операции: увеличение и уменьшение значения на единицу, при этом операция уменьшения для нулевого значения счётчика является блокирующейся. Служит для построения более сложных механизмов синхронизации и используется для синхронизации параллельно работающих задач, для защиты передачи данных через разделяемую память, для защиты критических секций, а также для управления доступом к аппаратному обеспечению. Семафоры могут быть двоичными и вычислительными. Вычислительные семафоры могут принимать целочисленные неотрицательные значения и используются для работы с ресурсами, количество которых ограничено, либо участвуют в синхронизации параллельно исполняемых задач. Двоичные семафоры являются частным случаем вычислительного семафора и могут принимать только два значения: 0 и 1.

// Mutex(Mutual exclusion) - is a property of concurrency control, which is instituted for the purpose of preventing race conditions. It is the requirement that one thread of execution never enters its critical section at the same time that another concurrent thread of execution enters its own critical section, which refers to an interval of time during which a thread of execution accesses a shared resource, such as shared memory.

// Мью́текс (англ. mutex, от mutual exclusion — «взаимное исключение») — аналог одноместного семафора, служащий в программировании для синхронизации одновременно выполняющихся потоков. Мьютекс отличается от семафора тем, что только владеющий им поток может его освободить, т.е. перевести в отмеченное состояние. Мьютексы — это простейшие двоичные семафоры, которые могут находиться в одном из двух состояний — отмеченном или неотмеченном (открыт и закрыт соответственно). Когда какой-либо поток, принадлежащий любому процессу, становится владельцем объекта mutex, последний переводится в неотмеченное состояние. Если задача освобождает мьютекс, его состояние становится отмеченным. Цель использования мьютексов — защита данных от повреждения в результате асинхронных изменений (состояние гонки), однако могут порождаться другие проблемы — например взаимная блокировка (клинч).

class CSaveThread3 {
    private var mutex3 = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex3, nil)
    }
    
    func someMethod(completion: () -> Void) { // some function that will make a protection of the object
        pthread_mutex_lock(&mutex3)
        completion()
        defer { //will run even if app crashes
            pthread_mutex_unlock(&mutex3)
        }
    }
}

var array3 = [String]()

let saveThread3 = CSaveThread3()
saveThread3.someMethod {
    print("This code will be runned in the mutex thread we created (C) (#3 Synchronization & Mutex)")
    array3.append("1 thread")
}

array3.append("2 thread")

array3.removeAll()

class SwiftSafeThread3 {
    private let lockMutex = NSLock() // You should not use this class to implement a recursive lock. Calling the lock method twice on the same thread will lock up your thread permanently. Use the NSRecursiveLock class to implement recursive locks instead.
    
    func someMethod(completion: () -> Void) {
        lockMutex.lock()
        completion()
        defer {
            lockMutex.unlock()
        }
    }
}


let swiftSaveThread3 = CSaveThread3()
saveThread3.someMethod {
    print("This code will be runned in the mutex thread we created (Swift) (#3 Synchronization & Mutex)")
    array3.append("1 thread")
}

array3.append("2 thread")

// MARK: - #4 - NSRecursiveLock & Mutex Recursive lock

// Race condition - is an error in a multi-threaded system or application, in which the data or an object state depends on the order in which parts of the code are executed. Условия гонки с несколькими потоками при работе с одними данными, в результате чего сами данные становятся непредсказуемыми и зависят от порядка выполнения потоков.

// Resource contention - is a conflict over access to a shared resource such as random access memory, disk storage, cache memory, internal buses or external network devices. A resource experiencing ongoing contention can be described as oversubscribed. Несколько потоков, выполняющих разные задачи, пытаются получить доступ к одному ресурсу, тем самым увеличивая время, необходимое для безопасного получения ресурса. Эта задержка может привести к непредвиденному поведению.

// Deadlock - multiple threads are blocking each other

// Starvation - thread cannot access the resource and unsuccessfully tries to do this again and again.

// Priority Inversion - thread with low priority is holding resource which another thread with bigger priority needs

// Non-deterministic and Fairness - we can't do any assumptions when and in which order the thread can access the resource, this delay can't be determined and depends on the amount of conflicts. However, semaphores guarantee the fairness and access to all threads that wait, taking the order into account.


class RecursiveMutexTest4 {
    private var mutex = pthread_mutex_t()
    private var attribute = pthread_mutexattr_t()
    
    init() {
        pthread_mutexattr_init(&attribute)
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attribute)
    }
    
    func firstTask() {
        pthread_mutex_lock(&mutex)
        secondTask()
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
    
    private func secondTask() {
        pthread_mutex_lock(&mutex)
        print("Finish (C) (NSRecursiveLock & Mutex Recursive lock)")
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}

let recursiveC4 = RecursiveMutexTest4()
recursiveC4.firstTask()

let recursiveLock4 = NSRecursiveLock() // if we make it as NSLock() - there will be a Starvation

class RecursiveThread4: Thread {
    override func main() {
        recursiveLock4.lock()
        print("Thread acquired lock")
        callMe()
        defer {
            recursiveLock4.unlock()
        }
        print("Exit main\n")
    }
    
    func callMe() {
        recursiveLock4.lock()
        print("Thread acquired lock")
        defer {
            recursiveLock4.unlock()
        }
        print("Exit callMe")
    }
}

let thread4 = RecursiveThread4()
thread4.start()

// MARK: - #5 - NSCondition, NSLocking

//TOREAD - https://developer.apple.com/documentation/foundation/nscondition

// NSCondition - it's all about the order of threads.

var available5 = false
var condition5 = pthread_cond_t()
var mutex5 = pthread_mutex_t()

class ConditionMutexPrinter5: Thread {
    override init() {
        pthread_cond_init(&condition5, nil)
        pthread_mutex_init(&mutex5, nil)
    }
    
    override func main() {
        printerMethod()
    }
    
    private func printerMethod() {
        pthread_mutex_lock(&mutex5)
        print("Printer enter (C) - (NSCondition, NSLocking)")
        while (!available5) {
            pthread_cond_wait(&condition5, &mutex5) // waiting for signal
        }
        available5 = false
        defer {
            pthread_mutex_unlock(&mutex5)
        }
        print("Printer exit (C) - (NSCondition, NSLocking) \n")
    }
}

class ConditionMutexWriter5: Thread {
    override init() {
        pthread_cond_init(&condition5, nil)
        pthread_mutex_init(&mutex5, nil)
    }
    
    override func main() {
        writerMethod()
    }
    
    private func writerMethod() {
        pthread_mutex_lock(&mutex5)
        print("Writer enter (C) - (NSCondition, NSLocking)")
        pthread_cond_signal(&condition5) // producing signal
        available5 = true
        defer {
            pthread_mutex_unlock(&mutex5)
        }
        print("Writer exit (C) - (NSCondition, NSLocking)")
    }
}

let conditionMutexWriter5 = ConditionMutexWriter5()
let conditionMutexPrinter5 = ConditionMutexPrinter5()

conditionMutexPrinter5.start()
conditionMutexWriter5.start()


let cond5 = NSCondition()
var swiftAvailabel5 = false

class WriterThread5: Thread {
    override func main() {
        cond5.lock()
        print("Writer enter (Swift) - (NSCondition, NSLocking)")
        swiftAvailabel5 = true
        cond5.signal()
        cond5.unlock()
        print("Writer exit (Swift) - (NSCondition, NSLocking)")
    }
}

class PrinterThread5: Thread {
    override func main() {
        cond5.lock()
        print("Printer enter (Swift) - (NSCondition, NSLocking)")
        while !swiftAvailabel5 {
            cond5.wait()
        }
        swiftAvailabel5 = false
        cond5.unlock()
        print("Printer exit (Swift) - (NSCondition, NSLocking) \n")
    }
}

let conditionWriter5 = WriterThread5()
let conditionPrinter5 = PrinterThread5()

conditionPrinter5.start()
conditionWriter5.start()

// MARK: - #6 - ReadWriteLock, SpinLock, UnfairLock, Synchronized in Objc

class ReadWriteLock { // protect property, setter or(and) getter
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    private var globalProperty: Int = 0
    
    init() {
        pthread_rwlock_init(&lock, &attribute)
    }
    
    public var workProperty: Int {
        get {
            pthread_rwlock_wrlock(&lock)
            let temp = globalProperty
            pthread_rwlock_unlock(&lock)
            return temp
        }
        
        set {
            pthread_rwlock_wrlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
}

class SpinLock {
    private var lock = OS_SPINLOCK_INIT // deprecated in iOS 10
    
    func someFunction() {
        OSSpinLockLock(&lock)
        // run any block
        OSSpinLockUnlock(&lock)
    }
}

class UnfairLock {
    private var lock = os_unfair_lock_s() // instead of SpinLock
    
    var array = [Int]()
    
    func some() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)
    }
}


class SynchronizedObjc {
    private let lock = NSObject()
    
    var array = [Int]()
    
    func someMethod() {
        objc_sync_enter(lock)
        array.append(1)
        objc_sync_exit(lock)
    }
}

// MARK: - #7 - GCD, Concurrent queues, Serial queues,sync-async

//TOREAD: https://developer.apple.com/documentation/dispatch/dispatchqueue

// Queue is a pull of closures. We do not manage threads. We manage queues
// Queue types: Serial queue (последовательная очередь), Concurrent queue (параллельная очередь). Serial queue runs in a single thread, Concurrent queue runs in multiple threads.

class Queue1_7 {
    private let serialQueue = DispatchQueue(label: "Serial queue in lesson 7")
    private let concurrentQueue = DispatchQueue(label: "Concurrent queue in lesson 7", attributes: .concurrent)
}

class Queue2_7 {
    private let globalQueue = DispatchQueue.global() // there are only 5 of them: .userInteractive, .userInitiated, .utility, .background, .default
    private let mainQueue = DispatchQueue.main
}

// MARK: - #8 - GCD Practice + Bonus, Sync-Async

// Firstly we choose which queue we will work in: global or main. Secondly we should choose a priority(QoS). Lastly, we should choose, should it be sync or async.
// Do not use sync in main thread, it will cause a deadlock(взаимная блокировка)

/*
let queueLesson8 = DispatchQueue(label: "My custom Queue for lesson 8")
queueLesson8.async {
    print("Async operation in customQueue from lesson 8")
    queueLesson8.sync {
        print("Sync operation in customQueue from lesson 8. There should be a deadlock") // deadlock
    }
}

let otherQueueLesson8 = DispatchQueue(label: "Another custom Queue for lesson 8")
otherQueueLesson8.sync {
    print(Thread.isMainThread)
    DispatchQueue.main.sync {
        print("Sync operation in main queue from lesson 8. There should be a deadlock") // deadlock
    }
}
*/

import PlaygroundSupport

class Lesson8ViewController: UIViewController {
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UIViewController from lesson 8"
        view.backgroundColor = .white
        button.addTarget(self, action: #selector(pressAction), for: .touchUpInside)
        
    }
    
    @objc func pressAction() {
        let vc = Lesson8ViewController2()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initButton()
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("Press", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        view.addSubview(button)
    }
}

class Lesson8ViewController2: UIViewController {
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Second UIViewController from lesson 8"
        view.backgroundColor = .white
        loadPhoto() // async behaviour
        
//        let imageUrl = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
//        if let data = try? Data(contentsOf: imageUrl) { //syncronius behaviour, which is incorrect and freezes the UI
//            self.image.image = UIImage(data: data)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initImage()
    }
    
    func initImage() {
        image.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        image.center = view.center
        view.addSubview(image)
    }
    
    func loadPhoto() {
        let imageUrl = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let data = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
        }
    }
        
}

let lesson8vc = Lesson8ViewController()
let lesson8navigationBar = UINavigationController(rootViewController: lesson8vc)

PlaygroundPage.current.liveView = lesson8navigationBar
