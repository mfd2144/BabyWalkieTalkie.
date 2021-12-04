import Cocoa
var stringLogic = true
var greeting = "Helldf56oplayground"
greeting.forEach({
    if !$0.isCased && !$0.isNumber{
        print(type(of: $0))
        print($0.isCased)
        print($0.isNumber)
        stringLogic = false}
    
})
print(stringLogic)
