import CoreData

extension Person {
    
    public convenience init(context: NSManagedObjectContext, name: String) {
        self.init(context: context)
        self.name = name
    }
    
}
