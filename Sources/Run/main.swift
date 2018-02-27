import App
import Service
import Vapor

var config = Config.default()
var env = try Environment.detect()
var services = Services.default()

try App.configure(&config, &env, &services)

let app = try Application(
    config: config,
    environment: env,
    services: services
)

try App.boot(app)

try app.run()
//

//import Foundation
//import Async
//import Redis
//let worker = try KqueueEventLoop(label: "redis")
//
//let client = try! RedisClient.connect(hostname: "127.0.0.1", port: 6379, on: worker) { _, error in
//    print("[Redis] \(error)")
//}


//Thread.async {
//
////14.9143859148026
//    let date = Date()
//    var count = 0
//    for _ in (1...100_000) {
//
//        client.command("PING").do { _ in
//            count += 1
//            if count == 100_000 {
//                let difference = Date().timeIntervalSince(date)
//                print(difference)
//            }
//            }.catch({ (er) in
//                count += 1
//            })
//    }
//
//
//    worker.runLoop()
//}



//RunLoop.main.run()

