import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//MARK: - #12 - GCD Dispatch Group

class DispatchGroupTest1 {
    private let queueSerial = DispatchQueue(label: "Custom thread for Dispatch Group")
    
    private let redGroup = DispatchGroup()
    
    func loadInfo() {
        queueSerial.async(group: redGroup) {
            sleep(1)
            print("1")
        }
        
        queueSerial.async(group: redGroup) {
            sleep(1)
            print("2")
        }
        
        redGroup.notify(queue: .main) {
            print("redGroup finished it's work and passed in thread: \(Thread.current)")
        }
    }
}

let dispatchGroupTest1 = DispatchGroupTest1()
dispatchGroupTest1.loadInfo()

class DispatchGroupTest2 {
    private let queueSerial = DispatchQueue(label: "Custom thread for Dispatch Group", attributes: .concurrent)
    
    private let blackGroup = DispatchGroup()
    
    func loadInfo() {
        blackGroup.enter()
        queueSerial.async {
            sleep(5)
            print("This is FIRST block in DispatchGroup in a concurrent queue")
            self.blackGroup.leave()
        }
        
        blackGroup.enter()
        queueSerial.async {
            sleep(6)
            print("This is SECOND block in DispatchGroup in a concurrent queue")
            self.blackGroup.leave()
        }
        
        blackGroup.wait() // we are not going further untill we don't run all the functions in DispatchGroup
        blackGroup.notify(queue: .main) {
            print("blackGroup finished it's work and passed in thread: \(Thread.current)")
        }
        print("Finish all")
    }
}

let dispatchGroupTest2 = DispatchGroupTest2()
dispatchGroupTest2.loadInfo()

class EightImages: UIView {
    public var ivs = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 300, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 400, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 300, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100)))
        
        ivs.forEach { (image) in
            image.contentMode = .scaleAspectFit
            self.addSubview(image)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var view = EightImages(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
view.backgroundColor = .red

PlaygroundPage.current.liveView = view

let imageURLs = ["https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png", "http://www.picture-newsletter.com/arctic/arctic-12.jpg" ]

var images = [UIImage]()

func asyncLoadImage(imageURL: URL, runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (UIImage?, Error?) -> Void) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async {
                completion(UIImage(data: data), nil)
            }
        } catch let error {
            completionQueue.async {
                completion(nil, error)
            }
        }
    }
}

func asyncGroup() {
    let dispatchGroup = DispatchGroup()
    
    for i in 0...3 {
        dispatchGroup.enter()
        asyncLoadImage(imageURL: URL(string: imageURLs[i])!,
                       runQueue: .global(),
                       completionQueue: .main) { (image, error) in
                        guard let image = image else { return }
                        images.append(image)
                        dispatchGroup.leave()
        }
    }
    
    dispatchGroup.notify(queue: .main) {
        for i in 0...3 {
            view.ivs[i].image = images[i]
        }
    }
}

func asyncUrlSession() {
    for i in 4...7 {
        let url = URL(string: imageURLs[i - 4])
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                view.ivs[i].image = UIImage(data: data!)
            }
        }
        
        task.resume()
    }
}

asyncGroup()
asyncUrlSession()
