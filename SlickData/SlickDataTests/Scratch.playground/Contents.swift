//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let x : Void? = ()

if x != nil{
    print("yay!")
}

func baz(x: Int) throws ->Int{
    if x > 0{
        return x.successor()
    }else{
        throw NSError(domain: "", code: 42, userInfo: nil)
    }
}



try? baz(8)
