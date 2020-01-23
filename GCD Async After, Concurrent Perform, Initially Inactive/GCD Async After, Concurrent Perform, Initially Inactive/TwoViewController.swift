//
//  TwoViewController.swift
//  GCD Async After, Concurrent Perform, Initially Inactive
//
//  Created by Administrator on 23.01.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class TwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //1. All in main thread
//        for i in 0...200000 { print(i) }
        
        //2. In several threads, including main
//        DispatchQueue.concurrentPerform(iterations: 200000) { print("\($0) times in thread \(Thread.current)") }
        
        //3.
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async {
//            DispatchQueue.concurrentPerform(iterations: 200000) { print("\($0) times in thread \(Thread.current)") }
//        }
        
        //4.
        myInactiveQueue()
    }
    
    func myInactiveQueue() {
        let inactiveQueue = DispatchQueue(label: "Inactive Queue", attributes: [.concurrent, .initiallyInactive])
        
        inactiveQueue.async {
            print("Done!")
        }
        print("Not started yet . . .")
        inactiveQueue.activate()
        print("Activated!")
        inactiveQueue.suspend()
        print("Pause!")
        inactiveQueue.resume()
    }
}
