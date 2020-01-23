import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//MARK: - #10 - GCD DispatchWorkItem, Notify

// Главное отличие NSOperation от GCD в том, что NSOperation умеет отменять таски во время их выполнения. GCD так не умеет.

class DispatchWorkItem1 {
    private let queue = DispatchQueue(label: "DispatchWorkItem1", attributes: .concurrent)
    
    func create() {
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Start task!")
        }
        
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("Task finished\n")
        }
        
        queue.async(execute: workItem)
    }
}

let dispatchWorkItem1 = DispatchWorkItem1()
dispatchWorkItem1.create()

class DispatchWorkItem2 {
    private let queue = DispatchQueue(label: "DispatchWorkItem2")
    
    func create() {
        queue.async {
            sleep(1)
            print(Thread.current)
            print("Task 1")
        }
        
        queue.async {
            sleep(1)
            print(Thread.current)
            print("Task 2")
        }
        
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Start of work item task 3")
        }
        
        queue.async(execute: workItem)
        
//        workItem.cancel() //will not cancel the operation if it has already started
    }
}

let dispatchWorkItem2 = DispatchWorkItem2()
dispatchWorkItem2.create()

//

let imageURL = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!

var view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
var eiffelImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

eiffelImage.backgroundColor = .yellow
eiffelImage.contentMode = .scaleAspectFit

view.addSubview(eiffelImage)

PlaygroundPage.current.liveView = view

//MARK: - Classic image fetching
func fetchImage() {
    let queue = DispatchQueue.global(qos: .utility)
    queue.async {
        if let data = try? Data(contentsOf: imageURL) {
            DispatchQueue.main.async {
                eiffelImage.image = UIImage(data: data)
            }
        }
    }
}

//fetchImage() // uncomment to run this function

//MARK: - Dispatch work item

func fetchImage2() {
    var data: Data?
    let queue = DispatchQueue.global(qos: .utility)
    
    let workItem = DispatchWorkItem(qos: .userInteractive) {
        data = try? Data(contentsOf: imageURL)
        print("Current thread is: \(Thread.current)")
    }
    
    queue.async(execute: workItem)
    
    workItem.notify(queue: .main) {
        print("Current thread is main: \(Thread.isMainThread)")
        if let imageData = data {
            eiffelImage.image = UIImage(data: imageData)
        }
    }
}

//fetchImage2() // does the same that fetchImage() but in a different way. uncomment to run this function


//MARK: - URLSession

func fetchImage3() {
    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
        print("Current thread is: \(Thread.current)")
        
        if let imageData = data {
            DispatchQueue.main.async {
                print("Current thread is main: \(Thread.isMainThread)")
                eiffelImage.image = UIImage(data: imageData)
            }
        }
    }
    task.resume()
}

fetchImage3()
