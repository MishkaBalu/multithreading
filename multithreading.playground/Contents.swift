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

// MARK: - #2 Quality of Service(QoS)/Priorities

//TOREAD - https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html

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

// MARK: - Synchronization & Mutex

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
    private let lockMutex = NSLock()
    
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

