import Foundation
import CoreData

class RoutineManager{
    
    var routines: [Routine] = []
    var coreDataContext: NSManagedObjectContext

    
    init(context: NSManagedObjectContext) {
        coreDataContext = context
        loadRoutine()
//        let defaultRoutine = Routine(context: coreDataContext)
//        defaultRoutine.name = "Default Routine"
//        // defaultRoutine.exercises
//        let defaultExercise = Exercise(context: context)
//        defaultExercise.name = "Default Exercise"
//        defaultExercise.bodypart = "Default Body Part"
//
//        let deaultSet = SingleSet(context: context)
//        deaultSet.previous = "0.0 x 0"
//        deaultSet.parentExercise = defaultExercise
//        deaultSet.reps = 0
//        deaultSet.weight = 0.0
//        deaultSet.done = false
//
//        defaultExercise.addToSets(deaultSet)
//        defaultRoutine.addToExercises(defaultExercise)
//
//        routines.append(defaultRoutine)
        
    }
    
    func getRoutineCount() -> Int{
        return routines.count
    }
    
    func addRoutine(with newRoutine: Routine) {
        routines.append(newRoutine)
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
