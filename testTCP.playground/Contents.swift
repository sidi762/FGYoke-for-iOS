//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var client:TCPClient = TCPClient(addr: "10.0.8.201", port: 12345)
var (success, errmsg) = client.connect(timeout: 1)
if success {
    print("success")
} else {
    print(errmsg)
    
}

