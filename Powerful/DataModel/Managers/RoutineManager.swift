import Foundation
import CoreData

class RoutineManager{
    
    var routines: [Routine] = []
    var coreDataContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        coreDataContext = context
        loadRoutine()
    }
    
    func getRoutineCount() -> Int{
        return routines.count
    }
    
    func addRoutine(with newRoutine: Routine) {
        routines.append(newRoutine)
        saveRoutine()
    }
    
    func deleteRoutine(with targetRoutineIndex: Int){
        coreDataContext.delete(routines[targetRoutineIndex])
        routines.remove(at: targetRoutineIndex)
        saveRoutine()
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveRoutine() {
        do {
            try coreDataContext.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // tableView.reloadData()
        
    }
    
    func loadRoutine() {
        let request : NSFetchRequest<Routine> = Routine.fetchRequest()
        do{
            routines = try coreDataContext.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        // tableView.reloadData()
    }
    
}
