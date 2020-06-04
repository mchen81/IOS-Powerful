import Foundation
import CoreData

struct RoutineManager{
    
    var routines: [Routine] = []
    var coreDataContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        coreDataContext = context
        let defaultRoutine = Routine(context: coreDataContext)
        routines.append(defaultRoutine)
    }
    
    func getRoutineCount() -> Int{
        return routines.count
    }
    
    mutating func addRoutine(with newRoutine: Routine) -> Bool {
        routines.append(newRoutine)
        return true
    }
    
    
    mutating func saveContext(){
        
    }
    
    mutating func loadContext(){
        
    }
    
}
