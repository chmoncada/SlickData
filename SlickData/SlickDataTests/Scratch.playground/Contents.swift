import CoreData


class Thing {
    typealias Handler = (context: Int)->Void
    
    func perform(closure: Handler){
        closure(context: 42)
    }
    
}