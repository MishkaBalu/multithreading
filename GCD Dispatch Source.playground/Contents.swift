import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//MARK: - #14 - GCD Dispatch Source

//TOREAD: https://developer.apple.com/documentation/dispatch/dispatchsource

//DispatchSource - is an object that coordinates the processing of specific low-level system events, such as file-system events, timers, and UNIX signals. E.g. for managing socket connection

let timer = DispatchSource.makeTimerSource(queue: .global())
timer.setEventHandler {
    print("❕")
}

timer.schedule(deadline: .now(), repeating: 5)
timer.activate()

