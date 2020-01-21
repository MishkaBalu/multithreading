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
