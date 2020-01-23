//
//  ViewController.swift
//  GCD Async After, Concurrent Perform, Initially Inactive
//
//  Created by Administrator on 23.01.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        afterBlock(seconds: 2, queue: .global()) {
            print("Hello!")
            print(Thread.current)
        }
        
        afterBlock(seconds: 2, queue: .main) {
            print("\nHello!")
            self.showAlert()
            print(Thread.current)
        }
    }
    
    private func afterBlock(seconds: Int, queue: DispatchQueue = DispatchQueue.global(), completion: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            completion()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "ALERT", message: "Hello! This is alert", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
