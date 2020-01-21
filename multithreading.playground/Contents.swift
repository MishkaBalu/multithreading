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

var thread = pthread_t(bitPattern: 0) //create C thread
var attribute = pthread_attr_t() // create C attribute
pthread_attr_init(&attribute)

pthread_create(&thread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
    print("This code will be runned in the thread we created (C) (#1 - Thread & Pthread)")
    return nil
}, nil)

//iOS

var nsthread = Thread {
    print("This code will be runned in the thread we created (Swift) (#1 - Thread & Pthread)")
}
nsthread.start()
